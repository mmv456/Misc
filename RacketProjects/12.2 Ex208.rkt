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

; LList -> List of String
; produce a list of keys that have boolean attriburs in
; a List of Association list
(check-expect (boolean-attributes '()) '())
(check-expect (boolean-attributes (list (list (list "aa" "bb"))
                                        (list (list "aa" "bb"))))
              '())
(check-expect (boolean-attributes (list (list (list "aa" "bb")
                                              (list "cc" #true))
                                        (list (list "aa" "bb")
                                              (list "cc" #false)
                                              (list "dd" #true))))
              (list "cc" "dd"))

(define (boolean-attributes llst)
  (create-set
   (cond [(empty? llst) '()]
         [else (append (find-booleans (first llst))
                       (boolean-attributes (rest llst)))])))

; String List-of-string -> List-of-string
; produce a List of String from a given List of String with str removed
(check-expect (remove-str "aa" '()) '())
(check-expect (remove-str "aa" (list "aa" "bb" "cc")) (list "bb" "cc"))
(check-expect (remove-str "bb" (list "aa" "bb" "cc")) (list "aa" "cc"))
(check-expect (remove-str "aa" (list "aa" "aa" "bb" "aa" "cc" "bb" "cc"))
              (list  "bb" "cc" "bb" "cc"))

(define (remove-str str los)
  (cond [(empty? los) '()]
        [else (if (string=? str (first los))
                  (remove-str str (rest los))
                  (cons (first los) (remove-str str (rest los))))]))

; List-of-string -> List-of-string
; copy List of String with duplications removed (list as a set).
(check-expect (create-set '()) '())
(check-expect (create-set (list "aa" "bb" "cc")) (list "aa" "bb" "cc"))
(check-expect (create-set (list "aa" "aa" "cc")) (list "aa" "cc"))
(check-expect (create-set (list "aa" "aa" "bb" "aa" "cc" "bb" "cc"))
              (list  "aa" "bb" "cc"))

(define (create-set los)
  (cond [(empty? los) '()]
        [else
         (cons (first los)
               (create-set (remove-str (first los) (rest los))))]))

; LAssoc -> List-of-string
; produce a list of keys (String) for any attribute in a LTrack is a boolean
(check-expect (find-booleans '()) '())
(check-expect (find-booleans (list (list "aa" "bb"))) '())
(check-expect (find-booleans (list (list "aa" "bb")
                                   (list "cc" #true)
                                   (list "dd" 3)
                                   (list "ee" #false)))
              (list "cc" "ee"))

(define (find-booleans las)
  (cond [(empty? las) '()]
        [else (if (boolean? (second (first las)))
                  (cons (first (first las))
                        (find-booleans (rest las)))
                  (find-booleans (rest las)))]))