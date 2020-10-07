%?- dense_layer1D([4,9],[[5,8],[7,6]],[4,3],X). 
% X = [87, 89] 

%?- dense_layer1D([1,2,3],[[2,3,4],[5,4,6],[7,6,8]],[2,3,4],X).
% X = [35, 32, 44] 

% ?-dense_layer1D([4,3,4,5],[[5,8,5],[7,6,6],[3,5,7],[3,5,4]],[4,3,5,6],X).
% X = [72, 98, 91] 

% ?- dense_layer1D([4,3,4,5,6],[[5,8,5],[7,6,6],[3,5,7],[3,5,4],[3,4,5]],[4,3,5,6,7],X).
% X = [90, 122, 121] 

% output = activation(dot(input, weight_data) + bias)
% bias value as 0

:- use_module(library(clpfd)).

dense_layer1D(Is,IWs,OWs,Os) :- 
   transpose(IWs,IWs1),  
   dense_layer(Is,IWs1,OWs,[],Os).  

dense_layer(_,[],_,Os,Os).

dense_layer(Is,[IW|IWs],[OW|OWs],Os1,Os) :-
  cal_output(Is,IW,OW,O),
  append(Os1,[O],Os2),
  dense_layer(Is,IWs,OWs,Os2,Os).

cal_output(Is,IWs,OW,Res) :- 
   output_comp(Is,IWs,OW,OW,Res).
   output_comp([],[],_,Res,Res). 

   output_comp([I|Is],[IW|IWs],OW,Res0,Res) :- 
   Res1 is Res0 + I * IW,
   output_comp(Is,IWs,OW,Res1,Res).