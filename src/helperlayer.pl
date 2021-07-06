:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-use_module(library(cplint_util)).
:-[util].

flatten_layer([],[]).
flatten_layer([I|Is],[O|Os]) :-
	flatten(I,O),
	flatten_layer(Is,Os).


%cropping1D_layer([[[1,2],[2,2],[3,3],[4,4]],[[1,2],[2,2],[3,3],[4,4]]],1,1,X).
cropping1D_layer(Is, CroppingT, CroppingB, Os) :- 
	check_dimensions(Is,3), 
	cropping1D_layer(Is, CroppingT, CroppingB, [], Os),
	check_empty_cropping(Is,Os).
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
cropping2D_layer(Is, CroppingT, CroppingB,CroppingL, CroppingR, Os) :- 
	check_dimensions(Is,4),
	cropping2D_layer(Is, CroppingT, CroppingB,CroppingL, CroppingR, [], Os),
	check_empty_cropping(Is,Os).
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
cropping3D_layer(Is, CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, Os) :- 
	check_dimensions(Is,5), 
	cropping3D_layer(Is, CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, [], Os),
	check_empty_cropping(Is,Os).
cropping3D_layer([], _,_,_,_,_,_, Os, Os).
cropping3D_layer([[[[I|I0s]|I1s]|I2s]|Is], CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, Os0, Os) :- 
	not(atomic(I)),
	%printlist(I),
	cropping3D_layer([[[I|I0s]|I1s]|I2s],CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, [], Os1),
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
	up_sampling1D_layer([I|Is0],Size,[],O),
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
	up_sampling2D_layer([[I|Is0]|Is1],SizeD1, SizeD2,[],O),
	append(Os0,[O],Os1),
	up_sampling2D_layer(Is,SizeD1,SizeD2,Os1,Os).
up_sampling2D_layer([[[I|Is0]|Is1]|Is], SizeD1, SizeD2, _,Os):-
	atomic(I),
	SizeD1 > 0,
	multiply_entries([[[I|Is0]|Is1]|Is],SizeD1,Os1),
	up_sampling2D_layer(Os1,0, SizeD2,[],Os).
up_sampling2D_layer([[[I|Is0]|Is1]|Is], 0, SizeD2, Os0,Os):-
	atomic(I),
	up_sampling1D_layer([[I|Is0]|Is1],SizeD2,[],O),
	append(Os0,[O],Os1),
	up_sampling2D_layer(Is,0, SizeD2,Os1,Os).
	
up_sampling3D_layer(Is, SizeD1, SizeD2, SizeD3, Os) :- check_dimensions(Is,5), up_sampling3D_layer(Is, SizeD1, SizeD2, SizeD3, [], Os).
up_sampling3D_layer([], _, _,_, Os,Os).
up_sampling3D_layer([[[[I|I0s]|I1s]|I2s]|Is], SizeD1, SizeD2, SizeD3, Os0,Os):-
	is_list(I),
	up_sampling3D_layer([[[I|I0s]|I1s]|I2s],SizeD1, SizeD2, SizeD3,[],O),
	append(Os0,[O],Os1),
	up_sampling3D_layer(Is,SizeD1,SizeD2, SizeD3,Os1,Os).
up_sampling3D_layer([[[[I|I0s]|I1s]|I2s]|Is], SizeD1, SizeD2, SizeD3, _,Os):-
	atomic(I),
	SizeD2 > 0,
	up_sampling2D_layer([[[[I|I0s]|I1s]|I2s]|Is],SizeD2,SizeD3,[],Os1),
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


embedding_layer(Is,Ws,Os) :- check_max_dimensions(Is,2), embedding_layer(Is,Ws,[],Os).
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
	
	
repeat_vector_layer(Is,N,[Os]) :- 
check_max_dimensions(Is,3),
multiply_entries(Is,N,Os).


permute_layer(Is,D1,D2,Os) :- 
	check_dimensions(Is,3), %TODO report valid dims
	permute_layer(Is,D1,D2,[],Os).
permute_layer([],_,_,Os,Os).
permute_layer([[I|Is1]|Is],D1,D2,Os0,Os) :- 
 	is_list(I),
 	permute_layer([I|Is1],D1,D2, [],O),
 	append(Os0,[O],Os1),
 	permute_layer(Is,D1,D2,Os1,Os).
permute_layer([[I|Is1]|Is],1,2,_,Os) :-
	atomic(I),
	permute_layer([],1,2,[[I|Is1]|Is],Os).
permute_layer([[I|Is1]|Is],2,1,_,Os) :-
	atomic(I),
	transpose([[I|Is1]|Is],Os1),
	permute_layer([],2,1,Os1,Os).
	
reshape_layer(Is,Ss,Os) :-
	depth(Is,1),
	recursive_split(Ss,Is,Os).
reshape_layer(Is,Ss,Os) :-
	check_valid_reshape(Is,Ss),
	depth(Is,D),
	D > 1,
	shape(Is,Shape),
	list_product(Shape,PIn),
	list_product(Ss,POut),
	flatten(Is,Is1),
	((PIn > POut)-> ((0 is mod(PIn,POut)) -> AddS is PIn // POut,reshape_layer(Is1,[AddS|Ss],Os);
			(writeln("Invalid Model, Badness Value: 1000000000"),
			 S1 = "Reshape Error, Input Shape ",
		         shape(Is,ShapeT),
		         term_string(ShapeT,S2),
		         string_concat(S1,S2,S),
			 throw(S)));
			((PIn < POut) -> (writeln("Invalid Model, Badness Value: 1000000000"),
			 S1 = "Reshape Error, Input Shape ",
		         shape(Is,ShapeT),
		         term_string(ShapeT,S2),
		         string_concat(S1,S2,S),
			 throw(S)); 
			(reshape_layer(Is1,Ss,OsT),pack_list(OsT,Os)))).
	%0 is mod(PIn,POut)

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
	
