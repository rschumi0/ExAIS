:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-[util].
:-[pooling].

/*
nth0_2D_temp(X,Y,Is,Os) :-
	nth0(Y,Is,I1s),
	nth0(X,I1s,Os).	
	
nth0_3D_temp(X,Y,Z,Is,Os) :-
	nth0(X,Is,I1s),
	nth0(Z,I1s,I2s),
	nth0(Y,I2s,Os).
*/

%conv1D_layer([1,2,3,4],2,[[1,2,5],[2,3,6]],[4,3,2],X).
%conv1D_layer([[0.713, 0.315, 0.805]], 2,[[[0.171, 0.841]], [[0.26, 0.334]]],[0.528, 0.495], X)
/*conv1D_layer(Is,K,IWs,OWs,Os) :- 
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
	apply_1Dkernel(Is,K1,Ws,Res1,Res).*/



%conv1D_layer([1,2,3,4],2,[[1,2,5],[2,3,6]],[4,3,2],X), flatten(X,X1), dense_layer(X1,[[3,4,3,1,2,5,6,4,5],[5,6,3,2,3,2,1,4,3]],[2,3],Z).
%conv2D_layer([[1,2,3],[3,2,2],[5,4,2]],2,2,[[[1 ],[ 2],[1],[3]],[[1 ],[ 2],[3 ],[4]],[[ 1],[2],[ 1],[3]],[[ 1],[ 2],[ 3],[1]]],[[[0],[0]],[[0],[0]]],X).
%conv2D_layer([[1,2],[1,2]],1,1,[[[1 ]],[[ 2 ]],[[ 1]],[[ 2]]],[0,0,0,0]],X).
%conv2D_layer([[1,2,3],[3,2,2],[5,4,2]],2,2,[[[1 ],[ 2],[1],[3]],[[1 ],[ 2],[3 ],[4]],[[ 1],[2],[ 1],[3]],[[ 1],[ 2],[ 3],[1]]],[4,3,2,1],X).


%conv2D_layer([[1,2,3],[3,2,2],[5,4,2]],2,2,[[[[1]],[[ 2 ]]],[[[ 3 ]],[[ 4]]]],[1],X).

%conv2D_layer([[1]],1,1,[[[[1]]]],[1],X).

/*
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
	nth0_2D_temp(KX1,KY1,Ws,[W|_]),
	comp_conv2D_temp(Res0,Is,X1,Y1,W,Res1),
	(X1 < X+KX-1 -> X2 is X1 + 1,Y2 is Y1;X2 is X,Y2 is Y1+1),
	apply_conv2Dkernel(Is,X,Y,X2,Y2,KX,KY,Ws,Res1,Res).
	
comp_conv2D_temp(Rs, Is, X,Y, Ws, R2s) :- Rs == [], length(Ws,L), empty_list(L,RTs), comp_conv2D_temp(RTs, Is, X,Y, Ws, [], R2s).
comp_conv2D_temp(Rs, Is, X,Y, Ws, R2s) :- comp_conv2D_temp(Rs, Is, X,Y, Ws, [], R2s).		
comp_conv2D_temp([],_,_,_,[], R2s, R2s).
comp_conv2D_temp([R0|R0s], Is, X,Y, [W|Ws], R1s, R2s) :-
	nth0_2D_temp(X,Y,Is,I),
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
	nth0_3D_temp(KX1,KY1,KZ1,Ws,[W|_]),
	comp_conv3D_temp(Res0,Is,X1,Y1,Z1,W,Res1),
	(X1 < X+KX-1 -> X2 is X1 + 1,Y2 is Y1, Z2 is Z1;(Y1 < Y+KY-1 -> X2 is X,Y2 is Y1+1,Z2 is Z1; X2 is X, Y2 is Y, Z2 is Z1 + 1)),
	apply_conv3Dkernel(Is,X,Y,Z,X2,Y2,Z2,KX,KY,KZ,Ws,Res1,Res).
	
	
comp_conv3D_temp(Rs, Is, X,Y,Z, Ws, R2s) :- Rs == [], length(Ws,L), empty_list(L,RTs), comp_conv3D_temp(RTs, Is, X,Y,Z, Ws, [], R2s).
comp_conv3D_temp(Rs, Is, X,Y,Z, Ws, R2s) :- comp_conv3D_temp(Rs, Is, X,Y,Z, Ws, [], R2s).		
comp_conv3D_temp([],_,_,_,_,[], R2s, R2s).
comp_conv3D_temp([R0|R0s], Is, X,Y,Z, [W|Ws], R1s, R2s) :-
	nth0_3D_temp(X,Y,Z,Is,I),
	R1 is R0 + I * W, 
	append(R1s,[R1],R1Ts),
	comp_conv3D_temp(R0s, Is, X,Y,Z, Ws, R1Ts, R2s).
*/


%conv_pool1D_layer([[[I|Is0]|Is1]|Is],KernelSize,Os):- atomic(I), length([I|Is0],L), encapsulate_atoms([[[I|Is0]|Is1]|Is],TIs),
%	pool2D_layer(sum_list,TIs,KernelSize,L,Os).
%conv_pool1D_layer(Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os):-
%	pool2D_layer(sum_list,Is,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,Os).	

