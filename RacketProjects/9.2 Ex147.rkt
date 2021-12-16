;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |9.2 Ex145|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; ---- Exercise 143

; A List-of-temperatures is one of: 
; – '()
; – (cons CTemperature List-of-temperatures)
 
; A CTemperature is a Number greater than -273.

; List-of-temperatures -> Number
; computes the average temperature
(check-expect (average (cons 1 (cons 2 (cons 3 '())))) 2)
(define (average alot)
  (/ (sum alot) (how-many alot)))

; List-of-temperatures -> Number
; computes the average temperature and checks for the empty list
(check-expect (checked-average (cons 1 (cons 2 (cons 3 '())))) 2)
(check-error (checked-average '()) "This results in a division by 0 error")
(define (checked-average alot)
  (cond
    [(empty? alot) (error "This results in a division by 0 error")]
    [(cons? alot) (/ (sum alot) (how-many alot))]))
 
; List-of-temperatures -> Number 
; adds up the temperatures on the given list
(check-expect (sum (cons 1 (cons 2 (cons 3 '())))) 6)
(define (sum alot)
  (cond
    [(empty? alot) 0]
    [(cons? alot) (+ (first alot) (sum (rest alot)))]))
 
; List-of-temperatures -> Number 
; counts the temperatures on the given list
(check-expect (how-many (cons 1 (cons 2 (cons 3 '())))) 3)
(define (how-many alot)
  (cond
    [(empty? alot) 0]
    [(cons? alot) (+ 1 (how-many (rest alot)))]))

; ---- Execerise 144

; An NEList-of-temperatures is one of: 
; – (cons CTemperature '())
; – (cons CTemperature NEList-of-temperatures)
; interpretation non-empty lists of Celsius temperatures 

(define NElot1 (cons 37 '()))
(define NElot2 (cons 0 (cons 37 '())))

; NEList-of-temperatures -> Number
; computes the average temperature 
(check-expect (averageNE (cons 1 (cons 2 (cons 3 '())))) 2)
 
(define (averageNE ne-l)
  (/ (sumNE ne-l)
     (how-many ne-l)))

; NEList-of-temperatures -> Number
; computes the sum
(check-expect (sumNE (cons 1 (cons 2 (cons 3 '())))) 6)
(define (sumNE ne-l)
  (cond
    [(empty? (rest ne-l)) (first ne-l)]
    [else (+ (first ne-l) (sumNE (rest ne-l)))]))

; --- Exercise 145

; NEList-of-temperatures -> Boolean
; produces #true if the temperatures are sorted in descending order
(check-expect (sorted>? (cons 2 '())) #true)
(check-expect (sorted>? (cons 1 (cons 2 '()))) #false)
(check-expect (sorted>? (cons 3 (cons 2 '()))) #true)
(check-expect (sorted>? (cons 0 (cons 3 (cons 2 '())))) #false)
(check-expect (sorted>? (cons 3 (cons 3 (cons 2 '())))) #true)

(define (sorted>? n)
  (cond
    [(empty? (rest n)) (> (first n) -274)]
    [(cons? n) (and (>= (first n) (first (rest n))) (sorted>? (rest n)))]))

; ---- Exercise 146

; NEList-of-temperatures -> Number 
; counts the temperatures on the given list
(check-expect (how-manyNE (cons 1 (cons 2 (cons 3 '())))) 3)
(define (how-manyNE ne-l)
  (cond
    [(empty? (rest ne-l)) 1]
    [(cons? ne-l) (+ 1 (how-manyNE (rest ne-l)))]))

; ---- Exercise 147

; An NEList-of-booleans is one of: 
; – (cons Boolean '())
; – (cons Boolean NEList-of-booleans)
; interpretation non-empty lists of booleans

(define NElob1 (cons #true '()))
(define NElob2 (cons #false '()))
(define NElob3 (cons #true (cons #true '())))
(define NElob4 (cons #false (cons #true '())))

; NEList-of-booleans -> Boolean
; determines whether all booleans are true
(check-expect (all-true-lob NElob1) #true)
(check-expect (all-true-lob NElob2) #false)
(check-expect (all-true-lob NElob3) #true)
(check-expect (all-true-lob NElob4) #false)

(define (all-true-lob lob)
  (cond
    [(empty? (rest lob)) (first lob)]
    [(cons? lob) (and (first lob) (all-true-lob (rest lob)))]))

; NEList-of-booleans -> Boolean
; determines whether at least one boolean is true
(check-expect (one-true-lob NElob1) #true)
(check-expect (one-true-lob NElob2) #false)
(check-expect (one-true-lob NElob3) #true)
(check-expect (one-true-lob NElob4) #true)

(define (one-true-lob lob)
  (cond
   [(empty? (rest lob)) (first lob)]
   [(cons? lob) (or (first lob) (one-true-lob (rest lob)))]))