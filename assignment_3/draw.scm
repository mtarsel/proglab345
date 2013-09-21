
(define make-window
  (lambda (x-size y-size foreground-color background-color)
  ;; choose one of the following lines: UNIX or Windows
    (let ((window (make-graphics-device 'x)))				; this is for UNIX 
    ;(let ((window (make-graphics-device 'win32 x-size y-size))) 	; this is for Windows
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