%conv_pool1D_layer([[[1,2,3,4],[4,3,2,1]]],1,[[[-0.32467753, -0.0531255 ,  0.12337923],[ 0.29796362, -0.10625941, -0.76591384],[-0.578306  , -0.12482834, -0.47245014],[-0.6056595 , -0.49180904, -0.09586048]]],[0,0,0],X).

%apply_dilation1D([[[0.964], [0.542]], [[0.035], [0.052]]],2,2,X,Y).
%apply_dilation1D([[[0.43, 0.389], [0.424, 0.087], [0.899, 0.544]], [[0.379, 0.932], [0.667, 0.258], [0.403, 0.881]], [[0.914, 0.074], [0.231, 0.337], [0.462, 0.917]]],3,2,X,Y).




conv1D_layer(Is,KernelSize,Os):- 
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,false),
	pool1D_layer(sum_list,Is,KernelSize,1,false,[],[],false,Os).
conv1D_layer(Is,KernelSize,IWs,Bs,Os):- 
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,false),
	calc_conv1D_weight_shape(Is,KernelSize,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	pool1D_layer(sum_list,Is,KernelSize,1,false,IWs,Bs,false,Os).
conv1D_layer(Is,KernelSize,IWs,Bs,Strides,Padding,Os):- 
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,Padding),
	calc_conv1D_weight_shape(Is,KernelSize,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	pool1D_layer(sum_list,Is,KernelSize,Strides,Padding,IWs,Bs,false,Os).
conv1D_layer(Is,KernelSize,IWs,Bs,Strides,Padding,DilationRate,Os):-
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,Padding),
	calc_conv1D_weight_shape(Is,KernelSize,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	check_valid_dilation(Is,KernelSize,DilationRate,Padding),
 	apply_dilation1D(IWs,KernelSize,DilationRate,KernelSize1,IWs1),
	pool1D_layer(sum_list,Is,KernelSize1,Strides,Padding,IWs1,Bs,false,Os).
	
calc_conv1D_weight_shape([I|_],KernelSize,Bs, Shape) :-
	S0 = [KernelSize],
	sub_length(I,SL1),
	append(S0,[SL1],S2),
	length(Bs,L),
	append(S2,[L],Shape).
	
apply_dilation1D(IWs,KernelSize,DilationRate,KernelSize,IWs) :- KernelSize =1; DilationRate < 2.
apply_dilation1D(IWs,KernelSize,DilationRate,KernelSize1,IWs1) :- DilationRate1 is DilationRate - 1, apply_dilation1D(IWs,KernelSize,DilationRate1,_,[],IWs1),length(IWs1,KernelSize1).
apply_dilation1D([],_,_,_,IWs1,IWs1).
apply_dilation1D([W|IWs],KernelSize,DilationRate,_,IWs0,IWsR) :-
	length([W|IWs],L),L > 1,
	replace_atoms_with(W,0,W1),
	multiplicate(W1,DilationRate,WTs),
	append(IWs0,[W],IWs1),
	append(IWs1,WTs,IWs2),
	apply_dilation1D(IWs,KernelSize,DilationRate,_,IWs2,IWsR).
apply_dilation1D([W|IWs],KernelSize,DilationRate,_,IWs0,IWsR) :-
	length([W|IWs],L),L = 1,
	append(IWs0,[W],IWs1),
	apply_dilation1D(IWs,KernelSize,DilationRate,_,IWs1,IWsR).



conv2D_layer(Is,KernelSizeD1,KernelSizeD2,Os):- 
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,false),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,1,1,false,[],[],false,Os).
conv2D_layer(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,Os):- 
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,false),
	calc_conv2D_weight_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,1,1,false,IWs,Bs,false,Os).
conv2D_layer(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,Os):- 
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,Padding),
	calc_conv2D_weight_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,false,Os).
conv2D_layer(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,DilationRateD1,DilationRateD2,Os):-
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,Padding),
	calc_conv2D_weight_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	check_valid_dilation(Is,KernelSizeD1,KernelSizeD2,DilationRateD1,DilationRateD2,Padding),
 	apply_dilation2D(IWs,KernelSizeD1,KernelSizeD2,DilationRateD1,DilationRateD2,KernelSize1D1,KernelSize1D2,IWs1),
	pool2D_layer(sum_list,Is,KernelSize1D1,KernelSize1D2,StridesD1,StridesD2,Padding,IWs1,Bs,false,Os).
	
calc_conv2D_weight_shape([I|_],KernelSizeD1,KernelSizeD2,Bs, Shape) :-
	S0 = [KernelSizeD1,KernelSizeD2],
	sub_sub_length(I,SL1),
	append(S0,[SL1],S2),
	length(Bs,L),
	append(S2,[L],Shape).
	
apply_dilation2D(IWs,KernelSizeD1,KernelSizeD2,DilationRateD1,DilationRateD2,KernelSize1D1,KernelSize1D2,[W|IWs1]) :- 
	DilationRate1D1 is DilationRateD1 - 1, 
	apply_dilation2D(IWs,KernelSizeD1,KernelSizeD2,DilationRate1D1,DilationRateD2,_,_,[],[W|IWs1]),
	length([W|IWs1],KernelSize1D1),length(W,KernelSize1D2).
