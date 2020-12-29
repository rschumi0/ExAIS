:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-use_module(library(cplint_util)).
:-[util].

%cropping1D_layer([[[1,2],[2,2],[3,3],[4,4]],[[1,2],[2,2],[3,3],[4,4]]],1,1,X).
cropping1D_layer(Is, CroppingT, CroppingB, Os) :- cropping1D_layer(Is, CroppingT, CroppingB, [], Os).
cropping1D_layer([], _,_, Os, Os).
cropping1D_layer([[I|I1s]|Is], CroppingT, CroppingB, Os0, Os) :- 
	not(atomic(I)),
	apply_cropping_top_bottom(CroppingT, CroppingB,[I|I1s], Os1),
	append(Os0,[Os1],Os2),
	cropping1D_layer(Is, CroppingT, CroppingB, Os2, Os).
cropping1D_layer([[I|I1s]|Is], CroppingT, CroppingB, _, Os) :- 
	atomic(I),
	apply_cropping_top_bottom(CroppingT, CroppingB,[[I|I1s]|Is], Os1),
	cropping1D_layer([], CroppingT, CroppingB, Os1, Os).
	
%cropping2D_layer([[[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]],[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]],[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]]],[[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]],[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]],[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]]],[[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]],[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]],[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]]],[[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]],[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]],[[1,2,1,3,3],[2,2,5,1,2],[3,3,5,9,8],[4,4,5,9,8]]]],1,1,1,1,X).
cropping2D_layer(Is, CroppingT, CroppingB,CroppingL, CroppingR, Os) :- cropping2D_layer(Is, CroppingT, CroppingB,CroppingL, CroppingR, [], Os).
cropping2D_layer([], _,_,_,_, Os, Os).
cropping2D_layer([[I|I1s]|Is], CroppingT, CroppingB,CroppingL, CroppingR, Os0, Os) :- 
	not(atomic(I)),
	apply_cropping_top_bottom(CroppingT, CroppingB,[I|I1s], Os1),
	apply_cropping_left_right(CroppingL, CroppingR,Os1, Os2),
	append(Os0,[Os2],Os3),
	cropping2D_layer(Is, CroppingT, CroppingB,CroppingL, CroppingR, Os3, Os).
cropping2D_layer([[I|I1s]|Is], CroppingT, CroppingB,CroppingL, CroppingR, _, Os) :- 
	atomic(I),
	apply_cropping_top_bottom(CroppingT, CroppingB,[[I|I1s]|Is], Os1),
	apply_cropping_left_right(CroppingL, CroppingR,Os1, Os2),
	cropping2D_layer([], CroppingT, CroppingB,CroppingL, CroppingR, Os2, Os).
	
             
%cropping3D_layer([[[[[1,2,1],[2,2,5],[3,3,3]],[[1,2,1],[2,2,5],[3,3,3]],[[1,2,1],[2,2,5],[3,3,3]]],[[[1,2,1],[2,2,5],[3,3,3]],[[1,2,1],[2,2,5],[3,3,3]],[[1,2,1],[2,2,5],[3,3,3]]],[[[1,2,1],[2,2,5],[3,3,3]],[[1,2,1],[2,2,5],[3,3,3]],[[1,2,1],[2,2,5],[3,3,3]]]]],1,1,1,1,1,1,X).
cropping3D_layer(Is, CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, Os) :- cropping3D_layer(Is, CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, [], Os).
cropping3D_layer([], _,_,_,_,_,_, Os, Os).
cropping3D_layer([[[[I|I0s]|I1s]|I2s]|Is], CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, Os0, Os) :- 
	not(atomic(I)),
	printlist(I),
	cropping3D_layer([[[I|I0s]|I1s]|I2s],CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, Os1),
	append(Os0,[Os1],Os2),
	cropping3D_layer(Is, CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, Os2, Os).
cropping3D_layer([[[[I|I0s]|I1s]|I2s]|Is], CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, _, Os) :- 
	atomic(I),
	apply_cropping_top_bottom(CroppingD1L, CroppingD1R,[[[[I|I0s]|I1s]|I2s]|Is], Os1),
	cropping2D_layer(Os1,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, Os2),
	cropping3D_layer([], CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, Os2, Os).

	
