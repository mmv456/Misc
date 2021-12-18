;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname tbd) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define-struct layer [color doll])

; An RD (short for Russian Doll) is one of:
; - String
; - (make-layer String RD)

(define RD1 "red")
(define RD2 (make-layer "green" RD1))
(define RD3 (make-layer "yellow" RD2))

; RD -> Number
; how many dolls are part of an RD
(check-expect (depth RD1) 1)
(check-expect (depth RD2) 2)
(check-expect (depth RD3) 3)

(define (depth rd)
  (cond
    [(string? rd) 1]
    [(layer? rd) (+ 1 (depth (layer-doll rd)))]))

; ---- Exercise 154

; RD -> String
; produces a string of all colors of the doll
(check-expect (colors RD1) "red")
(check-expect (colors RD2) "green, red")
(check-expect (colors RD3) "yellow, green, red")

(define (colors rd)
  (cond
    [(string? rd) rd]
    [(layer? rd) (string-append (layer-color rd)
                                ", "
                                (colors (layer-doll rd)))]))

; ---- Exercise 155

; RD -> String
; produces the string of the innermost doll
(check-expect (inner RD1) "red")
(check-expect (inner RD2) "red")
(check-expect (inner RD3) "red")

(define (inner rd)
  (cond
    [(string? rd) rd]
    [(layer? rd) (inner (layer-doll rd))]))