split_in_parts(P,Is,Os) :- 
	length(Is,L), 
	S is L / P, 
	split_in_parts(P,Is,S,[],Os).	
split_in_parts(_,[],_,Os,Os).
split_in_parts(P,Is,S,Os0,Os) :-
	Is \== [],
	split_at(S,Is,I1,Rs),
	append(Os0,[I1],Os1),
	split_in_parts(P,Rs,S,Os1,Os).
	
layer_normalization_layer(Is, Axis, Epsilon, Os) :-
	depth(Is,D),
	check_smaller_arguments(Is,Axis,D),
	layer_normalization(Is, Axis, Epsilon, Os).

layer_normalization([],_,_,[]).
layer_normalization([I|Is], Axis, Epsilon, [O|Os]) :-
	depth([I|Is], 2),	
	variance(I,V),
	avg(I,M),
	VE is V + Epsilon,
	sqrt(VE,Div),
	subtract_from_each_list_element(I,M,O0),
	divide_each_list_element_by(O0,Div,O),
	layer_normalization(Is, Axis, Epsilon, Os).
	
layer_normalization([I|Is], Axis, Epsilon, [O|Os]) :-
	%depth([I|Is], 3),
	depth([I|Is], D),
	D > 2,
	Axis == 1,
	transpose(I,I1),
	layer_normalization(I1,Axis,Epsilon,O1),
	transpose(O1,O),
	layer_normalization(Is, Axis, Epsilon, Os).
layer_normalization([I|Is], Axis, Epsilon, [O|Os]) :-
	depth([I|Is], 3),
	Axis == 2,
	layer_normalization(I,Axis,Epsilon,O),
	layer_normalization(Is, Axis, Epsilon, Os).
/*	
layer_normalization([I|Is], Axis, Epsilon, [O|Os]) :-
	depth([I|Is], 4),
	Axis == 1,
	transpose(I,I1),
	layer_normalization(I1,Axis,Epsilon,O1),
	transpose(O1,O),
	layer_normalization(Is, Axis, Epsilon, Os).*/
layer_normalization([I|Is], Axis, Epsilon, [O|Os]) :-
	%depth([I|Is], 4),
	depth([I|Is], D),
	D > 3,
	Axis > 1,
	Axis1 is Axis -1,
	layer_normalization(I,Axis1,Epsilon,O),
	layer_normalization(Is, Axis, Epsilon, Os).

	
calc_batch_normalization_param_shape(Is, Axis, [L]) :-
	shape(Is,S),
	nth0(Axis,S,L).
	
%batch_normalization_layer([[1,2,3]],1,0.001,[0,0,0],[1,1,1],[0,0,0],[1,1,1],X).
batch_normalization_layer([],_,_,_,_,_,_,[]).
batch_normalization_layer([I|Is], Axis, Epsilon, Gammas, Betas, MovingMeans, MovingVariances, [O|Os]) :-
	depth([I|Is],D),
	check_smaller_arguments([I|Is],Axis,D),
	calc_batch_normalization_param_shape([I|Is],Axis,Shape1),
	shape(Gammas,Shape2),
	check_valid_weight_shape([I|Is],Shape1,Shape2), 
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

concatenate_layer([[[[0.1961, 0.9416], [0.3303, 0.4419]]], [[[0.5051, 0.0706], [0.7356, 0.8823]]]], 0, X)
-------------------------------------------------------------------------------------
X = [[[[[0.1961, 0.9416], [0.3303, 0.4419]], [[0.5051, 0.0706], [0.7356, 0.8823]]]]] X = [[[[[0.1961, 0.9416], [0.3303, 0.4419]], [[0.5051, 0.0706], [0.7356, 0.8823]]]]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.1961000, 0.9416000], [0.3303000, 0.4419000]]], [[[0.5051000, 0.0706000], [0.7356000, 0.8823000]]]]
Expected (Unparsed): [[[[[0.1961, 0.9416], [0.3303, 0.4419]], [[0.5051, 0.0706], [0.7356, 0.8823]]]]]
-------------------------------------------------------------------------------------
	 [[[[[[0.1961, 0.9416], [0.3303, 0.4419]]], [[[0.5051, 0.0706], [0.7356, 0.8823]]]]]]
	 [[[[[0.1961, 0.9416], [0.3303, 0.4419]]], [[[0.5051, 0.0706], [0.7356, 0.8823]]]]]
	  [[[[0.1961, 0.9416], [0.3303, 0.4419]]], [[[0.5051, 0.0706], [0.7356, 0.8823]]]]
Actual:   [[[[0.1961, 0.9416], [0.3303, 0.4419]]], [[[0.5051, 0.0706], [0.7356, 0.8823]]]]
Expected: [[[[[0.1961, 0.9416], [0.3303, 0.4419]], [[0.5051, 0.0706], [0.7356, 0.8823]]]]]


concatenate_layer([[[[[0.7734, 0.0299], [0.5645, 0.5694]], [[0.0535, 0.1463], [0.0439, 0.3316]]]], [[[[0.8666, 0.7745], [0.0097, 0.1752]], [[0.6369, 0.1433], [0.8595, 0.3364]]]]], 1, X)
-------------------------------------------------------------------------------------
X = [[[[0.7734, 0.0299], [0.5645, 0.5694]]], [[[0.8666, 0.7745], [0.0097, 0.1752]]]] X = [[[[0.7734, 0.0299], [0.5645, 0.5694]]], [[[0.8666, 0.7745], [0.0097, 0.1752]]]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[[0.7734000, 0.0299000], [0.5645000, 0.5694000]], [[0.0535000, 0.1463000], [0.0439000, 0.3316000]]], [[[0.8666000, 0.7745000], [0.0097000, 0.1752000]], [[0.6369000, 0.1433000], [0.8595000, 0.3364000]]]]]
Expected (Unparsed): [[[[0.7734, 0.0299], [0.5645, 0.5694]]], [[[0.8666, 0.7745], [0.0097, 0.1752]]]]
-------------------------------------------------------------------------------------
	   [[[[0.7734, 0.0299], [0.5645, 0.5694]], [[0.8666, 0.7745], [0.0097, 0.1752]]]]
