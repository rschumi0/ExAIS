:- use_module(library(clpfd)).

% dense_layer([[1,2,3]],[[2,3,4],[5,4,6],[7,6,8]],[2,3,4],X).
% dense_layer([[4,3,4,5]],[[5,8,5],[7,6,6],[3,5,7],[3,5,4]],[4,3,5,6],X).
% dense_layer([[4,3,4,5,6]],[[5,8,5],[7,6,6],[3,5,7],[3,5,4],[3,4,5]],[4,3,5,6,7],X).

dense_layer(Is, IWs, Bs, Os) :-
	calc_dense_weight_shape(Is,Bs,Shape1),
	shape(IWs,Shape2),
	check_valid_weight_shape(Is,Shape1,Shape2), 
	dense(Is, IWs, Bs, Os).

dense([], _, _, []).
dense([I|Is], IWs, Bs, [O|Os]) :-
	depth([I|Is],D),
	D > 2,
	dense(I, IWs, Bs, O),
	dense(Is, IWs, Bs, Os).
dense([I|Is], IWs, Bs, [O|Os]) :- 
	depth([I|Is],2),
	dense_node_comp(I, IWs, Bs, O),
	dense(Is, IWs, Bs, Os).
   
dense_node_comp([],[],Res,Res).
dense_node_comp([I|Is],[IW|IWs],Res0,Res) :-
	multiply_each_list_element_with(IW,I,Res1),
	add_lists(Res0,Res1,Res2),
	dense_node_comp(Is,IWs,Res2,Res).
	
calc_dense_weight_shape([],_, _).
calc_dense_weight_shape([I|Is],Bs, [L,L1]) :-
	atomic(I),
	length([I|Is],L),
	length(Bs,L1).
calc_dense_weight_shape([I|_],Bs, Shape) :- 
    is_list(I),
	calc_dense_weight_shape(I,Bs, Shape).



/*  
dense_layer([], _, _, []).
dense_layer([I|Is], IWs, Bs, [O|Os]) :- 
	dense_node_comp(I, IWs, Bs, O),
	dense_layer(Is, IWs, Bs, Os).

dense_layer(Is,IWs,Bs,Os) :- 
	dense_node_comp(Is, IWs, Bs,Os).
  
dense_node_comp(_,_,Res,Res).
dense_node_comp([I|Is],[IW|IWs],Res0,Res) :-
	multiply_each_list_element_with(IW,I,Res1),
	add_lists(Res0,Res1,Res2),
	dense_node_comp(Is,IWs,Res2,Res).
*/

%dense_layer([1,2],[[3,4],[5,6]],[2,3],X).
%dense_layer([1,2,4],[[3,4],[5,6],[3,4]],[2,3],X).
/*
dense_layer(Is,IWs,OWs,Os) :- invert_2Dlist(IWs,IWs1),  dense_layer(Is,IWs1,OWs,[],Os).	
dense_layer(_,[],_,Os,Os).
dense_layer(Is,[IW|IWs],[OW|OWs],Os1,Os) :-
	dense_layer_comp(Is,IW,OW,O),
	append(Os1,[O],Os2),
	dense_layer(Is,IWs,OWs,Os2,Os).

dense_layer_comp(Is,IWs,OW,Res) :- dense_layer_comp(Is,IWs,OW,OW,Res).
dense_layer_comp([],[],_,Res,Res). 
dense_layer_comp([I|Is],[IW|IWs],OW,Res0,Res) :- 
  Res1 is Res0 + I * IW,
  dense_layer_comp(Is,IWs,OW,Res1,Res).
 */
 