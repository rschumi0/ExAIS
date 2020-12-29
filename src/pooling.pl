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
	
get_pool_max(Is,X,Y,Z,PoolSizeD1,PoolSizeD2,O) :- nth0_3D(X,Y,Z,Is,O1), get_pool_max(Is,X,Y,Z,X,Y,PoolSizeD1,PoolSizeD2, O1,O).
get_pool_max([[[I|Is0]|Is1]|Is],_,_,_,X1,Y1,_,_, O,O) :-
	length([[[I|Is0]|Is1]|Is],LX), 
	X1 >= LX;
	length([[I|Is0]|Is1],LY), 
	Y1 >= LY.
get_pool_max(_, X,Y,_,X1,Y1,PoolSizeD1,PoolSizeD2, O,O) :-
	X1 >= X + PoolSizeD1;Y1 >= Y + PoolSizeD2.
get_pool_max(Is,X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,O1,O) :-
	length(Is,LX),
	nth0_3D(X1,Y1,Z,Is,O2),
	(O2 < O1 -> O3 is O1; O3 is O2),
	((X1 < X+PoolSizeD1-1, X1< LX-1) -> X2 is X1 + 1,Y2 is Y1;X2 is X,Y2 is Y1+1),
	get_pool_max(Is, X,Y,Z,X2,Y2,PoolSizeD1,PoolSizeD2, O3,O).
*/	
	

insert_pool_field(Is,I,Append,X,Y,Strides,Os) :- Is = [], insert_pool_field([[]],I,Append,X,Y,Strides,Os).
insert_pool_field(Is,I,Append,X,Y,Strides,Os) :-
	X1 is X / Strides,
	Y1 is Y,
	fill_field_up_to_index_and_add2D(Is,I,Append,X1,Y1,Os).

fill_field_up_to_index_and_add2D(Is,I,Append,X,Y,Os) :- fill_field_up_to_index_and_add2D(Is,I,Append,X,Y,Is,Os). 
fill_field_up_to_index_and_add2D([],_,_,_,_,Os,Os).
fill_field_up_to_index_and_add2D(Is,I,Append,X,Y,Os0,Os) :-
	length(Os0,L),
	X >= L,
	append(Os0,[[]],Os1),
	fill_field_up_to_index_and_add2D(Is,I,Append,X,Y,Os1,Os).
fill_field_up_to_index_and_add2D(Is,I,Append,X,Y,Os0,Os) :-
	nth0(X,Os0,Os1),
	length(Os1,L),
	Y > L,
	append(Os1,[0],Os2),
	replace(Os0,X,Os2,Os3),
	fill_field_up_to_index_and_add2D(Is,I,Append,X,Y,Os3,Os).
fill_field_up_to_index_and_add2D(Is,I,false,X,Y,Os0,Os) :-
	nth0(X,Os0,Os1),
	length(Os1,L),
	Y = L,
	append(Os1,[0],Os2),
	replace(Os0,X,Os2,Os3),
	fill_field_up_to_index_and_add2D(Is,I,false,X,Y,Os3,Os).
fill_field_up_to_index_and_add2D(_,I,true,X,Y,Os0,Os) :-
	nth0(X,Os0,Os1),
	length(Os1,L),
	Y = L,
	(atomic(I) -> append(Os1,[I],Os2);append(Os1,I,Os2)),
	replace(Os0,X,Os2,Os3),
	fill_field_up_to_index_and_add2D([],I,true,X,Y,Os3,Os).
fill_field_up_to_index_and_add2D(_,I,false,X,Y,Os0,Os) :-
	nth0(X,Os0,Os1),
	length(Os1,L),
	Y < L,
	replace(Os1,Y,I,Os2),
	%(atomic(I) -> append(Os1,[I],Os2);append(Os1,I,Os2)),
	replace(Os0,X,Os2,Os3),
	fill_field_up_to_index_and_add2D([],I,false,X,Y,Os3,Os).
	
insert_pool_field(Is,I,Append,X,Y,Z,StridesD1,StridesD2,Os) :- Is = [], insert_pool_field([[[]]],I,Append,X,Y,Z,StridesD1,StridesD2,Os).
insert_pool_field(Is,I,Append,X,Y,Z,StridesD1,StridesD2,Os) :-
	X1 is X / StridesD1,
	Y1 is Y / StridesD2,
	Z1 is Z,
	fill_field_up_to_index_and_add3D(Is,I,Append,X1,Y1,Z1,Os).


insert_pool_field4D(Is,I,Append,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os) :- Is = [], insert_pool_field4D([[[[]]]],I,Append,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os).
insert_pool_field4D(Is,I,Append,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os) :-
	W1 is W / StridesD1,
	X1 is X / StridesD2,
	Y1 is Y / StridesD3,
	Z1 is Z,
	fill_field_up_to_index_and_add4D(Is,I,Append,W1,X1,Y1,Z1,Os).
fill_field_up_to_index_and_add4D(Is,I,Append,W,X,Y,Z,Os) :- fill_field_up_to_index_and_add4D(Is,I,Append,W,X,Y,Z,Is,Os).
fill_field_up_to_index_and_add4D([],_,_,_,_,_,_,Os,Os).
fill_field_up_to_index_and_add4D(Is,I,Append,W,X,Y,Z,Os0,Os) :-
	length(Os0,L),
	W >= L,
	append(Os0,[[[[]]]],Os1),
	fill_field_up_to_index_and_add4D(Is,I,Append,W,X,Y,Z,Os1,Os).
