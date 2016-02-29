#lang racket/base
(require ffi/unsafe
         ffi/unsafe/alloc
         ffi/unsafe/define
	 racket/class)

(provide cassowary% cassowary-variable%)

(define-ffi-definer define-rhea (ffi-lib "librhea"))

(define _solver-ptr (_cpointer 'solver))
(define _expression-ptr (_cpointer 'expression))
(define _constraint-ptr (_cpointer 'expression))
(define _strength-ptr (_cpointer 'expression))

;; solver
(define cassowary%
  (class* object%
	  (super-new)
	  (init-field llsolver
		      [(solver_new)])

	  (define/public (begin-edit) (solver_begin_edit llsolver))

	  (define/public (end-edit) (solver_end_edit llsolver))

	  (define/public (add-edit-var v) (solver_add_edit_var llsolver v))

	  (define/public (add-constraint c)
	    (solver_add_constraint llsolver c))

	  (define/public (solve) (eq? (solver_solve llsolver) 0))

	  (define/public (resolve) (eq? (solver_resolve llsolver) 0))))

(define-rhea solver_delete (_fun _solver-ptr -> _void) #:wrap (deallocator))
(define-rhea solver_new (_fun -> _solver-ptr) #:wrap (allocator solver_delete))
(define-rhea solver_add_constraint (_fun _solver-ptr _constraint-ptr -> _void))
(define-rhea solver_suggest (_fun _solver-ptr _expression-ptr _double -> _int))
(define-rhea solver_add_edit_var (_fun _solver-ptr _expression-ptr -> _void))
(define-rhea solver_begin_edit (_fun _solver-ptr -> _void))
(define-rhea solver_edit_value (_fun _solver-ptr _expression-ptr _double -> _void))
(define-rhea solver_resolve (_fun _solver-ptr -> _int))
(define-rhea solver_end_edit (_fun _solver-ptr -> _void))
(define-rhea solver_solve (_fun _solver-ptr -> _int))

;; variables
(define-rhea variable_new (_fun _double -> _expression-ptr))
(define-rhea variable_stay (_fun _expression-ptr -> _constraint-ptr))
(define-rhea expression_value (_fun _expression-ptr -> _double))

;; variable and expression operations
(define-rhea expression_plus (_fun _expression-ptr _expression-ptr -> _expression-ptr))
(define-rhea expression_plus_double (_fun _expression-ptr _double -> _expression-ptr))
(define-rhea expression_minus (_fun _expression-ptr _expression-ptr -> _expression-ptr))
(define-rhea expression_minus_double (_fun _expression-ptr _double -> _expression-ptr))
(define-rhea expression_times (_fun _expression-ptr _expression-ptr -> _expression-ptr))
(define-rhea expression_times_double (_fun _expression-ptr _double -> _expression-ptr))
(define-rhea expression_divide (_fun _expression-ptr _expression-ptr -> _expression-ptr))
(define-rhea expression_divide_double (_fun _expression-ptr _double -> _expression-ptr))
(define-rhea expression_leq (_fun _expression-ptr _expression-ptr -> _expression-ptr))
(define-rhea expression_leq_double (_fun _expression-ptr _double -> _expression-ptr))
(define-rhea expression_geq (_fun _expression-ptr _expression-ptr -> _expression-ptr))
(define-rhea expression_geq_double (_fun _expression-ptr _double -> _expression-ptr))
(define-rhea expression_equals (_fun _expression-ptr _expression-ptr -> _expression-ptr))
(define-rhea expression_equals_double (_fun _expression-ptr _double -> _expression-ptr))

;; constraints
(define-rhea constriant_change_strength (_fun _constraint-ptr _strength-ptr -> _void))

;; strengths
(define-rhea strength_required (_fun -> _strength-ptr))
(define-rhea strength_strong (_fun -> _strength-ptr))
(define-rhea strength_medium (_fun -> _strength-ptr))
(define-rhea strength_weak (_fun -> _strength-ptr))

