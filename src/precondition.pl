:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-use_module(library(cplint_util)).
:-[util].

exec_layers([],[],_,_).
exec_layers([L|Layers],[N|LayerNames],OutVar, OutVarName) :-
	catch(call_with_time_limit(120,L), E, (write("Aborted at "), write(N), write(": "), write(E), writeln("!!!"),abort)),
	write("Layer "), write(N),writeln(" executed successfully"),
	(length(Layers,0) -> write(OutVarName), write(" = "), writeln(OutVar);true),
	exec_layers(Layers,LayerNames,OutVar, OutVarName).

check_dimensions(Is, D) :-
	depth(Is,D1), 
	%writeln("D1"),
	%writeln(D1),
	%writeln("D"),
	%writeln(D),
	(D1 =\= D -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Dimension error, Input Shape ",
		    shape(Is,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).
		    
		    
check_max_dimensions(Is, D) :-
	depth(Is,D1), 
	(D1 > D -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Dimension error, Input Shape ",
		    shape(Is,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).
		    
check_min_dimensions(Is, D) :-
	depth(Is,D1), 
	(D1 < D -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Dimension error, Input Shape ",
		    shape(Is,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).		   
		    
check_same_dimensions(I1,I2) :-
	depth(I1,D1),
	depth(I2,D2),
	(D1 =\= D2 -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D2,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Inconsistent Input Dimensions, Input Shape ",
		    shape(I1,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).
		    
check_same_and_max_dimensions(I1,I2,Max) :-
	depth(I1,D1),
	depth(I2,D2),
	(D1 > Max -> 
		(D2 > Max->(write("Invalid Model, Badness Value: "), 
			    BV is (D1-Max)+(D2-Max),BV1 is BV*210000000, writeln(BV1),  
			    S1 = "Dimension error, Input Shape ",
			    shape(I1,Shape),
			    term_string(Shape,S2),
			    string_concat(S1,S2,S),
			    throw(S));
			    (write("Invalid Model, Badness Value: "), 
			    BV is (D1-Max),BV1 is BV*230000000, writeln(BV1),  
			    S1 = "Dimension error, Input Shape ",
			    shape(I1,Shape),
			    term_string(Shape,S2),
			    string_concat(S1,S2,S),
			    throw(S)));
		 (D2 > Max->(write("Invalid Model, Badness Value: "), 
			    BV is (D2-Max),BV1 is BV*210000000, writeln(BV1),  
			    S1 = "Dimension error, Input Shape ",
			    shape(I2,Shape),
			    term_string(Shape,S2),
			    string_concat(S1,S2,S),
			    throw(S));true)),
	(D1 =\= D2 -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D2,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Inconsistent Input Dimensions, Input Shape ",
		    shape(I1,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).
		    
check_same_dimensions_different_input(Is,I1,I2) :-
	depth(I1,D1),
	depth(I2,D),
	(D1 =\= D -> (write("Invalid Model, Badness Value: "), 
		    BV is D1-D,BV1 is BV*100000000, writeln(BV1),  
		    S1 = "Inconsistent Input Dimensions, Input Shape ",
		    shape(Is,Shape),
		    term_string(Shape,S2),
		    string_concat(S1,S2,S),
		    throw(S));true).
	
	
check_same_shape(I1,I2) :-
	check_same_dimensions(I1,I2),
	%shape(I1,Shape1),
	%shape(I2,Shape2),
	%writeln(Shape1),
	%writeln(Shape2),
	(not(compare_structure(I1,I2)) -> (write("Invalid Model, Badness Value: "), 
		    		 	   compute_different_shape_badness(I1,I2,B),
		    			   writeln(B), 
		    			   S1 = "Inconsistent Input Shapes, Input Shape ",
		    			   shape(I1,Shape),
		    			   term_string(Shape,S2),
		    			   string_concat(S1,S2,S),
		    			   throw(S));true).	
check_same_shape(I1,I2,I3) :-
	check_same_shape(I1,I2),
	check_same_shape(I2,I3).
	
check_same_shape([]).
check_same_shape(Is) :- length(Is,1).
check_same_shape([I1,I2|Is]) :-
	check_same_shape(I1,I2),
	check_same_shape([I2|Is]).
	
	
compute_different_shape_badness(I1,I2, Badness) :-
 	depth(I1,1),
 	length(I1,L1),
 	length(I2,L2),
 	Badness is abs(L1-L2).
 	
compute_different_shape_badness([I1|Is1],[I2|Is2], Badness) :-
 	depth([I1|Is1],D),
 	D>=2,
 	length(Is1,L1),
 	length(Is2,L2),
 	pow(100,D-1,Factor),
 	compute_different_shape_badness(I1,I2,InnerBadness),
 	Badness is Factor*abs(L1-L2) + InnerBadness.	


check_pool_input_match(_, _, true).
check_pool_input_match(Is,PoolSize, false) :-
	sub_length(Is,D1),
	(D1 < PoolSize -> (write("Invalid Model, Badness Value: "), 
		    	   BV is D1-PoolSize, writeln(BV),   
		           throw("Shape Error"));true).	

check_pool_input_match(_, _, _, true).
check_pool_input_match(Is,PoolSizeD1, PoolSizeD2, false) :-
	sub_length(Is,D1),
	(D1 < PoolSizeD1 -> (write("Invalid Model, Badness Value: "), 
			     BV1 is D1-PoolSizeD1, writeln(BV1),   
	    		     throw("Shape Error"));true),
	sub_sub_length(Is,D2),
	(D2 < PoolSizeD2 -> (write("Invalid Model, Badness Value: "), 
	    		     BV2 is D2-PoolSizeD2, writeln(BV2),   
	                     throw("Shape Error"));true).
	                     
check_pool_input_match(_, _, _, _, true).
check_pool_input_match(Is,PoolSizeD1, PoolSizeD2, PoolSizeD3, false) :-
	sub_length(Is,D1),
	(D1 < PoolSizeD1 -> (write("Invalid Model, Badness Value: "), 
			     BV1 is D1-PoolSizeD1, writeln(BV1),   
	    		     throw("Shape Error"));true),
	sub_sub_length(Is,D2),
	(D2 < PoolSizeD2 -> (write("Invalid Model, Badness Value: "), 
	    		     BV2 is D2-PoolSizeD2, writeln(BV2),   
	                     throw("Shape Error"));true),
	sub_sub_sub_length(Is,D3),
	(D3 < PoolSizeD3 -> (write("Invalid Model, Badness Value: "), 
	    		     BV3 is D3-PoolSizeD3, writeln(BV3),   
	                     throw("Shape Error"));true).	
	                     
check_valid_reshape([I|Is],Ss) :-
	shape(I,S),
	list_product(Ss,P),
	list_product(S,P1),
	(P =\= P1 -> (writeln("Invalid Model, Badness Value: 1000000000"),
			 S1 = "Reshape Error, Input Shape ",
			 shape([I|Is],ShapeT),
			 term_string(ShapeT,S2),
			 string_concat(S1,S2,ST),
			 throw(ST));true).
                     
check_valid_reshapeOld([I|Is],Ss) :-
	shape(I,S),
	list_product(Ss,P),
	list_product(S,P1),
	(P =\= P1 -> (
	(list_butlast(Ss,Ss1),not(is_sublist(S,Ss1))) ->
		(writeln("Invalid Model, Badness Value: 1000000000"),
		 S1 = "Reshape Error, Input Shape ",
		 shape([I|Is],ShapeT),
		 term_string(ShapeT,S2),
		 string_concat(S1,S2,ST),
		 throw(ST));
		true);
	true).
check_empty_cropping(Is,[]) :-
	writeln("Invalid Model, Badness Value: 1000000000"),
	S1 = "Cropping Error, Input Shape ",
	shape(Is,ShapeT),
	term_string(ShapeT,S2),
	string_concat(S1,S2,ST),
	throw(ST).
check_empty_cropping(_,O) :- number(O).
check_empty_cropping(Is, [O|_]) :-
	check_empty_cropping(Is,O).

	                     	                     
check_valid_arguments(Is, A1,A2) :-
	(A1 =\= A2 -> (write("Invalid Model, Badness Value: "), 
    		     BV is A1-A2, writeln(BV),  
    		     S1 = "Argument Error, Input Shape ",
    	             shape(Is,Shape),
    	             term_string(Shape,S2),
    		     string_concat(S1,S2,S), 
                     throw(S));true).
                     
check_smaller_arguments(Is, A1,A2) :-
	(A1 >= A2 -> (write("Invalid Model, Badness Value: "), 
    		     BV is A1-A2, writeln(BV),  
    		     S1 = "Argument Error, Input Shape ",
    	             shape(Is,Shape),
    	             term_string(Shape,S2),
    		     string_concat(S1,S2,S), 
                     throw(S));true).
                     
check_valid_weight_shape(_, [],[]).                    	                                          
check_valid_weight_shape(Is, [S|Shape],[S1|WsShape]) :-
	check_valid_arguments(Is,S,S1),
	check_valid_weight_shape(Is,Shape,WsShape).

check_same_shape_arg(I1,I2) :-
	check_same_dimensions(I1,I2),
	(not(compare_structure(I1,I2)) -> (write("Invalid Model, Badness Value: "), 
		    		 	   compute_different_shape_badness(I1,I2,B),
		    			   writeln(B), 
		    			   S1 = "Argument Error, Input Shape ",
		    			   shape(I1,Shape),
		    			   term_string(Shape,S2),
		    			   string_concat(S1,S2,S),
		    			   throw(S));true).
		    			   
check_same_shape_arg_different_input(Is,I1,I2) :-
	check_same_dimensions_different_input(Is,I1,I2),
	(not(compare_structure(I1,I2)) -> (write("Invalid Model, Badness Value: "), 
		    		 	   compute_different_shape_badness(I1,I2,B),
		    			   writeln(B), 
		    			   S1 = "Argument Error, Input Shape ",
		    			   shape(Is,Shape),
		    			   term_string(Shape,S2),
		    			   string_concat(S1,S2,S),
		    			   throw(S));true).
		    			   
check_same_shape_lists(Shape1,Shape2) :-
	(not(compare_lists(Shape1,Shape2)) -> (write("Invalid Model, Badness Value: "), 
		    		 	   %compute_different_shape_badness(I1,I2,B),
		    			   writeln("100"), 
		    			   S1 = "Argument Error, Input Shape ",
		    			   term_string(Shape1,S2),
		    			   string_concat(S1,S2,S),
		    			   throw(S));true).