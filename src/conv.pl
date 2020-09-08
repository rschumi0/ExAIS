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


%conv2D_layer([[1,2,3],[3,2,2],[5,4,2]],2,2,[[[1 ],[ 2],[1],[3]],[[1 ],[ 2],[3 ],[4]],[[ 1],[2],[ 1],[3]],[[ 1],[ 2],[ 3],[1]]],[[[0],[0]],[[0],[0]]],X).
%conv2D_layer([[1,2],[1,2]],1,1,[[[1 ]],[[ 2 ]],[[ 1]],[[ 2]]],[0,0,0,0]],X).
%conv2D_layer([[1,2,3],[3,2,2],[5,4,2]],2,2,[[[1 ],[ 2],[1],[3]],[[1 ],[ 2],[3 ],[4]],[[ 1],[2],[ 1],[3]],[[ 1],[ 2],[ 3],[1]]],[4,3,2,1],X).


%conv2D_layer([[1,2,3],[3,2,2],[5,4,2]],2,2,[[[[1]],[[ 2 ]]],[[[ 3 ]],[[ 4]]]],[1],X).

%conv2D_layer([[1]],1,1,[[[[1]]]],[1],X).




%conv2D_layer([[1,2,3],[3,2,2],[5,4,2]],2,2,[[[[0.39919466, -0.21345338]],[[ 0.2295965 ,  0.14584208]]],[[[-0.3789597, 0.6606434 ]],[[ 0.21004725,  0.6896575 ]]]],[0,0],X).
conv2D_layer(Is,KX,KY,IWs,OWs,Os) :- 
	conv2D_layer(Is,0,0,KX,KY,IWs,OWs,[],Os).

conv2D_layer([I|Is],X,Y,KX,KY,_,_,Os,Os) :-
	length(I,LX), 
	X+KX > LX; 
	length([I|Is],LY), 
	Y+KY > LY. 
conv2D_layer([I|Is],X,Y,KX,KY,[IW|IWs],OWs,Os0,Os) :-
	length(I,LX),%length([I|Is],LY),
	apply_conv2Dkernel([I|Is],X,Y,KX,KY,[IW|IWs],O),
	%add_to_each_list_element(O,OW,O1),
	add_lists(O,OWs,O1),
	append(Os0,[O1],Os1),
	(X+KX < LX -> X1 is X + 1,Y1 is Y;X1 is 0,Y1 is Y+1),
	conv2D_layer([I|Is],X1,Y1,KX,KY,[IW|IWs],OWs,Os1,Os).
	
apply_conv2Dkernel(Is,X,Y,KX,KY,IWs,O) :- apply_conv2Dkernel(Is,X,Y,X,Y,KX,KY,IWs,[],O).
apply_conv2Dkernel(_,X,Y,X1,Y1,KX,KY,_,Res,Res) :-
	X1 >= X+KX;Y1 >= Y+KY.
apply_conv2Dkernel(Is,X,Y,X1,Y1,KX,KY,Ws,Res0,Res) :-
	KX1 is X1 - X,
	KY1 is Y1 - Y,
	nth0_2D(KX1,KY1,Ws,[W|_]),
	comp_conv2D_temp(Res0,Is,X1,Y1,W,Res1),
	(X1 < X+KX-1 -> X2 is X1 + 1,Y2 is Y1;X2 is X,Y2 is Y1+1),
	apply_conv2Dkernel(Is,X,Y,X2,Y2,KX,KY,Ws,Res1,Res).
	
comp_conv2D_temp(Rs, Is, X,Y, Ws, R2s) :- Rs == [], length(Ws,L), empty_list(L,RTs), comp_conv2D_temp(RTs, Is, X,Y, Ws, [], R2s).
comp_conv2D_temp(Rs, Is, X,Y, Ws, R2s) :- comp_conv2D_temp(Rs, Is, X,Y, Ws, [], R2s).		
comp_conv2D_temp([],_,_,_,[], R2s, R2s).
comp_conv2D_temp([R0|R0s], Is, X,Y, [W|Ws], R1s, R2s) :-
	nth0_2D(X,Y,Is,I),
	R1 is R0 + I * W, 
	append(R1s,[R1],R1Ts),
	comp_conv2D_temp(R0s, Is, X,Y, Ws, R1Ts, R2s).
	
	
	
	
%[[[[[0.16094995 1.5689545 ]
%    [0.02414706 1.2510453 ]]
%
%   [[0.9227542  2.0026867 ]
%    [1.1550317  2.141678  ]]]]]	
	
