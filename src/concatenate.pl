:- use_module(library(lists)).
:- [util].

% ?- concatenate_layer([[1,2,9],[3,4,6]],0,X).
% X = [1,2,9,3,4,6].

% ?- concatenate_layer([[1,2,9],[3,4,6]],1,X).
% false, as there is no one dimension.

% ?- concatenate_layer([[[1,2,9],[2,0,9]],[[3,4,6],[3,7,6]]],0,X).
% X = [[1,2,9],[2,0,9],[3,4,6],[3,7,6]].

% ?- concatenate_layer([[[1,2,9],[2,0,9]],[[3,4,6],[3,7,6]]],1,X).
% X = [[1,2,9,3,4,6],[2,0,9,3,7,6]] ;

% ?- concatenate_layer([[[[1,2,9],[2,3,5],[2,3,4]],[[2,3],[4,6]],[[1,2,9],[2,3,5],[2,3,4]],[[2,3],[4,6]]],
	%                    [[[3,4,6],[2,4,6],[5,6,7]],[[3,5],[5,8]]]],0,X).

%   X = [[[1,2,9],[2,3,5],[2,3,4]],[[2,3],[4,6]],
%       [[1,2,9],[2,3,5],[2,3,4]],[[2,3],[4,6]],
%       [[3,4,6],[2,4,6],[5,6,7]],[[3,5],[5,8]]].

% ?- concatenate_layer([[[[1,2,9],[2,3,5],[2,3,4]],[[2,3],[4,6]],[[1,2,9],[2,3,5],[2,3,4]],[[2,3],[4,6]]],[[[3,4,6],[2,4,6],[5,6,7]],
	% [[3,5],[5,8]]]],1,X).

% X = [[[1,2,9],[2,3,5],[2,3,4],[3,4,6],[2,4,6],[5,6,7]],[[2,3],[4,6],[3,5],[5,8]],[[1,2,9],[2,3,5],[2,3,4]],[[2,3],[4,6]]] ;

% ?- concatenate_layer([[[[1,2,9],[2,3,5],[2,3,4]],[[2,3],[4,6]],[[1,2,9],[2,3,5],[2,3,4]],[[2,3],[4,6]]],[[[3,4,6],[2,4,6],
	% [5,6,7]],[[3,5],[5,8]]]],2,X).
% X = [[[1,2,9,3,4,6],[2,3,5,2,4,6],[2,3,4,5,6,7]],[[2,3,3,5],[4,6,5,8]],[[1,2,9],[2,3,5],[2,3,4]],[[2,3],[4,6]]]

% ?- concatenate_layer([[[[[1,2,9],[2,3,5],[2,3,4]]],[[[2,3]]]],[[[[3,4,6],[2,4,6],[5,6,7]]],[[[3,5],[5,8]]]]],0,X).
% X = [[[[1,2,9],[2,3,5],[2,3,4]]],[[[2,3]]],[[[3,4,6],[2,4,6],[5,6,7]]],[[[3,5],[5,8]]]].

% ?- concatenate_layer([[[[[1,2,9],[2,3,5],[2,3,4]]],[[[2,3]]]],[[[[3,4,6],[2,4,6],[5,6,7]]],[[[3,5],[5,8]]]]],1,X).
% X = [[[[1,2,9],[2,3,5],[2,3,4]],[[3,4,6],[2,4,6],[5,6,7]]],[[[2,3]],[[3,5],[5,8]]]]

% ?- concatenate_layer([[[[[1,2,9],[2,3,5],[2,3,4]]],[[[2,3]]]],[[[[3,4,6],[2,4,6],[5,6,7]]],[[[3,5],[5,8]]]]],2,X).
% X = [[[[1,2,9],[2,3,5],[2,3,4],[3,4,6],[2,4,6],[5,6,7]]],[[[2,3],[3,5],[5,8]]]]

% ?- concatenate_layer([[[[[1,2,9],[2,3,5],[2,3,4]]],[[[2,3]]]],[[[[3,4,6],[2,4,6],[5,6,7]]],[[[3,5],[5,8]]]]],3,X).
% X = [[[[1,2,9],[2,3,5],[2,3,4],[3,4,6],[2,4,6],[5,6,7]]],[[[2,3],[3,5],[5,8]]]]


% tf.keras.layers.Concatenate( axis = -1, **kwargs)
% It takes as input a list of tensors, 
% all of the same shape except for the concatenation axis, 
% and returns a single tensor that is the concatenation of all inputs.

concatenate_layer([X,Y,Z,S], Axis, O):-
  (Axis == 0 -> concatenate_lists_axis0([X,Y,Z,S],O); Axis == 1 -> concatenate_lists_axis1([X,Y,Z,S],O); Axis > 1 -> 
  	concatenate_lists_axis2_3([X,Y,Z,S],O); O is Axis).

concatenate_lists_axis0([[],[],[],[]],[]).
concatenate_lists_axis0([X,[],[],[]],X).
concatenate_lists_axis0([[],Z,[],[]],Z).
concatenate_lists_axis0([[],[],T,[]],T).
concatenate_lists_axis0([[],[],[],S],S).
concatenate_lists_axis0([X,Y,T,S],Z):-
 append(X,Y,Zs),
 append(Zs,T,Zss),
 append(Zss,S,Z).


concatenate_lists_axis1([[],[],[],[]], []).
concatenate_lists_axis1([X,[],[],[]], X).
concatenate_lists_axis1([[],Y,[],[]], Y).
concatenate_lists_axis1([[],[],T,[]], T).
concatenate_lists_axis1([[],[],[],S], S).
concatenate_lists_axis1([[X|Xs], [Y|Ys], [T1|T1s], [S0|S1]], Z):-
 concatenate_lists_axis0([X, Y, T1, S0], Zs),
 Z = [Zs|T],  
 concatenate_lists_axis1([Xs, Ys, T1s, S1], T).


concatenate_lists_axis2_3([[], [], [], []], []).
concatenate_lists_axis2_3([X, [], [], []], X).
concatenate_lists_axis2_3([[], Y, [], []], Y).
concatenate_lists_axis2_3([[], [], T, []], T).
concatenate_lists_axis2_3([[], [], [], S], S).
concatenate_lists_axis2_3([[[X0|X0s]|Xs],[[Y0|Y0s]|Ys],[[Z0|Z0s]|Zss], [[S0|Ss]|S1]], Z):-
  concatenate_lists_axis1([[X0|X0s], [Y0|Y0s], [Z0|Z0s],[S0|Ss]], Zs),
  Z = [Zs|T],
  concatenate_lists_axis2_3([Xs,Ys, Zss, S1], T).

