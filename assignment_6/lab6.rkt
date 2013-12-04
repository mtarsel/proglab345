#lang racket/gui
(require racket/class)

(define frame (new frame%
                   [label "Bad Argile"]
                   [width 500]
                   [height 500]
                   ))

(define canvas (new canvas% [parent frame]
             [paint-callback
              (lambda (canvas dc)
                (send dc set-background "black")
                (send dc clear)
                ;(drawharry dc)
                )]))

(define dc (send canvas get-dc))

(send frame show #t)
(sleep/yield 1)

(define point
  (lambda (x y [depth 1])
    (new point% [x x] [y y] [depth depth])))

(define draw-point
  (lambda (point)
    (send dc set-pen "white" 1 'solid)
    (send dc draw-point (send point get-x) (send point get-y))))

(define point%
  (class object%
    (super-new)
    (init-field x y [depth 1])
    (define/public get-x
      (lambda ()
        x))
    (define/public get-y
      (lambda ()
        y))
    (define/public type?
      (lambda ()
      'point))
    (define/public depth?
      (lambda ()
        depth))
    (define/public draw
      (lambda ()
        (send dc set-pen "white" 1 'solid)
        (send dc draw-point (get-x) (get-y))))
  ))

(define draw
  (lambda (object)
    (send object draw)))

(define type
  (lambda (object)
    (send object type?)))

(define depth
  (lambda (object)
    (send object depth?)))
    
(define point?
  (lambda (object)
    (cond ((equal? (send object type?) 'point) #t)
          (else #f))))

(define rectangle%
  (class object%
    (super-new)
    (init-field pointx pointy [color '()] [depth 1])
    (define/public get-x
      (lambda ()
        (send pointx get-x)))
    (define/public get-y
      (lambda ()
        (send pointx get-y)))
    (define/public get-width
      (lambda ()
        (abs(- (send pointx get-x) (send pointy get-x)))))
    (define/public get-height
      (lambda ()
        (abs(- (send pointx get-y) (send pointy get-y)))))
    (define/public get-color
      (lambda ()
        color))
    (define/public type?
      (lambda ()
      'rectangle))
    (define/public depth?
      (lambda ()
        depth))
    (define/public draw
      (lambda ()
        (cond ((not(string? (get-color))) (send dc set-pen "white" 1 'solid) (send dc set-brush "white" 'transparent) 
                                        (send dc draw-rectangle (get-x) (get-y) (get-width) (get-height))) 
              (else (send dc set-pen (get-color) 1 'solid) (send dc set-brush (get-color) 'solid)
                    (send dc draw-rectangle (get-x) (get-y) (get-width) (get-height))))))
  ))

(define rectangle
  (lambda (pointx pointy [color '()] [depth 1])
    (new rectangle% [pointx pointx] [pointy pointy] [color color] [depth depth])))

(define draw-rectangle
  (lambda (rec)
    (cond ((equal? (send rec get-color) '()) (send dc set-pen "white" 1 'solid) (send dc set-brush "white" 'transparent) 
                                                       (send dc draw-rectangle (send rec get-x) (send rec get-y) (send rec get-width) (send rec get-height))) 
          (else (send dc set-pen (send rec get-color) 1 'solid) (send dc set-brush (send rec get-color) 'solid)
                (send dc draw-rectangle (send rec get-x) (send rec get-y) (send rec get-width) (send rec get-height))))
    (send dc draw-rectangle (send rec get-x) (send rec get-y) (send rec get-width) (send rec get-height))))
    
(define rectangle?
  (lambda (object)
    (cond ((equal? (send object type?) 'rectangle) #t)
          (else #f))))

(define polygon%
  (class object%
    (super-new)
    (init-field points [color '()] [depth 1])

    (define/public get-points
      (lambda ()
        points))
    
    (define/public get-color
      (lambda ()
        (cond ((null? color) '())
              (else (car color)))))

    (define/public type?
      (lambda ()
      'polygon))
    
    (define/public depth?
      (lambda ()
        depth))
    
    (define/public draw
      (lambda ()
        (cond ((equal? (get-color) '()) (send dc set-pen "white" 1 'solid) (send dc set-brush "white" 'transparent) 
                                                       (send dc draw-polygon (get-points))) 
          (else (send dc set-pen (get-color) 1 'solid) (send dc set-brush (get-color) 'solid)
                (send dc draw-polygon (get-points))))
    ))
  ))

(define polygon
  (lambda vars
    (define color '())
    (define depth 1)
    (define createlist
      (lambda (vars)
        (cond ((null? vars) '())
              ((string? (car vars)) (set! color vars) (createlist (cdr vars)) '())
              ((not(object? (car vars))) (set! depth (car vars)) '())
              (else
               (cons (cons (send (car vars) get-x) (send (car vars) get-y)) (createlist (cdr vars))))
              )))
    (new polygon% [points (createlist vars)] [color color] [depth depth])
              ))

(define draw-polygon
  (lambda (poly)
    (cond ((equal? (send poly get-color) '()) (send dc set-pen "white" 1 'solid) (send dc set-brush "white" 'transparent) 
                                                       (send dc draw-polygon (send poly get-points))) 
          (else (send dc set-pen (send poly get-color) 1 'solid) (send dc set-brush (send poly get-color) 'solid)
                (send dc draw-polygon (send poly get-points))))
    ))

(define polygon?
  (lambda (object)
    (cond ((equal? (send object type?) 'polygon) #t)
          (else #f))))

(define scene%
  (class object%
    (super-new)
    (init-field objects)

    (define/public type?
      (lambda ()
      'scene))
    
    (define lessthandepth
      (lambda (a b)
        (cond ((< (depth a) (depth b)) #t)
          (else #f))))
    
    (define/public draw
      (lambda ()
        (for-each (lambda (arg) (send arg draw)) (sort objects lessthandepth))
        ))
    ))

(define scene
  (lambda (objs)
    
    (new scene% [objects objs])))

(define animate-me
 (lambda ()
   (define scn (scene (list (rectangle (point 0 100) (point 500 400) "blue" 3) ;ground
 
                            ;diagonal lines
                            (polygon (point 0 50) (point 450 500) "orange" 5) 
                            (polygon (point 0 150) (point 350 500) "orange" 5) 
                            (polygon (point 0 250) (point 250 500) "orange" 5)
                            (polygon (point 0 350) (point 150 500) "orange" 5)
                            (polygon (point 0 450) (point 50 500) "orange" 5)
                            (polygon (point 50 0) (point 500 450) "orange" 5)
                            (polygon (point 150 0) (point 500 350) "orange" 5)
                            (polygon (point 250 0) (point 500 250) "orange" 5)
                            (polygon (point 350 0) (point 500 150) "orange" 5)
                            (polygon (point 450 0) (point 500 50) "orange" 5)
                            
                            (polygon (point 50 500) (point 500 50) "orange" 5)
                            (polygon (point 150 500) (point 500 150) "orange" 5)
                            (polygon (point 250 500) (point 500 250) "orange" 5)
                            (polygon (point 350 500) (point 500 350) "orange" 5)
                            (polygon (point 450 500) (point 500 450) "orange" 5)
                            (polygon (point 0 450) (point 450 0) "orange" 5)
                            (polygon (point 0 350) (point 350 0) "orange" 5)
                            (polygon (point 0 250) (point 250 0) "orange" 5)
                            (polygon (point 0 150) (point 150 0) "orange" 5)
                            (polygon (point 0 50) (point 50 0) "orange" 5)
                            
                            
                            ;top triangles grey
                            (polygon (point 0 0) (point 50 50) (point 100 0) (point 150 50) (point 200 0) (point 250 50) (point 300 0)
                                     (point 350 50) (point 400 0) (point 450 50) (point 500 0) 
                                     "gray" 2)
                            
                            ;bottom triangles red
                            (polygon (point 0 500) (point 50 450) (point 100 500) (point 150 450) (point 200 500) (point 250 450) (point 300 500)
                                     (point 350 450) (point 400 500) (point 450 450) (point 500 500)
                                     "red" 2)
                            
                            ;green diamonds on bottom
                             (polygon (point 0 400) (point 50 350) (point 100 400) (point 50 450) 
                                      "green" 4)
 
                              (polygon (point 100 400) (point 150 350) (point 200 400) (point 150 450) 
                                      "green" 4)

                              (polygon (point 200 400) (point 250 350) (point 300 400) (point 250 450) 
                                      "green" 4)
                              
                              (polygon (point 300 400) (point 350 350) (point 400 400) (point 350 450) 
                                      "green" 4)

                              (polygon (point 400 400) (point 450 350) (point 500 400) (point 450 450) 
                                      "green" 4)
                            
                            
                            ;yellow diamonds on top
                             (polygon (point 0 100) (point 50 50) (point 100 100) (point 50 150) 
                                      "yellow" 4)
 
                              (polygon (point 100 100) (point 150 50) (point 200 100) (point 150 150)   
                                      "yellow" 4)
                              
                              (polygon (point 200 100) (point 250 50) (point 300 100) (point 250 150)   
                                      "yellow" 4)
                              
                               (polygon (point 300 100) (point 350 50) (point 400 100) (point 350 150)   
                                      "yellow" 4)
                               
                                (polygon (point 400 100) (point 450 50) (point 500 100) (point 450 150)  
                                      "yellow" 4)
                               
                            ))) 
   (draw scn)))

(animate-me)