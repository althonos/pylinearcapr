

cdef extern from "energy_model.hpp" namespace "energy" nogil:

    enum class Model:
        Turner1999
        Turner2004

    # struct Params:
    #     double temperature
    #     double gas_constant
    #     double k0
    #     double kT
    #     double lxc37
    #     int ML_intern37
    #     int ML_closing37
    #     int ML_BASE37
    #     int MAX_NINIO
    #     int ninio37;
    #     int TerminalAU37;
    #     # const int (*stack37)[NBPAIRS+1];
    #     # const int *hairpin37;
    #     # const int *bulge37;
    #     # const int *internal_loop37;
    #     # const int (*mismatchI37)[5][5];
    #     # const int (*mismatch1nI37)[5][5];
    #     # const int (*mismatch23I37)[5][5];
    #     # const int (*mismatchH37)[5][5];
    #     # const int (*mismatchM37)[5][5];
    #     # const int (*mismatchExt37)[5][5];
    #     # const int (*dangle5_37)[5];
    #     # const int (*dangle3_37)[5];
    #     const Int11Array *int11_37
    #     const Int21Array *int21_37
    #     const Int22Array *int22_37
    #     const char *Triloops
    #     const int *Triloop37
    #     const char *Tetraloops
    #     const int *Tetraloop37
    #     const char *Hexaloops
    #     const int *Hexaloop37
    #     bool has_special_hairpins
    #     bool allow_mismatch_multi
    #     bool allow_mismatch_external
    #     bool use_fast_logsumexp