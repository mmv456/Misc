;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |10.4 Ex180|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; Exercises 177, 178, 179, and 180

; CONSTANTS

(define HEIGHT 20) ; the height of the editor 
(define WIDTH 200) ; its width 
(define FONT-SIZE 16) ; the font size 
(define FONT-COLOR "black") ; the font color 
 
(define MT (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 2 HEIGHT "solid" "red"))

; DEFINITIONS

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor Lo1S Lo1S)
; interpretation: the letters in pre precide the
; cursor in reverse order and those in post succeed
; it in normal order

; An Lo1S is one of: 
; – '()
; – (cons 1String Lo1S)

(define good
  (cons "g" (cons "o" (cons "o" (cons "d" '())))))
(define all
  (cons "a" (cons "l" (cons "l" '()))))
(define lla
  (cons "l" (cons "l" (cons "a" '()))))
 
; data example 1: 
(define ex1 (make-editor all good)) ; outputs "llagood"
 
; data example 2:
(define ex2 (make-editor lla good)) ; outputs "allgood"

; HELPER FUNCTIONS

; Lo1s -> Lo1s 
; produces a reverse version of the given list 
(check-expect
 (rev (cons "a" (cons "b" (cons "c" '()))))
 (cons "c" (cons "b" (cons "a" '()))))
 
(define (rev l)
  (cond
    [(empty? l) '()]
    [(cons? l) (add-at-end (rev (rest l)) (first l))]))

; Lo1s 1String -> Lo1s
; creates a new list by adding s to the end of l
(check-expect
 (add-at-end (cons "c" (cons "b" '())) "a")
 (cons "c" (cons "b" (cons "a" '()))))
 
(define (add-at-end l s)
  (cond
    [(empty? l) (cons s '())]
    [(cons? l) (cons (first l) (add-at-end (rest l) s))]))

; String String -> Editor
; produces an Editor given two strings
(check-expect (create-editor "all" "good")
              (make-editor (cons "l" (cons "l" (cons "a" '())))
                           (cons "g" (cons "o" (cons "o" (cons "d" '()))))))
(define (create-editor one two)
  (make-editor (rev (explode one)) (explode two)))

; UNIVERSE CREATION

; Editor -> Image
; renders an editor as an image of the two texts 
; separated by the cursor
(check-expect (editor-render (create-editor "pre" "post"))
              (place-image/align
               (beside (text "pre" FONT-SIZE FONT-COLOR)
                       CURSOR
                       (text "post" FONT-SIZE FONT-COLOR))
               1 1
               "left" "top"
               MT))
(check-expect (editor-render (create-editor "" "post"))
              (place-image/align
               (beside CURSOR
                       (text "post" FONT-SIZE FONT-COLOR))
               1 1
               "left" "top"
               MT))
(check-expect (editor-render (create-editor "pre" ""))
              (place-image/align
               (beside (text "pre" FONT-SIZE FONT-COLOR)
                       CURSOR)
               1 1
               "left" "top"
               MT))
(check-expect (editor-render (create-editor "" ""))
              (place-image/align
               CURSOR
               1 1
               "left" "top"
               MT))
(define (editor-render e)
  (place-image/align (cond
                       [(and (cons? (editor-pre e))
                             (cons? (editor-post e)))
                        (beside (editor-text (reverse (editor-pre e)))
                                CURSOR
                                (editor-text (editor-post e)))]
                       [(and (empty? (editor-pre e))
                             (cons? (editor-post e)))
                        (beside CURSOR
                                (editor-text (editor-post e)))]
                       [(and (cons? (editor-pre e))
                             (empty? (editor-post e)))
                        (beside (editor-text (reverse (editor-pre e)))
                                CURSOR)]
                       [(and (empty? (editor-pre e))
                             (empty? (editor-post e)))
                        CURSOR])
                     1 1
                     "left" "top"
                     MT))

; Lo1s -> Image
; renders a list of 1Strings as a text image
(check-expect
  (editor-text
   (cons "p" (cons "o" (cons "s" (cons "t" '())))))
  (text "post" FONT-SIZE FONT-COLOR))
(define (editor-text s)
  (text (implode s) FONT-SIZE FONT-COLOR))
 
; Editor KeyEvent -> Editor
; deals with a key event, given some editor
(check-expect (editor-kh (create-editor "" "") "e")
              (create-editor "e" ""))
(check-expect
 (editor-kh (create-editor "cd" "fgh") "e")
 (create-editor "cde" "fgh"))
(check-expect (editor-kh (create-editor "abc" "") " ")
              (create-editor "abc " ""))
(check-expect (editor-kh (create-editor "" "") " ")
              (create-editor " " ""))
(check-expect (editor-kh (create-editor "cd" "fgh") "left")
              (create-editor "c" "dfgh"))
(check-expect (editor-kh (create-editor "" "fgh") "left")
              (create-editor "" "fgh"))
(check-expect (editor-kh (create-editor "cd" "fgh") "right")
              (create-editor "cdf" "gh"))
(check-expect (editor-kh (create-editor "cd" "") "right")
              (create-editor "cd" ""))
(check-expect (editor-kh (create-editor "cd" "fgh") "\b")
              (create-editor "c" "fgh"))
(check-expect (editor-kh (create-editor "" "fgh") "\b")
              (create-editor "" "fgh"))

(define (editor-kh ed k)
  (cond
    [(key=? k "left") (editor-lft ed)]
    [(key=? k "right") (editor-rgt ed)]
    [(key=? k "\b") (editor-del ed)]
    [(key=? k "\t") ed]
    [(key=? k "\r") ed]
    [(= (string-length k) 1) (editor-ins ed k)]
    [else ed]))

; Editor -> Editor
; moves the cursor position one 1String left, 
; if possible
(check-expect (editor-lft (make-editor (cons "a" '())
                                       '()))
              (make-editor '() (cons "a" '())))
(check-expect (editor-lft (make-editor (cons "a"
                                             (cons "b" '()))
                                       (cons "c" '())))
              (make-editor (cons "b" '()) (cons "a"
                                                (cons "c" '()))))
(check-expect (editor-lft (make-editor '() (cons "a" '())))
              (make-editor '() (cons "a" '())))
(define (editor-lft ed)
  (cond
    [(empty? (editor-pre ed)) ed]
    [else (make-editor (rest (editor-pre ed))
                       (cons (first (editor-pre ed))
                             (editor-post ed)))]))

; Editor -> Editor
; moves the cursor position one 1String right, 
; if possible
(check-expect (editor-rgt (make-editor (cons "a" '())
                                       '()))
              (make-editor (cons "a" '()) '()))
(check-expect (editor-rgt (make-editor (cons "a"
                                             (cons "b" '()))
                                       (cons "c" '())))
              (make-editor (cons "c" (cons "a" (cons "b" '())))
                           '()))
(check-expect (editor-rgt (make-editor '() (cons "a" '())))
              (make-editor (cons "a" '()) '()))
(define (editor-rgt ed)
  (cond
    [(empty? (editor-post ed)) ed]
    [else (make-editor (cons (first (editor-post ed))
                             (editor-pre ed))
                       (rest (editor-post ed)))]))
 
; Editor -> Editor
; deletes a 1String to the left of the cursor,
; if possible
(check-expect (editor-del (make-editor (cons "a" '())
                                       '()))
              (make-editor '() '()))
(check-expect (editor-del (make-editor (cons "a"
                                             (cons "b" '()))
                                       (cons "c" '())))
              (make-editor (cons "b" '()) (cons "c" '())))
(check-expect (editor-del (make-editor '() (cons "a" '())))
              (make-editor '() (cons "a" '())))
(define (editor-del ed)
  (cond
    [(empty? (editor-pre ed)) ed]
    [else (make-editor (rest (editor-pre ed))
                       (editor-post ed))]))

; Editor String -> Editor
; insert the 1String k between pre and post
(check-expect
 (editor-ins (make-editor '() '()) "e")
 (make-editor (cons "e" '()) '()))
(check-expect
 (editor-ins
  (make-editor (cons "d" '())
               (cons "f" (cons "g" '())))
  "e")
 (make-editor (cons "e" (cons "d" '()))
              (cons "f" (cons "g" '()))))

(define (editor-ins ed k)
  (make-editor (cons k (editor-pre ed))
               (editor-post ed)))


; main : String -> Editor
; launches the editor given some initial string 
(define (main s)
  (big-bang (create-editor s "")
    [on-key editor-kh]
    [to-draw editor-render]))