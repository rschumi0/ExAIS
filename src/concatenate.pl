
% tf.keras.layers.Concatenate( axis=-1, **kwargs)
% It takes as input a list of tensors, 
% all of the same shape except for the concatenation axis, 
% and returns a single tensor that is the concatenation of all inputs.

:- use_module(library(lists)).
:- [util].


concatenate_lists_1D([],[],[]).
concatenate_lists_1D(X,[],X).
concatenate_lists_1D([],Z,Z).
concatenate_lists_1D(X,Y,Z):-
 append(X,Y,Z).

concatenate_lists_2D([],[],[]).
concatenate_lists_2D(X,[],X).
concatenate_lists_2D([],Y, Y).
concatenate_lists_2D([X|Xs],[Y|Ys],Z):-
 concatenate_lists_1D(X,Y,Zs),
 Z = [Zs|T],  
 concatenate_lists_2D(Xs, Ys, T).

concatenate_lists_3D([], [], Z, Z).
concatenate_lists_3D(X,  [], _, X).
concatenate_lists_3D([], Y, _, Y).
concatenate_lists_3D([[X|X0s]|Xs],[[Y|Y0s]|Ys], Z0s, Zs):-
 concatenate_lists_1D([X|X0s],[Y|Y0s],Z),
 append(Z0s, [Z], Z1s),
 writeln(Z1s),
 concatenate_lists_3D(Xs, Ys, Z1s, Zs).
