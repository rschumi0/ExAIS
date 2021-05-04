:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-use_module(library(cplint_util)).
:-[util].

%cropping1D_layer([[[1,2],[2,2],[3,3],[4,4]],[[1,2],[2,2],[3,3],[4,4]]],1,1,X).
cropping1D_layer(Is, CroppingT, CroppingB, Os) :- check_dimensions(Is,3), cropping1D_layer(Is, CroppingT, CroppingB, [], Os).
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
cropping2D_layer(Is, CroppingT, CroppingB,CroppingL, CroppingR, Os) :- check_dimensions(Is,4),cropping2D_layer(Is, CroppingT, CroppingB,CroppingL, CroppingR, [], Os).
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
cropping3D_layer(Is, CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, Os) :- check_dimensions(Is,5), cropping3D_layer(Is, CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, [], Os).
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



zero_padding1D_layer(Is,N,Os)	 :- check_dimensions(Is,3), padding1D(Is,0,N,N,Os).
zero_padding1D_layer(Is,L,R,Os) :- check_dimensions(Is,3), padding1D(Is,0,L,R,Os).
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
zero_padding2D_layer(Is,N,Os) :- check_dimensions(Is,4), padding2D(Is,0,N,N,N,N,Os).
zero_padding2D_layer(Is,D1,D2,Os) :- check_dimensions(Is,4), padding2D(Is,0,D1,D1,D2,D2,Os).
zero_padding2D_layer(Is,LeftPD1,RightPD1,LeftPD2,RightPD2,Os) :- check_dimensions(Is,4), padding2D(Is,0,LeftPD1,RightPD1,LeftPD2,RightPD2,Os).

	
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
zero_padding3D_layer(Is,N,Os) :- check_dimensions(Is,5), padding3D(Is,0,N,N,N,N,N,N,Os).
zero_padding3D_layer(Is,D1,D2,D3,Os) :- check_dimensions(Is,5), padding3D(Is,0,D1,D1,D2,D2,D3,D3,Os).
zero_padding3D_layer(Is,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os) :- check_dimensions(Is,5), padding3D(Is,0,LeftPD1,RightPD1,LeftPD2,RightPD2,LeftPD3,RightPD3,Os).
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
	
up_sampling1D_layer(Is, Size, Os) :- check_dimensions(Is,3), up_sampling1D_layer(Is, Size, [], Os).
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
	
	
up_sampling2D_layer(Is, SizeD1, SizeD2, Os) :- check_dimensions(Is,4), up_sampling2D_layer(Is, SizeD1, SizeD2, [], Os).
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
	
up_sampling3D_layer(Is, SizeD1, SizeD2, SizeD3, Os) :- check_dimensions(Is,5), up_sampling3D_layer(Is, SizeD1, SizeD2, SizeD3, [], Os).
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
	



layer_normalization_layer([],_,_,[]).
layer_normalization_layer([I|Is], Axis, Epsilon, [O|Os]) :-
	depth([I|Is], 2),	
	variance(I,V),
	avg(I,M),
	VE is V + Epsilon,
	sqrt(VE,Div),
	subtract_from_each_list_element(I,M,O0),
	divide_each_list_element_by(O0,Div,O),
	layer_normalization_layer(Is, Axis, Epsilon, Os).
layer_normalization_layer([I|Is], Axis, Epsilon, [O|Os]) :-
	depth([I|Is], 3),
	Axis == 1,
	transpose(I,I1),
	layer_normalization_layer(I1,Axis,Epsilon,O1),
	transpose(O1,O),
	layer_normalization_layer(Is, Axis, Epsilon, Os).
layer_normalization_layer([I|Is], Axis, Epsilon, [O|Os]) :-
	depth([I|Is], 3),
	Axis == 2,
	layer_normalization_layer(I,Axis,Epsilon,O),
	layer_normalization_layer(Is, Axis, Epsilon, Os).
layer_normalization_layer([I|Is], Axis, Epsilon, [O|Os]) :-
	depth([I|Is], 4),
	Axis > 1,
	Axis1 is Axis -1,
	layer_normalization_layer(I,Axis1,Epsilon,O),
	layer_normalization_layer(Is, Axis, Epsilon, Os).
