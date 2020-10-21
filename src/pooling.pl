:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-[util].

%Padding is true for 'same', Strides is PoolSize per default
/*
max_pool1D_layer(Is,PoolSize,Os):- max_pool1D_layer(Is,PoolSize,PoolSize,false,[],Os).
max_pool1D_layer(Is,PoolSize,Strides,Padding,Os):- max_pool1D_layer(Is,PoolSize,Strides,Padding,[],Os).
max_pool1D_layer([],_,_,_,Os,Os).
max_pool1D_layer([[I|Is0]|Is],PoolSize,Strides,Padding,Os0,Os) :-
	is_list(I),
	max_pool1D_layer([I|Is0],PoolSize,Strides,Padding,O),
	append(Os0,[O],Os1),
	max_pool1D_layer(Is,PoolSize,Strides,Padding,Os1,Os).
max_pool1D_layer([[I|Is0]|Is],PoolSize,Strides,Padding,Os0,Os) :-
	atomic(I),
	del_first_items([[I|Is0]|Is],F,R),
	get_max_pools(F,PoolSize,Strides,Padding,O),
	transpose([O],T),
	concatinate_sub_lists(Os0,T,Os1),
	max_pool1D_layer(R,PoolSize,Strides,Padding,Os1,Os).
	
get_max_pools(Is,PoolSize,Strides,Padding,Os) :-get_max_pools(Is,PoolSize,Strides,Padding,[],Os).
get_max_pools([],_,_,_,Os,Os).
get_max_pools(Is,PoolSize,_,Padding,Os,Os) :-
	not(Padding),
	length(Is,N), N < PoolSize.
get_max_pools(Is,PoolSize,Strides,Padding,Os0,Os) :-
	Padding,
	length(Is,N), N < PoolSize,
	max_list(Is,M),
	append(Os0,[M],Os1),
	split_at(Strides,Is,_,R),
	get_max_pools(R,PoolSize,Strides,Padding,Os1,Os).
get_max_pools(Is,PoolSize,Strides,Padding,Os0,Os) :-
	length(Is,N), N >= PoolSize,
	split_at(PoolSize,Is,L,_),
	max_list(L,M),
	append(Os0,[M],Os1),
	split_at(Strides,Is,_,R),
	get_max_pools(R,PoolSize,Strides,Padding,Os1,Os).
*/
	
%([[[[4,3,3],[3,4,3],[1,9,3],[1,9,11]],[[8,2,8],[3,4,9],[3,4,3],[3,4,3]]]],2,3,2,3,false,X).
/*
max_pool2D_layer(Is,PoolSizeD1,PoolSizeD2,Os):- max_pool2D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD1,PoolSizeD2,false,Os).
max_pool2D_layer(Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os):- max_pool2D_layer(Is,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,[],Os).
max_pool2D_layer([],_,_,_,_,_,_,_,_,Os,Os).
max_pool2D_layer([[[I|Is0]|Is1]|Is],0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os0,Os) :-
	is_list(I),
	max_pool2D_layer([[I|Is0]|Is1],PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,O),
	append(Os0,[O],Os1),
	max_pool2D_layer(Is,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os1,Os).
max_pool2D_layer([[[I|Is0]|Is1]|Is],X,Y,Z,_,_,_,_,_,Os,Os) :-
	atomic(I),
	%Padding,
	(length([[[I|Is0]|Is1]|Is],LX), 
	X >= LX; 
	length([[I|Is0]|Is1],LY), 
	Y >= LY;
	length([I|Is0],LZ), 
	Z >= LZ).
max_pool2D_layer([[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os0,Os) :-
	atomic(I),
	not(Padding),
	length([[[I|Is0]|Is1]|Is],LX), 
	length([[I|Is0]|Is1],LY), 
	%length([I|Is0],LZ), 
	%X+PoolSizeD1 =< LX,Y+PoolSizeD2 =< LY,
	get_pool_max([[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,O),
	insert_pool_field(Os0,O,X,Y,Z,StridesD1,StridesD2,Os1),
	(X+StridesD1+PoolSizeD1 =< LX -> X1 is X + StridesD1,Y1 is Y, Z1 is Z; (Y+StridesD2+PoolSizeD2 =< LY -> X1 is 0,Y1 is Y+StridesD2, Z1 is Z; X1 is 0, Y1 is 0, Z1 is Z + 1)),
	max_pool2D_layer([[[I|Is0]|Is1]|Is],X1,Y1,Z1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os1,Os).
max_pool2D_layer([[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os0,Os) :-
	atomic(I),
	Padding,
	length([[[I|Is0]|Is1]|Is],LX), 
	length([[I|Is0]|Is1],LY), 
	%X+PoolSizeD1 > LX,Y+PoolSizeD2 > LY,
	get_pool_max([[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,O),
	insert_pool_field(Os0,O,X,Y,Z,StridesD1,StridesD2,Os1),
	(X < LX-1 -> X1 is X + StridesD1,Y1 is Y, Z1 is Z; (Y < LY-1 -> X1 is 0,Y1 is Y+StridesD2, Z1 is Z; X1 is 0, Y1 is 0, Z1 is Z + 1)),
	max_pool2D_layer([[[I|Is0]|Is1]|Is],X1,Y1,Z1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os1,Os).
	
get_pool_max(Is,X,Y,Z,PoolSizeD1,PoolSizeD2,O) :- nth0_3Dtemp(X,Y,Z,Is,O1), get_pool_max(Is,X,Y,Z,X,Y,PoolSizeD1,PoolSizeD2, O1,O).
get_pool_max([[[I|Is0]|Is1]|Is],_,_,_,X1,Y1,_,_, O,O) :-
	length([[[I|Is0]|Is1]|Is],LX), 
	X1 >= LX;
	length([[I|Is0]|Is1],LY), 
	Y1 >= LY.
get_pool_max(_, X,Y,_,X1,Y1,PoolSizeD1,PoolSizeD2, O,O) :-
	X1 >= X + PoolSizeD1;Y1 >= Y + PoolSizeD2.
get_pool_max(Is,X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,O1,O) :-
	length(Is,LX),
	nth0_3Dtemp(X1,Y1,Z,Is,O2),
	(O2 < O1 -> O3 is O1; O3 is O2),
	((X1 < X+PoolSizeD1-1, X1< LX-1) -> X2 is X1 + 1,Y2 is Y1;X2 is X,Y2 is Y1+1),
	get_pool_max(Is, X,Y,Z,X2,Y2,PoolSizeD1,PoolSizeD2, O3,O).
*/	
	

	
insert_pool_field(Is,I,X,Y,Z,StridesD1,StridesD2,Os) :- Is = [], insert_pool_field([[[]]],I,X,Y,Z,StridesD1,StridesD2,Os).
insert_pool_field(Is,I,X,Y,Z,StridesD1,StridesD2,Os) :-
	X1 is X / StridesD1,
	Y1 is Y / StridesD2,
	Z1 is Z,
	fill_field_up_to_index_and_add(Is,I,X1,Y1,Z1,Os).

replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

insert_pool_field4D(Is,I,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os) :- Is = [], insert_pool_field4D([[[[]]]],I,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os).
insert_pool_field4D(Is,I,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os) :-
	W1 is W / StridesD1,
	X1 is X / StridesD2,
	Y1 is Y / StridesD3,
	Z1 is Z,
	fill_field_up_to_index_and_add4D(Is,I,W1,X1,Y1,Z1,Os).
fill_field_up_to_index_and_add4D(Is,I,W,X,Y,Z,Os) :- fill_field_up_to_index_and_add4D(Is,I,W,X,Y,Z,Is,Os).
fill_field_up_to_index_and_add4D([],_,_,_,_,_,Os,Os).
fill_field_up_to_index_and_add4D(Is,I,W,X,Y,Z,Os0,Os) :-
	length(Os0,L),
	W >= L,
	append(Os0,[[[[]]]],Os1),
	fill_field_up_to_index_and_add4D(Is,I,W,X,Y,Z,Os1,Os).
fill_field_up_to_index_and_add4D(_,I,W,X,Y,Z,Os0,Os) :-
	length(Os0,L),
	W < L,
	nth0(W,Os0,Os1),
	fill_field_up_to_index_and_add(Os1,I,X,Y,Z,Os2),
	replace(Os0,W,Os2,Os3),
	fill_field_up_to_index_and_add4D([],I,W,X,Y,Z,Os3,Os).

fill_field_up_to_index_and_add(Is,I,X,Y,Z,Os) :- fill_field_up_to_index_and_add(Is,I,X,Y,Z,Is,Os). 
fill_field_up_to_index_and_add([],_,_,_,_,Os,Os).
fill_field_up_to_index_and_add(Is,I,X,Y,Z,Os0,Os) :-
	length(Os0,L),
	X >= L,
	append(Os0,[[]],Os1),
	fill_field_up_to_index_and_add(Is,I,X,Y,Z,Os1,Os).
fill_field_up_to_index_and_add(Is,I,X,Y,Z,Os0,Os) :-
	nth0(X,Os0,Os1),
	length(Os1,L),
	Y >= L,
	append(Os1,[[]],Os2),
	replace(Os0,X,Os2,Os3),
	fill_field_up_to_index_and_add(Is,I,X,Y,Z,Os3,Os).
fill_field_up_to_index_and_add(Is,I,X,Y,Z,Os0,Os) :-
	nth0(X,Os0,Os1),
	nth0(Y,Os1,Os2),
	length(Os2,L),
	Z > L,
	append(Os2,[0],Os3),
	replace(Os1,Y,Os3,OsX),
	replace(Os0,X,OsX,OsN),
	fill_field_up_to_index_and_add(Is,I,X,Y,Z,OsN,Os).
fill_field_up_to_index_and_add(_,I,X,Y,Z,Os0,Os) :-
	nth0(X,Os0,Os1),
	nth0(Y,Os1,Os2),
	length(Os2,L),
	Z = L,
	append(Os2,[I],Os3),
	replace(Os1,Y,Os3,OsX),
	replace(Os0,X,OsX,OsN),
	fill_field_up_to_index_and_add([],I,X,Y,Z,OsN,Os).
	
