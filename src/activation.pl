%:- module(activation,[]).


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

%leaky_relu_layer([-0.138821,-0.30971956,0.23123252,0.26585793,0.65178293,0.54254425,0.8526051,0.1260066,0.4059227],0.26,X).
leaky_relu_layer([],_,[]).
leaky_relu_layer([I|Is],Alpha,[O|Os]) :-
	atomic(I),
	(I < 0 -> O is Alpha * I ; O is I),
	leaky_relu_layer(Is,Alpha,Os).
leaky_relu_layer([I|Is],Alpha,[O|Os]) :-
	is_list(I),
	leaky_relu_layer(I,Alpha,O),
	leaky_relu_layer(Is,Alpha,Os).

% Sample data run
% ?- sigmoid_layer([8,5,0],[],Y).
% Y = [0.9996646498695336, 0.9933071490757153, 0.5].
% ?- sigmoid_layer([-8,-5,0],[],Y).
% Y = [0.0003353501304664781, 0.0066928509242848554, 0.5].
% Sigmoid activation function, sigmoid(x) = 1 / (1 + exp(-x)).

sigmoid_layer([],Y,Y).
sigmoid_layer([I|Is],Y0,Y):-
   I1 is I * -1,
   E is 1 + exp(I1), % calculate denominator term for sigmoid the formula
   O is rdiv(1, rational(E)), % calculate whole value for the sigmoid function
   % format('~5e~n', O),
   S is float(O), % format output as a floating point number
   append(Y0,[S],Ys),
   sigmoid_layer(Is,Ys,Y).

% Sample data run for the softmax layer
% ?- softmax_layer_SL([8,5,0], [], Y).
% Y = [0.9522698261237778, 0.04741072293787844, 0.0003194509383437505].
% Softmax activation function = exp(x) / tf.reduce_sum(exp(x)).

% softmax layer for one-dimensional input tensor

innner_transpose([],[]).
innner_transpose([I|Is],[O|Os]) :-
	maplist(transpose,I,O),
	innner_transpose(Is,Os).
	
softmax_layer([],_,[]).
softmax_layer(Is,-1,Os) :-
	softmax_layer(Is,Os).
%TODO strange behaviour for axis = 0
softmax_layer(Is,0,Os) :-
	replace_all(Is, 1,Os).
softmax_layer(Is,1,Os) :-
	depth(Is,3),
	maplist(transpose,Is,Is1),
	softmax_layer(Is1,Os1),
	maplist(transpose,Os1,Os).
softmax_layer(Is,1,Os) :-
	depth(Is,4),
	writeln("case test"),
	maplist(transpose,Is,IsT),
	innner_transpose(IsT,Is1),
	softmax_layer(Is1,Os1),
	innner_transpose(Os1,OsT),
	%softmax_layer(IsT,OsT),
	maplist(transpose,OsT,Os).
softmax_layer([I|Is],Axis,[O|Os]) :-
	Axis1 is Axis -1,
	softmax_layer(I,Axis1,O),
	softmax_layer(Is,Axis,Os).

softmax_layer([],[]).
softmax_layer([I|Is],[O|Os]) :-
	atomic(I),
	softmax([I|Is],[O|Os]).
softmax_layer([I|Is],[O|Os]) :-
	is_list(I),
	softmax_layer(I,O),
	softmax_layer(Is,Os).
	