fill_field_up_to_index_and_add4D(_,I,Append,W,X,Y,Z,Os0,Os) :-
	length(Os0,L),
	W < L,
	nth0(W,Os0,Os1),
	fill_field_up_to_index_and_add3D(Os1,I,Append,X,Y,Z,Os2),
	replace(Os0,W,Os2,Os3),
	fill_field_up_to_index_and_add4D([],I,Append,W,X,Y,Z,Os3,Os).

/*fill_field_up_to_index_and_add(Is,I,X,Y,Z,Os) :- fill_field_up_to_index_and_add(Is,I,X,Y,Z,Is,Os). 
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
	fill_field_up_to_index_and_add([],I,X,Y,Z,OsN,Os).*/
	
fill_field_up_to_index_and_add3D(Is,I,Append,X,Y,Z,Os) :- fill_field_up_to_index_and_add3D(Is,I,Append,X,Y,Z,Is,Os).
fill_field_up_to_index_and_add3D([],_,_,_,_,_,Os,Os).
fill_field_up_to_index_and_add3D(Is,I,Append,X,Y,Z,Os0,Os) :-
	length(Os0,L),
	X >= L,
	append(Os0,[[[]]],Os1),
	fill_field_up_to_index_and_add3D(Is,I,Append,X,Y,Z,Os1,Os).
fill_field_up_to_index_and_add3D(_,I,Append,X,Y,Z,Os0,Os) :-
	length(Os0,L),
	X < L,
	nth0(X,Os0,Os1),
	fill_field_up_to_index_and_add2D(Os1,I,Append,Y,Z,Os2),
	replace(Os0,X,Os2,Os3),
	fill_field_up_to_index_and_add3D([],I,Append,X,Y,Z,Os3,Os).



	
calc_padding(InLen,PoolSize,Strides,LeftP,RightP) :-
	OutLen is ceil(InLen / Strides),
	Pad is max((OutLen - 1) * Strides + PoolSize - InLen, 0),
	LeftP is Pad // 2,
	RightP is Pad - LeftP.	



	
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
/*pool1D_layer(Poolfunc,Is,PoolSize,Os):- pool1D_layer(Poolfunc,Is,PoolSize,PoolSize,false,[],Os).
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
	get_pool_res(Poolfunc,R,PoolSize,Strides,Os1,Os).*/

	

	
	
	
pool1D_layer(Poolfunc,Is,PoolSize,Os):- 
	pool1D_layer(Poolfunc,Is,PoolSize,PoolSize,false,[],[],true,Os).
pool1D_layer(Poolfunc,Is,PoolSize,Strides,Padding,Os) :- 
	pool1D_layer(Poolfunc,Is,PoolSize,Strides,Padding,[],[],true,Os).
pool1D_layer(Poolfunc,[[I|Is0]|Is],PoolSize,Strides,true,IWs,Bs,MultiLayerPool,Os) :-
	atomic(I),
	length([[I|Is0]|Is],L),
	/*OutLen is ceil(L / Strides),
	Pad is max((OutLen - 1) * Strides + PoolSize - L, 0),
	LeftP is Pad // 2,
	RightP is Pad - LeftP,*/
	calc_padding(L,PoolSize,Strides,LeftP,RightP),
	(IWs = [] -> padding1D([[I|Is0]|Is], x,LeftP, RightP, Is1); padding1D([[I|Is0]|Is], 0,LeftP, RightP, Is1)),
	pool1D_layer(Poolfunc,Is1,PoolSize,Strides,false,IWs,Bs,MultiLayerPool,Os).
pool1D_layer(Poolfunc,Is,PoolSize,Strides,Padding,IWs,Bs,MultiLayerPool,Os):- 
	pool1D_layer(Poolfunc,Is,0,0,PoolSize,Strides,Padding,IWs,Bs,MultiLayerPool,[],Os).
pool1D_layer(_,[],_,_,_,_,_,_,_,_,Os,Os).
pool1D_layer(Poolfunc,[[I|Is0]|Is],0,0,PoolSize,Strides,Padding,IWs,Bs,MultiLayerPool,Os0,Os) :-
	is_list(I),
	pool1D_layer(Poolfunc,[I|Is0],PoolSize,Strides,Padding,IWs,Bs,MultiLayerPool,O),
	append(Os0,[O],Os1),
	pool1D_layer(Poolfunc,Is,0,0,PoolSize,Strides,Padding,IWs,Bs,MultiLayerPool,Os1,Os).
pool1D_layer(_,[[I|Is0]|Is],X,Y,_,_,_,_,_,_,Os,Os) :-
	atomic(I),
	(length([[I|Is0]|Is],LX), 
	X >= LX; 
	length([I|Is0],LY), 
	Y >= LY).
pool1D_layer(Poolfunc,[[I|Is0]|Is],X,Y,PoolSize,Strides,Padding,IWs,Bs,true,Os0,Os) :-
	atomic(I),
	%MultiLayerPool,
	length([[I|Is0]|Is],LX), 
	%length([I|Is0],LY), 
	get_pool_res1D(Poolfunc,[[I|Is0]|Is],X,Y,PoolSize,Strides,IWs,Bs,true,O),
	insert_pool_field(Os0,O,true,X,Y,Strides,Os1),
	(X+Strides+PoolSize =< LX -> X1 is X + Strides,Y1 is Y; X1 is 0,Y1 is Y+1),
	pool1D_layer(Poolfunc,[[I|Is0]|Is],X1,Y1,PoolSize,Strides,Padding,IWs,Bs,true,Os1,Os).
