from libcpp.vector cimport vector
from libcpp.string cimport string

from linearcapr.miscs cimport Float, NPROBS
from linearcapr.energy_model cimport Model

cdef extern from "LinCapR.hpp" nogil:

    cppclass LinCapR:
        LinCapR(int beam_size)
        LinCapR(int beam_size, Model model)

        void run(const string&) except +
        Float get_energy_ensemble()

        vector[Float] prob_B
        vector[Float] prob_I
        vector[Float] prob_H
        vector[Float] prob_M
        vector[Float] prob_E
        vector[Float] prob_S
        vector[Float]* probs[NPROBS]