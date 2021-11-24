;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |6.1 Ex98 TBD|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define SCENE-WIDTH 500)
(define SCENE-HEIGHT 500)
(define MT-SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))

(define ACTORS-SIZE 60)

(define TANK-IMAGE (rectangle ACTORS-SIZE (* ACTORS-SIZE (/ 2 3)) "solid" "dark green"))
(define TANK-VELOCITY 1)
(define TANK-HEIGHT (- SCENE-HEIGHT (* 0.5 (image-height TANK-IMAGE))))

(define MISSILE-IMAGE (rotate 240 (wedge 20 ACTORS-SIZE "solid" "tan")))
(define MISSILE-HEIGHT (- SCENE-HEIGHT (* 2 (image-height MISSILE-IMAGE))))
(define MISSILE-VELOCITY 10)

(define UFO-IMAGE (ellipse ACTORS-SIZE (* ACTORS-SIZE 0.5) "solid" "light green"))
(define UFO-IMAGE-HEIGHT (* 1.5 (image-height UFO-IMAGE)))
(define UFO-VELOCITY 3)

(define DISTANCE-TO-HIT 20)

; A UFO is a Posn. 
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention)
(define ufo1 (make-posn SCENE-WIDTH SCENE-HEIGHT))
(define ufo2 (make-posn SCENE-WIDTH 0))
(define ufo3 (make-posn (/ SCENE-WIDTH 2) (/ SCENE-HEIGHT 2)))
(define ufo4 (make-posn 50 80))
 
(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick
(define tank1 (make-tank 0 10))
(define tank2 (make-tank SCENE-WIDTH 5))
(define tank3 (make-tank (/ SCENE-WIDTH 2) TANK-VELOCITY))
(define tank4 (make-tank 40 TANK-VELOCITY))
 
; A Missile is a Posn. 
; interpretation (make-posn x y) is the missile's place
(define missile1 (make-posn SCENE-WIDTH MISSILE-HEIGHT))
(define missile2 (make-posn (/ SCENE-WIDTH 2) 0))
(define missile3 (make-posn (/ SCENE-WIDTH 2) (/ SCENE-HEIGHT 2)))
(define missile4 (make-posn 38 MISSILE-HEIGHT))

(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])
; A SIGS is one of: 
; – (make-aim UFO Tank)
; – (make-fired UFO Tank Missile)
; interpretation represents the complete state of a 
; space invader game
(define aim1 (make-aim ufo1 tank1))
(define aim2 (make-aim ufo2 tank2))
(define fired1 (make-fired ufo3 tank3 missile3))
(define fired2 (make-fired ufo4 tank4 missile4))


; SIGS -> Image
; adds TANK-IMAGE, UFO-IMAGE, and possibly MISSILE-IMAGE
; to the MT-SCENE
(check-expect (si-render aim1)
              (ufo-render (aim-ufo aim1) (tank-render (aim-tank aim1) MT-SCENE)))
(check-expect (si-render aim2)
              (ufo-render (aim-ufo aim2) (tank-render (aim-tank aim2) MT-SCENE)))
(check-expect (si-render fired1)
              (missile-render (fired-missile fired1)
                              (ufo-render (fired-ufo fired1)
                                          (tank-render (fired-tank fired1) MT-SCENE))))
(check-expect (si-render fired2)
              (missile-render (fired-missile fired2)
                              (ufo-render (fired-ufo fired2)
                                          (tank-render (fired-tank fired2) MT-SCENE))))
(define (si-render s)
  (cond
    [(aim? s) (ufo-render (aim-ufo s) (tank-render (aim-tank s) MT-SCENE))]
    [(fired? s) (missile-render (fired-missile s)
                                (ufo-render (fired-ufo s)
                                            (tank-render (fired-tank s) MT-SCENE)))]))

; Tank Image -> Image
; adds tank to the given image im
(check-expect (tank-render tank1 MT-SCENE)
              (place-image TANK-IMAGE (tank-loc tank1) TANK-HEIGHT MT-SCENE))
(check-expect (tank-render tank2 MT-SCENE)
              (place-image TANK-IMAGE (tank-loc tank2) TANK-HEIGHT MT-SCENE))
(check-expect (tank-render tank3 MT-SCENE)
              (place-image TANK-IMAGE (tank-loc tank3) TANK-HEIGHT MT-SCENE))
(check-expect (tank-render tank4 MT-SCENE)
              (place-image TANK-IMAGE (tank-loc tank4) TANK-HEIGHT MT-SCENE))
