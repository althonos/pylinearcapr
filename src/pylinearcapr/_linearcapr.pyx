from cpython cimport Py_buffer
from cpython.memoryview cimport PyMemoryView_FromMemory
from cpython.buffer cimport PyBUF_FORMAT, PyBUF_READ

from libc.string cimport memcpy
from libc.stdlib cimport calloc, realloc, free
from libcpp cimport bool
from libcpp.memory cimport unique_ptr
from libcpp.string cimport string

from linearcapr cimport LinCapR
from linearcapr.miscs cimport NPROBS, Float


__version__ = PROJECT_VERSION


cdef class ProfileMatrix:

    cdef size_t     seq_n
    cdef Float*     mat
    cdef Py_ssize_t _shape[2]

    def __init__(self, size_t seq_n):
        self.seq_n = seq_n
        self._shape[0] = NPROBS
        self._shape[1] = seq_n

        cdef size_t mat_size = max(seq_n, 1) * NPROBS
        if self.mat != NULL:
            free(self.mat)
        self.mat = <Float*> calloc(mat_size, sizeof(Float))
        if self.mat is NULL:
            raise MemoryError("failed to allocate matrix data")

    def __dealloc__(self):
        free(self.mat)
        self.mat = NULL

    def __getbuffer__(self, Py_buffer* buffer, int flags):
        if flags & PyBUF_FORMAT:
            buffer.format = b"d" if sizeof(Float) == 8 else b"f"
        else:
            buffer.format = NULL
        buffer.buf = <void*> self.mat
        buffer.internal = NULL
        buffer.itemsize = sizeof(Float)
        buffer.len = NPROBS * self.seq_n * sizeof(Float) 
        buffer.ndim = 2
        buffer.obj = self
        buffer.readonly = 1
        buffer.shape = self._shape
        buffer.suboffsets = NULL
        buffer.strides = NULL

    def __len__(self):
        return NPROBS

    def __getitem__(self, object index):
        cdef ssize_t index_
        if isinstance(index, tuple):
            raise NotImplementedError
        else:
            index_ = index
            if index_ < 0:
                index_ += <ssize_t> NPROBS
            if index_ < 0 or index_ >= NPROBS:
                raise IndexError(index)
            return self.vec[<size_t> index_]


cdef class ProfileVector:

    cdef Float*     vec
    cdef Py_ssize_t _shape[1]
    cdef object     _owner
    cdef bool       _owned

    def __init__(self, size_t seq_n):
        self.seq_n = seq_n
        self._shape[0] = seq_n

    def __dealloc__(self):
        if not self._owned:
            free(self.vec)
            self.vec = NULL

    def __len__(self):
        return self.seq_n

    def __getitem__(self, ssize_t index):
        cdef ssize_t index_ = index
        if index_ < 0:
            index_ += <ssize_t> self.seq_n
        if index_ < 0 or index_ >= self.seq_n:
            raise IndexError(index)
        return self.vec[<size_t> index_]

    def __getbuffer__(self, Py_buffer* buffer, int flags):
        if flags & PyBUF_FORMAT:
            buffer.format = b"d" if sizeof(Float) == 8 else b"f"
        else:
            buffer.format = NULL
        buffer.buf = <void*> self.vec
        buffer.internal = NULL
        buffer.itemsize = sizeof(Float)
        buffer.len = self.seq_n * sizeof(Float) 
        buffer.ndim = 1
        buffer.obj = self
        buffer.readonly = 1
        buffer.shape = self._shape
        buffer.suboffsets = NULL
        buffer.strides = NULL


cdef class Profile:

    cdef readonly Float         free_energy
    cdef readonly ProfileMatrix matrix


cdef class StructuralProfiler:
    
    cdef readonly int beam_size

    def __init__(self, int beam_size, str model not None = "turner2004"):
        self.beam_size = beam_size

    def profile(self, str sequence not None) -> Profile:
        cdef size_t              i
        cdef string              s        = sequence.encode('ascii') # TODO: transparent extraction
        cdef size_t              seq_n    = s.size()
        cdef Profile             profile  = Profile.__new__(Profile)
        cdef unique_ptr[LinCapR] profiler = unique_ptr[LinCapR](new LinCapR(self.beam_size))

        profile.matrix = ProfileMatrix( seq_n )
        with nogil:
            profiler.get().run(s)
            profile.free_energy = profiler.get().get_energy_ensemble()
            for i in range(NPROBS):
                memcpy(
                    &profile.matrix.mat[i * seq_n],
                    profiler.get().probs[i].data(), 
                    seq_n * sizeof(Float)
                )
        return profile