[[[[[0.7734, 0.0299], [0.5645, 0.5694]], [[0.0535, 0.1463], [0.0439, 0.3316]]], [[[0.8666, 0.7745], [0.0097, 0.1752]], [[0.6369, 0.1433], [0.8595, 0.3364]]]]]
X = 	 [[[[[[0.7734, 0.0299], [0.5645, 0.5694]], [[0.0535, 0.1463], [0.0439, 0.3316]]], [[[0.8666, 0.7745], [0.0097, 0.1752]], [[0.6369, 0.1433], [0.8595, 0.3364]]]]]]
           [[[[0.7734, 0.0299], [0.5645, 0.5694]], [[0.0535, 0.1463], [0.0439, 0.3316]]], [[[0.8666, 0.7745], [0.0097, 0.1752]], [[0.6369, 0.1433], [0.8595, 0.3364]]]]
          [[[[[0.7734, 0.0299], [0.5645, 0.5694]], [[0.0535, 0.1463], [0.0439, 0.3316]]], [[[0.8666, 0.7745], [0.0097, 0.1752]], [[0.6369, 0.1433], [0.8595, 0.3364]]]]]
Actual:   [[[[[0.7734, 0.0299], [0.5645, 0.5694]], [[0.0535, 0.1463], [0.0439, 0.3316]]], [[[0.8666, 0.7745], [0.0097, 0.1752]], [[0.6369, 0.1433], [0.8595, 0.3364]]]]]
Expected: [[[[0.7734, 0.0299], [0.5645, 0.5694]]], [[[0.8666, 0.7745], [0.0097, 0.1752]]]]
*/


temp_layer_con(X,A,B,C,D,A2,B2,C2,D2,E2,Zs) :-
	(A = true; A = false),
	(B = true; B = false),
	(C = true; C = false),
	(D = true; D = false),
	%(E = true; E = false),
	%(E1 = true; E1 = false),
	(A2 = true; A2 = false),
	(B2 = true; B2 = false),
	(C2 = true; C2 = false),
	(D2 = true; D2 = false),
	(E2 = true; E2 = false),
	%keep(X,X0),
	del_first_items(X,X0,_),
	
	(A -> transpose(X0,X1);keep(X0,X1)),
	(B -> map_transpose(X1,X2);keep(X1,X2)),
	(C -> map_map_transpose(X2,X3);keep(X2,X3)),
	(D -> map_transpose(X3,X4);keep(X3,X4)),
	%(E -> transpose(X4,X5);keep(X4,X5)),
	
	concatenate(X4,0,Z),
	(A2 -> transpose(Z,Z1);keep(Z,Z1)),
	(B2 -> map_transpose(Z1,Z2);keep(Z1,Z2)),
	(C2 -> map_map_transpose(Z2,Z3);keep(Z2,Z3)),
	(D2 -> map_transpose(Z3,Z4);keep(Z3,Z4)),
	(E2 -> transpose(Z4,Zs);keep(Z4,Zs)).

