;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |6.1 Ex98 TBD|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define SCENE-WIDTH 500)
(define SCENE-HEIGHT 500)
(define MT-SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))

(define ACTORS-SIZE 60)

(define TANK-IMAGE (rectangle ACTORS-SIZE (* ACTORS-SIZE (/ 2 3)) "solid" "dark green"))
(define TANK-VELOCITY 2)
(define TANK-HEIGHT (- SCENE-HEIGHT (* 0.5 (image-height TANK-IMAGE))))

(define MISSILE-IMAGE (rotate 240 (wedge 20 ACTORS-SIZE "solid" "tan")))
(define MISSILE-HEIGHT (- SCENE-HEIGHT (* 2 (image-height MISSILE-IMAGE))))

(define UFO-IMAGE (ellipse ACTORS-SIZE (* ACTORS-SIZE 0.5) "solid" "light green"))
(define UFO-IMAGE-HEIGHT (* 1.5 (image-height UFO-IMAGE)))

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
; adds t to the given image im
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
; adds u to the given image im
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
; adds m to the givne image im
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
(define (si-game-over? s)
  (cond
    [(aim? s) ...]
    [(fired? s) ...]))

; UFO Image -> Boolean
; checks whether the ufo has hit the bottom of the scene
(check-expect (ufo-hit-bottom? 