pool1D_layer(Poolfunc,[[I|Is0]|Is],X,Y,PoolSize,Strides,Padding,IWs,Bs,false,Os0,Os) :-
	atomic(I),
	%not(MultiLayerPool),
	length([[I|Is0]|Is],LX), 
	%length([I|Is0],LY), 
	%writeln("before pool calc"),
	%writeln(X),
	%writeln(Y),
	get_pool_res1D(Poolfunc,[[I|Is0]|Is],X,Y,PoolSize,Strides,IWs,Bs,false,O),
	%writeln(Os0),
	%writeln(O),
	insert_pool_field(Os0,O,true,X,Y,Strides,Os1),
	%writeln(Os1),
	(X+Strides+PoolSize =< LX -> X1 is X + Strides; X1 is LX+1),
	pool1D_layer(Poolfunc,[[I|Is0]|Is],X1,0,PoolSize,Strides,Padding,IWs,Bs,false,Os1,Os).
	
get_pool_res1D(Poolfunc,Is,X,Y,PoolSize,Strides,IWs,Bs,MultiLayerPool,O) :- get_pool_res1D(Poolfunc,Is,X,Y,X,PoolSize,Strides,IWs,Bs,MultiLayerPool,[],O).
get_pool_res1D(Poolfunc,[I|_],X,Y,X1,PoolSize,_,_,_,_,[O1|Os],O) :-
	((X1 >= X + PoolSize);
	length(I,LY), Y >= LY),
	atomic(O1),
	remove_non_numbers([O1|Os],Os1),
	call(Poolfunc,Os1,O).
get_pool_res1D(Poolfunc,Is,X,Y,X1,PoolSize,Strides,IWs,Bs,true,Os0,O) :-
	nth0_2D(X1,Y,Is,O1),
	append(Os0,[O1],Os1),
	X2 is X1 + 1,
	get_pool_res1D(Poolfunc,Is, X,Y,X2,PoolSize,Strides,IWs,Bs,true,Os1,O).
get_pool_res1D(Poolfunc,[I|Is],X,Y,X1,PoolSize,Strides,IWs,[B|Bs],false,Os0,O) :-
	not(check_separable_conv_weights(IWs)),
	XT is X1 - X,
	(atomic(B) -> nth0_2D(XT,Y,IWs,Ws); (XT1 is X / Strides, length(I,LY), XT2 is (XT * LY) + Y, nth0_2D(XT1,XT2,IWs,Ws))),
	nth0_2D(X1,Y,[I|Is],O1),
	multiply_each_list_element_with(Ws,O1,O2),
	append(Os0,[O2],Os1),
	((X1 < X+PoolSize-1) -> X2 is X1 + 1,Y1 is Y;X2 is X,Y1 is Y+1),
	get_pool_res1D(Poolfunc,[I|Is],X,Y1,X2,PoolSize,Strides,IWs,[B|Bs],false,Os1,O).
get_pool_res1D(Poolfunc,[I|Is],X,Y,X1,PoolSize,Strides,[TWs,IWs1,IWs2],[B|Bs],false,Os0,O) :-
	check_separable_conv_weights([TWs,IWs1,IWs2]),
	XT is X1 - X,
	nth0_3D(XT,Y,0,IWs1,Ws1),
	nth0_2D(X1,Y,[I|Is],O1),
	O2 is O1 * Ws1,
	nth0_2D(0,Y,IWs2,Ws2),
	multiply_each_list_element_with(Ws2,O2,O3),
	append(Os0,[O3],Os1),
	((X1 < X+PoolSize-1) -> X2 is X1 + 1,Y1 is Y;X2 is X,Y1 is Y+1),
	get_pool_res1D(Poolfunc,[I|Is],X,Y1,X2,PoolSize,Strides,[TWs,IWs1,IWs2],[B|Bs],false,Os1,O).
get_pool_res1D(Poolfunc,[I|_],X,Y,X1,PoolSize,Strides,_,[B|Bs],_,[O1|Os],OsF) :-
	((X1 >= X + PoolSize);
	length(I,LY), Y >= LY),
	is_list(O1),
	get_pool_res1D(Poolfunc,[I|_],X,Y,X1,PoolSize,Strides,_,[B|Bs],_,[O1|Os],[],OsF). 
get_pool_res1D(Poolfunc,[I|_],X,Y,X1,PoolSize,Strides,_,[B|Bs],_,[O1|Os],OsT,OsF) :-
	is_list(B),
	XT1 is X / Strides,
	nth0(XT1,[B|Bs],Bs1),
	get_pool_res1D(Poolfunc,[I|_],X,Y,X1,PoolSize,Strides,_,Bs1,_,[O1|Os],OsT,OsF).
get_pool_res1D(Poolfunc,[I|_],X,Y,X1,PoolSize,_,_,[B|Bs],_,[O1|Os],OsT,OsF) :-
	%((X1 >= X + PoolSize);
	%length(I,LY), Y >= LY),
	%is_list(O1),
	atomic(B),
	del_first_items([O1|Os],F,R),
	remove_non_numbers(F,Os1),
	call(Poolfunc,Os1,O),
	%(atomic(B) -> A is B, Bs1 is Bs;nth0(X,[B|Bs],[A|TW]), Bs1 is TW),
	N is  O + B,
	append(OsT,[N],OsT1),
	get_pool_res1D(Poolfunc,[I|_],X,Y,X1,PoolSize,_,_,Bs,_,R,OsT1,OsF).
