;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |12.5 Ex219 Worm|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; ----Exercises 215 and 216----

(define WIDTH 100)
(define HEIGHT 100)
(define MT-SCENE (empty-scene WIDTH HEIGHT))

(define HEAD (circle 3 "solid" "green"))
(define FOOD (circle 3 "solid" "orange"))
(define TAIL (circle 3 "solid" "red"))
(define WORM-DIAMETER 6)

; A Direction is one of:
; - "Up"
; - "Down"
; - "Left"
; - "Right"
; interpretation: a direction for the worm to go to

(define UP "Up")
(define DOWN "Down")
(define LEFT "Left")
(define RIGHT "Right")

(define-struct worm [location direction])
; A Worm is a structure:
; (make-struct worm (Posn Direction))
; interpretation: a worm with a location on the screen and a
; direction that it is heading towards

(define WORM1 (make-worm (make-posn 0 0) UP))
(define WORM2 (make-worm (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                         UP))
(define WORM3 (make-worm (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                         DOWN))
(define WORM4 (make-worm (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                         LEFT))
(define WORM5 (make-worm (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                         RIGHT))

; big-bang wishlist:
; -X- render: renders the image
; -X- tock: moves the worm forward one diameter
; -X- change: controls the movement of the worm
; -X- main: animates the game
; -X- hit-border?: does the worm hit the border?
; -X- render-border-stop: renders the image when the game is over

; Worm -> Number
; gets the x or y value of the posn of the worm
(check-expect (get WORM1 "x") 0)
(check-expect (get WORM1 "y") 0)
(define (get w c)
  (cond
    [(equal? c "x") (posn-x (worm-location w))]
    [(equal? c "y") (posn-y (worm-location w))]))

; Worm -> Image
; renders the image
(check-expect (render WORM1)
              (place-image HEAD 0 0 MT-SCENE))
(check-expect (render WORM2)
              (place-image HEAD (/ WIDTH 2) (/ HEIGHT 2) MT-SCENE))
(check-expect (render WORM3)
              (place-image HEAD (/ WIDTH 2) (/ HEIGHT 2) MT-SCENE))
(check-expect (render WORM4)
              (place-image HEAD (/ WIDTH 2) (/ HEIGHT 2) MT-SCENE))
(check-expect (render WORM5)
              (place-image HEAD (/ WIDTH 2) (/ HEIGHT 2) MT-SCENE))
(define (render w)
  (place-image HEAD (get w "x") (get w "y") MT-SCENE))

; Worm -> Worm
; moves the worm forward one diameter
(check-expect (tock WORM1) (make-worm
                            (make-posn 0 (- 0 WORM-DIAMETER))
                            UP))
(check-expect (tock WORM2) (make-worm
                            (make-posn (/ WIDTH 2) (- (/ HEIGHT 2) WORM-DIAMETER))
                            UP))
(check-expect (tock WORM3) (make-worm
                            (make-posn (/ WIDTH 2) (+ (/ HEIGHT 2) WORM-DIAMETER))
                            DOWN))
(check-expect (tock WORM4) (make-worm
                            (make-posn (- (/ WIDTH 2) WORM-DIAMETER) (/ HEIGHT 2))
                            LEFT))
(check-expect (tock WORM5) (make-worm
                            (make-posn (+ (/ WIDTH 2) WORM-DIAMETER) (/ HEIGHT 2))
                            RIGHT))
(define (tock w)
  (cond
    [(equal? (worm-direction w) UP) (make-worm (make-posn (get w "x")
                                                          (- (get w "y") WORM-DIAMETER))
                                               UP)]
    [(equal? (worm-direction w) DOWN) (make-worm (make-posn (get w "x")
                                                            (+ (get w "y") WORM-DIAMETER))
                                                 DOWN)]
    [(equal? (worm-direction w) LEFT) (make-worm (make-posn (- (get w "x") WORM-DIAMETER)
                                                            (get w "y"))
                                                 LEFT)]
    [(equal? (worm-direction w) RIGHT) (make-worm (make-posn (+ (get w "x") WORM-DIAMETER)
                                                             (get w "y"))
                                                  RIGHT)]))

; Worm Key-Expression -> Worm
; changes the direction of the worm based on the key press
(check-expect (change WORM1 "up")
              (make-worm (make-posn 0 0) UP))
(check-expect (change WORM1 "down")
              (make-worm (make-posn 0 0) DOWN))
(check-expect (change WORM1 "left")
              (make-worm (make-posn 0 0) LEFT))
(check-expect (change WORM1 "right")
              (make-worm (make-posn 0 0) RIGHT))
(check-expect (change WORM1 "a") WORM1)
(define (change w ke)
  (cond
    [(equal? ke "up") (make-worm (make-posn (get w "x")
                                            (get w "y"))
                                 UP)]
    [(equal? ke "down") (make-worm (make-posn (get w "x")
                                            (get w "y"))
                                 DOWN)]
    [(equal? ke "left") (make-worm (make-posn (get w "x")
                                            (get w "y"))
                                 LEFT)]
    [(equal? ke "right") (make-worm (make-posn (get w "x")
                                            (get w "y"))
                                 RIGHT)]
    [else w]))

; Worm -> Boolean
; does the worm hit the border?
(check-expect (hit-border? WORM1) #true)
(check-expect (hit-border? WORM2) #false)
(define (hit-border? w)
  (if (or (<= (get w "x") 0)
          (>= (get w "x") WIDTH)
          (<= (get w "y") 0)
          (>= (get w "y") HEIGHT))
      #true
      #false))

; Worm -> Image
; renders the image when the game is over
(check-expect (render-border-stop WORM1)
              (place-image (text "worm hit border" 8 "red")
                           30 (- HEIGHT 10)
                           (render WORM1)))
(define (render-border-stop w)
  (place-image (text "worm hit border" 8 "red")
               30 (- HEIGHT 10)
               (render w)))

; Worm -> Worm
; animates the game
(define (main w)
  (big-bang w
    [to-draw render]
    [on-tick tock 0.5]
    [on-key change]
    [stop-when hit-border? render-border-stop]))