/*
model = keras.Sequential([
keras.layers.Softmax(axis=1, input_shape=(3, 4, 3))])
x = tf.constant([[[[0.8996, 0.7369, 0.9819], [0.6772, 0.5752, 0.7727], [0.5042, 0.6055, 0.1404], [0.7983, 0.1691, 0.1599]], [[0.9724, 0.0418, 0.6281], [0.9855, 0.5109, 0.4117], [0.1899, 0.6222, 0.1003], [0.451, 0.9264, 0.0985]], [[0.9026, 0.741, 0.2059], [0.5442, 0.1844, 0.4792], [0.5176, 0.5027, 0.2227], [0.9959, 0.156, 0.048]]]])
print (np.array2string(model.predict(x,steps=1), separator=', '))

-------------------------------------------------------------------------------------
2021-03-24 08:02:30.349897: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcudart.so.11.0'; dlerror: libcudart.so.11.0: cannot open shared object file: No such file or directory2021-03-24 08:02:30.349913: I tensorflow/stream_executor/cuda/cudart_stub.cc:29] Ignore above cudart dlerror if you do not have a GPU set up on your machine.2021-03-24 08:02:31.148017: I tensorflow/compiler/jit/xla_cpu_device.cc:41] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-03-24 08:02:31.148113: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcuda.so.1'; dlerror: libcuda.so.1: cannot open shared object file: No such file or directory2021-03-24 08:02:31.148121: W tensorflow/stream_executor/cuda/cuda_driver.cc:326] failed call to cuInit: UNKNOWN ERROR (303)2021-03-24 08:02:31.148133: I tensorflow/stream_executor/cuda/cuda_diagnostics.cc:156] kernel driver does not appear to be running on this host (admin1-ThinkPad-X1-Carbon-7th): /proc/driver/nvidia/version does not exist2021-03-24 08:02:31.148435: I tensorflow/compiler/jit/xla_gpu_device.cc:99] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-03-24 08:02:31.219535: I tensorflow/compiler/mlir/mlir_graph_optimization_pass.cc:116] None of the MLIR optimization passes are enabled (registered 2)2021-03-24 08:02:31.240327: I tensorflow/core/platform/profile_utils/cpu_utils.cc:112] CPU Frequency: 1999965000 Hz

-------------------------------------------------------------------------------------
Prolog Script:
-------------------------------------------------------------------------------------
softmax_layer([[[[0.8996, 0.7369, 0.9819], [0.6772, 0.5752, 0.7727], [0.5042, 0.6055, 0.1404], [0.7983, 0.1691, 0.1599]], [[0.9724, 0.0418, 0.6281], [0.9855, 0.5109, 0.4117], [0.1899, 0.6222, 0.1003], [0.451, 0.9264, 0.0985]], [[0.9026, 0.741, 0.2059], [0.5442, 0.1844, 0.4792], [0.5176, 0.5027, 0.2227], [0.9959, 0.156, 0.048]]]], 1, X)
-------------------------------------------------------------------------------------
X = [[[[0.3406426619624228, 0.28949383912718235, 0.36986349891039494], [0.33297390202398763, 0.30068527346215806, 0.3663408245138544], [0.3569339537163348, 0.3949861737281661, 0.2480798725554991], [0.4851649153721218, 0.2586016546566559, 0.2562334299712223]], [[0.47550363826141834, 0.18749919149973293, 0.3369971702388487], [0.457558188158238, 0.2846624418856131, 0.25777936995614886], [0.2894277164265321, 0.4459494396788698, 0.2646228438945981], [0.30197010414636233, 0.4857664824204416|...]], [[0.425711584883995, 0.36218751907196656, 0.2121008960440384], [0.3795234442924085, 0.26483748447224903, 0.3556390712353425], [0.3663249892343641, 0.3609072095862182|...], [0.549659622573643|...]]]] X = [[[[0.3406426619624228, 0.28949383912718235, 0.36986349891039494], [0.33297390202398763, 0.30068527346215806, 0.3663408245138544], [0.3569339537163348, 0.3949861737281661, 0.2480798725554991], [0.4851649153721218, 0.2586016546566559, 0.2562334299712223]], [[0.47550363826141834, 0.18749919149973293, 0.3369971702388487], [0.457558188158238, 0.2846624418856131, 0.25777936995614886], [0.2894277164265321, 0.4459494396788698, 0.2646228438945981], [0.30197010414636233, 0.4857664824204416, 0.2122634134331961]], [[0.425711584883995, 0.36218751907196656, 0.2121008960440384], [0.3795234442924085, 0.26483748447224903, 0.3556390712353425], [0.3663249892343641, 0.3609072095862182, 0.2727678011794177], [0.549659622573643, 0.2373175739399435, 0.2130228034864135]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:556:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.3248314, 0.3994993, 0.4624794], [0.3089687, 0.3825205, 0.4093951], [0.3644594, 0.3425657, 0.3282482], [0.3418724, 0.2427481, 0.3527859]], [[0.3493612, 0.1993600, 0.3246676], [0.4205401, 0.3586985, 0.2853398], [0.2661646, 0.3483346, 0.3153459], [0.2415647, 0.5176630, 0.3317764]], [[0.3258074, 0.4011407, 0.2128530], [0.2704913, 0.2587810, 0.3052651], [0.3693760, 0.3090996, 0.3564059], [0.4165629, 0.2395889, 0.3154377]]]]
Expected (Unparsed): [[[[0.3406426619624228, 0.28949383912718235, 0.36986349891039494], [0.33297390202398763, 0.30068527346215806, 0.3663408245138544], [0.3569339537163348, 0.3949861737281661, 0.2480798725554991], [0.4851649153721218, 0.2586016546566559, 0.2562334299712223]], [[0.47550363826141834, 0.18749919149973293, 0.3369971702388487], [0.457558188158238, 0.2846624418856131, 0.25777936995614886], [0.2894277164265321, 0.4459494396788698, 0.2646228438945981], [0.30197010414636233, 0.4857664824204416, 0.2122634134331961]], [[0.425711584883995, 0.36218751907196656, 0.2121008960440384], [0.3795234442924085, 0.26483748447224903, 0.3556390712353425], [0.3663249892343641, 0.3609072095862182, 0.2727678011794177], [0.549659622573643, 0.2373175739399435, 0.2130228034864135]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:556:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[0.3249, 0.3995, 0.4625], [0.309, 0.3826, 0.4094], [0.3645, 0.3426, 0.3283], [0.3419, 0.2428, 0.3528]], [[0.3494, 0.1994, 0.3247], [0.4206, 0.3587, 0.2854], [0.2662, 0.3484, 0.3154], [0.2416, 0.5177, 0.3318]], [[0.3259, 0.4012, 0.2129], [0.2705, 0.2588, 0.3053], [0.3694, 0.3091, 0.3565], [0.4166, 0.2396, 0.3155]]]]
Expected: [[[[0.3407, 0.2895, 0.3699], [0.333, 0.3007, 0.3664], [0.357, 0.395, 0.2481], [0.4852, 0.2587, 0.2563]], [[0.4756, 0.1875, 0.337], [0.4576, 0.2847, 0.2578], [0.2895, 0.446, 0.2647], [0.302, 0.4858, 0.2123]], [[0.4258, 0.3622, 0.2122], [0.3796, 0.2649, 0.3557], [0.3664, 0.361, 0.2728], [0.5497, 0.2374, 0.2131]]]]
*/
	

