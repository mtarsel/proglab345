% lab 7

% my_list(+Item)
% Decides if Item is a list.
%
my_list([]).
my_list([_|As]):-my_list(As).


% my_member(+Item,+List)
% Decides if Item is a member of List.
%
my_member(A, [A|As]).
my_member(A, [B|As]):- \+ A=B, my_member(A,As).


% my_length(+As,-N)
% Returns the length of list As in the variable N.
%
my_length([],0).
my_length([_|As], Answer) :- my_length(As, N), Answer is N+1.


% my_append(+As,+Bs,-Cs)
% Returns the append of two lists As and Bs in the list Cs.
%
my_append([],Bs,Bs).
my_append([A|As],Bs,[A|Cs]):-my_append(As,Bs,Cs).


% my_reverse(+As,-Bs)
% Returns the reverse of list As in the list Bs.
%
my_reverse([],[]).
my_reverse([A|As],Bs):-my_reverse(As,Xs),my_append(Xs,[A],Bs).


% my_prefix(+Pattern,+List)
% Decides if Pattern is a prefix of List.
%
my_prefix([], Bs).
my_prefix([A|As], [A|Bs]) :- my_prefix(As, Bs).


% my_subsequence(+Pattern,+List)
% Decides if Pattern is a subsequence (consecutive) of List.
%
my_subsequence([],Bs).
my_subsequence([A|As], [A|Bs]) :- prefix(As, Bs).
my_subsequence([A|As], [B|Bs]) :- my_subsequence([A|As], Bs).


% my_delete(+Item,+List,-Answer)
% Deletes all occurrences of Item from List and returns the result in Answer.
%
my_delete(A,[],[]).
my_delete(A,[A|As],Bs):-my_delete(A,As,Bs).
my_delete(A,[B|As],[B|Bs]):-\+ A=B, my_delete(A,As,Bs).
my_delete(A,[B|As],[B|Bs]):-my_delete(A,As,Bs).