apply_dilation2D([],_,_,_,_,_,_,IWs1,IWs1).
apply_dilation2D([W|IWs],KernelSizeD1,KernelSizeD2,DilationRateD1,DilationRateD2,_,_,IWs0,IWsR) :-
	DilationRateD1 >0,
	length([W|IWs],L),L > 1,
	apply_dilation1D(W,KernelSizeD2,DilationRateD2,_,W1),
	replace_atoms_with(W1,0,W2),
	multiplicate(W2,DilationRateD1,WTs),
	append(IWs0,[W],IWs1),
	append(IWs1,WTs,IWs2),
	apply_dilation2D(IWs,KernelSizeD1,KernelSizeD2,DilationRateD1,DilationRateD2,_,_,IWs2,IWsR).
apply_dilation2D([W|IWs],KernelSizeD1,KernelSizeD2,DilationRateD1,DilationRateD2,_,_,IWs0,IWsR) :-
	(DilationRateD1 <1;(length([W|IWs],L),L = 1)),
	apply_dilation1D(W,KernelSizeD2,DilationRateD2,_,W1),
	append(IWs0,[W1],IWs1),
	apply_dilation2D(IWs,KernelSizeD1,KernelSizeD2,DilationRateD1,DilationRateD2,_,_,IWs1,IWsR).



conv3D_layer(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Os):- 
	check_dimensions(Is,5),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,false),
	pool3D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,1,1,1,false,[],[],false,Os).
conv3D_layer(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,Bs,Os):- 
	check_dimensions(Is,5),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,false),
	calc_conv3D_weight_shape(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	pool3D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,1,1,1,false,IWs,Bs,false,Os).
conv3D_layer(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,Bs,StridesD1,StridesD2,StridesD3,Padding,Os):- 
	check_dimensions(Is,5),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Padding),
	calc_conv3D_weight_shape(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	pool3D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,StridesD1,StridesD2,StridesD3,Padding,IWs,Bs,false,Os).
conv3D_layer(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,Bs,StridesD1,StridesD2,StridesD3,Padding,DilationRateD1,DilationRateD2,DilationRateD3,Os):-
	check_dimensions(Is,5),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Padding),%TODO DilationRate
	calc_conv3D_weight_shape(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	check_valid_dilation(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,DilationRateD1,DilationRateD2,DilationRateD3,Padding),
 	apply_dilation3D(IWs,KernelSizeD1,KernelSizeD2,KernelSizeD3,DilationRateD1,DilationRateD2,DilationRateD3,KernelSize1D1,KernelSize1D2,KernelSize1D3,IWs1),
	pool3D_layer(sum_list,Is,KernelSize1D1,KernelSize1D2,KernelSize1D3,StridesD1,StridesD2,StridesD3,Padding,IWs1,Bs,false,Os).

calc_conv3D_weight_shape([I|_],KernelSizeD1,KernelSizeD2,KernelSizeD3,Bs, Shape) :-
	S0 = [KernelSizeD1,KernelSizeD2,KernelSizeD3],
	sub_sub_sub_length(I,SL1),
	append(S0,[SL1],S2),
	length(Bs,L),
	append(S2,[L],Shape).	

apply_dilation3D(IWs,KernelSizeD1,KernelSizeD2,KernelSizeD3,DilationRateD1,DilationRateD2,DilationRateD3,KernelSize1D1,KernelSize1D2,KernelSize1D3,[[W|IWs0]|Ws1]) :- 
	DilationRate1D1 is DilationRateD1 - 1, 
	apply_dilation3D(IWs,KernelSizeD1,KernelSizeD2,KernelSizeD3,DilationRate1D1,DilationRateD2,DilationRateD3,_,_,_,[],[[W|IWs0]|Ws1]),
	length([[W|IWs0]|Ws1],KernelSize1D1),length([W|IWs0],KernelSize1D2),length(W,KernelSize1D3).
apply_dilation3D([],_,_,_,_,_,_,_,_,_,IWs1,IWs1).
apply_dilation3D([W|IWs],KernelSizeD1,KernelSizeD2,KernelSizeD3,DilationRateD1,DilationRateD2,DilationRateD3,_,_,_,IWs0,IWsR) :-
	DilationRateD1 >0,
	length([W|IWs],L),L > 1,
	apply_dilation2D(W,KernelSizeD2,KernelSizeD3,DilationRateD2,DilationRateD3,_,_,W1),
	replace_atoms_with(W1,0,W2),
	multiplicate(W2,DilationRateD1,WTs),
	append(IWs0,[W],IWs1),
	append(IWs1,WTs,IWs2),
	apply_dilation3D(IWs,KernelSizeD1,KernelSizeD2,KernelSizeD3,DilationRateD1,DilationRateD2,DilationRateD3,_,_,_,IWs2,IWsR).
apply_dilation3D([W|IWs],KernelSizeD1,KernelSizeD2,KernelSizeD3,DilationRateD1,DilationRateD2,DilationRateD3,_,_,_,IWs0,IWsR) :-
	(DilationRateD1 <1;(length([W|IWs],L),L = 1)),
	apply_dilation2D(W,KernelSizeD2,KernelSizeD3,DilationRateD2,DilationRateD3,_,_,W1),
	append(IWs0,[W1],IWs1),
	apply_dilation3D(IWs,KernelSizeD1,KernelSizeD2,KernelSizeD3,DilationRateD1,DilationRateD2,DilationRateD3,_,_,_,IWs1,IWsR).




%separable_conv1D_layer([[[1],[2],[3]]],2,[[[[1]],[[1]]],[[[ 1 , 2,  1]]]],[0,0,0],X).
separable_conv1D_layer(Is,KernelSize,Os):- 
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,false),
	pool1D_layer(sum_list,Is,KernelSize,1,false,[],[],false,Os).
