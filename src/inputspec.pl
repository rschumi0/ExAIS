
% tf.keras.layers.InputSpec(
% dtype=None, shape=None, ndim=None, max_ndim=None, min_ndim=None, axes=None)

:- use_module(library(apply)).
:- use_module(library(clpb)).
:- use_module(library(lists)).

input_spec(List, Y):-
 find_ndim(List, DIM), % find dimensions of the input tensor
 find_shape(List, D, R, C). % find shape of the input tensor
 find_data_type(List, T), % find ndtype of the input tensor
 
% ?- find_ndim([1,2,3],C).
% C = 1.
% ?- find_ndim([[1,2,3],[4,5,6]],C).
% C = 2.
% ?- find_ndim([[[1,2],[3,4]],[[5,6],[2,3]],[[2,3]]],D).
% D = 3.
% ?- find_ndim([[[[1,2],[3,4]]],[[[5,6],[2,3]]],[[[2,3],[2,3]]]],Z).
% Z = 4.

find_ndim([], 0).
find_ndim(List, D):-
 nth0(0, List, X),
 (is_list(X) -> find_rows_coulmns(List, D); D is 1).

find_rows_coulmns([[I|Is]|Iss], D) :-
  nth0(0, [[I|Is]|Iss], X1),
  (is_list(X1) ->  nth0(0, X1, X2); D is 1),
  (is_list(X2) ->  nth0(0, X2, X3); D is 2) , 
  (is_list(X3) -> D is 4; (is_list(X2) -> D is 3; (is_list(X1) -> D is 2))).
  % length([[I|Is]|Iss], R),
  % maplist(length_of(C), [[I|Is]|Iss]),
  % (R > 0, C > 0 -> D is 2).
  
length_of(C, List) :-
 length(List, C).

find_shape(List, D, R, C):-
nth0(0, List, X),
 (is_list(X) -> find_shape_matrix_cube(List, D, R, C); find_shape_vector(List, D, R, C)).

% ?- find_shape_matrix([[1,2,3],[4,5,6],[7,8,9]], D,R,C).
% D = 2,
% R = C, C = 3.

% ?- find_shape_matrix([[1],[7],[6],[4],[4]],D,R,C).
% D = 2,
% R = 5,
% C = 1.

% ?- find_shape_matrix([[[1,2],[3,4]],[[5,6],[2,3]],[[2,3],[4,5]]],D,R,C).
% D = 3,
% R = C, C = 2.

find_shape_matrix_cube([[I|Is]|Iss], D, R, C) :-
  nth0(0, [[I|Is]|Iss], X1),
  (is_list(X1) ->  nth0(0, X1, X2)),
  (is_list(X2) -> (D is 3, length(X2, R)) ; (D is 2, length([[I|Is]|Iss], R))),
  find_shape_vector([I|Is], C).
  % maplist(length_of(C), [I|Is]).

% find_shape_vector([1,7,6,4,4],S).
% D = R = 1
% C = 5

find_shape_vector([H|T], C):-
  D is 1,
  R is 1,
  length([H|T], C).
  % number_string(C, Str),
  % string_concat('Shape (', Str, Str2),
  % string_concat(Str2, ', )', S).

find_data_type([], T).
find_data_type(List, T):-
  (is_integer(List, T) -> writeln('int32')),
  (is_float(List, T) -> writeln('float64')),
  (is_rational(List, T) -> writeln('rational')).

% ?- is_integer([1.0,2.0,7.0],Y).
% Y = 0.
% ?- is_integer([1,2,7],Y).
% Y = 1.

is_integer([], Y).
is_integer([I|Is], Y):-
  (integer(I) -> Y is 1; Y is 0),
   is_integer(Is, Y).

% ?- is_float([1,2,7],Y).
% Y = 0.
% ?- is_float([1.0,2.0,7.0],Y).
% Y = 1.

is_float([], Y).
is_float([I|Is], Y):-
  (float(I) -> Y is 1; Y is 0),
   is_float(Is, Y).

is_rational([], Y).
is_rational([I|Is], Y):-
  (rational(I) -> Y is 1; Y is 0),
   is_rational(Is, Y).