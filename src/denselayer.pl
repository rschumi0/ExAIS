:- use_module(library(clpfd)).

% dense_layer([[1,2,3]],[[2,3,4],[5,4,6],[7,6,8]],[2,3,4],X).
% dense_layer([[4,3,4,5]],[[5,8,5],[7,6,6],[3,5,7],[3,5,4]],[4,3,5,6],X).
% dense_layer([[4,3,4,5,6]],[[5,8,5],[7,6,6],[3,5,7],[3,5,4],[3,4,5]],[4,3,5,6,7],X).

dense_layer([], _, _, []).
dense_layer([I|Is], IWs, Bs, [O|Os]) :- 
	depth([I|Is],D),
	D > 2,
	dense_layer(I, IWs, Bs, O),
	dense_layer(Is, IWs, Bs, Os).
dense_layer([I|Is], IWs, Bs, [O|Os]) :- 
	depth([I|Is],2),
	dense_node_comp(I, IWs, Bs, O),
	dense_layer(Is, IWs, Bs, Os).
   
dense_node_comp([],[],Res,Res).
dense_node_comp([I|Is],[IW|IWs],Res0,Res) :-
	multiply_each_list_element_with(IW,I,Res1),
	add_lists(Res0,Res1,Res2),
	dense_node_comp(Is,IWs,Res2,Res).

 
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
 