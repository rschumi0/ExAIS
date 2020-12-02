:- [util].
:- [math].
:- [helperlayer].
:- [conv].
:- [locallyconnected].
:- [activation].
:- [pooling].
:- [concatenate].
:- [recurrent].

%dense_layer([1,2],[[3,4],[5,6]],[2,3],X).
%dense_layer([1,2,4],[[3,4],[5,6],[3,4]],[2,3],X).
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
  
  
  

	



	

	

	
	

	