softmax([],_).
softmax([I|Is], R2):-
 calc_exp_SL([I|Is], [], Y), % calc exponential for a single list
 calc_sum_SL([I|Is], 0, Sum),   %  calc sum of exponential values for all the list elements
 reduce_sum_SL(Y, Sum, [], R2). % dividing by the normalization to get the valid probabilities.
%softmax_layer([],Y,Y).
%softmax_layer([I|Is], _, R2):-
% calc_exp_SL([I|Is], [], Y), % calc exponential for a single list
% calc_sum_SL([I|Is], 0, Sum),   %  calc sum of exponential values for all the list elements
% reduce_sum_SL(Y, Sum, [], R2). % dividing by the normalization to get the valid probabilities.

% calculate exponential of a one-dimension list
% ?- calc_exp_SL([5,0],[],Y).
% Y = [148.4131591025766, 1].
% calculate exponent of elements in a one-dimensional input tensor
calc_exp_SL([],Y,Y).
calc_exp_SL([I|Is], Y0, L):-
% ((I > 0 -> O is exp(I)); (I =:= 0 -> O is 1 ; O is I)),
(I =:= 0 -> O is 1 ; O is exp(I)),
 append(Y0, [O], Ys),
 calc_exp_SL(Is, Ys, L).

 % calculate exponential sum of a one-dimension list