nth0_3Dtemp(X,Y,Z,Is,Os) :-
	nth0(X,Is,I1s),
	nth0(Y,I1s,I2s),
	nth0(Z,I2s,Os).
	
nth0_4Dtemp(W,X,Y,Z,Is,Os) :-
	nth0(W,Is,I0s),
	nth0(X,I0s,I1s),
	nth0(Y,I1s,I2s),
	nth0(Z,I2s,Os).	
	
list_sum([Item], Item).
list_sum([Item1,Item2 | Tail], Total) :-
    list_sum([Item1+Item2|Tail], Total).
    
avg( [], 0 ).
avg( List, Avg ):- 
    list_sum( List, Sum ),
    length( List, Length), 
    (  Length > 0
    -> Avg is Sum / Length
    ;  Avg is 0
    ).
    
remove_non_numbers([],[]).
remove_non_numbers([H|T], NewT):- 
    not(number(H)),
    remove_non_numbers(T, NewT).
remove_non_numbers([H|T1], [H|T2]):-         
    number(H),                   
    remove_non_numbers(T1, T2).	
	
	
/*	
average_pooling1D_layer(Is,PoolSize,Os):- average_pooling1D_layer(Is,PoolSize,PoolSize,false,[],Os).
average_pooling1D_layer([[I|Is0]|Is],PoolSize,Strides,Padding,Os):- 
	atomic(I),
	Padding,
	length([[I|Is0]|Is],L),
	OutLen is ceil(L / Strides),
	writeln(OutLen),
	Pad is max((OutLen - 1) * Strides + PoolSize - L, 0),
	writeln(Pad),
	writeln(Pad),
	LeftP is Pad // 2,
	RightP is Pad - LeftP,
	writeln(LeftP),
	writeln(RightP),
	padding1D([[I|Is0]|Is], x,LeftP, RightP, Is1),
	average_pooling1D_layer(Is1,PoolSize,Strides,Padding,[],Os).
average_pooling1D_layer(Is,PoolSize,Strides,Padding,Os):- 
	average_pooling1D_layer(Is,PoolSize,Strides,Padding,[],Os).
average_pooling1D_layer([],_,_,_,Os,Os).
average_pooling1D_layer([[I|Is0]|Is],PoolSize,Strides,Padding,Os0,Os) :-
	is_list(I),
	average_pooling1D_layer([I|Is0],PoolSize,Strides,Padding,O),
	append(Os0,[O],Os1),
	average_pooling1D_layer(Is,PoolSize,Strides,Padding,Os1,Os).
average_pooling1D_layer([[I|Is0]|Is],PoolSize,Strides,Padding,Os0,Os) :-
	atomic(I),
	del_first_items([[I|Is0]|Is],F,R),
	get_average_poolings(F,PoolSize,Strides,O),
	transpose([O],T),
	concatinate_sub_lists(Os0,T,Os1),
	average_pooling1D_layer(R,PoolSize,Strides,Padding,Os1,Os).

get_average_poolings(Is,PoolSize,Strides,Os) :- get_average_poolings(Is,PoolSize,Strides,[],Os).
get_average_poolings([],_,_,Os,Os).
get_average_poolings(Is,PoolSize,_,Os,Os) :-
	length(Is,N), N < PoolSize.
get_average_poolings(Is,PoolSize,Strides,Os0,Os) :-
	length(Is,N), N >= PoolSize,
	split_at(PoolSize,Is,L,_),
	remove_non_numbers(L,L1),
	avg(L1,A),
	append(Os0,[A],Os1),
	split_at(Strides,Is,_,R),
	get_average_poolings(R,PoolSize,Strides,Os1,Os).	
*/
	
%TODO add warnings when PoolSize or Strides is bigger than the input space.
pool1D_layer(Poolfunc,Is,PoolSize,Os):- pool1D_layer(Poolfunc,Is,PoolSize,PoolSize,false,[],Os).
pool1D_layer(Poolfunc,[[I|Is0]|Is],PoolSize,Strides,Padding,Os):- 
	atomic(I),
	Padding,
	length([[I|Is0]|Is],L),
	OutLen is ceil(L / Strides),
	Pad is max((OutLen - 1) * Strides + PoolSize - L, 0),
	LeftP is Pad // 2,
	RightP is Pad - LeftP,
	padding1D([[I|Is0]|Is], x,LeftP, RightP, Is1),
	pool1D_layer(Poolfunc,Is1,PoolSize,Strides,Padding,[],Os).
pool1D_layer(Poolfunc,Is,PoolSize,Strides,Padding,Os):- 
	pool1D_layer(Poolfunc,Is,PoolSize,Strides,Padding,[],Os).
pool1D_layer(_,[],_,_,_,Os,Os).
pool1D_layer(Poolfunc,[[I|Is0]|Is],PoolSize,Strides,Padding,Os0,Os) :-
	is_list(I),
	pool1D_layer(Poolfunc,[I|Is0],PoolSize,Strides,Padding,O),
	append(Os0,[O],Os1),
	pool1D_layer(Poolfunc,Is,PoolSize,Strides,Padding,Os1,Os).
