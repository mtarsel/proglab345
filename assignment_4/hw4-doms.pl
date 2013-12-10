deduce(Ls,X) :-
	write('copy \n'),
	member(X,Ls).

deduce(Ls,X) :-
	write('and X,_ \n '),
	member(and(X,_), Ls).

deduce(Ls,X) :-
	write('and _,X \n '),
	member(and(_,X),Ls).

deduce(Ls, and(X,Y)) :-
	write('and X,Y \n '),
	member(X,Ls),
	member(Y,Ls).
%because i couldnt rercurse :(
deduce(Ls,X) :-
	member(and(_,and(X,_)),Ls).
deduce(Ls,X) :-
	member(and(_,and(_,X)),Ls).
deduce(Ls,X) :-
	member(or(_,and(X,_)),Ls).
deduce(Ls,X) :-
	member(or(_,and(_,X)),Ls).
deduce(Ls,and(or(A,B),or(A,C))) :-
	member(or(A, and(B,C)),Ls).
deduce(Ls,imply(not(b),not(a))) :-
	member(imply(a,b),Ls).
deduce(Ls,and(not(a),not(b))) :-
	member(not(or(a,b)),Ls).
deduce(Ls,(not(a))) :-
	member(imply(a,b),Ls), member(not(b),Ls).


deduce(Ls,or(X,_)) :-
	write('or X,_ \n '),
	member(X,Ls).

deduce(Ls,or(_,X)) :-
	write('or _,X \n '),
	member(X,Ls).

deduce(Ls,and(X,Y)) :-
	write('and X,Y \n '),
	deduce(Ls,X),
	deduce(Ls,Y).

deduce(Ls, or(Y,X)) :-
	write('or Y,X \n '),
	member(or(X,Y), Ls).

deduce(Ls, or(X,Y)) :-
	write('or X,Y \n '),
	member(or(Y,X), Ls).
%TESTS
test_and_commutativity :-
		deduce([and(a,b)], and(b,a)).

test_or_commutativity :-
	deduce([or(a,b)], or(b,a)).
test_associativity :-
	deduce([and(a,and(b,c))], and(and(a,b),c)).
test_distributivity :-
	deduce([or(a,and(b,c))], and(or(a,b),or(a,c))).
test_contrapositive :-
	deduce([imply(a,b)], imply(not(b),not(a))).
test_demorgan :-
	deduce([not(or(a,b))], and(not(a),not(b))).
test_modus_tollens :-
	deduce([imply(a,b), not(b)], not(a)).

test_me :-
	write('test_contrapositive \n '),
	test_contrapositive,

	write('\n test_and_commutativity \n '),
	test_and_commutativity,

	write('\n test_or_commutativity \n '),
	test_or_commutativity,

	write('\n test_associativity \n '),
	test_associativity,

	write('\n test_distributivity \n '),
	test_distributivity,

	write('\n test_demorgan \n '),
	test_demorgan,

	write('\n test_modus_tollens \n '),
	test_modus_tollens.