separable_conv1D_layer(Is,KernelSize,[IWs1,IWs2],Bs,Os):- 
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,false),
	calc_separable_conv1D_weight1_shape(Is,KernelSize,Bs,Shape1),
	shape(IWs1,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	calc_separable_conv1D_weight2_shape(Is,KernelSize,Bs,Shape3),
	shape(IWs2,Shape4),
	check_valid_weight_shape(Is,Shape3,Shape4),
	pool1D_layer(sum_list,Is,KernelSize,1,false,[[],IWs1,IWs2],Bs,false,Os).
separable_conv1D_layer(Is,KernelSize,[IWs1,IWs2],Bs,Strides,Padding,Os):- 
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,Padding),
	calc_separable_conv1D_weight1_shape(Is,KernelSize,Bs,Shape1),
	shape(IWs1,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	calc_separable_conv1D_weight2_shape(Is,KernelSize,Bs,Shape3),
	shape(IWs2,Shape4),
	check_valid_weight_shape(Is,Shape3,Shape4),
	pool1D_layer(sum_list,Is,KernelSize,Strides,Padding,[[],IWs1,IWs2],Bs,false,Os).
	
check_separable_conv_weights([IWts,IWs1,IWs2]) :-
	length([IWts,IWs1,IWs2],L), L = 3,
	IWts = [].
	
calc_separable_conv1D_weight1_shape([I|_],KernelSize,_, Shape) :-
	S0 = [KernelSize],
	sub_length(I,SL1),
	append(S0,[SL1],S2),
	append(S2,[1],Shape).

calc_separable_conv1D_weight2_shape([I|_],_,Bs, Shape) :-
	S0 = [1],
	sub_length(I,L),
	append(S0,[L],S2),
	length(Bs,L1),
	append(S2,[L1],Shape).



separable_conv2D_layer(Is,KernelSizeD1,KernelSizeD2,Os):- 
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,false),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,1,1,false,[],[],false,Os).
separable_conv2D_layer(Is,KernelSizeD1,KernelSizeD2,[IWs1,IWs2],Bs,Os):- 
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,false),
	calc_separable_conv2D_weight1_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape1),
	shape(IWs1,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	calc_separable_conv2D_weight2_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape3),
	shape(IWs2,Shape4),
	check_valid_weight_shape(Is,Shape3,Shape4),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,1,1,false,[[],IWs1,IWs2],Bs,false,Os).
separable_conv2D_layer(Is,KernelSizeD1,KernelSizeD2,[IWs1,IWs2],Bs,StridesD1,StridesD2,Padding,Os):- 
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,Padding),
	calc_separable_conv2D_weight1_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape1),
	shape(IWs1,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	calc_separable_conv2D_weight2_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape3),
	shape(IWs2,Shape4),
	check_valid_weight_shape(Is,Shape3,Shape4),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,StridesD1,StridesD2,Padding,[[],IWs1,IWs2],Bs,false,Os).
	
calc_separable_conv2D_weight1_shape([I|_],KernelSizeD1,KernelSizeD2,_, Shape) :-
	S0 = [KernelSizeD1,KernelSizeD2],
	sub_sub_length(I,SL1),
	append(S0,[SL1],S2),
	append(S2,[1],Shape).
	
calc_separable_conv2D_weight2_shape([I|_],_,_,Bs, Shape) :-
	S0 = [1,1],
	sub_sub_length(I,L),
	append(S0,[L],S2),
	length(Bs,L1),
	append(S2,[L1],Shape).



conv1D_transpose([[I|Is0]|Is],KernelSize,IWs,[B|Bs],Strides,Padding,Os) :-
	atomic(I),
	length([[I|Is0]|Is],LX), 
        OutX is LX * Strides + max(KernelSize - Strides, 0),
	empty_list([B|Bs],OutX,Os0),
        conv1D_transpose([[I|Is0]|Is],0,KernelSize,IWs,[B|Bs],Strides,Padding,Os0,Os).
