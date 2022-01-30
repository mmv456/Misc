;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |12.4 Ex214|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; A Word is one of:
; – '() or
; – (cons 1String Word)
; interpretation a Word is a list of 1Strings (letters)
 
; A List-of-words is one of:
; - '()
; - (cons Word List-of-words)
; interpretation: a list of words

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

; ----Exercise 212----

(define WORD1 '())
(define WORD2 (list "a" "n" "t"))
(define WORD3 (list "b" "e" "e"))

(define LOW1 '())
(define LOW2 (list WORD2))
(define LOW3 (list WORD2 WORD3))

; ----Exercise 213----

; 1String Word -> Word
; inserts the 1String to the beginning of the word
(check-expect (add-to-beginning "a" '())
              (list "a"))
(check-expect (add-to-beginning "a" (list "n" "t"))
              (list "a" "n" "t"))
(define (add-to-beginning s w)
  (cons s w))


; 1String List-of-Words -> List-of-Words
; inserts the 1String in front of all words in list
(check-expect (insert-everywhere/in-all-words "a" '())
              '())
(check-expect (insert-everywhere/in-all-words "a" (list (list "n" "t")))
              (list (list "a" "n" "t")))
(check-expect (insert-everywhere/in-all-words "d"
                                              (list (list "e" "r")
                                                    (list "r" "e")))
              (list (list "d" "e" "r")
                    (list "d" "r" "e")))
(define (insert-everywhere/in-all-words s low)
  (cond
    [(empty? low) '()]
    [(cons? low) (cons (add-to-beginning s (first low))
                       (insert-everywhere/in-all-words s (rest low)))]))


; ----Exercise 214----

; Word -> List-of-words
; creates all rearrangements of the letters in w
(check-expect (arrangements '()) (list '()))
(check-expect (arrangements (list "a" "m"))
              (list (list "a" "m")))
(define (arrangements w)
  (cond
    [(empty? w) (list '())]
    [else (insert-everywhere/in-all-words (first w)
                                          (arrangements (rest w)))]))