/*
concatenate_layer([[[[[0.3747, 0.4272], [0.0248, 0.2095]], [[0.4037, 0.0458], [0.6292, 0.7836]]]], [[[[0.2045, 0.2952], [0.8904, 0.5486]], [[0.0843, 0.2293], [0.9772, 0.873]]]]], 0, X)
-------------------------------------------------------------------------------------
X = [[[[[0.3747, 0.4272], [0.0248, 0.2095]], [[0.4037, 0.0458], [0.6292, 0.7836]]]], [[[[0.2045, 0.2952], [0.8904, 0.5486]], [[0.0843, 0.2293], [0.9772, 0.873]]]]] X = [[[[[0.3747, 0.4272], [0.0248, 0.2095]], [[0.4037, 0.0458], [0.6292, 0.7836]]]], [[[[0.2045, 0.2952], [0.8904, 0.5486]], [[0.0843, 0.2293], [0.9772, 0.873]]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/math.pl:582:Warning:    Redefined static procedure pack_list/2Warning:    Previously defined at /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl:652

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.3747000, 0.4272000], [0.0248000, 0.2095000]], [[0.4037000, 0.0458000], [0.6292000, 0.7836000]]], [[[0.2045000, 0.2952000], [0.8904000, 0.5486000]], [[0.0843000, 0.2293000], [0.9772000, 0.8730000]]]]
Expected (Unparsed): [[[[[0.3747, 0.4272], [0.0248, 0.2095]], [[0.4037, 0.0458], [0.6292, 0.7836]]]], [[[[0.2045, 0.2952], [0.8904, 0.5486]], [[0.0843, 0.2293], [0.9772, 0.873]]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/math.pl:582:Warning: Redefined static procedure pack_list/2Warning: Previously defined at /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl:652
-------------------------------------------------------------------------------------
          [[[[0.3747, 0.4272], [0.0248, 0.2095]], [[0.4037, 0.0458], [0.6292, 0.7836]]], [[[0.2045, 0.2952], [0.8904, 0.5486]], [[0.0843, 0.2293], [0.9772, 0.873]]]]
Actual:   [[[[0.3747, 0.4272], [0.0248, 0.2095]], [[0.4037, 0.0458], [0.6292, 0.7836]]], [[[0.2045, 0.2952], [0.8904, 0.5486]], [[0.0843, 0.2293], [0.9772, 0.873]]]]
Expected: [[[[[0.3747, 0.4272], [0.0248, 0.2095]], [[0.4037, 0.0458], [0.6292, 0.7836]]]], [[[[0.2045, 0.2952], [0.8904, 0.5486]], [[0.0843, 0.2293], [0.9772, 0.873]]]]]

concatenate_layer([[[[[0.766, 0.3542], [0.7203, 0.4083]], [[0.8496, 0.5699], [0.1306, 0.1573]]]], [[[[0.2784, 0.395], [0.5468, 0.7413]], [[0.3611, 0.6774], [0.5618, 0.8086]]]]], 1, X)
-------------------------------------------------------------------------------------
X = [[[[[0.766, 0.3542], [0.7203, 0.4083]], [[0.8496, 0.5699], [0.1306, 0.1573]]], [[[0.2784, 0.395], [0.5468, 0.7413]], [[0.3611, 0.6774], [0.5618, 0.8086]]]]] X = [[[[[0.766, 0.3542], [0.7203, 0.4083]], [[0.8496, 0.5699], [0.1306, 0.1573]]], [[[0.2784, 0.395], [0.5468, 0.7413]], [[0.3611, 0.6774], [0.5618, 0.8086]]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/math.pl:582:Warning:    Redefined static procedure pack_list/2Warning:    Previously defined at /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl:652

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.7660000, 0.3542000], [0.7203000, 0.4083000]], [[0.8496000, 0.5699000], [0.1306000, 0.1573000]], [[0.2784000, 0.3950000], [0.5468000, 0.7413000]], [[0.3611000, 0.6774000], [0.5618000, 0.8086000]]]]
Expected (Unparsed): [[[[[0.766, 0.3542], [0.7203, 0.4083]], [[0.8496, 0.5699], [0.1306, 0.1573]]], [[[0.2784, 0.395], [0.5468, 0.7413]], [[0.3611, 0.6774], [0.5618, 0.8086]]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/math.pl:582:Warning: Redefined static procedure pack_list/2Warning: Previously defined at /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl:652
-------------------------------------------------------------------------------------
          [[[[0.766, 0.3542], [0.7203, 0.4083]], [[0.8496, 0.5699], [0.1306, 0.1573]], [[0.2784, 0.395], [0.5468, 0.7413]], [[0.3611, 0.6774], [0.5618, 0.8086]]]]
Actual:   [[[[0.766, 0.3542], [0.7203, 0.4083]], [[0.8496, 0.5699], [0.1306, 0.1573]], [[0.2784, 0.395], [0.5468, 0.7413]], [[0.3611, 0.6774], [0.5618, 0.8086]]]]
Expected: [[[[[0.766, 0.3542], [0.7203, 0.4083]], [[0.8496, 0.5699], [0.1306, 0.1573]]], [[[0.2784, 0.395], [0.5468, 0.7413]], [[0.3611, 0.6774], [0.5618, 0.8086]]]]]

concatenate_layer([[[[[[0.9521, 0.369], [0.6516, 0.8806]], [[0.3956, 0.1372], [0.5964, 0.5806]]]], [[[[0.3988, 0.1688], [0.8602, 0.0703]], [[0.1648, 0.4908], [0.7639, 0.514]]]]], [[[[[0.812, 0.8494], [0.7677, 0.5054]], [[0.9957, 0.0137], [0.9772, 0.7882]]]], [[[[0.7879, 0.1554], [0.7077, 0.2006]], [[0.6858, 0.7554], [0.3063, 0.0468]]]]]], 0, X)
-------------------------------------------------------------------------------------
Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/math.pl:582:Warning:    Redefined static procedure pack_list/2Warning:    Previously defined at /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl:652ERROR: Out of global-stack.ERROR: No room for exception term.  Aborting.Could not reenable global-stackCould not reenable global-stackCould not reenable global-stackERROR: Unknown procedure: w/0 (DWIM could not correct goal)

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[[0.9521000, 0.3690000], [0.6516000, 0.8806000]], [[0.3956000, 0.1372000], [0.5964000, 0.5806000]]]], [[[[0.3988000, 0.1688000], [0.8602000, 0.0703000]], [[0.1648000, 0.4908000], [0.7639000, 0.5140000]]]], [[[[0.8120000, 0.8494000], [0.7677000, 0.5054000]], [[0.9957000, 0.0137000], [0.9772000, 0.7882000]]]], [[[[0.7879000, 0.1554000], [0.7077000, 0.2006000]], [[0.6858000, 0.7554000], [0.3063000, 0.0468000]]]]]
Expected (Unparsed): Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/math.pl:582:Warning: Redefined static procedure pack_list/2Warning: Previously defined at /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl:652ERROR: Out of global-stack.ERROR: No room for exception term. Aborting.Could not reenable global-stackCould not reenable global-stackCould not reenable global-stackERROR: Unknown procedure: w/0 (DWIM could not correct goal)
Invalid list input!!!-------------------------------------------------------------------------------------
[[[[[[0.9521, 0.369], [0.6516, 0.8806]], [[0.3956, 0.1372], [0.5964, 0.5806]]]], [[[[0.812, 0.8494], [0.7677, 0.5054]], [[0.9957, 0.0137], [0.9772, 0.7882]]]]], [[[[[0.3988, 0.1688], [0.8602, 0.0703]], [[0.1648, 0.4908], [0.7639, 0.514]]]], [[[[0.7879, 0.1554], [0.7077, 0.2006]], [[0.6858, 0.7554], [0.3063, 0.0468]]]]]]          
[[[[[0.9521, 0.369], [0.6516, 0.8806]], [[0.3956, 0.1372], [0.5964, 0.5806]]]], [[[[0.812, 0.8494], [0.7677, 0.5054]], [[0.9957, 0.0137], [0.9772, 0.7882]]]]], [[[[[0.3988, 0.1688], [0.8602, 0.0703]], [[0.1648, 0.4908], [0.7639, 0.514]]]], [[[[0.7879, 0.1554], [0.7077, 0.2006]], [[0.6858, 0.7554], [0.3063, 0.0468]]]]]]
          [[[[[0.9521, 0.369], [0.6516, 0.8806]], [[0.3956, 0.1372], [0.5964, 0.5806]]]], [[[[0.812, 0.8494], [0.7677, 0.5054]], [[0.9957, 0.0137], [0.9772, 0.7882]]]], [[[[0.3988, 0.1688], [0.8602, 0.0703]], [[0.1648, 0.4908], [0.7639, 0.514]]]], [[[[0.7879, 0.1554], [0.7077, 0.2006]], [[0.6858, 0.7554], [0.3063, 0.0468]]]]]	
Actual:   [[[[[0.9521, 0.369], [0.6516, 0.8806]], [[0.3956, 0.1372], [0.5964, 0.5806]]]], [[[[0.3988, 0.1688], [0.8602, 0.0703]], [[0.1648, 0.4908], [0.7639, 0.514]]]], [[[[0.812, 0.8494], [0.7677, 0.5054]], [[0.9957, 0.0137], [0.9772, 0.7882]]]], [[[[0.7879, 0.1554], [0.7077, 0.2006]], [[0.6858, 0.7554], [0.3063, 0.0468]]]]]
Expected: 

concatenate_layer([[[[[[[0.624]], [[0.565]]], [[[0.0348]], [[0.1211]]]]], [[[[[0.2062]], [[0.0497]]], [[[0.6407]], [[0.6423]]]]]], [[[[[[0.3603]], [[0.3698]]], [[[0.7759]], [[0.0109]]]]], [[[[[0.4994]], [[0.4754]]], [[[0.7044]], [[0.3293]]]]]]], 0, X)
-------------------------------------------------------------------------------------
X = [[[[[[0.624]], [[0.565]]], [[[0.0348]], [[0.1211]]]]], [[[[[0.3603]], [[0.3698]]], [[[0.7759]], [[0.0109]]]]], [[[[[0.2062]], [[0.0497]]], [[[0.6407]], [[...]]]]], [[[[[0.4994]], [[...]]], [[[...]], [...]]]]] X = [[[[[[0.624]], [[0.565]]], [[[0.0348]], [[0.1211]]]]], [[[[[0.3603]], [[0.3698]]], [[[0.7759]], [[0.0109]]]]], [[[[[0.2062]], [[0.0497]]], [[[0.6407]], [[0.6423]]]]], [[[[[0.4994]], [[0.4754]]], [[[0.7044]], [[0.3293]]]]]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[[[0.6240000]], [[0.5650000]]], [[[0.0348000]], [[0.1211000]]]]], [[[[[0.2062000]], [[0.0497000]]], [[[0.6407000]], [[0.6423000]]]]], [[[[[0.3603000]], [[0.3698000]]], [[[0.7759000]], [[0.0109000]]]]], [[[[[0.4994000]], [[0.4754000]]], [[[0.7044000]], [[0.3293000]]]]]]
Expected (Unparsed): [[[[[[0.624]], [[0.565]]], [[[0.0348]], [[0.1211]]]]], [[[[[0.3603]], [[0.3698]]], [[[0.7759]], [[0.0109]]]]], [[[[[0.2062]], [[0.0497]]], [[[0.6407]], [[0.6423]]]]], [[[[[0.4994]], [[0.4754]]], [[[0.7044]], [[0.3293]]]]]]
-------------------------------------------------------------------------------------
Actual:   [[[[[[0.624]], [[0.565]]], [[[0.0348]], [[0.1211]]]]], [[[[[0.2062]], [[0.0497]]], [[[0.6407]], [[0.6423]]]]], [[[[[0.3603]], [[0.3698]]], [[[0.7759]], [[0.0109]]]]], [[[[[0.4994]], [[0.4754]]], [[[0.7044]], [[0.3293]]]]]]
Expected: [[[[[[0.624]], [[0.565]]], [[[0.0348]], [[0.1211]]]]], [[[[[0.3603]], [[0.3698]]], [[[0.7759]], [[0.0109]]]]], [[[[[0.2062]], [[0.0497]]], [[[0.6407]], [[0.6423]]]]], [[[[[0.4994]], [[0.4754]]], [[[0.7044]], [[0.3293]]]]]]


-------------------------------------------------------------------------------------
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import numpy as np
np.set_printoptions(suppress=True,threshold=np.inf,formatter={'float_kind':'{:16.7f}'.format})
tf.keras.backend.set_floatx('float64')
input0 = tf.keras.layers.Input(shape=([1, 2]))
input1 = tf.keras.layers.Input(shape=([1, 2]))
func = keras.layers.Concatenate(axis=0, )([input0,input1])
model = tf.keras.models.Model(inputs=[input0,input1], outputs=func)
input0 = tf.constant([[[0.0242, 0.8086]], [[0.9331, 0.0734]]])
input1 = tf.constant([[[0.4256, 0.0702]], [[0.0895, 0.217]]])
print (np.array2string(model.predict([input0,input1],steps=1), separator=', '))


concatenate_layer([[[[0.0242, 0.8086]], [[0.9331, 0.0734]]], [[[0.4256, 0.0702]], [[0.0895, 0.217]]]], 0, X)
-------------------------------------------------------------------------------------
X = [[[0.0242, 0.8086]], [[0.4256, 0.0702]], [[0.9331, 0.0734]], [[0.0895, 0.217]]] X = [[[0.0242, 0.8086]], [[0.4256, 0.0702]], [[0.9331, 0.0734]], [[0.0895, 0.217]]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[0.0242000, 0.8086000]], [[0.9331000, 0.0734000]], [[0.4256000, 0.0702000]], [[0.0895000, 0.2170000]]]
Expected (Unparsed): [[[0.0242, 0.8086]], [[0.4256, 0.0702]], [[0.9331, 0.0734]], [[0.0895, 0.217]]]
-------------------------------------------------------------------------------------
Actual:   [[[0.0242, 0.8086]], [[0.9331, 0.0734]], [[0.4256, 0.0702]], [[0.0895, 0.217]]]
Expected: [[[0.0242, 0.8086]], [[0.4256, 0.0702]], [[0.9331, 0.0734]], [[0.0895, 0.217]]]


concatenate_layer([[[[[[[0.0724], [0.5743]]], [[[0.874], [0.7279]]]], [[[[0.7218], [0.2726]]], [[[0.356], [0.7116]]]]], [[[[[0.9283], [0.9371]]], [[[0.4953], [0.9669]]]], [[[[0.2571], [0.0112]]], [[[0.4418], [0.7353]]]]]], [[[[[[0.8561], [0.103]]], [[[0.7395], [0.7654]]]], [[[[0.3978], [0.6726]]], [[[0.1321], [0.3884]]]]], [[[[[0.7251], [0.5909]]], [[[0.467], [0.9308]]]], [[[[0.6722], [0.9302]]], [[[0.4152], [0.9676]]]]]]], 0, X)
-------------------------------------------------------------------------------------
X = [[[[[[0.0724], [0.5743]]], [[[0.874], [0.7279]]]], [[[[0.7218], [0.2726]]], [[[0.356], [0.7116]]]]], [[[[[0.8561], [0.103]]], [[[0.7395], [0.7654]]]], [[[[0.3978], [0.6726]]], [[[0.1321], [...]]]]], [[[[[0.9283], [0.9371]]], [[[0.4953], [...]]]], [[[[0.2571], [...]]], [[[...]|...]]]], [[[[[0.7251], [...]]], [[[...]|...]]], [[[[...]|...]], [[...|...]]]]] X = [[[[[[0.0724], [0.5743]]], [[[0.874], [0.7279]]]], [[[[0.7218], [0.2726]]], [[[0.356], [0.7116]]]]], [[[[[0.8561], [0.103]]], [[[0.7395], [0.7654]]]], [[[[0.3978], [0.6726]]], [[[0.1321], [0.3884]]]]], [[[[[0.9283], [0.9371]]], [[[0.4953], [0.9669]]]], [[[[0.2571], [0.0112]]], [[[0.4418], [0.7353]]]]], [[[[[0.7251], [0.5909]]], [[[0.467], [0.9308]]]], [[[[0.6722], [0.9302]]], [[[0.4152], [0.9676]]]]]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[[[0.0724000], [0.5743000]]], [[[0.8740000], [0.7279000]]]], [[[[0.7218000], [0.2726000]]], [[[0.3560000], [0.7116000]]]]], [[[[[0.9283000], [0.9371000]]], [[[0.4953000], [0.9669000]]]], [[[[0.2571000], [0.0112000]]], [[[0.4418000], [0.7353000]]]]], [[[[[0.8561000], [0.1030000]]], [[[0.7395000], [0.7654000]]]], [[[[0.3978000], [0.6726000]]], [[[0.1321000], [0.3884000]]]]], [[[[[0.7251000], [0.5909000]]], [[[0.4670000], [0.9308000]]]], [[[[0.6722000], [0.9302000]]], [[[0.4152000], [0.9676000]]]]]]
Expected (Unparsed): [[[[[[0.0724], [0.5743]]], [[[0.874], [0.7279]]]], [[[[0.7218], [0.2726]]], [[[0.356], [0.7116]]]]], [[[[[0.8561], [0.103]]], [[[0.7395], [0.7654]]]], [[[[0.3978], [0.6726]]], [[[0.1321], [0.3884]]]]], [[[[[0.9283], [0.9371]]], [[[0.4953], [0.9669]]]], [[[[0.2571], [0.0112]]], [[[0.4418], [0.7353]]]]], [[[[[0.7251], [0.5909]]], [[[0.467], [0.9308]]]], [[[[0.6722], [0.9302]]], [[[0.4152], [0.9676]]]]]]
-------------------------------------------------------------------------------------
Actual:   [[[[[[0.0724], [0.5743]]], [[[0.874], [0.7279]]]], [[[[0.7218], [0.2726]]], [[[0.356], [0.7116]]]]], [[[[[0.9283], [0.9371]]], [[[0.4953], [0.9669]]]], [[[[0.2571], [0.0112]]], [[[0.4418], [0.7353]]]]], [[[[[0.8561], [0.103]]], [[[0.7395], [0.7654]]]], [[[[0.3978], [0.6726]]], [[[0.1321], [0.3884]]]]], [[[[[0.7251], [0.5909]]], [[[0.467], [0.9308]]]], [[[[0.6722], [0.9302]]], [[[0.4152], [0.9676]]]]]]
Expected: [[[[[[0.0724], [0.5743]]], [[[0.874], [0.7279]]]], [[[[0.7218], [0.2726]]], [[[0.356], [0.7116]]]]], [[[[[0.8561], [0.103]]], [[[0.7395], [0.7654]]]], [[[[0.3978], [0.6726]]], [[[0.1321], [0.3884]]]]], [[[[[0.9283], [0.9371]]], [[[0.4953], [0.9669]]]], [[[[0.2571], [0.0112]]], [[[0.4418], [0.7353]]]]], [[[[[0.7251], [0.5909]]], [[[0.467], [0.9308]]]], [[[[0.6722], [0.9302]]], [[[0.4152], [0.9676]]]]]]
-------------------------------------------------------------------------------------
*/


