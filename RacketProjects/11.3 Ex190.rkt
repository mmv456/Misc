;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |11.3 Ex190|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; Exercise 181

(check-expect (cons "a" (cons "b" (cons "c" (cons "d" '()))))
              (list "a" "b" "c" "d"))
(check-expect (cons (cons 1 (cons 2 '())) '())
              (list (list 1 2)))
(check-expect (cons "a" (cons (cons 1 '()) (cons #false '())))
              (list "a" (list 1) #false))
(check-expect (cons (cons "a" (cons 2 '())) (cons "hello" '()))
              (list (list "a" 2) "hello"))
(check-expect (cons (cons 1 (cons 2 '()))
                    (cons (cons 2 '())
                          '()))
              (list (list 1 2) (list 2)))

; Exercise 182

(check-expect (list 0 1 2 3 4 5)
              (cons 0
                    (cons 1
                          (cons 2
                                (cons 3
                                      (cons 4
                                            (cons 5 '())))))))
(check-expect (list (list "he" 0) (list "it" 1) (list "lui" 14))
              (cons (cons "he" (cons 0 '()))
                    (cons (cons "it" (cons 1 '()))
                          (cons
                           (cons "lui" (cons 14 '())) '()))))
(check-expect (list 1 (list 1 2) (list 1 2 3))
              (cons 1
                    (cons (cons 1 (cons 2 '()))
                          (cons
                           (cons 1 (cons 2 (cons 3 '()))) '()))))

; Exercise 183

(check-expect (cons "a" (list 0 #false))
              (list "a" 0 #false))
(check-expect (list (cons 1 (cons 13 '())))
              (list (list 1 13)))
(check-expect (cons (list 1 (list 13 '())) '())
              (list (list 1 (list 13 '()))))
(check-expect (list '() '() (cons 1 '()))
              (list '() '() (list 1)))
(check-expect (cons "a" (cons (list 1) (list #false '())))
              (list "a" (list 1) #false '()))

; Exercise 184

(check-expect (list (string=? "a" "b") #false)
              (list #false #false))
(check-expect (list (+ 10 20) (* 10 20) (/ 10 20))
              (list 30 200 0.5))
(check-expect (list "dana" "jane" "mary" "laura")
              (list "dana" "jane" "mary" "laura"))

; Exercise 185

(check-expect (first (list 1 2 3))
              1)
(check-expect (rest (list 1 2 3))
              (list 2 3))
(check-expect (second (list 1 2 3))
              2)

; Exercise 186

; List-of-numbers -> List-of-numbers 
; rearranges alon in descending order
 
(check-expect (sort> '()) '())
(check-expect (sort> (list 3 2 1)) (list 3 2 1))
(check-expect (sort> (list 1 2 3)) (list 3 2 1))
(check-expect (sort> (list 12 20 -5))
              (list 20 12 -5))

(define (sort> alon)
  (cond
    [(empty? alon) '()]
    [else
     (insert (first alon) (sort> (rest alon)))]))


; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of numbers alon
(check-expect (insert 5 '()) (list 5))
(check-expect (insert 5 (list 6)) (list 6 5))
(check-expect (insert 5 (list 4)) (list 5 4))
(check-expect (insert 12 (list 20 -5))
              (list 20 12 -5))

(define (insert n alon)
  (cond
    [(empty? alon) (cons n '())]
    [else (if (>= n (first alon))
              (cons n alon)
              (cons (first alon) (insert n (rest alon))))]))

; List-of-numbers -> Boolean
; is the list sorted descendingly?
(check-expect (sorted>? (list 5 4 3)) #true)
(check-expect (sorted>? (list 3 4 5)) #false)
(check-expect (sorted>? (list 3)) #true)
(check-expect (sorted>? '()) #true)
(check-satisfied (sort> (list 1 2 3)) sorted>?)

(define (sorted>? lon)
  (cond
    [(empty? lon) #true]
    [(empty? (rest lon)) #true]
    [(cons? lon) (and
                  (>= (first lon) (first (rest lon)))
                  (sorted>? (rest lon)))]))

; Exercise 187

(define-struct gp [name score])
; A GamePlayer is a structure: 
;    (make-gp String Number)
; interpretation (make-gp p s) represents player p who 
; scored a maximum of s points

(define gp1 (make-gp "One" 34))
(define gp2 (make-gp "Two" 65))
(define gp3 (make-gp "Three" 5))

; A List-of-GP is one of:
; - '()
; - (cons GP List-of-GP)
; interpretation: A list of game players

(define logp1 '())
(define logp2 (list gp1))
(define logp3 (list gp1 gp2))
(define logp4 (list gp1 gp2 gp3))

; List-of-GP -> List-of-GP
; sorts the list of game players by highest score
(check-expect (sortGP logp1) logp1)
(check-expect (sortGP logp2) logp2)
(check-expect (sortGP logp3) (list gp2 gp1))
(check-expect (sortGP logp4) (list gp2 gp1 gp3))
(define (sortGP logp)
  (cond
    [(empty? logp) logp]
    [(empty? (rest logp)) logp]
    [else (compareGP (first logp) (rest logp))]))

; GP List-of-GP -> List-of-GP
; places the given GP in the appropriate spot on the list
(check-expect (compareGP (make-gp "A" 5)
                         '())
              (list (make-gp "A" 5)))
(check-expect (compareGP (make-gp "B" 20)
                         (list (make-gp "C" 50) (make-gp "A" 5)))
              (list (make-gp "C" 50) (make-gp "B" 20) (make-gp "A" 5)))
(define (compareGP gp logp)
  (cond
    [(empty? logp) (cons gp '())]
    [(cons? logp) (if (>= (gp-score gp)
                          (gp-score (first logp)))
                      (cons gp logp)
                      (cons (first logp) (compareGP gp (rest logp))))]))

; List-of-GP -> Boolean
; Are GPs listed by descending order?
(check-expect (descGP? '()) #true)
(check-expect (descGP? (list (make-gp "B" 20))) #true)
(check-expect (descGP? (list (make-gp "B" 20)
                             (make-gp "C" 50))) #false)
(check-expect (descGP? (list (make-gp "C" 50)
                             (make-gp "B" 20)
                             (make-gp "A" 5))) #true)
(check-satisfied (list (make-gp "C" 50) (make-gp "B" 20) (make-gp "A" 5))
                 descGP?)
(define (descGP? logp)
  (cond
    [(empty? logp) #true]
    [(empty? (rest logp)) #true]
    [else (and (>= (gp-score (first logp)) (gp-score (first (rest logp))))
               (descGP? (rest logp)))]))

; Exercise 188

(define-struct email [from date message])
; An Email Message is a structure: 
;   (make-email String Number String)
; interpretation (make-email f d m) represents text m 
; sent by f, d seconds after the beginning of time 

; A List-of-Emails is one of:
; - '()
; - (cons Email List-of-Emails)
; interpretation: A list of emails

; List-of-Emails -> List-of-Emails
; sorts the emails by earliest date to later
(check-expect (sort-email-date '()) '())
(check-expect (sort-email-date (list (make-email "" 5 "")))
              (list (make-email "" 5 "")))
(check-expect (sort-email-date (list (make-email "" 10 "")
                                     (make-email "" 5 "")))
              (list (make-email "" 5 "") (make-email "" 10 "")))
(define (sort-email-date loe)
  (cond
    [(empty? loe) '()]
    [(empty? (rest loe)) loe]
    [else (compareDate (first loe) (rest loe))]))

; Email List-of-Emails -> List-of-Emails
; places the given email in the list of emails
(check-expect (compareDate (make-email "" 5 "")
                           (list (make-email "" 10 "")))
              (list (make-email "" 5 "") (make-email "" 10 "")))
(define (compareDate e loe)
  (cond
    [(empty? loe) (cons e '())]
    [(cons? loe) (if (<= (email-date e) (email-date (first loe)))
                     (cons e (compareDate (first loe) (rest loe)))
                     (cons (first loe) (compareDate e (rest loe))))]))


; Exercise 189

; Number List-of-numbers -> Boolean
; does a number occur in a list of numbers?
(check-expect (search 7 (list 7 8 9)) #true)
(check-expect (search 7 (list 1 2 3)) #false)
(check-expect (search 3 (list 1 2 3)) #true)
(define (search n alon)
  (cond
    [(empty? alon) #false]
    [else (or (= (first alon) n)
              (search n (rest alon)))]))

; Number List-of-numbers -> Boolean
; does a number occur in a sorted list of numbers?
(check-expect (search-sorted 5 (list 5 3 2 1)) #true)
(check-expect (search-sorted 1 (list 10 9 8)) #false)
(define (search-sorted n lon)
  (member? n lon))

; Exercise 190

; List-of-1Strings -> List-of-List-of-1Strings
; consumes a list and produces a list of all prefixes
(check-expect (prefixes (list "a" "b" "c"))
              (list
               (list "a" "b" "c")
               (list "a" "b")
               (list "a")))
(check-expect (prefixes '()) '())
(define (prefixes lo1s)
  (cond
    [(empty? lo1s) '()]
    [else
     (cons lo1s (prefixes (all-but-last lo1s)))]))

; List-of-1Strings -> List-of-1Strings
; Gets the items in a list except for the last one
(check-expect (all-but-last (list "a" "b" "c"))
              (list "a" "b"))
(define (all-but-last l)
  (cond
    [(empty? (rest l)) '()]
    [else
     (cons (first l) (all-but-last (rest l)))]))