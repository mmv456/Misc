;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |10.3 Ex176|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/batch-io)

; --- Exercise 171

; A List-of-string is one of:
; - '()
; - (cons String List-of-string)
; interpretation: a list of strings

(define LINE_AS_STRING
  (cons "TTT"
        (cons ""
              (cons "Put up in a place"
                    (cons "where it's easy to see"
                          '())))))
(define WORD_AS_STRING
  (cons "TTT"
        (cons "Put"
              (cons "up"
                    (cons "in"
                          '())))))

; A List-of-List-of-string (LLS) is one of:
; - '()
; - (cons List-of-string List-of-List-of-string)
; interpretation: a list of lines, eash is a list of Strings

(define line0 (cons "hello" (cons "world" '())))
(define line1 '())

(define lls0 '())
(define lls1 (cons line0 (cons line1 '())))

; LLS -> List-of-numbers
; determines the number of words on each line
(check-expect (words-on-line lls0) '())
(check-expect (words-on-line lls1) (cons 2 (cons 0 '())))
(define (words-on-line lls)
  (cond
    [(empty? lls) '()]
    [(cons? lls) (cons (length (first lls)) (words-on-line (rest lls)))]))


; ---- Exercise 172

; LLS -> String
; converts a list of lines into a string
(check-expect (collapse (cons "Hello world" '()))
              "Hello world/n ")
(check-expect (collapse (cons "Once upon a time"
                              (cons "there was a great castle" '())))
              "Once upon a time/n there was a great castle/n ")
(check-expect (collapse '()) "")
(define (collapse lls)
  (cond
    [(empty? lls) ""]
    [(cons? lls) (string-append (first lls) "/n " (collapse (rest lls)))]))

; ---- Exercise 176

; A Matrix is one of:
; - (cons Row '())
; - (cons Row Matrix)
; constraint: all rows in matrix are of the sam length

; A Row is one of:
; - '()
; - (cons Number Row)

(define ROW1 (cons 11 (cons 12 '())))
(define ROW2 (cons 21 (cons 22 '())))
(define MAT1 (cons ROW1 (cons ROW2 '())))

(define WOR1 (cons 11 (cons 21 '())))
(define WOR2 (cons 12 (cons 22 '())))
(define TAM1 (cons WOR1 (cons WOR2 '())))

; Matrix -> Matrix
; transposes the given matrix along the diagonal
(check-expect (transpose MAT1) TAM1)

(define (transpose m)
  (cond
    [(empty? (first m)) '()]
    [(cons? (first m)) (cons (first* m) (transpose (rest* m)))]))

; Matrix -> List-of-numbers
; consumes a matrix and produces the first column as a list of numbers
(check-expect (first* MAT1) WOR1)

(define (first* m)
  (cond
    [(empty? m) '()]
    [(cons? (first m)) (cons (first (first m)) (first* (rest m)))]))

; Matrix -> List-of-numbers
; consumes a matrix and removes the first column
(check-expect (rest* MAT1) (cons (cons 12 '())
                                 (cons (cons 22 '()) '())))

(define (rest* m)
  (cond
    [(empty? m) '()]
    [(cons? (first m)) (cons (rest (first m)) (rest* (rest m)))]))