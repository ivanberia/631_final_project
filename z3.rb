require 'ffi'

module Z3
    extend FFI::Library
    ffi_lib "/usr/lib/libz3.so"

    #Misc
    attach_function :Z3_get_version,[:pointer,:pointer,:pointer,:pointer],:void
    attach_function :Z3_reset_memory,[],:void

    #Configuration
    attach_function :Z3_mk_config,[],:pointer
    attach_function :Z3_del_config,[:pointer],:void
    attach_function :Z3_set_param_value,[:pointer,:string,:string],:void

    #Context
    attach_function :Z3_mk_context,[:pointer],:pointer
    attach_function :Z3_del_context,[:pointer],:void
    attach_function :Z3_update_param_value,[:pointer,:string,:string],:void
    attach_function :Z3_get_param_value,[:pointer,:string,:pointer],:int
    attach_function :Z3_interrupt,[:pointer],:void

    #Parameters and Parameter Descriptions not implemented

    #Symbols
    attach_function :Z3_mk_int_symbol,[:pointer,:int],:pointer
    attach_function :Z3_mk_string_symbol,[:pointer,:string],:pointer

    #Sorts
    attach_function :Z3_mk_uninterpreted_sort,[:pointer,:pointer],:pointer
    attach_function :Z3_mk_bool_sort,[:pointer],:pointer
    attach_function :Z3_mk_int_sort,[:pointer],:pointer
    attach_function :Z3_mk_real_sort,[:pointer],:pointer
    attach_function :Z3_mk_bv_sort,[:pointer,:int],:pointer
    attach_function :Z3_mk_finite_domain_sort,[:pointer,:pointer,:int],:pointer
    attach_function :Z3_mk_array_sort,[:pointer,:pointer,:pointer],:pointer
    #Some sorts not implemented

    #Constants
    attach_function :Z3_mk_func_decl,
                    [:pointer,:pointer,:int,:pointer,:pointer],:pointer
    attach_function :Z3_mk_app,[:pointer,:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_const,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_fresh_func_decl,
                    [:pointer,:string,:int,:pointer,:pointer],:pointer
    attach_function :Z3_mk_fresh_const,[:pointer,:string,:pointer],:pointer

    #Logic
    attach_function :Z3_mk_true,[:pointer],:pointer
    attach_function :Z3_mk_false,[:pointer],:pointer
    attach_function :Z3_mk_eq,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_distinct,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_not,[:pointer,:pointer],:pointer
    attach_function :Z3_mk_ite,[:pointer,:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_iff,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_implies,[:pointer,:pointer],:pointer
    attach_function :Z3_mk_xor,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_and,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_or,[:pointer,:int,:pointer],:pointer

    #Arithmetic
    attach_function :Z3_mk_add,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_mul,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_sub,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_unary_minus,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_div,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_mod,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_rem,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_power,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_lt,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_le,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_gt,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_ge,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_int2real,[:pointer,:pointer],:pointer
    attach_function :Z3_mk_real2int,[:pointer,:pointer],:pointer
    attach_function :Z3_mk_is_int,[:pointer,:pointer],:pointer

    #Bit-vectors
    attach_function :Z3_mk_bvnot,[:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvredand,[:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvredor,[:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvand,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvor,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvxor,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvnand,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvnor,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvxnor,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvneg,[:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvadd,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvsub,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvmul,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvudiv,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvsdiv,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvurem,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvsrem,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvsmod,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvult,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvslt,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvule,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvsle,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvuge,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvsge,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvugt,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvsgt,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_concat,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_extract,[:pointer,:int,:int,:pointer],:pointer
    attach_function :Z3_mk_sign_ext,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_zero_ext,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_repeat,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_bvshl,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvlshr,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvashr,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_rotate_left,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_ext_rotate_left,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_ext_rotate_right,
                    [:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_int2bv,[:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_bv2int,[:pointer,:pointer,:int],:pointer
    attach_function :Z3_mk_bvadd_no_overflow,
                    [:pointer,:pointer,:pointer,:int],:pointer
    attach_function :Z3_mk_bvadd_no_underflow,
                    [:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvsub_no_overflow,
                    [:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvsub_no_underflow,
                    [:pointer,:pointer,:pointer,:int],:pointer
    attach_function :Z3_mk_bvsdiv_no_overflow,
                    [:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvneg_no_overflow,
                    [:pointer,:pointer],:pointer
    attach_function :Z3_mk_bvmul_no_overflow,
                    [:pointer,:pointer,:pointer,:int],:pointer
    attach_function :Z3_mk_bvmul_no_underflow,
                    [:pointer,:pointer,:pointer],:pointer

    #Arrays
    attach_function :Z3_mk_select,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_store,[:pointer,:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_const_array,[:pointer,:pointer,:pointer],:pointer
    attach_function :Z3_mk_map,[:pointer,:pointer,:int,:pointer],:pointer
    attach_function :Z3_mk_array_default,[:pointer,:pointer,:pointer],:pointer

    #Solvers
    attach_function :Z3_mk_solver,[:pointer],:pointer
    attach_function :Z3_mk_simple_solver,[:pointer],:pointer
    attach_function :Z3_mk_solver_for_logic,[:pointer,:pointer],:pointer
    attach_function :Z3_mk_solver_from_tactic,[:pointer,:pointer],:pointer
    attach_function :Z3_solver_get_help,[:pointer,:pointer],:pointer
    attach_function :Z3_solver_get_param_descrs,[:pointer,:pointer],:pointer
    attach_function :Z3_solver_set_params,[:pointer,:pointer,:pointer],:void
    attach_function :Z3_solver_inc_ref,[:pointer,:pointer],:void
    attach_function :Z3_solver_dec_ref,[:pointer,:pointer],:void
    attach_function :Z3_solver_push,[:pointer,:pointer],:void
    attach_function :Z3_solver_pop,[:pointer,:pointer,:int],:void
    attach_function :Z3_solver_reset,[:pointer,:pointer],:void
    attach_function :Z3_solver_get_num_scopes,[:pointer,:pointer],:int
    attach_function :Z3_solver_assert,[:pointer,:pointer,:pointer],:void
    attach_function :Z3_solver_assert_and_track,
                    [:pointer,:pointer,:pointer,:pointer],:void
    attach_function :Z3_solver_get_assertions,[:pointer,:pointer],:pointer
    attach_function :Z3_solver_check,[:pointer,:pointer],:int
    attach_function :Z3_solver_check_assumptions,
                    [:pointer,:pointer,:int,:pointer],:int
    attach_function :Z3_solver_get_model,[:pointer,:pointer],:pointer
    attach_function :Z3_solver_get_proof,[:pointer,:pointer],:pointer
    attach_function :Z3_solver_get_unsat_core,[:pointer,:pointer],:pointer
    attach_function :Z3_solver_get_reason_unknown,[:pointer,:pointer],:string
    attach_function :Z3_solver_get_statistics,[:pointer,:pointer],:pointer
    attach_function :Z3_solver_to_string,[:pointer,:pointer],:string

    #Logging functions
    attach_function :Z3_open_log,[:string],:int
    attach_function :Z3_append_log,[:string],:void
    attach_function :Z3_close_log,[],:void

    #Debugging
    attach_function :Z3_context_to_string,[:pointer],:string
end

