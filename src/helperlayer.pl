:-use_module(library(clpfd)).
:-use_module(library(list_util)).
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

	
zero_padding1D([[I|I0s]|Is],N,Os) :- atomic(I), zero_padding1D([[I|I0s]|Is],N,[[I|I0s]|Is],Os).
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
	zero_padding1D([[I|I0s]|Is],N1,[O|Os2],Os).



%zero_padding2D([[[[1,2],[3,4]],[[1,2],[3,4]]]],1,X).
%zero_padding2D([[[[1,2],[3,4]],[[1,2],[3,4]]],[[[1,2],[3,4]],[[1,2],[3,4]]]],1,X).
zero_padding2D([I|Is],N,Os) :- length([I|Is],L), L == 1, zero_padding1D(I,N,Os1), zero_padding2D(Os1,N,Os1,Os).
zero_padding2D(Is,N,Os) :- length(Is,L), L > 1, zero_padding2D(Is,N,[],Os).
zero_padding2D([],_,Os,Os).
zero_padding2D([[[I|I0s]|I1s]|Is],N,Os1,Os) :-
	is_list(I),
	zero_padding2D([[[I|I0s]|I1s]],N,O),
	append(Os1,[O],Os2),
	zero_padding2D(Is,N,Os2,Os).
zero_padding2D(_,0,Os,Os).
zero_padding2D([[[I|I0s]|I1s]|Is],N,Os1,Os) :-
	atomic(I),
	N1 is N - 1,
	length([I|I0s],LX),
	length([[I|I0s]|I1s],LY),
	empty_field(LX,LY,O),
	append(Os1,[O],Os2),
	zero_padding2D([[[I|I0s]|I1s]|Is],N1,[O|Os2],Os).
	
%zero_padding3D([[[[[1,2],[3,4]],[[1,2],[3,4]]],[[[1,2],[3,4]],[[1,2],[3,4]]]]],1,X).
zero_padding3D([I|Is],N,Os) :- length([I|Is],L), L == 1, zero_padding2D(I,N,Os1), zero_padding3D(Os1,N,Os1,Os).
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
	zero_padding3D([[[[I|I0s]|I1s]|I2s]|Is],N1,[O|Os2],Os).
	
	
up_sampling1D(Is, Size, Os) :- up_sampling1D(Is, Size, [], Os).
up_sampling1D([], _, Os,Os).
up_sampling1D([[I|Is0]|Is], Size, Os0,Os):-
	is_list(I),
	up_sampling1D([I|Is0],Size,O),
	append(Os0,[O],Os1),
	up_sampling1D(Is,Size,Os1,Os).
up_sampling1D([[I|Is0]|Is], Size, _,Os):-
	atomic(I),
	multiply_entries([[I|Is0]|Is],Size,Os1),
	up_sampling1D([],Size,Os1,Os).



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
	
	
up_sampling2D(Is, SizeD1, SizeD2, Os) :- up_sampling2D(Is, SizeD1, SizeD2, [], Os).
up_sampling2D([], _, _, Os,Os).
up_sampling2D([[[I|Is0]|Is1]|Is], SizeD1, SizeD2, Os0,Os):-
	is_list(I),
	up_sampling2D([[I|Is0]|Is1],SizeD1, SizeD2,O),
	append(Os0,[O],Os1),
	up_sampling2D(Is,SizeD1,SizeD2,Os1,Os).
up_sampling2D([[[I|Is0]|Is1]|Is], SizeD1, SizeD2, _,Os):-
	atomic(I),
	SizeD1 > 0,
	multiply_entries([[[I|Is0]|Is1]|Is],SizeD1,Os1),
	up_sampling2D(Os1,0, SizeD2,[],Os).
up_sampling2D([[[I|Is0]|Is1]|Is], 0, SizeD2, Os0,Os):-
	atomic(I),
	up_sampling1D([[I|Is0]|Is1],SizeD2,O),
	append(Os0,[O],Os1),
	up_sampling2D(Is,0, SizeD2,Os1,Os).
	
up_sampling3D(Is, SizeD1, SizeD2, SizeD3, Os) :- up_sampling3D(Is, SizeD1, SizeD2, SizeD3, [], Os).
up_sampling3D([], _, _,_, Os,Os).
up_sampling3D([[[I|Is0]|Is1]|Is], SizeD1, SizeD2, SizeD3, Os0,Os):-
	is_list(I),
	up_sampling3D([[I|Is0]|Is1],SizeD1, SizeD2, SizeD3,O),
	append(Os0,[O],Os1),
	up_sampling3D(Is,SizeD1,SizeD2, SizeD3,Os1,Os).
up_sampling3D([[[I|Is0]|Is1]|Is], SizeD1, SizeD2, SizeD3, _,Os):-
	atomic(I),
	SizeD1 > 0,
	up_sampling2D([[[I|Is0]|Is1]|Is],SizeD1,SizeD2,Os1),
	up_sampling3D(Os1,0, 0, SizeD3,[],Os).
up_sampling3D([[[I|Is0]|Is1]|Is], 0, 0, SizeD3, Os0,Os):-
	atomic(I),
	multiply_sub_entries([[I|Is0]|Is1],SizeD3,O),
	append(Os0,[O],Os1),
	up_sampling3D(Is,0, 0, SizeD3,Os1,Os).
	
	
multiply_sub_entries(Is,N,Os) :- multiply_sub_entries(Is,N,[],Os).
multiply_sub_entries([],_,Os,Os).
multiply_sub_entries([I|Is],N,Os0,Os) :-
	multiply_entries(I,N,O),
	append(Os0,[O],Os1),
	multiply_sub_entries(Is,N,Os1,Os). 

	