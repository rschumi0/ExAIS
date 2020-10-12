
% tf.keras.layers.Concatenate( axis = -1, **kwargs)
% It takes as input a list of tensors, 
% all of the same shape except for the concatenation axis, 
% and returns a single tensor that is the concatenation of all inputs.

:- use_module(library(lists)).
:- [util].

% concatenate_lists_1D([1,2],[3,4],X).X = [1, 2, 3, 4].
% X = [1, 2, 3, 4].

% ?- concatenate_lists_2_3_D_axis1([1,2,3,4],[6,7,9,8],X).% there is no axis = 1 
% false.

concatenate_lists_1D_axis0([],[],[]).
concatenate_lists_1D_axis0(X,[],X).
concatenate_lists_1D_axis0([],Z,Z).
concatenate_lists_1D_axis0(X,Y,Z):-
 append(X,Y,Z).

% ?- concatenate_lists_1D_axis0([[1,2],[3,4]],[[6,7],[9,8]],X).
% X = [[1,2],[3,4],[6,7],[9,8]].

% ?- concatenate_lists_2_3_D_axis1([[1,2],[3,4]],[[6,7],[9,8]],X).
% X = [[1,2,6,7],[3,4,9,8]] 

%?- concatenate_lists_1D_axis0([[[0,1,2],[3,4,5]]],[[[0,1,2],[3,4,5]]],X).
% X = [[[0,1,2],[3,4,5]],[[0,1,2],[3,4,5]]].

% ?- concatenate_lists_2_3_D_axis1([[[0,1,2],[3,4,5]]],[[[0,1,2],[3,4,5]]],X).
% X = [[[0,1,2],[3,4,5],[0,1,2],[3,4,5]]];

concatenate_lists_2_3_D_axis1([], [], []).
concatenate_lists_2_3_D_axis1(X, [], X).
concatenate_lists_2_3_D_axis1([], Y, Y).
concatenate_lists_2_3_D_axis1([X|Xs], [Y|Ys], Z):-
 concatenate_lists_1D_axis0(X, Y, Zs),
 Z = [Zs|T],  
 concatenate_lists_2_3_D_axis1(Xs, Ys, T).

% concatenate_lists_3D([[[1,0],[2,0]],[[1,2],[2,3]]],[[[1,2],[3,4]],[[1,2],[3,4]]],[],X).
% X = [[[1, 0], [2, 0], [1, 2], [3, 4]], [[1, 2], [2, 3], [1, 2], [3, 4]]] ;

% concatenate_lists_3D([[[0,1,3],[5,6,3]],[[10,11,3],[15,16,3]]],[[[20,21,3],[25,26,3]],[[30,31,3],[35,36,3]]],[],X).
% X = [[[0, 1, 3], [5, 6, 3], [20, 21, 3], [25, 26, 3]], [[10, 11, 3], [15, 16, 3], [30, 31, 3], [35, 36, 3]]] ;

concatenate_lists_3D([], [], Z, Z).
concatenate_lists_3D(X,  [], _, X).
concatenate_lists_3D([], Y, _, Y).
concatenate_lists_3D([[X|X0s]|Xs],[[Y|Y0s]|Ys], Z0s, Zs):-
 concatenate_lists_1D_axis0([X|X0s],[Y|Y0s],Z),
 append(Z0s, [Z], Z1s),
 writeln(Z1s),
 concatenate_lists_3D(Xs, Ys, Z1s, Zs).



