;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |12.1 Ex198|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; On OS X: 
(define LOCATION "words.txt")
; On LINUX: /usr/share/dict/words or /var/lib/dict/words
; On WINDOWS: borrow the word file from your Linux friend
 
; A Dictionary is a List-of-strings.
(define AS-LIST (read-lines LOCATION))

; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS
  (explode "abcdefghijklmnopqrstuvwxyz"))

; ------ Exercise 195

; Letter Dictionary -> Number
; counts how many words in the dictionary start with the letter
(check-expect (starts-with# "a" (list)) 0)
(check-expect (starts-with# "a" (list "cat" "bear")) 0)
(check-expect (starts-with# "a" (list "apple" "ark" "bear")) 2)
(define (starts-with# l d)
  (cond
    [(empty? d) 0]
    [(cons? d) (if (starts-with? l (first d))
                   (+ 1 (starts-with# l (rest d)))
                   (starts-with# l (rest d)))]))

; Letter String -> Boolean
; Does the string start with the letter?
(check-expect (starts-with? "a" "apple") #true)
(check-expect (starts-with? "a" "bear") #false)
(define (starts-with? l s)
  (equal? l (substring s 0 1)))

; ------ Exercise 196

(define-struct counter [letter count])
; A Counter is a struct:
; (make-counter String Number)
; interpretation: (make-counter l c) shows how
; many times a word has l as the first letter

; A List-of-Counters is one of:
; - '()
; - (cons Counter List-of-Counters)
; interpretation: a list of individual letter counts

; Dictionary -> List-of-Counters
; counts how often a letter is used as the first letter
(check-expect (count-by-letter (list)) (list))
#;(check-expect (count-by-letter (list "apple" "bee" "cat"))
              (list (make-counter "a" 1)
                    (make-counter "b" 1)
                    (make-counter "c" 1)))
#;(check-expect (count-by-letter (list "apple" "ant" "bee"))
              (list (make-counter "a" 2)
                    (make-counter "b" 1)))
(define (count-by-letter d)
  (cond
    [(empty? d) '()]
    [(cons? d) (list (if (substring 0 1 (first d)) in LETTERS)
                         (list (make-counter (substring 0 1 (first d))
                                             1)
                               (count-by-letter (rest d)))
                         (count-by-letter (rest d)))]))

; String 