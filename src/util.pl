reverse([],[]).
reverse([X|Xs], Zs) :- reverse(Xs,Ys), append(Ys, [X],Zs). 

flatten([],[]).
flatten(X,[X]) :- atomic(X), X \== [].
flatten([X|Xs], Zs) :- flatten(X, Ys1), flatten(Xs, Ys2), append(Ys1,Ys2,Zs).



isort([],[]).
isort([X|Xs],Ys) :- isort(Xs,Zs), insert(X,Zs,Ys).

insert(X,[],[X]).
insert(X,[Y|Ys],[Y|Zs]) :- X > Y, insert(X, Ys, Zs).
insert(X,[Y|_],[X,Y|_]) :- X =< Y.

sum_list(Xs, Sum) :- sum_list(Xs, 0, Sum).
sum_list([], Sum, Sum).
sum_list([X|Xs], Sum0, Sum) :-
  Sum1 is Sum0 + X,
  sum_list(Xs, Sum1, Sum).

invert_2Dlist(Xs,Ys) :- invert_2Dlist(Xs,[],Ys).
invert_2Dlist([],Ys,Ys).
invert_2Dlist(Xs,Ys1,Ys) :-
	del_first_items(Xs,Y,Xs1),
	append(Ys1,[Y],Ys2),
	invert_2Dlist(Xs1,Ys2,Ys).
	
empty_list(N,Xs) :- empty_list(N,[],Xs).
empty_list(0,Xs,Xs).
empty_list(N,Xs1,Xs) :- 
	N1 is N - 1,
	empty_list(N1,[0|Xs1],Xs).

del_first_items([], [], []).
del_first_items([[H|B]|T], [H|T1], [B|T2]) :-
	B \== [],
	del_first_items(T, T1, T2).
del_first_items([[H|B]|T], [H|T1], T2) :-
	B == [],
	del_first_items(T, T1, T2).
   
   
nth0_2D(X,Y,Is,Os) :-
	nth0(Y,Is,I1s),
	nth0(X,I1s,Os).	
	
list_butlast([X|Xs], Ys) :-         
   list_butlast(Xs, Ys, X).       

list_butlast([], [], _).
list_butlast([X1|Xs], [X0|Ys], X0) :-  
   list_butlast(Xs, Ys, X1). 