pool1D_layer(Poolfunc,[[I|Is0]|Is],PoolSize,Strides,Padding,Os0,Os) :-
	atomic(I),
	del_first_items([[I|Is0]|Is],F,R),
	get_pool_res(Poolfunc,F,PoolSize,Strides,O),
	transpose([O],T),
	concatinate_sub_lists(Os0,T,Os1),
	pool1D_layer(Poolfunc,R,PoolSize,Strides,Padding,Os1,Os).

get_pool_res(Poolfunc,Is,PoolSize,Strides,Os) :- get_pool_res(Poolfunc,Is,PoolSize,Strides,[],Os).
get_pool_res(_,[],_,_,Os,Os).
get_pool_res(_,Is,PoolSize,_,Os,Os) :-
	length(Is,N), N < PoolSize.
get_pool_res(Poolfunc,Is,PoolSize,Strides,Os0,Os) :-
	length(Is,N), N >= PoolSize,
	split_at(PoolSize,Is,L,_),
	remove_non_numbers(L,L1),
	call(Poolfunc,L1,O),
	append(Os0,[O],Os1),
	split_at(Strides,Is,_,R),
	get_pool_res(Poolfunc,R,PoolSize,Strides,Os1,Os).
	
/*
average_pooling2D_layer(Is,PoolSizeD1,PoolSizeD2,Os):- average_pooling2D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD1,PoolSizeD2,false,Os).
average_pooling2D_layer([[[I|Is0]|Is1]|Is],PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os) :-
	%atomic(I),
	Padding,
	length([[[I|Is0]|Is1]|Is],LX),
	length([[I|Is0]|Is1],LY),
	calc_padding(LX,PoolSizeD1,StridesD1,LeftPD1,RightPD1),
	calc_padding(LY,PoolSizeD2,StridesD2,LeftPD2,RightPD2),
	writeln(LeftPD1),
	writeln(RightPD2),
	writeln(LeftPD2),
	writeln(RightPD2),
	writeln([[[I|Is0]|Is1]|Is]),
	padding2D([[[I|Is0]|Is1]|Is], x,LeftPD1,RightPD1,LeftPD2,RightPD2, Is2),
	writeln("Paddding applied"),
	writeln(Is2),
	average_pooling2D_layer(Is2,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,false,[],Os).
average_pooling2D_layer(Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os):- average_pooling2D_layer(Is,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,[],Os).
average_pooling2D_layer([],_,_,_,_,_,_,_,_,Os,Os).
average_pooling2D_layer([[[I|Is0]|Is1]|Is],0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os0,Os) :-
	is_list(I),
	average_pooling2D_layer([[I|Is0]|Is1],PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,O),
	append(Os0,[O],Os1),
	average_pooling2D_layer(Is,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os1,Os).
average_pooling2D_layer([[[I|Is0]|Is1]|Is],X,Y,Z,_,_,_,_,_,Os,Os) :-
	atomic(I),
	(length([[[I|Is0]|Is1]|Is],LX), 
	X >= LX; 
	length([[I|Is0]|Is1],LY), 
	Y >= LY;
	length([I|Is0],LZ), 
	Z >= LZ).
average_pooling2D_layer([[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os0,Os) :-
	atomic(I),
	length([[[I|Is0]|Is1]|Is],LX), 
	length([[I|Is0]|Is1],LY), 
	%length([I|Is0],LZ), 
	%X+PoolSizeD1 =< LX,Y+PoolSizeD2 =< LY,
	get_pool_avg([[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,O),
	insert_pool_field(Os0,O,X,Y,Z,StridesD1,StridesD2,Os1),
	(X+StridesD1+PoolSizeD1 =< LX -> X1 is X + StridesD1,Y1 is Y, Z1 is Z; (Y+StridesD2+PoolSizeD2 =< LY -> X1 is 0,Y1 is Y+StridesD2, Z1 is Z; X1 is 0, Y1 is 0, Z1 is Z + 1)),
	average_pooling2D_layer([[[I|Is0]|Is1]|Is],X1,Y1,Z1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os1,Os).
	
get_pool_avg(Is,X,Y,Z,PoolSizeD1,PoolSizeD2,O) :- get_pool_avg(Is,X,Y,Z,X,Y,PoolSizeD1,PoolSizeD2, [],O).
get_pool_avg(_, X,Y,_,X1,Y1,PoolSizeD1,PoolSizeD2, Os,O) :-
	(X1 >= X + PoolSizeD1;Y1 >= Y + PoolSizeD2),
	remove_non_numbers(Os,Os1),
	avg(Os1,O).
get_pool_avg(Is,X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,Os0,O) :-
	nth0_3Dtemp(X1,Y1,Z,Is,O1),
	append(Os0,[O1],Os1),
	((X1 < X+PoolSizeD1-1) -> X2 is X1 + 1,Y2 is Y1;X2 is X,Y2 is Y1+1),
	get_pool_avg(Is, X,Y,Z,X2,Y2,PoolSizeD1,PoolSizeD2, Os1,O).
*/	

calc_padding(InLen,PoolSize,Strides,LeftP,RightP) :-
	OutLen is ceil(InLen / Strides),
	Pad is max((OutLen - 1) * Strides + PoolSize - InLen, 0),
	LeftP is Pad // 2,
	RightP is Pad - LeftP.	
	
