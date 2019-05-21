(library (dollar-sign)
  (export $)
  (import (rnrs))

  (define-syntax $
    (lambda (x)
      (syntax-case x ()
        [(k str) (string? (syntax->datum #'str))
         (let-values ([(in) (open-string-input-port (syntax->datum #'str))]
                      [(out get) (open-string-output-port)])

           (define (parse-string char)
             (cond
               [(eof-object? char) (list (get))]
               [(not (char=? char #\$))
                (put-char out char)
                (parse-string (get-char in))]
               [(char=? (peek-char in) #\$)
                (put-char out (get-char in))
                (parse-string (get-char in))]
               [else (let* ([s (get)]
                            [expr (read in)]
                            [expr^ (cond
                                     [(not (pair? expr)) expr]
                                     [(null? (cdr expr)) (car expr)]
                                     [else expr])])
                       (cons* s (datum->syntax #'k expr^)
                         (parse-string (get-char in))))]))

           (with-syntax ([(exprs ...) (parse-string (get-char in))])
             #'(let-values ([(out get) (open-string-output-port)])
                 (display exprs out) ...
                 (get))))])))
)
