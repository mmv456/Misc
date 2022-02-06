;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |12.5 Ex219 Worm|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; ----Exercise 215----

(define WIDTH 100)
(define HEIGHT 100)
(define MT-SCENE (empty-scene WIDTH HEIGHT))

(define HEAD (circle 3 "solid" "green"))
(define FOOD (circle 3 "solid" "orange"))
(define TAIL (circle 3 "solid" "red"))

; A Direction is one of:
; - "Up"
; - "Down"
; - "Left"
; - "Right"
; interpretation: a direction for the worm to go to

(define UP "Up")
(define DOWN "Down")
(define LEFT "Left")
(define RIGHT "Right")

(define-struct worm [location direction])
; A Worm is a structure:
; (make-struct worm (Posn Direction))
; interpretation: a worm with a location on the screen and a
; direction that it is heading towards

(define WORM1 (make-worm 

; big-bang wishlist:
; - render: animates the game
; - on-tick: moves the worm forward
; - on-key: controls the movement