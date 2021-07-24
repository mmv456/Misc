;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |3.7 Ex47|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define max-score 100)
(define min-score 0)
(define guage (rectangle (+ max-score 1) 21 "outline" "black"))

; A WorldState is a Number
; interpretation: the happiness level decreasing over time

; WorldState -> Image
; renders the program
(check-expect (render 100)
              (overlay (rectangle 100 20 "solid" "red")
                       guage))
(check-expect (render 50)
              (overlay (rectangle 50 20 "solid" "red")
                       guage))
(check-expect (render 0)
              (overlay (rectangle 0 20 "solid" "red")
                       guage))
(check-expect (render -2)
              (overlay (rectangle 0 20 "solid" "red")
                       guage))
(check-expect (render 120)
              (overlay (rectangle 100 20 "solid" "red")
                       guage))
(define (render x)
  (cond
    [(< x min-score) (overlay (rectangle min-score 20 "solid" "red")
                      guage)]
    [(> x max-score) (overlay (rectangle max-score 20 "solid" "red")
                        guage)]
    [else (overlay (rectangle x 20 "solid" "red")
                   guage)]))

; WorldState -> WorldState
; decreases the happiness by 0.1
(check-expect (tock 0) (- 0 0.1))
(check-expect (tock 100) (- 100 0.1))
(define (tock x)
  (- x 0.1))

; WorldState Number Number String -> WorldState
; increase happiness by 1/5 if mouse-down, increase happiness by
; 1/3 if mouse-up
(check-expect (hyper 0 3 20 "button-down") (+ 0 (/ 1 5)))
(check-expect (hyper 0 3 20 "button-up") (+ 0 (/ 1 3)))
(check-expect (hyper 0 3 20 "move") 0)
(define (hyper x n1 n2 me)
              (cond
                [(equal? me "button-down") (+ x (/ 1 5))]
                [(equal? me "button-up") (+ x (/ 1 3))]
                [else x])) 

; WorldState -> WorldState
; creates the animation
(define (guage-prog ws)
  (big-bang ws
    [to-draw render]
    [on-tick tock]
    [on-mouse hyper]))