:-use_module(library(lambda)).
:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-use_module(library(matrix)).
:-use_module(library(cplint_util)).
:-[util].
:-[helperlayer].

add_lists(Xs,Ys,Zs) :- add_lists(Xs,Ys,[],Zs).
add_lists([],[],Zs,Zs).
add_lists([X|Xs],[],Z0s,Zs) :-
	append(Z0s,[X],Z1s),
	add_lists(Xs,[],Z1s,Zs).
add_lists([],[Y|Ys],Z0s,Zs) :-
	append(Z0s,[Y],Z1s),
	add_lists([],Ys,Z1s,Zs).
add_lists([X|Xs],[Y|Ys],Z0s,Zs) :-
	atomic(X),
	atomic(Y),
	Z is X + Y,
	append(Z0s,[Z],Z1s),
	add_lists(Xs,Ys,Z1s,Zs).
add_lists([X|Xs],[Y|Ys],Z0s,Zs) :-
	is_list(X),
	is_list(Y),
	add_lists(X,Y,Z),
	append(Z0s,[Z],Z1s),
	add_lists(Xs,Ys,Z1s,Zs).	
	
add_layer(Is1,Is2,Os) :- check_same_shape(Is1,Is2), add_lists(Is1,Is2,Os).
add_layer(Is,Os) :- check_same_shape(Is), tmpadd_lists(Is,[],Os).
tmpadd_lists([],Os,Os).
tmpadd_lists([I|Is],Os0,Os) :-
	add_lists(I,Os0,Os1),
	tmpadd_lists(Is,Os1,Os).
	
multiply_lists(Xs,Ys,Zs) :- multiply_lists(Xs,Ys,[],Zs).
multiply_lists([],[],Zs,Zs).
multiply_lists([X|Xs],[],Z0s,Zs) :-
	append(Z0s,[X],Z1s),
	multiply_lists(Xs,[],Z1s,Zs).
multiply_lists([],[Y|Ys],Z0s,Zs) :-
	append(Z0s,[Y],Z1s),
	multiply_lists([],Ys,Z1s,Zs).
multiply_lists([X|Xs],[Y|Ys],Z0s,Zs) :-
	atomic(X),
	atomic(Y),
	Z is X * Y,
	append(Z0s,[Z],Z1s),
	multiply_lists(Xs,Ys,Z1s,Zs).
multiply_lists([X|Xs],[Y|Ys],Z0s,Zs) :-
	is_list(X),
	is_list(Y),
	multiply_lists(X,Y,Z),
	append(Z0s,[Z],Z1s),
	multiply_lists(Xs,Ys,Z1s,Zs).	
	
multiply_layer(Is1,Is2,Os) :- check_same_shape(Is1,Is2), multiply_lists(Is1,Is2,Os).
multiply_layer(Is,Os) :- check_same_shape(Is), tmpmultiply_lists(Is,[],Os).
tmpmultiply_lists([],Os,Os).
tmpmultiply_lists([I|Is],Os0,Os) :-
	multiply_lists(I,Os0,Os1),
	tmpmultiply_lists(Is,Os1,Os).
	
subtract_lists(Xs,Ys,Zs) :- subtract_lists(Xs,Ys,[],Zs).
subtract_lists([],[],Zs,Zs).
subtract_lists([X|Xs],[],Z0s,Zs) :-
	append(Z0s,[X],Z1s),
	subtract_lists(Xs,[],Z1s,Zs).
subtract_lists([],[Y|Ys],Z0s,Zs) :-
	append(Z0s,[Y],Z1s),
	subtract_lists([],Ys,Z1s,Zs).
subtract_lists([X|Xs],[Y|Ys],Z0s,Zs) :-
	atomic(X),
	atomic(Y),
	Z is X - Y,
	append(Z0s,[Z],Z1s),
	subtract_lists(Xs,Ys,Z1s,Zs).
subtract_lists([X|Xs],[Y|Ys],Z0s,Zs) :-
	is_list(X),
	is_list(Y),
	subtract_lists(X,Y,Z),
	append(Z0s,[Z],Z1s),
	subtract_lists(Xs,Ys,Z1s,Zs).	
	

subtract_layer(Is1,Is2,Os) :- check_same_shape(Is1,Is2), subtract_lists(Is1,Is2,Os).
subtract_layer([Is1,Is2],Os) :- check_same_shape(Is1,Is2), subtract_lists(Is1,Is2,Os).
	
