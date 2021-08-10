:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-[util].



dropout_layer(Is, Os, Rate, Succ) :- 
	count_atoms(Is,N),
	count_occurrences(Is,0,NZeroOrig),
	count_occurrences(Os,0,NZeroNew),
	RealRate is (NZeroNew - NZeroOrig) / (N -NZeroOrig),
	Diff is abs(Rate - RealRate),
	(Diff > 0.1 -> (write("Expected Rate: "), writeln(Rate), write(" Actual Rate: "), writeln(RealRate), write(" "),  Succ = false); Succ = true).

count_atoms([],0).
count_atoms([H|T], R):- 
	is_list(H),
	count_atoms(H,R1),
	count_atoms(T,R2),
	R is R1 + R2.
count_atoms([H|T1], R):-  
	atomic(H),         
    	count_atoms(T1, R1),
    	R is R1 + 1.
    	
count_occurrences([],_,0).
count_occurrences([H|T], S, R):- 
	is_list(H),
	count_occurrences(H,S,R1),
	count_occurrences(T,S,R2),
	R is R1 + R2.
count_occurrences([H|T1], S, R):-  
	atomic(S),  
	H == S,      
    	count_occurrences(T1, S, R1),
    	R is R1 + 1.
count_occurrences([H|T1], S, R):-  
	atomic(H),  
	H =\= S,        
    	count_occurrences(T1, S, R).	




alpha_dropout_layer([I|Is], [O|Os], Rate, Succ) :- 
	is_list(I), alpha_dropout_layer([I|Is], [O|Os], Rate, [], Succ).
alpha_dropout_layer(Is, Os, Rate, Succ) :- 
	depth(Is,1),
	count_atoms(Is,N),
	count_smaller_than(Is,0,NZeroOrig),
	count_smaller_than(Os,0,NZeroNew),
	RealRate is (NZeroNew - NZeroOrig) / (N -NZeroOrig),
	Diff is abs(Rate - RealRate),
	avg(Is,OriginalMean),
	avg(Os,NewMean),
	MeanDiff is abs(OriginalMean - NewMean),
	variance(Is,OriginalVar),
	variance(Os,NewVar),
	VarDiff is abs(OriginalVar - NewVar),	
	(Diff > 0.1 -> (write("Expected Rate: "), writeln(Rate), write(" Actual Rate: "), writeln(RealRate),  Succ = false); 
	(MeanDiff > 5 -> (write("Original Mean: "), writeln(OriginalMean), write(" New Mean: "), writeln(NewMean),  Succ = false);
	(VarDiff > 5 -> (write("Original Variance: "), writeln(OriginalVar), write(" New Variance: "), writeln(NewVar),Succ=false);Succ = true))).
alpha_dropout_layer([], [], _, SuccL, Succ) :- all_true(SuccL,Succ).
alpha_dropout_layer([I|Is], [O|Os], Rate, SuccL, Succ) :-
	alpha_dropout_layer(I, O, Rate, SuccN),
	append(SuccL,[SuccN],SuccL1),
	alpha_dropout_layer(Is, Os, Rate, SuccL1,Succ).	
	
all_true([], true).	
all_true([I|_],false) :- I == false.
all_true([I|Is],Succ) :- I == true, all_true(Is,Succ).

count_smaller_than([],_,0).
count_smaller_than([H|T], S, R):- 
	is_list(H),
	count_smaller_than(H,S,R1),
	count_smaller_than(T,S,R2),
	R is R1 + R2.
count_smaller_than([H|T1], S, R):-  
	atomic(S),  
	H < S,      
    	count_smaller_than(T1, S, R1),
    	R is R1 + 1.
count_smaller_than([H|T1], S, R):-  
	atomic(H),  
	H >= S,        
    	count_smaller_than(T1, S, R).



spatial_dropout1D_layer(Is, Os, Rate, Succ) :-
	dropout_layer(Is, Os, Rate, Succ1),
	spatial_dropout1D_feature_check(Is, Os, Succ2),
	writeln(Succ1),
	writeln(Succ2),
	((Succ1 == true, Succ2 == true) ->  Succ = true; Succ = false).
	
spatial_dropout1D_feature_check(Is, Os, Succ) :- 
	spatial_dropout1D_feature_check(Is, Os, [], Succ).
spatial_dropout1D_feature_check([I|Is], [O|Os], SuccL, Succ) :-
	depth([I|Is],3),
	spatial_dropout1D_feature_check(I, O, SuccN),
	append(SuccL,[SuccN],SuccL1), 
	spatial_dropout1D_feature_check(Is, Os, SuccL1, Succ).
spatial_dropout1D_feature_check([], [], SuccL, Succ) :- all_true(SuccL,Succ).
spatial_dropout1D_feature_check([[I|Is0]|Is], [[O|Os0]|Os], SuccL, Succ) :- 
	atomic(I),
	del_first_items([[I|Is0]|Is],_,R),
	del_first_items([[O|Os0]|Os],F1,R1),
	((I =\= 0, O == 0) -> (all_zero(F1) -> SuccN = true;SuccN =false);SuccN=true),
	append(SuccL,[SuccN],SuccL1),
	spatial_dropout1D_feature_check(R,R1, SuccL1, Succ).

all_zero([]).
all_zero([H|T]) :-
    H == 0,
    all_zero(T).