apply_cropping_top_bottom(0, 0, Os, Os).
apply_cropping_top_bottom(CroppingT, CroppingB, [O|Os0], Os) :- 
	length([O|Os0], N),
	N =< CroppingT + CroppingB,
	apply_cropping_top_bottom(0,0,[],Os).
apply_cropping_top_bottom(CroppingT, CroppingB, [_|Os0], Os) :- 
	CroppingT > 0,
	CroppingB > 0,
	CroppingT1 is CroppingT - 1,
	CroppingB1 is CroppingB -1,
	list_butlast(Os0,Os1),
	apply_cropping_top_bottom(CroppingT1,CroppingB1, Os1, Os).
apply_cropping_top_bottom(CroppingT, 0, [_|Os0], Os) :- 
	CroppingT1 is CroppingT - 1,
	apply_cropping_top_bottom(CroppingT1, 0, Os0, Os).
apply_cropping_top_bottom(0,CroppingB, Os0, Os) :- 
	list_butlast(Os0,Os1),
	CroppingB1 is CroppingB -1,
	apply_cropping_top_bottom(0,CroppingB1, Os1, Os).
	
	
apply_cropping_left_right(0, 0, Os, Os).
apply_cropping_left_right(CroppingL, CroppingR, [O|_], Os) :- 
	length(O, N),
	N =< CroppingL + CroppingR,
	apply_cropping_left_right(0,0,[],Os).
apply_cropping_left_right(CroppingL, CroppingR, Os0, Os) :- 
	CroppingL > 0,
	CroppingR > 0,
	CroppingL1 is CroppingL - 1,
	CroppingR1 is CroppingR -1,
	del_first_items(Os0,_,Os1),
	del_last_items(Os1,Os2),
	apply_cropping_left_right(CroppingL1,CroppingR1, Os2, Os).
apply_cropping_left_right(CroppingL, 0, Os0, Os) :- 
	CroppingL1 is CroppingL - 1,
	del_first_items(Os0,_,Os1),
	apply_cropping_left_right(CroppingL1, 0, Os1, Os).
apply_cropping_left_right(0,CroppingR, Os0, Os) :- 
	CroppingR1 is CroppingR -1,
	del_last_items(Os0,Os1),
	apply_cropping_left_right(0,CroppingR1, Os1, Os).



zero_padding1D_layer(Is,N,Os)	 :- padding1D(Is,0,N,N,Os).
zero_padding1D_layer(Is,L,R,Os) :- padding1D(Is,0,L,R,Os).
/*zero_padding1D([[I|I0s]|Is],N,Os) :- atomic(I), zero_padding1D([[I|I0s]|Is],N,[[I|I0s]|Is],Os).
zero_padding1D([[I|I0s]|Is],N,Os) :- is_list(I), zero_padding1D([[I|I0s]|Is],N,[],Os).
zero_padding1D([],_,Os,Os).
zero_padding1D([[I|I0s]|Is],N,Os1,Os) :- 
	is_list(I),
	zero_padding1D([I|I0s],N,O),
	append(Os1,[O],Os2),
	zero_padding1D(Is,N,Os2,Os).
zero_padding1D(_,0,Os,Os).
zero_padding1D([[I|I0s]|Is],N,Os1,Os) :-
	atomic(I),
	N1 is N - 1,
	length([I|I0s],L),
	empty_list(L,O),
	append(Os1,[O],Os2),
	zero_padding1D([[I|I0s]|Is],N1,[O|Os2],Os).*/
	
depth([],1).
depth([H|T],R) :- atomic(H),!, depth(T,R).
depth([H|T],R):- depth(H,R1), depth(T,R2), R3 is R1+1, R is max(R3,R2).

	
padding1D([[I|I0s]|Is],PadSym,LeftP,RightP,Os) :- atomic(I), padding1D([[I|I0s]|Is],PadSym,LeftP,RightP,[[I|I0s]|Is],Os).
padding1D([[I|I0s]|Is],PadSym,LeftP,RightP,Os) :- is_list(I), padding1D([[I|I0s]|Is],PadSym,LeftP,RightP,[],Os).
padding1D([],_,_,_,Os,Os).
padding1D([[I|I0s]|Is],PadSym,LeftP,RightP,Os1,Os) :- 
	is_list(I),
	padding1D([I|I0s],PadSym,LeftP,RightP,O),
	append(Os1,[O],Os2),
	padding1D(Is,PadSym,LeftP,RightP,Os2,Os).