calc_sum_SL([], Sum1, Sum1).
calc_sum_SL([I|Is], Sum0, Sum):-
 %((I > 0 -> O is exp(I)); (I =:= 0 -> O is 1 ; O is I)),
(I =:= 0 -> O is 1 ; O is exp(I)),
 S is float(O),
 Sum1 is Sum0 + S,
 calc_sum_SL(Is, Sum1, Sum).

% calculate reduce sum for a one-dimension list
reduce_sum_SL([],_,Y,Y).
reduce_sum_SL([Y|Ys], Sum1, R1, R2):-
  O is rdiv(rational(Y), rational(Sum1)),
  % format('~5e~n', O),
   S is float(O),
   append(R1, [S], Z),
   reduce_sum_SL(Ys, Sum1, Z, R2).

% softmax layer for multi-dimensional input tensor
% ?- softmax_layer_LL([[0,1,0],[0,1,0]],[],Y).
% Y = [[0.21194155761708547, 0.5761168847658291, 0.21194155761708547], [0.21194155761708547, 0.5761168847658291, 0.21194155761708547]].

softmax_layer_LL([],Y,Y).
softmax_layer_LL([[I|Is]|Xs], Y0, Y):-
 softmax_layer([I|Is], Y0, Y1),
 Y = [Y1|T],
 softmax_layer_LL(Xs,[],T).

% calculate exponential sum of multi-dimension list
  calc_sum_LL([], Y, Y).
  calc_sum_LL([[I|Is]|Xs], Y0, Y):-
   calc_sum([I|Is], 0, Sum),
   append(Y0, [Sum], Ys),
   calc_sum_LL(Xs, Ys, Y).

% calculate exponent of elements in a multi-dimensional input tensor
% ?- calc_exp_LL([[8,0],[5,0]],[],Y).
% Y = [[2980.9579870417283, 1], [148.4131591025766, 1]].

calc_exp_LL([], Y, Y).
calc_exp_LL([[I|Is]|Xs], Y0, Y):-
 calc_exp_SL([I|Is], Y0, L),
 Y = [L|T],
 calc_exp_LL(Xs, [], T).


% elu_layer([3,2,1,-2,-0.1],2,1,0.5,O).
elu_layer([],_,[]).
elu_layer([I|Is],Alpha,[O|Os]) :-
	atomic(I),
	(I < 0 -> O is Alpha * ((e ^ I) - 1);O is I),
	elu_layer(Is,Alpha,Os).
elu_layer([I|Is],Alpha,[O|Os]) :-
	is_list(I),
	elu_layer(I,Alpha,O),
	elu_layer(Is,Alpha,Os).
	
prelu_layer([],_,[]).
prelu_layer([I|Is],[A|Alphas],[O|Os]) :-
	atomic(I),
	length([A|Alphas],LA),
	length([I|Is],LI),
	LA = LI,
	(I < 0 -> O is A * I;O is I),
	prelu_layer(Is,Alphas,Os).
prelu_layer([I|Is],[A|Alphas],[O|Os]) :-
	atomic(I),
	length([A|Alphas],LA),
	length([I|Is],LI),
	LA \= LI,
	(I < 0 -> O is A * I;O is I),
	prelu_layer(Is,[A|Alphas],Os).
prelu_layer([I|Is],[A|Alphas],[O|Os]) :-
	%depth(Alphas,DA),
	%depth([I|Is],DI),
	%DI \= DA,
	(atomic(A);(
	depth([A|Alphas],DA),
	depth([I|Is],DI),
	DA \= DI)),
	is_list(I),
	prelu_layer(I,[A|Alphas],O),
	prelu_layer(Is,[A|Alphas],Os).
prelu_layer([I|Is],[A|Alphas],[O|Os]):-
	%depth([A|Alphas],DA),
	%depth([I|Is],DI),
	%DI = DA,
	is_list(A),
	is_list(I),
	prelu_layer(I,A,O),
	prelu_layer(Is,Alphas,Os).

	
