
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
