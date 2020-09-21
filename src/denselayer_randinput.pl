
%This is a dense layer that accepts random inputs

% ?- dense_layer_randIs(2,10,[[1,2],[3,4]],[2,4],X).
% X = [21, 32] 

% ?- dense_layer_randIs(3,10,[[1,2,3],[3,4,4],[4,6,7]],[2,4,6],X).
% X = [46, 68, 78] 

% ?- dense_layer_randIs(4,10,[[1,2,3,4],[3,4,4,4],[4,6,5,7],[1,2,3,4]],[2,5,4,6],X).
% X = [37, 61, 68, 87] 

% ?- dense_layer_randIs(4,10,[[1,2,3,4],[3,4,4,4],[4,6,5,7],[1,2,3,4]],[2,5,4,6],X).
% X = [62, 99, 105, 135] 

% ?- dense_layer_randIs(5,10,[[1,2,3,4,5],[3,4,4,4,5],[4,6,5,7,7],[1,2,3,4,7],[3,5,6,8,5]],[2,4,5,4,6],X).
% X = [71, 116, 130, 170, 163] 

% output = activation(dot(input, weight_data) + bias)
% bias value as 0

:- [util].
:- [denselayer].
:- use_module(library(random)).
:- use_module(library(clpfd)).

  dense_layer_randIs(K,N,IWs,OWs,Os) :-
       randseq(K,N,List), 
       transpose(IWs,IWs1), 
       copyList(List,Is),
       dense_layer(Is,IWs1,OWs,[],Os).
   

   % new denselayer specs added with all random inputs
   % k = number of input features
   % N = seed value for random number generation
   % U = no. of units on each layer
   % Y = output   
   % sample runs
   % ?- dense_layer_randIs(2,10,2,X).
   % X = [36, 87] .
   % ?- dense_layer_randIs(3,10,5,X).
   % X = [139, 61, 146, 116, 83] 
   % ?- dense_layer_randIs(4,10,6,X).
   % X = [69, 130, 160, 140, 129, 71] 
   
  dense_layer_randIs(K,N,U,Y):- % activation function needs to be added
       randseq(K,N,List), % generate random input features
       copyList(List,Is),
       generate_weights(K,N,U,Ws), % generate random input weights
       copyList(Ws,IWs),
       transpose(IWs,IWs1),
       generateRL(U, N, BW), % generate random biases
       copyList(BW,BWs),
       dense_layer_rand(Is,IWs1,BWs,[],Y).  

  dense_layer_rand(_,[],_,Os,Os).

  dense_layer_rand(Is,[IW|IWs],[BWs|BWs1],Os1,Y) :-
  weighted_sum(Is,IW,BWs,PY),
  append(Os1,[PY],Os2),
  %calc_relu(Os2),
  dense_layer_rand(Is,IWs,BWs1,Os2,Y).

 weighted_sum(Is,IWs,BWs,PY) :- 
   calc_output(Is,IWs,BWs,BWs,PY).
   calc_output([],[],_,PY,PY). 

   calc_output([I|Is],[IW|IWs],BWs,Res0,PY) :- 
   Res1 is Res0 + I * IW,
   calc_output(Is,IWs,BWs,Res1,PY).

 generate_weights(0, _, _, []).  
 % C = number of features, N range of ranom numbers, U = no. of units in a hidden layer, Y is output
 generate_weights(C, N, U, Y):- 
  C > 0,        
  C1 is C-1,    
  generateRL(U,N,L),
  Y = [L|T],    
  generate_weights(C1, N, U, T).

 generateRL(0, 10, []). 
 generateRL(U, N, Y):-
    U > 0,
  	U1 is U-1,
    random(1, N, R),
    Y = [R|T],
    % writeln(Y),
    generateRL(U1, N, T).
