;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |6.1 Ex105|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; ------------------------------Exercise 103------------------------------------
(define-struct spider [legs space])
; A Spider is a structure:
; (make-spider Number Number)
; interpretation: (make-spider l s) describes a spider who has l legs left
; and takes up s much space, in ft^3

(define spider1 (make-spider 8 3))
(define spider2 (make-spider 7 3))
(define spider3 (make-spider 4 1))
(define spider4 (make-spider 5 1.5))

(define-struct elephant [space])
; An Elephant is a structure:
; (make-elephant Number)
; interpretation: (make-elephant s) describes an elephant who takes up
; s much space, in ft^3

(define elephant1 (make-elephant 1000))
(define elephant2 (make-elephant 1500))
(define elephant3 (make-elephant 3000))
(define elephant4 (make-elephant 800))

(define-struct boa-constrictor [length girth])
; A Boa Constrictor is  structure:
; (make-boa-constrictor Number Number)
; interpretation: (make-boa-constrictor l g) describes a boa constrictor whose 
; length is l and girth is g

(define boa-constrictor1 (make-boa-constrictor 8 2))
(define boa-constrictor2 (make-boa-constrictor 18 4))
(define boa-constrictor3 (make-boa-constrictor 5 0.5))
(define boa-constrictor4 (make-boa-constrictor 10 3))

(define-struct armadillo [armor space])
; An Armadillo is a structure:
; (make-armadillo Number Number)
; interpretation: (make-armadillo a s) describes an armadillo whose armor strength
; is a (as a percentage) and takes up s much space, in ft^3

(define armadillo1 (make-armadillo 50 2))
(define armadillo2 (make-armadillo 80 5))
(define armadillo3 (make-armadillo 10 1))
(define armadillo4 (make-armadillo 100 7))

; A Zoo Animal is one of:
; - Spider
; - Elephant
; - Boa Constrictor
; - Armadillo

; Template:
(define (x a)
  (cond
    [(spider? a) ... (spider-legs a) ... (spider-space a)...]
    [(elephant? a) ... (elephant-space a) ...]
    [(boa-constrictor? a) ...(boa-constrictor-length a) ... (boa-constrictor-girth a) ...]
    [(armadillo? a) ... (armadillo-armor a) ... (armadillo-space a) ...]))

; Zoo Animal Number -> Boolean
; is the volume of the cage big enough for the animal?
(check-expect (fits? spider1 10) #true)
(check-expect (fits? spider2 10) #true)
(check-expect (fits? spider3 10) #true)
(check-expect (fits? spider4 10) #true)
(check-expect (fits? elephant1 10) #false)
(check-expect (fits? elephant2 10) #false)
(check-expect (fits? boa-constrictor1 10) #true)
(check-expect (fits? armadillo1 10) #true)
(define (fits? animal n)
  (cond
    [(spider? animal) (>= n (spider-space animal))]
    [(elephant? animal) (>= n (elephant-space animal))]
    [(boa-constrictor? animal) (>= n (boa-constrictor-girth animal))]
    [(armadillo? animal) (>= n (armadillo-space animal))]))

;---------------------------------Exercise 104-----------------------------------------

(define-struct automobile [number license fuel])
; An Automobile is a structure:
; (make-automobile Number String Number)
; interpretation: (make-automobile n l f) describes an automobile who can have n number of
; passengers, has a license plate l, and has f miles per gallon for fuel consumption

(define automobile1 (make-automobile 5 "AAA123" 30))
(define automobile2 (make-automobile 8 "456BCD" 25))

(define-struct van [number license fuel])
; A Van is a structure:
; (make-van Number String Number)
; interpretation: (make-van n l f) describes a van who can have n number of
; passengers, has a license plate l, and has f miles per gallon for fuel consumption

(define van1 (make-van 10 "V H3F4T6" 20))
(define van2 (make-van 12 "V H3F4T6" 18))

(define-struct bus [number license fuel])
; A Bus is a structure:
; (make-bus Number String Number)
; interpretation: (make-bus n l f) describes a bus who can have n number of
; passengers, has a license plate l, and has f miles per gallon for fuel consumption

(define bus1 (make-bus 25 "B BOS111" 25))
(define bus2 (make-bus 25 "B BOS112" 25))

(define-struct suv [number license fuel])
; An SUV is a structure:
; (make-suv Number String Number)
; interpretation: (make-suv n l f) describes an suv who can have n number of
; passengers, has a license plate l, and has f miles per gallon for fuel consumption

(define suv1 (make-suv 8 "U7U8U9" 20))
(define suv2 (make-suv 8 "WEEWOO" 19))

; A Vehicle is one of:
; - Automobile
; - Van
; - Bus
; - SUV

; Template:
(define (y v)
  (cond
    [(automobile? v) ... (automobile-number v)
                     ... (automobile-license v)
                     ... (automobile-fuel v) ...]
    [(van? v) ... (van-number v) ... (van-license v) ... (van-fuel v) ...]
    [(bus? v) ... (bus-number v) ... (bus-license v) ... (bus-fuel v) ...]
    [(suv? v) ... (suv-number v) ... (suv-license v) ... (suv-fuel v) ...]))

;-------------------------------------Exercise 105-------------------------------------------

; A Coordinate is one of: 
; – a NegativeNumber 
; interpretation on the y axis, distance from top
; – a PositiveNumber 
; interpretation on the x axis, distance from left
; – a Posn
; interpretation an ordinary Cartesian point

(define coordinate1 -1) ; this means it's 1 unit below the top of the screen on the y axis
(define coordinate2 -100) ; this means it's 100 units below the top of the screen on the y axis
(define coordinate3 2) ; this means it's 2 units to the right of the screen on the x axis
(define coordinate4 200) ; this means it's 200 units to the right of the screen on the x axis
(define coordinate5 (make-posn -1 -3)) ; this means it's at point (-1, -3) on a coordinate plane
(define coordinate6 (make-posn 10 10)) ; this means it's at point (10, 10) on a coordinate plane