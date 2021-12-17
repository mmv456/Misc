;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname tbd) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; An N is one of:
; - 0
; - (add1 N)
; interpretation: represents the counting numbers (Natural Numbers)

; N String -> List-of-strings
; creates a list of n copies of s
(check-expect (copier 0 "hello") '())
(check-expect (copier 2 "hello") (cons "hello" (cons "hello" '())))

(define (copier n s)
  (cond
    [(zero? n) '()]
    [(positive? n) (cons s (copier (sub1 n) s))]))

; ---- Exercise 150

; N -> Number
; computes the (+ n pi) without using '+'
(check-within (add-to-pi 0) pi 0.001)
(check-within (add-to-pi 3) (+ 3 pi) 0.001)

(define (add-to-pi n)
  (cond
    [(zero? n) pi]
    [(positive? n) (add1 (add-to-pi (sub1 n)))]))

; N Number -> Number
; computes the (+ n x) without using '+'
(check-within (add 0 1) 1 0.001)
(check-within (add 3 1) 4 0.001)

(define (add n x)
  (cond
    [(zero? n) x]
    [(positive? n) (add1 (add (sub1 n) x))]))

; ---- Exercise 151

; N Number -> Number
; computes the (* n x) without using '*'
(check-within (multiply 0 1) 0 0.001)
(check-within (multiply 3 1) 3 0.001)

(define (multiply n x)
  (cond
    [(zero? n) 0]
    [(positive? n) (add x (multiply (sub1 n) x))]))

; ---- Exercise 152

; N Image -> Image
; produces a column of n copies of img
(check-expect (col 2 (square 5 "outline" "blue"))
              (overlay/xy (square 5 "outline" "blue")
                          0 5
                          (square 5 "outline" "blue")))
(define (col n img)
  (cond
    [(zero? (- n 1)) img]
    [(positive? n) (overlay/xy img 0 (image-height img) (col (- n 1) img))]))

; N Image -> Image
; produces a row of n copies of img
(check-expect (row 2 (square 5 "outline" "blue"))
              (overlay/xy (square 5 "outline" "blue")
                          5 0
                          (square 5 "outline" "blue")))
(define (row n img)
  (cond
    [(zero? (- n 1)) img]
    [(positive? n) (overlay/xy img (image-width img) 0 (row (- n 1) img))]))

; ---- Exercise 153

(define LECTURE-HALL (place-image (row 8 (col 18 (square 10 "outline" "black")))
                                  40 90
                                  (rectangle 81 181 "outline" "black")))
(define BALLOON (circle 4 "solid" "red"))

; A List-of-Posn is one of:
; - '()
; - (cons Posn List-of-Posn)
; interpretation: A list of posns whose coordinates fit the dimensions of the lecture hall

(define lop1 '())
(define lop2 (cons (make-posn 1 2)
                   (cons (make-posn 4 5)
                         '())))
(define lop3 (cons (make-posn 7.5 16)
                   (cons (make-posn 3 8.5)
                         (cons (make-posn 7 2.5)
                               '()))))

; List-of-Posn -> Image
; produces an image of the lecture hall with red balloons on it
(check-expect (add-balloons lop1) LECTURE-HALL)
(check-expect (add-balloons lop2)
              (place-image BALLOON 10 20
                           (place-image BALLOON 40 50
                                        LECTURE-HALL)))
(check-expect (add-balloons lop3)
              (place-image BALLOON 75 160
                           (place-image BALLOON 30 85
                                        (place-image BALLOON 70 25
                                                     LECTURE-HALL))))
(define (add-balloons lop)
  (cond
    [(empty? lop) LECTURE-HALL]
    [(cons? lop) (place-image BALLOON
                              (get-xy (first lop) "x")
                              (get-xy (first lop) "y")
                              (add-balloons (rest lop)))]))

; Posn String -> Number
; gets the x or y coordinates of the balloon
(check-expect (get-xy (make-posn 3 4) "x") 30)
(check-expect (get-xy (make-posn 3 4) "y") 40)

(define (get-xy p s)
  (cond
    [(string=? s "x") (* 10 (posn-x p))]
    [(string=? s "y") (* 10 (posn-y p))]))