/*

average_pooling3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os):- average_pooling3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,PoolSizeD1,PoolSizeD2,PoolSizeD3,false,Os).
average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os):- 
	Padding,
	atomic(I),
	length([[[[I|Is0]|Is1]|Is2]|Is],LW), 
	length([[[I|Is0]|Is1]|Is2],LX), 
	length([[I|Is0]|Is1],LY), 
	writeln(LW),
	writeln(LX),
	writeln(LY),
	writeln("----"),
	writeln(PoolSizeD1),
	writeln(PoolSizeD2),
	writeln(PoolSizeD3),
	calc_padding(LW,PoolSizeD1,StridesD1,LeftPD1,RightPD1),
	calc_padding(LX,PoolSizeD2,StridesD2,LeftPD2,RightPD2),
	calc_padding(LY,PoolSizeD3,StridesD3,LeftPD3,RightPD3),
	writeln(LeftPD1),
	writeln(RightPD1),
	writeln(LeftPD2),
	writeln(RightPD2),
	writeln(LeftPD3),
	writeln(RightPD3),
	padding3D([[[[I|Is0]|Is1]|Is2]|Is], x,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3, Is3),
	writeln("Paddding applied"),
	writeln(Is3),
	average_pooling3D_layer(Is3,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,false,[],Os).
average_pooling3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os):- average_pooling3D_layer(Is,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,[],Os).
average_pooling3D_layer([],_,_,_,_,_,_,_,_,_,_,_,Os,Os).
average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os0,Os) :-
	is_list(I),
	average_pooling3D_layer([[[I|Is0]|Is1]|Is2],PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,O),
	writeln("iterate List"),
	writeln([[[I|Is0]|Is1]|Is2]),
	append(Os0,[O],Os1),
	writeln(O),
	average_pooling3D_layer(Is,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os1,Os).
average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,_,_,_,_,_,_,_,Os,Os) :-
	atomic(I),
	(length([[[[I|Is0]|Is1]|Is2]|Is],LW), 
	W >= LW; 
	length([[[I|Is0]|Is1]|Is2],LX), 
	X >= LX; 
	length([[I|Is0]|Is1],LY), 
	Y >= LY;
	length([I|Is0],LZ), 
	Z >= LZ).
average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os0,Os) :-
	atomic(I),
	%not(Padding),
	length([[[[I|Is0]|Is1]|Is2]|Is],LW),
	length([[[I|Is0]|Is1]|Is2],LX), 
	length([[I|Is0]|Is1],LY), 
	%length([I|Is0],LZ), 
	W+PoolSizeD1 =< LW,X+PoolSizeD2 =< LX,Y+PoolSizeD3 =< LY,
	get_pool_avg([[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,O),
	writeln("avg pool"),
	writeln(O),
	writeln(W),
	writeln(X),
	writeln(Y),
	writeln(Z),

	writeln("strides"),
	writeln(StridesD1),
	writeln(StridesD2),
	writeln(StridesD3),
	writeln("ins----------------"),
	writeln(Os0),
	insert_pool_field4D(Os0,O,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os1),
	writeln(Os1),
	writeln("ins---------------- completed --------"),
	(W+StridesD1+PoolSizeD1 =< LW -> W1 is W + StridesD1, X1 is X, Y1 is Y, Z1 is Z; 
	(X+StridesD2+PoolSizeD2 =< LX -> W1 is 0, X1 is X + StridesD2,Y1 is Y, Z1 is Z; 
	(Y+StridesD3+PoolSizeD3 =< LY -> W1 is 0, X1 is 0,Y1 is Y+StridesD3, Z1 is Z; 
	W1 is 0, X1 is 0, Y1 is 0, Z1 is Z + 1))),
	writeln(W1),
	writeln(X1),
	writeln(Y1),
	writeln(Z1),
	average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],W1,X1,Y1,Z1,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os1,Os).
	

get_pool_avg(Is,W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,O) :- get_pool_avg(Is,W,X,Y,Z,W,X,Y,PoolSizeD1,PoolSizeD2,PoolSizeD3, [],O).
get_pool_avg(_, W,X,Y,_,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3, Os,O) :-
	W1 >= W + PoolSizeD1; X1 >= X + PoolSizeD2;Y1 >= Y + PoolSizeD3,
	remove_non_numbers(Os,Os1),
	avg(Os1,O).
get_pool_avg([I|Is],W,X,Y,Z,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os0,O) :-
	length([I|Is],LW),
	length(I,LX),
	nth0_4Dtemp(W1,X1,Y1,Z,[I|Is],O1),
	append(Os0,[O1],Os1),
	(W1 < W+PoolSizeD1-1, W1< LW-1 -> W2 is W1 +1, X2 is X1,Y2 is Y1;((X1 < X+PoolSizeD2-1, X1< LX-1) -> W2 is W, X2 is X1 + 1,Y2 is Y1; W2 is W, X2 is X,Y2 is Y1+1)),
	get_pool_avg([I|Is], W,X,Y,Z,W2,X2,Y2,PoolSizeD1,PoolSizeD2,PoolSizeD3, Os1,O).

*/	


