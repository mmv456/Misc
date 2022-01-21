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
; counts how often each letter occurs in the dictionary
(check-expect (count-by-letter '())
              (list
               (make-letter-count "a" 0)
               (make-letter-count "b" 0)
               (make-letter-count "c" 0)
               (make-letter-count "d" 0)
               (make-letter-count "e" 0)
               (make-letter-count "f" 0)
               (make-letter-count "g" 0)
               (make-letter-count "h" 0)
               (make-letter-count "i" 0)
               (make-letter-count "j" 0)
               (make-letter-count "k" 0)
               (make-letter-count "l" 0)
               (make-letter-count "m" 0)
               (make-letter-count "n" 0)
               (make-letter-count "o" 0)
               (make-letter-count "p" 0)
               (make-letter-count "q" 0)
               (make-letter-count "r" 0)
               (make-letter-count "s" 0)
               (make-letter-count "t" 0)
               (make-letter-count "u" 0)
               (make-letter-count "v" 0)
               (make-letter-count "w" 0)
               (make-letter-count "x" 0)
               (make-letter-count "y" 0)
               (make-letter-count "z" 0)))
(check-expect (count-by-letter (list "apple" "ant" "bear" "cat" "bat"))
              (list
               (make-letter-count "a" 2)
               (make-letter-count "b" 2)
               (make-letter-count "c" 1)
               (make-letter-count "d" 0)
               (make-letter-count "e" 0)
               (make-letter-count "f" 0)
               (make-letter-count "g" 0)
               (make-letter-count "h" 0)
               (make-letter-count "i" 0)
               (make-letter-count "j" 0)
               (make-letter-count "k" 0)
               (make-letter-count "l" 0)
               (make-letter-count "m" 0)
               (make-letter-count "n" 0)
               (make-letter-count "o" 0)
               (make-letter-count "p" 0)
               (make-letter-count "q" 0)
               (make-letter-count "r" 0)
               (make-letter-count "s" 0)
               (make-letter-count "t" 0)
               (make-letter-count "u" 0)
               (make-letter-count "v" 0)
               (make-letter-count "w" 0)
               (make-letter-count "x" 0)
               (make-letter-count "y" 0)
               (make-letter-count "z" 0)))
(define (count-by-letter d)
  (count-dict-letters LETTERS d))

; List-of-Letters Dictionary -> List-of-Letter-Counts
; creates the list of letter counts given a library and dictionary
(check-expect (count-dict-letters '() (list "apple"))
              '())
(check-expect (count-dict-letters LETTERS
                                  (list "apple" "ant" "bear" "cat" "bat"))
              (list
               (make-letter-count "a" 2)
               (make-letter-count "b" 2)
               (make-letter-count "c" 1)
               (make-letter-count "d" 0)
               (make-letter-count "e" 0)
               (make-letter-count "f" 0)
               (make-letter-count "g" 0)
               (make-letter-count "h" 0)
               (make-letter-count "i" 0)
               (make-letter-count "j" 0)
               (make-letter-count "k" 0)
               (make-letter-count "l" 0)
               (make-letter-count "m" 0)
               (make-letter-count "n" 0)
               (make-letter-count "o" 0)
               (make-letter-count "p" 0)
               (make-letter-count "q" 0)
               (make-letter-count "r" 0)
               (make-letter-count "s" 0)
               (make-letter-count "t" 0)
               (make-letter-count "u" 0)
               (make-letter-count "v" 0)
               (make-letter-count "w" 0)
               (make-letter-count "x" 0)
               (make-letter-count "y" 0)
               (make-letter-count "z" 0)))
(define (count-dict-letters l d)
  (cond
    [(empty? l) '()]
    [(cons? l) (cons (make-letter-count (first l)
                                        (starts-with# (first l) d))
                     (count-dict-letters (rest l) d))]))


; Exercise 197

; Dictionary -> Letter-Count
; produces the letter-count used most often in the dictionary
(check-expect (most-frequent (list "apple" "bear"))
              (make-letter-count "a" 1))
(check-expect (most-frequent (list "apple" "ant" "bear"))
              (make-letter-count "a" 2))
(define (most-frequent d)
  (most-in-lc (count-by-letter d)))

; List-of-Letter-Counts -> Letter-Count
; produces the letter-count most often used
(check-expect (most-in-lc (list (make-letter-count "a" 1)
                                (make-letter-count "b" 1)))
              (make-letter-count "a" 1))
(check-expect (most-in-lc (list (make-letter-count "a" 1)
                                (make-letter-count "b" 2)))
              (make-letter-count "b" 2))
(define (most-in-lc llc)
  (cond
    [(empty? (rest llc)) (first llc)]
    [(cons? (rest llc)) (if (>= (letter-count-count (first llc))
                                (letter-count-count (first (rest llc))))
                            (most-in-lc (cons (first llc) (rest (rest llc))))
                            (most-in-lc (rest llc)))]))

; Dictionary -> Letter-Count
; produces the letter-count used most often in the dictionary
(check-expect (most-frequent-sort (list "apple" "bear"))
              (make-letter-count "a" 1))
(check-expect (most-frequent-sort (list "apple" "ant" "bear"))
              (make-letter-count "a" 2))
(define (most-frequent-sort d)
  (first (sort-lc (count-by-letter d))))

; List-of-Letter-Counts -> List-of-Letter-Counts
; sorts the list of letter counts by greatest to least count
(check-expect (sort-lc (list (make-letter-count "a" 1)
                             (make-letter-count "b" 2)))
              (list (make-letter-count "b" 2)
                    (make-letter-count "a" 1)))
(check-expect (sort-lc (list (make-letter-count "a" 1)
                             (make-letter-count "b" 1)))
              (list (make-letter-count "a" 1)
                    (make-letter-count "b" 1)))
(check-expect (sort-lc (list (make-letter-count "a" 1)))
              (list (make-letter-count "a" 1)))
(define (sort-lc llc)
  (cond
    [(empty? (rest llc)) (cons (first llc) '())]
    [(cons? (rest llc)) (if (>= (letter-count-count (first llc))
                                (letter-count-count (first (rest llc))))
                            (cons (first llc)
                                  (sort-lc (rest llc)))
                            (cons (first (rest llc))
                                  (sort-lc (cons (first llc)
                                                 (rest (rest llc))))))]))

; Exercise 198

; Dictionary -> List-of-Dictionaries
; creates a list of dictionaries, one per letter
(check-expect (words-by-first-letter (list "apple"))
              (list (list "apple")))
(check-expect (words-by-first-letter (list "apple" "bear"))
              (list (list "apple")
                    (list "bear")))
(check-expect (words-by-first-letter (list "apple" "ant" "bear"))
              (list (list "apple" "ant")
                    (list "bear")))
(define (words-by-first-letter d)
  (create-from-letters LETTERS d))

; List-of-Letters Dictionary -> List-of-Dictionaries
; creates a list of dictionaries referencing the list of letters
(check-expect (create-from-letters LETTERS (list "apple"))
              (list (list "apple")))
(check-expect (create-from-letters LETTERS (list "apple" "bear"))
              (list (list "apple")
                    (list "bear")))
(check-expect (create-from-letters LETTERS
                                   (list "apple" "ant" "bear"))
              (list (list "apple" "ant")
                    (list "bear")))
(define (create-from-letters l d)
  (remove-empty (cond
                  [(empty? l) '()]
                  [(cons? l) (cons (dict-from-letter (first l) d)
                                   (create-from-letters (rest l) d))])))

; Letter Dictionary -> Dictionary
; creates a dictionary with just words starting with the letter
(check-expect (dict-from-letter "a" (list "apple"))
              (list "apple"))
(check-expect (dict-from-letter "a" (list "apple" "bat"))
              (list "apple"))
(check-expect (dict-from-letter "a" (list "bat"))
              '())
(define (dict-from-letter s d)
  (cond
    [(empty? d) '()]
    [(cons? d) (if (equal? s (substring (first d) 0 1))
                   (cons (first d) (dict-from-letter s (rest d)))
                   (dict-from-letter s (rest d)))]))

; List-of-Dictionaries -> List-of-Dictionaries
; gets rid of all empty lists
(check-expect (remove-empty (list '() (list "apple") '()))
              (list (list "apple")))
(define (remove-empty lod)
  (cond
    [(empty? lod) '()]
    [(cons? lod) (if (empty? (first lod))
                     (remove-empty (rest lod))
                     (cons (first lod) (remove-empty (rest lod))))]))

; Dictionary -> Letter-Count
; produces the letter-count most oftem used in the dictionary
(check-expect (most-frequent.v2 (list "apple" "bear"))
              (make-letter-count "a" 1))
(check-expect (most-frequent.v2 (list "apple" "ant" "bear"))
              (make-letter-count "a" 2))
(define (most-frequent.v2 d)
  (longest (words-by-first-letter d)))

; List-of-Dictionaries -> Letter-Count
; produces the letter-count most often used
(check-expect (longest (list (list "apple")))
              (make-letter-count "a" 1))
(check-expect (longest (list (list "apple" "ant")
                             (list "bee")))
              (make-letter-count "a" 2))
(define (longest lod)
  (cond
    [(empty? (rest lod)) (make-letter-count
                          (substring (first (first lod)) 0 1)
                          (length (first lod)))]
    [(cons? (rest lod)) (if (>= (length (first lod))
                                (length (first (rest lod))))
                            (longest (cons (first lod)
                                           (rest (rest lod))))
                            (longest (rest lod)))]))