layer_normalization_layer([I|Is], Axis, Epsilon, [O|Os]) :-
	depth([I|Is], 4),
	Axis == 1,
	transpose(I,I1),
	layer_normalization_layer(I1,Axis,Epsilon,O1),
	transpose(O1,O),
	layer_normalization_layer(Is, Axis, Epsilon, Os).
	
	
	
%batch_normalization_layer([[1,2,3]],1,0.001,[0,0,0],[1,1,1],[0,0,0],[1,1,1],X).
batch_normalization_layer([],_,_,_,_,_,_,[]).
batch_normalization_layer([I|Is], Axis, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, [O|Os]) :-
	batch_normalization(I, Axis, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, O),
	batch_normalization_layer(Is, Axis, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, Os).
batch_normalization([],_,_,_,_,_,_,[]).
batch_normalization([I|Is], Axis, Epsilon, [G|Gammas], [B|Betas], [M|MovingMeans], [V|MovingVariances], [O|Os]) :-
	Axis == 1,
	apply_batch_normalization(I, Epsilon, G, B,M,V,O),
	batch_normalization(Is, Axis, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, Os).
batch_normalization([I|Is], Axis, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, [O|Os]) :-
	Axis == 2,
	batch_normalization(I, 1, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, O),
	batch_normalization(Is, Axis, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, Os).
batch_normalization([I|Is], Axis, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, [O|Os]) :-
	Axis == 3,
	batch_normalization(I, 2, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, O),
	batch_normalization(Is, Axis, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, Os).
	

apply_batch_normalization([],_,_,_,_,_,[]). 
apply_batch_normalization([I|Is],Epsilon, G, B,M,V,[O|Os]) :-
	apply_batch_normalization(I, Epsilon, G, B,M,V,O),
	apply_batch_normalization(Is, Epsilon, G, B,M,V,Os).
apply_batch_normalization(I,Epsilon, G, B,M,V,O) :-
	number(I),
	X is (I - M)/(sqrt(V + Epsilon)), 
	O is G * X + B.
	
	
all_x([], _).
all_x([H|T],X) :-
    H == X,
    all_x(T,X).

masking_layer([],_,[]).
masking_layer([I|Is], MaskValue, [O|Os]):- 
	is_list(I),
	masking_layer(I,MaskValue,O),
	masking_layer(Is,MaskValue,Os).
masking_layer([I|Is], MaskValue, Os):-  
	atomic(I),   
	all_x([I|Is],MaskValue),        
    	replace_all([I|Is], 0, Os).
masking_layer([I|Is], MaskValue, [I|Is]):-  
	atomic(I),
	not(all_x([I|Is],MaskValue)).
	
time_distributed_layer([],_, []).	
time_distributed_layer([I|Is], Layer, [O|Os]) :-
	call(Layer,I,O),
	time_distributed_layer(Is, Layer, Os).
	
time_distributed_layer(_,[] ,_, []).	
time_distributed_layer([I|Is], Layer, A1, [O|Os]) :-
	call(Layer,I, A1, O),
	time_distributed_layer(Is, Layer, A1, Os).
	
time_distributed_layer([],_, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, [O|Os]) :-
	call(Layer,I, A1, A2, O),
	time_distributed_layer(Is, Layer, A1, A2, Os).
	
time_distributed_layer([],_, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, [O|Os]) :-
	call(Layer,I, A1, A2, A3, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, Os).
	
time_distributed_layer([],_, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, Os).
	
time_distributed_layer([],_, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, Os).
	
time_distributed_layer([],_, _, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, A6, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, A6, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, A6, Os).
	
time_distributed_layer([],_, _, _, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, A6, A7, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, A6, A7, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, A6, A7, Os).
	
time_distributed_layer([],_, _, _, _, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, A6, A7, A8, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, A6, A7, A8, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, A6, A7, A8, Os).
	
time_distributed_layer([],_, _, _, _, _, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, A6, A7, A8, A9, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, Os).
	
time_distributed_layer([],_, _, _, _, _, _, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, Os).
		
