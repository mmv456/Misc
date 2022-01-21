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

; WISH LIST:
; - count-by-letter - counts how often each letter is used in dict
; - letter-exists? - is the letter already in the lolc?
; - letter-match? - does this letter-count match the letter?
; - add-one - adds one count to the letter-count
; - create-letter-count - given a string, makes a letter count
; - make-raw-llc - creates letter counts for all strings
; - find-lc - produces the letter-count in the non-empty llc

; Letter-Count -> Letter-Count
; adds one count to the letter count
(check-expect (add-one (make-letter-count "a" 1))
              (make-letter-count "a" 2))
(define (add-one lc)
  (make-letter-count (letter-count-letter lc)
                     (+ 1 (letter-count-count lc))))

; String Letter-Count -> Boolean
; does this letter match the letter-count?
(check-expect (letter-match? "apple"
                             (make-letter-count "a" 1))
              #true)
(check-expect (letter-match? "apple"
                             (make-letter-count "b" 1))
              #false)
(define (letter-match? s lc)
  (equal? (substring s 0 1)
          (letter-count-letter lc)))

; String List-of-Letter-Counts -> Boolean
; does this string occur in the list?
(check-expect (letter-exists? "apple" '())
              #false)
(check-expect (letter-exists? "apple"
                              (list (make-letter-count "a" 1)))
              #true)
(check-expect (letter-exists? "apple"
                              (list (make-letter-count "a" 1)
                                        (make-letter-count "b" 1)))
              #true)
(check-expect (letter-exists? "apple"
                              (list (make-letter-count "b" 1)
                                        (make-letter-count "c" 1)))
              #false)
(define (letter-exists? s llc)
  (cond
    [(empty? llc) #false]
    [(cons? llc) (or (letter-match? s (first llc))
                     (letter-exists? s (rest llc)))]))

; String -> Letter-Count
; given a string, creates a letter count
(check-expect (create-letter-count "apple")
              (make-letter-count "a" 1))
(define (create-letter-count s)
  (make-letter-count (substring s 0 1) 1))

; String List-of-Letter-Counts -> Letter-Count
; produces the letter-count in the non-empty llc
(check-expect (find-lc "apple" (list (make-letter-count "a" 1)))
                       (make-letter-count "a" 1))
(define (find-lc s llc)
  (if (equal? (substring s 0 1)
              (letter-count-letter (first llc)))
      (first llc)
      (find-lc s (rest llc))))

; Dictionary List-of-Letter-Counts -> List-of-Letter-Counts
; creates letter counts for all strings, given they pass
(check-expect (make-raw-llc '() '()) '())
(check-expect (make-raw-llc (list "apple") '())
              (list (make-letter-count "a" 1)))
(check-expect (make-raw-llc (list "apple" "ark") '())
              (list (make-letter-count "a" 2)))
(check-expect (make-raw-llc (list "apple" "ark" "bat") '())
              (list (make-letter-count "a" 2)
                    (make-letter-count "b" 1)))
(check-expect (make-raw-llc (list "apple")
                            (list (make-letter-count "a" 1)))
              (list (make-letter-count "a" 2)))
(define (make-raw-llc d llc)
  (cond
    [(empty? d) '()]
    [(cons? d) (cond
                 [(empty? llc) (cons (create-letter-count (first d))
                                     (make-raw-llc (rest d)
                                                   (cons (create-letter-count (first d))
                                                         llc)))]
                 [(cons? llc) (cons (if (letter-exists? (first d)
                                                        llc)
                                        (add-one (find-lc (first d)
                                                          llc))
                                        (create-letter-count (first d)))
                                    (make-raw-llc (rest d) llc))])]))
                         

; Dictionary -> List-of-Letter-Counts
; counts how often each letter occurs in the dictionary
(check-expect (count-by-letter '())
              '())
(check-expect (count-by-letter (list "apple"))
              (list (make-letter-count "a" 1)))
(check-expect (count-by-letter (list "apple" "ark"))
              (list (make-letter-count "a" 2)))
(check-expect (count-by-letter (list "apple" "bat"))
              (list (make-letter-count "a" 1)
                    (make-letter-count "b" 1)))
(check-expect (count-by-letter (list "apple" "ark" "bat"))
              (list (make-letter-count "a" 2)
                    (make-letter-count "b" 1)))
(define (count-by-letter d)
  (cond
    [(empty? d) '()]
    [(cons? d) (make-raw-llc d '())]))