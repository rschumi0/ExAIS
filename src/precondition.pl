:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-use_module(library(cplint_util)).
:-[util].

exec_layers([],[],_,_).
exec_layers([L|Layers],[N|LayerNames],OutVar, OutVarName) :-
	catch(call_with_time_limit(220,L), E, (write("Aborted at "), write(N), write(": "), write(E), writeln("!!!"),abort)),%120
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
			BV is D1-D,BV1 is BV*100000000000000000, writeln(BV1),
			S1 = "Dimension error, Input Shape ",
			shape(Is,Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,RS),
			S3 = ", Expected Dimensions ",
			string_concat(S3,D,RS1),
			string_concat(RS,RS1,S),
			throw(S));true).
			
			
check_max_dimensions(Is, D) :-
	depth(Is,D1),
	(D1 > D -> (write("Invalid Model, Badness Value: "),
			BV is D1-D,BV1 is BV*100000000000000000, writeln(BV1),
			S1 = "Dimension error, Input Shape ",
			shape(Is,Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,RS),
			S3 = ", Expected Max Dimensions ",
			string_concat(S3,D,RS1),
			string_concat(RS,RS1,S),
			throw(S));true).
			
check_min_dimensions(Is, D) :-
	depth(Is,D1),
	(D1 < D -> (write("Invalid Model, Badness Value: "),
			BV is D1-D,BV1 is BV*100000000000000000, writeln(BV1),  
			S1 = "Dimension error, Input Shape ",
			shape(Is,Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,RS),
			S3 = ", Expected Min Dimensions ",
			string_concat(S3,D,RS1),
			string_concat(RS,RS1,S),
			throw(S));true).		   
			
check_same_dimensions(I1,I2) :-
	depth(I1,D1),
	depth(I2,D2),
	(D1 =\= D2 -> (write("Invalid Model, Badness Value: "),
			BV is D1-D2,BV1 is BV*10000000000000000, writeln(BV1),  
			S1 = "Inconsistent Input Dimensions, Input Shape ",
			shape(I1,Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,RS),
			S3 = ", Expected Equal Dimensions ",
			string_concat(S3,D1,S4),
			S5 = " != ",
			string_concat(S4,S5,S6),
			string_concat(S6,D2,RS1),
			string_concat(RS,RS1,S),
			throw(S));true).
			
