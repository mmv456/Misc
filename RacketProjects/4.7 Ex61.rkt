;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |4.7 Ex61|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define red "red")
(define green "green")
(define yellow "yellow")

(define light-box (rectangle 90 30 "outline" "black"))
(define mt-lights (overlay/align
                   "right" "middle"
                   (circle 10 "outline" "green")
                   (overlay/align
                   "middle" "middle"
                   (circle 10 "outline" "yellow")
                   (overlay/align
                   "left" "middle"
                   (circle 10 "outline" "red") light-box))))

; A TrafficLight is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent the three 
; possible states that a traffic light may assume

; TrafficLight -> TrafficLight
; yields the next state, given current state cs
(check-expect (tl-next green) yellow)
(check-expect (tl-next yellow) red)
(check-expect (tl-next red) green)
(define (tl-next cs)
  (cond
    [(equal? cs green) yellow]
    [(equal? cs yellow) red]
    [(equal? cs red) green]))
 
; TrafficLight -> Image
; renders the current state cs as an image
(check-expect (tl-render green) (show-light green))
(check-expect (tl-render yellow) (show-light yellow))
(check-expect (tl-render red) (show-light red))
(define (tl-render current-state)
  (cond
    [(equal? current-state green) (show-light "green")]
    [(equal? current-state yellow) (show-light "yellow")]
    [(equal? current-state red) (show-light "red")]))

; TrafficLight -> Image
; creates a appropriate colored light given the TrafficLight
(check-expect (show-light green)
              (overlay/align
               "right" "middle"
               (circle 10 "solid" "green") mt-lights))
(check-expect (show-light yellow)
              (overlay/align
               "middle" "middle"
               (circle 10 "solid" "yellow") mt-lights))
(check-expect (show-light red)
              (overlay/align
               "left" "middle"
               (circle 10 "solid" "red") mt-lights))
(define (show-light x)
  (cond
    [(equal? x green)
     (overlay/align "right" "middle"
                    (circle 10 "solid" "green") mt-lights)]
    [(equal? x yellow)
     (overlay/align "middle" "middle"
                    (circle 10 "solid" "yellow") mt-lights)]
    [(equal? x red)
     (overlay/align "left" "middle"
                    (circle 10 "solid" "red") mt-lights)]))
    
; TrafficLight -> TrafficLight
; simulates a clock-based American traffic light
(define (traffic-light-simulation initial-state)
  (big-bang initial-state
    [to-draw tl-render]
    [on-tick tl-next 1]))