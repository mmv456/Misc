;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |8.1 Ex131|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; ---- Exercise 129

(cons 'Mercury'
      (cons 'Venus'
            (cons 'Earth'
                  (cons 'Mars'
                        (cons 'Jupiter'
                              (cons 'Saturn'
                                    (cons 'Uranus'
                                          (cons 'Neptune'
                                                (cons 'Pluto' '())))))))))

(cons 'Steak'
      (cons 'French Fries'
            (cons 'Beans'
                  (cons 'Bread'
                        (cons 'Water'
                              (cons 'Brie Cheese'
                                    (cons 'Ice Cream' '())))))))

(cons 'Violet'
      (cons 'Indigo'
            (cons 'Blue'
                  (cons 'Green'
                        (cons 'Yellow'
                              (cons 'Orange'
                                    (cons 'Red' '())))))))

; ---- Exercise 130

; A List-of-names is one of:
; - '()
; - (cons String List-of-names)
; interpretation: a list of invitees by last name

(cons "LN1"
      (cons "LN2"
            (cons "LN3"
                  (cons "LN4"
                        (cons "LN5" '())))))

; ---- Exercise 131

; A List-of-booleans is one of:
; - '()
; - (cons Boolean List-of-booleans)
; - interpretation: a list of booleans