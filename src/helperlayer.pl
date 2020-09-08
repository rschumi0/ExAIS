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