:-[util].


%relu_layer([3,2,1,-2,-0.1],2,1,0.5,O).
relu_layer([],_,_,_,[]).
relu_layer([I|Is],Max_Value,Negative_Slope,Threshold,[O|Os]) :-
	atomic(I),
	(I < Threshold -> I1 is I * Negative_Slope + (-Threshold *Negative_Slope);I1 is I),
	(number(Max_Value) -> O is min(I1,Max_Value); O is I1),
	relu_layer(Is,Max_Value,Negative_Slope,Threshold,Os).

relu_layer([I|Is],Max_Value,Negative_Slope,Threshold,[O|Os]) :-
	is_list(I),
	relu_layer(I,Max_Value,Negative_Slope,Threshold,O),
	relu_layer(Is,Max_Value,Negative_Slope,Threshold,Os).



%thresholded_relu_layer([0.138821,0.30971956,0.23123252,0.26585793,0.65178293,0.54254425,0.8526051,0.1260066,0.4059227],0.26,X).
thresholded_relu_layer([],_,[]).
thresholded_relu_layer([I|Is],Theta,[O|Os]) :-
	atomic(I),
	(I > Theta -> O is I;O is 0),
	thresholded_relu_layer(Is,Theta,Os).
thresholded_relu_layer([I|Is],Theta,[O|Os]) :-
	is_list(I),
	thresholded_relu_layer(I,Theta,O),
	thresholded_relu_layer(Is,Theta,Os).



%leaky_relu_layer([-0.138821,-0.30971956,0.23123252,0.26585793,0.65178293,0.54254425,0.8526051,0.1260066,0.4059227],0.26,X).
leaky_relu_layer([],_,[]).
leaky_relu_layer([I|Is],Alpha,[O|Os]) :-
	atomic(I),
	(I < 0 -> O is Alpha * I ; O is I),
	leaky_relu_layer(Is,Alpha,Os).
leaky_relu_layer([I|Is],Alpha,[O|Os]) :-
	is_list(I),
	leaky_relu_layer(I,Alpha,O),
	leaky_relu_layer(Is,Alpha,Os).






sigmoid_layer(X,Y) :- sigmoid_func(X,Y).
sigmoid_func([],[]).
sigmoid_func(X,Y) :-
	atomic(X),
	sigmoid_comp([X],[],[Y]).
sigmoid_func([X|Xs],Y) :-
	atomic(X),
	sigmoid_comp([X|Xs],[],Y).
sigmoid_func([X|Xs],[Y|Ys]) :-
	is_list(X),
	sigmoid_func(X,Y),
	sigmoid_func(Xs,Ys).
	

sigmoid_comp([],Y,Y).
sigmoid_comp([I|Is],Y0,Y):-
	I < -709,
	append(Y0,[0.0],Ys),
	sigmoid_comp(Is,Ys,Y).
sigmoid_comp([I|Is],Y0,Y):-
	I > -710,
	I1 is I * -1,
	E is 1 + exp(I1), 
	O is rdiv(1, rational(E)),
	S is float(O), 
	append(Y0,[S],Ys),
	sigmoid_comp(Is,Ys,Y).





softmax_layer([],_,[]).
softmax_layer(Is,-1,Os) :-
	softmax_layer(Is,Os).
softmax_layer(Is,0,Os) :-
	depth(Is,2),
	replace_all(Is, 1,Os).
softmax_layer(Is,1,Os) :-
	depth(Is,2),
	softmax_layer(Is,Os).
softmax_layer(Is,1,Os) :-
	depth(Is,3),
	maplist(transpose,Is,Is1),
	softmax_layer(Is1,Os1),
	maplist(transpose,Os1,Os).
softmax_layer(Is,1,Os) :-
	depth(Is,4),
	%writeln("case test"),
	maplist(transpose,Is,IsT),
	map_map_transpose(IsT,Is1),
	softmax_layer(Is1,Os1),
	map_map_transpose(Os1,OsT),
	%softmax_layer(IsT,OsT),
	maplist(transpose,OsT,Os).
softmax_layer(Is,1,Os) :-
	depth(Is,5),
	%writeln("case test"),
	maplist(transpose,Is,IsT),
	map_map_transpose(IsT,Is1),
	map_map_map_transpose(Is1,Is2),
	softmax_layer(Is2,Os1),
	map_map_map_transpose(Os1,Os2),
	map_map_transpose(Os2,OsT),
	%softmax_layer(IsT,OsT),
	maplist(transpose,OsT,Os).
softmax_layer(Is,1,Os) :-
	depth(Is,6),
	%writeln("case test"),
	maplist(transpose,Is,IsT),
	map_map_transpose(IsT,Is1),
	map_map_map_transpose(Is1,Is2),
	map_map_map_map_transpose(Is2,Is3),
	softmax_layer(Is3,Os1),
	map_map_map_map_transpose(Os1,Os2),
	map_map_map_transpose(Os2,Os3),
	map_map_transpose(Os3,OsT),
	%softmax_layer(IsT,OsT),
	maplist(transpose,OsT,Os).
