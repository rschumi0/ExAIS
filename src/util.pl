:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-use_module(library(lambda)).
:-use_module(library(matrix)).

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

% generate K random numbers in the range [1, N]
randseq(K, N, List):-
  randset(K, N, Set),
  random_permutation(Set, List).

% calculate activation functions
 calc_relu(X, Y):- Y is max(0,X).   

%reverse([],[]).
%reverse([X|Xs], Zs) :- reverse(Xs,Ys), append(Ys, [X],Zs). 

%flatten([],[]).
%flatten(X,[X]) :- atomic(X), X \== [].
%flatten([X|Xs], Zs) :- flatten(X, Ys1), flatten(Xs, Ys2), append(Ys1,Ys2,Zs).

isort([],[]).
isort([X|Xs],Ys) :- isort(Xs,Zs), insert(X,Zs,Ys).

insert(X,[],[X]).
insert(X,[Y|Ys],[Y|Zs]) :- X > Y, insert(X, Ys, Zs).
insert(X,[Y|_],[X,Y|_]) :- X =< Y.


%sum_list(Xs, Sum) :- sum_list(Xs, 0, Sum).
%sum_list([], Sum, Sum).
%sum_list([X|Xs], Sum0, Sum) :-
%  Sum1 is Sum0 + X,
%  sum_list(Xs, Sum1, Sum).

invert_2Dlist(Xs,Ys) :- invert_2Dlist(Xs,[],Ys).
invert_2Dlist([],Ys,Ys).
invert_2Dlist(Xs,Ys1,Ys) :-
	del_first_items(Xs,Y,Xs1),
	append(Ys1,[Y],Ys2),
	invert_2Dlist(Xs1,Ys2,Ys).

empty_list(N,Xs) :- empty_list(0,N,Xs).
empty_list(I,N,Xs) :- N > 0, empty_list(I,N,[],Xs).
empty_list(_,0,Xs,Xs).
empty_list(I,N,Xs1,Xs) :- 
	N1 is N - 1,
	empty_list(I,N1,[I|Xs1],Xs).

empty_field(X,Y,Fs) :- empty_field2D(0,X,Y,Fs).
empty_field2D(I,X,Y,Fs) :- empty_field2D(I,X,Y,[],Fs).
empty_field2D(_,0,_,Fs,Fs).
empty_field2D(I,X,Y,Fs0,Fs) :-
	empty_list(I,Y,F),
	X1 is X -1,
	empty_field2D(I,X1,Y,[F|Fs0],Fs).
	
empty_field(X,Y,Z,Fs) :- empty_field3D(0,X,Y,Z,Fs).
empty_field3D(I,X,Y,Z,Fs) :- empty_field3D(I,X,Y,Z,[],Fs).
empty_field3D(_,0,_,_,Fs,Fs).
empty_field3D(I,X,Y,Z,Fs0,Fs) :-
	empty_field2D(I,Y,Z,F),
	X1 is X -1,
	empty_field3D(I,X1,Y,Z,[F|Fs0],Fs).
	
empty_field(X,Y,Z,Z1,Fs) :- empty_field4D(0,X,Y,Z,Z1,Fs).
empty_field4D(I,X,Y,Z,Z1,Fs) :- empty_field4D(I,X,Y,Z,Z1,[],Fs).
empty_field4D(_,0,_,_,_,Fs,Fs).
empty_field4D(I,X,Y,Z,Z1,Fs0,Fs) :-
	empty_field3D(I,Y,Z,Z1,F),
	X1 is X -1,
	empty_field4D(I,X1,Y,Z,Z1,[F|Fs0],Fs).

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
   
   

	
	
list_butlast([X|Xs], Ys) :-         
   list_butlast(Xs, Ys, X).       

list_butlast([], [], _).
list_butlast([X1|Xs], [X0|Ys], X0) :-  
   list_butlast(Xs, Ys, X1). 
   
add_to_each_list_element([],_,[]).
add_to_each_list_element([X|Xs],A,[Y|Ys]) :-
	Y is X + A,
	add_to_each_list_element(Xs,A,Ys).
	
subtract_from_each_list_element([],_,[]).
subtract_from_each_list_element([X|Xs],A,[Y|Ys]) :-
	Y is X - A,
	subtract_from_each_list_element(Xs,A,Ys).
	
multiply_each_list_element_with([],_,[]).
multiply_each_list_element_with([X|Xs],A,[Y|Ys]) :-
	Y is X * A,
	multiply_each_list_element_with(Xs,A,Ys).
	
divide_each_list_element_by([],_,[]).
divide_each_list_element_by([X|Xs],A,[Y|Ys]) :-
	Y is X / A,
	divide_each_list_element_by(Xs,A,Ys).
	
%:- use_module(library(lambda)).
% list_sum(L1, L2, L3) :-
%    maplist(\X^Y^Z^(Z is X + Y), L1, L2, L3).

