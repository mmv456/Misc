;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |5.10 Ex87 - Text Editor v2|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define max-character-length 40)

(define-struct editor [text index])
; An Editor is a structure:
; (make-editor String Number)
; interpretation: (make-editor s n) describes an editor whose text is
; represented as t with the cursor displayed in the index n

(define ed1 (make-editor "hello world" 0))
(define ed2 (make-editor "hello world" 5))
(define ed3 (make-editor "hello world" 6))
(define ed4 (make-editor "hello world" 11))


; Editor -> String
; displays the string on the left of the index (cursor position)
(check-expect (string-left ed1) "")
(check-expect (string-left ed2) "hello")
(check-expect (string-left ed3) "hello ")
(check-expect (string-left ed4) "hello world")
(define (string-left ed)
  (substring (editor-text ed) 0 (editor-index ed)))

; Editor -> String
; displays the string on the right side of the index (cursor position)
(check-expect (string-right ed1) "hello world")
(check-expect (string-right ed2) " world")
(check-expect (string-right ed3) "world")
(check-expect (string-right ed4) "")
(define (string-right ed)
  (substring (editor-text ed) (editor-index ed)))

; String -> String
; removes the last character of the string
(check-expect (remove-end "hello") "hell")
(check-expect (remove-end "hello ") "hello")
(define (remove-end s)
  (substring s 0 (- (string-length s) 1)))

; Editor -> Image
; renders the editor as an image
(check-expect (render ed1)
              (overlay/align "left" "center"
                             (beside (rectangle 1 20 "solid" "red")
                                     (text (editor-text ed1) 11 "black"))
                             (empty-scene 200 20)))
(check-expect (render ed2)
              (overlay/align "left" "center"
                             (beside (text "hello" 11 "black")
                                     (rectangle 1 20 "solid" "red")
                                     (text " world" 11 "black"))
                             (empty-scene 200 20)))
(check-expect (render ed3)
              (overlay/align "left" "center"
                             (beside (text "hello " 11 "black")
                                     (rectangle 1 20 "solid" "red")
                                     (text "world" 11 "black"))
                             (empty-scene 200 20)))
(check-expect (render ed4)
              (overlay/align "left" "center"
                             (beside (text "hello world" 11 "black")
                                     (rectangle 1 20 "solid" "red"))
                             (empty-scene 200 20)))
(define (render ed)
  (overlay/align "left" "center"
                 (beside (text (string-left ed) 11 "black")
                         (rectangle 1 20 "solid" "red")
                         (text (string-right ed) 11 "black"))
                 (empty-scene 200 20)))


; Editor KeyEvent -> Editor
; add a single character ke to the end of the text at the end of
; the text to the left of the cursor
; if ke is "\b", delete the character to the left of the cursor
; if ke is "\t" or "\r", ignore
; Also, the "left" and "right" keys moves the cursor left or right
; If the text is too wide for the canvas, ignore the keystroke
(check-expect (edit ed1 "a")
              (make-editor "ahello world" 1))
(check-expect (edit ed2 "a")
              (make-editor "helloa world" 6))
(check-expect (edit ed3 "a")
              (make-editor "hello aworld" 7))
(check-expect (edit ed4 "a")
              (make-editor "hello worlda" 12))
(check-expect (edit ed1 "\b") ed1)
(check-expect (edit ed2 "\b")
              (make-editor "hell world" 4))
(check-expect (edit ed3 "\b")
              (make-editor "helloworld" 5))
(check-expect (edit ed4 "\b")
              (make-editor "hello worl" 10))
(check-expect (edit ed1 "\t") ed1)
(check-expect (edit ed1 "\r") ed1)
(check-expect (edit ed1 "left") ed1)
(check-expect (edit ed1 "right")
              (make-editor "hello world" 1))
(check-expect (edit ed2 "left")
              (make-editor "hello world" 4))
(check-expect (edit ed2 "right")
              (make-editor "hello world" 6))
(check-expect (edit ed3 "left")
              (make-editor "hello world" 5))
(check-expect (edit ed3 "right")
              (make-editor "hello world" 7))
(check-expect (edit ed4 "left")
              (make-editor "hello world" 10))
(check-expect (edit ed4 "right") ed4)
(check-expect (edit
               (make-editor "This is a very long text which is long and is meant to overflow to check a condition"
                            8)
               "a")
              (make-editor "This is a very long text which is long and is meant to overflow to check a condition"
                            8))
(define (edit ed ke)
  (cond
    [(equal? ke "\b")
     (if (equal? (editor-index ed) 0)
         ed
         (make-editor
          (string-append (remove-end (string-left ed))
                         (string-right ed))
          (- (editor-index ed) 1)))]
    [(or (equal? ke "\t") (equal? ke "\r"))
     ed]
    [(equal? ke "left")
     (if (equal? (editor-index ed) 0)
         ed
         (make-editor (editor-text ed) (- (editor-index ed) 1)))]
    [(equal? ke "right")
     (if (equal? (editor-index ed) (string-length (editor-text ed)))
         ed
         (make-editor (editor-text ed) (+ (editor-index ed) 1)))]
    [else
     (if (> (string-length (editor-text ed)) max-character-length)
         ed
         (make-editor (string-append (string-left ed)
                                     ke
                                     (string-right ed))
                      (+ (editor-index ed) 1)))]))

; String -> String
; creates the editor animation
(define (main s)
  (big-bang (make-editor s (string-length s))
    [to-draw render]
    [on-key edit]))