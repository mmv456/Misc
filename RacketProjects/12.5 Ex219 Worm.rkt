;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |12.5 Ex219 Worm|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; ----Exercises 217 and 218----

(define WIDTH 100)
(define HEIGHT 100)
(define MT-SCENE (empty-scene WIDTH HEIGHT))

(define HEAD (circle 3 "solid" "green"))
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

(define-struct segment [location direction])
; A Segment is a structure:
; (make-struct segment (Posn Direction))
; interpretation: a segment with a location on the screen and a
; direction that it is heading towards

(define SEG1 (make-segment (make-posn 0 0) UP))
(define SEG2 (make-segment (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                           UP))
(define SEG3 (make-segment (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                           DOWN))
(define SEG4 (make-segment (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                           LEFT))
(define SEG5 (make-segment (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                           RIGHT))

; A Worm is one of:
; - '()
; - (cons Segment Worm)
; interpretation: a possibly empty sequence of connected
; segments. Commected means that the coordinates differ from the
; closest neighbors by at most one direction

(define WORM1 '())
(define WORM2 (cons SEG2 WORM1))
(define WORM3 (cons SEG2
                    (cons (make-segment
                           (make-posn (/ WIDTH 2)
                                      (+ (/ HEIGHT 2) WORM-DIAMETER))
                           UP)
                          WORM1)))
(define WORM4 (cons SEG2
                    (cons (make-segment
                           (make-posn (/ WIDTH 2)
                                      (+ (/ HEIGHT 2) WORM-DIAMETER))
                           UP)
                          (cons (make-segment
                                 (make-posn (- (/ WIDTH 2) WORM-DIAMETER)
                                            (+ WORM-DIAMETER (/ HEIGHT 2)))
                                 RIGHT)
                                WORM1))))
                                 

; big-bang wishlist:
; -X- get: gets the x or y coordinate of a segment
; -X- render: renders the image
; -X- move: moves the segment according to its direction
; -X- add-segment: adds a new segment to the worm
; -X- remove-last: removes the last segment
; -X- tock: moves the worm forward one diameter
; -X- edit-direction: changes the segment's direction
; -X- change: controls the movement of the worm
; -X- main: animates the game
; -X- segment-hit-border?: is any segment hitting the border?
; -X- hit-border?: does the worm hit the border?
; -X- make-list-of-locations: make a list of posns of segments
; -X- hit-itself?: did the worm hit itself?
; -X- render-stop: renders the image when the game is over

; Segment -> Number
; gets the x or y coordinate of a segment
(check-expect (get SEG1 "x") 0)
(check-expect (get SEG1 "y") 0)
(define (get s c)
  (cond
    [(equal? c "x") (posn-x (segment-location s))]
    [(equal? c "y") (posn-y (segment-location s))]))

; Worm -> Image
; renders the game
(check-expect (render WORM1) MT-SCENE)
(check-expect (render WORM2) (place-image HEAD
                                          (/ WIDTH 2) (/ HEIGHT 2)
                                          MT-SCENE))
(check-expect (render WORM3) (place-image HEAD
                                          (/ WIDTH 2) (/ HEIGHT 2)
                                          (place-image HEAD
                                                       (/ WIDTH 2)
                                                       (+ (/ HEIGHT 2) WORM-DIAMETER)
                                                       MT-SCENE)))
(check-expect (render WORM4) (place-image HEAD
                                          (/ WIDTH 2) (/ HEIGHT 2)
                                          (place-image HEAD
                                                       (/ WIDTH 2) (+ (/ HEIGHT 2) WORM-DIAMETER)
                                                       (place-image HEAD
                                                                    (- (/ WIDTH 2) WORM-DIAMETER) (+ WORM-DIAMETER (/ HEIGHT 2))
                                                                    MT-SCENE))))
(define (render w)
  (cond
    [(empty? w) MT-SCENE]
    [(cons? w) (place-image HEAD
                            (get (first w) "x") (get (first w) "y")
                            (render (rest w)))]))

; Worm -> Worm
; moves the segment according to its direction
(check-expect (move SEG1) (make-segment
                           (make-posn 0 (- 0 WORM-DIAMETER))
                           UP))
(check-expect (move SEG2) (make-segment
                           (make-posn (/ WIDTH 2) (- (/ HEIGHT 2) WORM-DIAMETER))
                           UP))
(check-expect (move SEG3) (make-segment
                           (make-posn (/ WIDTH 2) (+ (/ HEIGHT 2) WORM-DIAMETER))
                           DOWN))
(check-expect (move SEG4) (make-segment
                           (make-posn (- (/ WIDTH 2) WORM-DIAMETER) (/ HEIGHT 2))
                           LEFT))
(check-expect (move SEG5) (make-segment
                           (make-posn (+ (/ WIDTH 2) WORM-DIAMETER) (/ HEIGHT 2))
                           RIGHT))
(define (move w)
  (cond
    [(equal? (segment-direction w) UP) (make-segment (make-posn (get w "x")
                                                                (- (get w "y") WORM-DIAMETER))
                                                     UP)]
    [(equal? (segment-direction w) DOWN) (make-segment (make-posn (get w "x")
                                                                  (+ (get w "y") WORM-DIAMETER))
                                                       DOWN)]
    [(equal? (segment-direction w) LEFT) (make-segment (make-posn (- (get w "x") WORM-DIAMETER)
                                                                  (get w "y"))
                                                       LEFT)]
    [(equal? (segment-direction w) RIGHT) (make-segment (make-posn (+ (get w "x") WORM-DIAMETER)
                                                                   (get w "y"))
                                                        RIGHT)]))

; Worm -> Worm
; adds a new segment to the worm
(check-expect (add-segment WORM1) WORM1)
(check-expect (add-segment WORM2) (cons (move SEG2)
                                        WORM2))
(check-expect (add-segment WORM3) (cons (move SEG2)
                                        WORM3))
(check-expect (add-segment WORM4) (cons (move SEG2)
                                        WORM4))
(define (add-segment w)
  (cond
    [(empty? w) w]
    [(cons? w) (cons (move (first w))
                     w)]))

; Worm -> Worm
; removes the last segment
(check-expect (remove-last WORM1) WORM1)
(check-expect (remove-last WORM2) '())
(check-expect (remove-last WORM3) (cons SEG2 '()))
(check-expect (remove-last WORM4) (cons SEG2
                                        (cons (make-segment
                                               (make-posn (/ WIDTH 2)
                                                          (+ (/ HEIGHT 2) WORM-DIAMETER))
                                               UP) '())))
(define (remove-last w)
  (cond
    [(empty? w) '()]
    [(empty? (rest w)) '()]
    [(cons? (rest w)) (cons (first w)
                            (remove-last (rest w)))]))


; Worm -> Worm
; moves the worm forward one diameter
(check-expect (tock WORM1) WORM1)
(check-expect (tock WORM2) (cons
                            (make-segment (make-posn (/ WIDTH 2) (- (/ HEIGHT 2) WORM-DIAMETER))
                                          UP)
                            '()))
(check-expect (tock WORM3) (cons (make-segment (make-posn (/ WIDTH 2) (- (/ HEIGHT 2) WORM-DIAMETER))
                                               UP)
                                 (cons SEG2 '())))
(check-expect (tock WORM4) (cons (make-segment (make-posn (/ WIDTH 2) (- (/ HEIGHT 2) WORM-DIAMETER))
                                               UP)
                                 (cons SEG2
                                       (cons (make-segment
                                              (make-posn (/ WIDTH 2)
                                                         (+ (/ HEIGHT 2) WORM-DIAMETER))
                                              UP) '()))))
(define (tock w)
  (cond
    [(empty? w) '()]
    [(cons? w) (remove-last (add-segment w))]))

; Segment -> Segment
; changes the segment's direction
(check-expect (edit-direction SEG1 "up")
              (make-segment (make-posn 0 0) UP))
(check-expect (edit-direction SEG1 "down")
              (make-segment (make-posn 0 0) DOWN))
(check-expect (edit-direction SEG1 "left")
              (make-segment (make-posn 0 0) LEFT))
(check-expect (edit-direction SEG1 "right")
              (make-segment (make-posn 0 0) RIGHT))
(check-expect (edit-direction SEG1 "a") SEG1)
(define (edit-direction s ke)
  (cond
    [(equal? ke "up") (make-segment (make-posn (get s "x")
                                               (get s "y"))
                                    UP)]
    [(equal? ke "down") (make-segment (make-posn (get s "x")
                                                 (get s "y"))
                                      DOWN)]
    [(equal? ke "left") (make-segment (make-posn (get s "x")
                                                 (get s "y"))
                                      LEFT)]
    [(equal? ke "right") (make-segment (make-posn (get s "x")
                                                  (get s "y"))
                                       RIGHT)]
    [else s]))

; Worm Key-Expression -> Worm
; changes the direction of the worm based on the key press
(check-expect (change WORM1 "up")
              WORM1)
(check-expect (change WORM2 "up")
              (cons (make-segment (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                                  UP)
                    '()))
(check-expect (change WORM2 "down")
              (cons (make-segment (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                                  DOWN)
                    '()))
(check-expect (change WORM2 "left")
              (cons (make-segment (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                                  LEFT)
                    '()))
(check-expect (change WORM2 "right")
              (cons (make-segment (make-posn (/ WIDTH 2) (/ HEIGHT 2))
                                  RIGHT)
                    '()))
(check-expect (change WORM2 "a") WORM2)
(define (change w ke)
  (cond
    [(empty? w) '()]
    [(cons? w) (cons (edit-direction (first w) ke)
                     (rest w))]))

; Segment -> Boolean
; is any segment hitting the border?
(check-expect (segment-hit-border? SEG1) #true)
(check-expect (segment-hit-border? SEG2) #false)
(define (segment-hit-border? w)
  (if (or (<= (get w "x") 0)
          (>= (get w "x") WIDTH)
          (<= (get w "y") 0)
          (>= (get w "y") HEIGHT))
      #true
      #false))

; Worm -> Boolean
; does the worm hit the border?
(check-expect (hit-border? WORM1) #false)
(check-expect (hit-border? WORM2) #false)
(check-expect (hit-border? (cons (make-segment (make-posn 0 10)
                                               LEFT)
                                 (cons (make-segment (make-posn WORM-DIAMETER 10)
                                                     LEFT)
                                       '())))
              #true)
(define (hit-border? w)
  (cond
    [(empty? w) #false]
    [(cons? w) (or (segment-hit-border? (first w))
                   (hit-border? (rest w)))]))

; Worm -> List-of-Posns
; make a list of posns of segments
(check-expect (make-list-of-locations WORM1) '())
(check-expect (make-list-of-locations WORM2)
              (list (make-posn (/ WIDTH 2)
                               (/ HEIGHT 2))))
(define (make-list-of-locations w)
  (cond
    [(empty? w) '()]
    [(cons? w) (cons (make-posn (get (first w) "x")
                                (get (first w) "y"))
                     (make-list-of-locations (rest w)))]))

; Worm -> Boolean
; did the worm hit itself?
(check-expect (hit-itself? WORM1) #false)
(check-expect (hit-itself? (cons (make-segment (make-posn 10 10)
                                               UP)
                                 '()))
              #false)
(check-expect (hit-itself? (cons (make-segment (make-posn 10 10)
                                               UP)
                                 (cons (make-segment (make-posn 10 10)
                                                     LEFT)
                                       '())))
              #true)
(define (hit-itself? w)
  (cond
    [(empty? w) #false]
    [(empty? (rest w)) #false]
    [(cons? (rest w)) (member? (make-posn (get (first w) "x")
                                          (get (first w) "y"))
                               (make-list-of-locations (rest w)))]))

; Worm -> Image
; renders the image when the game is over
; either when the worm hits the border or hits itself
(check-expect (render-stop (cons (make-segment (make-posn 0 10)
                                               LEFT)
                                 (cons (make-segment (make-posn WORM-DIAMETER 10)
                                                     LEFT)
                                       '())))
              (place-image (text "worm hit border" 8 "red")
                           30 (- HEIGHT 10)
                           (render (cons (make-segment (make-posn 0 10)
                                                       LEFT)
                                         (cons (make-segment (make-posn WORM-DIAMETER 10)
                                                             LEFT)
                                               '())))))
(check-expect (render-stop (cons (make-segment (make-posn 10 10)
                                               UP)
                                 (cons (make-segment (make-posn 10 10)
                                                     LEFT)
                                       '())))
              (place-image (text "worm hit itself" 8 "red")
                           30 (- HEIGHT 10)
                           (render (cons (make-segment (make-posn 10 10)
                                                       UP)
                                         (cons (make-segment (make-posn 10 10)
                                                             LEFT)
                                               '())))))
(define (render-stop w)
  (cond
    [(hit-border? w) (place-image (text "worm hit border" 8 "red")
                                  30 (- HEIGHT 10)
                                  (render w))]
    [(hit-itself? w) (place-image (text "worm hit itself" 8 "red")
                                  30 (- HEIGHT 10)
                                  (render w))]))
  

; Worm -> Worm
; animates the game
(define (main w)
  (big-bang w
    [to-draw render]
    [on-tick tock 0.5]
    [on-key change]
    [stop-when hit-border? render-stop]))