get_pool_res1D(_,_,_,_,_,_,_,_,_,_,[],OsF,OsF).

	
	


	
	
	
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
	nth0_3D(X1,Y1,Z,Is,O1),
	append(Os0,[O1],Os1),
	((X1 < X+PoolSizeD1-1) -> X2 is X1 + 1,Y2 is Y1;X2 is X,Y2 is Y1+1),
	get_pool_avg(Is, X,Y,Z,X2,Y2,PoolSizeD1,PoolSizeD2, Os1,O).
*/	
	
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
	nth0_4D(W1,X1,Y1,Z,[I|Is],O1),
	append(Os0,[O1],Os1),
	(W1 < W+PoolSizeD1-1, W1< LW-1 -> W2 is W1 +1, X2 is X1,Y2 is Y1;((X1 < X+PoolSizeD2-1, X1< LX-1) -> W2 is W, X2 is X1 + 1,Y2 is Y1; W2 is W, X2 is X,Y2 is Y1+1)),
	get_pool_avg([I|Is], W,X,Y,Z,W2,X2,Y2,PoolSizeD1,PoolSizeD2,PoolSizeD3, Os1,O).

*/	

pool2D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,Os):- 
	pool2D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,PoolSizeD1,PoolSizeD2,false,[],[],true,Os).
pool2D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os) :- 
	pool2D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,[],[],true,Os).
pool2D_layer(Poolfunc,[[[I|Is0]|Is1]|Is],PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,true,IWs,Bs,MultiLayerPool,Os) :-
	atomic(I),
	length([[[I|Is0]|Is1]|Is],LX),
	length([[I|Is0]|Is1],LY),
	calc_padding(LX,PoolSizeD1,StridesD1,LeftPD1,RightPD1),
	calc_padding(LY,PoolSizeD2,StridesD2,LeftPD2,RightPD2),
	(IWs = [] -> padding2D([[[I|Is0]|Is1]|Is], x,LeftPD1,RightPD1,LeftPD2,RightPD2, Is2); 
	padding2D([[[I|Is0]|Is1]|Is], 0,LeftPD1,RightPD1,LeftPD2,RightPD2, Is2)),
	pool2D_layer(Poolfunc,Is2,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,false,IWs,Bs,MultiLayerPool,[],Os).
pool2D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,MultiLayerPool,Os):- 
	pool2D_layer(Poolfunc,Is,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,MultiLayerPool,[],Os).
pool2D_layer(_,[],_,_,_,_,_,_,_,_,_,_,_,Os,Os).
pool2D_layer(Poolfunc,[[[I|Is0]|Is1]|Is],0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,MultiLayerPool,Os0,Os) :-
	is_list(I),
	pool2D_layer(Poolfunc,[[I|Is0]|Is1],PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,MultiLayerPool,O),
	append(Os0,[O],Os1),
	pool2D_layer(Poolfunc,Is,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,MultiLayerPool,Os1,Os).
pool2D_layer(_,[[[I|Is0]|Is1]|Is],X,Y,Z,_,_,_,_,_,_,_,_,Os,Os) :-
	atomic(I),
	(length([[[I|Is0]|Is1]|Is],LX), 
	X >= LX; 
	length([[I|Is0]|Is1],LY), 
	Y >= LY;
	length([I|Is0],LZ), 
	Z >= LZ).