spatial_dropout2D_layer(Is, Os, Rate, Succ) :-
	dropout_layer(Is, Os, Rate, Succ1),
	spatial_dropout2D_feature_check(Is, Os, Succ2),
	writeln(Succ1),
	writeln(Succ2),
	((Succ1 == true, Succ2 == true) ->  Succ = true; Succ = false).
	
spatial_dropout2D_feature_check(Is, Os, Succ) :- 
	spatial_dropout2D_feature_check(Is, Os, [], Succ).
spatial_dropout2D_feature_check([I|Is], [O|Os], SuccL, Succ) :-
	depth([I|Is],4),
	spatial_dropout2D_feature_check(I, O, SuccN),
	append(SuccL,[SuccN],SuccL1), 
	spatial_dropout2D_feature_check(Is, Os, SuccL1, Succ).
spatial_dropout2D_feature_check([], [], SuccL, Succ) :- all_true(SuccL,Succ).
spatial_dropout2D_feature_check([[[I|Is0]|Is1]|Is], [[[O|Os0]|Os1]|Os], SuccL, Succ) :- 
	atomic(I),
	del_first_items([[[I|Is0]|Is1]|Is],F,R),
	del_first_items([[[O|Os0]|Os1]|Os],F1,R1),
	spatial_dropout1D_feature_check(F,F1,SuccN),
	%((I =\= 0, O == 0) -> (all_zero(F1) -> SuccN = true;SuccN =false);SuccN=true),
	append(SuccL,[SuccN],SuccL1),
	spatial_dropout2D_feature_check(R,R1, SuccL1, Succ).



spatial_dropout3D_layer(Is, Os, Rate, Succ) :-
	dropout_layer(Is, Os, Rate, Succ1),
	spatial_dropout3D_feature_check(Is, Os, Succ2),
	writeln(Succ1),
	writeln(Succ2),
	((Succ1 == true, Succ2 == true) ->  Succ = true; Succ = false).
	
spatial_dropout3D_feature_check(Is, Os, Succ) :- 
	spatial_dropout3D_feature_check(Is, Os, [], Succ).
spatial_dropout3D_feature_check([I|Is], [O|Os], SuccL, Succ) :-
	depth([I|Is],4),
	spatial_dropout3D_feature_check(I, O, SuccN),
	append(SuccL,[SuccN],SuccL1), 
	spatial_dropout3D_feature_check(Is, Os, SuccL1, Succ).
spatial_dropout3D_feature_check([], [], SuccL, Succ) :- all_true(SuccL,Succ).
spatial_dropout3D_feature_check([[[[I|Is0]|Is1]|Is2]|Is], [[[[O|Os0]|Os1]|Os2]|Os], SuccL, Succ) :- 
	atomic(I),
	del_first_items([[[[I|Is0]|Is1]|Is2]|Is],F,R),
	del_first_items([[[[O|Os0]|Os1]|Os2]|Os],F1,R1),
	spatial_dropout2D_feature_check(F,F1,SuccN),
	append(SuccL,[SuccN],SuccL1),
	spatial_dropout3D_feature_check(R,R1, SuccL1, Succ).



%gaussian_noise_layer([1,2,3,4,5,6,7,8,9,10],[1.0001044, 1.9990835, 2.9983914, 3.9985507, 5.0002775, 6.0013294,6.9997735, 7.99828  , 9.000185 , 9.999998 ],0.001,X).	
gaussian_noise_layer(Is, Os, SD, Succ) :- 
	flatten(Is,Is1), flatten(Os,Os1), length(Is1,N), SD2 is 2 * SD,
	gaussian_noise_layer(Is1, Os1, SD2, 0, N, Succ).
gaussian_noise_layer([], [], _, Within2SD, N, Succ) :-
	R is Within2SD / N,
	(R < 0.9 -> (write("Expected portion within 2SDs: "), writeln(R), write(" Actual portion: "), writeln(R),  Succ = false);(Succ = true)).
gaussian_noise_layer([I|Is], [O|Os], SD2, Within2SD, N, Succ) :-
	Diff is abs(O - I),
	(Diff > SD2 -> Within2SD1 is Within2SD; Within2SD1 is Within2SD +1),
	gaussian_noise_layer(Is, Os, SD2, Within2SD1, N, Succ).



%gaussian_dropout_layer([1,2,3,4,5,6,7,8,9,10],[0.99891865, 1.9996369 , 3.000546  , 4.000738  , 4.9984345 , 5.9959006 ,6.991423  , 7.994241  , 9.007317  , 9.977198],0.000001,X).	
gaussian_dropout_layer(Is, Os, Rate, Succ) :- 
	flatten(Is,Is1), flatten(Os,Os1), length(Is1,N), SD2 is 2 * sqrt(Rate/(1.0-Rate)),
	gaussian_dropout_layer(Is1, Os1, SD2, 0, N, Succ).
gaussian_dropout_layer([], [], _, Within2SD, N, Succ) :-
	R is Within2SD / N,
	(R < 0.9 -> (write("Expected portion within 2SDs: "), writeln(R), write(" Actual portion: "), writeln(R),  Succ = false);(Succ = true)).
gaussian_dropout_layer([I|Is], [O|Os], SD2, Within2SD, N, Succ) :-
	Mult is abs(O / I),
	Diff is abs(1.0 - Mult),
	(Diff > SD2 -> Within2SD1 is Within2SD; Within2SD1 is Within2SD +1),
	gaussian_dropout_layer(Is, Os, SD2, Within2SD1, N, Succ).
