;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |9.5 Ex159|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; ---- Exercises 156-158

(define HEIGHT 80)
(define WIDTH 100)
(define XSHOTS (/ WIDTH 2))

; graphical constants
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define SHOT (triangle 3 "solid" "red"))

; A List-of-shots is one of:
; - '()
; - (cons Shot List-of-shots)
; interpretation: the collection of shots fired

; A Shot is a Number
; interpretationL represents the shot's y-coordinate

; A ShotWorld is a List-of-Numbers
; interpretation: each number on such a list represents the y-coordinate of a shot

; ShotWorld -> Image
; adds the image of a shot for each y on w
; at (MID, y} to the background image
(check-expect (to-image '()) BACKGROUND)
(check-expect (to-image (cons 9 '()))
              (place-image SHOT XSHOTS 9 BACKGROUND))
(define (to-image w)
  (cond
    [(empty? w) BACKGROUND]
    [(cons? w) (place-image SHOT XSHOTS (first w) (to-image (rest w)))]))

; ShotWorld -> ShotWorld
; moves each shot on w up by one pixel
(check-expect (tock '()) '())
(check-expect (tock (cons 9 '())) (cons 8 '()))
(check-expect (tock (cons -10 (cons 9 '()))) (cons 8 '()))
(define (tock w)
  (cond
    [(empty? w) '()]
    [(cons? w) (if (clean (first w))
                   (cons (- (first w) 1) (tock (rest w)))
                   (tock (rest w)))]))

; Shot -> Boolean
; is the shot still on the canvas?
(check-expect (clean 9) #true)
(check-expect (clean 0) #true)
(check-expect (clean -1) #false)
(define (clean w)
  (>= w 0))

; ShotWorld KeyEvent -> ShotWorld
; adds a shot to the world
; if the player presses the space bar
(check-expect (keyh '() " ") (cons HEIGHT '()))
(check-expect (keyh (cons 9 '()) " ") (cons HEIGHT (cons 9 '())))
(check-expect (keyh '() "b") '())
(check-expect (keyh (cons 9 '()) "r") (cons 9 '()))
(define (keyh w ke)
  (cond
    [(key=? ke " ") (cons HEIGHT w)]
    [else w]))

; ShotWorld -> ShotWorld
; animates the game
(define (main_shotworld w0)
  (big-bang w0
    [to-draw to-image]
    [on-tick tock]
    [on-key keyh]))

; ---- Exercise 159

; HELPER FUNCTIONS
; N Image -> Image
; produces a column of n copies of img
(check-expect (col 2 (square 5 "outline" "blue"))
              (overlay/xy (square 5 "outline" "blue")
                          0 5
                          (square 5 "outline" "blue")))
(define (col n img)
  (cond
    [(zero? (- n 1)) img]
    [(positive? n) (overlay/xy img 0 (image-height img) (col (- n 1) img))]))

; N Image -> Image
; produces a row of n copies of img
(check-expect (row 2 (square 5 "outline" "blue"))
              (overlay/xy (square 5 "outline" "blue")
                          5 0
                          (square 5 "outline" "blue")))
(define (row n img)
  (cond
    [(zero? (- n 1)) img]
    [(positive? n) (overlay/xy img (image-width img) 0 (row (- n 1) img))]))


; GRAPHICAL CONSTANTS
(define LECTURE-HALL (place-image (row 8 (col 18 (square 10 "outline" "black")))
                                  40 90
                                  (rectangle 81 181 "outline" "black")))
(define BALLOON (circle 4 "solid" "red"))

; DEFINITIONS
; A List-of-Posns is one of:
; - '()
; - (cons Posn List-of-Posns)
; interpretation: A list of posns whose coordinates fit the dimensions of the lecture hall
(define lop1 '())
(define lop2 (cons (make-posn 10 20) lop1))
(define lop3 (cons (make-posn 15 34) lop2))
(define lop4 (cons (make-posn 52 155) lop3))
(define lop5 (cons (make-posn 79 123) lop4))

(define-struct pair [initial on-screen])
; A Pair is a structure (make-pair List-of-Posns List-of-Posns)
; interpretation: (make-pair i o) means there is i total balloons to be thrown and o total
; balloons already thrown

; A BalloonWorld is a Pair
; interpretation: two lists that represent the balloons' locations in the lecture hall

(define bw1 (make-pair lop5 '()))
(define bw2 (make-pair lop5 (cons (make-posn 79 123) '())))
(define bw3 (make-pair lop5 (cons (make-posn 52 155)
                       (cons (make-posn 79 123) '()))))
(define bw4 (make-pair lop5 (cons (make-posn 15 34)
                       (cons (make-posn 52 155)
                       (cons (make-posn 79 123) '())))))
(define bw5 (make-pair lop5 (cons (make-posn 10 20)
                       (cons (make-posn 15 34)
                       (cons (make-posn 52 155)
                       (cons (make-posn 79 123) '()))))))

; BalloonWorld -> Image
; adds the image of a balloon that's on-screen onto the lecture hall
(check-expect (render bw1) LECTURE-HALL)
(check-expect (render bw2) (place-image BALLOON 79 123 LECTURE-HALL))
(check-expect (render bw3) (place-image BALLOON 52 155
                                        (place-image BALLOON 79 123 LECTURE-HALL)))
(check-expect (render bw4) (place-image BALLOON 15 34
                                        (place-image BALLOON 52 155
                                        (place-image BALLOON 79 123 LECTURE-HALL))))
(check-expect (render bw5) (place-image BALLOON 10 20
                                        (place-image BALLOON 15 34
                                        (place-image BALLOON 52 155
                                        (place-image BALLOON 79 123 LECTURE-HALL)))))
(define (render bw)
  (cond
    [(empty? (pair-on-screen bw)) LECTURE-HALL]
    [(cons? (pair-on-screen bw)) (place-image BALLOON
                             (get-xy (first (pair-on-screen bw)) "x")
                             (get-xy (first (pair-on-screen bw)) "y")
                             (render (make-pair (pair-initial bw)
                                                (rest (pair-on-screen bw)))))]))

; Posn String -> Number
; gets the x or y coordinates of the balloon
(check-expect (get-xy (make-posn 3 4) "x") 3)
(check-expect (get-xy (make-posn 3 4) "y") 4)

(define (get-xy p s)
  (cond
    [(string=? s "x") (posn-x p)]
    [(string=? s "y") (posn-y p)]))

; BalloonWorld -> BalloonWorld
; drops a balloon at a rate of one second
(check-expect (tockb bw1) bw2)
(check-expect (tockb bw2) bw3)
(check-expect (tockb bw3) bw4)
(check-expect (tockb bw4) bw5)
(check-expect (tockb bw5) bw5)

(define (tockb bw)
  (make-pair (pair-initial bw)
             (add1 (pair-initial bw) (pair-on-screen bw))))

; List-of-Posns List-of-Posns -> List-os-Posns
; adds one more balloon from the initial list to the on-screen list
(check-expect (add1 lop1 '()) '())
(check-expect (add1 lop2 '()) (cons (make-posn 10 20) '()))
(define (add1 initial on-screen)
  (if (= (length initial) (length on-screen))
      on-screen
      (if (posn-in-list? initial on-screen)
          ...