check_same_and_max_dimensions(I1,I2,Max) :-
	depth(I1,D1),
	depth(I2,D2),
	(D1 > Max -> 
		(D2 > Max->(write("Invalid Model, Badness Value: "),
				BV is (D1-Max)+(D2-Max),BV1 is BV*210000000000000000, writeln(BV1),  
				S1 = "Dimension error, Input Shape ",
				shape(I1,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Max Dimensions ",
				string_concat(S3,D1,RS1),
				string_concat(RS,RS1,S),
				throw(S));
				(write("Invalid Model, Badness Value: "),
				BV is (D1-Max),BV1 is BV*230000000000000000, writeln(BV1),  
				S1 = "Dimension error, Input Shape ",
				shape(I1,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Max Dimensions ",
				string_concat(S3,D1,RS1),
				string_concat(RS,RS1,S),
				throw(S)));
		 (D2 > Max->(write("Invalid Model, Badness Value: "),
				BV is (D2-Max),BV1 is BV*210000000000000000, writeln(BV1),  
				S1 = "Dimension error, Input Shape ",
				shape(I2,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Max Dimensions ",
				string_concat(S3,D2,RS1),
				string_concat(RS,RS1,S),
				throw(S));true)),
	(D1 =\= D2 -> (write("Invalid Model, Badness Value: "),
			BV is D1-D2,BV1 is BV*100000000000000000, writeln(BV1),  
			S1 = "Inconsistent Input Dimensions, Input Shape ",
			shape(I1,Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,RS),
			S3 = ", Expected Equal Dimensions ",
			string_concat(S3,D1,S4),
			S5 = " != ",
			string_concat(S4,S5,S6),
			string_concat(S6,D2,RS1),
			string_concat(RS,RS1,S),
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
						string_concat(S1,S2,RS),
						S3 = ", Expected Shape ",
						shape(I2,Shape2),
						term_string(Shape2,S22),
						string_concat(S3,S22,RS1),
						string_concat(RS,RS1,S),
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
	pow(1000,D-1,Factor),
	compute_different_shape_badness(I1,I2,InnerBadness),
	Badness is Factor*abs(L1-L2) + InnerBadness.	


check_pool_input_match(_, _, true).
check_pool_input_match(Is,PoolSize, false) :-
	sub_length(Is,D1),
	(D1 < PoolSize -> (write("Invalid Model, Badness Value: "),
			BV is D1-PoolSize, writeln(BV),
			S1 = "Pool Shape Error, Input Shape ",
			shape(Is,Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,RS),
			S3 = ", Expected Shape ",
			replace(Shape,1,PoolSize,Shape3),
			term_string(Shape3,S22),
			string_concat(S3,S22,RS1),
			string_concat(RS,RS1,S),
			throw(S));true).

check_pool_input_match(_, _, _, true).
check_pool_input_match(Is,PoolSizeD1, PoolSizeD2, false) :-
	sub_length(Is,D1),
	(D1 < PoolSizeD1 -> (write("Invalid Model, Badness Value: "),
				BV1 is D1-PoolSizeD1, writeln(BV1), 
				S1 = "Pool Shape Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,1,PoolSizeD1,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true),
	sub_sub_length(Is,D2),
	(D2 < PoolSizeD2 -> (write("Invalid Model, Badness Value: "),
				BV2 is D2-PoolSizeD2, writeln(BV2),
				S1 = "Pool Shape Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,2,PoolSizeD2,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true).
				
check_pool_input_match(_, _, _, _, true).
check_pool_input_match(Is,PoolSizeD1, PoolSizeD2, PoolSizeD3, false) :-
	sub_length(Is,D1),
	(D1 < PoolSizeD1 -> (write("Invalid Model, Badness Value: "),
				BV1 is D1-PoolSizeD1, writeln(BV1),   
				S1 = "Pool Shape Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,1,PoolSizeD1,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true),
	sub_sub_length(Is,D2),
	(D2 < PoolSizeD2 -> (write("Invalid Model, Badness Value: "),
				BV2 is D2-PoolSizeD2, writeln(BV2),   
				S1 = "Pool Shape Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,2,PoolSizeD2,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true),
	sub_sub_sub_length(Is,D3),
	(D3 < PoolSizeD3 -> (write("Invalid Model, Badness Value: "),
				BV3 is D3-PoolSizeD3, writeln(BV3),   
				S1 = "Pool Shape Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,3,PoolSizeD3,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true).	


check_valid_dilation(_,_,_,true).				
check_valid_dilation(Is,PoolSize,DilationRate,false):-
	sub_length(Is,D1),
	ED1 is PoolSize + (DilationRate-1)*(D1-1),
	(D1 < ED1 -> (writeln("Invalid Model, Badness Value: "),
				BV1 is D1 - ED1, writeln(BV1),
				S1 = "Dilation Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,1,ED1,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true).

check_valid_dilation(_,_,_,_,_,true).
check_valid_dilation(Is,PoolSizeD1,PoolSizeD2,DilationRateD1,DilationRateD2,false):-
	sub_length(Is,D1),
	ED1 is PoolSizeD1 + (DilationRateD1-1)*(D1-1),
	(D1 < ED1 -> (writeln("Invalid Model, Badness Value: "),
				BV1 is D1 - ED1, writeln(BV1),
				S1 = "Dilation Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,1,ED1,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true),
	sub_sub_length(Is,D2),
	ED2 is PoolSizeD2 + (DilationRateD2-1)*(D2-1),
	(D2 < ED2 -> (writeln("Invalid Model, Badness Value: "),
				BV2 is D2 - ED2, writeln(BV2),
				S1 = "Dilation Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,2,ED2,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true).
		
check_valid_dilation(_,_,_,_,_,_,_,true).	
check_valid_dilation(Is,PoolSizeD1,PoolSizeD2,PoolSizeD3,DilationRateD1,DilationRateD2,DilationRateD3,false):-
	sub_length(Is,D1),
	ED1 is PoolSizeD1 + (DilationRateD1-1)*(D1-1),
	(D1 < ED1 -> (writeln("Invalid Model, Badness Value: "),
				BV1 is D1 - ED1, writeln(BV1),
				S1 = "Dilation Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,1,ED1,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true),
	sub_sub_length(Is,D2),
	ED2 is PoolSizeD2 + (DilationRateD2-1)*(D2-1),
	(D2 < ED2 -> (writeln("Invalid Model, Badness Value: "),
				BV2 is D2 - ED2, writeln(BV2),
				S1 = "Dilation Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,2,ED2,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true),
	sub_sub_sub_length(Is,D3),
	ED3 is PoolSizeD3 + (DilationRateD3-1)*(D3-1),
	(D3 < ED3 -> (writeln("Invalid Model, Badness Value: "),
				BV3 is D3 - ED3, writeln(BV3),
				S1 = "Dilation Error, Input Shape ",
				shape(Is,Shape),
				term_string(Shape,S2),
				string_concat(S1,S2,RS),
				S3 = ", Expected Shape ",
				replace(Shape,3,ED3,Shape3),
				term_string(Shape3,S22),
				string_concat(S3,S22,RS1),
				string_concat(RS,RS1,S),
				throw(S));true).

check_valid_reshape([I|Is],Ss) :-
	shape(I,S),
	list_product(Ss,P),
	list_product(S,P1),
	(P =\= P1 -> (writeln("Invalid Model, Badness Value: 1000000000000000000"),
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
		(writeln("Invalid Model, Badness Value: 1000000000000000000"),
		S1 = "Reshape Error, Input Shape ",
		shape([I|Is],ShapeT),
		term_string(ShapeT,S2),
		string_concat(S1,S2,ST),
		throw(ST));
		true);
	true).
check_empty_cropping(Is,[]) :-
	writeln("Invalid Model, Badness Value: 1000000000000000000"),
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
			
check_equal_weight_shape(Is, A1,A2) :-
	(A1 =\= A2 -> (write("Invalid Model, Badness Value: "),
			BV is A1-A2, writeln(BV),  
			S1 = "Weight Shape Error, Input Shape ",
			shape(Is,Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,S),
			throw(S));true).			
			
check_valid_weight_shape(_, [],[]).
check_valid_weight_shape(Is, [S|Shape],[S1|WsShape]) :-
	check_equal_weight_shape(Is,S,S1),
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


check_same_dimensions_different_input(Is,I1,I2) :-
	depth(I1,D1),
	depth(I2,D2),
	(D1 =\= D2 -> (write("Invalid Model, Badness Value: "),
			BV is D1-D2,BV1 is BV*100000000000000000, writeln(BV1),  
			S1 = "Inconsistent Input Dimensions, Input Shape ",
			shape(Is,Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,RS),
			S3 = ", Expected Equal Dimensions ",
			string_concat(S3,D1,S4),
			S5 = " != ",
			string_concat(S4,S5,S6),
			string_concat(S6,D2,RS1),
			string_concat(RS,RS1,S),
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


check_valid_axis_for_dot([I1|Is1],[I2|Is2],Axis1,Axis2) :-
		A1 is Axis1 - 1,
		A2 is Axis2 - 1,
		shape(I1,Shape1),
		shape(I2,Shape2),
		length(Shape1,L1),
		length(Shape2,L2),
		((A1 >= L1; A2 >= L2) -> (write("Invalid Model, Badness Value: "),
			writeln("99999"),  
			S1 = "Dot Axis Error, Input Shape ",
			shape([I1|Is1],Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,S),
			throw(S));true),
		nth0(A1,Shape1,D1),
		nth0(A2,Shape2,D2),
		(D1 < D2 -> (write("Invalid Model, Badness Value: "),
			depth([I1|Is1],DT),
			D is DT - Axis1,
			pow(100,D-1,Factor),
			Badness is Factor*abs(D1-D2),
			writeln(Badness),
			S1 = "Dot Axis Error, Input Shape ",
			shape([I1|Is1],Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,RS),
			S3 = ", Expected Shape ",
			replace(Shape,Axis1,D2,Shape3),
			term_string(Shape3,S22),
			string_concat(S3,S22,RS1),
			string_concat(RS,RS1,S),
			throw(S));true),
		(D1 > D2 -> (write("Invalid Model, Badness Value: "),
			depth([I1|Is1],DT),
			D is DT - Axis1,
			pow(100,D-1,Factor),
			Badness is Factor*abs(D1-D2),
			writeln(Badness),
			S1 = "Dot Axis Error, Input Shape ",
			shape([I2|Is2],Shape),
			term_string(Shape,S2),
			string_concat(S1,S2,RS),
			S3 = ", Expected Shape ",
			replace(Shape,Axis2,D1,Shape3),
			term_string(Shape3,S22),
			string_concat(S3,S22,RS1),
			string_concat(RS,RS1,S),
			throw(S));true).


check_type_precondition(Is,DType) :-
	(not(check_type(Is,DType)) -> (write("Invalid Model, Badness Value: "), 
					%compute_different_shape_badness(I1,I2,B),
					writeln("100"), 
					S1 = "Type Error, Input ",
					first_atom(Is,I),
					term_string(I,S2),
					string_concat(S1,S2,S),
					throw(S));true).


check_valid_reshape(Is,LPIn,LPOut) :-
		Mod is mod(LPIn,LPOut),
		((LPIn > LPOut) -> (Mod > 0 ->
			(writeln("Invalid Model, Badness Value: 1000000000000000000"),
			S1 = "Reshape Error, Input Shape ",
			shape(Is,ShapeT),
			term_string(ShapeT,S2),
			string_concat(S1,S2,S),
			throw(S));true);true),
		((LPIn < LPOut) -> 
			(writeln("Invalid Model, Badness Value: 1000000000000000000"),
			S1 = "Reshape Error, Input Shape ",
			shape(Is,ShapeT),
			term_string(ShapeT,S2),
			string_concat(S1,S2,S),
			throw(S)); true).
			
check_valid_concatenate(Is,Axis) :-
	depth(Is,D),
	(Axis > D - 2-> (writeln("Invalid Model, Badness Value: 1000000000000000000"),
			S1 = "Concatenate Error, Input Shape ",
			shape(Is,ShapeT),
			term_string(ShapeT,S2),
			string_concat(S1,S2,S),
			throw(S));true).