conv1D_transpose_layer(Is,KernelSize,IWs,Bs,Strides,Padding,Os) :-
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,Padding),
	calc_conv1D_transpose_weight_shape(Is,KernelSize,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
        conv1D_transpose(Is,KernelSize,IWs,Bs,Strides,Padding,[],Os).
conv1D_transpose([],_,_,_,_,_,Os,Os).
conv1D_transpose([[I|Is0]|Is],KernelSize,IWs,Bs,Strides,Padding,Os0,Os) :-
	is_list(I),
	conv1D_transpose([I|Is0],KernelSize,IWs,Bs,Strides,Padding,O),
	append(Os0,[O],Os1),
        conv1D_transpose(Is,KernelSize,IWs,Bs,Strides,Padding,Os1,Os).
conv1D_transpose([[I|Is0]|Is],X,_,_,_,_,false,Os,Os) :-
	atomic(I),
	length([[I|Is0]|Is],LX), 
	X >= LX.
conv1D_transpose([[I|Is0]|Is],X,KernelSize,_,_,Strides,true,Os0,Os) :-
	atomic(I),
	length([[I|Is0]|Is],LX),
	X >= LX,
	CroppingL is floor((max(KernelSize - Strides, 0))/2),
        CroppingR is max(KernelSize - Strides, 0) - CroppingL,
        %CroppingT is floor((max(KernelSizeD2 - StridesD2, 0))/2),
        %CroppingB is max(KernelSizeD2 - StridesD2, 0) - CroppingT,
	apply_cropping_top_bottom(CroppingL, CroppingR,Os0, Os).
	%apply_cropping_left_right(CroppingL, CroppingR,Os0, Os).
conv1D_transpose([[I|Is0]|Is],X,KernelSize,IWs,Bs,Strides,Padding,Os0,Os) :-
	atomic(I),
	%length([[I|Is0]|Is],LX), 
	%X < LX - 1,
	conv1D_transpose_pool_res([[I|Is0]|Is],X,0,KernelSize,Strides,IWs,Bs,Os0,Os1),
	X1 is X + 1,
	conv1D_transpose([[I|Is0]|Is],X1,KernelSize,IWs,Bs,Strides,Padding,Os1,Os).
	
conv1D_transpose_pool_res(Is,X,Y,PoolSize,Strides,IWs,Bs,Os0,Os) :- 
	conv1D_transpose_pool_res(Is,X,Y,0,PoolSize,Strides,IWs,Bs,Os0,Os).
conv1D_transpose_pool_res([I|_],_,Y,KX,PoolSize,_,_,_,Os,Os) :-
	(KX >= PoolSize;(length(I,LY), Y >= LY)).
conv1D_transpose_pool_res(Is,X,Y,KX,PoolSize,Strides,IWs,Bs,Os0,Os) :-
	OutX is (X * Strides) + KX,
	nth0(OutX,Os0,OldO),
	nth0(KX,IWs,Ws0),
	nth0_from_sublist(Y,Ws0,Ws),
	nth0_2D(X,Y,Is,I),
	multiply_each_list_element_with(Ws,I,Add),
	add_lists(OldO,Add,NewO),
	%writeln(NewO),
	insert_pool_field(Os0,NewO,false,OutX,1,Os1),
	((KX < PoolSize-1  -> KX1 is KX+1, Y1 is Y);
	(KX1 is 0, Y1 is Y + 1)),
	conv1D_transpose_pool_res(Is,X,Y1,KX1,PoolSize,Strides,IWs,Bs,Os1,Os).
	
calc_conv1D_transpose_weight_shape([I|_],KernelSize,Bs, Shape) :-
	S0 = [KernelSize],
	sub_length(I,L0),
	length(Bs,L),
	append(S0,[L],S2),
	append(S2,[L0],Shape).	



conv2D_transpose([[[I|Is0]|Is1]|Is],KernelSizeD1,KernelSizeD2,IWs,[B|Bs],StridesD1,StridesD2,Padding,Os) :-
	atomic(I),
	length([[[I|Is0]|Is1]|Is],LX), 
	length([[I|Is0]|Is1],LY), 
	%length([B|Bs],NN),
        %OutX is (LX - 1) * StridesD1 + KernelSizeD1,
        OutX is LX * StridesD1 + max(KernelSizeD1 - StridesD1, 0),
        %OutY is (LY - 1) * StridesD2 + KernelSizeD2,
        OutY is LY * StridesD2 + max(KernelSizeD2 - StridesD2, 0),
        %empty_field(OutX,OutY,NN,Os0),
	empty_field2D([B|Bs],OutX,OutY,Os0),
        conv2D_transpose([[[I|Is0]|Is1]|Is],0,0,KernelSizeD1,KernelSizeD2,IWs,[B|Bs],StridesD1,StridesD2,Padding,Os0,Os).
conv2D_transpose_layer(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,Os) :-
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,Padding),
	calc_conv2D_transpose_weight_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	%is_list(I),
        conv2D_transpose(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,[],Os).
conv2D_transpose([],_,_,_,_,_,_,_,Os,Os).
conv2D_transpose([[[I|Is0]|Is1]|Is],KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,Os0,Os) :-
	is_list(I),
	conv2D_transpose([[I|Is0]|Is1],KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,O),
	append(Os0,[O],Os1),
        conv2D_transpose(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,Os1,Os).
conv2D_transpose([[[I|Is0]|Is1]|Is],X,Y,_,_,_,_,_,_,false,Os,Os) :-
	atomic(I),
	((length([[[I|Is0]|Is1]|Is],LX), X >= LX); 
	(length([[I|Is0]|Is1],LY), Y >= LY)).
