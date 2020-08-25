


%locally_connected1D_layer([1,2,3,4],2,[[[1,2,5],[2,3,6]],[[1,2,5],[2,3,6]],[[1,2,5],[2,3,6]]],[[4,3,2],[1,3,2],[2,3,2]],X).
locally_connected1D_layer(Is,K,IWs,OWs,Os) :- %invert_2Dlist(IWs,IWs1), 
	locally_connected1D_output_comp(Is,K,IWs,OWs,Os).%locally_connected1D_layer(Is,K,IWs,OWs,[],Os).


	
locally_connected1D_output_comp(Is,K,IWs,OWs,Os) :- locally_connected1D_output_comp(Is,K,IWs,OWs,[],Os).
%conv1D_output_comp([],_,_,_,Os,Os).
locally_connected1D_output_comp(Is,K,[],[],Os,Os) :-
	length(Is,L),
	L < K.	
locally_connected1D_output_comp([I|Is],K,[IW|IWs],[OW|OWs],Os0,Os) :-
	length([I|Is],L),
	L >= K,
	apply_locallyconnected1Dkernel([I|Is],K,IW,O),
	add_lists(O,OW,O1),%O1 is O + OW,
	append(Os0,[O1],Os1),
	locally_connected1D_output_comp(Is,K,IWs,OWs,Os1,Os).
	
apply_locallyconnected1Dkernel([I|Is],K,[W|Ws],Res) :- apply_locallyconnected1Dkernel([I|Is],K,[W|Ws],[],Res).
apply_locallyconnected1Dkernel(_,0,[],Res,Res).
apply_locallyconnected1Dkernel([I|Is],K,[W|Ws],Res0,Res) :-
	locallyconnected1D_comp_temp(Res0,I,W,Res1),
	K1 is K - 1,
	apply_locallyconnected1Dkernel(Is,K1,Ws,Res1,Res).
	
locallyconnected1D_comp_temp(Rs, I, Ws, R2s) :- 
	Rs == [], 
	length(Ws,L), 
	empty_list(L,RTs), 
	locallyconnected1D_comp_temp(RTs, I, Ws, [], R2s).	
locallyconnected1D_comp_temp(Rs, I, Ws, R2s) :- locallyconnected1D_comp_temp(Rs, I, Ws, [], R2s).
locallyconnected1D_comp_temp([], _, [], R2s, R2s).
locallyconnected1D_comp_temp([R0|R0s], I, [W|Ws], R1s, R2s) :-
	R1 is R0 + I * W, 
	append(R1s,[R1],R1Ts),
	locallyconnected1D_comp_temp(R0s, I, Ws, R1Ts, R2s).


%locally_connected2D_layer([[1,2,3],[3,2,2],[5,4,2]],2,2,[[[1 ],[ 2],[1],[3]],[[1 ],[ 2],[3 ],[4]],[[ 1],[2],[ 1],[3]],[[ 1],[ 2],[ 3],[1]]],[[[0],[0]],[[0],[0]]],X).
%locally_connected2D_layer([[1,2],[1,2]],1,1,[[[1 ]],[[ 2 ]],[[ 1]],[[ 2]]],[[[0],[0]],[[0],[0]]],X).
%locally_connected2D_layer([[1,2,3],[3,2,2],[5,4,2]],2,2,[[[1 ],[ 2],[1],[3]],[[1 ],[ 2],[3 ],[4]],[[ 1],[2],[ 1],[3]],[[ 1],[ 2],[ 3],[1]]],[[[4],[3]],[[2],[1]]],X).
locally_connected2D_layer(Is,KX,KY,IWs,OWs,Os) :- %invert_2Dlist(IWs,IWs1), 
	locally_connected2D_output_comp(Is,KX,KY,IWs,OWs,Os).

locally_connected2D_output_comp(Is,KX,KY,IWs,OWs,Os) :- 
	locally_connected2D_output_comp(Is,0,0,KX,KY,IWs,OWs,[],Os).
%conv1D_output_comp([],_,_,_,Os,Os).
%locally_connected2D_output_comp([I|Is],X,Y,KX,KY,[],_,Os,Os).
locally_connected2D_output_comp(_,_,_,_,_,[],_,Os,Os).
%	length([I|Is],LX), length(I,LY),
%	X+KX > LX,	Y+KY > LY. 
locally_connected2D_output_comp([I|Is],X,Y,KX,KY,[IW|IWs],OWs,Os0,Os) :-
	length(I,LX),%length([I|Is],LY),
	%X+KX =< LX;Y+KY =< LY, 
	apply_locallyconnected2Dkernel([I|Is],X,Y,KX,KY,IW,O),
	nth0_2D(X,Y,OWs,OW),
	add_lists(O,OW,O1),
	append(Os0,[O1],Os1),
	(X+KX < LX -> X1 is X + 1,Y1 is Y;X1 is 0,Y1 is Y+1),
	locally_connected2D_output_comp([I|Is],X1,Y1,KX,KY,IWs,OWs,Os1,Os).
	
apply_locallyconnected2Dkernel(Is,X,Y,KX,KY,IWs,O) :- apply_locallyconnected2Dkernel(Is,X,Y,X,Y,KX,KY,IWs,[],O).
apply_locallyconnected2Dkernel(_,_,_,_,_,_,_,[],Res,Res).
%apply_locallyconnected2Dkernel(_,X,Y,X1,Y1,KX,KY,[],Res,Res).
%	X1 >= X+KX,
%	Y1 >= Y+KY.
apply_locallyconnected2Dkernel(Is,X,Y,X1,Y1,KX,KY,[W|Ws],Res0,Res) :-
	%X+KX =< X1; Y+KY =< Y1, 
	comp_locallyconnected2D_temp(Res0,Is,X1,Y1,W,Res1),
	(X1 < X+KX-1 -> X2 is X1 + 1,Y2 is Y1;X2 is X,Y2 is Y1+1),
	apply_locallyconnected2Dkernel(Is,X,Y,X2,Y2,KX,KY,Ws,Res1,Res).
	
comp_locallyconnected2D_temp(Rs, Is, X,Y, Ws, R2s) :- Rs == [], length(Ws,L), empty_list(L,RTs), comp_locallyconnected2D_temp(RTs, Is, X,Y, Ws, [], R2s).
comp_locallyconnected2D_temp(Rs, Is, X,Y, Ws, R2s) :- comp_locallyconnected2D_temp(Rs, Is, X,Y, Ws, [], R2s).		
comp_locallyconnected2D_temp([],_,_,_,[], R2s, R2s).
comp_locallyconnected2D_temp([R0|R0s], Is, X,Y, [W|Ws], R1s, R2s) :-
	nth0_2D(X,Y,Is,I),
	R1 is R0 + I * W, 
	append(R1s,[R1],R1Ts),
	comp_locallyconnected2D_temp(R0s, Is, X,Y, Ws, R1Ts, R2s).