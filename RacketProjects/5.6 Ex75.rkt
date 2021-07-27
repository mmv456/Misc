;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |5.6 Ex75|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define-struct vel [deltax deltay])
; A Vel is a structure: 
;   (make-vel Number Number)
; interpretation (make-vel dx dy) means a velocity of 
; dx pixels [per tick] along the horizontal and
; dy pixels [per tick] along the vertical direction

(define-struct ufo [loc vel])
; A UFO is a structure: 
;   (make-ufo Posn Vel)
; interpretation (make-ufo p v) is at location p moving at velocity v

(define v1 (make-vel 8 -3))
(define v2 (make-vel -5 -3))

(define p1 (make-posn 22 80))
(define p2 (make-posn 30 77))
 
(define u1 (make-ufo p1 v1))
(define u2 (make-ufo p1 v2))
(define u3 (make-ufo p2 v1))
(define u4 (make-ufo p2 v2))

; UFO -> UFO
; determines where u moves in one clock tick; 
; leaves the velocity as is
(check-expect (ufo-move-1 u1) u3)
(check-expect (ufo-move-1 u2)
              (make-ufo (make-posn 17 77) v2))
(define (ufo-move-1 u)
  (make-ufo
   (make-posn (new-x (ufo-loc u) (ufo-vel u))
              (new-y (ufo-loc u) (ufo-vel u)))
   (ufo-vel u)))

; Posn Vel -> Number
; adds the x-values of the two to create a new x-position
(check-expect (new-x p1 v1) 30)
(check-expect (new-x p2 v2) 25)
(define (new-x p v)
  (+ (posn-x p) (vel-deltax v)))

; Posn Vel -> Number
; adds the y-values of the two to create a new x-position
(check-expect (new-y p1 v1) 77)
(check-expect (new-y p2 v2) 74)
(define (new-y p v)
  (+ (posn-y p) (vel-deltay v)))