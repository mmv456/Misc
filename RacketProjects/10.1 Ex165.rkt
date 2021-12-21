;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |10.1 Ex165|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; -----Exercises 161 and 162

(define WAGE 12)

; Number -> Number
; computes the wage for h hours of work
(check-expect (wage 10) 120)

(define (wage h)
  (* WAGE h))

; A List-of-numbers is one of:
; - '()
; - (cons Number List-of-numbers)

; List-of-numbers -> List-of-numbers
; computes the weekly wages for the weekly hours
(check-expect (wage* '()) '())
(check-expect (wage* (cons 28 '())) (cons (* WAGE 28) '()))
(check-expect (wage* (cons 4 (cons 2 '()))) (cons (* WAGE 4) (cons (* WAGE 2) '())))
(check-error (wage* (cons 120 '())) "overtime: hours worked exceeds 100 hours")

(define (wage* hrs)
  (cond
    [(empty? hrs) '()]
    [(cons? hrs) (cond
                   [(> (first hrs) 100) (error 'overtime "hours worked exceeds 100 hours")]
                   [else (cons (wage (first hrs)) (wage* (rest hrs)))])]))

; ------Exercise 163

; Number -> Number
; converts the Fahrenheight temp to Celsius
(check-expect (convert 32) 0)

(define (convert x)
  (* (/ 5 9) (- x 32)))

; A List-of-Measurements is one of:
; - '()
; - (cons Number List-of-Measurement)
; interpretation: a list of measurements in Fahrenheit or Celsius

; List-of-Measurements -> List of Measurements
; converts a list from Fahrenheit to Celsius
(check-expect (convertFC '()) '())
(check-expect (convertFC (cons 32 '())) (cons 0 '()))

(define (convertFC lom)
  (cond
    [(empty? lom) '()]
    [(cons? lom) (cons (convert (first lom)) (convertFC (rest lom)))]))

; ------Exercise 164

(define US-EURO-RATE 0.89)

; Number -> Number
; converts the US $ to Euro pound
(check-expect (convert-rate 10) (* 10 US-EURO-RATE))

(define (convert-rate x)
  (* x US-EURO-RATE))

; A List-of-$ is one of:
; - '()
; - (cons Number List-of-US)
; interpretation: a list of $ amounts

; List-of-$ -> List-of-$
; converts a list of US $ amounts to a list of Euro pound amounts
(check-expect (convert-euro '()) '())
(check-expect (convert-euro (cons 10 '())) (cons (* 10 US-EURO-RATE) '()))

(define (convert-euro loa)
  (cond
    [(empty? loa) '()]
    [(cons? loa) (cons (convert-rate (first loa)) (convert-euro (rest loa)))]))

; -----Exercise 165

(define WORD "robot")
(define SUBSTITUTE "r2d2")

; String -> Boolean
; does the string equal another string?
(check-expect (s=s? "robot") #true)
(check-expect (s=s? "rbt") #false)

(define (s=s? x)
  (string=? x WORD))

; A List-of-words is one of:
; - '()
; - (cons String List-of-words)
; interpretation: a list of strings (toy descriptions)

; List-of-words -> List-of-words
; replaces a specific word with a substitute
(check-expect (substitute '()) '())
(check-expect (substitute (cons "robot" '())) (cons "r2d2" '()))
(check-expect (substitute (cons "r2d2" '())) (cons "r2d2" '()))
(check-expect (substitute (cons "dog" '())) (cons "dog" '()))

(define (substitute low)
  (cond
    [(empty? low) '()]
    [(cons? low) (cond
                   [(s=s? (first low)) (cons SUBSTITUTE (substitute (rest low)))]
                   [else (cons (first low) (substitute (rest low)))])]))