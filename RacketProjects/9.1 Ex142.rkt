;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |9.1 Ex142|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; ----- Exercise 138

; A List-of-amounts is one of: 
; – '()
; – (cons PositiveNumber List-of-amounts)

(define one '())
(define two (cons 1 '()))
(define three (cons 1 (cons 2 '())))
(define four (cons 1 (cons 2 (cons 3 '()))))

; List-of-Amounts -> Number
; computes the sum of amounts in a list-of-amounts
(check-expect (sum one) 0)
(check-expect (sum two) 1)
(check-expect (sum three) 3)
(check-expect (sum four) 6)
(define (sum loa)
  (cond
    [(empty? loa) 0]
    [(cons? loa) (+ (first loa) (sum (rest loa)))]))


; ----- Exercise 139

; A List-of-numbers is one of: 
; – '()
; – (cons Number List-of-numbers)

(define lon1 '())
(define lon2 (cons 1 '()))
(define lon3 (cons 1 (cons 2 '())))
(define lon4 (cons 0 '()))
(define lon5 (cons 0 (cons 1 '())))
(define lon6 (cons -1 '()))
(define lon7 (cons 1 (cons -1 '())))

; List-of-numbers -> Boolean
; determines whether all numbers in a list-of-numbers are positive
; if they are, that means they're also a list-of-amounts (see Exercise 138 above)
(check-expect (pos? lon1) #true)
(check-expect (pos? lon2) #true)
(check-expect (pos? lon3) #true)
(check-expect (pos? lon4) #false)
(check-expect (pos? lon5) #false)
(check-expect (pos? lon6) #false)
(check-expect (pos? lon7) #false)

(define (pos? lon)
  (cond
    [(empty? lon) #true]
    [(cons? lon) (and (> (first lon) 0) (pos? (rest lon)))]))

; List-of-Numbers -> Number
; produces the sum of a list of numbers if it is also a list of amounts
(check-expect (checked-sum lon1) 0)
(check-expect (checked-sum lon2) 1)
(check-expect (checked-sum lon3) 3)
(check-error (checked-sum lon4) "The input is not a list-of-amounts")
(check-error (checked-sum lon5) "The input is not a list-of-amounts")
(check-error (checked-sum lon6) "The input is not a list-of-amounts")
(check-error (checked-sum lon7) "The input is not a list-of-amounts")

(define (checked-sum lon)
  (if (pos? lon)
      (sum lon)
      (error "The input is not a list-of-amounts")))


; ------Exercise 140

; A List-of-booleans is one of: 
; – '()
; – (cons Boolean List-of-booleans)

(define b1 '())
(define b2 (cons #true '()))
(define b3 (cons #true (cons #true '())))
(define b4 (cons #true (cons #false '())))
(define b5 (cons #false '()))
(define b6 (cons #false (cons #false '())))
(define b7 (cons #false (cons #true '())))

; List-of-Booleans -> Boolean
; determines whether all booleans in a list of booleans are true
(check-expect (all-true b1) #true)
(check-expect (all-true b2) #true)
(check-expect (all-true b3) #true)
(check-expect (all-true b4) #false)
(check-expect (all-true b5) #false)
(check-expect (all-true b6) #false)
(check-expect (all-true b7) #false)

(define (all-true lob)
  (cond
    [(empty? lob) #true]
    [(cons? lob) (and (first lob) (all-true (rest lob)))]))

; List-of-Booleans -> Boolean
; determines whether at least one item in a list of booleans is true
(check-expect (one-true b1) #false)
(check-expect (one-true b2) #true)
(check-expect (one-true b3) #true)
(check-expect (one-true b4) #true)
(check-expect (one-true b5) #false)
(check-expect (one-true b6) #false)
(check-expect (one-true b7) #true)

(define (one-true lob)
  (cond
    [(empty? lob) #false]
    [(cons? lob) (or (first lob) (one-true (rest lob)))]))

; ------Exercise 142

; A List-of-images is one of: 
; – '()
; – (cons Image List-of-images)

(define loi1 '())
(define loi2 (cons (square 5 "solid" "yellow") '()))
(define loi3 (cons (square 10 "solid" "blue") loi2))
(define loi4 (cons (square 15 "solid" "red") loi3))

; ImageOrFalse is one of:
; – Image
; – #false 

; List-of-Images Number -> ImageOrFalse
; produces the first image in a list of images that is not an n by n square
; and #false if it can't find one
(check-expect (ill-sized? loi1 5) #false)
(check-expect (ill-sized? loi2 5) #false)
(check-expect (ill-sized? loi3 5) (square 10 "solid" "blue"))
(check-expect (ill-sized? loi4 5) (square 15 "solid" "red"))

(define (ill-sized? loi n)
  (cond
    [(empty? loi) #false]
    [(cons? loi) (if (not (same-size? (first loi) n))
                     (first loi)
                     (ill-sized? (rest loi) n))]))

; Image Number -> Boolean
; is the square's size equal to the number?
(check-expect (same-size? (square 10 "solid" "black") 10) #true)
(check-expect (same-size? (square 1 "solid" "black") 10) #false)

(define (same-size? i n)
  (equal? (image-height i) n))