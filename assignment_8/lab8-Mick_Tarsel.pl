%Mick Tarsel

%helpers
member(A, [A|As]).
member(A, [B|As]):- \+ A=B, member(A,As).

reverse([],[]).
reverse([A|As],Bs):-reverse(As,Xs),append(Xs,[A],Bs).

prefix([], Bs).
prefix([A|As], [A|Bs]) :- prefix(As, Bs).

append([],Bs,Bs).
append([A|As],Bs,[A|Cs]):-
append(As,Bs,Cs).

delete_all(A,[],[]).
delete_all(A,[A|As],Bs):-delete_all(A,As,Bs).
delete_all(A,[B|As],Bs):-
	\+ A=B, delete_all(A,As,Bs).

% 1) solution without member

remove_duplicates([],[]).
remove_duplicates([A|As],Bs):-
	member(A,As), remove_duplicates(As,Bs).
remove_duplicates([A|As],[A|Bs]):-
	\+ member(A,As), remove_duplicates(As,Bs).

% 2) solution using member

remove_duplicates_two([],[]).
remove_duplicates_two([A|As], Bs) :- 
	member(A, As), remove_duplicates_two(As, Bs).
remove_duplicates_two([A|As],[A|Bs]):- 
	\+ member(A,As), remove_duplicates_two(As,Bs).

% 3) one-liner using prefix

suffix(As, Bs) :- reverse(As, Xs), reverse(Bs, Ys), prefix(Xs, Ys).

% 4) two-liner without prefix

suffix_two(As, As).
suffix_two(As, [B|Bs]):-suffix(As,Bs).

% 4) one-liner without prefix

suffix_three(As,Bs):-append(_,As,Bs).