pool2D_layer(Poolfunc,[[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,true,Os0,Os) :-
	atomic(I),
	length([[[I|Is0]|Is1]|Is],LX), 
	length([[I|Is0]|Is1],LY), 
	get_pool_res2D(Poolfunc,[[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,true,O),
	insert_pool_field(Os0,O,true,X,Y,Z,StridesD1,StridesD2,Os1),
	(X+StridesD1+PoolSizeD1 =< LX -> X1 is X + StridesD1,Y1 is Y, Z1 is Z; 
	(Y+StridesD2+PoolSizeD2 =< LY -> X1 is 0,Y1 is Y+StridesD2, Z1 is Z; 
					 X1 is 0, Y1 is 0, Z1 is Z + 1)),
	pool2D_layer(Poolfunc,[[[I|Is0]|Is1]|Is],X1,Y1,Z1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,true,Os1,Os).
pool2D_layer(Poolfunc,[[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,false,Os0,Os) :-
	atomic(I),
	length([[[I|Is0]|Is1]|Is],LX), 
	length([[I|Is0]|Is1],LY), 
	get_pool_res2D(Poolfunc,[[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,false,O),
	insert_pool_field(Os0,O,true,X,Y,Z,StridesD1,StridesD2,Os1),
	(X+StridesD1+PoolSizeD1 =< LX -> X1 is X + StridesD1,Y1 is Y, Z1 is Z; 
	(Y+StridesD2+PoolSizeD2 =< LY -> X1 is 0,Y1 is Y+StridesD2, Z1 is Z; 
					X1 is LX +1, Y1 is LY + 1, Z1 is Z + 1)),
	pool2D_layer(Poolfunc,[[[I|Is0]|Is1]|Is],X1,Y1,Z1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,false,Os1,Os).

	
get_pool_res2D(Poolfunc,Is,X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,MultiLayerPool,O) :- 
	get_pool_res2D(Poolfunc,Is,X,Y,Z,X,Y,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,MultiLayerPool,[],O).
get_pool_res2D(Poolfunc,[[I|_]|_], X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,_,_,_,Bs,_,[O1|Os],O) :-
	(X1 >= X + PoolSizeD1;Y1 >= Y + PoolSizeD2;(length(I,LZ), Z >= LZ)),
	atomic(O1),
	remove_non_numbers([O1|Os],Os1),
	(Bs = [] -> 	(call(Poolfunc,Os1,O));
			(call(Poolfunc,Os1,O0),nth0(Z,Bs,B),O is O0 + B)).
get_pool_res2D(Poolfunc,Is,X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,true,Os0,O) :-
	nth0_3D(X1,Y1,Z,Is,O1),
	(IWs = [] -> 	(append(Os0,[O1],Os1));
			(XT is X1 - X,YT is Y1 - Y,nth0_4D(XT,YT,Z,0, IWs,W),O2 is O1*W,append(Os0,[O2],Os1))),
	((X1 < X+PoolSizeD1-1) -> X2 is X1 + 1,Y2 is Y1;X2 is X,Y2 is Y1+1),
	get_pool_res2D(Poolfunc,Is, X,Y,Z,X2,Y2,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,true,Os1,O).
get_pool_res2D(Poolfunc,[[I|Is1]|Is],X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,[B|Bs],false,Os0,O) :-
	not(check_separable_conv_weights(IWs)),
	XT is X1 - X,
	YT is Y1 - Y,
	(atomic(B) -> nth0_3D(XT,YT,Z, IWs,Ws); 
	(XT1 is X / StridesD1, YT1 is Y / StridesD2, length([I|Is1],LY), T is YT1 +XT1  * ceil((LY - PoolSizeD2 +1) / StridesD2),%length([[I|Is1]|Is],LX),T is XT1 + YT1 * ceil((LX - PoolSizeD1 +1) / StridesD1)
	length(I,LZ),T1 is ((YT+(XT*PoolSizeD2))*LZ) + Z, nth0_2D(T,T1,IWs,Ws))),
	%TODO check if order of the weights within the kernel is wrong?
	%((XT+(YT*PoolSizeD1))*LZ) + Z %XT + YT*PoolSizeD1+ Z*PoolSizeD1*PoolSizeD2
	nth0_3D(X1,Y1,Z,[[I|Is1]|Is],O1),
	multiply_each_list_element_with(Ws,O1,O2),
	append(Os0,[O2],Os1),
	(X1 < X+PoolSizeD1-1  -> X2 is X1 +1, Y2 is Y1,Z1 is Z;
	(Y1 < Y+PoolSizeD2-1  -> X2 is X, Y2 is Y1 + 1,Z1 is Z; 
				 X2 is X, Y2 is Y,Z1 is Z+1)),
	get_pool_res2D(Poolfunc,[[I|Is1]|Is],X,Y,Z1,X2,Y2,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,[B|Bs],false,Os1,O).
get_pool_res2D(Poolfunc,[[I|Is1]|Is],X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,[TWs,IWs1,IWs2],[B|Bs],false,Os0,O) :-
	check_separable_conv_weights([TWs,IWs1,IWs2]),
	XT is X1 - X,
	YT is Y1 - Y,
	nth0_4D(XT,YT,Z,0,IWs1,Ws1),
	nth0_3D(X1,Y1,Z,[[I|Is1]|Is],O1),
	O2 is O1 * Ws1,
	nth0_3D(0,0,Z,IWs2,Ws2),
	multiply_each_list_element_with(Ws2,O2,O3),
	append(Os0,[O3],Os1),
	(X1 < X+PoolSizeD1-1  -> X2 is X1 +1, Y2 is Y1,Z1 is Z;
	(Y1 < Y+PoolSizeD2-1  -> X2 is X, Y2 is Y1 + 1,Z1 is Z; 
				 X2 is X, Y2 is Y,Z1 is Z+1)),
	get_pool_res2D(Poolfunc,[[I|Is1]|Is],X,Y,Z1,X2,Y2,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,[TWs,IWs1,IWs2],[B|Bs],false,Os1,O).
get_pool_res2D(Poolfunc,[[I|Is1]|Is], X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,[B|Bs],_,[O1|Os],OsF) :-
	(X1 >= X + PoolSizeD1;Y1 >= Y + PoolSizeD2;(length(I,LZ), Z >= LZ)),
	is_list(O1),
	get_pool_res2D(Poolfunc,[[I|Is1]|Is], X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,[B|Bs],_,[O1|Os],[],OsF).
get_pool_res2D(Poolfunc,_, X,Y,Z,X1,Y1,PoolSizeD1,_,StridesD1,StridesD2,_,[B|Bs],_,[O1|Os],OsT,OsF) :-
	is_list(B),
	XT1 is X / StridesD1, 
	YT1 is Y / StridesD2, 
	%length(Is,L), T is XT1 + YT1 * ceil((L - PoolSizeD1 +1) / StridesD1),
	nth0_2D(XT1,YT1,[B|Bs],Bs1),
	get_pool_res2D(Poolfunc,_, X,Y,Z,X1,Y1,PoolSizeD1,_,_,_,_,Bs1,_,[O1|Os],OsT,OsF).
get_pool_res2D(Poolfunc,_, X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,_,_,_,[B|Bs],_,[O1|Os],OsT,OsF) :-
	atomic(B),
	del_first_items([O1|Os],F,R),
	remove_non_numbers(F,Os1),
	call(Poolfunc,Os1,O),
	N is  O + B,
	append(OsT,[N],OsT1),
	get_pool_res2D(Poolfunc,_, X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,_,_,_,Bs,_,R,OsT1,OsF).
get_pool_res2D(_,_,_,_,_,_,_,_,_,_,_,_,_,_,[],OsF,OsF).


	
pool3D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os):- 
	pool3D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,PoolSizeD1,PoolSizeD2,PoolSizeD3,false,[],[],true,Os).
pool3D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os):- 
	pool3D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,[],[],true,Os).
pool3D_layer(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,true,IWs,Bs,MultiLayerPool,Os):- 
	atomic(I),
	length([[[[I|Is0]|Is1]|Is2]|Is],LW), 
	length([[[I|Is0]|Is1]|Is2],LX), 
	length([[I|Is0]|Is1],LY), 
	calc_padding(LW,PoolSizeD1,StridesD1,LeftPD1,RightPD1),
	calc_padding(LX,PoolSizeD2,StridesD2,LeftPD2,RightPD2),
	calc_padding(LY,PoolSizeD3,StridesD3,LeftPD3,RightPD3),
	(IWs = [] -> padding3D([[[[I|Is0]|Is1]|Is2]|Is], x,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3, Is3); 
	padding3D([[[[I|Is0]|Is1]|Is2]|Is], 0,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3, Is3)),
	pool3D_layer(Poolfunc,Is3,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,false,IWs,Bs,MultiLayerPool,[],Os).
pool3D_layer(Poolfunc,Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,IWs,Bs,MultiLayerPool,Os):- 
	pool3D_layer(Poolfunc,Is,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,IWs,Bs,MultiLayerPool,[],Os).
pool3D_layer(_,[],_,_,_,_,_,_,_,_,_,_,_,_,_,_,Os,Os).
pool3D_layer(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,IWs,Bs,MultiLayerPool,Os0,Os) :-
	is_list(I),
	pool3D_layer(Poolfunc,[[[I|Is0]|Is1]|Is2],PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,IWs,Bs,MultiLayerPool,O),
	append(Os0,[O],Os1),
	pool3D_layer(Poolfunc,Is,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,IWs,Bs,MultiLayerPool,Os1,Os).
pool3D_layer(_,[[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,_,_,_,_,_,_,_,_,_,_,Os,Os) :-
	atomic(I),
	(length([[[[I|Is0]|Is1]|Is2]|Is],LW), 
	W >= LW; 
	length([[[I|Is0]|Is1]|Is2],LX), 
	X >= LX; 
	length([[I|Is0]|Is1],LY), 
	Y >= LY;
	length([I|Is0],LZ), 
	Z >= LZ).
pool3D_layer(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,IWs,Bs,true,Os0,Os) :-
	atomic(I),
	length([[[[I|Is0]|Is1]|Is2]|Is],LW),
	length([[[I|Is0]|Is1]|Is2],LX), 
	length([[I|Is0]|Is1],LY), 
	%length([I|Is0],LZ), 
	W+PoolSizeD1 =< LW,X+PoolSizeD2 =< LX,Y+PoolSizeD3 =< LY,
	get_pool_res3D(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,IWs,Bs,true,O),
	insert_pool_field4D(Os0,O,true,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os1),
	(W+StridesD1+PoolSizeD1 =< LW -> W1 is W + StridesD1, X1 is X, Y1 is Y, Z1 is Z; 
	(X+StridesD2+PoolSizeD2 =< LX -> W1 is 0, X1 is X + StridesD2,Y1 is Y, Z1 is Z; 
	(Y+StridesD3+PoolSizeD3 =< LY -> W1 is 0, X1 is 0,Y1 is Y+StridesD3, Z1 is Z; 
	W1 is 0, X1 is 0, Y1 is 0, Z1 is Z + 1))),
	pool3D_layer(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],W1,X1,Y1,Z1,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,IWs,Bs,true,Os1,Os).
pool3D_layer(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,IWs,Bs,false,Os0,Os) :-
	atomic(I),
	length([[[[I|Is0]|Is1]|Is2]|Is],LW),
	length([[[I|Is0]|Is1]|Is2],LX), 
	length([[I|Is0]|Is1],LY), 
	%length([I|Is0],LZ), 
	W+PoolSizeD1 =< LW,X+PoolSizeD2 =< LX,Y+PoolSizeD3 =< LY,
	get_pool_res3D(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,IWs,Bs,false,O),
	insert_pool_field4D(Os0,O,true,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os1),
	(W+StridesD1+PoolSizeD1 =< LW -> W1 is W + StridesD1, X1 is X, Y1 is Y, Z1 is Z; 
	(X+StridesD2+PoolSizeD2 =< LX -> W1 is 0, X1 is X + StridesD2,Y1 is Y, Z1 is Z; 
	(Y+StridesD3+PoolSizeD3 =< LY -> W1 is 0, X1 is 0,Y1 is Y+StridesD3, Z1 is Z; 
	W1 is LW + 1, X1 is LX +1, Y1 is LY+1, Z1 is Z + 1))),
	pool3D_layer(Poolfunc,[[[[I|Is0]|Is1]|Is2]|Is],W1,X1,Y1,Z1,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,IWs,Bs,false,Os1,Os).



get_pool_res3D(Poolfunc,Is,W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,IWs,Bs,MultiLayerPool,O) :- 
	get_pool_res3D(Poolfunc,Is,W,X,Y,Z,W,X,Y,PoolSizeD1,PoolSizeD2,PoolSizeD3,IWs,Bs,MultiLayerPool, [],O).
get_pool_res3D(Poolfunc,[[[I|_]|_]|_], W,X,Y,Z,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3,_,_,_,[O1|Os],O) :-
	(W1 >= W + PoolSizeD1; X1 >= X + PoolSizeD2;Y1 >= Y + PoolSizeD3;(length(I,LZ), Z >= LZ)),
	atomic(O1),
	remove_non_numbers([O1|Os],Os1),
	call(Poolfunc,Os1,O).
get_pool_res3D(Poolfunc,[I|Is],W,X,Y,Z,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3,IWs,Bs,true,Os0,O) :-
	length([I|Is],LW),
	length(I,LX),
	nth0_4D(W1,X1,Y1,Z,[I|Is],O1),
	append(Os0,[O1],Os1),
	((W1 < W+PoolSizeD1-1, W1< LW-1) -> W2 is W1 +1, X2 is X1,Y2 is Y1;
	((X1 < X+PoolSizeD2-1, X1< LX-1) -> W2 is W, X2 is X1 + 1,Y2 is Y1; 
					    W2 is W, X2 is X,Y2 is Y1+1)),
	get_pool_res3D(Poolfunc,[I|Is], W,X,Y,Z,W2,X2,Y2,PoolSizeD1,PoolSizeD2,PoolSizeD3,IWs,Bs,true, Os1,O).
get_pool_res3D(Poolfunc,[I|Is],W,X,Y,Z,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3,IWs,Bs,false,Os0,O) :-
	WT is W1 - W,
	XT is X1 - X,
	YT is Y1 - Y,
	nth0_4D(WT,XT,YT,Z,IWs,Ws),
	nth0_4D(W1,X1,Y1,Z,[I|Is],O1),
	multiply_each_list_element_with(Ws,O1,O2),
	append(Os0,[O2],Os1),
	((W1 < W+PoolSizeD1-1) -> W2 is W1 +1, X2 is X1,Y2 is Y1, Z1 is Z;
	((X1 < X+PoolSizeD2-1) -> W2 is W, X2 is X1 + 1,Y2 is Y1, Z1 is Z;
	((Y1 < Y+PoolSizeD3-1) -> W2 is W, X2 is X, Y2 is Y1+1, Z1 is Z;
				  W2 is W, X2 is X, Y2 is Y, Z1 is Z +1 ))),
	get_pool_res3D(Poolfunc,[I|Is], W,X,Y,Z1,W2,X2,Y2,PoolSizeD1,PoolSizeD2,PoolSizeD3,IWs,Bs,false, Os1,O).
get_pool_res3D(Poolfunc,[[[I|Is1]|Is2]|Is], W,X,Y,Z,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3,IWs,Bs,_,[O1|Os],OsF) :-
	(W1 >= W + PoolSizeD1; X1 >= X + PoolSizeD2;Y1 >= Y + PoolSizeD3;(length(I,LZ), Z >= LZ)),
	is_list(O1),
	get_pool_res3D(Poolfunc,[[[I|Is1]|Is2]|Is], W,X,Y,Z,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3,IWs,Bs,_,[O1|Os],[],OsF). 
get_pool_res3D(Poolfunc,_, W,X,Y,Z,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3,_,[B|Bs],_,[O1|Os],OsT,OsF) :-
	del_first_items([O1|Os],F,R),
	remove_non_numbers(F,Os1),
	call(Poolfunc,Os1,O),
	N is  O + B,
	append(OsT,[N],OsT1),
	get_pool_res3D(Poolfunc,_, W,X,Y,Z,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3,_,Bs,_,R,OsT1,OsF).
get_pool_res3D(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,[],OsF,OsF).


	
	
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
global_average_pooling1D_layer([[I|Is0]|Is],Os):- atomic(I), length([[I|Is0]|Is],L), average_pooling1D_layer([[I|Is0]|Is],L,[Os]).
global_average_pooling1D_layer([[I|Is0]|Is],Os):- is_list(I), length([I|Is0],L), average_pooling1D_layer([[I|Is0]|Is],L,[Os]).

global_average_pooling2D_layer([[[I|Is0]|Is1]|Is],Os):- atomic(I), length([[[I|Is0]|Is1]|Is],L1), length([[I|Is0]|Is1],L2), average_pooling2D_layer([[[I|Is0]|Is1]|Is],L1,L2,[[Os]]).
global_average_pooling2D_layer([[[I|Is0]|Is1]|Is],Os):- is_list(I), length([[I|Is0]|Is1],L1), length([I|Is0],L2), average_pooling2D_layer([[[I|Is0]|Is1]|Is],L1,L2,[[Os]]).

global_average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],Os):- atomic(I), length([[[[I|Is0]|Is1]|Is2]|Is],L1), length([[[I|Is0]|Is1]|Is2],L2), length([[I|Is0]|Is1],L3), average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],L1,L2,L3,[[[Os]]]).
global_average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],Os):- is_list(I), length([[[I|Is0]|Is1]|Is2],L1), length([[I|Is0]|Is1],L2), length([I|Is0],L3), average_pooling3D_layer([[[[I|Is0]|Is1]|Is2]|Is],L1,L2,L3,[[[Os]]]).


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
global_max_pool1D_layer([[I|Is0]|Is],Os):- atomic(I), length([[I|Is0]|Is],L), max_pool1D_layer([[I|Is0]|Is],L,[Os]).
global_max_pool1D_layer([[I|Is0]|Is],Os):- is_list(I), length([I|Is0],L), max_pool1D_layer([[I|Is0]|Is],L,[Os]).