concatenate_layer(Is,Axis,Os) :- 
	depth(Is,D),
	%Axis < D - 1,
	(Axis > D - 2-> (writeln("Invalid Axis!"),abort);true),
	concatenate_layer(Is,Axis,[],OsT),
	((Axis =:=  0) -> remove_inner_nesting(OsT,Os); keep(OsT,Os)).
concatenate_layer([],_,Os,Os).
concatenate_layer(Is,Axis,Os0,Os) :-
	(Axis  =:=  0 -> (get_first_elem(Is,I),get_tail(Is,Is1)); del_first_items(Is,I,Is1)),
	concatenate(I, Axis,O),
	append(Os0,[O],Os1),
	concatenate_layer(Is1,Axis,Os1,Os).
	

concatenate(Is,0,Is).% :-
	%concatenate_lists(Is,Os).

concatenate(Is,1,Os) :-
	depth(Is,D),
	D < 3,
	remove_inner_nesting(Is,Os).

concatenate(Is,1,Os) :-
	depth(Is,D),
	D > 2,
	maplist(transpose,Is,Is1),
	concatenate(Is1,0,Os1),
	maplist(transpose,Os1,Os2),
	remove_inner_nesting(Os2,Os).

concatenate(Is,2,Os) :-
	transpose(Is,Is1),
	concatenate(Is1,0,Os1),
	remove_inner_inner_nesting(Os1,Os).
	
	/*transpose(Is,IsT),
	map_transpose(IsT,Is1),
	concatenate(Is1,0,Os1),
	map_transpose(Os1,Os2),
	transpose(Os2,Os3),
	remove_inner_nesting(Os3,Os).*/
	%decapsulate_items(Os1,Os).
	%maplist(remove_inner_nesting,Os1,Os).
