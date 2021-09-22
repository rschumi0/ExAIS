:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-use_module(library(cplint_util)).
:-[util].
:-[helperlayer].



input_spec_layer(Is,Is).
input_spec_layer(Is,Shape,Is) :-
	check_shape(Is,Shape,false).
input_spec_layer(Is,Shape, 0, Is) :-
	check_shape(Is,Shape,false).	
input_spec_layer(Is,Shape, Ndin, Is) :-
	check_shape(Is,Shape,false),
	check_dimensions(Is,Ndin).
input_spec_layer(Is,Shape, Max_ndin, Min_ndin, Is) :-
	check_shape(Is,Shape,false),
	check_max_dimensions(Is,Max_ndin),
	check_min_dimensions(Is,Min_ndin).
input_spec_layer(Is,Dtype,Shape, Ndin, Max_ndin, Min_ndin, Allow_last_axis_squeeze, Is) :-
	Allow_last_axis_squeeze = false,
	check_type_precondition(Is,Dtype),
	check_shape(Is,Shape,false),
	check_dimensions(Is,Ndin),
	check_max_dimensions(Is,Max_ndin),
	check_min_dimensions(Is,Min_ndin).
input_spec_layer(Is,Dtype,Shape, Ndin, Max_ndin, Min_ndin, Allow_last_axis_squeeze, Is) :-
	Allow_last_axis_squeeze = true,
	check_type_precondition(Is,Dtype),
	check_shape(Is,Shape,false),
	shape(Is,S),
	last(S,Last),
	(Last = 1) -> (
		length(S,D),
		Diff is abs(Ndin - D),
		(Diff > 1 -> check_dimensions(Is,Ndin);true),
		Max_ndin1 is Max_ndin  + 1,
		check_max_dimensions(Is,Max_ndin1),
		Min_ndin1 is Min_ndin - 1,
		check_min_dimensions(Is,Min_ndin1));
		(check_dimensions(Is,Ndin),
		check_max_dimensions(Is,Max_ndin),
		check_min_dimensions(Is,Min_ndin)).

check_type(_,"").
check_type(Is,Dtype) :-
	sub_string(Dtype,0,5,_,"float"),
	first_atom(Is,I),
	float(I).
check_type(Is,Dtype) :-
	(sub_string(Dtype,0,3,_,"int");sub_string(Dtype,0,4,_,"uint")),
	first_atom(Is,I),
	integer(I).
check_type(Is,"bool") :-
	first_atom(Is,true).
check_type(Is,"bool") :-
	first_atom(Is,false).


check_shape(_,[], _).
check_shape(Is,Shape, false) :-
	not_empty(Shape),
	shape(Is,RealShape),
	check_same_shape_lists(Shape,RealShape).
check_shape(Is,Shape,true) :-
	not_empty(Shape),
	shape(Is,RealShape),
	set_zero_based_on_second_list(RealShape,Shape,RealShape1),
	check_same_shape_lists(Shape,RealShape1).

set_zero_based_on_second_list([],[],[]).	
set_zero_based_on_second_list([L|Ls],[R|Rs],[O|Os]) :-
	(R = 0 -> O is 0; O is L),
	 set_zero_based_on_second_list(Ls,Rs,Os).



input_layer(Is,Is).
input_layer(Is,Input_shape,Is):-
	unpack(Is,IsI),
	check_shape(IsI,Input_shape,false).
input_layer(Is,Input_shape,Batch_size,Is):-
	Batch_size = 0,
	unpack(Is,IsI),
	check_shape(IsI,Input_shape,false).
input_layer(Is,[],Batch_size,Is):-
	Batch_size \== 0,
	length(Is,Batch_size).
input_layer(Is,Input_shape,Batch_size,Is):-
	Batch_size \== 0,
	not_empty(Input_shape),
	check_shape(Is,[Batch_size|Input_shape],false).	
input_layer(Is,Input_shape,Batch_size,Dtype,Is):-
	input_layer(Is,Input_shape,Batch_size,Is),
	check_type_precondition(Is,Dtype).
input_layer(Is,Input_shape,Batch_size,Dtype,Ragged,Is):-
	not(Ragged),
	input_layer(Is,Input_shape,Batch_size,Is),
	check_type_precondition(Is,Dtype).	
input_layer(Is,[],Batch_size,Dtype,Ragged,Is):-
	Ragged,
	Batch_size \== 0,
	length(Is,Batch_size),
	check_type_precondition(Is,Dtype).
input_layer(Is,Input_shape,Batch_size,Dtype,Ragged,Is):-
	Ragged,
	not_empty(Input_shape),
	check_shape(Is,[Batch_size|Input_shape], true),
	check_type_precondition(Is,Dtype).
