#lang racket/gui
(define frame (new frame%
                   [label "It was a dark and stormy night."]
                   [width 500]
                   [height 500]
                   ;[style (list 'no-resize-border)]
                   ))

(define canvas (new canvas% [parent frame]
             [paint-callback
              (lambda (canvas dc)
                (send dc set-background "black")
                (send dc clear)
                ;(drawharry dc)
                )]))

;starting positions
(define x 0)
(define y 0)

;choose color of smarties
(define choosecolor
  (lambda num
    (set! num (car num))
    (cond ((= num 0) (send dc set-pen "white" 1 'solid))
          ((= num 1) (send dc set-pen "blue" 1 'solid))
          ((= num 2) (send dc set-pen "red" 1 'solid))
          ((= num 3) (send dc set-pen "purple" 1 'solid))
          ((= num 4) (send dc set-pen "green" 1 'solid))
          ((= num 5) (send dc set-pen "orange" 1 'solid))
          ((= num 6) (send dc set-pen "yellow" 1 'solid))
          )))
  

(define dc (send canvas get-dc))

(define drawharry
  (lambda (dc udlr)
    (choosecolor (random 7))
    (cond ((= x -1) (set! udlr 0))
          ((= y -1) (set! udlr 2))
          ((= y 501) (set! udlr 3))
          ((= x 500) (set! udlr 1)))
    (cond ((= udlr 0) (set! x (+ x 1)))
          ((= udlr 1) (set! x (- x 1)))
          ((= udlr 2) (set! y (+ y 1)))
          ((= udlr 3) (set! y (- y 1))))
    (send dc draw-point x y)))
 
(send frame show #t)
(sleep/yield 1)

(define looparound
  (lambda (index udlr)
    (drawharry dc udlr)
    (cond ((or (< x 500) (< y 500)) (looparound (+ index 1) (random 4)))
          (else "Home Sweet Home."))))
          
(looparound 0 0)