concatenate(Is,3,Os) :-
	transpose(Is,IsT),
	map_transpose(IsT,Is1),
	concatenate(Is1,0,Os1),
	remove_inner_inner_inner_nesting(Os1,Os).
	/*transpose(Is,IsT),
	map_transpose(IsT,IsT1),
	map_map_transpose(IsT1,Is1),
	concatenate(Is1,0,Os1),
	map_map_transpose(Os1,Os2),
	map_transpose(Os2,Os3),
	remove_inner_inner_nesting(Os3,Os).*/
	%maplist(remove_inner_nesting(Os3,Os)).
	%transpose(Os3,Os).
	
	%maplist(remove_inner_inner_nesting,Os1,Os).
	%innner_transpose(Os1,OsT),
	%maplist(map_transpose,Os1,Os).
	%maplist(remove_inner_nesting,Os1,Os).

concatenate(Is,4,Os) :-
	transpose(Is,IsT),
	map_transpose(IsT,IsT1),
	map_map_transpose(IsT1,Is1),
	concatenate(Is1,0,Os1),
	remove_inner_inner_inner_inner_nesting(Os1,Os).
	/*transpose(Is,IsT),
	map_transpose(IsT,IsT1),
	map_map_transpose(IsT1,IsT2),
	map_map_map_transpose(IsT2,Is1),
	concatenate(Is1,0,Os1),
	map_map_map_transpose(Os1,Os2),
	map_map_transpose(Os2,Os3),
	remove_inner_inner_inner_nesting(Os3,Os).*/
	
