;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |12.2 Ex 208|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/itunes)
(require 2htdp/batch-io)


 
; the 2htdp/itunes library documentation, part 1:

#;(define-struct track [name artist album time track# added play# played])
; A Track is a structure:
;   (make-track String String String N N Date N Date)
; interpretation An instance records in order: the track's 
; title, its producing artist, to which album it belongs, 
; its playing time in milliseconds, its position within the 
; album, the date it was added, how often it has been 
; played, and the date when it was last played

#;(define-struct date [year month day hour minute second])
; A Date is a structure:
;   (make-date N N N N N N)
; interpretation An instance records six pieces of information:
; the date's year, month (between 1 and 12 inclusive), 
; day (between 1 and 31), hour (between 0 
; and 23), minute (between 0 and 59), and 
; second (also between 0 and 59).

; Any Any Any Any Any Any Any Any -> Track or #false
; creates an instance of Track for legitimate inputs
; otherwise it produces #false
#;(define (create-track name artist album time
                      track# added play# played)
  ...)
 
; Any Any Any Any Any Any -> Date or #false
; creates an instance of Date for legitimate inputs 
; otherwise it produces #false
#;(define (create-date y mo day h m s)
  ...)
 
; String -> LTracks
; creates a list-of-tracks representation from the
; text in file-name (an XML export from iTunes)
#;(define (read-itunes-as-tracks file-name)
  ...)

; modify the following to use your chosen name
#;(define ITUNES-LOCATION "itunes.xml")

; ------ Exercise 199-------

(define DATE1 (create-date 2022 1 22 2 13 23))
(define DATE2 (create-date 2021 2 12 10 6 59))
(define DATE3 (create-date 2020 10 4 28 4 0))

(define TRACK1 (create-track "One" "Enya" "Numbers" 100 1 DATE3 21 DATE1))
(define TRACK2 (create-track "Two" "Enya" "Numbers" 200 2 DATE3 32 DATE2))
(define TRACK3 (create-track "Three" "Enya" "Numbers" 300 3 DATE2 43 DATE1))

; An LTracks is one of:
; – '()
; – (cons Track LTracks)

(define LTRACKS1 '())
(define LTRACKS2 (cons TRACK1 LTRACKS1))
(define LTRACKS3 (cons TRACK2 LTRACKS2))
(define LTRACKS4 (cons TRACK3 LTRACKS3))

; ----Exercise 200----

; LTracks -> Number
; computes the total amount of play time
(check-expect (total-time LTRACKS1) 0)
(check-expect (total-time LTRACKS2) 100)
(check-expect (total-time LTRACKS3) 300)
(check-expect (total-time LTRACKS4) 600)
(define (total-time lot)
  (cond
    [(empty? lot) 0]
    [(cons? lot) (+ (track-time (first lot))
                    (total-time (rest lot)))]))

; ----Exercise 201----

; LTracks -> List-of-Strings
; produces the list of album titles
(check-expect (select-all-album-titles LTRACKS1) '())
(check-expect (select-all-album-titles LTRACKS2)
              (list "Numbers"))
(check-expect (select-all-album-titles LTRACKS3)
              (list "Numbers" "Numbers"))
(check-expect (select-all-album-titles LTRACKS4)
              (list "Numbers" "Numbers" "Numbers"))
(define (select-all-album-titles lot)
  (cond
    [(empty? lot) '()]
    [(cons? lot) (cons (track-album (first lot))
                       (select-all-album-titles (rest lot)))]))

; String List-of-Strings -> Boolean
; does this string occur in the list of strings?
(check-expect (occurs-again? "hi" '()) #false)
(check-expect (occurs-again? "hi" (list "hi")) #true)
(check-expect (occurs-again? "hi" (list "hello")) #false)
(define (occurs-again? s los)
  (cond
    [(empty? los) #false]
    [(cons? los) (or (if (equal? s (first los))
                     #true
                     #false)
                     (occurs-again? s (rest los)))]))

; LTracks -> List-of-Strings
; produces a set of album titles (a non-repeating list)
(check-expect (create-set LTRACKS1) '())
(check-expect (create-set LTRACKS2) (list "Numbers"))
(check-expect (create-set LTRACKS3) (list "Numbers"))
(check-expect (create-set LTRACKS4) (list "Numbers"))
(define (create-set lot)
  (cond
    [(empty? lot) '()]
    [(cons? lot) (if (occurs-again? (track-album (first lot))
                                    (rest (select-all-album-titles lot)))
                     (create-set (rest lot))
                     (cons (track-album (first lot))
                           (create-set (rest lot))))]))

; LTracks -> List-of-Strings
; produces a list of unique album titles
(check-expect (select-album-titles/unique LTRACKS1)
              '())
(check-expect (select-album-titles/unique LTRACKS2)
              (list "Numbers"))
(check-expect (select-album-titles/unique LTRACKS3)
              (list "Numbers"))
(check-expect (select-album-titles/unique LTRACKS4)
              (list "Numbers"))
(define (select-album-titles/unique lot)
  (create-set lot))