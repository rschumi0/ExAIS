%cropping1D_layer([[[1,2],[2,2],[3,3],[4,4]],[[1,2],[2,2],[3,3],[4,4]]],1,X).
cropping1D_layer(Is, Cropping, Os) :- cropping1D_layer(Is, Cropping, [], Os).
cropping1D_layer([], _, Os, Os).
cropping1D_layer([[I|I1s]|Is], Cropping, Os0, Os) :- 
	not(atomic(I)),
	apply_cropping(Cropping,[I|I1s], Os1),
	append(Os0,[Os1],Os2),
	cropping1D_layer(Is, Cropping, Os2, Os).
cropping1D_layer([[I|I1s]|Is], Cropping, _, Os) :- 
	atomic(I),
	apply_cropping(Cropping,[[I|I1s]|Is], Os1),
	cropping1D_layer([], Cropping, Os1, Os).

	
apply_cropping(0, Os, Os).
apply_cropping(Cropping, [O|Os0], Os) :- 
	length([O|Os0], N),
	N >= 2,
	Cropping1 is Cropping - 1,
	list_butlast(Os0,Os1),
	apply_cropping(Cropping1, Os1, Os).
apply_cropping(_, [O|Os0], Os) :- 
	length([O|Os0], N),
	N == 1,
	apply_cropping(0, Os0, Os).
apply_cropping(_, Os0, Os) :- 
	length(Os0, N),
	N == 0,
	apply_cropping(0, Os0, Os).
	
zero_padding1D(Is,N,Os) :- zero_padding1D(Is,N,Is,Os).
zero_padding1D(_,0,Os,Os).
zero_padding1D([I|Is],N,Os1,Os) :-
	N1 is N - 1,
	length(I,L),
	empty_list(L,O),
	append(Os1,[O],Os2),
	zero_padding1D([I|Is],N1,[O|Os2],Os).