padding1D(_,_,0,0,Os,Os).
padding1D([[I|I0s]|Is],PadSym,LeftP,RightP,Os1,Os) :-
	atomic(I),
	LeftP > 0,
	LeftP1 is LeftP - 1,
	length([I|I0s],L),
	empty_list(PadSym,L,O),
	padding1D([[I|I0s]|Is],PadSym,LeftP1,RightP,[O|Os1],Os).
padding1D([[I|I0s]|Is],PadSym,LeftP,RightP,Os1,Os) :-
	atomic(I),
	RightP > 0,
	RightP1 is RightP - 1,
	length([I|I0s],L),
	empty_list(PadSym,L,O),
	append(Os1,[O],Os2),
	padding1D([[I|I0s]|Is],PadSym,LeftP,RightP1,Os2,Os).



%zero_padding2D_layer([[[[1,2],[3,4]],[[1,2],[3,4]]]],1,X).
%zero_padding2D_layer([[[[1,2],[3,4]],[[1,2],[3,4]]],[[[1,2],[3,4]],[[1,2],[3,4]]]],1,X).
zero_padding2D_layer(Is,N,Os) :- padding2D(Is,0,N,N,N,N,Os).
zero_padding2D_layer(Is,D1,D2,Os) :- padding2D(Is,0,D1,D1,D2,D2,Os).
zero_padding2D_layer(Is,LeftPD1,RightPD1,LeftPD2,RightPD2,Os) :- padding2D(Is,0,LeftPD1,RightPD1,LeftPD2,RightPD2,Os).

	
padding2D([[[I|I0s]|I1s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,Os) :- atomic(I), padding1D([[[I|I0s]|I1s]|Is],PadSym,LeftPD2,RightPD2,Os1), padding2D(Os1,PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,Os1,Os).
padding2D([[[I|I0s]|I1s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,Os) :- is_list(I), padding2D([[[I|I0s]|I1s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,[],Os).
padding2D([],_,_,_,_,_,Os,Os).
padding2D([[[I|I0s]|I1s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,Os1,Os) :-
	is_list(I),
	padding2D([[I|I0s]|I1s],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,O),
	append(Os1,[O],Os2),
	padding2D(Is,PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,Os2,Os).
padding2D(_,_,0,0,_,_,Os,Os).
padding2D([[[I|I0s]|I1s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,Os1,Os) :-
	atomic(I),
	LeftPD1 >0,
	LeftPD11 is LeftPD1 - 1,
	length([I|I0s],LY),
	length([[I|I0s]|I1s],LX),
	empty_field2D(PadSym,LX,LY,O),
	padding2D([[[I|I0s]|I1s]|Is],PadSym,LeftPD11,RightPD1,LeftPD2,RightPD2,[O|Os1],Os).
padding2D([[[I|I0s]|I1s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,Os1,Os) :-
	atomic(I),
	RightPD1 >0,
	RightPD11 is RightPD1 - 1,
	length([I|I0s],LY),
	length([[I|I0s]|I1s],LX),
	empty_field2D(PadSym,LX,LY,O),
	append(Os1,[O],Os2),
	padding2D([[[I|I0s]|I1s]|Is],PadSym,LeftPD1,RightPD11,LeftPD2,RightPD2,Os2,Os).
	
	

	
%zero_padding3D_layer([[[[[1,2],[3,4]],[[1,2],[3,4]]],[[[1,2],[3,4]],[[1,2],[3,4]]]]],1,X).
zero_padding3D_layer(Is,N,Os) :- padding3D(Is,0,N,N,N,N,N,N,Os).
zero_padding3D_layer(Is,D1,D2,D3,Os) :- padding3D(Is,0,D1,D1,D2,D2,D3,D3,Os).
zero_padding3D_layer(Is,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os) :- padding3D(Is,0,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os).
/*zero_padding3D([I|Is],N,Os) :- length([I|Is],L), L == 1, zero_padding2D(I,N,Os1), zero_padding3D(Os1,N,Os1,Os).
zero_padding3D(Is,N,Os) :- length(Is,L), L > 1, zero_padding3D(Is,N,[],Os).
zero_padding3D([],_,Os,Os).
zero_padding3D([[[[I|I0s]|I1s]|I2s]|Is],N,Os1,Os) :-
	is_list(I),
	zero_padding3D([[[I|I0s]|I1s]|I2s],N,O),
	append(Os1,[O],Os2),
	zero_padding3D(Is,N,Os2,Os).
zero_padding3D(_,0,Os,Os).
zero_padding3D([[[[I|I0s]|I1s]|I2s]|Is],N,Os1,Os) :-
	atomic(I),
	N1 is N - 1,
	length([I|I0s],LX),
	length([[I|I0s]|I1s],LY),
	length([[[I|I0s]|I1s]|I2s],LZ),
	empty_field(LX,LY,LZ,O),
	append(Os1,[O],Os2),
	zero_padding3D([[[[I|I0s]|I1s]|I2s]|Is],N1,[O|Os2],Os).*/
	
	
padding3D([[[[I|I0s]|I1s]|I2s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os) :- 
	%length([I|Is],L), L == 1, 
	atomic(I),
	padding2D([[[[I|I0s]|I1s]|I2s]|Is],PadSym,LeftPD2,RightPD2,LeftPD3,RightPD3,Os1), 
	padding3D(Os1,PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os1,Os).
padding3D([[[[I|I0s]|I1s]|I2s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os) :-
	is_list(I), 
	%length(Is,L), L > 1, 
	padding3D([[[[I|I0s]|I1s]|I2s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,[],Os).
padding3D([],_,_,_,_,_,_,_,Os,Os).
padding3D([[[[I|I0s]|I1s]|I2s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os1,Os) :-
	is_list(I),
	padding3D([[[I|I0s]|I1s]|I2s],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,O),
	append(Os1,[O],Os2),
	padding3D(Is,PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os2,Os).
padding3D(_,_,0,0,_,_,_,_,Os,Os).
padding3D([[[[I|I0s]|I1s]|I2s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os1,Os) :-
	atomic(I),
	LeftPD1 >0,
	LeftPD11 is LeftPD1 - 1,
	length([I|I0s],LZ),
	length([[I|I0s]|I1s],LY),
	length([[[I|I0s]|I1s]|I2s],LX),
	empty_field3D(PadSym,LX,LY,LZ,O),
	padding3D([[[[I|I0s]|I1s]|I2s]|Is],PadSym,LeftPD11,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,[O|Os1],Os).
padding3D([[[[I|I0s]|I1s]|I2s]|Is],PadSym,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os1,Os) :-
	atomic(I),
	RightPD1 >0,
	RightPD11 is RightPD1 - 1,
	length([I|I0s],LZ),
	length([[I|I0s]|I1s],LY),
	length([[[I|I0s]|I1s]|I2s],LX),
	empty_field3D(PadSym,LX,LY,LZ,O),
	append(Os1,[O],Os2),
	padding3D([[[[I|I0s]|I1s]|I2s]|Is],PadSym,LeftPD1,RightPD11,LeftPD2,RightPD2,LeftPD3,RightPD3,Os2,Os).
	
up_sampling1D_layer(Is, Size, Os) :- up_sampling1D_layer(Is, Size, [], Os).
up_sampling1D_layer([], _, Os,Os).
up_sampling1D_layer([[I|Is0]|Is], Size, Os0,Os):-
	is_list(I),
	up_sampling1D_layer([I|Is0],Size,O),
	append(Os0,[O],Os1),
	up_sampling1D_layer(Is,Size,Os1,Os).
up_sampling1D_layer([[I|Is0]|Is], Size, _,Os):-
	atomic(I),
	multiply_entries([[I|Is0]|Is],Size,Os1),
	up_sampling1D_layer([],Size,Os1,Os).



%multiply_entries([a,b,c],2,X).
multiply_entries(Is,N,Os) :- multiply_entries(Is,N,[],Os).
multiply_entries([],_,Os,Os).
multiply_entries([I|Is],N,Os0,Os) :-
	multiply_element(I,N,O),
	append(Os0,O,Os1),
	multiply_entries(Is,N,Os1,Os). 
	
	
multiply_element(_,0,[]).
multiply_element(X,N,[X|Ys]):-
	N1 is N -1,
	multiply_element(X,N1,Ys).
	
	
up_sampling2D_layer(Is, SizeD1, SizeD2, Os) :- up_sampling2D_layer(Is, SizeD1, SizeD2, [], Os).
up_sampling2D_layer([], _, _, Os,Os).
up_sampling2D_layer([[[I|Is0]|Is1]|Is], SizeD1, SizeD2, Os0,Os):-
	is_list(I),
	up_sampling2D_layer([[I|Is0]|Is1],SizeD1, SizeD2,O),
	append(Os0,[O],Os1),
	up_sampling2D_layer(Is,SizeD1,SizeD2,Os1,Os).
up_sampling2D_layer([[[I|Is0]|Is1]|Is], SizeD1, SizeD2, _,Os):-
	atomic(I),
	SizeD1 > 0,
	multiply_entries([[[I|Is0]|Is1]|Is],SizeD1,Os1),
	up_sampling2D_layer(Os1,0, SizeD2,[],Os).
up_sampling2D_layer([[[I|Is0]|Is1]|Is], 0, SizeD2, Os0,Os):-
	atomic(I),
	up_sampling1D_layer([[I|Is0]|Is1],SizeD2,O),
	append(Os0,[O],Os1),
	up_sampling2D_layer(Is,0, SizeD2,Os1,Os).
	
up_sampling3D_layer(Is, SizeD1, SizeD2, SizeD3, Os) :- up_sampling3D_layer(Is, SizeD1, SizeD2, SizeD3, [], Os).
up_sampling3D_layer([], _, _,_, Os,Os).
up_sampling3D_layer([[[[I|I0s]|I1s]|I2s]|Is], SizeD1, SizeD2, SizeD3, Os0,Os):-
	is_list(I),
	up_sampling3D_layer([[[I|I0s]|I1s]|I2s],SizeD1, SizeD2, SizeD3,O),
	append(Os0,[O],Os1),
	up_sampling3D_layer(Is,SizeD1,SizeD2, SizeD3,Os1,Os).
up_sampling3D_layer([[[[I|I0s]|I1s]|I2s]|Is], SizeD1, SizeD2, SizeD3, _,Os):-
	atomic(I),
	SizeD2 > 0,
	up_sampling2D_layer([[[[I|I0s]|I1s]|I2s]|Is],SizeD2,SizeD3,Os1),
	up_sampling3D_layer(Os1,SizeD1, 0, 0,[],Os).
up_sampling3D_layer([[[[I|I0s]|I1s]|I2s]|Is], SizeD1, 0, 0, _,Os):-
	atomic(I),
	%multiply_sub_entries([[[I|I0s]|I1s]|I2s],SizeD1,O),
	%append(Os0,[O],Os1),
	%up_sampling3D_layer(Is,SizeD1, 0, 0,Os1,Os).
	multiply_entries([[[[I|I0s]|I1s]|I2s]|Is],SizeD1,Os1),
	up_sampling3D_layer([],0, 0, 0,Os1,Os).

/*
-------------------------------------------------------------------------------------
Prolog Script:
-------------------------------------------------------------------------------------
up_sampling3D_layer([[[[[0.5987], [0.4397]]]]], 2, 2, 1, X)
-------------------------------------------------------------------------------------
in[[[[0.5987],[0.4397]]]]out[[[[0.5987],[0.5987],[0.4397],[0.4397]],[[0.5987],[0.5987],[0.4397],[0.4397]]]]X = [[[[[0.5987], [0.5987], [0.4397], [0.4397]], [[0.5987], [0.5987], [0.4397], [0.4397]]]]] X = [[[[[0.5987], [0.5987], [0.4397], [0.4397]], [[0.5987], [0.5987], [0.4397], [0.4397]]]]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[[0.5987], [0.4397]], [[0.5987], [0.4397]]], [[[0.5987], [0.4397]], [[0.5987], [0.4397]]]]]
Expected (Unparsed): [[[[[0.5987], [0.5987], [0.4397], [0.4397]], [[0.5987], [0.5987], [0.4397], [0.4397]]]]]
-------------------------------------------------------------------------------------
Actual:   [[[[[0.5987], [0.4397]], [[0.5987], [0.4397]]], [[[0.5987], [0.4397]], [[0.5987], [0.4397]]]]]
Expected: [[[[[0.5987], [0.5987], [0.4397], [0.4397]], [[0.5987], [0.5987], [0.4397], [0.4397]]]]]
-------------------------------------------------------------------------------------

Test 3 failed!*/
	
	
multiply_sub_entries(Is,N,Os) :- multiply_sub_entries(Is,N,[],Os).
multiply_sub_entries([],_,Os,Os).
multiply_sub_entries([I|Is],N,Os0,Os) :-
	multiply_entries(I,N,O),
	append(Os0,[O],Os1),
	multiply_sub_entries(Is,N,Os1,Os). 


embedding_layer(Is,Ws,Os) :- embedding_layer(Is,Ws,[],Os).
embedding_layer([],_,Os,Os).
embedding_layer([I|Is],Ws,Os0,Os) :- 
	is_list(I),
	embedding_layer(I,Ws,O),
	append(Os0,[O],Os1),
	embedding_layer(Is,Ws,Os1,Os).
embedding_layer([I|Is],Ws,Os0,Os) :- 
	atomic(I),
	I1 is floor(I),
	nth0(I1,Ws,O),
	append(Os0,[O],Os1),
	embedding_layer(Is,Ws,Os1,Os).
	
	
repeat_vector_layer(Is,N,[Os]) :- multiply_entries(Is,N,Os).


permute_layer(Is,D1,D2,Os) :- permute_layer(Is,D1,D2,[],Os).
permute_layer([],_,_,Os,Os).
permute_layer([[I|Is1]|Is],D1,D2,Os0,Os) :- 
 	is_list(I),
 	permute_layer([I|Is1],D1,D2,O),
 	append(Os0,[O],Os1),
 	permute_layer(Is,D1,D2,Os1,Os).
permute_layer([[I|Is1]|Is],1,2,_,Os) :-
	atomic(I),
	permute_layer([],1,2,[[I|Is1]|Is],Os).
permute_layer([[I|Is1]|Is],2,1,_,Os) :-
	atomic(I),
	transpose([[I|Is1]|Is],Os1),
	permute_layer([],2,1,Os1,Os).
	
reshape_layer(Is,Ss,[Os]) :-
	depth(Is,1),
	recursive_split(Ss,Is,Os).
reshape_layer(Is,Ss,Os) :-
	depth(Is,D),
	D > 1,
	flatten(Is,Is1),
	reshape_layer(Is1,Ss,Os).

%recursive_split([3,3],[1,2,3,4,5,6,7,8,9],X).
%recursive_split([],Is,Is).

recursive_split([S|Ss],Is,Is) :-length([S|Ss],L), L = 1.
recursive_split([S|Ss],Is,Os) :-length([S|Ss],L), L = 2, split_in_parts(S,Is,Os).
recursive_split([S|Ss],Is,Os) :-length([S|Ss],L), L > 2, split_in_parts(S,Is,Os0), recursive_split(Ss,Os0,[],Os).
%recursive_split([],_,Os,Os).
recursive_split(_,[],Os,Os).
recursive_split([S|Ss],[I|Is],Os0,Os) :-
	%length([S|Ss],L),
	%L > 1,
	recursive_split([S|Ss],I,O),
	%split_in_parts(S,I,O),
	append(Os0,[O],Os2),
	recursive_split([S|Ss],Is,Os2,Os).
/*recursive_split(_,[],[],Os,Os).
recursive_split([S|Ss],[],Os,_,Os) :-
	length([S|Ss],L),
	L < 3.
recursive_split([S|Ss],[],[O|Os0],Os1,Os) :-
	length([S|Ss],L),
	L > 2,
	recursive_split(Ss,O,O1),
	append(Os1,[O1],Os2),
	recursive_split([S|Ss],[],Os0,Os2,Os).*/
	
split_in_parts(P,Is,Os) :- length(Is,L), S is L / P, split_in_parts(P,Is,S,[],Os).	
split_in_parts(_,[],_,Os,Os).
split_in_parts(P,Is,S,Os0,Os) :-
	Is \== [],
	split_at(S,Is,I1,Rs),
	append(Os0,[I1],Os1),
	split_in_parts(P,Rs,S,Os1,Os).
	


%variance([],0).
%variance([H|T], M, VO):-
%    variance(T,M,Y),
%    VO is( Y + ((H-M)*(H-M))).

layer_normalization_layer([],_,_,[]).
layer_normalization_layer([I|Is], Axis, Epsilon, [O|Os]) :-
	variance(I,V),
	avg(I,M),
	VE is V + Epsilon,
	sqrt(VE,Div),
	subtract_from_each_list_element(I,M,O0),
	divide_each_list_element_by(O0,Div,O),
	layer_normalization_layer(Is, Axis, Epsilon, Os).
	

    