global_max_pool2D_layer([[[I|Is0]|Is1]|Is],Os):- atomic(I), length([[[I|Is0]|Is1]|Is],L1), length([[I|Is0]|Is1],L2), max_pool2D_layer([[[I|Is0]|Is1]|Is],L1,L2,[[Os]]).
global_max_pool2D_layer([[[I|Is0]|Is1]|Is],Os):- is_list(I), length([[I|Is0]|Is1],L1), length([I|Is0],L2), max_pool2D_layer([[[I|Is0]|Is1]|Is],L1,L2,[[Os]]).

global_max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],Os):- atomic(I), length([[[[I|Is0]|Is1]|Is2]|Is],L1), length([[[I|Is0]|Is1]|Is2],L2), length([[I|Is0]|Is1],L3), max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],L1,L2,L3,[[[Os]]]).
global_max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],Os):- is_list(I), length([[[I|Is0]|Is1]|Is2],L1), length([[I|Is0]|Is1],L2), length([I|Is0],L3), max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],L1,L2,L3,[[[Os]]]).


encapsulate_atoms(Is,Os) :- encapsulate_atoms(Is,[],Os).
encapsulate_atoms([],Os,Os).
encapsulate_atoms([I|Is],Os0,Os) :-
	is_list(I),
	encapsulate_atoms(I,O),
	append(Os0,[O],Os1),
	encapsulate_atoms(Is,Os1,Os).
