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
	locallyconnected1D_comp_temp(R0s, I, Ws, R1Ts, R2s).*/

/*

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
	nth0_2D_temp(X,Y,OWs,OW),
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
	nth0_2D_temp(X,Y,Is,I),
	R1 is R0 + I * W, 
	append(R1s,[R1],R1Ts),
	comp_locallyconnected2D_temp(R0s, Is, X,Y, Ws, R1Ts, R2s).
	
	
	
locallyconnected3D_layer(Is,KX,KY,KZ,IWs,OWs,Os) :- 
	locallyconnected3D_layer(Is,0,0,0,KX,KY,KZ,IWs,OWs,[],Os).
locallyconnected3D_layer(_,_,_,_,_,_,_,[],_,Os,Os).
locallyconnected3D_layer([[I|I1s]|Is],X,Y,Z,KX,KY,KZ,[IW|IWs],OWs,Os0,Os) :-
	length(I,LX),length([[I|I1s]|Is],LY),
	apply_locallyconnected3Dkernel([[I|I1s]|Is],X,Y,Z,KX,KY,KZ,[IW|IWs],O),
	nth0_3D_temp(X,Y,Z,OWs,OW),
	add_lists(O,OW,O1),
	append(Os0,[O1],Os1),
	(X+KX < LX -> X1 is X + 1,Y1 is Y, Z1 is Z; (Y+KY < LY -> X1 is 0,Y1 is Y+1, Z1 is Z; X1 is 0, Y1 is 0, Z1 is Z + 1)),
	locallyconnected3D_layer([[I|I1s]|Is],X1,Y1,Z1,KX,KY,KZ,[IW|IWs],OWs,Os1,Os).
	
	
apply_locallyconnected3Dkernel(Is,X,Y,Z,KX,KY,KZ,IWs,O) :- apply_locallyconnected3Dkernel(Is,X,Y,Z,X,Y,Z,KX,KY,KZ,IWs,[],O).
apply_locallyconnected3Dkernel(_,_,_,_,_,_,_,_,_,_,[],Res,Res).
%apply_locallyconnected3Dkernel(_,X,Y,Z,X1,Y1,Z1,KX,KY,KZ,[],Res,Res).
	%X1 >= X+KX;Y1 >= Y+KY; Z1 >= Z+KZ.
apply_locallyconnected3Dkernel(Is,X,Y,Z,X1,Y1,Z1,KX,KY,KZ,[W|Ws],Res0,Res) :-
	KX1 is X1 - X,
	KY1 is Y1 - Y,
	KZ1 is Z1 - Z,
	nth0_3D_temp(KX1,KY1,KZ1,Ws,[W|_]),
	comp_locallyconnected3D_temp(Res0,Is,X1,Y1,Z1,W,Res1),
	(X1 < X+KX-1 -> X2 is X1 + 1,Y2 is Y1, Z2 is Z1;(Y1 < Y+KY-1 -> X2 is X,Y2 is Y1+1,Z2 is Z1; X2 is X, Y2 is Y, Z2 is Z1 + 1)),
	apply_locallyconnected3Dkernel(Is,X,Y,Z,X2,Y2,Z2,KX,KY,KZ,Ws,Res1,Res).
	
	
comp_locallyconnected3D_temp(Rs, Is, X,Y,Z, Ws, R2s) :- Rs == [], length(Ws,L), empty_list(L,RTs), comp_locallyconnected3D_temp(RTs, Is, X,Y,Z, Ws, [], R2s).
comp_locallyconnected3D_temp(Rs, Is, X,Y,Z, Ws, R2s) :- comp_locallyconnected3D_temp(Rs, Is, X,Y,Z, Ws, [], R2s).		
comp_locallyconnected3D_temp([],_,_,_,_,[], R2s, R2s).
comp_locallyconnected3D_temp([R0|R0s], Is, X,Y,Z, [W|Ws], R1s, R2s) :-
	nth0_3D_temp(X,Y,Z,Is,I),
	R1 is R0 + I * W, 
	append(R1s,[R1],R1Ts),
	comp_locallyconnected3D_temp(R0s, Is, X,Y,Z, Ws, R1Ts, R2s).	
*/



