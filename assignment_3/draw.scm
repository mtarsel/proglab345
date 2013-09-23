(define make-window
  (lambda (x-size y-size foreground-color background-color)
    (let ((window (make-graphics-device 'x)))				; this is for UNIX 
	(begin
	  (graphics-set-coordinate-limits window 0 0 x-size y-size)
	  (set-foreground-color window foreground-color)
	  (set-background-color window background-color)
	  (graphics-clear window)
	  window))))

(define kill-window
  (lambda (window)
    (graphics-close window)))

(define set-foreground-color
  (lambda (window color)
    (graphics-operation window 'set-foreground-color color)))

(define set-background-color
  (lambda (window color)
    (graphics-operation window 'set-background-color color)))

(define draw-point
  (lambda (window x1 y1)
    (graphics-operation window 'draw-point x1 y1)))

(define draw-line
  (lambda (window x1 y1 x2 y2)
    (graphics-operation window 'draw-line x1 y1 x2 y2)))

(define draw-ellipse
  (lambda (window x-left y-top x-right y-bottom)
    (graphics-operation window 'draw-ellipse x-left y-top x-right y-bottom)))

(define draw-circle
  (lambda (window x-center y-center radius)
    (graphics-operation window 'draw-circle x-center y-center radius)))

(define draw-polygon
  (lambda (window vector-points)
    (graphics-operation window 'fill-polygon vector-points)))

;(define test-driver
;  (lambda ()
;    (draw-circle (make-window 500 500 "black" "red") 250 250 100)))

(define test-driver
   (lambda (x1 y1 window);starting position
	(cond ((equal? x1 500) 
			(cond ((equal? y1 500) #t)
				(else (draw-point window x1 y1)
                                      (choosecolor (random 7))
					(test-driver (direction x1 (random 3)) (direction y1 (random 3)) window)))) 
		(else (draw-point window x1 y1)
			(test-driver (direction x1 (random 3)) (direction y1 (random 3)) window)))))
(define direction
   (lambda (p num)
	(cond ((equal? p 500) (- p 1))
              ((equal? p 0) (+ p 1))
              ((equal? 0 num) p)
              ((equal? 1 num) (+ 1 p))
              ((equal? 2 num) (- 1 p)))))

(define choosecolor
  (lambda num
    (num (car num))
    (cond ((= num 0) ("white"))
          ((= num 1) ("blue"))
          ((= num 2) ("red"))
          ((= num 3) ("purple"))
          ((= num 4) ("green"))
          ((= num 5) ("orange"))
          ((= num 6) ("yellow"))
          )))

;;(test-driver 250 250 (make-window 500 500 "green" "black"))