(check-expect (tank-render tank1 (ufo-render ufo1 MT-SCENE))
              (place-image TANK-IMAGE (tank-loc tank1) TANK-HEIGHT (ufo-render ufo1 MT-SCENE)))
(check-expect (tank-render tank1 (missile-render missile1 MT-SCENE))
              (place-image TANK-IMAGE (tank-loc tank1) TANK-HEIGHT (missile-render missile1 MT-SCENE)))
(check-expect (tank-render tank1 (missile-render missile1 (ufo-render ufo1 MT-SCENE)))
              (place-image TANK-IMAGE (tank-loc tank1) TANK-HEIGHT (missile-render missile1 (ufo-render ufo1 MT-SCENE))))
(check-expect (tank-render tank1 (ufo-render ufo1 (missile-render missile1 MT-SCENE)))
              (place-image TANK-IMAGE (tank-loc tank1) TANK-HEIGHT (ufo-render ufo1 (missile-render missile1 MT-SCENE))))
(define (tank-render t im)
  (place-image TANK-IMAGE (tank-loc t) TANK-HEIGHT im))
  

; UFO Image -> Image
; adds ufo to the given image im
(check-expect (ufo-render ufo1 MT-SCENE)
              (place-image UFO-IMAGE (posn-x ufo1) (posn-y ufo1) MT-SCENE))
(check-expect (ufo-render ufo2 MT-SCENE)
              (place-image UFO-IMAGE (posn-x ufo2) (posn-y ufo2) MT-SCENE))
(check-expect (ufo-render ufo3 MT-SCENE)
              (place-image UFO-IMAGE (posn-x ufo3) (posn-y ufo3) MT-SCENE))
(check-expect (ufo-render ufo4 MT-SCENE)
              (place-image UFO-IMAGE (posn-x ufo4) (posn-y ufo4) MT-SCENE))
(check-expect (ufo-render ufo4 (missile-render missile1 MT-SCENE))
              (place-image UFO-IMAGE (posn-x ufo4) (posn-y ufo4) (missile-render missile1 MT-SCENE)))
(check-expect (ufo-render ufo4 (tank-render tank1 MT-SCENE))
              (place-image UFO-IMAGE (posn-x ufo4) (posn-y ufo4) (tank-render tank1 MT-SCENE)))
(check-expect (ufo-render ufo4 (tank-render tank1 (missile-render missile1 MT-SCENE)))
              (place-image UFO-IMAGE (posn-x ufo4) (posn-y ufo4) (tank-render tank1 (missile-render missile1 MT-SCENE))))
(check-expect (ufo-render ufo4 (missile-render missile1 (tank-render tank1 MT-SCENE)))
              (place-image UFO-IMAGE (posn-x ufo4) (posn-y ufo4) (missile-render missile1 (tank-render tank1 MT-SCENE))))
(define (ufo-render u im)
  (place-image UFO-IMAGE (posn-x u) (posn-y u) im))

; Missile Image -> Image
; adds missile to the givne image im
(check-expect (missile-render missile1 MT-SCENE)
              (place-image MISSILE-IMAGE (posn-x missile1) (posn-y missile1) MT-SCENE))
(check-expect (missile-render missile2 MT-SCENE)
              (place-image MISSILE-IMAGE (posn-x missile2) (posn-y missile2) MT-SCENE))
(check-expect (missile-render missile3 MT-SCENE)
              (place-image MISSILE-IMAGE (posn-x missile3) (posn-y missile3) MT-SCENE))
(check-expect (missile-render missile4 MT-SCENE)
              (place-image MISSILE-IMAGE (posn-x missile4) (posn-y missile4) MT-SCENE))
(check-expect (missile-render missile4 (ufo-render ufo1 MT-SCENE))
              (place-image MISSILE-IMAGE (posn-x missile4) (posn-y missile4) (ufo-render ufo1 MT-SCENE)))
(check-expect (missile-render missile4 (tank-render tank1 MT-SCENE))
              (place-image MISSILE-IMAGE (posn-x missile4) (posn-y missile4) (tank-render tank1 MT-SCENE)))
(check-expect (missile-render missile4 (tank-render tank1 (ufo-render ufo1 MT-SCENE)))
              (place-image MISSILE-IMAGE (posn-x missile4) (posn-y missile4) (tank-render tank1 (ufo-render ufo1 MT-SCENE))))
