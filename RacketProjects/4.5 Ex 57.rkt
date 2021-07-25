;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |4.5 Ex 57|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; An LRCD (for launching rocket countdown) is one of:
; – "resting"
; – a Number between -3 and -1
; – a NonnegativeNumber

; interpretation: a grounded rocket, in countdown mode,
; a number denotes the number of pixels between the
; top of the canvas and the rocket (its height)

(define height 300) ; distances in pixels 
(define width  100)
(define y-delta 3)
 
(define background  (empty-scene width height))
(define rocket (rectangle 5 30 "solid" "red"))
 
(define center (/ (image-height rocket) 2))

; LCRD -> Image
; renders the state as a resting or flying rocket
(check-expect (show "resting")
              (place-image rocket 10 (- height center) background))
(check-expect (show -3)
              (place-image
               (text "-3" 20 "red")
               10 (* 3/4 width)
               (place-image rocket 10 (- height center) background)))
(check-expect (show -2)
              (place-image
               (text "-2" 20 "red")
               10 (* 3/4 width)
               (place-image rocket 10 (- height center) background)))
(check-expect (show -1)
              (place-image
               (text "-1" 20 "red")
               10 (* 3/4 width)
               (place-image rocket 10 (- height center) background)))
(check-expect (show 53)
              (place-image rocket 10 (- 53 center) background))
(check-expect (show height)
              (place-image rocket 10 (- height center) background))
(define (show x)
  (cond
    [(equal? x "resting")
     (place-rocket x)]
    [(<= -3 x -1) 
     (place-image (text (number->string x) 20 "red")
                  10 (* 3/4 width)
                  (place-rocket x))]
    [(>= x 0)
     (place-rocket x)]))

; LRCD -> Image
; performs the auxiliary function of placing the rocket in the
; background with the given LRCD position
(check-expect (place-rocket "resting")
              (place-image rocket 10 (- height center) background))
(check-expect (place-rocket -3)
              (place-image rocket 10 (- height center) background))
(check-expect (place-rocket -2)
              (place-image rocket 10 (- height center) background))
(check-expect (place-rocket -1)
              (place-image rocket 10 (- height center) background))
(check-expect (place-rocket 0)
              (place-image rocket 10 (- 0 center) background))
(check-expect (place-rocket 53)
              (place-image rocket 10 (- 53 center) background))
(define (place-rocket x)
  (cond
    [(equal? x "resting") (place-image rocket 10 (- height center)
                                       background)]
    [(<= -3 x -1) (place-image rocket 10 (- height center)
                               background)]
    [(>= x 0) (place-image rocket 10 (- x center) background)]))
    

; LCRD KeyEvent -> LRCD
; starts the countdown when spacebar is pressed, if the rocket is
; still resting
(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)
(define (launch x ke)
  (cond
    [(equal? x "resting") (if (string=? " " ke) -3 x)]
    [(<= -3 x -1) x]
    [(>= x 0) x]))

; LRCD -> LRCD
; raises the rocket by y-delta if it is already moving
(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) height)
(check-expect (fly height) (- height y-delta))
(check-expect (fly 10) (- 10 y-delta))
(define (fly x)
  (cond
    [(equal? x "resting") "resting"]
    [(<= -3 x -1) (if (= x -1) height (+ x 1))]
    [(>= x 0) (- x y-delta)]))

; LRCD -> boolean
; indicates whether the animation should stop
(check-expect (stop? "resting") #false)
(check-expect (stop? -3) #false)
(check-expect (stop? -2) #false)
(check-expect (stop? -1) #false)
(check-expect (stop? height) #false)
(check-expect (stop? (* center 2)) #true)
(check-expect (stop? 0) #true)
(define (stop? x)
  (cond
    [(equal? x "resting") #false]
    [(<= -3 x -1) #false]
    [(>= x 0) (if (<= x (* center 2)) #true #false)]))

; LRCD -> LRCD
; creates the rocket animation
(define (main1 s)
  (big-bang s
    [to-draw show]
    [on-key launch]
    [on-tick fly]
    [stop-when stop?]))