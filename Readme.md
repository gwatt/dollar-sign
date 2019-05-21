
## Dollar Sign

Add string interpolation to your R6RS scheme code with the familiar '$'

Examples:
```scala
(import (dollar-sign))

; simple case
(let ((a 1)
      (b 2)
      (c 3))
  ($"$a + $b + $c = $(+ a b c)")) => "1 + 2 + 3 = 6"

; if you want no spaces between your variable and another non-space non-parenthetical,
; wrap your variable with parentheses
(let ((a 1)
      (b 2)
      (c 3))
  ($"$(a)$(b)$(c)")) => "123"

; Dollar signs are valid parts of identifiers
(let ((a 1)
      (b 2)
      (c 3))
  ($"$a$b$c")) => error, no identifier a$b$c

; function calls:
; zero argument functions need two sets of parentheses around the interpolation
; functions with one or more arguments do not need the extra set of parentheses
(define (two) 2)
($"$((two))") => "2"
($"$(+ 1 2 3 4)") => 10
```
