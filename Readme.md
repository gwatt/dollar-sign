
## Dollar Sign

Add string interpolation to your R6RS scheme code with the familiar '$'

Examples:
```scheme
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
; functions that take arguments can be called either way:
($"$(+ 1 2 3 4)") => "10"
($"$((+ 1 2 3 4))") => "10"

; literal dollar signs in your string:
; put two dollar signs in a row
($"$$") => "$"
(let ((dollars 10)
      (cents 99))
  ($"$$$(dollars).$(cents)")) => "$10.99"
```
