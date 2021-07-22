;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |3.6 Ex44|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; basic world-making constants
(define width-of-world 200)
(define height-of-world (/ width-of-world 2))

(define tree
  (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))

(define mt-scene (place-image
                  tree 50 80
                  (empty-scene width-of-world height-of-world)))
(define y-car (- height-of-world 20))

; creating the wheels
(define wheel-radius 5)
(define wheel-distance (* wheel-radius 5))

(define wheel
  (circle wheel-radius "solid" "black"))
(define wheel-space
  (rectangle 20 wheel-radius "solid" "white"))
(define both-wheels
  (beside wheel wheel-space wheel))

; creating the whole car
(define car-body
  (rectangle (* wheel-radius 10)
             (* wheel-radius 2) "solid" "red"))
(define car-top
  (rectangle (* wheel-radius 4)
             (* wheel-radius 1.5) "solid" "red"))
(define red-car
  (above car-top car-body both-wheels))

; An AnimationState is a Number
; interpretation: the number of clock ticks since the animation
; started

; AnimationState -> Image
; places the image of the car x pixels from the left margin of 
; the background image and moves up and down based on the sine
; function
(check-expect (render 3)
              (place-image red-car 3 (+ (sin 3) 80) mt-scene))
(check-expect (render 300)
              (place-image red-car 300 (+ (sin 300) 80) mt-scene))
(define (render x)
  (place-image red-car x (+ (sin x) 80) mt-scene))

; AnimationState -> AnimationState
; adds 1 to move the car to the right
(check-expect (tock 1) 2)
(check-expect (tock 5) 6)
(define (tock x)
  (+ x 1))

; AnimationState Number Number String -> AnimationState
; places the car at x-mouse if the given MouseEvent is "button-down"
(check-expect (hyper 0 0 0 "button-down") 0)
(check-expect (hyper 0 10 0 "button-down") 10)
(check-expect (hyper 0 0 0 "button-up") 0)
(check-expect (hyper 0 10 0 "button-up") 0)
(define (hyper x-car x-mouse y-mouse m-event)
  (cond
    [(string=? "button-down" m-event) x-mouse]
    [else x-car]))

; AnimationState -> AnimationState
; launches the program from some initial state
(define (main as)
  (big-bang as
    [to-draw render]
    [on-tick tock]
    [on-mouse hyper]))