concatenate(Is,5,Os) :-
	transpose(Is,IsT),
	map_transpose(IsT,IsT1),
	map_map_transpose(IsT1,IsT2),
	map_map_map_transpose(IsT2,Is1),
	concatenate(Is1,0,Os1),
	remove_inner_inner_inner_inner_inner_nesting(Os1,Os).
	/*transpose(Is,IsT),
	map_transpose(IsT,IsT1),
	map_map_transpose(IsT1,IsT2),
	map_map_map_transpose(IsT2,IsT3),
	map_map_map_map_transpose(IsT3,Is1),
	concatenate(Is1,0,Os1),
	map_map_map_map_transpose(Os1,Os2),
	map_map_map_transpose(Os2,Os3),
	remove_inner_inner_inner_inner_nesting(Os3,Os).*/


/*
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

concatenate_layer(Is,4,[Os]) :-
	transpose(Is,IsT),
	map_transpose(IsT,IsT1),
	map_map_transpose(IsT1,Is1),
	concatenate_layer(Is1,0,Os1),
	maplist(remove_inner_inner_inner_nesting,Os1,Os).
	
concatenate_layer(Is,5,[Os]) :-
	transpose(Is,IsT),
	map_transpose(IsT,IsT1),
	map_map_transpose(IsT1,IsT2),
	map_map_map_transpose(IsT2,Is1),
	concatenate_layer(Is1,0,Os1),
	maplist(remove_inner_inner_inner_inner_nesting,Os1,Os).
*/
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
	catch(call_with_time_limit(120,L), E, (write("Aborted at "), write(N), write(": "), write(E), writeln("!!!"),abort)),
	write("Layer "), write(N),writeln(" executed successfully"),
	(length(Layers,0) -> write(OutVarName), write(" = "), writeln(OutVar);true),
	exec_layers(Layers,LayerNames,OutVar, OutVarName).

