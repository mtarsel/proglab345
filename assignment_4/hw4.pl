% Sean Franklin - 0177990
% HW 4

try(S,X,Comment):-
    write('Try:'),
    write(S),write('|- '),write(X),
    writeln(Comment).
	
imply(A,B):- B.
imply(A,B):- not(A).
and(A,B):- A,B.
or(A,B):- A.
or(A,B):- B.

% deduce(+Premises,+Term)
% decides if there is a sequence of moves in Natural Deduction from the set of
% Premises which yeild the target Term.

% Copy Rule : ! |- A
deduce(S,X):- member(X,S).

% Falsehood elimination
deduce(S,X) :- member(false,S).

% AND Introduction
deduce(S,and(X,Y)) :- member(X,S), member(Y,S).

% AND Elimination
deduce(S,X) :- member(and(X,Y),S).
deduce(S,X) :- member(and(Y,X),S).
deduce(S,X) :- member(and(X,Y),S).

% OR Elimination
deduce(S,X) :- member(or(A,B),S),
               member(imply(A,X),S),
               member(imply(B,X),S).

% OR Introduction
deduce(S,or(X,Y)) :- member(X,S).
deduce(S,or(X,Y)) :- member(Y,S).

% Modus Ponens
deduce(S,X) :- member(imply(Y,X),S), member(Y,S).

% Negation Introduction
deduce(S,X) :- deduce([not(X)|S],false).
deduce(S,not(X)) :- deduce([X|S],false).

% Implication Introduction
deduce(S,imply(X,Y)) :- deduce([X|S],Y).

% Double-Negation Introduction
deduce(S,not(not(X))) :- member(X,S).

% False Introduction
deduce(S,false) :- member(A,S), member(not(A),S).

% Double-Negation Elimination
deduce(S,X) :- member(not(not(X)),S).

% Conjunctive Introduction
%conjunctive_intorduction(S,and(X,UY),N):- member(X,S),member(Y,S).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Test Section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
	test_contrapositive, 
	test_and_commutativity, 
	test_or_commutativity, 
	test_associativity, 
	test_distributivity, 
	test_demorgan,
	test_modus_tollens.
