;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |10.2 Ex170|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; ---- Exercise 166

(define-struct work [employee number rate hours])
(define-struct paycheck [employee number wage])

; Work -> Number
; gets the wage amount for a given work
(check-expect (get-wage (make-work "T" 515252 12 10)) 120)

(define (get-wage w)
  (* (work-rate w) (work-hours w)))

; A (piece of) Work is a structure:
; (make-work String Number Number Number)
; interpretation: (make-work s n r h) combines the name
; with the employee number, pay rate r, and the number of hours h

; Low (short for list of works) is one of:
; - '()
; - (cons Work Low)
; interpretation: an instance of Low represents the
; hours worked for a number of employees

(define LOW1 '())
(define LOW2 (cons (make-work "Robby" 515253 11.95 39)
                   '()))
(define LOW3 (cons (make-work "Matthew" 114151 12.95 45)
                   (cons (make-work "Robby" 515253 11.95 39)
                         '())))

; A Paycheck is a structure:
; (make-paycheck String Number Number)
; interpretation: (make-work s n w) combines the name
; with the employee number and the wage w

; Lop (short for list of paychecks) is one of:
; - '()
; - (cons Paycheck Lop)
; interpretation: an instance of Lop represents the
; paychecks earned for a number of employees

(define LOP1 '())
(define LOP2 (cons (make-paycheck "Robby" 515253 (* 11.95 39))
                   '()))
(define LOP3 (cons (make-paycheck "Matthew" 114151 (* 12.95 45))
                   (cons (make-paycheck "Robby" 515253 (* 11.95 39))
                         '())))

; Low -> Lop
; computes the weekly wages for the given records
(check-expect (wage* LOW1) LOP1)
(check-expect (wage* LOW2) LOP2)
(check-expect (wage* LOW3) LOP3)

(define (wage* low)
  (cond
    [(empty? low) '()]
    [(cons? low) (cons (make-paycheck
                        (work-employee (first low))
                        (work-number (first low))
                        (get-wage (first low)))
                       (wage* (rest low)))]))

; ---- Exercise 167

; Posn -> Number
; gets the x-value of a posn
(check-expect (get-x (make-posn 1 2)) 1)
(define (get-x p)
  (posn-x p))

; List-of-Posns -> Number
; consumes a list of posns and produces the sum of all x coordinates
(check-expect (sum '()) 0)
(check-expect (sum (cons (make-posn 1 2)
                         (cons (make-posn 5 10)
                               '()))) 6)
(define (sum lop)
  (cond
    [(empty? lop) 0]
    [(cons? lop) (+ (get-x (first lop)) (sum (rest lop)))]))

; ---- Exercise 168

; Posn -> Posn
; increases the y-coordinate of a posn by +1
(check-expect (plus-y (make-posn 1 2)) (make-posn 1 3))

(define (plus-y p)
  (make-posn (posn-x p) (+ (posn-y p) 1)))

; List-of-Posns -> List-of-Posns
; translates each y-coordinate of a posn in the list by +1
(check-expect (translate '()) '())
(check-expect (translate (cons (make-posn 1 2) '())) (cons (make-posn 1 3) '()))

(define (translate lop)
  (cond
    [(empty? lop) '()]
    [(cons? lop) (cons (plus-y (first lop)) (translate (rest lop)))]))

; ---- Exercise 169

; Posn -> Boolean
; does the posn fit the range?
(check-expect (fit? (make-posn 1 2)) #true)
(check-expect (fit? (make-posn 150 2)) #false)
(check-expect (fit? (make-posn 1 250)) #false)
(check-expect (fit? (make-posn 150 250)) #false)

(define (fit? p)
  (and
   (and (>= (posn-x p) 0)
        (<= (posn-x p) 100))
   (and (>= (posn-y p) 0)
        (<= (posn-y p) 200))))

; List-of-Posns -> List-of-Posns
; contains all posns whose x values are between 0 and 100
; and whose y values are between 0 and 200
(check-expect (legal '()) '())
(check-expect (legal (cons (make-posn 1 2)
                           (cons (make-posn 34 54)
                                 '())))
              (cons (make-posn 1 2)
                    (cons (make-posn 34 54)
                          '())))
(check-expect (legal (cons (make-posn 1 2)
                           (cons (make-posn 500 600)
                                 '())))
              (cons (make-posn 1 2)
                    '()))

(define (legal lop)
  (cond
    [(empty? lop) '()]
    [(cons? lop) (cond
                   [(fit? (first lop)) (cons (first lop) (legal (rest lop)))]
                   [else (legal (rest lop))])]))

; ----- Exercise 170

(define-struct phone [area switch four])
; A Phone is a structure:
; (make-phone Three Three Four)
; A Three is a number between 100 and 999
; A Four is a number between 1000 and 9999
; interpretation: a phone number

; Phone -> Phone
; replaces the area code to 281 if the given code is 713
(check-expect (p-to-p (make-phone 508 507 5060))
              (make-phone 508 507 5060))
(check-expect (p-to-p (make-phone 713 507 5060))
              (make-phone 281 507 5060))

(define (p-to-p p)
  (if (= (phone-area p) 713)
      (make-phone 281 (phone-switch p) (phone-four p))
      p))

; List-of-Phones -> List-of-Phones
; replaces all occurrence of area code 713 with 281
(check-expect (replace '()) '())
(check-expect (replace (cons (make-phone 508 508 5080) '()))
              (cons (make-phone 508 508 5080) '()))
(check-expect (replace (cons (make-phone 713 508 5080) '()))
              (cons (make-phone 281 508 5080) '()))

(define (replace lop)
  (cond
    [(empty? lop) '()]
    [(cons? lop) (cons (p-to-p (first lop)) (replace (rest lop)))]))