pool2D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,Os):- pool2D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,PoolSizeD1,PoolSizeD2,false,Os).
pool2D_layer(Poolfunc,[[[I|Is0]|Is1]|Is],PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os) :-
	Padding,
	length([[[I|Is0]|Is1]|Is],LX),
	length([[I|Is0]|Is1],LY),
	calc_padding(LX,PoolSizeD1,StridesD1,LeftPD1,RightPD1),
	calc_padding(LY,PoolSizeD2,StridesD2,LeftPD2,RightPD2),
	padding2D([[[I|Is0]|Is1]|Is], x,LeftPD1,RightPD1,LeftPD2,RightPD2, Is2),
	pool2D_layer(Poolfunc,Is2,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,false,[],Os).
pool2D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os):- pool2D_layer(Poolfunc,Is,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,[],Os).
pool2D_layer(_,[],_,_,_,_,_,_,_,_,Os,Os).
pool2D_layer(Poolfunc,[[[I|Is0]|Is1]|Is],0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os0,Os) :-
	is_list(I),
	pool2D_layer(Poolfunc,[[I|Is0]|Is1],PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,O),
	append(Os0,[O],Os1),
	pool2D_layer(Poolfunc,Is,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os1,Os).
pool2D_layer(_,[[[I|Is0]|Is1]|Is],X,Y,Z,_,_,_,_,_,Os,Os) :-
	atomic(I),
	(length([[[I|Is0]|Is1]|Is],LX), 
	X >= LX; 
	length([[I|Is0]|Is1],LY), 
	Y >= LY;
	length([I|Is0],LZ), 
	Z >= LZ).