encapsulate_atoms([I|Is],Os0,Os) :-
	atomic(I),
	append(Os0,[[I]],Os1),
	encapsulate_atoms(Is,Os1,Os).



	
	
%conv1D_layer([[[1],[2],[3],[4]]],1,[[[-0.2462332 ,  0.5441545 , -0.26646703,  0.21214396]],[[-0.18358815,  0.21298283, -0.06799102, -0.50684196]],[[ 0.11723036, -0.4119215 ,  0.14352113,  0.33476758]],[[-0.13191402,  0.47741675, -0.30865103, -0.40099528]]],[[0, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0]],X).
%conv1D_layer([[[1],[2],[3],[4]]],1,[[[-0.30587655,  0.45706058, -0.03339434, -0.71791303]]],[0,0,0,0],X)
%locally_connected1D_layer([[[0.553, 0.468, 0.138, 0.507], [0.451, 0.111, 0.219, 0.581], [0.065, 0.962, 0.31, 0.004]]], 2,[[[0.557, 0.478, 0.794, 0.358], [0.651, 0.422, 0.065, 0.039], [0.964, 0.118, 0.925, 0.377], [0.383, 0.819, 0.896, 0.797], [0.117, 0.095, 0.385, 0.169], [0.099, 0.23, 0.053, 0.193], [0.331, 0.817, 0.988, 0.045], [0.002, 0.57, 0.727, 0.893]], [[0.447, 0.5, 0.628, 0.465], [0.879, 0.696, 0.609, 0.687], [0.348, 0.905, 0.072, 0.739], [0.576, 0.99, 0.658, 0.584], [0.157, 0.154, 0.552, 0.121], [0.091, 0.462, 0.269, 0.664], [0.811, 0.85, 0.168, 0.34], [0.622, 0.261, 0.49, 0.364]]],[[0.984, 1.0, 0.385, 0.872], [0.162, 0.692, 0.173, 0.127]], X).