concatinate_sub_lists([],[],[]).
concatinate_sub_lists([],Ys,Ys).
concatinate_sub_lists(Xs,[],Xs).
concatinate_sub_lists([X|Xs],[Y|Ys],[Z|Zs]):-
	append(X,Y,Z),
	concatinate_sub_lists(Xs,Ys,Zs).
	
nth0_2DallY(X,Is,Os) :-
	nth0(X,Is,Os).
	
nth0_3DallZ(X,Y,Is,Os) :-
	nth0(X,Is,I1s),
	nth0(Y,I1s,Os).
	
nth0_4DallZ(W,X,Y,Is,Os) :-
	nth0(W,Is,I0s),
	nth0(X,I0s,I1s),
	nth0(Y,I1s,Os).

nth0_2D(X,Y,Is,Os) :-
	nth0(X,Is,I1s),
	nth0(Y,I1s,Os).
	
nth0_3D(X,Y,Z,Is,Os) :-
	nth0(X,Is,I1s),
	nth0(Y,I1s,I2s),
	nth0(Z,I2s,Os).
	
nth0_4D(W,X,Y,Z,Is,Os) :-
	nth0(W,Is,I0s),
	nth0(X,I0s,I1s),
	nth0(Y,I1s,I2s),
	nth0(Z,I2s,Os).	
	
list_sum([Item], Item).
list_sum([Item1,Item2 | Tail], Total) :-
    list_sum([Item1+Item2|Tail], Total).
    
avg( [], 0 ).
avg( List, Avg ):- 
    list_sum( List, Sum ),
    length( List, Length), 
    (  Length > 0
    -> Avg is Sum / Length
    ;  Avg is 0
    ).
    
remove_non_numbers([],[]).
remove_non_numbers([H|T], [H1|T1]):- 
	is_list(H),
	remove_non_numbers(H,H1),
	remove_non_numbers(T,T1).
remove_non_numbers([H|T], NewT):- 
	atomic(H),
	not(number(H)),
	remove_non_numbers(T, NewT).
remove_non_numbers([H|T1], [H|T2]):-  
	atomic(H),
    	number(H),                   
    	remove_non_numbers(T1, T2).
    	
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).	

replace_atoms_with([],_,[]).
replace_atoms_with([H|T],R,[H1|T1]):- 
	is_list(H),
	replace_atoms_with(H,R,H1),
	replace_atoms_with(T,R,T1).
replace_atoms_with([H|T1], R, [R|T2]):-  
	atomic(H),                   
    	replace_atoms_with(T1, R, T2).

multiplicate(X,N,Xs) :- multiplicate(X,N,[],Xs).
multiplicate(_,0,Xs,Xs).
multiplicate(X,N,Xs0,Xs) :-
	N1 is N-1,
	multiplicate(X,N1,[X|Xs0],Xs).
	
compare_structure([H1|T1], [H2|T2]) :-
    is_list(H1),
    is_list(H2),
    compare_structure(H1, H2),
    compare_structure(T1, T2).
compare_structure([H1|T1], [H2|T2]) :-
    \+ is_list(H1),
    \+ is_list(H2),
    compare_structure(T1, T2).
compare_structure([], []).
	
tanh([],[]).	
tanh(X,Y) :- number(X), Y is tanh(X).
tanh([X|Xs],[Y|Ys]) :- tanh(X,Y), tanh(Xs,Ys). 

dot(V1, V2, N) :- maplist(product,V1,V2,P), sumlist(P,N).
product(N1,N2,N3) :- N3 is N1*N2.
mm_helper(M2, I1, M3) :- maplist(dot(I1), M2, M3).
mmult(M1, M2, M3) :- transpose(M2,MT), maplist(mm_helper(MT), M1, M3).

one_minus_x([],[]). 	
one_minus_x(X,Y) :- atomic(X), Y is 1 - X.
one_minus_x([X|Xs],[Y|Ys]) :- one_minus_x(X,Y), one_minus_x(Xs,Ys).

replace( [L|Ls] , 0 , Y , Z , [R|Ls] ) :-
  replace_column(L,Y,Z,R).                                     
replace( [L|Ls] , X , Y , Z , [L|Rs] ) :- 
  X > 0 ,                                 
  X1 is X-1 ,                             
  replace( Ls , X1 , Y , Z , Rs ).

replace_column( [_|Cs] , 0 , Z , [Z|Cs] ) .  
replace_column( [C|Cs] , Y , Z , [C|Rs] ) :-
  Y > 0 ,                                   
  Y1 is Y-1 ,                               
  replace_column( Cs , Y1 , Z , Rs ).
  
  
replace_all([],_,[]).
replace_all([H|T], R, [H1|T1]):- 
	is_list(H),
	replace_all(H,R,H1),
	replace_all(T,R,T1).
replace_all([H|T1], R, [R|T2]):-  
	atomic(H),                  
    	replace_all(T1, R, T2).
    	
    	
sub_length([I|_],L) :- length(I,L).

sub_sub_length([I|_],L) :- sub_length(I,L).

sub_sub_sub_length([I|_],L) :- sub_sub_length(I,L).
    	