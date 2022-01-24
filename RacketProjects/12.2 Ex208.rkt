;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |12.2 Ex208|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/itunes)
(require 2htdp/batch-io)

; the 2htdp/itunes library documentation, part 2: 
 
; An LLists is one of:
; – '()
; – (cons LAssoc LLists)
 
; An LAssoc is one of: 
; – '()
; – (cons Association LAssoc)
; 
; An Association is a list of two items: 
;   (cons String (cons BSDN '()))
 
; A BSDN is one of: 
; – Boolean
; – Number
; – String
; – Date
 
; String -> LLists
; creates a list of lists representation for all tracks in 
; file-name, which must be an XML export from iTunes 
#;(define (read-itunes-as-lists file-name) ...)


; modify the following to use your chosen name
#;(define ITUNES-LOCATION "itunes.xml")
 
; LLists
#;(define list-tracks (read-itunes-as-lists ITUNES-LOCATION))

; ----Exercise 205---

(define ASSOC1 (cons "Name" (cons "One" '())))
(define ASSOC2 (cons "Artist" (cons "Enya" '())))
(define ASSOC3 (cons "Album" (cons "Numbers" '())))
(define ASSOC4 (cons "Time" (cons 100 '())))
(define ASSOC5 (cons "Track#" (cons 1 '())))
(define ASSOC6 (cons "Good?" (cons #true '())))

(define LASSOC1 '())
(define LASSOC2 (cons ASSOC1 (cons ASSOC2 '())))
(define LASSOC3 (list ASSOC1 ASSOC2 ASSOC3 ASSOC4 ASSOC5 ASSOC6))

(define LLIST1 '())
(define LLIST2 (list LASSOC2 LASSOC3))

; ----Exercise 206---

; String Association -> Boolean
; does the given string equal the first value of the association?
(check-expect (first-found? "Time" ASSOC4) #true)
(check-expect (first-found? "Time" ASSOC1) #false)
(define (first-found? s assoc)
  (equal? s (first assoc)))

; String LAssoc Any -> Assocation
; produces the first association whose first item is equal
; to the string, or the given default value if it isn't found
(check-expect (find-association "Time" LASSOC3 "NA") ASSOC4)
(check-expect (find-association "Time" LASSOC1 "NA") "NA")
(check-expect (find-association "Time" LASSOC2 400) 400)
(define (find-association key lassoc default)
  (cond
    [(empty? lassoc) default]
    [(cons? lassoc) (if (first-found? key (first lassoc))
                        (first lassoc)
                        (find-association key (rest lassoc) default))]))

; ----Exercise 207---

; Assocation -> BSDN
; retrieves the second value of the association
(check-expect (get-value ASSOC4) 100)
(define (get-value a)
  (second a))

; LLists -> Number
; produces the total amount of play time
(check-expect (total-time/list LLIST1) 0)
(check-expect (total-time/list LLIST2) 100)
(define (total-time/list llist)
  (cond
    [(empty? llist) 0]
    [(cons? llist) (if (cons? (find-association "Time" (first llist) "NA"))
                       (+ (get-value (find-association "Time" (first llist) "NA"))
                          (total-time/list (rest llist)))
                       (total-time/list (rest llist)))]))

; ----Exercise 208---

; Association -> Boolean
; is the assocation's value a boolean?
(check-expect (is-boolean? ASSOC1) #false)
(check-expect (is-boolean? ASSOC6) #true)
(define (is-boolean? assoc)
  (boolean? (second assoc)))

; Assocation -> BSDN
; retrieves the key of the association
(check-expect (get-key ASSOC4) "Time")
(define (get-key a)
  (first a))

; LAssoc -> List-of-Strings
; produces the strings that are associated with a boolean value
(check-expect (boolean-lassoc LASSOC1) '())
(check-expect (boolean-lassoc LASSOC2) '())
(check-expect (boolean-lassoc LASSOC3) (list "Good?"))
(define (boolean-lassoc lassoc)
  (cond
    [(empty? lassoc) '()]
    [(cons? lassoc) (if (is-boolean? (first lassoc))
                        (cons (get-key (first lassoc))
                              (boolean-lassoc (rest lassoc)))
                        (boolean-lassoc (rest lassoc)))]))

; List-of-List-of-Any -> List-of-Any
; create one big list from separate lists
(check-expect (combine '()) '())
(check-expect (combine (list (list "apple")
                             (list "bear")))
              (list "apple" "bear"))
(check-expect (combine (list (list "apple" "ant")
                             (list "bear")))
              (list "apple" "ant" "bear"))
(define (combine lol)
  (cond
  [(empty? lol) '()]
  [(cons? lol) (cons (first (first lol))
                     (if (not (empty? (rest (first lol))))
                         (combine (cons (rest (first lol))
                                        (rest lol)))
                         (combine (rest lol))))]))

; List-of-List-of-Strings -> List-of-Strings
; cleans up a list of lists of strings (removes empty lists and
; any duplicates)
(check-expect (clean-llos '()) '())
(check-expect (clean-llos (list '()
                                (list "hello")
                                (list "hello")))
              (list "hello"))
(check-expect (clean-llos (list '()
                                (list "hello")
                                '()
                                (list "hello")))
              (list "hello"))
(define (clean-llos llos)
  (cond
    [(empty? llos) '()]
    [(cons? llos) (combine (if (empty? (first llos))
                               (clean-llos (rest llos))
                               (cons (first llos)
                                     (clean-llos (rest llos)))))]))

; LLists -> List-of-Strings
; produces the strings that are associated with a boolean value
;(check-expect (boolean-attributes LLIST1) '())
;(check-expect (boolean-attributes LLIST2) (list "Good?"))
#;(define (boolean-attributes llist)
  (cond
    [(empty? llist) '()]
    [(cons? llist) (cons (boolean-lassoc (first llist))
                         (boolean-attributes (rest llist)))]))