pool2D_layer(Poolfunc,[[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os0,Os) :-
	atomic(I),
	length([[[I|Is0]|Is1]|Is],LX), 
	length([[I|Is0]|Is1],LY), 
	%length([I|Is0],LZ), 
	%X+PoolSizeD1 =< LX,Y+PoolSizeD2 =< LY,
	get_pool_res(Poolfunc,[[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,O),
	insert_pool_field(Os0,O,X,Y,Z,StridesD1,StridesD2,Os1),
	(X+StridesD1+PoolSizeD1 =< LX -> X1 is X + StridesD1,Y1 is Y, Z1 is Z; (Y+StridesD2+PoolSizeD2 =< LY -> X1 is 0,Y1 is Y+StridesD2, Z1 is Z; X1 is 0, Y1 is 0, Z1 is Z + 1)),
	pool2D_layer(Poolfunc,[[[I|Is0]|Is1]|Is],X1,Y1,Z1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os1,Os).
	
get_pool_res(Poolfunc,Is,X,Y,Z,PoolSizeD1,PoolSizeD2,O) :- get_pool_res(Poolfunc,Is,X,Y,Z,X,Y,PoolSizeD1,PoolSizeD2, [],O).
get_pool_res(Poolfunc,_, X,Y,_,X1,Y1,PoolSizeD1,PoolSizeD2, Os,O) :-
	(X1 >= X + PoolSizeD1;Y1 >= Y + PoolSizeD2),
	remove_non_numbers(Os,Os1),
	call(Poolfunc,Os1,O).
get_pool_res(Poolfunc,Is,X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,Os0,O) :-
	nth0_3Dtemp(X1,Y1,Z,Is,O1),
	append(Os0,[O1],Os1),
	((X1 < X+PoolSizeD1-1) -> X2 is X1 + 1,Y2 is Y1;X2 is X,Y2 is Y1+1),
	get_pool_res(Poolfunc,Is, X,Y,Z,X2,Y2,PoolSizeD1,PoolSizeD2, Os1,O).

	
pool3D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os):- pool3D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,PoolSizeD1,PoolSizeD2,PoolSizeD3,false,Os).
pool3D_layer(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os):- 
	Padding,
	atomic(I),
	length([[[[I|Is0]|Is1]|Is2]|Is],LW), 
	length([[[I|Is0]|Is1]|Is2],LX), 
	length([[I|Is0]|Is1],LY), 
	calc_padding(LW,PoolSizeD1,StridesD1,LeftPD1,RightPD1),
	calc_padding(LX,PoolSizeD2,StridesD2,LeftPD2,RightPD2),
	calc_padding(LY,PoolSizeD3,StridesD3,LeftPD3,RightPD3),
	padding3D([[[[I|Is0]|Is1]|Is2]|Is], x,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3, Is3),
	pool3D_layer(Poolfunc,Is3,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,false,[],Os).
pool3D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os):- pool3D_layer(Poolfunc,Is,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,[],Os).
pool3D_layer(_,[],_,_,_,_,_,_,_,_,_,_,_,Os,Os).
pool3D_layer(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os0,Os) :-
	is_list(I),
	pool3D_layer(Poolfunc,[[[I|Is0]|Is1]|Is2],PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,O),
	append(Os0,[O],Os1),
	pool3D_layer(Poolfunc,Is,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os1,Os).
pool3D_layer(_,[[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,_,_,_,_,_,_,_,Os,Os) :-
	atomic(I),
	(length([[[[I|Is0]|Is1]|Is2]|Is],LW), 
	W >= LW; 
	length([[[I|Is0]|Is1]|Is2],LX), 
	X >= LX; 
	length([[I|Is0]|Is1],LY), 
	Y >= LY;
	length([I|Is0],LZ), 
	Z >= LZ).
pool3D_layer(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os0,Os) :-
	atomic(I),
	length([[[[I|Is0]|Is1]|Is2]|Is],LW),
	length([[[I|Is0]|Is1]|Is2],LX), 
	length([[I|Is0]|Is1],LY), 
	%length([I|Is0],LZ), 
	W+PoolSizeD1 =< LW,X+PoolSizeD2 =< LX,Y+PoolSizeD3 =< LY,
	get_pool_res(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,O),
	insert_pool_field4D(Os0,O,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os1),
	(W+StridesD1+PoolSizeD1 =< LW -> W1 is W + StridesD1, X1 is X, Y1 is Y, Z1 is Z; 
	(X+StridesD2+PoolSizeD2 =< LX -> W1 is 0, X1 is X + StridesD2,Y1 is Y, Z1 is Z; 
	(Y+StridesD3+PoolSizeD3 =< LY -> W1 is 0, X1 is 0,Y1 is Y+StridesD3, Z1 is Z; 
	W1 is 0, X1 is 0, Y1 is 0, Z1 is Z + 1))),
	pool3D_layer(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],W1,X1,Y1,Z1,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os1,Os).

get_pool_res(Poolfunc,Is,W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,O) :- get_pool_res(Poolfunc,Is,W,X,Y,Z,W,X,Y,PoolSizeD1,PoolSizeD2,PoolSizeD3, [],O).
get_pool_res(Poolfunc,_, W,X,Y,_,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3, Os,O) :-
	W1 >= W + PoolSizeD1; X1 >= X + PoolSizeD2;Y1 >= Y + PoolSizeD3,
	remove_non_numbers(Os,Os1),
	call(Poolfunc,Os1,O).
get_pool_res(Poolfunc,[I|Is],W,X,Y,Z,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os0,O) :-
	length([I|Is],LW),
	length(I,LX),
	nth0_4Dtemp(W1,X1,Y1,Z,[I|Is],O1),
	append(Os0,[O1],Os1),
	(W1 < W+PoolSizeD1-1, W1< LW-1 -> W2 is W1 +1, X2 is X1,Y2 is Y1;((X1 < X+PoolSizeD2-1, X1< LX-1) -> W2 is W, X2 is X1 + 1,Y2 is Y1; W2 is W, X2 is X,Y2 is Y1+1)),
	get_pool_res(Poolfunc,[I|Is], W,X,Y,Z,W2,X2,Y2,PoolSizeD1,PoolSizeD2,PoolSizeD3, Os1,O).
	
	
%average_pooling1D_layer([[[8,3,5],[5,4,-2],[2,1,-1]]],1,X).
%average_pooling1D_layer([[[8,3,5],[5,4,-2],[2,1,-1]]],2,1,true,X).
%average_pooling1D_layer([[[8,3],[5,4],[2,1],[2,1]],[[8,3],[5,4],[2,1],[2,1]]],1,20,false,X).
average_pooling1D_layer(Is,PoolSize,Os):- pool1D_layer(avg,Is,PoolSize,Os).
average_pooling1D_layer(Is,PoolSize,Strides,Padding,Os):- 
	pool1D_layer(avg,Is,PoolSize,Strides,Padding,Os).
	
%average_pooling2D_layer([[[[8,3,5],[5,4,-2],[2,1,-1]]]],1,4,1,1,true,X).
%average_pooling2D_layer([[[[1,2],[3,4]],[[1,2],[3,4]]]],4,3,1,1,true,X).
average_pooling2D_layer(Is,PoolSize,Os):- 
	pool2D_layer(avg,Is,PoolSize,PoolSize,Os).
average_pooling2D_layer(Is,PoolSizeD1,PoolSizeD2,Os):- 
	pool2D_layer(avg,Is,PoolSizeD1,PoolSizeD2,PoolSizeD1,PoolSizeD2,false,Os).
average_pooling2D_layer(Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os):-
	pool2D_layer(avg,Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os).	
	
%average_pooling3D_layer([[[[[1]]]]],1,1,1,X).
%average_pooling3D_layer([[[[[8,3],[2,4]],[[4,3],[5,6]]],[[[8,3],[2,4]],[[4,3],[5,6]]]]],2,2,2,X).
%average_pooling3D_layer([[[[[8,3],[2,4]],[[4,3],[5,6]]],[[[8,3],[2,4]],[[4,3],[5,6]]]]],2,2,2,1,1,1,true,X).	
average_pooling3D_layer(Is,PoolSize,Os) :-
	pool3D_layer(avg,Is,PoolSize,PoolSize,PoolSize,Os).
average_pooling3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os) :-
	pool3D_layer(avg,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os).
average_pooling3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os) :-
	pool3D_layer(avg,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os).
average_pooling3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os) :-
	pool3D_layer(avg,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os).	
	
	
