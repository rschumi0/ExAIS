
% This file contains specs for dense layer with random inputs

% tf.keras.layers.Dense(
%   units,
%    activation=None,
%    use_bias=True,
%    kernel_initializer="glorot_uniform",
%    bias_initializer="zeros",
%    kernel_regularizer=None,
%    bias_regularizer=None,
%    activity_regularizer=None,
%    kernel_constraint=None,
%    bias_constraint=None,
%    **kwargs
%)

:- [util].
:- [denselayer].
:- [activation].

:- use_module(library(random)).
:- use_module(library(clpfd)).

% A denselayer specs with input features as random numbers
% ?- dense_layer_randIs(2, 10, [[1,2],[3,4]],[2,4],X).
% X = [21, 32] 
% ?- dense_layer_randIs(4,10,[[1,2,3,4],[3,4,4,4],[4,6,5,7],[1,2,3,4]],[2,5,4,6],X).
% X = [37, 61, 68, 87] 
% ?- dense_layer_randIs(5,10,[[1,2,3,4,5],[3,4,4,4,5],[4,6,5,7,7],[1,2,3,4,7],[3,5,6,8,5]],[2,4,5,4,6],X).
% X = [71, 116, 130, 170, 163] 

% output = activation(dot(input, weight_data) + bias)
% K is number of input features and N represents the seed value for random number generation

dense_layer_randIs(K, N, IWs, OWs, Os) :- 
 randseq(K, N, List), 
 transpose(IWs, IWs1), 
 copyList(List, Is),
 dense_layer(Is, IWs1, OWs, [], Os).

% new denselayer specs added with all inputs as random numbers and with activation function as None
% sample runs
% ?- dense_layer_randIs(2,1,10,2,X).
% X = [36, 87]
% ?- dense_layer_randIs(4,1,10,6,X).
% X = [69, 130, 160, 140, 129, 71] 
% ?- dense_layer_randIs_range(2,1,10,3,'softmx',Y).
% Y = [0.4999999999999988, 2.3294430725516933e-15, 0.4999999999999988] .

% K = number of input features
% Max = seed value for random number generation
% U = no. of units on each hidden layer
% Y = output   

 dense_layer_randIs_range(K, Min, Max, U, Act, Y):- 
   randseq(K, Max, List), % generate random input features between 1 - Max
   copyList(List, Is),
   generate_weights(K, Min, Max, U, Ws), % generate random input weights between Min - Max
   copyList(Ws, IWs),
   transpose(IWs, IWs1),
   generateRL(U, Min, Max, BW), % generate random biases between Min - Max
   copyList(BW, BWs),
   dense_layer_rand(Is, IWs1, BWs, [], Y0),  
   (Act == 'sig' -> sigmoid_layer(Y0, [], Y); Act == 'softmx' -> softmax_layer_SL(Y0, [], Y); copyList(Y0, Y)).

  dense_layer_rand(_, [], _, Os, Os).

  dense_layer_rand(Is, [IW|IWs], [BWs|BWs1], Os1, Y) :-
  weighted_sum(Is, IW, BWs, PY),
  append(Os1, [PY], Os2),
  dense_layer_rand(Is, IWs, BWs1, Os2, Y).

  weighted_sum(Is, IWs, BWs, PY) :- 
   calc_output(Is, IWs, BWs, BWs, PY).
   calc_output([], [], _, PY, PY). 

   calc_output([I|Is], [IW|IWs], BWs, Res0, PY) :- 
   Res1 is Res0 + I * IW,
   calc_output(Is, IWs, BWs, Res1, PY).
 
% dense layer specs with kernel_initializer="zeros|ones" and bias_initializer="ones|zeros")
% ?- dense_layer_randIs_Init_zeros_ones(2,1,5,3,'sig',Y).
% Y = [0.9975273768433653, 0.9975273768433653, 0.9975273768433653] .
% ?- dense_layer_randIs_Init_zeros_ones(2,0,5,3,'sig',Y).
% Y = [0.5, 0.5, 0.5] .

  dense_layer_randIs_Init_zeros_ones(K, Init, N, U, Act, Y):- 
    randseq(K, N, List),
    copyList(List, Is),
    generate_weights(K, Init, U, Ws), 
    copyList(Ws, IWs),
    transpose(IWs, IWs1),
    generateRL(U, Init, BW),
    copyList(BW, BWs),
    dense_layer_rand(Is, IWs1, BWs, [], Y0),  
    (Act == 'sig' -> sigmoid_layer(Y0, [], Y); Act == 'softmx' -> softmax_layer_SL(Y0, [], Y); copyList(Y0, Y)).

 % generate random weights in a range Min-Max
 % C = number of features, 
 % Min - Max defines range of random numbers, 
 % U = no. of units in each hidden layer, 
 % Y is output

 % sample runs
 % ?- generate_weights(2, 1, 10, 2, X).
 % X = [[8, 8], [3, 8]] .
 % ?- generate_weights(2,1,10,3,X).
 % X = [[4, 1, 8], [7, 5, 3]] .
 
 generate_weights(0, _, _, _,[]).  
 generate_weights(K, Min, Max, U, Y):- 
  K > 0,        
  K1 is K-1,    
  generateRL(U, Min, Max, L),
  Y = [L|T],    
  generate_weights(K1, Min, Max, U, T).

% generate a list of random numbers (for biases or weights in a range)
% Sample runs
% ?- generateRL(4, 1, 10,X).
% X = [5, 3, 3, 2] ;
 generateRL(0, _, _, []). 
 generateRL(U, Min, Max, Y):-
  U > 0,
  U1 is U-1,
  random(Min, Max, R),
  Y = [R|T],
  generateRL(U1, Min, Max, T).

% generate weights (for kernel_initializer="zeros" and kernel_initializer="ones")
% sample 
% generate_weights(4,1,3,X).
% X = [[1, 1, 1], [1, 1, 1], [1, 1, 1], [1, 1, 1]] .
% ?- generate_weights(4,0,3,X).
% X = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]] 

 generate_weights(0, _, _,[]).  
 generate_weights(K, Init, U, Y):- 
  K > 0,        
  K1 is K-1,    
  generateRL(U, Init, L),
  Y = [L|T],    
  generate_weights(K1, Init, U, T).

 % generate a list of random numbers for 
 % bias_initializer="zeros" and kernel_initializer="zeros" 
 % and bias_initializer="ones"and kernel_initializer="ones"
 % sample runs
 % ?- generateRL(4,0,X).
 % X = [0, 0, 0, 0].
 % generateRL(4,1,X).
 % X = [1, 1, 1, 1] ;

 generateRL(0, _, []). 
 generateRL(U, Init, Y):-
  U > 0,
  U1 is U-1,
  R is Init,
  Y = [R|T],
  generateRL(U1, Init, T).

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
softmax_layer_SL([],Y,Y).
softmax_layer_SL([I|Is], Y0, R2):-
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