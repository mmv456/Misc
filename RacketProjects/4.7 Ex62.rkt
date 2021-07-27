;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |4.7 TBD Last Door Problem|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; A DoorState is one of:
; - locked
; - closed
; - open

(define locked "locked")
(define closed "closed")
(define open "open")

; DoorState -> DoorState
; closes the door during one tick
(check-expect (door-closer locked) locked)
(check-expect (door-closer closed) closed)
(check-expect (door-closer open) closed)
(define (door-closer x)
  (cond
    [(string=? x locked) locked]
    [(string=? x closed) closed]
    [(string=? x open) closed]))

; DoorState KeyEvent -> DoorState
; creates actions on the door in response to pressing a key
(check-expect (door-action locked "u") closed)
(check-expect (door-action closed "l") locked)
(check-expect (door-action closed " ") open)
(check-expect (door-action open "u") open)
(check-expect (door-action open "a") open)
(define (door-action x ke)
  (cond
    [(and (string=? x locked) (string=? ke "u")) closed]
    [(and (string=? x closed) (string=? ke "l")) locked]
    [(and (string=? x closed) (string=? ke " ")) open]
    [else x]))

; DoorState -> Image
; renders the current state into an image
(check-expect (door-render locked) (text locked 40 "red"))
(check-expect (door-render closed) (text closed 40 "red"))
(check-expect (door-render open) (text open 40 "red"))
(define (door-render x)
  (cond
    [(string=? x locked) (text locked 40 "red")]
    [(string=? x closed) (text closed 40 "red")]
    [(string=? x open) (text open 40 "red")]))

; DoorState -> DoorState
; simulates a door with an autmatic door closer
(define (door-simulation initial-state)
  (big-bang initial-state
    [on-tick door-closer 3]
    [on-key door-action]
    [to-draw door-render]))