;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |12.3 Ex211|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; A Word is one of:
; – '() or
; – (cons 1String Word)
; interpretation a Word is a list of 1Strings (letters)
 
; A List-of-words is one of:
; - '()
; - (cons Word List-of-words)
; interpretation: a list of words
 
; Word -> List-of-words
; finds all rearrangements of word
(define (arrangements word)
  (list word))

; ----Exercise 209----

; String -> Word
; converts s to the chosen word representation
(check-expect (string->word "") '())
(check-expect (string->word "ant") (list "a" "n" "t"))
(define (string->word s)
  (cond
    [(equal? (string-length s) 0) '()]
    [else (cons (substring s 0 1)
                (string->word (substring s 1)))]))
 
; Word -> String
; converts w to a string
(check-expect (word->string '()) "")
(check-expect (word->string (list "a" "n" "t")) "ant")
(define (word->string w)
  (cond
    [(empty? w) ""]
    [(cons? w) (string-append (first w)
                              (word->string (rest w)))]))

; ----Exercise 210----

; List-of-words -> List-of-strings
; turns all Words in low into Strings
(check-expect (words->strings '()) '())
(check-expect (words->strings (list (list "a" "n" "t")))
              (list "ant"))
(check-expect (words->strings (list (list "a" "n" "t")
                                    (list "b" "e" "e")))
              (list "ant" "bee"))
(define (words->strings low)
  (cond
    [(empty? low) '()]
    [(cons? low) (cons (word->string (first low))
                       (words->strings (rest low)))]))

; ----Exercise 211----

; List-of-strings -> List-of-strings
; picks out all those Strings that occur in the dictionary 
(define (in-dictionary los) '())(index "in-dictionary")
 