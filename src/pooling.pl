:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-[util].

%Padding is true for 'same', Strides is PoolSize per default
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
	
%([[[[4,3,3],[3,4,3],[1,9,3],[1,9,11]],[[8,2,8],[3,4,9],[3,4,3],[3,4,3]]]],2,3,2,3,false,X).
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
/*	writeln(''),
	write('LX'),
	writeln(LX),
	write('LY'),
	writeln(LY),
	write('LZ'),
	writeln(LZ),
	write('X= '),
	writeln(X1),
	write('Y= '),
	writeln(Y1),
	write('Z= '),
	writeln(Z1),
	writeln(''),
	writeln(''),*/
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
	W > L,
	append(Os0,[[]],Os1),
	fill_field_up_to_index_and_add4D(Is,I,W,X,Y,Z,Os1,Os).
fill_field_up_to_index_and_add4D(_,I,W,X,Y,Z,Os0,Os) :-
	length(Os0,L),
	W =< L,
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
	
	
%max_pool3D_layer([[[[[1]]]]],1,1,1,X).
%max_pool3D_layer([[[[[1]]]]],1,1,1,X).
%max_pool3D_layer([[[[[8,3],[2,4]],[[4,3],[5,6]]],[[[8,3],[2,4]],[[4,3],[5,6]]]]],2,2,2,X).
max_pool3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,Os):- max_pool3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,PoolSizeD1,PoolSizeD2,PoolSizeD3,false,Os).
max_pool3D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os):- max_pool3D_layer(Is,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,[],Os).
max_pool3D_layer([],_,_,_,_,_,_,_,_,_,_,_,Os,Os).
max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os0,Os) :-
	is_list(I),
	max_pool3D_layer([[[I|Is0]|Is1]|Is2],PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,O),
	append(Os0,[O],Os1),
	max_pool3D_layer(Is,0,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os1,Os).
max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,_,_,_,_,_,_,_,Os,Os) :-
	atomic(I),
	%Padding,
	(length([[[[I|Is0]|Is1]|Is2]|Is],LW), 
	W >= LW; 
	length([[[I|Is0]|Is1]|Is2],LX), 
	X >= LX; 
	length([[I|Is0]|Is1],LY), 
	Y >= LY;
	length([I|Is0],LZ), 
	Z >= LZ).
/* max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,_,_,_,_,_,_,_,Os,Os) :-
	atomic(I),
	%Padding,
	writeln("Exit"),
	%writeln(Os),
	length([[[[I|Is0]|Is1]|Is2]|Is],LW),
	length([[[I|Is0]|Is1]|Is2],LX), 
	length([[I|Is0]|Is1],LY), 
	length([I|Is0],LZ), 
	(Z >= LZ;
	W >= LW;
	X >= LX; 
	Y >= LY),
write('LW'),
writeln(LW),
	write('LX'),
	writeln(LX),
	write('LY'),
	writeln(LY),
	write('LZ'),
	writeln(LZ),
		write('W= '),
	writeln(W),
	write('X= '),
	writeln(X),
	write('Y= '),
	writeln(Y),
	write('Z= '),
	writeln(Z),
	writeln(''),
	writeln('').*/
max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os0,Os) :-
	atomic(I),
	not(Padding),
	length([[[[I|Is0]|Is1]|Is2]|Is],LW),
	length([[[I|Is0]|Is1]|Is2],LX), 
	length([[I|Is0]|Is1],LY), 
	length([I|Is0],LZ), 
	W+PoolSizeD1 =< LW,X+PoolSizeD2 =< LX,Y+PoolSizeD3 =< LY,
/*	writeln(''),
	write('LW'),
	writeln(LW),
	write('LX'),
	writeln(LX),
	write('LY'),
	writeln(LY),
	write('LZ'),
	writeln(LZ),
	write('W= '),
	writeln(W),
	write('X= '),
	writeln(X),
	write('Y= '),
	writeln(Y),
	write('Z= '),
	writeln(Z),
	writeln(''),
	writeln(''),*/
	get_pool_max([[[[I|Is0]|Is1]|Is2]|Is],W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,O),
	%writeln(O),
	insert_pool_field4D(Os0,O,W,X,Y,Z,StridesD1,StridesD2,StridesD3,Os1),
	%writeln(Os1),
	%append(Os0,[a],Os1),

	(W+StridesD1+PoolSizeD1 =< LW -> W1 is W + StridesD1, X1 is X, Y1 is Y, Z1 is Z; 
	(X+StridesD2+PoolSizeD2 =< LX -> W1 is 0, X1 is X + StridesD2,Y1 is Y, Z1 is Z; 
	(Y+StridesD3+PoolSizeD3 =< LY -> W1 is 0, X1 is 0,Y1 is Y+StridesD3, Z1 is Z; 
	W1 is 0, X1 is 0, Y1 is 0, Z1 is Z + 1))),