%conv3D_layer([[[3,2,1],[1,1,1],[1,1,1]],[[1,1,1],[1,1,1],[1,1,1]],[[1,1,1],[1,1,1],[4,5,6]]],3,2,2,[[[[[-0.04054663, -0.03322145]],[[ 0.17734951,  0.35113066]]],[[[ 0.34456736,  0.35620993]],[[-0.2550702 ,  0.01479244]]]],[[[[ 0.18048924,  0.18314284]],[[-0.0992502 ,  0.21947753]]],[[[-0.16307092, -0.13529667]],[[ 0.2602666 ,  0.3122995 ]]]],[[[[-0.31659678, -0.21346802]],[[-0.2557217 ,  0.09020904]]],[[[ 0.07104903, -0.16245615]],[[ 0.16122836,  0.30144715]]]]],[0,0],X).
%conv3D_layer([[[3,2,1],[1,1,1],[1,1,1]],[[1,1,1],[1,1,1],[1,1,1]],[[1,1,1],[1,1,1],[4,5,6]]],3,2,2,[[[[[-0.09344122, -0.26252544]],[[-0.24480645,  0.36845672]]],[[[ 0.40190554,  0.30591333]],[[-0.39025027,  0.38763988]]]],[[[[-0.2282657 , -0.08173075]],[[ 0.15992498, -0.02860072]]],[[[-0.20307304,  0.03189811]],[[-0.08320138,  0.07733205]]]],[[[[ 0.17180228,  0.27463096]],[[-0.25922278, -0.02403438]]],[[[-0.02859068, -0.15852697]],[[ 0.40714782,  0.13434345]]]]],[0,0],X).
%conv3D_layer([[[1,1,1],[1,1,1],[1,1,1]],[[1,1,1],[1,1,1],[1,1,1]],[[1,1,1],[1,1,1],[1,1,1]]],2,2,2,[[[[[-0.13427508,  0.04172552]],[[ 0.3790692 , -0.24367893]]],[[[ 0.16087413,  0.42867708]],[[ 0.15049517,  0.23206043]]]],[[[[-0.37373185, -0.02819586]],[[ 0.0837754 ,  0.02620053]]],[[[-0.3780887 ,  0.3137504 ]],[[ 0.10876596,  0.29410756]]]]],[0,0],X).
%conv3D_layer([[[1,1,1],[1,1,1],[1,1,1]],[[1,1,1],[1,1,1],[1,1,1]],[[1,1,1],[1,1,1],[1,1,1]]],2,2,2,[[[[[-0.17750347]],[[-0.0514757 ]]],[[[ 0.26448923]],[[ 0.22037184]]]],[[[[-0.19314542]],[[-0.27748755]]],[[[ 0.59971946]],[[ 0.27509284]]]]],[0],X).
conv3D_layer(Is,KX,KY,KZ,IWs,OWs,Os) :- 
	conv3D_layer(Is,0,0,0,KX,KY,KZ,IWs,OWs,[],Os).
conv3D_layer([[I|I1s]|Is],X,Y,Z,KX,KY,KZ,_,_,Os,Os) :-
	length([[I|I1s]|Is],LX), 
	X+KX > LX; 
	length([I|I1s],LY), 
	Y+KY > LY;
	length(I,LZ), 
	Z+KZ > LZ.
conv3D_layer([[I|I1s]|Is],X,Y,Z,KX,KY,KZ,[IW|IWs],OWs,Os0,Os) :-
	length(I,LX),length([[I|I1s]|Is],LY),
	apply_conv3Dkernel([[I|I1s]|Is],X,Y,Z,KX,KY,KZ,[IW|IWs],O),
	add_lists(O,OWs,O1),
	append(Os0,[O1],Os1),
	(X+KX < LX -> X1 is X + 1,Y1 is Y, Z1 is Z; (Y+KY < LY -> X1 is 0,Y1 is Y+1, Z1 is Z; X1 is 0, Y1 is 0, Z1 is Z + 1)),
	conv3D_layer([[I|I1s]|Is],X1,Y1,Z1,KX,KY,KZ,[IW|IWs],OWs,Os1,Os).
	
	
apply_conv3Dkernel(Is,X,Y,Z,KX,KY,KZ,IWs,O) :- apply_conv3Dkernel(Is,X,Y,Z,X,Y,Z,KX,KY,KZ,IWs,[],O).
apply_conv3Dkernel(_,X,Y,Z,X1,Y1,Z1,KX,KY,KZ,_,Res,Res) :-
	X1 >= X+KX;Y1 >= Y+KY; Z1 >= Z+KZ.
apply_conv3Dkernel(Is,X,Y,Z,X1,Y1,Z1,KX,KY,KZ,Ws,Res0,Res) :-
	KX1 is X1 - X,
	KY1 is Y1 - Y,
	KZ1 is Z1 - Z,
	nth0_3D(KX1,KY1,KZ1,Ws,[W|_]),
	comp_conv3D_temp(Res0,Is,X1,Y1,Z1,W,Res1),
	(X1 < X+KX-1 -> X2 is X1 + 1,Y2 is Y1, Z2 is Z1;(Y1 < Y+KY-1 -> X2 is X,Y2 is Y1+1,Z2 is Z1; X2 is X, Y2 is Y, Z2 is Z1 + 1)),
	apply_conv3Dkernel(Is,X,Y,Z,X2,Y2,Z2,KX,KY,KZ,Ws,Res1,Res).
	
	
comp_conv3D_temp(Rs, Is, X,Y,Z, Ws, R2s) :- Rs == [], length(Ws,L), empty_list(L,RTs), comp_conv3D_temp(RTs, Is, X,Y,Z, Ws, [], R2s).
comp_conv3D_temp(Rs, Is, X,Y,Z, Ws, R2s) :- comp_conv3D_temp(Rs, Is, X,Y,Z, Ws, [], R2s).		
comp_conv3D_temp([],_,_,_,_,[], R2s, R2s).
comp_conv3D_temp([R0|R0s], Is, X,Y,Z, [W|Ws], R1s, R2s) :-
	nth0_3D(X,Y,Z,Is,I),
	R1 is R0 + I * W, 
	append(R1s,[R1],R1Ts),
	comp_conv3D_temp(R0s, Is, X,Y,Z, Ws, R1Ts, R2s).
	