time_distributed_layer([],_, _, _, _, _, _, _, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, Os).
	
time_distributed_layer([],_, _, _, _, _, _, _, _, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, Os).
	
time_distributed_layer([],_, _, _, _, _, _, _, _, _, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, Os).
	
time_distributed_layer([],_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, Os).

time_distributed_layer([],_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, []).	
time_distributed_layer([I|Is], Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, [O|Os]) :-
	call(Layer,I, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, O),
	time_distributed_layer(Is, Layer, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, Os).
	
    /*
    time_distributed_layer(conv2D_layer,[[[[[0.5949]], [[0.2165]]]]], 1, 1,[[[[1]]]],[0], 2, 1, false, 1, 1, X)
-------------------------------------------------------------------------------------
X = [[[[[0.5949]]]]] X = [[[[[0.5949]]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:523:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[[-0.3640345]]]]]
Expected (Unparsed): [[[[[0.5949]]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:523:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[[-0.364]]]]]
Expected: [[[[[0.5949]]]]] */


innner_transpose([],[]).
innner_transpose([I|Is],[O|Os]) :-
	maplist(transpose,I,O),
	innner_transpose(Is,Os).

	
/*
softmax_layer([],_,[]).
softmax_layer(Is,-1,Os) :-
	softmax_layer(Is,Os).
%TODO strange behaviour for axis = 0
softmax_layer(Is,0,Os) :-
	replace_all(Is, 1,Os).
softmax_layer(Is,1,Os) :-
	depth(Is,3),
	maplist(transpose,Is,Is1),
	softmax_layer(Is1,Os1),
	maplist(transpose,Os1,Os).
softmax_layer(Is,1,Os) :-
	depth(Is,4),
	maplist(transpose,Is,IsT),
	innner_transpose(IsT,Is1),
	softmax_layer(Is1,Os1),
	innner_transpose(Os1,OsT),
	maplist(transpose,OsT,Os).
softmax_layer([I|Is],Axis,[O|Os]) :-
	Axis1 is Axis -1,
	softmax_layer(I,Axis1,O),
	softmax_layer(Is,Axis,Os).
*/


concatenate_layer(Is,0,Is).% :-
	%concatenate_lists(Is,Os).

concatenate_layer(Is,1,[Os]) :-
	maplist(transpose,Is,Is1),
	concatenate_layer(Is1,0,Os1),
	maplist(transpose,Os1,Os2),
	remove_inner_nesting(Os2,Os).

concatenate_layer(Is,2,[Os]) :-
	transpose(Is,Is1),
	concatenate_layer(Is1,0,Os1),
	maplist(remove_inner_nesting,Os1,Os).
concatenate_layer(Is,3,[Os]) :-
	transpose(Is,IsT),
	map_transpose(IsT,Is1),
	concatenate_layer(Is1,0,Os1),
	maplist(remove_inner_inner_nesting,Os1,Os).
	%innner_transpose(Os1,OsT),
	%maplist(map_transpose,Os1,Os).
	%maplist(remove_inner_nesting,Os1,Os).


	
	
remove_inner_inner_nesting(Is,Os) :-
	maplist(remove_inner_nesting,Is, Os).
remove_inner_nesting(Is,Os) :- remove_inner_nesting(Is,[],Os).
remove_inner_nesting([],Os,Os).
remove_inner_nesting([I|Is],Os0, Os) :-
	append(Os0,I,Os1),
	remove_inner_nesting(Is,Os1,Os).