%minimum_list([1,2,3,4],[4,3,2,1],X).
%minimum_layer([[[1,2,3,4],[5,2,3,4]],[[4,3,2,1],[6,4,3,4]],[[7,8,9,0],[3,2,8,4]]],X).
%minimum_layer([[1,2,3,4],[4,3,2,1],[7,8,9,0]],X).
%minimum_layer([[[1,2,3,4]],[[4,3,2,1]],[[7,8,9,0]]],X).
minimum_list(Xs,Ys,Zs) :- minimum_list(Xs,Ys,[],Zs).
minimum_list([],[],Zs,Zs).
minimum_list([X|Xs],[],Z0s,Zs) :-
	append(Z0s,[X],Z1s),
	add_lists(Xs,[],Z1s,Zs).
minimum_list([],[Y|Ys],Z0s,Zs) :-
	append(Z0s,[Y],Z1s),
	add_lists([],Ys,Z1s,Zs).
minimum_list([X|Xs],[Y|Ys],Z0s,Zs) :-
	atomic(X),
	atomic(Y),
	(X < Y -> Z is X;Z is Y),
	append(Z0s,[Z],Z1s),
	minimum_list(Xs,Ys,Z1s,Zs).
minimum_list([X|Xs],[Y|Ys],Z0s,Zs) :-
	is_list(X),
	is_list(Y),
	minimum_list(X,Y,Z),
	append(Z0s,[Z],Z1s),
	minimum_list(Xs,Ys,Z1s,Zs).
	
minimum_layer(Is1,Is2,Os) :- check_same_shape(Is1,Is2), minimum_list(Is1,Is2,Os).
minimum_layer(Is,Os) :- check_same_shape(Is), tmpminimum_layer(Is,[],Os).
tmpminimum_layer([],Os,Os).
tmpminimum_layer([I|Is],Os0,Os) :-
	minimum_list(I,Os0,Os1),
	tmpminimum_layer(Is,Os1,Os).
	
maximum_list(Xs,Ys,Zs) :- maximum_list(Xs,Ys,[],Zs).
maximum_list([],[],Zs,Zs).
maximum_list([X|Xs],[],Z0s,Zs) :-
	append(Z0s,[X],Z1s),
	add_lists(Xs,[],Z1s,Zs).
maximum_list([],[Y|Ys],Z0s,Zs) :-
	append(Z0s,[Y],Z1s),
	add_lists([],Ys,Z1s,Zs).
maximum_list([X|Xs],[Y|Ys],Z0s,Zs) :-
	atomic(X),
	atomic(Y),
	(X > Y -> Z is X;Z is Y),
	append(Z0s,[Z],Z1s),
	maximum_list(Xs,Ys,Z1s,Zs).
maximum_list([X|Xs],[Y|Ys],Z0s,Zs) :-
	is_list(X),
	is_list(Y),
	maximum_list(X,Y,Z),
	append(Z0s,[Z],Z1s),
	maximum_list(Xs,Ys,Z1s,Zs).
	
maximum_layer(Is1,Is2,Os) :- check_same_shape(Is1,Is2), maximum_list(Is1,Is2,Os).
maximum_layer(Is,Os) :- check_same_shape(Is), tmpmaximum_layer(Is,[],Os).
tmpmaximum_layer([],Os,Os).
tmpmaximum_layer([I|Is],Os0,Os) :-
	maximum_list(I,Os0,Os1),
	tmpmaximum_layer(Is,Os1,Os).
	
	
average_layer(Is1,Is2,[Os]):- check_same_shape(Is1,Is2), average_list([Is1,Is2],Os).
average_layer(Is,Os) :- check_same_shape(Is), average_list(Is,Os).
%average_list([[1,2,3],[3,2,2]],X).
%average_list([[[1,2,3]],[[3,2,2]]],X).
%average_list([[[1,2,3],[4,6,3]],[[3,2,2],[8,2,4]]],X).
%average_list([[[[1,2,3],[4,6,3]]],[[[3,2,2],[8,2,4]]]],X).
average_list(Xs,Ys) :- average_list(Xs,[],Ys).
average_list([],Ys,Ys).
average_list([[X|XTs]|Xs],Y0s,Ys) :-
	atomic(X),
	sum_first_items([[X|XTs]|Xs],Y),
	del_first_items([[X|XTs]|Xs],_,X1s),
	length([[X|XTs]|Xs],L),
	Y1 is Y / L,
	append(Y0s,[Y1],Y1s),
	average_list(X1s,Y1s,Ys).