/*
ArrayList<Integer> kernel_comps_per_dim = new ArrayList<>();
int kernel_comps = (int) Math.ceil((double)(inputShape.get(0) - kernelSizes.get(0) +1) / (double)strides.get(0));
kernel_comps_per_dim.add(kernel_comps);
if(dimensions > 1) {
	kernel_comps_per_dim.add((int) Math.ceil((double)(inputShape.get(1) - kernelSizes.get(1) +1) / (double)strides.get(1)));
	kernel_comps *= kernel_comps_per_dim.get(1);
}
inWS = new ArrayList<>();
inWS.add(kernel_comps);
int tempKernelPlaces = kernelSizes.get(0);
for(int i = 1; i < kernelSizes.size(); i++) {
	tempKernelPlaces = tempKernelPlaces * kernelSizes.get(i);
}
tempKernelPlaces *= inputShape.get(dimensions);
inWS.add(tempKernelPlaces);
inWS.add(nodeNumber);

outWS = new ArrayList<>(kernel_comps_per_dim);//kernelSizes);
//outWS.add(kernel_comps);
outWS.add(nodeNumber);
locally_connected1D_layer([[[0.745], [0.8317]]], 1,[[[0.4935, 0.8662, 0.3557]], [[0.2954, 0.3469, 0.8934]]],[[0, 0, 0], [0, 0, 0]], 1, X)

calc_locally_connected1D_weight1_shape([[[0.745], [0.8317]]],[[0, 0, 0], [0, 0, 0]], 1, 1, X)
calc_locally_connected1D_weight2_shape([[[0.745], [0.8317]]],[[[0.4935, 0.8662, 0.3557]], [[0.2954, 0.3469, 0.8934]]], 1, 1, X)

calc_locally_connected2D_weight1_shape([[[[0.0052], [0.2128]], [[0.0348], [0.0804]]]],[[[0, 0]], [[0, 0]]],1, 2, 1, 1, X)
calc_locally_connected2D_weight2_shape([[[[0.0052], [0.2128]], [[0.0348], [0.0804]]]], [[[0.2671, 0.9108], [0.5449, 0.6011]], [[0.2905, 0.818], [0.3869, 0.616]]],1, 2, 1, 1, X)

*/



locally_connected1D_layer(Is,KernelSize,Os):- 
	check_dimensions(Is,3),
	check_pool_input_match(Is,KernelSize,false),
	pool1D_layer(sum_list,Is,KernelSize,1,false,[],[],false,Os).
locally_connected1D_layer(Is,KernelSize,IWs,Bs,Os):- 
	check_dimensions(Is,3),
	check_weight_dimensions(Is,IWs,3),
	check_weight_dimensions(Is,Bs,2),
	check_pool_input_match(Is,KernelSize,false),
	check_locally_connected1D_weight_shape(Is,KernelSize,IWs,Bs,1),
	pool1D_layer(sum_list,Is,KernelSize,1,false,IWs,Bs,false,Os).
locally_connected1D_layer(Is,KernelSize,IWs,Bs,Strides,Os):- 
	check_dimensions(Is,3),
	check_weight_dimensions(Is,IWs,3),
	check_weight_dimensions(Is,Bs,2),
	check_pool_input_match(Is,KernelSize,false),
	check_locally_connected1D_weight_shape(Is,KernelSize,IWs,Bs,Strides),
	pool1D_layer(sum_list,Is,KernelSize,Strides,false,IWs,Bs,false,Os).
	