/*	
concatenate_layer([I|Is],Axis,[O|Os]) :-
	Axis1 is Axis -1,
	concatenate_layer(I,Axis1,O),
	concatenate_layer(Is,Axis,Os).

concatenate_layer([[[[0.2388, 0.5628], [0.4056, 0.9396]], [[0.9617, 0.0576], [0.4156, 0.4144]]], [[[0.9361, 0.002], [0.2037, 0.974]], [[0.4572, 0.9538], [0.9977, 0.9201]]]], 3, X)
-------------------------------------------------------------------------------------
X = [[[[[0.2388, 0.5628], [0.4056, 0.9396]], [[0.9361, 0.002], [0.2037, 0.974]]], [[[0.9617, 0.0576], [0.4156, 0.4144]], [[0.4572, 0.9538], [0.9977, 0.9201]]]]] X = [[[[[0.2388, 0.5628], [0.4056, 0.9396]], [[0.9361, 0.002], [0.2037, 0.974]]], [[[0.9617, 0.0576], [0.4156, 0.4144]], [[0.4572, 0.9538], [0.9977, 0.9201]]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/activation.pl:64:Warning:    Redefined static procedure innner_transpose/2Warning:    Previously defined at /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl:596Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:556:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.2388000, 0.5628000, 0.9361000, 0.0020000], [0.4056000, 0.9396000, 0.2037000, 0.9740000]], [[0.9617000, 0.0576000, 0.4572000, 0.9538000], [0.4156000, 0.4144000, 0.9977000, 0.9201000]]]]
Expected (Unparsed): [[[[[0.2388, 0.5628], [0.4056, 0.9396]], [[0.9361, 0.002], [0.2037, 0.974]]], [[[0.9617, 0.0576], [0.4156, 0.4144]], [[0.4572, 0.9538], [0.9977, 0.9201]]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/activation.pl:64:Warning: Redefined static procedure innner_transpose/2Warning: Previously defined at /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl:596Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:556:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[0.2388, 0.5628, 0.9361, 0.002], [0.4056, 0.9396, 0.2037, 0.974]], [[0.9617, 0.0576, 0.4572, 0.9538], [0.4156, 0.4144, 0.9977, 0.9201]]]]
Expected: [[[[[0.2388, 0.5628], [0.4056, 0.9396]], [[0.9361, 0.002], [0.2037, 0.974]]], [[[0.9617, 0.0576], [0.4156, 0.4144]], [[0.4572, 0.9538], [0.9977, 0.9201]]]]]
*/
/*
concatenate_lists([],[]).
concatenate_lists(Is,Is) :- length(Is,1).
concatenate_lists([I1,I2|Is],Os) :-
	concatenate_lists(I1,I2,IT),
	concatenate_lists([IT|Is],Os).
concatenate_lists([I1,I2],Os) :-
	concatenate_lists(I1,I2,Os).
concatenate_lists(I1,I2,[I1,I2]).*/



test_exception(Name,T) :-
	catch(T, E, (writeln(Name), writeln(E), writeln("asfdasdf"),abort)),
	%writeln(X),
	writeln("done").
	




	
/*	
test123(Out,Y) :-
	L1 = thresholded_relu_layer([1,2,3,0.4,0.6],0.5,X),
	catch(L1, E, (writeln(Name), writeln(E), writeln("asfdasdf"),abort)),
	L2 = thresholded_relu_layer(X,0.5,Y),
	test_exception("thresholded_relu_layer",L2),
	catch(L2, E, (writeln(Name), writeln(E), writeln("asfdasdf"),abort)),
	writeln(Out).

	
test5(Out) :-
	L1 = thresholded_relu_layer([1,2,3,0.4,0.6],0.5,X),
	L2 = thresholded_relu_layer(X,0.5,Y),
	execLayers([L1,L2],["Lasdf","Lwer"],Y,"Y").
*/

exec_layers([],[],_,_).
exec_layers([L|Layers],[N|LayerNames],OutVar, OutVarName) :-
	catch(call_with_time_limit(10,L), E, (write("Aborted at "), write(N), write(": "), write(E), writeln("!!!"),abort)),
	write("Layer "), write(N),writeln(" executed successfully"),
	(length(Layers,0) -> write(OutVarName), write(" = "), writeln(OutVar);true),
	exec_layers(Layers,LayerNames,OutVar, OutVarName).

check_dimensions(Is, D) :-
	depth(Is,D1), 
	(D1 =\= D -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D,BV1 is BV*10, writeln(BV1),  
		    throw("Dimension error"));true).
		    
		    
check_same_dimensions(I1,I2) :-
	depth(I1,D1),
	depth(I2,D),
	(D1 =\= D -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D,BV1 is BV*10, writeln(BV1),  
		    throw("Inconsistent Input Dimensions"));true).
	
