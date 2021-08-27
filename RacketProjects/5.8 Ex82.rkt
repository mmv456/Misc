;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |5.8 Ex82|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;Ex81
(define-struct time [hours minutes seconds])
; Time is a structure:
; (make-time Number Number Number)
; interpretation: represents points in time since midnight

(define time1 (make-time 12 30 2))
(define time2 (make-time 0 0 5))

; Time -> Number
; computes seconds passed since midnight given the time
(check-expect (time->seconds time1) 45002)
(check-expect (time->seconds time2) 5)
(define (time->seconds t)
  (+ (* (time-hours t) 3600)
     (* (time-minutes t) 60)
     (time-seconds t)))
;-----------------------------------------------
; Ex82
; A 1String is a String of length 1, 
; including
; – "\\" (the backslash),
; – " " (the space bar), 
; – "\t" (tab),
; – "\r" (return), and 
; – "\b" (backspace).
; interpretation represents keys on the keyboard

(define-struct 3-letter-word [first second third])
; A 3-letter-word is a structure:
; (make-3-letter-word 1String 1String 1String)
; interpretation: string "a" through "z" plus "#false"
(define 3lw1 (make-3-letter-word "a" "b" "c"))
(define 3lw2 (make-3-letter-word "a" "c" "#false"))
(define 3lw3 (make-3-letter-word "z" "b" "c"))

; 3-letter-word 3-letter-word -> 3-letter-word
; produces a word that indicates where the given ones agree (or not)
; retaining the content if they agree, or putting #false if not
(check-expect (compare-word 3lw1 3lw2)
              (make-3-letter-word "a" #false #false))
(check-expect (compare-word 3lw1 3lw3)
              (make-3-letter-word #false "b" "c"))
(define (compare-word w1 w2)
  (make-3-letter-word (1Stringtest (3-letter-word-first w1)
                                   (3-letter-word-first w2))
                      (1Stringtest (3-letter-word-second w1)
                                   (3-letter-word-second w2))
                      (1Stringtest (3-letter-word-third w1)
                                   (3-letter-word-third w2))))

; 1String 1String -> 1String
; checks if the 1Strings are equal, producing the 1String, otherwise
; producing #false
(check-expect (1Stringtest "a" "a") "a")
(check-expect (1Stringtest "a" "c") #false)
(define (1Stringtest x y)
  (if (equal? x y)
      x
      #false))