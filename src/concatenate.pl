
% tf.keras.layers.Concatenate( axis = -1, **kwargs)
% It takes as input a list of tensors, 
% all of the same shape except for the concatenation axis, 
% and returns a single tensor that is the concatenation of all inputs.

:- use_module(library(lists)).
:- [util].

% concatenate_lists_1D([1,2],[3,4],X).X = [1, 2, 3, 4].
% X = [1, 2, 3, 4].

concatenate_lists_1D([],[],[]).
concatenate_lists_1D(X,[],X).
concatenate_lists_1D([],Z,Z).
concatenate_lists_1D(X,Y,Z):-
 append(X,Y,Z).

% ?- concatenate_lists_2D([[1,2],[3,4]],[[6,7],[9,8]],X).
% X = [[1, 2, 6, 7], [3, 4, 9, 8]] ;
% ?- concatenate_lists_2D([[1,2,4],[3,4,5]],[[6,7,6],[9,8,8]],X).
% X = [[1, 2, 4, 6, 7, 6], [3, 4, 5, 9, 8, 8]] ;

concatenate_lists_2D([],[],[]).
concatenate_lists_2D(X,[],X).
concatenate_lists_2D([],Y, Y).
concatenate_lists_2D([X|Xs],[Y|Ys],Z):-
 concatenate_lists_1D(X,Y,Zs),
 Z = [Zs|T],  
 concatenate_lists_2D(Xs, Ys, T).

% concatenate_lists_3D([[[1,0],[2,0]],[[1,2],[2,3]]],[[[1,2],[3,4]],[[1,2],[3,4]]],[],X).
% X = [[[1, 0], [2, 0], [1, 2], [3, 4]], [[1, 2], [2, 3], [1, 2], [3, 4]]] ;
% concatenate_lists_3D([[[0,1,3],[5,6,3]],[[10,11,3],[15,16,3]]],[[[20,21,3],[25,26,3]],[[30,31,3],[35,36,3]]],[],X).
% X = [[[0, 1, 3], [5, 6, 3], [20, 21, 3], [25, 26, 3]], [[10, 11, 3], [15, 16, 3], [30, 31, 3], [35, 36, 3]]] ;

concatenate_lists_3D([], [], Z, Z).
concatenate_lists_3D(X,  [], _, X).
concatenate_lists_3D([], Y, _, Y).
concatenate_lists_3D([[X|X0s]|Xs],[[Y|Y0s]|Ys], Z0s, Zs):-
 concatenate_lists_1D([X|X0s],[Y|Y0s],Z),
 append(Z0s, [Z], Z1s),
 writeln(Z1s),
 concatenate_lists_3D(Xs, Ys, Z1s, Zs).
