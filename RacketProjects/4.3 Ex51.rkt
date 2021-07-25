;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |4.3 Ex51|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define box (rectangle 30 60 "outline" "black"))

(define mt-red (circle 10 "outline" "red"))
(define mt-yellow (circle 10 "outline" "yellow"))
(define mt-green (circle 10 "outline" "green"))

(define lights
  (overlay/align "middle" "bottom" mt-green
                 (overlay/align "middle" "middle" mt-yellow
                                (overlay/align "middle" "top" mt-red
                                               box))))

(define full-red (circle 10 "solid" "red"))
(define full-yellow (circle 10 "solid" "yellow"))
(define full-green (circle 10 "solid" "green"))

; A TrafficLight is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent the three 
; possible states that a traffic light may assume

; TrafficLight -> Image
; renders the program
(check-expect (render "green")
              (overlay/align "middle" "bottom" full-green
                             lights))
(check-expect (render "red")
              (overlay/align "middle" "top" full-red
                             lights))
(check-expect (render "yellow")
              (overlay/align "middle" "middle" full-yellow
                             lights))
(define (render x)
  (cond
    [(equal? x "green") (overlay/align "middle" "bottom" full-green
                                       lights)]
    [(equal? x "yellow") (overlay/align "middle" "middle" full-yellow
                                        lights)]
    [(equal? x "red") (overlay/align "middle" "top" full-red
                                     lights)]))

; TrafficLight -> TrafficLight
; yields the next state given current state s
(check-expect (traffic-light-next "red") "green")
(check-expect (traffic-light-next "yellow") "red")
(check-expect (traffic-light-next "green") "yellow")
(define (traffic-light-next s)
  (cond
    [(string=? "red" s) "green"]
    [(string=? "green" s) "yellow"]
    [(string=? "yellow" s) "red"]))

; TrafficLight -> TrafficLight
; creates the animation
(define (tl-program x)
  (big-bang x
    [to-draw render]
    [on-tick traffic-light-next 1.5]))