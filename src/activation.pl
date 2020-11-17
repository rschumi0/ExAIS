%:- module(activation,[]).


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

% Sample data run
% ?- sigmoid_layer([8,5,0],[],Y).
% Y = [0.9996646498695336, 0.9933071490757153, 0.5].
% ?- sigmoid_layer([-8,-5,0],[],Y).
% Y = [0.0003353501304664781, 0.0066928509242848554, 0.5].
% Sigmoid activation function, sigmoid(x) = 1 / (1 + exp(-x)).

sigmoid_layer([],Y,Y).
sigmoid_layer([I|Is],Y0,Y):-
   E is 1 + exp(-I), % calculate denominator term for sigmoid the formula
   O is rdiv(1, rational(E)), % calculate whole value for the sigmoid function
   % format('~5e~n', O),
   S is float(O), % format output as a floating point number
   append(Y0,[S],Ys),
   sigmoid_layer(Is,Ys,Y).

% Sample data run for the softmax layer
% ?- softmax_layer_SL([8,5,0], [], Y).
% Y = [0.9522698261237778, 0.04741072293787844, 0.0003194509383437505].
% Softmax activation function = exp(x) / tf.reduce_sum(exp(x)).

% softmax layer for one-dimensional input tensor
softmax_layer([],Y,Y).
softmax_layer([I|Is], _, R2):-
 calc_exp_SL([I|Is], [], Y), % calc exponential for a single list
 calc_sum_SL([I|Is], 0, Sum),   %  calc sum of exponential values for all the list elements
 reduce_sum_SL(Y, Sum, [], R2). % dividing by the normalization to get the valid probabilities.

% calculate exponential of a one-dimension list
% ?- calc_exp_SL([5,0],[],Y).
% Y = [148.4131591025766, 1].
% calculate exponent of elements in a one-dimensional input tensor
calc_exp_SL([],Y,Y).
calc_exp_SL([I|Is], Y0, L):-
 (I > 0 -> O is exp(I); I =:= 0 -> O is 1 ; O is I),
 append(Y0, [O], Ys),
 calc_exp_SL(Is, Ys, L).

 % calculate exponential sum of a one-dimension list
calc_sum_SL([], Sum1, Sum1).
calc_sum_SL([I|Is], Sum0, Sum):-
 (I > 0 -> O is exp(I); I =:= 0 -> O is 1 ; O is I),
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
	
prelu_layer([],_,[]).
prelu_layer([I|Is],[A|Alphas],[O|Os]) :-
	atomic(I),
	length([A|Alphas],LA),
	length([I|Is],LI),
	LA = LI,
	(I < 0 -> O is A * I;O is I),
	prelu_layer(Is,Alphas,Os).
prelu_layer([I|Is],[A|Alphas],[O|Os]) :-
	atomic(I),
	length([A|Alphas],LA),
	length([I|Is],LI),
	LA \= LI,
	(I < 0 -> O is A * I;O is I),
	prelu_layer(Is,[A|Alphas],Os).
prelu_layer([I|Is],[A|Alphas],[O|Os]) :-
	%depth(Alphas,DA),
	%depth([I|Is],DI),
	%DI \= DA,
	(atomic(A);(
	depth([A|Alphas],DA),
	depth([I|Is],DI),
	DA \= DI)),
	is_list(I),
	prelu_layer(I,[A|Alphas],O),
	prelu_layer(Is,[A|Alphas],Os).
prelu_layer([I|Is],[A|Alphas],[O|Os]):-
	%depth([A|Alphas],DA),
	%depth([I|Is],DI),
	%DI = DA,
	is_list(A),
	is_list(I),
	prelu_layer(I,A,O),
	prelu_layer(Is,Alphas,Os).

	