check_dimensions(Is, D) :-
	depth(Is,D1), 
	%writeln("D1"),
	%writeln(D1),
	%writeln("D"),
	%writeln(D),
	(D1 =\= D -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Dimension error, Input Shape ",
		    shape(Is,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).
		    
		    
check_max_dimensions(Is, D) :-
	depth(Is,D1), 
	(D1 > D -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Dimension error, Input Shape ",
		    shape(Is,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).
		    
check_same_dimensions(I1,I2) :-
	depth(I1,D1),
	depth(I2,D2),
	(D1 =\= D2 -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D2,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Inconsistent Input Dimensions, Input Shape ",
		    shape(I1,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).
		    
check_same_and_max_dimensions(I1,I2,Max) :-
	depth(I1,D1),
	depth(I2,D2),
	(D1 > Max -> 
		(D2 > Max->(write("Invalid Model, Badness Value: "), 
			    BV is (D1-Max)+(D2-Max),BV1 is BV*210000000, writeln(BV1),  
			    S1 = "Dimension error, Input Shape ",
			    shape(I1,Shape),
			    term_string(Shape,S2),
			    string_concat(S1,S2,S),
			    throw(S));
			    (write("Invalid Model, Badness Value: "), 
			    BV is (D1-Max),BV1 is BV*230000000, writeln(BV1),  
			    S1 = "Dimension error, Input Shape ",
			    shape(I1,Shape),
			    term_string(Shape,S2),
			    string_concat(S1,S2,S),
			    throw(S)));
		 (D2 > Max->(write("Invalid Model, Badness Value: "), 
			    BV is (D2-Max),BV1 is BV*210000000, writeln(BV1),  
			    S1 = "Dimension error, Input Shape ",
			    shape(I2,Shape),
			    term_string(Shape,S2),
			    string_concat(S1,S2,S),
			    throw(S));true)),
	(D1 =\= D2 -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D2,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Inconsistent Input Dimensions, Input Shape ",
		    shape(I1,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).
		    
check_same_dimensions_different_input(Is,I1,I2) :-
	depth(I1,D1),
	depth(I2,D),
	(D1 =\= D -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Inconsistent Input Dimensions, Input Shape ",
		    shape(Is,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).
	
	
check_same_shape(I1,I2) :-
	check_same_dimensions(I1,I2),
	%shape(I1,Shape1),
	%shape(I2,Shape2),
	%writeln(Shape1),
	%writeln(Shape2),
	(not(compare_structure(I1,I2)) -> (write("Invalid Model, Badness Value: "), 
		    		 	   compute_different_shape_badness(I1,I2,B),
		    			   writeln(B), 
		    			   S1 = "Inconsistent Input Shapes, Input Shape ",
		    			   shape(I1,Shape),
		    			   term_string(Shape,S2),
		    			   string_concat(S1,S2,S),
		    			   throw(S));true).	
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
 	pow(100,D-1,Factor),
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
	                     
check_valid_reshape([I|Is],Ss) :-
	shape(I,S),
	list_product(Ss,P),
	list_product(S,P1),
	(P =\= P1 -> (writeln("Invalid Model, Badness Value: 1000000000"),
			 S1 = "Reshape Error, Input Shape ",
			 shape([I|Is],ShapeT),
			 term_string(ShapeT,S2),
			 string_concat(S1,S2,ST),
			 throw(ST));true).
                     
check_valid_reshapeOld([I|Is],Ss) :-
	shape(I,S),
	list_product(Ss,P),
	list_product(S,P1),
	(P =\= P1 -> (
	(list_butlast(Ss,Ss1),not(is_sublist(S,Ss1))) ->
		(writeln("Invalid Model, Badness Value: 1000000000"),
		 S1 = "Reshape Error, Input Shape ",
		 shape([I|Is],ShapeT),
		 term_string(ShapeT,S2),
		 string_concat(S1,S2,ST),
		 throw(ST));
		true);
	true).
check_empty_cropping(Is,[]) :-
	writeln("Invalid Model, Badness Value: 1000000000"),
	S1 = "Cropping Error, Input Shape ",
	shape(Is,ShapeT),
	term_string(ShapeT,S2),
	string_concat(S1,S2,ST),
	throw(ST).
check_empty_cropping(_,O) :- number(O).
check_empty_cropping(Is, [O|_]) :-
	check_empty_cropping(Is,O).

	                     	                     
check_valid_arguments(Is, A1,A2) :-
	(A1 =\= A2 -> (write("Invalid Model, Badness Value: "), 
    		     BV is A1-A2, writeln(BV),  
    		     S1 = "Argument Error, Input Shape ",
    	             shape(Is,Shape),
    	             term_string(Shape,S2),
    		     string_concat(S1,S2,S), 
                     throw(S));true).
                     
check_smaller_arguments(Is, A1,A2) :-
	(A1 >= A2 -> (write("Invalid Model, Badness Value: "), 
    		     BV is A1-A2, writeln(BV),  
    		     S1 = "Argument Error, Input Shape ",
    	             shape(Is,Shape),
    	             term_string(Shape,S2),
    		     string_concat(S1,S2,S), 
                     throw(S));true).
                     
check_valid_weight_shape(_, [],[]).                    	                                          
check_valid_weight_shape(Is, [S|Shape],[S1|WsShape]) :-
	check_valid_arguments(Is,S,S1),
	check_valid_weight_shape(Is,Shape,WsShape).

check_same_shape_arg(I1,I2) :-
	check_same_dimensions(I1,I2),
	(not(compare_structure(I1,I2)) -> (write("Invalid Model, Badness Value: "), 
		    		 	   compute_different_shape_badness(I1,I2,B),
		    			   writeln(B), 
		    			   S1 = "Argument Error, Input Shape ",
		    			   shape(I1,Shape),
		    			   term_string(Shape,S2),
		    			   string_concat(S1,S2,S),
		    			   throw(S));true).
		    			   
check_same_shape_arg_different_input(Is,I1,I2) :-
	check_same_dimensions_different_input(Is,I1,I2),
	(not(compare_structure(I1,I2)) -> (write("Invalid Model, Badness Value: "), 
		    		 	   compute_different_shape_badness(I1,I2,B),
		    			   writeln(B), 
		    			   S1 = "Argument Error, Input Shape ",
		    			   shape(Is,Shape),
		    			   term_string(Shape,S2),
		    			   string_concat(S1,S2,S),
		    			   throw(S));true).
		    			   
