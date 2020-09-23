% copy one list to another (Ayesha)
copyList(L,R) :- 
	copy(L,R).
	copy([],[]).
	copy([H|T1],[H|T2]) :- 
	copy(T1,T2).

% print a list element one by one (Ayesha)
printlist([]).
  printlist([H|Tail]) :-
   write(H),nl,
   printlist(Tail).

% get first element of a list (Ayesha)
get_first_elem(X,Y):-  
   X = [Z|_], Y = Z.

% get tail of a list (Ayesha)
get_tail(X,Y):-  
   X = [_|W], Y = W.
 
 % get second element of a list (Ayesha)
get_second_elem(X,Y):- 
   X= [_,S|_], Y = S.
 
 % get second last elem of a list (Ayesha)
get_secondlast_elem(X,Y):- 
    X= [_,_,_,P|_], Y = P.
 
 % if parameter is a list (Ayesha)
if_list(X):- 
   X = [ ]; X = [_|_].
 
% if list has single elem (Ayesha)
has_single_elem(X):- 
    X = [_|Z], Z = [ ]. 
 
cons(X,Y,Z):- Z = [X|Y].

% generate K random numbers in the range [1,N] (Ayesha)
randseq(K,N,List):-
  randset(K,N,Set),
  random_permutation(Set,List).

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
	
empty_list(N,Xs) :- N > 0, empty_list(N,[],Xs).
empty_list(0,Xs,Xs).
empty_list(N,Xs1,Xs) :- 
	N1 is N - 1,
	empty_list(N1,[0|Xs1],Xs).
	
empty_field(X,Y,Fs) :- empty_field(X,Y,[],Fs).
empty_field(_,0,Fs,Fs).
empty_field(X,Y,Fs0,Fs) :-
	empty_list(X,F),
	Y1 is Y -1,
	empty_field(X,Y1,[F|Fs0],Fs).
	
empty_field(X,Y,Z,Fs) :- empty_field(X,Y,Z,[],Fs).
empty_field(_,_,0,Fs,Fs).
empty_field(X,Y,Z,Fs0,Fs) :-
	empty_field(X,Y,F),
	Z1 is Z -1,
	empty_field(X,Y,Z1,[F|Fs0],Fs).

del_first_items([], [], []).
del_first_items([[H|B]|T], [H|T1], [B|T2]) :-
	B \== [],
	del_first_items(T, T1, T2).
del_first_items([[H|B]|T], [H|T1], T2) :-
	B == [],
	del_first_items(T, T1, T2).
	
del_last_items([], []).
del_last_items([X|Xs], [Y|Ys]) :-
	list_butlast(X,Y),
	del_last_items(Xs, Ys).
   
   
nth0_2D(X,Y,Is,Os) :-
	nth0(Y,Is,I1s),
	nth0(X,I1s,Os).	
	
nth0_3D(X,Y,Z,Is,Os) :-
	nth0(X,Is,I1s),
	nth0(Z,I1s,I2s),
	nth0(Y,I2s,Os).
	
	
list_butlast([X|Xs], Ys) :-         
   list_butlast(Xs, Ys, X).       

list_butlast([], [], _).
list_butlast([X1|Xs], [X0|Ys], X0) :-  
   list_butlast(Xs, Ys, X1). 
   
add_to_each_list_element([],_,[]).
add_to_each_list_element([X|Xs],A,[Y|Ys]) :-
	Y is X + A,
	add_to_each_list_element(Xs,A,Ys).
	
%:- use_module(library(lambda)).
%list_sum(L1, L2, L3) :-
%    maplist(\X^Y^Z^(Z is X + Y), L1, L2, L3).

concatinate_sub_lists([],[],[]).
concatinate_sub_lists([],Ys,Ys).
concatinate_sub_lists(Xs,[],Xs).
concatinate_sub_lists([X|Xs],[Y|Ys],[Z|Zs]):-
	append(X,Y,Z),
	concatinate_sub_lists(Xs,Ys,Zs).
	