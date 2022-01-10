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

; ----Exercise 195

; Letter Dictionary -> Number
; counts how many words in the dictionary start with the letter
(check-expect (starts-with# "a" '()) 0)
(check-expect (starts-with# "a" (list "apple" "bat")) 1)
(check-expect (starts-with# "a" (list "bat" "cat")) 0)

(define (starts-with# letter dict)
  (cond
    [(empty? dict) 0]
    [(cons? dict) (+ (if (starts-with? letter (first dict))
                         1
                         0)
                     (starts-with# letter (rest dict)))]))

     
; Letter String -> Boolean
; does the string start with the given letter?
(check-expect (starts-with? "a" "apple") #true)
(check-expect (starts-with? "a" "bat") #false)

(define (starts-with? l s)
  (equal? (substring s 0 1) l))

; ---- Exercise 196

(define-struct letter-count [letter count])
; A Letter-Count is a structure:
; (make-letter-count l c)
; interpretation: a letter-count is a structure that holds a
; letter l and the number of instances c of words that begin
; wiht the letter

; A List-of-Letter-Counts is one of:
; - '()
; - (list Letter-Count List-of-Letter-Counts)
; interpretation: a collection of letters and their counts

; Dictionary -> List-of-Letter-Counts
; counts how often each letter is used in a dictionary
;(check-expect (count-by-letter '()) '())
;(check-expect (count-by-letter (list "apple"))
;              (list (make-letter-count "a" 1)))
;(check-expect (count-by-letter (list "apple" "bat"))
;              (list (make-letter-count "a" 1)
;                    (make-letter-count "b" 1)))
;
;(define (count-by-letter d)
;  (cond
;    [(empty? d) '()]
;    [(cons? d) (edit-LC (first d)) ...]))

; String -> Letter-Count
; given a string, create a Letter-Count object
(check-expect (make-LC "apple") (make-letter-count "a" 1))
(define (make-LC s)
  (make-letter-count (substring s 0 1) 1))

; String List-of-Letter-Counts -> List-of-Letter-Counts
; given a string and a list of letter counts, add the string
; to the list if it isn't there already, or add 1 to the current
; letter count
(check-expect (edit-LC "apple" '())
              (list (make-letter-count "a" 1)))
(check-expect (edit-LC "apple" (list (make-letter-count "a" 1)))
              (list (make-letter-count "a" 2)))
(check-expect (edit-LC "bat" (list (make-letter-count "a" 1)))
              (list (make-letter-count "a" 1)
                    (make-letter-count "b" 1)))
(define (edit-LC s llc)
  (cond
    [(empty? llc) (cons (make-letter-count (get-first s) 1) llc)]
    [(and (cons? llc) (in-LC? s llc)) (update-llc s llc)]
    [(and (cons? llc) (not (in-LC? s llc)))
     (cons (make-letter-count (get-first s) 1) llc)]))

; String -> String
; gets the first letter that starts the string
(check-expect (get-first "apple") "a")

(define (get-first s)
  (substring s 0 1))

; String List-of-Letter-Counts -> Boolean
; is the letter of the string in the list of letter counts?
(check-expect (in-LC? "apple" '()) #false)
(check-expect (in-LC? "apple" (list (make-letter-count "a" 1)))
              #true)
(define (in-LC? s llc)
  (cond
    [(empty? llc) #false]
    [(cons? llc) (if (equal? (letter-count-letter (first llc))
                             (get-first s))
                     #true
                     (in-LC? s (rest llc)))]))

; String List-of-Letter-Counts -> List-of-Letter-Counts
; adds a count to the corresponding letter count in the list
(check-expect (update-llc "apple"
                          (list (make-letter-count "a" 1)))
              (list (make-letter-count "a" 2)))
(define (update-llc s llc)
  (if (equal? (letter-count-letter (first llc))
              (get-first s))
      (cons (make-letter-count (letter-count-letter (first llc))
                         (+ 1 (letter-count-count (first llc)))) llc)
      (cons (update-llc s (rest llc)))))