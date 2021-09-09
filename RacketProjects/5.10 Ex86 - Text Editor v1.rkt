;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |5.10 Ex86 - Text Editor v1|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define max-character-length 40)

(define-struct editor [pre post])
; An Editor is a structure:
; (make-editor String String)
; interpretation: (make-editor s t) describes an editor whose
; visible text is (string-append s t) with the cursor displayed
; between s and t

(define ed1 (make-editor "hello " "world"))
(define ed2 (make-editor "123" "abc"))
(define ed3 (make-editor "" "hij"))
(define ed4 (make-editor "klm" ""))

; Editor -> Image
; render text onto an empty scene with a cursor
(check-expect (render ed1)
              (overlay/align "left" "center"
                             (beside (text (editor-pre ed1) 11 "black")
                                     (rectangle 1 20 "solid" "red")
                                     (text (editor-post ed1) 11 "black"))
                             (empty-scene 200 20)))
(define (render ed)
  (overlay/align "left" "center"
                 (beside (text (editor-pre ed) 11 "black")
                         (rectangle 1 20 "solid" "red")
                         (text (editor-post ed) 11 "black"))
                 (empty-scene 200 20)))

; Editor KeyEvent -> Editor
; add a single character ke to the end of the pre field of ed,
; unless ke denoted the "\b" key which deletes the character to the
; left of the cursor. It ignores the "\t" and "\r" keys
; Also, the "left" and "right" keys moves the cursor left or right
; If the text is too wide for the canvas, ignore the keystroke
(check-expect (edit ed1 "\b") (make-editor "hello" "world"))
(check-expect (edit ed2 " ") (make-editor "123 " "abc"))
(check-expect (edit ed2 "\t") (make-editor "123" "abc"))
(check-expect (edit ed2 "\r") (make-editor "123" "abc"))
(check-expect (edit ed1 "left") (make-editor "hello" " world"))
(check-expect (edit ed2 "right") (make-editor "123a" "bc"))
(check-expect (edit ed3 "left") ed3)
(check-expect (edit ed3 "right") (make-editor "h" "ij"))
(check-expect (edit ed4 "left") (make-editor "kl" "m"))
(check-expect (edit ed4 "right") ed4)
(check-expect (edit (make-editor "This editor can only hold"
                                 "40 characters so this is long")
                    "w")
              (make-editor "This editor can only hold"
                                 "40 characters so this is long"))
(define (edit ed ke)
  (cond
    [(equal? ke "\b")
     (make-editor (string-remove-last (editor-pre ed))
                                   (editor-post ed))]
    [(or (equal? ke "\t") (equal? ke "\r"))
     ed]
    [(equal? ke "left")
     (if (> (string-length (editor-pre ed)) 0)
         (make-editor (string-remove-last (editor-pre ed))
                      (string-add-to-beg (string-last (editor-pre ed))
                                         (editor-post ed)))
         ed)]
    [(equal? ke "right")
     (if (> (string-length (editor-post ed)) 0)
         (make-editor (string-add-to-end (editor-pre ed)
                                         (string-first (editor-post ed)))
                      (string-remove-first (editor-post ed)))
         ed)]
    [else
     (if (> (length-of-editor ed) max-character-length)
         ed
         (make-editor (string-add-to-end (editor-pre ed) ke)
                  (editor-post ed)))]))

; String -> String
; returns the string without the last character
(check-expect (string-remove-last "hello ") "hello")
(check-expect (string-remove-last "hello") "hell")
(define (string-remove-last s)
  (substring s 0 (- (string-length s) 1)))

; String String -> String
; appends the second string to the first
(check-expect (string-add-to-end "1" "2") "12")
(check-expect (string-add-to-end "1" " ") "1 ")
(define (string-add-to-end s1 s2)
  (string-append s1 s2))

; String -> String
; provides the last character of the string
(check-expect (string-last "12") "2")
(check-expect (string-last "1") "1")
(check-expect (string-last "") "")
(define (string-last s)
  (if (equal? s "")
      ""
      (substring s (- (string-length s) 1))))

; String -> String
; removes the first character form the string
(check-expect (string-remove-first "1") "")
(check-expect (string-remove-first "12") "2")
(define (string-remove-first s)
  (substring s 1))

; String -> String
; provides the first character of the string
(check-expect (string-first "1") "1")
(check-expect (string-first "124") "1")
(define (string-first s)
  (substring s 0 1))

; String String -> String
; adds the first string to the beginning of the second one
(check-expect (string-add-to-beg "1" "2345") "12345")
(define (string-add-to-beg s1 s2)
  (string-append s1 s2))

; Editor -> Number
; counts the number fo characters of the editor
(check-expect (length-of-editor ed1) 11)
(check-expect (length-of-editor ed2) 6)
(check-expect (length-of-editor ed3) 3)
(check-expect (length-of-editor ed4) 3)
(define (length-of-editor ed)
  (+ (string-length (editor-pre ed))
     (string-length (editor-post ed))))

; String -> String
; creates the editor animation
(define (main s)
  (big-bang (make-editor s "")
    [to-draw render]
    [on-key edit]))