%locally_connected1D_layer([[[0.764, 0.313, 0.675], [0.631, 0.08, 0.456], [0.42, 0.494, 0.744], [0.498, 0.302, 0.626]]], 3,[[[0.943, 0.378], [0.399, 0.969], [0.76, 0.626], [0.646, 0.601], [0.241, 0.202], [0.859, 0.569], [0.688, 0.341], [0.919, 0.405], [0.895, 0.558]], [[0.828, 0.798], [0.297, 0.687], [0.964, 0.548], [0.115, 0.11], [0.201, 0.271], [0.1, 0.254], [0.411, 0.252], [0.485, 0.23], [0.84, 0.697]]],[[0.93, 0.774], [0.472, 0.496]], 1, true, X).

%conv1D_layer([[[0.218, 0.193, 0.2, 0.642], [0.645, 0.142, 0.726, 0.442], [0.06, 0.276, 0.141, 0.41], [0.712, 0.348, 0.222, 0.156], [0.813, 0.476, 0.298, 0.626], [0.253, 0.138, 0.884, 0.971]]], 5,[[[0.593, 0.167, 0.371, 0.303], [0.91, 0.941, 0.734, 0.959], [0.552, 0.563, 0.995, 0.356], [0.066, 0.176, 0.748, 0.574]], [[0.593, 0.441, 0.092, 0.78], [0.269, 0.256, 0.562, 0.823], [0.958, 0.415, 0.946, 0.399], [0.698, 0.896, 0.375, 0.327]], [[0.531, 0.958, 0.536, 0.141], [0.171, 0.301, 0.13, 0.014], [0.074, 0.39, 0.957, 0.039], [0.048, 0.395, 0.116, 0.005]], [[0.494, 0.374, 0.858, 0.108], [0.722, 0.005, 0.559, 0.491], [0.574, 0.622, 0.151, 0.119], [0.753, 0.335, 0.068, 0.225]], [[0.836, 0.77, 0.469, 0.54], [0.949, 0.291, 0.034, 0.533], [0.471, 0.629, 0.109, 0.161], [0.936, 0.519, 0.373, 1.0]]],[0.508, 0.27, 0.46, 0.173], 1, false, 2, X)