;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |4.6 Ex58|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define low-tax-rate 0.00)
(define mid-tax-rate 0.05)
(define high-tax-rate 0.08)

(define lower-range 1000)
(define higher-range 10000)

; A Price falls into one of three intervals: 
; — 0 through 999
; — 1,000 through 9,999
; — 10,000 and above.
; interpretation the price of an item  

; Price -> Number
; computes the amount of tax charged for p
(check-expect (sales-tax 0) 0)
(check-expect (sales-tax 537) 0)
(check-expect (sales-tax 1000)(* 0.05 1000))
(check-expect (sales-tax 1282) (* 0.05 1282))
(check-expect (sales-tax 10000) (* 0.08 10000))
(check-expect (sales-tax 12017) (* 0.08 12017))
(define (sales-tax p)
  (cond
    [(and (<= 0 p) (< p lower-range)) (* low-tax-rate p)]
    [(and (<= lower-range p) (< p higher-range)) (* mid-tax-rate p)]
    [(<= higher-range p) (* high-tax-rate p)]))