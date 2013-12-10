#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define who
  (lambda ()
    (whos-on-first-loop '())))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define select-any-from-list
  (lambda (ls)
    (list-ref ls (random (length ls)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define writeln
  (lambda (sentence)
    (write sentence)
    (newline)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define wrap-it-up
  (lambda ()
    (writeln '(have a good day))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define exists?
  (lambda (item ls)
    (cond ((null? ls) #f)
          ((equal? item (car ls)) #t)
    (else (exists? item (cdr ls))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define list-ref
  (lambda (ls index)
    (cond ((null? ls) '())
          ((zero? index) (car ls))
    (else (list-ref (cdr ls) (- index 1))))))


(define my-prefix
  (lambda (ls1 ls2)
    (cond ((null? ls1) #t)
          ((null? ls2) #f)
          ((equal? (car ls1) (car ls2))(my-prefix (cdr ls1) (cdr ls2)))
    (else #f))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define subsequence?
  (lambda (ls1 ls2)
    (cond ((null? ls1) #t)
          ((null? ls2) #f)
          ((my-prefix ls1 ls2) #t)
    (else ( subsequence? ls1 (cdr ls2))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define cue-part
  (lambda (pair)
    (car pair)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define response-part
  (lambda (pair)
    (cadr pair)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define any-good-fragments? 
  (lambda (list-of-cues sentence)
    (cond ((null? list-of-cues) #f)
          ((subsequence? (car list-of-cues) sentence) #t)
    (else (any-good-fragments? (car list-of-cues) sentence)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define wants-to-end? 
  (lambda (sentence)
    (exists? sentence '((i quit) (screw this)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define get-context 
  (lambda (sentence context)
    (define helper
      (lambda (list-of-pairs)
       (cond((null? list-of-pairs) context)
             ((any-good-fragments? (cue-part (car list-of-pairs)) sentence) (response-part (car list-of-pairs)))
             (else (helper cdr list-of-pairs)))))
    (helper *context-words*)))
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define try-strong-cues
  (lambda (sentence)
    (define helper
      (lambda (list-of-pairs)
        (cond((null? list-of-pairs)'())
             ((any-good-fragments? (cue-part (car list-of-pairs) ) sentence)
              (select-any-from-list (response-part(car list-of-pairs))))
             (else(helper (cdr list-of-pairs))))))
      (helper *strong-cues*)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define *strong-cues*
	  '( ( ((the names) (their names))
	       ((whos on first whats on second i dont know on third)
 	        (whats on second whos on first i dont know on third)) )

	     ( ((suppose) (lets say) (assume))
	       ((okay) (why not) (sure) (it could happen)) )

	     ( ((i dont know))
	       ((third base) (hes on third)) )
	   ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define *hedges*
	  '((its like im telling you)
	    (now calm down)
	    (take it easy)
	    (its elementary lou)
	    (im trying to tell you)
	    (but you asked)))

(define hedge_h
  (lambda (ls x)
    (if (x = 0)
        (car ls)
        (hedge_h (cdr ls) (x - 1))
        )))

(define hedge 
  (lambda ()
    (hedge_h *hedges* (random (length *hedges*)))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define *context-words*
	  `( ( ((first)) first-base )
	     ( ((second)) second-base )
	     ( ((third)) third-base )))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define *weak-cues*
  '( ( ((who) (whos) (who is))
       ((first-base)
           ((thats right) (exactly) (you got it)
	    (right on) (now youve got it)))
       ((second-base third-base)
           ((no whos on first) (whos on first) (first base))) )
     ( ((what) (whats) (what is))
       ((first-base third-base)
	   ((hes on second) (i told you whats on second)))
       ((second-base)
	   ((right) (sure) (you got it right))) )
     ( ((whats the name))
       ((first-base third-base)
	   ((no whats the name of the guy on second)
	    (whats the name of the second baseman)))
       ((second-base)
	((now youre talking) (you got it))))
   ))

(define context-responses-part
  (lambda (object)
    (cdr object)))

(define weak-context-part
  (lambda (pair)
    (car pair)))

(define weak-response-part
  (lambda (pair)
    (cadr pair)))


(define try-weak-cues
  (lambda (sentence context)
    (define helper2
      (lambda (list-of-context-responses)
        (cond ((null? list-of-context-responses) '())
              ((exists? context (weak-context-part (car list-of-context-responses)))
               (select-any-from-list (weak-response-part (car list-of-context-responses))))
              (else (helper2 (cdr list-of-context-responses))))))
    (define helper
      (lambda (list-of-weak-cues)
        (cond ((null? list-of-weak-cues) '())
              ((any-good-fragments? (cue-part (car list-of-weak-cues)) sentence)
               (helper2 (context-responses-part (car list-of-weak-cues))))
              (else (helper (cdr list-of-weak-cues))))))
    (helper *weak-cues*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define whos-on-first-loop 
  (lambda (old-context)
    (let ((costellos-line (read)))
      (let ((new-context (get-context costellos-line old-context)))
        (let ((strong-reply (try-strong-cues costellos-line)))
          (let ((weak-reply (try-weak-cues costellos-line new-context))) 
            (cond ((not (null? strong-reply))
                   (writeln strong-reply)
                   (whos-on-first-loop (get-context strong-reply new-context)))
                  ((not (null? weak-reply))
                   (writeln weak-reply)
                   (whos-on-first-loop (get-context weak-reply new-context)))
                  ((wants-to-end? costellos-line)
                   (wrap-it-up))
                  (else 
                   (writeln (hedge))
                  (whos-on-first-loop new-context)))))))))