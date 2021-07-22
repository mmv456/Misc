;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |2.4 Ex30|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define base-attendees 120)
(define base-ticket-price 5.0)
(define price-change-constant 0.1)
(define attendee-change 15)

(define fixed-cost 180)
(define variable-cost 0.04)

(define price-sensitivity (/ attendee-change price-change-constant))

; Number -> Number
; Returns the amount of profit generated by ticket price
(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

; Number -> Number
; Gives the number of attendees based on ticket price
(define (attendees ticket-price)
  (- base-attendees
     (* (- ticket-price base-ticket-price)
        price-sensitivity)))

; Number -> Number
; How much money generated by ticket price
(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

; Number -> Number
; The cost of operating given the ticket price
(define (cost ticket-price)
  (+ fixed-cost (* variable-cost (attendees ticket-price))))

(profit 1)
(profit 2)
(profit 3)
(profit 4)
(profit 5)