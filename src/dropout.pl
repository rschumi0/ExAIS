:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-[util].

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
    

dropout_layer(Is, Os, Rate, Succ) :- 
	count_atoms(Is,N),
	count_occurrences(Is,0,NZeroOrig),
	count_occurrences(Os,0,NZeroNew),
	RealRate is (NZeroNew - NZeroOrig) / (N -NZeroOrig),
	Diff is abs(Rate - RealRate),
	(Diff > 0.1 -> (write("Expected Rate: "), writeln(Rate), write(" Actual Rate: "), writeln(RealRate), write(" "),  Succ = false); Succ = true).
	
all_true([], true).	
all_true([I|_],false) :- I == false.
all_true([I|Is],Succ) :- I == true, all_true(Is,Succ).
	
	

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
	
	
spatial_dropout1D_layer(Is, Os, Rate, Succ) :-
	dropout_layer(Is, Os, Rate, Succ1),
	spatial_dropout1D_feature_check(Is, Os, Succ2),
	writeln(Succ1),
	writeln(Succ2),
	((Succ1 == true, Succ2 == true) ->  Succ = true; Succ = false).
	
	

all_zero([]).
all_zero([H|T]) :-
    H == 0,
    all_zero(T).

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
	