/*	writeln(''),
	write('W= '),
	writeln(W1),
	write('X= '),
	writeln(X1),
	write('Y= '),
	writeln(Y1),
	write('Z= '),
	writeln(Z1),
	writeln(''),
	writeln(''),*/
	max_pool3D_layer([[[[I|Is0]|Is1]|Is2]|Is],W1,X1,Y1,Z1,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,Padding,Os1,Os).
	
nth0_4Dtemp(W,X,Y,Z,Is,Os) :-
	nth0(W,Is,I0s),
	nth0(X,I0s,I1s),
	nth0(Y,I1s,I2s),
	nth0(Z,I2s,Os).
get_pool_max(Is,W,X,Y,Z,PoolSizeD1,PoolSizeD2,PoolSizeD3,O) :- nth0_4Dtemp(W,X,Y,Z,Is,O1), get_pool_max(Is,W,X,Y,Z,W,X,Y,PoolSizeD1,PoolSizeD2,PoolSizeD3, O1,O).
get_pool_max([[[I|Is0]|Is1]|Is],_,_,_,_,W1,X1,Y1,_,_, O,O) :-
	length([[[I|Is0]|Is1]|Is],LW), 
	W1 >= LW;
	length([[I|Is0]|Is1],LX), 
	X1 >= LX;
	length([I|Is0],LY), 
	Y1 >= LY.
get_pool_max(_, W,X,Y,_,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3, O,O) :-
	W1 >= W + PoolSizeD1; X1 >= X + PoolSizeD2;Y1 >= Y + PoolSizeD3.
get_pool_max([I|Is],W,X,Y,Z,W1,X1,Y1,PoolSizeD1,PoolSizeD2,PoolSizeD3,O1,O) :-
	length([I|Is],LW),
	length(I,LX),
	nth0_4Dtemp(W1,X1,Y1,Z,[I|Is],O2),
	(O2 < O1 -> O3 is O1; O3 is O2),
	(W1 < W+PoolSizeD1-1, W1< LW-1 -> W2 is W1 +1, X2 is X1,Y2 is Y1;((X1 < X+PoolSizeD2-1, X1< LX-1) -> W2 is W, X2 is X1 + 1,Y2 is Y1; W2 is W, X2 is X,Y2 is Y1+1)),
	get_pool_max([I|Is], W,X,Y,Z,W2,X2,Y2,PoolSizeD1,PoolSizeD2,PoolSizeD3, O3,O).
	
	
	
	
	
	
	
	
	
	
	
	
	
average_pool1D_layer(Is,PoolSize,Os):- average_pool1D_layer(Is,PoolSize,PoolSize,false,[],Os).
average_pool1D_layer(Is,PoolSize,Strides,Padding,Os):- average_pool1D_layer(Is,PoolSize,Strides,Padding,[],Os).
average_pool1D_layer([],_,_,_,Os,Os).
average_pool1D_layer([[I|Is0]|Is],PoolSize,Strides,Padding,Os0,Os) :-
	is_list(I),
	average_pool1D_layer([I|Is0],PoolSize,Strides,Padding,O),
	append(Os0,[O],Os1),
	average_pool1D_layer(Is,PoolSize,Strides,Padding,Os1,Os).
average_pool1D_layer([[I|Is0]|Is],PoolSize,Strides,Padding,Os0,Os) :-
	atomic(I),
	del_first_items([[I|Is0]|Is],F,R),
	get_average_pools(F,PoolSize,Strides,Padding,O),
	transpose([O],T),
	concatinate_sub_lists(Os0,T,Os1),
	average_pool1D_layer(R,PoolSize,Strides,Padding,Os1,Os).
	
list_sum([Item], Item).
list_sum([Item1,Item2 | Tail], Total) :-
    list_sum([Item1+Item2|Tail], Total).
    
avg( List, Avg ):- 
    list_sum( List, Sum ),
    length( List, Length), 
    (  Length > 0
    -> Avg is Sum / Length
    ;  Avg is 0
    ).

get_average_pools(Is,PoolSize,Strides,Padding,Os) :-get_average_pools(Is,PoolSize,Strides,Padding,[],Os).
get_average_pools([],_,_,_,Os,Os).
get_average_pools(Is,PoolSize,_,Padding,Os,Os) :-
	not(Padding),
	length(Is,N), N < PoolSize.