conv2D_transpose([[[I|Is0]|Is1]|Is],X,Y,KernelSizeD1,KernelSizeD2,_,_,StridesD1,StridesD2,true,Os0,Os) :-
	atomic(I),
	length([[[I|Is0]|Is1]|Is],LX),
	length([[I|Is0]|Is1],LY),
	(X >= LX; Y >= LY),
	CroppingL is floor((max(KernelSizeD1 - StridesD1, 0))/2),
        CroppingR is max(KernelSizeD1 - StridesD1, 0) - CroppingL,
        CroppingT is floor((max(KernelSizeD2 - StridesD2, 0))/2),
        CroppingB is max(KernelSizeD2 - StridesD2, 0) - CroppingT,
	apply_cropping_top_bottom(CroppingL, CroppingR,Os0, Os1),
	apply_cropping_left_right(CroppingT, CroppingB,Os1, Os).
conv2D_transpose([[[I|Is0]|Is1]|Is],X,Y,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,Os0,Os) :-
	atomic(I),
	length([[[I|Is0]|Is1]|Is],LX), 
	%length([[I|Is0]|Is1],LY), 
	conv2D_transpose_pool_res([[[I|Is0]|Is1]|Is],X,Y,0,KernelSizeD1,KernelSizeD2,StridesD1,StridesD2,IWs,Bs,Os0,Os1),
	(X < LX - 1 -> X1 is X + 1, Y1 is Y; X1 is 0, Y1 is Y + 1),
	conv2D_transpose([[[I|Is0]|Is1]|Is],X1,Y1,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,Os1,Os).

conv2D_transpose_pool_res(Is,X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,Os0,Os) :- 
	%writeln(X),
	%writeln(Y),
	conv2D_transpose_pool_res(Is,X,Y,Z,0,0,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,Os0,Os).
conv2D_transpose_pool_res([[I|_]|_],_,_,Z,KX,KY,PoolSizeD1,PoolSizeD2,_,_,_,_,Os,Os) :-
	(KX >= PoolSizeD1;KY >=  PoolSizeD2;(length(I,LZ), Z >= LZ)).
conv2D_transpose_pool_res(Is,X,Y,Z,KX,KY,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,Os0,Os) :-
	OutX is (X * StridesD1) + KX,
	OutY is (Y * StridesD2) + KY,
	nth0_2D(OutX,OutY,Os0,OldO),
	nth0_2D(KX,KY,IWs,Ws0),
	nth0_from_sublist(Z,Ws0,Ws),
	nth0_3D(X,Y,Z,Is,I),
	multiply_each_list_element_with(Ws,I,Add),
	add_lists(OldO,Add,NewO),
	%writeln(NewO),
	insert_pool_field(Os0,NewO,false,OutX,OutY,1,Os1),
	((KX < PoolSizeD1-1  -> KX1 is KX+1, KY1 is KY,   Z1 is Z);
	((KY < PoolSizeD2-1  -> KX1 is 0,    KY1 is KY+1, Z1 is Z); 
			       (KX1 is 0,    KY1 is 0,    Z1 is Z+1))),
	conv2D_transpose_pool_res(Is,X,Y,Z1,KX1,KY1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,Os1,Os).

%conv2D_transpose_pool_res([[[1],[2]],[[1],[1]]],1,0,0,4,4,1,1,[[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]]],[[0]],[[[[1]],[[1]],[[1]],[[1]],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]]],X).
%conv2D_transpose_pool_res([[[1],[2]],[[1],[1]]],0,0,0,4,4,1,1,[[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]]],[[0]],[[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]]],X).
calc_conv2D_transpose_weight_shape([I|_],KernelSizeD1,KernelSizeD2,Bs, Shape) :-
	S0 = [KernelSizeD1,KernelSizeD2],
	sub_sub_length(I,L0),
	length(Bs,L),
	append(S0,[L],S2),
	append(S2,[L0],Shape).	
	
%conv2D_transpose_layer([[[[1], [2]], [[1], [1]]]],4,4,[[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]]],[[0]],1,1,false,X).
%conv2D_transpose_layer([[[[1]]]],1,1,[[[[1]]]],[0],1,1,false,X).





%conv3D_transpose_pool_res([[[1],[2]],[[1],[1]]],1,0,0,0,4,4,1,1,[[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]]],[[0]],[[[[1]],[[1]],[[1]],[[1]],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]]],X).
%conv3D_transpose_pool_res([[[1],[2]],[[1],[1]]],0,0,0,0,4,4,1,1,[[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]],[[1]]]],[[0]],[[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]],[[0],[0],[0],[0],[0]]],X).
conv3D_transpose([[[[I|Is0]|Is1]|Is2]|Is],KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,[B|Bs],StridesD1,StridesD2,StridesD3,Padding,Os) :-
	atomic(I),
	length([[[[I|Is0]|Is1]|Is2]|Is],LX), 
	length([[[I|Is0]|Is1]|Is2],LY), 
	length([[I|Is0]|Is1],LZ),
        %OutX is (LX - 1) * StridesD1 + KernelSizeD1,
        OutX is LX * StridesD1 + max(KernelSizeD1 - StridesD1, 0),
        %OutY is (LY - 1) * StridesD2 + KernelSizeD2,
        OutY is LY * StridesD2 + max(KernelSizeD2 - StridesD2, 0),
        OutZ is LZ * StridesD3 + max(KernelSizeD3 - StridesD3, 0),
        %empty_field(OutX,OutY,NN,Os0),
	empty_field3D([B|Bs],OutX,OutY,OutZ,Os0),
        conv3D_transpose([[[[I|Is0]|Is1]|Is2]|Is],0,0,0,KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,[B|Bs],StridesD1,StridesD2,StridesD3,Padding,Os0,Os).