average_list([[X|XTs]|Xs],Y0s,Ys) :-
	is_list(X),
	del_first_items([[X|XTs]|Xs],X0s,X1s),
	average_list(X0s,Zs),
	append(Y0s,[Zs],Y1s),
	average_list(X1s,Y1s,Ys).
	
sum_first_items(Xs, Sum) :- sum_first_items(Xs,0,Sum).
sum_first_items([],Sum,Sum).
sum_first_items([[X|_]|Xs], Sum0, Sum) :-
    atomic(X),
    Sum1 is Sum0 + X,
    sum_first_items(Xs, Sum1, Sum).

% sum of the last items in a list of list
% sum_last_items([[8,1],[4,2],[2,4],[6,7]],0,X).
% X = 14.
sum_last_items(Ys, Sum) :- sum_last_items(Ys, 0, Sum).
sum_last_items([],Sum,Sum).
sum_last_items([[_|Y]|Ys], Sum0, Sum) :-
    Sum1 is Sum0 + Y,
    sum_last_items(Ys, Sum1, Sum).

% reduce_sum along all directions, If axis is None (0), all dimensions are reduced, and a tensor with a single element is returned.
% sum_all_items([[8,1],[4,2]],0,X).
% X = 15.
sum_all_items(X, Sum) :- sum_all_items(X, 0, Sum).
sum_all_items([], Sum, Sum).
sum_all_items(X, _, Sum) :-
    sum_first_items(X, Sum1),
    sum_last_items(X, Sum2),
    Sum is Sum1 + Sum2.

% reduce one and two-dimension tensor along the first dimension (row)
% ?- reduce_sum_one([[8,1],[4,2],[2,4],[6,7]],[],X).
% Correct to: "activation:reduce_sum_one([[8,1],[4,2],[2,4],[6,7]],[],X)"? yes
% X = [20, 14].

reduce_sum_one(X, 0, Y) :- reduce_sum_one(X, [], Y).
reduce_sum_one([], Y, Y).
reduce_sum_one(X, Y0, Y) :-
    sum_first_items(X, 0, Sum),
    append(Y0, [Sum], Ys),
    sum_last_items(X, 0, Sum1),
    append(Ys, [Sum1], Y).
  
  
  
dimension_length(Is,0,O) :-
	length(Is,O).	
dimension_length([I|_],D,O):-
	D1 is D - 1,
	dimension_length(I,D1,O).
	
	
 	
check_valid_axis([I1|Is1],[I2|_],Axis1,Axis2) :-
		A1 is Axis1 - 1,
		A2 is Axis2 - 1,
		shape(I1,Shape1),
		shape(I2,Shape2),
		length(Shape1,L1),
		length(Shape2,L2),
		((A1 >= L1; A2 >= L2) -> (write("Invalid Model, Badness Value: "), 
    		     writeln("99"),  
    		     S1 = "Dot Axis Error, Input Shape ",
    	             shape([I1|Is1],Shape),
    	             term_string(Shape,S2),
    		     string_concat(S1,S2,S), 
                     throw(S));true),
		nth0(A1,Shape1,D1),
		nth0(A2,Shape2,D2),
		(D1 =\= D2 -> (write("Invalid Model, Badness Value: "), 
		     depth([I1|Is1],DT),
		     D is DT - Axis1,
		     pow(100,D-1,Factor),
		     Badness is Factor*abs(D1-D2),
    		     writeln(Badness),  
    		     S1 = "Dot Axis Error, Input Shape ",
    	             shape([I1|Is1],Shape),
    	             term_string(Shape,S2),
    		     string_concat(S1,S2,S), 
                     throw(S));true).

dot_layer([],[],_,_,[]).
dot_layer([I1|Is1],[I2|Is2],Axis1,Axis2,[O|Os]):-
	check_same_and_max_dimensions([I1|Is1],[I2|Is2],3),
	%check_same_dimensions([I1|Is1],[I2|Is2]),
	%check_max_dimensions([I1|Is1], 3),
	%check_max_dimensions([I2|Is2], 3),
	check_valid_axis([I1|Is1],[I2|Is2],Axis1,Axis2),
	dot(I1,I2,Axis1,Axis2,[O]),
	dot_layer(Is1,Is2,Axis1,Axis2,Os).
