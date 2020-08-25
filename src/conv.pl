%conv1D_layer([1,2,3,4],2,[[1,2,5],[2,3,6]],[4,3,2],X).
conv1D_layer(Is,K,IWs,OWs,Os) :- 
	invert_2Dlist(IWs,IWs1), 
	conv1D_layer(Is,K,IWs1,OWs,[],Os).
conv1D_layer(_,_,[],[],Os,Os).
conv1D_layer(Is,K,[IW|IWs],[OW|OWs],Os1,Os) :-
	conv1D_output_comp(Is,K,IW,OW,O),
	append(Os1,[O],Os2),
	length(IWs,L),
	L > 0,
	conv1D_layer(Is,K,IWs,OWs,Os2,Os).
conv1D_layer(Is,K,[IW|IWs],[OW|OWs],Os1,Os) :-
	conv1D_output_comp(Is,K,IW,OW,O),
	append(Os1,[O],Os2),
	length(IWs,L),
	L == 0,
	invert_2Dlist(Os2,Os3),
	conv1D_layer(Is,K,IWs,OWs,Os3,Os).

conv1D_output_comp(Is,K,IW,OW,Os) :- conv1D_output_comp(Is,K,IW,OW,[],Os).
conv1D_output_comp(Is,K,_,_,Os,Os) :-
	length(Is,L),
	L < K.	
conv1D_output_comp([I|Is],K,IW,OW,Os0,Os) :-
	length([I|Is],L),
	L >= K,
	apply_1Dkernel([I|Is],K,IW,O),
	O1 is O + OW,
	append(Os0,[O1],Os1),
	conv1D_output_comp(Is,K,IW,OW,Os1,Os).

apply_1Dkernel([I|Is],K,[W|Ws],Res) :- apply_1Dkernel([I|Is],K,[W|Ws],0, Res).
apply_1Dkernel(_,0,[],Res,Res).
apply_1Dkernel([I|Is],K,[W|Ws],Res0,Res) :-
	Res1 is Res0 + I * W,
	K1 is K - 1,
	apply_1Dkernel(Is,K1,Ws,Res1,Res).



%conv1D_layer([1,2,3,4],2,[[1,2,5],[2,3,6]],[4,3,2],X), flatten(X,X1), dense_layer(X1,[[3,4,3,1,2,5,6,4,5],[5,6,3,2,3,2,1,4,3]],[2,3],Z).