conv3D_transpose_layer(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,Bs,StridesD1,StridesD2,StridesD3,Padding,Os) :-
	check_dimensions(Is,5),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Padding),
	calc_conv3D_transpose_weight_shape(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Bs,Shape1),
	shape(IWs,Shape2),
	%writeln(Shape1),
	%writeln(Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	writeln("checks done"),
	%is_list(I),
        conv3D_transpose(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,Bs,StridesD1,StridesD2,StridesD3,Padding,[],Os).
conv3D_transpose([],_,_,_,_,_,_,_,_,_,Os,Os).
conv3D_transpose([[[[I|Is0]|Is1]|Is2]|Is],KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,Bs,StridesD1,StridesD2,StridesD3,Padding,Os0,Os) :-
	is_list(I),
	conv3D_transpose([[[I|Is0]|Is1]|Is2],KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,Bs,StridesD1,StridesD2,StridesD3,Padding,O),
	append(Os0,[O],Os1),
        conv3D_transpose(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,Bs,StridesD1,StridesD2,StridesD3,Padding,Os1,Os).
conv3D_transpose([[[[I|Is0]|Is1]|Is2]|Is],X,Y,Z,_,_,_,_,_,_,_,_,false,Os,Os) :-
	atomic(I),
	((length([[[[I|Is0]|Is1]|Is2]|Is],LX), X >= LX); 
	(length([[[I|Is0]|Is1]|Is2],LY), Y >= LY);
	(length([[I|Is0]|Is1],LZ), Z >= LZ)).
conv3D_transpose([[[[I|Is0]|Is1]|Is2]|Is],X,Y,Z,KernelSizeD1,KernelSizeD2,KernelSizeD3,_,_,StridesD1,StridesD2,StridesD3,true,Os0,Os) :-
	atomic(I),
	length([[[[I|Is0]|Is1]|Is2]|Is],LX), 
	length([[[I|Is0]|Is1]|Is2],LY), 
	length([[I|Is0]|Is1],LZ),
	(X >= LX; Y >= LY; Z >= LZ),
	CroppingD1L is floor((max(KernelSizeD1 - StridesD1, 0))/2),
        CroppingD1R is max(KernelSizeD1 - StridesD1, 0) - CroppingD1L,
        CroppingD2L is floor((max(KernelSizeD2 - StridesD2, 0))/2),
        CroppingD2R is max(KernelSizeD2 - StridesD2, 0) - CroppingD2L,
        CroppingD3L is floor((max(KernelSizeD3 - StridesD3, 0))/2),
        CroppingD3R is max(KernelSizeD3 - StridesD3, 0) - CroppingD3L,
        cropping3D_layer(Os0, CroppingD1L,CroppingD1R,CroppingD2L,CroppingD2R,CroppingD3L,CroppingD3R, [], Os).
        %apply_cropping_top_bottom(CroppingD1L, CroppingD1R,Os0, Os1),
	%apply_cropping_top_bottom(CroppingD2L, CroppingD2R,Os1, Os2),
	%apply_cropping_left_right(CroppingD3L, CroppingD3R,Os2, Os).
conv3D_transpose([[[[I|Is0]|Is1]|Is2]|Is],X,Y,Z,KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,Bs,StridesD1,StridesD2,StridesD3,Padding,Os0,Os) :-
	atomic(I),
	length([[[[I|Is0]|Is1]|Is2]|Is],LX), 
	length([[[I|Is0]|Is1]|Is2],LY), 
	conv3D_transpose_pool_res([[[[I|Is0]|Is1]|Is2]|Is],X,Y,Z,0,KernelSizeD1,KernelSizeD2,KernelSizeD3,StridesD1,StridesD2,StridesD3,IWs,Bs,Os0,Os1),
	(X < LX - 1 -> (X1 is X + 1, Y1 is Y, Z1 is Z); 
	(Y < LY - 1 -> (X1 is 0, Y1 is Y + 1, Z1 is Z);
		       (X1 is 0, Y1 is 0, Z1 is Z + 1))),
	conv3D_transpose([[[[I|Is0]|Is1]|Is2]|Is],X1,Y1,Z1,KernelSizeD1,KernelSizeD2,KernelSizeD3,IWs,Bs,StridesD1,StridesD2,StridesD3,Padding,Os1,Os).

conv3D_transpose_pool_res(Is,X,Y,Z,Z1,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,IWs,Bs,Os0,Os) :- 
	conv3D_transpose_pool_res(Is,X,Y,Z,Z1,0,0,0,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,IWs,Bs,Os0,Os).
conv3D_transpose_pool_res([[[I|_]|_]|_],_,_,_,Z1,KX,KY,KZ,PoolSizeD1,PoolSizeD2,PoolSizeD3,_,_,_,_,_,Os,Os) :-
	(KX >= PoolSizeD1;KY >=  PoolSizeD2;KZ >=PoolSizeD3;(length(I,LZ1), Z1 >= LZ1)).
conv3D_transpose_pool_res(Is,X,Y,Z,Z1,KX,KY,KZ,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,IWs,Bs,Os0,Os) :-
	OutX is (X * StridesD1) + KX,
	OutY is (Y * StridesD2) + KY,
	OutZ is (Z * StridesD3) + KZ,
	nth0_3D(OutX,OutY,OutZ,Os0,OldO),
	nth0_3D(KX,KY,KZ,IWs,Ws0),
	nth0_from_sublist(Z1,Ws0,Ws),
	nth0_4D(X,Y,Z,Z1,Is,I),
	multiply_each_list_element_with(Ws,I,Add),
	add_lists(OldO,Add,NewO),
	%writeln(NewO),
	insert_pool_field(Os0,NewO,false,OutX,OutY,OutZ,1,1,Os1),
	((KX < PoolSizeD1-1  -> KX1 is KX+1, KY1 is KY,   KZ1 is KZ,   Z2 is Z1);
	((KY < PoolSizeD2-1  -> KX1 is 0,    KY1 is KY+1, KZ1 is KZ,   Z2 is Z1);
	((KZ < PoolSizeD3-1  -> KX1 is 0,    KY1 is 0,    KZ1 is KZ+1, Z2 is Z1);  
			       (KX1 is 0,    KY1 is 0,    KZ1 is 0,    Z2 is Z1+1)))),
	conv3D_transpose_pool_res(Is,X,Y,Z,Z2,KX1,KY1,KZ1,PoolSizeD1,PoolSizeD2,PoolSizeD3,StridesD1,StridesD2,StridesD3,IWs,Bs,Os1,Os).

calc_conv3D_transpose_weight_shape([I|_],KernelSizeD1,KernelSizeD2,KernelSizeD3,Bs, Shape) :-
	S0 = [KernelSizeD1,KernelSizeD2,KernelSizeD3],
	sub_sub_sub_length(I,L0),
	length(Bs,L),
	append(S0,[L],S2),
	append(S2,[L0],Shape).

depthwise_conv1D_layer(Is,KernelSize,Os):-
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,false),
	pool1D_layer(sum_list,Is,KernelSize,1,false,[],[],true,Os).
