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
	
add_layer(Is1,Is2,Os) :- add_lists(Is1,Is2,Os).
add_layer(Is,[Os]) :- tmpadd_lists(Is,[],Os).
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
	
multiply_layer(Is1,Is2,Os) :- multiply_lists(Is1,Is2,Os).
multiply_layer(Is,[Os]) :- tmpmultiply_lists(Is,[],Os).
tmpmultiply_lists([],Os,Os).
tmpmultiply_lists([I|Is],Os0,Os) :-
	multiply_lists(I,Os0,Os1),
	tmpmultiply_lists(Is,Os1,Os).
	
substract_lists(Xs,Ys,Zs) :- substract_lists(Xs,Ys,[],Zs).
substract_lists([],[],Zs,Zs).
substract_lists([X|Xs],[],Z0s,Zs) :-
	append(Z0s,[X],Z1s),
	substract_lists(Xs,[],Z1s,Zs).
substract_lists([],[Y|Ys],Z0s,Zs) :-
	append(Z0s,[Y],Z1s),
	substract_lists([],Ys,Z1s,Zs).
substract_lists([X|Xs],[Y|Ys],Z0s,Zs) :-
	atomic(X),
	atomic(Y),
	Z is X - Y,
	append(Z0s,[Z],Z1s),
	substract_lists(Xs,Ys,Z1s,Zs).
substract_lists([X|Xs],[Y|Ys],Z0s,Zs) :-
	is_list(X),
	is_list(Y),
	substract_lists(X,Y,Z),
	append(Z0s,[Z],Z1s),
	substract_lists(Xs,Ys,Z1s,Zs).	
	
substract_layer(Is1,Is2,Os) :- substract_lists(Is1,Is2,Os).
substract_lists([Is1,Is2],[Os]) :- substract_lists(Is1,Is2,Os).
	
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
	
minimum_layer(Is1,Is2,Os) :- minimum_list(Is1,Is2,Os).
minimum_layer(Is,[Os]) :- tmpminimum_layer(Is,[],Os).
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
	
maximum_layer(Is1,Is2,Os) :- maximum_list(Is1,Is2,Os).
maximum_layer(Is,[Os]) :- tmpmaximum_layer(Is,[],Os).
tmpmaximum_layer([],Os,Os).
tmpmaximum_layer([I|Is],Os0,Os) :-
	maximum_list(I,Os0,Os1),
	tmpmaximum_layer(Is,Os1,Os).
	
	
average_layer(Is1,Is2,[Os]):- average_list([Is1,Is2],Os).
average_layer(Is,[Os]) :- average_list(Is,Os).
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