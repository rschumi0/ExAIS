:-[util].

relu_layer_clp([I|Is],Max_Value,Negative_Slope,Threshold,[O|Os]) :-
    is_list(I),
    relu_layer_clp(I,Max_Value,Negative_Slope,Threshold,O),
    relu_layer_clp(Is,Max_Value,Negative_Slope,Threshold,Os).
    
relu_layer_clp([],_,_,_,[]).
relu_layer_clp([I|Is],Max_Value,Negative_Slope,Threshold,[O|Os]) :-
    not(is_list(I)),%atomic(I),
    I #< Threshold,
    I1 #= I * Negative_Slope + (-Threshold *Negative_Slope),
    O #= min(I1,Max_Value),
    relu_layer_clp(Is,Max_Value,Negative_Slope,Threshold,Os).
    
relu_layer_clp([I|Is],Max_Value,Negative_Slope,Threshold,[O|Os]) :-
    not(is_list(I)),%atomic(I),
    I #>= Threshold,
    I1 #= I,
    O #= min(I1,Max_Value),
    relu_layer_clp(Is,Max_Value,Negative_Slope,Threshold,Os).
    

    
dense_layer_clp([], _, _, []).
dense_layer_clp([[I|Is]|Is1], IWs, Bs, [O|Os]) :-
	%depth([I|Is],D),
	%D > 2,
	is_list(I),
	dense_layer_clp([I|Is], IWs, Bs, O),
	dense_layer_clp(Is1, IWs, Bs, Os).
dense_layer_clp([I|Is], IWs, Bs, [O|Os]) :- 
	is_list(I),%depth([I|Is],2),
	dense_node_comp_clp(I, IWs, Bs, O),
	dense_layer_clp(Is, IWs, Bs, Os).
   
dense_node_comp_clp([],[],Res,Res).
dense_node_comp_clp([I|Is],[IW|IWs],Res0,Res) :-
	multiply_each_list_element_with_clp(IW,I,Res1),
	add_lists_clp(Res0,Res1,Res2),
	dense_node_comp_clp(Is,IWs,Res2,Res).
	

add_lists_clp([],[],[]).
add_lists_clp([X|Xs],[Y|Ys],[Z|Zs]) :-
	Z #= X + Y ,
	add_lists_clp(Xs,Ys,Zs).	
	
multiply_each_list_element_with_clp([],_,[]).
multiply_each_list_element_with_clp([X|Xs],A,[Y|Ys]) :-
	Y #= X * A,
	multiply_each_list_element_with_clp(Xs,A,Ys).
	
	
sigmoid_layer_clp([],[]).
sigmoid_layer_clp(X,Y) :-
	sigmoid_comp_clp([X],[Y]).
sigmoid_layer_clp([X|Xs],Y) :-
	sigmoid_comp_clp([X|Xs],Y).
sigmoid_layer_clp([X|Xs],[Y|Ys]) :-
	is_list(X),
	sigmoid_layer_clp(X,Y),
	sigmoid_layer_clp(Xs,Ys).
	
sigmoid_comp_clp([],[]).
sigmoid_comp_clp([I|Is],[0|Ys]):-
	I #< -709,
	sigmoid_comp(Is,Ys).
sigmoid_comp_clp([I|Is],[Y|Ys]):-
	I #> -710,
	I1 #= I * -1 ,
	E #= 1 + exp(I1), 
	Y #= 1 // E,
	sigmoid_comp(Is,Ys).