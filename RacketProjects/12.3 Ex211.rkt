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

; On OS X: 
(define LOCATION "words.txt")
; On LINUX: /usr/share/dict/words or /var/lib/dict/words
; On WINDOWS: borrow the word file from your Linux friend
 
; A Dictionary is a List-of-strings.
(define AS-LIST (read-lines LOCATION))

; String Dictionary -> Boolean
; is the word in the dictionary?
(check-expect (in-dict? "ant" AS-LIST) #true)
(check-expect (in-dict? "tna" AS-LIST) #false)
(define (in-dict? s AS-LIST)
  (cond
    [(empty? AS-LIST) #false]
    [(cons? AS-LIST) (if (equal? s (first AS-LIST))
                         #true
                         (in-dict? s (rest AS-LIST)))]))
                         

; List-of-strings -> List-of-strings
; picks out all those Strings that occur in the dictionary
(check-expect (in-dictionary '()) '())
(check-expect (in-dictionary (list "tna" "nta")) '())
(check-expect (in-dictionary (list "ant" "nta")) (list "ant"))
(define (in-dictionary los)
  (cond
    [(empty? los) '()]
    [(cons? los) (if (in-dict? (first los) AS-LIST)
                     (cons (first los)
                           (in-dictionary (rest los)))
                     (in-dictionary (rest los)))]))
 