(check-expect (missile-render missile4 (ufo-render ufo1 (tank-render tank1 MT-SCENE)))
              (place-image MISSILE-IMAGE (posn-x missile4) (posn-y missile4) (ufo-render ufo1 (tank-render tank1 MT-SCENE))))
(define
  (missile-render m im)
  (place-image MISSILE-IMAGE (posn-x m) (posn-y m) im))

; SIGS -> Boolean
; stops the animation if the ufo lands or the missile hits the launcher
(check-expect (si-game-over? (make-aim (make-posn 5 SCENE-HEIGHT) tank1)) #true)
(check-expect (si-game-over? (make-aim (make-posn 5 (+ 45 SCENE-HEIGHT)) tank1)) #true)
(check-expect (si-game-over? (make-aim (make-posn 5 46) tank1)) #false)
(check-expect (si-game-over? (make-fired (make-posn 5 SCENE-HEIGHT) tank1 missile1)) #true)
(check-expect (si-game-over? (make-fired (make-posn 5 (+ 45 SCENE-HEIGHT)) tank1 missile1)) #true)
(check-expect (si-game-over? (make-fired (make-posn 5 46) tank1 missile1)) #false)
(check-expect (si-game-over? (make-fired (make-posn 5 100) tank1 (make-posn 5 100))) #true)
(check-expect (si-game-over? (make-fired (make-posn 5 100) tank1 (make-posn 10 100))) #true)
(check-expect (si-game-over? (make-fired (make-posn 5 100) tank1 (make-posn 5 50))) #false)
(check-expect (si-game-over? (make-fired (make-posn 5 100) tank1 (make-posn 4 99))) #true)
(define (si-game-over? s)
  (or (ufo-hit-bottom? s) (hit? s)))

; SIGS Image -> Boolean
; checks whether the ufo has hit the bottom of the scene
(check-expect (ufo-hit-bottom? (make-aim (make-posn 5 SCENE-HEIGHT) tank1)) #true)
(check-expect (ufo-hit-bottom? (make-aim (make-posn 5 (+ 45 SCENE-HEIGHT)) tank1)) #true)
(check-expect (ufo-hit-bottom? (make-aim (make-posn 5 46) tank1)) #false)
(check-expect (ufo-hit-bottom? (make-fired (make-posn 5 SCENE-HEIGHT) tank1 missile1)) #true)
(check-expect (ufo-hit-bottom? (make-fired (make-posn 5 (+ 45 SCENE-HEIGHT)) tank1 missile1)) #true)
(check-expect (ufo-hit-bottom? (make-fired (make-posn 5 46) tank1 missile1)) #false)
(define (ufo-hit-bottom? s)
  (cond
    [(aim? s) (if (>= (posn-y (aim-ufo s)) SCENE-HEIGHT)
              #true
              #false)]
    [(fired? s) (if (>= (posn-y (fired-ufo s)) SCENE-HEIGHT)
                #true
                #false)]))

; SIGS Image -> Boolean
; checks whether the missile is close to the ufo
(check-expect (hit? (make-aim (make-posn 5 0) tank1)) #false)
(check-expect (hit? (make-aim (make-posn 5 45) tank1)) #false)
(check-expect (hit? (make-aim (make-posn 5 46) tank1)) #false)
(check-expect (hit? (make-fired (make-posn 5 100) tank1 (make-posn 5 100))) #true)
(check-expect (hit? (make-fired (make-posn 5 100) tank1 (make-posn 10 100))) #true)
(check-expect (hit? (make-fired (make-posn 5 100) tank1 (make-posn 5 50))) #false)
(check-expect (hit? (make-fired (make-posn 5 100) tank1 (make-posn 4 99))) #true)
(define (hit? s)
  (cond
    [(aim? s) #false]
    [(fired? s) (if (<= (sqrt (+ (sqr (- (posn-x (fired-missile s)) (posn-x (fired-ufo s))))
                          (sqr (- (posn-y (fired-missile s)) (posn-y (fired-ufo s))))))
                        DISTANCE-TO-HIT)
                    #true
                    #false)]))

; SIGS -> Image
; if the game is over, render the final scene
(check-expect (si-render-final (make-aim (make-posn 5 0) tank1))
              (si-render (make-aim (make-posn 5 0) tank1)))
(check-expect (si-render-final (make-fired (make-posn 5 SCENE-HEIGHT) tank1 (make-posn 5 100)))
              (place-image (text "Game Over" 60 "red")
                           (/ SCENE-WIDTH 2)
                           (/ SCENE-HEIGHT 2)
                           MT-SCENE))
(check-expect (si-render-final (make-fired (make-posn 5 (+ 2 SCENE-HEIGHT)) tank1 (make-posn 5 100)))
              (place-image (text "Game Over" 60 "red")
                           (/ SCENE-WIDTH 2)
                           (/ SCENE-HEIGHT 2)
                           MT-SCENE))
(check-expect (si-render-final (make-fired (make-posn 5 100) tank1 (make-posn 5 50)))
              (si-render (make-fired (make-posn 5 100) tank1 (make-posn 5 50))))
(define (si-render-final s)
  (if (si-game-over? s)
      (place-image (text "Game Over" 60 "red")
                           (/ SCENE-WIDTH 2)
                           (/ SCENE-HEIGHT 2)
                           MT-SCENE)
      (si-render s)))

; UFO -> UFO
; moves the UFO on a clock tick
(check-random (si-move aim1) (make-aim (ufo-move (make-posn SCENE-WIDTH SCENE-HEIGHT)) (tank-move (make-tank 0 10))))
(check-random (si-move aim2) (make-aim (ufo-move (make-posn SCENE-WIDTH 0)) (tank-move (make-tank SCENE-WIDTH 5))))
(check-random (si-move fired1) (make-fired (ufo-move (make-posn (/ SCENE-WIDTH 2) (/ SCENE-HEIGHT 2)))
                                           (tank-move (make-tank (/ SCENE-WIDTH 2) TANK-VELOCITY))
                                           (missile-move (make-posn (/ SCENE-WIDTH 2) (/ SCENE-HEIGHT 2)))))
(check-random (si-move fired2) (make-fired (ufo-move (make-posn 50 80))
                                           (tank-move (make-tank 40 TANK-VELOCITY))
                                           (missile-move (make-posn 38 MISSILE-HEIGHT))))
(define (si-move s)
  (cond
    [(aim? s) (make-aim (ufo-move (aim-ufo s))
                        (tank-move (aim-tank s)))]
    [(fired? s) (make-fired (ufo-move (fired-ufo s))
                            (tank-move (fired-tank s))
                            (missile-move (fired-missile s)))]))

; UFO -> UFO
; moves the UFO a random x to the right or left and down 3
(check-random (ufo-move ufo1) (make-posn (+ SCENE-WIDTH (* (if (= (random 2) 0) -1 1)
                                                           (random 5)))
                                         (+ SCENE-HEIGHT UFO-VELOCITY)))
(check-random (ufo-move ufo2) (make-posn (+ SCENE-WIDTH (* (if (= (random 2) 0) -1 1)
                                                           (random 5)))
                                         UFO-VELOCITY))
(check-random (ufo-move ufo3) (make-posn (+ (/ SCENE-WIDTH 2) (* (if (= (random 2) 0) -1 1)
                                                           (random 5)))
                                         (+ (/ SCENE-HEIGHT 2) UFO-VELOCITY)))
(check-random (ufo-move ufo4) (make-posn (+ 50 (* (if (= (random 2) 0) -1 1)
                                                           (random 5)))
                                         (+ 80 UFO-VELOCITY)))
(define (ufo-move u)
  (make-posn
   (+ (posn-x u) (* (if (= (random 2) 0)
                        -1
                        1)
                    (random 5)))
   (+ (posn-y u) UFO-VELOCITY)))

; Tank -> Tank
; moves the tank back and forth with its given velocity
(check-expect (tank-move tank1) (make-tank (modulo 10 SCENE-WIDTH) 10))
(check-expect (tank-move tank2) (make-tank (modulo (+ SCENE-WIDTH 5) SCENE-WIDTH) 5))
(check-expect (tank-move tank3) (make-tank (modulo (+ (/ SCENE-WIDTH 2) TANK-VELOCITY) SCENE-WIDTH) TANK-VELOCITY))
(check-expect (tank-move tank4) (make-tank (modulo (+ 40 TANK-VELOCITY) SCENE-WIDTH) TANK-VELOCITY))
(define (tank-move t)
  (make-tank (modulo (+ (tank-loc t) (tank-vel t)) SCENE-WIDTH)
             (tank-vel t)))

; Missile -> Missile
; moves the missile up
(check-expect (missile-move missile1) (make-posn SCENE-WIDTH (- MISSILE-HEIGHT MISSILE-VELOCITY)))
(check-expect (missile-move missile2) (make-posn (/ SCENE-WIDTH 2) (- 0 MISSILE-VELOCITY)))
(check-expect (missile-move missile3) (make-posn (/ SCENE-WIDTH 2) (- (/ SCENE-HEIGHT 2) MISSILE-VELOCITY)))
(check-expect (missile-move missile4) (make-posn 38 (- MISSILE-HEIGHT MISSILE-VELOCITY)))
(define (missile-move m)
  (make-posn (posn-x m) (- (posn-y m) MISSILE-VELOCITY)))

; SIGS KeyEvent -> SIGS
; moves the tank ("l" for left, "r" for right) and launches the missile (spacebar) only if it is out of screen
(check-expect (si-control aim1 " ") (make-fired ufo1 tank1 (make-posn (tank-loc tank1) MISSILE-HEIGHT)))
(check-expect (si-control aim1 "left") (make-aim ufo1 (tank-move-left tank1)))
(check-expect (si-control aim1 "right") (make-aim ufo1 (tank-move-right tank1)))
(check-expect (si-control fired1 " ") fired1)
(check-expect (si-control (make-fired ufo1 tank1 (make-posn 5 -10)) " ")
              (make-fired ufo1 tank1 (make-posn (tank-loc tank1) MISSILE-HEIGHT)))
(check-expect (si-control fired1 "left") (make-fired ufo3 (tank-move-left tank3) missile3))
(check-expect (si-control fired1 "right") (make-fired ufo3 (tank-move-right tank3) missile3))
(check-expect (si-control aim1 "t") aim1)
(check-expect (si-control fired1 "t") fired1)
(define (si-control s ke)
  (cond
    [(aim? s)
     (cond
       [(key=? ke " ") (make-fired (aim-ufo s) (aim-tank s) (make-posn (tank-loc (aim-tank s)) MISSILE-HEIGHT))]
       [(key=? ke "left") (make-aim (aim-ufo s) (tank-move-left (aim-tank s)))]
       [(key=? ke "right") (make-aim (aim-ufo s) (tank-move-right (aim-tank s)))]
       [else s])]
    [(fired? s)
     (cond
       [(key=? ke " ") (if (missile-gone? (fired-missile s))
                           (make-fired (fired-ufo s) (fired-tank s) (make-posn (tank-loc (fired-tank s)) MISSILE-HEIGHT))
                           s)]
       [(key=? ke "left") (make-fired (fired-ufo s) (tank-move-left (fired-tank s)) (fired-missile s))]
       [(key=? ke "right") (make-fired (fired-ufo s) (tank-move-right (fired-tank s)) (fired-missile s))]
       [else s])]))

; Missile -> Boolean
; is the missile above the screen?
(check-expect (missile-gone? missile1) #false)
(check-expect (missile-gone? missile1) #false)
(check-expect (missile-gone? missile1) #false)
(check-expect (missile-gone? missile1) #false)
(check-expect (missile-gone? (make-posn 5 -20)) #true)
(define (missile-gone? m)
  (if (< (posn-y m) 0) #true #false))

; Tank -> Tank
; moves tank to the left by its velocity
(check-expect (tank-move-left tank1) (make-tank -10 10))
(check-expect (tank-move-left tank2) (make-tank (- SCENE-WIDTH 5) 5))
(check-expect (tank-move-left tank3) (make-tank (- (/ SCENE-WIDTH 2) TANK-VELOCITY) TANK-VELOCITY))
(check-expect (tank-move-left tank4) (make-tank (- 40 TANK-VELOCITY) TANK-VELOCITY))
(define (tank-move-left t)
  (make-tank (- (tank-loc t) (tank-vel t)) (tank-vel t)))

; Tank -> Tank
; moves tank to the right by its velocity
(check-expect (tank-move-right tank1) (make-tank 10 10))
(check-expect (tank-move-right tank2) (make-tank (+ SCENE-WIDTH 5) 5))
(check-expect (tank-move-right tank3) (make-tank (+ (/ SCENE-WIDTH 2) TANK-VELOCITY) TANK-VELOCITY))
(check-expect (tank-move-right tank4) (make-tank (+ 40 TANK-VELOCITY) TANK-VELOCITY))
(define (tank-move-right t)
  (make-tank (+ (tank-loc t) (tank-vel t)) (tank-vel t)))

; Number -> SIGS
; animates the game
(define (main n)
  (big-bang (make-aim (make-posn n 0) tank1)
    [to-draw si-render]
    [on-tick si-move]
    [on-key si-control]
    [stop-when si-game-over? si-render-final]))