depthwise_conv1D_layer(Is,KernelSize,IWs,Bs,Os):-
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,false),
	calc_depthwise_conv1D_weight_shape(Is,KernelSize,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	pool1D_layer(sum_list,Is,KernelSize,1,false,IWs,Bs,true,Os).
depthwise_conv1D_layer(Is,KernelSize,IWs,Bs,Strides,Padding,Os):-
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,Padding),
	calc_depthwise_conv1D_weight_shape(Is,KernelSize,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	pool1D_layer(sum_list,Is,KernelSize,Strides,Padding,IWs,Bs,true,Os).
depthwise_conv1D_layer(Is,KernelSize,IWs,Bs,Strides,Padding,DilationRate,Os):-
	check_dimensions(Is,3),
	% check_pool_input_match(Is,KernelSize,Padding), TODO check dilation
	calc_depthwise_conv1D_weight_shape(Is,KernelSize,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	check_valid_dilation(Is,KernelSize,DilationRate,Padding),
	apply_dilation1D(IWs,KernelSize,DilationRate,KernelSize,IWs1),
	pool1D_layer(sum_list,Is,KernelSize,Strides,Padding,IWs1,Bs,true,Os).
	
calc_depthwise_conv1D_weight_shape([I|_],KernelSize,_,Shape):-
	S0 = [KernelSize],
	sub_length(I,L),
	append(S0,[L],S2),
	append(S2,[1],Shape).

depthwise_conv2D_layer(Is,KernelSizeD1,KernelSizeD2,Os):- 
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,false),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,1,1,false,[],[],true,Os).
depthwise_conv2D_layer(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,Os):- 
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,false),
	calc_depthwise_conv2D_weight_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,1,1,false,IWs,Bs,true,Os).
depthwise_conv2D_layer(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,Os):- 
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,Padding),
	calc_depthwise_conv2D_weight_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,true,Os).
depthwise_conv2D_layer(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Padding,DilationRateD1,DilationRateD2,Os):-
 	check_dimensions(Is,4),
 	%check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,Padding),TODO check dilation
	calc_depthwise_conv2D_weight_shape(Is,KernelSizeD1,KernelSizeD2,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	check_valid_dilation(Is,KernelSizeD1,KernelSizeD2,DilationRateD1,DilationRateD2,Padding),
 	apply_dilation2D(IWs,KernelSizeD1,KernelSizeD2,DilationRateD1,DilationRateD2,KernelSize1D1,KernelSize1D2,IWs1),
	pool2D_layer(sum_list,Is,KernelSize1D1,KernelSize1D2,StridesD1,StridesD2,Padding,IWs1,Bs,true,Os).

calc_depthwise_conv2D_weight_shape([I|_],KernelSizeD1,KernelSizeD2,_, Shape) :-
	S0 = [KernelSizeD1,KernelSizeD2],
	sub_sub_length(I,L),
	append(S0,[L],S2),
	append(S2,[1],Shape).


