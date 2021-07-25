;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |4.4 Ex52|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; A WorldState falls into one of three intervals:
; - between 0 and close
; - between close and height
; - below height
; interpretation: number of pixels between the top and the UFO

(define width 300) ; distances in terms of piselx
(define height 100)
(define close (/ height 3))
(define mt-scene (empty-scene width height))
(define ufo (overlay (circle 10 "solid" "green")
                     (circle 20 "solid" "black")))

; WorldState -> WorldState
(define (main y0)
  (big-bang y0
    [on-tick next]
    [to-draw render/status]))

; WorldState -> WorldState
; computes the next location of the ufo
(check-expect (next 11) 14)
(define (next y)
  (+ y 3))

; WorldState -> Image
; places the ufo at given height into the center of mt-scene
(check-expect (render 11)
              (place-image ufo (/ width 2) 11 mt-scene))
(define (render y)
  (place-image ufo (/ width 2) y mt-scene))

; WorldState -> Image
; adds a status line to the scene created by render
(check-expect (render/status 10)
              (place-image (text "descending" 11 "green")
                           50 20
                           (render 10)))
(define (render/status y)
  (place-image (cond
                 [(<= 0 y close)
                  (text "descending" 11 "green")]
                 [(and (< close y) (<= y height))
                  (text "closing in" 11 "yellow")]
                 [(> y height)
                  (text "landed" 11 "red")])
               50 20 (render y)))