check_same_shape(I1,I2) :-
	check_same_dimensions(I1,I2),
	(not(compare_structure(I1,I2)) -> (write("Invalid Model, Badness Value: "), 
		    		 	   compute_different_shape_badness(I1,I2,B),
		    			   writeln(B),  
		    			   throw("Inconsistent Input Shapes"));true).	
check_same_shape(I1,I2,I3) :-
	check_same_shape(I1,I2),
	check_same_shape(I2,I3).
	
check_same_shape([]).
check_same_shape(Is) :- length(Is,1).
check_same_shape([I1,I2|Is]) :-
	check_same_shape(I1,I2),
	check_same_shape([I2|Is]).
	
	
compute_different_shape_badness(I1,I2, Badness) :-
 	depth(I1,1),
 	length(I1,L1),
 	length(I2,L2),
 	Badness is abs(L1-L2).
 	
compute_different_shape_badness([I1|Is1],[I2|Is2], Badness) :-
 	depth([I1|Is1],D),
 	D>=2,
 	length(Is1,L1),
 	length(Is2,L2),
 	pow(10,D-1,Factor),
 	compute_different_shape_badness(I1,I2,InnerBadness),
 	Badness is Factor*abs(L1-L2) + InnerBadness.	
	
	


	
%LMax22036 = maximum_layer([[[[0.5569, 0.134], [0.5071, 0.0128]], [[0.9252, 0.9474], [0.9312, 0.0105]]], [[[0.7936, 0.7922], [0.5587, 0.4919]], [[0.5949, 0.8723], [0.97, 0.251]]]], Max22036), 
%LAve50954 = average_layer([[[[0.4029, 0.524], [0.2112, 0.9831]], [[0.0687, 0.4765], [0.5959, 0.1895]]], [[[0.9714, 0.2605], [0.1184, 0.6947]], [[0.9785, 0.4338], [0.1493, 0.1083]]], [[[0.3312, 0.1356], [0.7549, 0.234]], [[0.7122, 0.0159], [0.4776, 0.4945]]]], Ave50954), 
%LAdd90342 = add_layer([Ave50954,Max22036], [Add90342]), 
%exec_layers([LMax22036,LAve50954,LAdd90342],["LAdd90342","LAve50954","LMax22036"],Add90342,"Add90342").

check_pool_input_match(_, _, true).
check_pool_input_match(Is,PoolSize, false) :-
	sub_length(Is,D1),
	(D1 < PoolSize -> (write("Invalid Model, Badness Value: "), 
		    	   BV is D1-PoolSize, writeln(BV),   
		           throw("Shape Error"));true).	

check_pool_input_match(_, _, _, true).
check_pool_input_match(Is,PoolSizeD1, PoolSizeD2, false) :-
	sub_length(Is,D1),
	(D1 < PoolSizeD1 -> (write("Invalid Model, Badness Value: "), 
			     BV1 is D1-PoolSizeD1, writeln(BV1),   
	    		     throw("Shape Error"));true),
	sub_sub_length(Is,D2),
	(D2 < PoolSizeD2 -> (write("Invalid Model, Badness Value: "), 
	    		     BV2 is D2-PoolSizeD2, writeln(BV2),   
	                     throw("Shape Error"));true).
	                     
check_pool_input_match(_, _, _, _, true).
check_pool_input_match(Is,PoolSizeD1, PoolSizeD2, PoolSizeD3, false) :-
	sub_length(Is,D1),
	(D1 < PoolSizeD1 -> (write("Invalid Model, Badness Value: "), 
			     BV1 is D1-PoolSizeD1, writeln(BV1),   
	    		     throw("Shape Error"));true),
	sub_sub_length(Is,D2),
	(D2 < PoolSizeD2 -> (write("Invalid Model, Badness Value: "), 
	    		     BV2 is D2-PoolSizeD2, writeln(BV2),   
	                     throw("Shape Error"));true),
	sub_sub_sub_length(Is,D3),
	(D3 < PoolSizeD3 -> (write("Invalid Model, Badness Value: "), 
	    		     BV3 is D3-PoolSizeD3, writeln(BV3),   
	                     throw("Shape Error"));true).	                     
	                     
