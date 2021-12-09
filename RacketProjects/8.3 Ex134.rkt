;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |8.3 Ex134|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; List-of-names -> Boolean
; determines whether "Flatt" is on a list-of-names
(check-expect (contains-flatt? '()) #false)
(check-expect (contains-flatt? (cons "Find" '()))
              #false)
(check-expect (contains-flatt? (cons "Flatt" '()))
              #true)
(check-expect
 (contains-flatt?
  (cons "A" (cons "Flatt" (cons "C" '()))))
 #true)
(check-expect
 (contains-flatt?
  (cons "A" (cons "Find" (cons "C" '()))))
 #false)
(check-expect (contains-flatt?
               (cons "Fagan"
                     (cons "Findler"
                           (cons "Fisler"
                                 (cons "Flanagan"
                                       (cons "Flatt"
                                             (cons "Felleisen"
                                                   (cons "Friedman" '()))))))))
              #true)

(define (contains-flatt? lon)
  (cond
    [(empty? lon) #false]
    [(cons? lon) (or (string=? (first lon) "Flatt")
                     (contains-flatt? (rest lon)))]))

; -- Exercise 134

; String List-Of-Strings -> Boolean
; determines whether a given string occur in the list of strings
(check-expect (contains? "a" '()) #false)
(check-expect (contains? "a" (cons "a" '())) #true)
(check-expect (contains? "a" (cons "b" '())) #false)
(check-expect (contains? "a" (cons "2" (cons "Amy" (cons "a" '())))) #true)
(check-expect (contains? "a" (cons "2" (cons "Amy" (cons "_a_" '())))) #false)

(define (contains? s los)
  (cond
    [(empty? los) #false]
    [(cons? los) (or (string=? s (first los))
                     (contains? s (rest los)))]))