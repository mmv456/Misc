;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |3.6 Ex41|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
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

; A WorldState is a Number
; interpretation: the number of pixels between the left border of the
; scene and the car

; WorldState -> Image
; places the image of the car x pixels from the left margin of the
; background image
(check-expect (render 20) (place-image red-car 20 80 mt-scene))
(check-expect (render 78) (place-image red-car 78 80 mt-scene))
(define (render x)
  (place-image red-car x y-car mt-scene))

; WorldState -> WorldState
; adds 3 to x to move the car to the right
(check-expect (tock 20) 23)
(check-expect (tock 78) 81)
(define (tock x)
  (+ x 3))

; WorldState -> WorldState
; stops the animation when the car disappears to the right
(check-expect (stop 4) #false)
(check-expect (stop width-of-world) #false)
(check-expect (stop (+ width-of-world (* wheel-radius 10))) #true)
(define (stop x)
  (if (>= x (+ width-of-world (* wheel-radius 10)))
      #true
      #false))

; WorldState -> WorldState
; launches the program from some initial state
(define (main ws)
  (big-bang ws
    [on-tick tock]
    [to-draw render]
    [stop-when stop]))