%global_average_pooling1D_layer([[[8,3,6],[5,4,9]]],X).
%global_average_pooling1D_layer([[[8,3],[5,4]],[[8,3],[5,4]],[[8,3],[5,4]]],X).
global_average_pooling1D_layer([[I|Is0]|Is],Os):- atomic(I), length([[I|Is0]|Is],L), average_pooling1D_layer([[I|Is0]|Is],L,Os).
global_average_pooling1D_layer([[I|Is0]|Is],Os):- is_list(I), length([I|Is0],L), average_pooling1D_layer([[I|Is0]|Is],L,Os).

global_average_pooling2D_layer([[[I|Is0]|Is1]|Is],Os):- atomic(I), length([[[I|Is0]|Is1]|Is],L1), length([[I|Is0]|Is1],L2), average_pooling2D_layer([[[I|Is0]|Is1]|Is],L1,L2,Os).
global_average_pooling2D_layer([[[I|Is0]|Is1]|Is],Os):- is_list(I), length([[I|Is0]|Is1],L1), length([I|Is0],L2), average_pooling2D_layer([[[I|Is0]|Is1]|Is],L1,L2,Os).

global_average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],Os):- atomic(I), length([[[[I|Is0]|Is1]|Is2]|Is],L1), length([[[I|Is0]|Is1]|Is2],L2), length([[I|Is0]|Is1],L3), average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],L1,L2,L3,Os).
global_average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],Os):- is_list(I), length([[[I|Is0]|Is1]|Is2],L1), length([[I|Is0]|Is1],L2), length([I|Is0],L3), average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],L1,L2,L3,Os).


%max_pool1D_layer([[[8,3,5],[5,4,-2],[2,1,-1]]],1,X).
%max_pool1D_layer([[[8,3,5],[5,4,-2],[2,1,-1]]],2,1,true,X).
%max_pool1D_layer([[[8,3],[5,4],[2,1],[2,1]],[[8,3],[5,4],[2,1],[2,1]]],1,20,false,X).
max_pool1D_layer(Is,PoolSize,Os):- pool1D_layer(max_list,Is,PoolSize,Os).
max_pool1D_layer(Is,PoolSize,Strides,Padding,Os):- 
	pool1D_layer(max_list,Is,PoolSize,Strides,Padding,Os).
	
%max_pool2D_layer([[[[8,3,5],[5,4,-2],[2,1,-1]]]],1,4,1,1,true,X).
%max_pool2D_layer([[[[1,2],[3,4]],[[1,2],[3,4]]]],4,3,1,1,true,X).
max_pool2D_layer(Is,PoolSize,Os):- 
	pool2D_layer(max_list,Is,PoolSize,PoolSize,Os).
max_pool2D_layer(Is,PoolSizeD1,PoolSizeD2,Os):- 
	pool2D_layer(max_list,Is,PoolSizeD1,PoolSizeD2,PoolSizeD1,PoolSizeD2,false,Os).
max_pool2D_layer(Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os):-
	pool2D_layer(max_list,Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os).	
	
%max_pool3D_layer([[[[[1]]]]],1,1,1,X).
%max_pool3D_layer([[[[[8,3],[2,4]],[[4,3],[5,6]]],[[[8,3],[2,4]],[[4,3],[5,6]]]]],2,2,2,X).
%max_pool3D_layer([[[[[8,3],[2,4]],[[4,3],[5,6]]],[[[8,3],[2,4]],[[4,3],[5,6]]]]],2,2,2,1,1,1,true,X).	
max_pool3D_layer(Is,PoolSize,Os) :-
	pool3D_layer(max_list,Is,PoolSize,PoolSize,PoolSize,Os).
max_pool3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os) :-
	pool3D_layer(max_list,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os).
max_pool3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os) :-
	pool3D_layer(max_list,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os).
max_pool3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os) :-
	pool3D_layer(max_list,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os).	
	
	
%global_max_pool1D_layer([[[8,3,6],[5,4,9]]],X).
%global_max_pool1D_layer([[[8,3],[5,4]],[[8,3],[5,4]],[[8,3],[5,4]]],X).
global_max_pool1D_layer([[I|Is0]|Is],Os):- atomic(I), length([[I|Is0]|Is],L), max_pool1D_layer([[I|Is0]|Is],L,Os).
global_max_pool1D_layer([[I|Is0]|Is],Os):- is_list(I), length([I|Is0],L), max_pool1D_layer([[I|Is0]|Is],L,Os).

global_max_pool2D_layer([[[I|Is0]|Is1]|Is],Os):- atomic(I), length([[[I|Is0]|Is1]|Is],L1), length([[I|Is0]|Is1],L2), max_pool2D_layer([[[I|Is0]|Is1]|Is],L1,L2,Os).
global_max_pool2D_layer([[[I|Is0]|Is1]|Is],Os):- is_list(I), length([[I|Is0]|Is1],L1), length([I|Is0],L2), max_pool2D_layer([[[I|Is0]|Is1]|Is],L1,L2,Os).

global_max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],Os):- atomic(I), length([[[[I|Is0]|Is1]|Is2]|Is],L1), length([[[I|Is0]|Is1]|Is2],L2), length([[I|Is0]|Is1],L3), max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],L1,L2,L3,Os).
global_max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],Os):- is_list(I), length([[[I|Is0]|Is1]|Is2],L1), length([[I|Is0]|Is1],L2), length([I|Is0],L3), max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],L1,L2,L3,Os).
