;;; Code written by Oleg Kiselyov
;; (http://pobox.com/~oleg/ftp/)
;;;
;;; Taken from leanTAP.scm
;;; http://kanren.cvs.sourceforge.net/kanren/kanren/mini/leanTAP.scm?view=log

; A simple linear pattern matcher
; It is efficient (generates code at macro-expansion time) and simple:
; it should work on any R5RS Scheme system.

; (cmatch exp <clause> ...[<else-clause>])
; <clause> ::= (<pattern> <guard|guard-with> exp ...)
; <else-clause> ::= (else exp ...)
; <guard> ::= boolean exp | ()
; <guard-with> ::= <symbol> [boolean exp]* | ()
; <pattern> :: =
;        ,var  -- matches always and binds the var
;                 pattern must be linear! No check is done
;        'exp  -- comparison with variable bound to exp (using equal?)
;        exp   -- comparison with exp (using equal?)
;        (<pattern1> <pattern2> ...) -- matches the list of patterns
;        (<pattern1> . <pattern2>)  -- ditto
;        ()    -- matches the empty list

; Modified by Adam C. Foltzer for R6RS compatibility
; Modified by Cameron Swords to:
; - remove all the thunks: ain't nobody got time for extra evaluation!
; - provide quote support. We can match on bound variables now!
; - add guard-with at Jason Hemann's request.

(define-syntax cmatch
  (syntax-rules (else guard guard-with)
    ((_ (rator rand ...) cs ...)
      (let ((v (rator rand ...)))
       (cmatch v cs ...)))
    ((_ v) (error 'cmatch "failed: ~s" v))
    ((_ v (else e0 e ...)) (begin e0 e ...))
    ((_ v (pat (guard g ...) e0 e ...) cs ...)
     (cpat v pat 
       (if (and g ...) (begin e0 e ...) (cmatch v cs ...)) 
       (cmatch v cs ...)))
    ((_ v (pat (guard-with x g ...) e0 e ...) cs ...)
     (cpat v pat 
       (let ((x (and g ...))) (if x (begin e0 e ...) (cmatch v cs ...))) 
       (cmatch v cs ...)))
    ((_ v (pat e0 e ...) cs ...)
     (cpat v pat (begin e0 e ...) (cmatch v cs ...)))))

(define-syntax cpat
  (syntax-rules (unquote quote)
    ((_ v (quote a) kt kf) (if (equal? v a) kt kf))
    ((_ v () kt kf) (if (null? v) kt kf))
    ((_ v (unquote var) kt kf) (let ((var v)) kt))
    ((_ v (x . y) kt kf)
     (if (pair? v)
       (let ((vx (car v)) (vy (cdr v)))
 	      (cpat vx x (cpat vy y kt kf) kf))
       kf))
    ((_ v lit kt kf) (if (equal? v (quote lit)) kt kf)))
  )

(print-gensym 'pretty/suffix)

(print-gensym 'pretty/suffix)
