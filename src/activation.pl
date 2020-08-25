%relu_layer([3,2,1,-2,-0.1],2,1,0.5,O).
relu_layer([],_,_,_,[]).
relu_layer([I|Is],Max_Value,Negative_Slope,Threshold,[O|Os]) :-
	atomic(I),
	(I < Threshold -> I1 is I * Negative_Slope + (-Threshold *Negative_Slope);I1 is I),
	(number(Max_Value) -> O is min(I1,Max_Value); O is I1),
	relu_layer(Is,Max_Value,Negative_Slope,Threshold,Os).
relu_layer([I|Is],Max_Value,Negative_Slope,Threshold,[O|Os]) :-
	is_list(I),
	relu_layer(I,Max_Value,Negative_Slope,Threshold,O),
	relu_layer(Is,Max_Value,Negative_Slope,Threshold,Os).

   

%thresholded_relu_layer([0.138821,0.30971956,0.23123252,0.26585793,0.65178293,0.54254425,0.8526051,0.1260066,0.4059227],0.26,X).
thresholded_relu_layer([],_,[]).
thresholded_relu_layer([I|Is],Theta,[O|Os]) :-
	atomic(I),
	(I > Theta -> O is I;O is 0),
	thresholded_relu_layer(Is,Theta,Os).
thresholded_relu_layer([I|Is],Theta,[O|Os]) :-
	is_list(I),
	thresholded_relu_layer(I,Theta,O),
	thresholded_relu_layer(Is,Theta,Os).
	
%leakyrelu_layer([-0.138821,-0.30971956,0.23123252,0.26585793,0.65178293,0.54254425,0.8526051,0.1260066,0.4059227],0.26,X).
leakyrelu_layer([],_,[]).
leakyrelu_layer([I|Is],Alpha,[O|Os]) :-
	atomic(I),
	(I < 0 -> O is Alpha * I;O is I),
	leakyrelu_layer(Is,Alpha,Os).
leakyrelu_layer([I|Is],Alpha,[O|Os]) :-
	is_list(I),
	leakyrelu_layer(I,Alpha,O),
	leakyrelu_layer(Is,Alpha,Os).