dot_layer([Is1,Is2],Axis1,Axis2,Os):-
	dot_layer(Is1,Is2,Axis1,Axis2,Os).
	

dot(Xs,Ys,Dim,Zs) :- dot(Xs,Ys,Dim,Dim,Zs).
dot(Xs,Ys,0,0,Zs) :-
	depth(Xs,1),
	transpose([Ys],Ys1),
	mmmult([Xs],Ys1,Zs).
dot(Xs,Ys,1,1,Zs) :-
	depth(Xs,1),
	transpose([Ys],Ys1),
	mmmult([Xs],Ys1,Zs).
dot(Xs,Ys,0,0,[Zs]) :-
	depth(Xs,D),
	D>1,
	(D < 3 -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	mmmult(Xs1,Ys,Zs).
dot(Xs,Ys,1,1,[Zs]) :-
	depth(Xs,D),
	D>1,
	(D < 3 -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	mmmult(Xs1,Ys,Zs).
dot(Xs,Ys,1,2,[Zs]) :-
	depth(Xs,2),
	transpose(Xs,Xs1),
	transpose(Ys,Ys1),
	mmmult(Xs1,Ys1,Zs).
dot(Xs,Ys,2,1,[Zs]) :-
	depth(Xs,2),
	mmmult(Xs,Ys,Zs).

dot(Xs,Ys,2,2,[Zs]) :-
	depth(Xs,2),
	transpose(Ys,Ys1),
	mmmult(Xs,Ys1,Zs).
	
dot(Xs,Ys,1,2,Zs) :-
	depth(Xs,3),
	map_transpose([Xs], X1),
	map_map_transpose(X1,X2),
	transpose([Ys],Y1),
	map_map_transpose(Y1,Y2),
	map_transpose(Y2,Y3),
	mmmult(X2,Y3,Z1),
	map_transpose(Z1,Zs).
	
dot(Xs,Ys,2,1,Zs) :-
	depth(Xs,3),
	transpose([Xs],X1),
	map_map_transpose(X1,X2),
	%transpose(X2,X3),
	map_transpose([Ys],Y1),
	%transpose(Y1,Y2),
	mmmult(X2,Y1,Z1),
	%transpose(Z,Z1),
	map_transpose(Z1,Zs).
	


dot(Xs,Ys,1,3,[Zs]) :-
	depth(Xs,3),
	maplist(transpose, Xs, Xs1),
	maplist(transpose, Ys, Ys1),
	mmmult(Xs1,Ys1,Zs).
	
dot(Xs,Ys,2,2,[Zs]) :-
	depth(Xs,3),
	maplist(transpose, Xs, Xs1),
	mmmult(Xs1,Ys,Zs).
dot(Xs,Ys,2,3,[Zs]) :-
	depth(Xs,3),
	maplist(transpose, Xs, Xs1),
	maplist(transpose, Ys, Ys1),
	mmmult(Xs1,Ys1,Zs).
dot(Xs,Ys,3,1,[Zs]) :-
	depth(Xs,3),
	mmmult(Xs,Ys,Zs).
dot(Xs,Ys,3,2,[Zs]) :-
	depth(Xs,3),
	mmmult(Xs,Ys,Zs).
dot(Xs,Ys,3,3,[Zs]) :-
	depth(Xs,3),
	maplist(transpose, Ys, Ys1),
	mmmult(Xs,Ys1,Zs).


/*
dot_layer([[[4, 2], [4, 2]], [[4, 6], [9, 0]]], [[[9, 5], [4, 5]], [[7, 8], [9, 1]]], 2, 1, X)
-------------------------------------------------------------------------------------
X = [[[[52, 40], [26, 20]], [[109, 41], [42, 48]]]] X = [[[[52, 40], [26, 20]], [[109, 41], [42, 48]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/activation.pl:64:Warning:    Redefined static procedure innner_transpose/2Warning:    Previously defined at /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl:596Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:556:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[[64.0000000, 52.0000000], [52.0000000, 24.0000000]], [[32.0000000, 26.0000000], [26.0000000, 12.0000000]]], [[[99.0000000, 92.0000000], [97.0000000, 29.0000000]], [[54.0000000, 30.0000000], [24.0000000, 30.0000000]]]]]
Expected (Unparsed): [[[[52, 40], [26, 20]], [[109, 41], [42, 48]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/activation.pl:64:Warning: Redefined static procedure innner_transpose/2Warning: Previously defined at /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl:596Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:556:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[[64, 52], [52, 24]], [[32, 26], [26, 12]]], [[[99, 92], [97, 29]], [[54, 30], [24, 30]]]]]
Expected: [[[[52, 40], [26, 20]], [[109, 41], [42, 48]]]]
*/

mmmult([],[],[]).
mmmult(Xs,Ys,Zs) :-
	depth(Xs,2),
	mmult(Xs,Ys,Zs).
mmmult([X],[Y|Ys],[Z|Zs]) :-
	depth([X],3),
	length([X],1),
	length([Y|Ys],L),
	L>1,
	mmult(X,Y,Z),
	mmmult([X],Ys,Zs).
mmmult([X|Xs],[Y],[Z|Zs]) :-
	depth([X|Xs],3),
	length([Y],1),
	length([X|Xs],L),
	L>1,
	mmult(X,Y,Z),
	mmmult(Xs,[Y],Zs).
mmmult([X|Xs],[Y|Ys],[Z|Zs]) :-
	depth([X|Xs],3),
	mmult(X,Y,Z),
	mmmult(Xs,Ys,Zs).
	
mmmult([X],[Y|Ys],[Z|Zs]) :-
	depth([X],4),
	length([X],1),
	length([Y|Ys],L),
	L>1,
	mmmult(X,Y,Z),
	mmmult([X],Ys,Zs).
mmmult([X|Xs],[Y],[Z|Zs]) :-
	depth([X|Xs],4),
	length([Y],1),
	length([X|Xs],L),
	L>1,
	mmmult(X,Y,Z),
	mmmult(Xs,[Y],Zs).
mmmult([X|Xs],[Y|Ys],[Z|Zs]) :-
	depth([X|Xs],4),
	mmmult(X,Y,Z),
	mmmult(Xs,Ys,Zs).
mmmult(_,[],[]).
mmmult([],_,[]).

	
matrix_rotated(Xss, Zss) :-
   transpose(Xss, Yss),
   maplist(reverse, Yss, Zss).
  
/*
temp_layer(Xs,Ys,1,1,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs,Ys,Zs).
temp_layer(Xs,Ys,1,2,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	transpose(Xs,Xs1),
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs1,Ys,Zs).
temp_layer(Xs,Ys,1,3,[Zs]) :-
	(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs1,Ys,Zs).
temp_layer(Xs,Ys,1,4,[Zs]) :-
	transpose(Xs,Xs1),
	(depth(Xs,2) -> transpose(Xs1,Xs2) ; maplist(transpose, Xs1, Xs2)),
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs2,Ys,Zs).
temp_layer(Xs,Ys,1,5,[Zs]) :-
	(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	transpose(Xs1,Xs2),
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs2,Ys,Zs).
temp_layer(Xs,Ys,2,1,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	transpose(Ys,Ys1),
	mmmult(Xs,Ys1,Zs).
temp_layer(Xs,Ys,3,1,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs,Ys1,Zs).
temp_layer(Xs,Ys,4,1,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	transpose(Ys,Ys1),
	(depth(Ys,2) -> transpose(Ys1,Ys2) ; maplist(transpose, Ys1, Ys2)),
	mmmult(Xs,Ys2,Zs).
temp_layer(Xs,Ys,5,1,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	transpose(Ys1,Ys2),
	mmmult(Xs,Ys2,Zs).
temp_layer(Xs,Ys,1,6,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	transpose(Xs,Xs1),
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	transpose(Ys,Ys1),
	mmmult(Xs1,Ys1,Zs).
temp_layer(Xs,Ys,1,7,[Zs]) :-
	(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs1,Ys1,Zs).
temp_layer(Xs,Ys,1,8,[Zs]) :-
	transpose(Xs,Xs1),	
	(depth(Xs,2) -> transpose(Xs1,Xs2) ; maplist(transpose, Xs1, Xs2)),
	transpose(Ys,Ys1),
	(depth(Ys,2) -> transpose(Ys1,Ys2) ; maplist(transpose, Ys1, Ys2)),
	mmmult(Xs2,Ys2,Zs).
temp_layer(Xs,Ys,1,9,[Zs]) :-
	(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	transpose(Xs1,Xs2),
	(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	transpose(Ys1,Ys2),
	mmmult(Xs2,Ys2,Zs).
temp_layer(Xs,Ys,1,10,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs,Ys,Zs).
temp_layer(Xs,Ys,1,11,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	transpose(Xs,Xs1),
	transpose(Ys,Ys1),
	(depth(Ys,2) -> transpose(Ys1,Ys2) ; maplist(transpose, Ys1, Ys2)),
	mmmult(Xs1,Ys2,Zs).
temp_layer(Xs,Ys,1,12,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	transpose(Xs,Xs1),
	(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs1,Ys1,Zs).
temp_layer(Xs,Ys,1,13,[Zs]) :-
	%(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	transpose(Xs,Xs1),
	(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	transpose(Ys1,Ys2),
	mmmult(Xs1,Ys2,Zs).
temp_layer(Xs,Ys,1,14,[Zs]) :-
	(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	transpose(Ys,Ys1),
	mmmult(Xs1,Ys1,Zs).
temp_layer(Xs,Ys,1,15,[Zs]) :-
	(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	transpose(Ys,Ys1),	
	(depth(Ys,2) -> transpose(Ys1,Ys2) ; maplist(transpose, Ys1, Ys2)),
	mmmult(Xs1,Ys2,Zs).
temp_layer(Xs,Ys,1,16,[Zs]) :-
	(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	%transpose(Xs,Xs1),
	(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	transpose(Ys1,Ys2),
	mmmult(Xs1,Ys2,Zs).
temp_layer(Xs,Ys,1,17,[Zs]) :-
	transpose(Xs,Xs1),	
	(depth(Xs,2) -> transpose(Xs1,Xs2) ; maplist(transpose, Xs1, Xs2)),
	%
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	transpose(Ys,Ys1),
	mmmult(Xs2,Ys1,Zs).
temp_layer(Xs,Ys,1,18,[Zs]) :-
	transpose(Xs,Xs1),	
	(depth(Xs,2) -> transpose(Xs1,Xs2) ; maplist(transpose, Xs1, Xs2)),
	(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs2,Ys1,Zs).
temp_layer(Xs,Ys,1,19,[Zs]) :-
	transpose(Xs,Xs1),	
	(depth(Xs,2) -> transpose(Xs1,Xs2) ; maplist(transpose, Xs1, Xs2)),
	(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	transpose(Ys1,Ys2),
	mmmult(Xs2,Ys2,Zs).
temp_layer(Xs,Ys,1,20,[Zs]) :-
	(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	transpose(Xs1,Xs2),
	%(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	transpose(Ys,Ys1),
	mmmult(Xs2,Ys1,Zs).
temp_layer(Xs,Ys,1,21,[Zs]) :-
	(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	transpose(Xs1,Xs2),
	(depth(Ys,2) -> transpose(Ys,Ys1) ; maplist(transpose, Ys, Ys1)),
	%transpose(Ys,Ys1),
	mmmult(Xs2,Ys1,Zs).
temp_layer(Xs,Ys,1,22,[Zs]) :-
	(depth(Xs,2) -> transpose(Xs,Xs1) ; maplist(transpose, Xs, Xs1)),
	transpose(Xs1,Xs2),
	transpose(Ys,Ys1),
	(depth(Ys,2) -> transpose(Ys1,Ys2) ; maplist(transpose, Ys1, Ys2)),
	mmmult(Xs2,Ys2,Zs).
*/




/*
temp_layer1([[[[4, 2], [4, 2]], [[4, 6], [9, 0]]]], [[[[9, 5], [4, 5]], [[7, 8], [9, 1]]]], true,false,true,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false, X).
keep(A,A).
temp_layer1(X,Y,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,Zs) :-
	(A = true; A = false),
	(B = true; B = false),
	(C = true; C = false),
	(D = true; D = false),
	(E = true; E = false),
	(F = true; F = false),
	(G = true; G = false),
	(H = true; H = false),
	(I = true; I = false),
	(J = true; J = false),
	(K = true; K = false),
	(L = true; L = false),
	(M = true; M = false),
	(N = true; N = false),
	(O = true; O = false),
	(P = true; P = false),
	(Q = true; Q = false),
	(R = true; R = false),
	(A -> transpose(X,X1);keep(X,X1)),
	(B -> map_transpose(X1,X2);keep(X1,X2)),
	(C -> map_map_transpose(X2,X3);keep(X2,X3)),
	%(D -> map_map_map_transpose(X3,X4);keep(X3,X4)),
	%(E -> map_map_map_map_transpose(X4,X5);keep(X4,X5)),
	
	%(M -> map_map_map_transpose(X5,X6);keep(X5,X6)),
	(N -> map_map_transpose(X3,X7);keep(X3,X7)),
	(O -> map_transpose(X7,X8);keep(X7,X8)),

	(F -> transpose(X8,X9);keep(X8,X9)),
	(G -> transpose(Y,Y1);keep(Y,Y1)),
	(H -> map_transpose(Y1,Y2);keep(Y1,Y2)),
	(I -> map_map_transpose(Y2,Y3);keep(Y2,Y3)),
%	(J -> map_map_map_transpose(Y3,Y4);keep(Y3,Y4)),
%	(K -> map_map_map_map_transpose(Y4,Y5);keep(Y4,Y5)),
%	
%	(P -> map_map_map_transpose(Y5,Y6);keep(Y5,Y6)),
	(Q -> map_map_transpose(Y3,Y7);keep(Y3,Y7)),
	(R -> map_transpose(Y7,Y8);keep(Y7,Y8)),
	
	(L -> transpose(Y8,Y9);keep(Y8,Y9)),
	mmmult(X9,Y9,Zs).
	%map_transpose([[[[64, 52], [32, 26]], [[52, 24], [26, 12]]], [[[99, 92], [54, 30]], [[97, 29], [24, 30]]]],X)
	%[[[[64, 52], [52, 24]], [[32, 26], [26, 12]]], [[[99, 92], [97, 29]], [[54, 30], [24, 30]]]]
*/

%temp_layer1([[[[4, 2], [4, 2]], [[4, 6], [9, 0]]]], [[[[9, 5], [4, 5]], [[7, 8], [9, 1]]]], A,B,C,D,E,F,G,H,I,J,K,L,M,N,O, [[[[64, 52], [52, 24]], [[32, 26], [26, 12]]], [[[99, 92], [97, 29]], [[54, 30], [24, 30]]]]).

/*
temp_layer1(X,Y,A,B,C,D,A1,B1,C1,D1,B2,C2,D2,Zs) :-
	(A = true; A = false),
	(B = true; B = false),
	(C = true; C = false),
	(D = true; D = false),
	%(E = true; E = false),
	(A1 = true; A1 = false),
	(B1 = true; B1 = false),
	(C1 = true; C1 = false),
	(D1 = true; D1 = false),
	%(E1 = true; E1 = false),
	%(A2 = true; A2 = false),
	(B2 = true; B2 = false),
	(C2 = true; C2 = false),
	(D2 = true; D2 = false),
	%(E2 = true; E2 = false),
	(depth(X,3) -> pack_list(X,X0);keep(X,X0)),
	(depth(Y,3) -> pack_list(Y,Y0);keep(Y,Y0)),
	
	(A -> transpose(X0,X1);keep(X0,X1)),
	(B -> map_transpose(X1,X2);keep(X1,X2)),
	(C -> map_map_transpose(X2,X3);keep(X2,X3)),
	(D -> map_transpose(X3,X4);keep(X3,X4)),
	%(E -> transpose(X4,X5);keep(X4,X5)),
	
	(A1 -> transpose(Y0,Y1);keep(Y0,Y1)),
	(B1 -> map_transpose(Y1,Y2);keep(Y1,Y2)),
	(C1 -> map_map_transpose(Y2,Y3);keep(Y2,Y3)),
	(D1 -> map_transpose(Y3,Y4);keep(Y3,Y4)),
	%(E1 -> transpose(Y4,Y5);keep(Y4,Y5)),
	
	mmmult(X4,Y4,Z1),
	%(A2 -> transpose(Z,Z1);keep(Z,Z1)),
	(B2 -> map_transpose(Z1,Z2);keep(Z1,Z2)),
	(C2 -> map_map_transpose(Z2,Z3);keep(Z2,Z3)),
	(D2 -> map_transpose(Z3,Zs);keep(Z3,Zs)).
	%(E2 -> transpose(Z4,Zs);keep(Z4,Zs)).

temp_layer2(X,Y,A,Zs) :-
	(A = true; A = false),
	(A -> (transpose(X,X1));(keep(X,X1))),
	mmmult(X1,Y,Zs).*/