get_average_pools(Is,PoolSize,Strides,Padding,Os0,Os) :-
	Padding,
	length(Is,N), N < PoolSize,
	avg(Is,A),
	append(Os0,[A],Os1),
	split_at(Strides,Is,_,R),
	get_average_pools(R,PoolSize,Strides,Padding,Os1,Os).
get_average_pools(Is,PoolSize,Strides,Padding,Os0,Os) :-
	length(Is,N), N >= PoolSize,
	split_at(PoolSize,Is,L,_),
	avg(L,A),
	append(Os0,[A],Os1),
	split_at(Strides,Is,_,R),
	get_average_pools(R,PoolSize,Strides,Padding,Os1,Os).
	
	
average_pool2D_layer(Is,PoolSizeD1,PoolSizeD2,Os):- average_pool2D_layer(Is,PoolSizeD1,PoolSizeD2,PoolSizeD1,PoolSizeD2,false,Os).
average_pool2D_layer(Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os):- average_pool2D_layer(Is,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,[],Os).
average_pool2D_layer([],_,_,_,_,_,_,_,_,Os,Os).
average_pool2D_layer([[[I|Is0]|Is1]|Is],0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os0,Os) :-
	is_list(I),
	average_pool2D_layer([[I|Is0]|Is1],PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,O),
	append(Os0,[O],Os1),
	average_pool2D_layer(Is,0,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os1,Os).
average_pool2D_layer([[[I|Is0]|Is1]|Is],X,Y,Z,_,_,_,_,_,Os,Os) :-
	atomic(I),
	%Padding,
	(length([[[I|Is0]|Is1]|Is],LX), 
	X >= LX; 
	length([[I|Is0]|Is1],LY), 
	Y >= LY;
	length([I|Is0],LZ), 
	Z >= LZ).
average_pool2D_layer([[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os0,Os) :-
	atomic(I),
	not(Padding),
	length([[[I|Is0]|Is1]|Is],LX), 
	length([[I|Is0]|Is1],LY), 
	%length([I|Is0],LZ), 
	%X+PoolSizeD1 =< LX,Y+PoolSizeD2 =< LY,
	get_pool_avg([[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,O),
	insert_pool_field(Os0,O,X,Y,Z,StridesD1,StridesD2,Os1),
	(X+StridesD1+PoolSizeD1 =< LX -> X1 is X + StridesD1,Y1 is Y, Z1 is Z; (Y+StridesD2+PoolSizeD2 =< LY -> X1 is 0,Y1 is Y+StridesD2, Z1 is Z; X1 is 0, Y1 is 0, Z1 is Z + 1)),
	average_pool2D_layer([[[I|Is0]|Is1]|Is],X1,Y1,Z1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os1,Os).
average_pool2D_layer([[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os0,Os) :-
	atomic(I),
	Padding,
	length([[[I|Is0]|Is1]|Is],LX), 
	length([[I|Is0]|Is1],LY), 
	%X+PoolSizeD1 > LX,Y+PoolSizeD2 > LY,
	get_pool_avg([[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,O),
	insert_pool_field(Os0,O,X,Y,Z,StridesD1,StridesD2,Os1),
	(X < LX-1 -> X1 is X + StridesD1,Y1 is Y, Z1 is Z; (Y < LY-1 -> X1 is 0,Y1 is Y+StridesD2, Z1 is Z; X1 is 0, Y1 is 0, Z1 is Z + 1)),
	average_pool2D_layer([[[I|Is0]|Is1]|Is],X1,Y1,Z1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os1,Os).
	
get_pool_avg(Is,X,Y,Z,PoolSizeD1,PoolSizeD2,O) :- get_pool_avg(Is,X,Y,Z,X,Y,PoolSizeD1,PoolSizeD2, [],O).
get_pool_avg(_, X,Y,_,X1,Y1,PoolSizeD1,PoolSizeD2, Os,O) :-
	(X1 >= X + PoolSizeD1;Y1 >= Y + PoolSizeD2),
	avg(Os,O).
get_pool_avg(Is,X,Y,Z,X1,Y1,PoolSizeD1,PoolSizeD2,Os0,O) :-
	nth0_3Dtemp(X1,Y1,Z,Is,O1),
	append(Os0,[O1],Os1),
	((X1 < X+PoolSizeD1-1) -> X2 is X1 + 1,Y2 is Y1;X2 is X,Y2 is Y1+1),
	get_pool_avg(Is, X,Y,Z,X2,Y2,PoolSizeD1,PoolSizeD2, Os1,O).