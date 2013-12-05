#lang racket/gui

(define frame (new frame%
                   [label "8 Puzzle"]
                   [width 310]
                   [height 332]
                   [style (list 'no-resize-border)]
                   ))

(define canvas (new canvas% [parent frame]
                    [paint-callback
                     (lambda (canvas dc)
                       (send dc set-background "white")
                       (send dc clear)
                       )]))

(define dc (send canvas get-dc))

(send frame show #t)
(sleep/yield 1)

(define fill
  (lambda (box num)
    (send dc set-brush "black" 'solid)
    (cond ((= 0 num) 
           (cond ((= 0 box) (send dc draw-rectangle 0 0 101 101))
                 ((= 1 box) (send dc draw-rectangle 101 0 101 101))
                 ((= 2 box) (send dc draw-rectangle 202 0 102 101))
                 ((= 3 box) (send dc draw-rectangle 0 101 101 101))
                 ((= 4 box) (send dc draw-rectangle 101 101 101 101))
                 ((= 5 box) (send dc draw-rectangle 202 101 102 101))
                 ((= 6 box) (send dc draw-rectangle 0 203 101 101))
                 ((= 7 box) (send dc draw-rectangle 101 203 101 101))
                 ((= 8 box) (send dc draw-rectangle 202 203 102 101))
                 ))
          
          
          (else
           (cond ((= 0 box) (define-values (w h d a) (send dc get-text-extent (number->string num))) (send dc draw-text (number->string num) (/ (- 100 w) 2) (/ (- 100 h) 2)))
                 ((= 1 box) (define-values (w h d a) (send dc get-text-extent (number->string num))) (send dc draw-text (number->string num) (/ (- 302 w) 2) (/ (- 100 h) 2)))
                 ((= 2 box) (define-values (w h d a) (send dc get-text-extent (number->string num))) (send dc draw-text (number->string num) (/ (- 506 w) 2) (/ (- 100 h) 2)))
                 ((= 3 box) (define-values (w h d a) (send dc get-text-extent (number->string num))) (send dc draw-text (number->string num) (/ (- 100 w) 2) (/ (- 302 h) 2)))
                 ((= 4 box) (define-values (w h d a) (send dc get-text-extent (number->string num))) (send dc draw-text (number->string num) (/ (- 302 w) 2) (/ (- 302 h) 2)))
                 ((= 5 box) (define-values (w h d a) (send dc get-text-extent (number->string num))) (send dc draw-text (number->string num) (/ (- 506 w) 2) (/ (- 302 h) 2)))
                 ((= 6 box) (define-values (w h d a) (send dc get-text-extent (number->string num))) (send dc draw-text (number->string num) (/ (- 100 w) 2) (/ (- 506 h) 2)))
                 ((= 7 box) (define-values (w h d a) (send dc get-text-extent (number->string num))) (send dc draw-text (number->string num) (/ (- 302 w) 2) (/ (- 506 h) 2)))
                 ((= 8 box) (define-values (w h d a) (send dc get-text-extent (number->string num))) (send dc draw-text (number->string num) (/ (- 506 w) 2) (/ (- 506 h) 2)))
                 )))))


(define board%
  (class object%
    (super-new)
    ;(init-field pointx pointy [color '()] [depth 1])
    
    (define board-array
      (list->vector '(0 1 2 3 4 5 6 7 8))
      )
    
    ;sounce number and destination position
    (define/public swap
      (lambda (src dst)
        (define x (vector-ref board-array dst))
        (define y (vector-member src board-array))
        
        (vector-set! board-array dst src)
        (vector-set! board-array y x)
        ))
    
    ;check if the blank could be moved down
    (define/public check-down
      (lambda ()
        (cond((> (vector-member 0 board-array) 5) #f)
             (else #t))))
    
    ;check if the blank could be moved up
    (define/public check-up
      (lambda ()
        (cond((< (vector-member 0 board-array) 3) #f)
             (else #t)))) 
    
    ;check if the blank could be moved left
    (define/public check-left
      (lambda ()
        (cond((= (vector-member 0 board-array) 0) #f)
             ((= (vector-member 0 board-array) 3) #f)
             ((= (vector-member 0 board-array) 6) #f)
             (else #t))))
    
    ;check if the blank can be moved right         
    (define/public check-right
      (lambda ()
        (cond((= (vector-member 0 board-array) 2) #f)
             ((= (vector-member 0 board-array) 5) #f)
             ((= (vector-member 0 board-array) 8) #f)
             (else #t))))
    
    (define/public move-left
      (lambda ()
        (cond ((check-left) (swap 0 (- (vector-member 0 board-array) 1)))
              (else (displayln "cant go left")))
        (redraw)))
    
    (define/public move-right
      (lambda ()
        (cond ((check-right) (swap 0 (+ (vector-member 0 board-array) 1)))
              (else (displayln "cant go right")))
        (redraw)))
    
    (define/public move-up
      (lambda ()
        (cond ((check-up) (swap 0 (- (vector-member 0 board-array) 3)))
              (else (displayln "cant go higher")))
        (redraw)))
    
    (define/public move-down
      (lambda ()
        (cond ((check-down) (swap 0 (+ (vector-member 0 board-array) 3)))
              (else (displayln "cant go lower")))
        (redraw)))
    
    ;  (define/public get-position
    ;   (lambda (x y)
    ;    (vector-ref board-array (+ x (* 3 (- y 1))))))
    
    ;   (define/public display
    ;    (lambda ()
    ;     board-array))
    
    (define/public redraw
      (lambda ()
        (send dc clear)
        (send dc set-font (make-font #:size 50 #:weight 'bold))
        
        ;vertical lines
        (send dc draw-line 101 0 101 303)
        (send dc draw-line 202 0 202 303)
        ;horizontal lines
        (send dc draw-line 0 101 303 101)
        (send dc draw-line 0 202 303 202)
        
        (define walk-puzzle
          (lambda (vec box)
            (cond ((not(null? vec))(fill box (car vec)) (walk-puzzle (cdr vec) (+ box 1))))))
        
        (walk-puzzle (vector->list board-array) 0)
        ))
    
    (define/public randomize
      (lambda (times)
        (cond ((> times 0)(define rand (random 4))
                          ;(write (= rand 0)) (write (check-down))
                          (cond ((and (= rand 0) (check-up)) (move-up)) 
                                ((and (= rand 1) (check-right)) (move-right))
                                ((and (= rand 2) (check-down)) (move-down))
                                ((and (= rand 3) (check-left)) (move-left))
                                (else (randomize 1)))
                          (sleep .1)
                          (randomize (- times 1))))))
    
    (define/public solve
      (lambda ()
        (cond ((equal? (vector->list board-array) '(0 1 2 3 4 5 6 7 8)) (print "SOLVED!"))
              (else
               (define rand (random 4))
               ;(write (= rand 0)) (write (check-down))
               (cond ((and (= rand 0) (check-up)) (move-up)) 
                     ((and (= rand 1) (check-right)) (move-right))
                     ((and (= rand 2) (check-down)) (move-down))
                     ((and (= rand 3) (check-left)) (move-left))
                     (else (randomize 1)))
               ;(sleep .05)
               (solve)))))
    
    ))

(define boo (new board%))
(send boo redraw)

(define play-me
  (lambda ()
     (displayln "Randomizing")
     (sleep 2)
     (send boo randomize 100)
     (displayln "Solving")
     (sleep 2)
     (send boo solve)))