check_locally_connected1D_weight_shape(Is,KernelSize,IWs,Bs,Strides) :-
	calc_locally_connected1D_weight1_shape(Is, Bs, KernelSize, Strides, Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	calc_locally_connected1D_weight2_shape(Is, IWs, KernelSize, Strides, Shape3),
	shape(Bs,Shape4),
	check_valid_weight_shape(Is,Shape3,Shape4).

calc_locally_connected1D_weight1_shape(Is, Bs, KernelSize, Strides, Shape) :-
        sub_length(Is,L),
	Kernel_comps is ceiling(((L - KernelSize +1)/Strides)),
	S0 = [Kernel_comps],
	sub_sub_length(Is,L1),
	TempKernelPlaces is L1 * KernelSize,
	append(S0,[TempKernelPlaces],S2),
	sub_length(Bs,SL),
	append(S2,[SL],Shape).
	
calc_locally_connected1D_weight2_shape(Is, IWs, KernelSize, Strides, Shape) :-
        sub_length(Is,L),
	Kernel_comps is ceiling(((L - KernelSize +1)/Strides)),
	S0 = [Kernel_comps],
	sub_sub_length(IWs,SL),
	append(S0,[SL],Shape).



locally_connected2D_layer(Is,KernelSizeD1,KernelSizeD2,Os):- 
	check_dimensions(Is,4),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,false),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,1,1,false,[],[],false,Os).
locally_connected2D_layer(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,Os):- 
	check_dimensions(Is,4),
	check_weight_dimensions(Is,IWs,3),
	check_weight_dimensions(Is,Bs,3),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,false),
	check_locally_connected2D_weight_shape(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,1,1),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,1,1,false,IWs,Bs,false,Os).
locally_connected2D_layer(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2,Os):- 
	check_dimensions(Is,4),
	check_weight_dimensions(Is,IWs,3),
	check_weight_dimensions(Is,Bs,3),
	check_pool_input_match(Is,KernelSizeD1,KernelSizeD2,false),
	check_locally_connected2D_weight_shape(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2),
	pool2D_layer(sum_list,Is,KernelSizeD1,KernelSizeD2,StridesD1,StridesD2,false,IWs,Bs,false,Os).
	
check_locally_connected2D_weight_shape(Is,KernelSizeD1,KernelSizeD2,IWs,Bs,StridesD1,StridesD2) :-
	calc_locally_connected2D_weight1_shape(Is, Bs, KernelSizeD1,KernelSizeD2, StridesD1,StridesD2, Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2),
	calc_locally_connected2D_weight2_shape(Is, IWs, KernelSizeD1,KernelSizeD2, StridesD1,StridesD2, Shape3),
	shape(Bs,Shape4),
	check_valid_weight_shape(Is,Shape3,Shape4).
	
calc_locally_connected2D_weight1_shape(Is, Bs, KernelSizeD1,KernelSizeD2, StridesD1,StridesD2, Shape) :-
        sub_length(Is,L),
	Kernel_comps is ceiling(((L - KernelSizeD1 +1)/StridesD1)),
	sub_sub_length(Is,L1),
	Kernel_comps1 is ceiling(((L1 - KernelSizeD2 +1)/StridesD2)),
	Temp is Kernel_comps * Kernel_comps1,
	S0 = [Temp],
	sub_sub_sub_length(Is,L2),
	TempKernelPlaces is L2 * KernelSizeD1 * KernelSizeD2,
	append(S0,[TempKernelPlaces],S2),
	sub_sub_length(Bs,SL),
	append(S2,[SL],Shape).
	
calc_locally_connected2D_weight2_shape(Is, IWs, KernelSizeD1,KernelSizeD2, StridesD1,StridesD2, Shape) :-
        sub_length(Is,L),
	Kernel_comps is ceiling(((L - KernelSizeD1 +1)/StridesD1)),
	sub_sub_length(Is,L1),
	Kernel_comps1 is ceiling(((L1 - KernelSizeD2 +1)/StridesD2)),
	S0 = [Kernel_comps,Kernel_comps1],
	sub_sub_length(IWs,SL),
	append(S0,[SL],Shape).



