(library (dollar-sign)
  (export $)
  (import (rnrs))

  (define-syntax $
    (lambda (x)
      (syntax-case x ()
        [(k str) (string? (syntax->datum #'str))
         (let-values ([(in) (open-string-input-port (syntax->datum #'str))]
                      [(out get) (open-string-output-port)])

           (define (print-with func dat)
             (lambda (p)
                 #`(#,func #,dat #,p)))

           (define (ch=? a b c)
             (and (eqv? a b) (eqv? b c)))

           (define (parse-string char)
             (cond
               [(eof-object? char) (list (print-with #'display (get)))]
               [(let ([next (peek-char in)])
                  (or (ch=? char next #\$)
                      (ch=? char next #\#)))
                (put-char out (get-char in))
                (parse-string (get-char in))]
               [(char=? char #\$) (gen-output #'display)]
               [(char=? char #\#) (gen-output #'write)]
               [else
                (put-char out char)
                (parse-string (get-char in))]))

           (define (gen-output func)
             (let* ([s (get)]
                    [expr (read in)]
                    [expr (cond
                            [(not (pair? expr)) expr]
                            [(null? (cdr expr)) (car expr)]
                            [else expr])]
                    [expr (datum->syntax #'k expr)])
               (cond
                 [(string=? s "") (cons (print-with func expr)
                                    (parse-string (get-char in)))]
                 [else (cons* (print-with #'display s)
                         (print-with func expr)
                         (parse-string (get-char in)))])))

         (let ([funcs (parse-string (get-char in))])
           #`(call-with-values open-string-output-port
               (lambda (out get)
                 #,@(map (lambda (f)
                           (f #'out))
                      funcs)
                 (get)))))])))
)
