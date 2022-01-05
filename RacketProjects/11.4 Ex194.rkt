;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |11.4 Ex194|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; A Polygon is one of:
; – (list Posn Posn Posn)
; – (cons Posn Polygon)

(define triangle-p
  (list
   (make-posn 20 10)
   (make-posn 20 20)
   (make-posn 30 20)))
 

(define square-p
  (list
   (make-posn 10 10)
   (make-posn 20 10)
   (make-posn 20 20)
   (make-posn 10 20)))

; An NELoP is one of: 
; – (cons Posn '())
; – (cons Posn NELoP)

; a plain background image 
(define MT (empty-scene 50 50))



; Image Polygon -> Image
; renders the given polygon p into img
(check-expect
 (render-polygon MT triangle-p)
 (scene+line
  (scene+line
   (scene+line MT 20 10 20 20 "red")
   20 20 30 20 "red")
  30 20 20 10 "red"))
(check-expect
 (render-polygon MT square-p)
 (scene+line
  (scene+line
   (scene+line
    (scene+line MT 10 10 20 10 "red")
    20 10 20 20 "red")
   20 20 10 20 "red")
  10 20 10 10 "red"))
; Image Polygon -> Image 
; adds an image of p to img
(define (render-polygon img p)
  (render-line (connect-dots img p)
               (first p)
               (last p)))


; Image Posn Posn -> Image 
; renders a line from p to q into img
(check-expect (render-line MT (make-posn 1 2) (make-posn 3 4))
              (scene+line MT 1 2 3 4 "red"))
(define (render-line img p q)
  (scene+line
   img
   (posn-x p) (posn-y p) (posn-x q) (posn-y q)
   "red"))

 
; Image NELoP -> Image 
; connects the dots in p by rendering lines in img
(check-expect (connect-dots MT triangle-p)
              (scene+line
               (scene+line MT 20 10 20 20 "red")
               20 20 30 20 "red"))
(define (connect-dots img p)
  (cond
    [(empty? (rest p)) img]
    [else (render-line (connect-dots MT (rest p))
                       (first p)
                       (second p))]))

; NELoP -> Posn
; extracts the last item from p
(define (last p)
  (cond
    [(empty? (rest p)) (first p)]
    [else (last (rest p))]))


; ------ Exercise 194

; Image NELoP Posn -> Image 
; connects the dots in p and the posn by rendering lines in img
(check-expect (connect-dots2 MT triangle-p (make-posn 1 2))
              (scene+line
               (scene+line
                (scene+line MT 20 10 20 20 "red")
                20 20 30 20 "red")
               30 20 1 2 "red"))
(check-expect (connect-dots2 MT (cons (make-posn 1 2) '())
                             (make-posn 3 4))
              (scene+line MT 1 2 3 4 "red"))
(define (connect-dots2 img lop p)
  (cond
    [(empty? (rest lop)) (scene+line img
                                     (posn-x (first lop))
                                     (posn-y (first lop))
                                     (posn-x p)
                                     (posn-y p)
                                     "red")]
    [else (render-line (connect-dots2 img (rest lop) p)
                       (first lop)
                       (second lop))]))