softmax_layer([I|Is],Axis,[O|Os]) :-
	Axis1 is Axis -1,
	softmax_layer(I,Axis1,O),
	softmax_layer(Is,Axis,Os).
softmax_layer([],[]).
softmax_layer([I|Is],[O|Os]) :-
	atomic(I),
	softmax([I|Is],[O|Os]).
softmax_layer([I|Is],[O|Os]) :-
	is_list(I),
	softmax_layer(I,O),
	softmax_layer(Is,Os).
softmax([],_).
softmax(Is, Os):-
	exp_list(Is, Y), 
	sum_list(Y,Sum), %calc_sum_SL([I|Is], 0, Sum),	%  calc sum of exponential values for all the list elements
	divide_each_list_element_by(Y,Sum,Os).%reduce_sum_SL(Y, Sum, [], R2). % dividing by the normalization to get the valid probabilities.

/*
 % calculate exponential sum of a one-dimension list
calc_sum_SL([], Sum1, Sum1).
calc_sum_SL([I|Is], Sum0, Sum):-
 %((I > 0 -> O is exp(I)); (I =:= 0 -> O is 1 ; O is I)),
(I =:= 0 -> O is 1 ; O is exp(I)),
 S is float(O),
 Sum1 is Sum0 + S,
 calc_sum_SL(Is, Sum1, Sum).

% calculate reduce sum for a one-dimension list
reduce_sum_SL([],_,Y,Y).
reduce_sum_SL([Y|Ys], Sum1, R1, R2):-
  O is rdiv(rational(Y), rational(Sum1)),
  % format('~5e~n', O),
	S is float(O),
	append(R1, [S], Z),
	reduce_sum_SL(Ys, Sum1, Z, R2).

% softmax layer for multi-dimensional input tensor
% ?- softmax_layer_LL([[0,1,0],[0,1,0]],[],Y).
% Y = [[0.21194155761708547, 0.5761168847658291, 0.21194155761708547], [0.21194155761708547, 0.5761168847658291, 0.21194155761708547]].
*/

/*
softmax_layer_LL([],Y,Y).
softmax_layer_LL([[I|Is]|Xs], Y0, Y):-
 softmax_layer([I|Is], Y0, Y1),
 Y = [Y1|T],
 softmax_layer_LL(Xs,[],T).

% calculate exponential sum of multi-dimension list
  calc_sum_LL([], Y, Y).
  calc_sum_LL([[I|Is]|Xs], Y0, Y):-
	calc_sum([I|Is], 0, Sum),
	append(Y0, [Sum], Ys),
	calc_sum_LL(Xs, Ys, Y).

% calculate exponent of elements in a multi-dimensional input tensor
% ?- calc_exp_LL([[8,0],[5,0]],[],Y).
% Y = [[2980.9579870417283, 1], [148.4131591025766, 1]].

calc_exp_LL([], Y, Y).
calc_exp_LL([[I|Is]|Xs], Y0, Y):-
 calc_exp_SL([I|Is], Y0, L),
 Y = [L|T],
 calc_exp_LL(Xs, [], T).
*/




% elu_layer([3,2,1,-2,-0.1],2,1,0.5,O).
elu_layer([],_,[]).
elu_layer([I|Is],Alpha,[O|Os]) :-
	atomic(I),
	(I < 0 -> O is Alpha * ((e ^ I) - 1);O is I),
	elu_layer(Is,Alpha,Os).
elu_layer([I|Is],Alpha,[O|Os]) :-
	is_list(I),
	elu_layer(I,Alpha,O),
	elu_layer(Is,Alpha,Os).



prelu_layer([I|Is],Alphas,Os) :-
	check_same_shape_arg_different_input([I|Is],I,Alphas),
	prelu([I|Is],Alphas,Os).
prelu([],_,[]).
prelu([I|Is],[A|Alphas],[O|Os]) :-
	atomic(I),
	length([A|Alphas],LA),
	length([I|Is],LI),
	LA = LI,
	(I < 0 -> O is A * I;O is I),
	prelu(Is,Alphas,Os).
prelu([I|Is],[A|Alphas],[O|Os]) :-
	atomic(I),
	length([A|Alphas],LA),
	length([I|Is],LI),
	LA \= LI,
	(I < 0 -> O is A * I;O is I),
	prelu(Is,[A|Alphas],Os).
prelu([I|Is],[A|Alphas],[O|Os]) :-
	(atomic(A);(
	depth([A|Alphas],DA),
	depth([I|Is],DI),
	DA \= DI)),
	is_list(I),
	prelu(I,[A|Alphas],O),
	prelu(Is,[A|Alphas],Os).
prelu([I|Is],[A|Alphas],[O|Os]):-
	is_list(A),
	is_list(I),
	prelu(I,A,O),
	prelu(Is,Alphas,Os).



