:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-use_module(library(matrix)).
:-use_module(library(lambda)).
:-[util].



simple_rnncell_layer(Is,Ws,RWs,Bs,Os) :-
	simple_rnn_layer(Is,Ws,RWs,Bs,Os).



simple_rnn_layer(Is,Ws,RWs,Bs,Os) :- 
	check_dimensions(Is,3),
	sub_sub_length(Is,L),
	length(Ws,L1),
	check_valid_arguments(Is,L,L1),
	simple_rnn(Is,Ws,RWs,Bs,Os).

simple_rnn([[I|Is0]|Is],Ws,RWs,Bs,Os) :- 
	is_list(I), simple_rnn([[I|Is0]|Is],Ws,RWs,Bs,[],Os).
simple_rnn([[I|Is0]|Is],Ws,RWs,Bs,Os) :- 
	atomic(I), length(Bs,N), empty_list(N,Os0), simple_rnn([[I|Is0]|Is],Ws,RWs,Bs,Os0,Os).
simple_rnn([],_,_,_,Os,Os).
simple_rnn([[I|Is0]|Is],Ws,RWs,Bs,Os0,Os) :-
	is_list(I),
	simple_rnn([I|Is0],Ws,RWs,Bs,O),
	append(Os0,[O],Os1),
	simple_rnn(Is,Ws,RWs,Bs,Os1,Os).
simple_rnn([[I|Is0]|Is],Ws,RWs,Bs,Os0,Os) :-
	atomic(I),
	mult_input_and_weight([I|Is0],Ws,O),
	%writeln("O"),
	%writeln(O),
	%mult_recurrent_weight(Os0,RWs,Rs1),
	mmult([Os0],RWs,Rs0),
	unpack(Rs0,Rs1),
	%writeln(Rs1),
	add_lists(O,Rs1,O1),
	add_lists(O1,Bs,O2),
	%writeln(O2),
	tanh(O2,Os1),
	%writeln(Os1),
	simple_rnn(Is,Ws,RWs,Bs,Os1,Os).
	
mult_input_and_weight([I|Is],[W|Ws],Os) :- mult_input_and_weight([I|Is],[W|Ws],[],Os).
mult_input_and_weight([],[],Os,Os).
mult_input_and_weight([I|Is],[W|Ws],Os0,Os) :-
	multiply_each_list_element_with(W,I,Os1),
	add_lists(Os0,Os1,Os2),
	mult_input_and_weight(Is,Ws,Os2,Os).



/*
mult_recurrent_weight([I|Is],[RW|RWs],Os) :- mult_recurrent_weight([I|Is],[RW|RWs], [],Os).
mult_recurrent_weight([],[],Os,Os).
mult_recurrent_weight([I|Is],[RW|RWs],Os0,Os) :-
	%del_first_items(RWs,RW,RWs1),
	multiply_each_list_element_with(RW,I,O),
	sum_list(O,O1),
	append(Os0,[O1],Os1),
	mult_recurrent_weight(Is,RWs,Os1,Os).
*/


grucell_layer(Is,Ws,RWs,Bs,ResetAfter,Os) :- 
	gru_layer(Is,Ws,RWs,Bs,ResetAfter,Os).



gru_layer(Is,Ws,RWs,Bs,ResetAfter,Os) :- 
	check_dimensions(Is,3),
	sub_sub_length(Is,L),
	length(Ws,L1),
	check_valid_arguments(Is,L,L1),
	gru(Is,Ws,RWs,Bs,ResetAfter,Os).

gru([[I|Is0]|Is],Ws,RWs,Bs,ResetAfter,Os) :- 
	is_list(I), gru([[I|Is0]|Is],Ws,RWs,Bs,ResetAfter,[],Os).
gru([[I|Is0]|Is],[W|Ws],RWs,Bs,ResetAfter,Os) :- 
	atomic(I), length(W,N), N1 is N /3, empty_list(N1,Os0), gru([[I|Is0]|Is],[W|Ws],RWs,Bs,ResetAfter,[Os0],[Os]).
gru([],_,_,_,_,Os,Os).
gru([[I|Is0]|Is],Ws,RWs,Bs,ResetAfter,Os0,Os) :-
	is_list(I),
	gru([I|Is0],Ws,RWs,Bs,ResetAfter,O),
	append(Os0,[O],Os1),
	gru(Is,Ws,RWs,Bs,ResetAfter,Os1,Os).
gru([[I|Is0]|Is],Ws,Us,Bs,false,Os0,Os) :-
	atomic(I),
	%writeln("last res"),
	%writeln(Os0),
	split_weights(Ws, Wz,Wr,Wh),
	split_weights(Us, Uz,Ur,Uh),
	split_weights([Bs], Bz,Br,Bh),
	%writeln(Wr),
	%writeln(Ur),
	%writeln(Br),
	%writeln("start"),
	mmult([[I|Is0]],Wz,Z0),
	%write('Z0: '),
	%writeln(Z0),
	mmult(Os0,Uz,Z1),
	%write('Z1: '),
	%writeln(Z1),
	add_lists(Z0,Z1,Z2),
	%write('Z2: '),
	%writeln(Z2),
	add_lists(Z2,Bz,Z3),
	%write('Z3: '),
	%writeln(Z3),
	sigmoid_func(Z3,Zt),
	%write('Zt: '),
	%writeln(Zt),
	mmult([[I|Is0]],Wr,R0),
	mmult(Os0,Ur,R1),
	add_lists(R0,R1,R2),
	add_lists(R2,Br,R3),
	sigmoid_func(R3,Rt),
	%write('Rt: '),
	%writeln(Rt),
	mmult([[I|Is0]],Wh,H0),
	multiply_lists(Rt,Os0,H1),
	mmult(H1,Uh,H2),
	add_lists(H0,H2,H3),
	add_lists(H3,Bh,H4),
	%write('H4: '),
	%writeln(H4),
	tanh(H4,Htt),
	%write('Htt: '),
	%writeln(Htt),
	one_minus_x(Zt,Zt1),
	%write('Zt1: '),
	%writeln(Zt1),
	multiply_lists(Zt1,Htt,Ht0),
	%write('Ht0: '),
	%writeln(Ht0),
	multiply_lists(Zt,Os0,Ht1),
	%write('Ht1: '),
	%writeln(Ht1),
	add_lists(Ht0,Ht1,Os1),
	%write('Os1: '),
	%writeln(Os1),
	%N1 is N+1,
	gru(Is,Ws,Us,Bs,false,Os1,Os). 
	
gru([[I|Is0]|Is],Ws,Us,[Bs1,Bs2],true,Os0,Os) :-
	atomic(I),
	%writeln("last res"),
	%writeln(Os0),
	split_weights(Ws, Wz,Wr,Wh),
	split_weights(Us, Uz,Ur,Uh),
	add_lists(Bs1,Bs2,Bs),
	split_weights([Bs], Bz,Br,Bh),
	%writeln(Wr),
	%writeln(Ur),
	%writeln(Br),
	%writeln("start"),
	mmult([[I|Is0]],Wz,Z0),
	%write('Z0: '),
	%writeln(Z0),
	mmult(Os0,Uz,Z1),
	%write('Z1: '),
	%writeln(Z1),
	add_lists(Z0,Z1,Z2),
	%write('Z2: '),
	%writeln(Z2),
	add_lists(Z2,Bz,Z3),
	%write('Z3: '),
	%writeln(Z3),
	sigmoid_func(Z3,Zt),
	%write('Zt: '),
	%writeln(Zt),
	mmult([[I|Is0]],Wr,R0),
	mmult(Os0,Ur,R1),
	add_lists(R0,R1,R2),
	add_lists(R2,Br,R3),
	sigmoid_func(R3,Rt),
	%write('Rt: '),
	%writeln(Rt),
	mmult([[I|Is0]],Wh,H0),
	multiply_lists(Rt,Os0,H1),
	mmult(H1,Uh,H2),
	add_lists(H0,H2,H3),
	add_lists(H3,Bh,H4),
	%write('H4: '),
	%writeln(H4),
	tanh(H4,Htt),
	%write('Htt: '),
	%writeln(Htt),
	one_minus_x(Zt,Zt1),
	%write('Zt1: '),
	%writeln(Zt1),
	multiply_lists(Zt1,Htt,Ht0),
	%write('Ht0: '),
	%writeln(Ht0),
	multiply_lists(Zt,Os0,Ht1),
	%write('Ht1: '),
	%writeln(Ht1),
	add_lists(Ht0,Ht1,Os1),
	%write('Os1: '),
	%writeln(Os1),
	%N1 is N+1,
	gru(Is,Ws,Us,[Bs1,Bs2],true,Os1,Os). 
/*
z_t = \sigma(W^{(z)} x_t + U^{(z)} h_{t-1} + b^{(z)})
r_t = \sigma(W^{(r)} x_t + U^{(r)} h_{t-1} + b^{(r)})
\tilde{h}_t = \tanh(W^{(h)} x_t + U^{(h)} h_{t-1} \circ r_t + b^{(h)})
h_t = (1 - z_t) \circ h_{t - 1} + z_t \circ \tilde{h}_t

      # Definitions of z_t and r_t
        z_t = tf.sigmoid(tf.matmul(x_t, self.Wz) + tf.matmul(h_tm1, self.Uz) + self.bz)
        r_t = tf.sigmoid(tf.matmul(x_t, self.Wr) + tf.matmul(h_tm1, self.Ur) + self.br)
        
        # Definition of h~_t
        h_proposal = tf.tanh(tf.matmul(x_t, self.Wh) + tf.matmul(tf.multiply(r_t, h_tm1), self.Uh) + self.bh)
        
        # Compute the next hidden state
        h_t = tf.multiply(1 - z_t, h_tm1) + tf.multiply(z_t, h_proposal)

	gru_layer(Is,Ws,RWs,Bs,Os1,Os).*/
	
split_weights([],[],[],[]).
split_weights([W|Ws], [Wr|Wrs],[Wz|Wzs],[Wh|Whs]) :-
	length(W,L),
	LN is L / 3,
	split_at(LN,W,Wr,WT),
	split_at(LN,WT,Wz,Wh),
	split_weights(Ws, Wrs,Wzs,Whs).



%one_minus_x_list(Xs,Ys) :- maplist(one_minus_x,Xs,Ys).
%one_minus_x_matrix(Xs,Ys) :- maplist(one_minus_x_list,Xs,Ys).


	
/*

Prolog Script:
-------------------------------------------------------------------------------------
gru_layer([[[0.0501]]],[[1, 1, 1]],[[0, 0, 0]],[0, 0, 0], X)
-------------------------------------------------------------------------------------
last res[[0]][[1]][[0]][[0]]start[[0.0501]][[0]][[0.0501]][[0.0501]][[0.5125223808344737]][[0.5125223808344737]][[0.0501]][[0.05005812487529025]][[0.48747761916552634]][[0.0]][[0.02565590934119315]]X = [[0.02565590934119315]] X = [[0.02565590934119315]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[0.02452748]]
Expected (Unparsed): [[0.02565590934119315]]
-------------------------------------------------------------------------------------
Actual:   [[0.0246]]
Expected: [[0.0257]]


gru_layer([[[2]]],[[1, 1, 1]],[[0, 0, 0]],[0, 0, 0], X)
-------------------------------------------------------------------------------------
last res[[0]][[1]][[0]][[0]]start[[2]][[0]][[2]][[2]][[0.8807970779778823]][[0.8807970779778823]][[2.0]][[0.9640275800758169]][[0.11920292202211769]][[0.0]][[0.8491126756208685]]X = [[0.8491126756208685]] X = [[0.8491126756208685]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[0.09640278]]
Expected (Unparsed): [[0.8491126756208685]]
-------------------------------------------------------------------------------------
Actual:   [[0.0965]]
Expected: [[0.8492]]


gru_layer([[[0.66]]],[[0.0933, 0.7673, 0.4945]],[[0, 0, 0]],[0, 0, 0],  X)
-------------------------------------------------------------------------------------
last res[[0]][[0.0933]][[0]][[0]]startZ0: [[0.506418]]Z1: [[0]]Z2: [[0.506418]]Z3: [[0.506418]]Zt: [[0.6239663953856449]]Rt: [[0.51538963737415]]H4: [[0.32637]]Htt: [[0.3152552990125508]]Zt1: [[0.3760336046143551]]Ht0: [[0.1185465864614658]]Ht1: [[0.0]]Os1: [[0.1185465864614658]]X = [[0.1185465864614658]] X = [[0.1185465864614658]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[0.152776]]
Expected (Unparsed): [[0.1185465864614658]]
-------------------------------------------------------------------------------------
Actual:   [[0.1528]]
Expected: [[0.1186]]

*/



lstmcell_layer(Is,Ws,Us,Bs,Os) :- 
	lstm_layer(Is,Ws,Us,Bs,Os).



lstm_layer(Is,Ws,Us,Bs,Os) :- 
	check_dimensions(Is,3),
	sub_sub_length(Is,L),	
	length(Ws,L1),
	check_valid_arguments(Is,L,L1),
	lstm(Is,Ws,Us,Bs,Os).
	
lstm([[I|Is0]|Is],Ws,Us,Bs,Os) :- 
	is_list(I), lstm([[I|Is0]|Is],Ws,Us,Bs,[],Os).
lstm([[I|Is0]|Is],Ws,Us,Bs,Os) :- 
	atomic(I), length(Bs,N), N1 is N /4, empty_list(N1,Os0), lstm([[I|Is0]|Is],Ws,Us,Bs,[Os0],[Os0],[Os]).
lstm([],_,_,_,Os,Os).
lstm([[I|Is0]|Is],Ws,Us,Bs,Os0,Os) :-
	is_list(I),
	lstm([I|Is0],Ws,Us,Bs,O),
	append(Os0,[O],Os1),
	lstm(Is,Ws,Us,Bs,Os1,Os).
lstm([],_,_,_,_,Os,Os).
lstm([[I|Is0]|Is],Ws,Us,Bs,Ct0,Os0,Os) :-
	atomic(I),
	split_lstm_weights(Ws, Wi,Wf,Wc,Wo),
	split_lstm_weights(Us, Ui,Uf,Uc,Uo),
	split_lstm_weights([Bs], Bi,Bf,Bc,Bo),
	%write('Wi: '),
	%writeln(Wi),
	sig_gate([[I|Is0]],Os0,Wi,Ui,Bi,It),
	sig_gate([[I|Is0]],Os0,Wf,Uf,Bf,Ft),
	sig_gate([[I|Is0]],Os0,Wo,Uo,Bo,Ot),
	%write('Ot: '),
	%writeln(Ot),
	tanh_gate([[I|Is0]],Os0,Wc,Uc,Bc,Ctt),
	%write('Ctt: '),
	%writeln(Ctt),
	multiply_lists(Ft,Ct0,Ct1),
	multiply_lists(It,Ctt,Ct2),
	add_lists(Ct1,Ct2,Ct),
	tanh(Ct,TanhCt),
	multiply_lists(Ot,TanhCt,Os1),
	%write('Os1: '),
	%writeln(Os1),
	lstm(Is,Ws,Us,Bs,Ct,Os1,Os). 
	
sig_gate(Is,HtPast,W,U,B,Os) :-
	mmult(Is,W,Os0),
	mmult(HtPast,U,Os1),
	add_lists(Os0,Os1,Os2),
	add_lists(Os2,B,Os3),
	sigmoid_func(Os3,Os).
	
tanh_gate(Is,HtPast,W,U,B,Os) :-
	mmult(Is,W,Os0),
	mmult(HtPast,U,Os1),
	add_lists(Os0,Os1,Os2),
	add_lists(Os2,B,Os3),
	tanh(Os3,Os).
	
split_lstm_weights([],[],[],[],[]).
split_lstm_weights([W|Ws], [Wi|Wis],[Wf|Wfs],[Wo|Wos],[Wc|Wcs]) :-
	length(W,L),
	LN is L / 4,
	split_at(LN,W,Wi,WT),
	split_at(LN,WT,Wf,WT1),
	split_at(LN,WT1,Wo,Wc),
	split_lstm_weights(Ws, Wis,Wfs,Wos,Wcs).



/*
Prolog Script:
-------------------------------------------------------------------------------------
lstm_layer([[[4], [1]]],[[4, 5, 2, 10]],[[0, 0, 0, 0]],[0, 0, 0, 0],  X)
lstm_layer([[[4], [1]]],X,[[0, 0, 0, 0]],[0, 0, 0, 0],  [[0.9594901]]).
-------------------------------------------------------------------------------------
Wi: [[4]]Ot: [[0.9996646498695336]]Ctt: [[1.0]]Os1: [[0.7613387080101672]]Wi: [[4]]Ot: [[0.8807970779778823]]Ctt: [[0.9999999958776927]]Os1: [[0.8475398128355199]]X = [[0.8475398128355199]] X = [[0.8475398128355199]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[0.9594901]]
Expected (Unparsed): [[0.8475398128355199]]
-------------------------------------------------------------------------------------
Actual:   [[0.9595]]
Expected: [[0.8476]]

*/


conv_lstm1D_layer([[[I|Is0]|Is1]|Is],Ws,Us,Bs,Os) :- 
	is_list(I), conv_lstm1D_layer([[[I|Is0]|Is1]|Is],Ws,Us,Bs,[],Os).
conv_lstm1D_layer([[[I|Is0]|Is1]|Is],Ws,Us,Bs,Os) :-
	atomic(I), 
	conv_lstm1D_layer([[[I|Is0]|Is1]|Is],Ws,Us,Bs,[],[],Os).
conv_lstm1D_layer([[[I|Is0]|Is1]|Is],Ws,Us,Bs,Os0,Os) :-
	is_list(I),
	conv_lstm1D_layer([[I|Is0]|Is1],Ws,Us,Bs,O),
	append(Os0,O,Os1),
	conv_lstm1D_layer(Is,Ws,Us,Bs,Os1,Os).	
conv_lstm1D_layer([],_,_,_,Os,Os).
conv_lstm1D_layer([],_,_,_,_,Os,Os).
conv_lstm1D_layer([[[I|Is0]|Is1]|Is],Ws,Us,Bs,Ct0,Os0,Os) :-
	atomic(I),
	length(Ws, KernelSize),
	(Ct0 = [] -> 
		(
			initialize_convlstm1d_variables([[[I|Is0]|Is1]],KernelSize,Os0Ready,Ct0Ready,Ws,Us,Bs,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo),
			apply_lstm_step_convlstm1d([[[I|Is0]|Is1]],KernelSize,Os0Ready,Ct0Ready,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo,Os1,Ct1)
		);
		(	
			PadLeft is div(KernelSize-1,2), 
			PadRight is KernelSize - 1 - PadLeft,
			split_convlstm_weights(3,Ws,Wi,Wf,Wc,Wo),
			split_convlstm_weights(3,Us,Ui,Uf,Uc,Uo),
			split_convlstm_bias(Bs,Bi,Bf,Bc,Bo),
			padding1D(Os0,0,PadLeft,PadRight,Os0Ready),
			apply_lstm_step_convlstm1d([[[I|Is0]|Is1]],KernelSize,Os0Ready,Ct0,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo,Os1,Ct1)
		)
	),
	conv_lstm1D_layer(Is,Ws,Us,Bs,Ct1,Os1,Os).

initialize_convlstm1d_variables(Is,KernelSize,Os0,Ct0,Ws,Us,Bs,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo) :-
	length(Is,L0),
	sub_length(Is,L1),
	sub_sub_length(Is,L2),
	empty_field3D(0,L0,L1,L2,Os0),
	split_convlstm_weights(3,Ws,Wi,Wf,Wc,Wo),
	split_convlstm_hidden_weights(3,Bs,Us,Ui,Uf,Uc,Uo),
	split_convlstm_bias(Bs,Bi,Bf,Bc,Bo),
	conv1D_layer(Is,KernelSize,Wi,Bi,Xi),
	length(Xi,CL0),
	sub_length(Xi,CL1),
	sub_sub_length(Xi,CL2),
	empty_field3D(0,CL0,CL1,CL2,Ct0).

apply_lstm_step_convlstm1d(Is,KernelSize,Os0,Ct0,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo,Os1,Ct1) :-
	length(Bi,Lb),
	empty_list(0,Lb,Bempty),
	conv1D_layer(Is,KernelSize,Wi,Bi,Xi),
	conv1D_layer(Is,KernelSize,Wf,Bf,Xf),
	conv1D_layer(Is,KernelSize,Wc,Bc,Xc),
	conv1D_layer(Is,KernelSize,Wo,Bo,Xo),
	conv1D_layer(Os0,KernelSize,Ui,Bempty,Hi),
	conv1D_layer(Os0,KernelSize,Uf,Bempty,Hf),
	conv1D_layer(Os0,KernelSize,Uc,Bempty,Hc),
	conv1D_layer(Os0,KernelSize,Uo,Bempty,Ho),
	% write('Ct0: '),writeln(Ct0),
	add_layer([Xi,Hi],[It0]),
	keep(It0,It),
	% write('It: '),writeln(It),
	add_layer([Xf,Hf],[Ft0]),
	keep(Ft0,Ft),
	% write('Ft: '),writeln(Ft),
	add_layer([Xo,Ho],[Ot0]),
	keep(Ot0,Ot),
	multiply_lists([Ft],Ct0,CtTemp0),
	add_layer([Xc,Hc],CtTemp1),
	multiply_lists([It],CtTemp1,CtTemp2),
	add_lists(CtTemp2,CtTemp0,Ct1),
	multiply_lists([Ot],Ct1,Os1).

conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],Ws,Us,Bs,Os) :- 
	is_list(I), conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],Ws,Us,Bs,[],Os).
conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],Ws,Us,Bs,Os) :- 
	atomic(I), %length(Bs,N), N1 is N /4, empty_list(N1,Os0), 
	conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],Ws,Us,Bs,[],[],Os).
conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],Ws,Us,Bs,Os0,Os) :-
	is_list(I),
	conv_lstm2D_layer([[[I|Is0]|Is1]|Is2],Ws,Us,Bs,O),
	append(Os0,O,Os1),
	conv_lstm2D_layer(Is,Ws,Us,Bs,Os1,Os).	
conv_lstm2D_layer([],_,_,_,Os,Os).
conv_lstm2D_layer([],_,_,_,_,Os,Os).
/*conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],[[W|Ws0]|Ws],Us,Bs,Ct0,Os0,Os) :-
	atomic(I),
	length([[W|Ws0]|Ws], KernelSizeD1),
	length([W|Ws0],KernelSizeD2),
	%length(W,TempNodeNumb),
	%length(Bs,N), TempNodeNumb is N /4,
	writeln("before conv"),
	writeln([[[I|Is0]|Is1]|Is2]),
	writeln(KernelSizeD1),
	writeln(KernelSizeD2),
	length([I|Is0],LD3),
	writeln(LD3),
	empty_field4D(1,KernelSizeD1,KernelSizeD2,LD3,1,TW),
	writeln(TW),
	empty_list(LD3,TW1),
	writeln(TW1),
	depthwise_conv2D_layer([[[I|Is0]|Is1]|Is2],KernelSizeD1,KernelSizeD2,TW,TW1,CO),
	
	write('conv donc CO: '),
	writeln(CO),
	flatten(CO,XI),

	nth0_2D(0,0, [[W|Ws0]|Ws],WsM),
	nth0_2D(0,0, Us,UsM),
	
	split_lstm_weights(WsM, Wi,Wf,Wc,Wo),
	split_lstm_weights(UsM, Ui,Uf,Uc,Uo),
	split_lstm_weights([Bs], Bi,Bf,Bc,Bo),
		write('Wi: '),writeln(Wi),
		write('Ui: '),writeln(Ui),
		write('Bi: '),writeln(Bi),
		write('Os0: '),writeln(Os0),
	
	sig_gate([XI],Os0,Wi,Ui,Bi,It),
		write('It: '),writeln(It),
	sig_gate([XI],Os0,Wf,Uf,Bf,Ft),
			write('Ft: '),
	writeln(Ft),
	sig_gate([XI],Os0,Wo,Uo,Bo,Ot),
	write('Ot: '),
	writeln(Ot),
	
	tanh_gate([XI],Os0,Wc,Uc,Bc,Ctt),
	write('Ctt: '),
	writeln(Ctt),
	
	multiply_lists(Ft,Ct0,Ct1),
	multiply_lists(It,Ctt,Ct2),
	add_lists(Ct1,Ct2,Ct),
	tanh(Ct,TanhCt),
	multiply_lists(Ot,TanhCt,Os1),
	write('Os1: '),
	writeln(Os1),
	conv_lstm2D_layer(Is,[[W|Ws0]|Ws],Us,Bs,Ct,Os1,Os).*/
conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],[[W|Ws0]|Ws],Us,Bs,Ct0,Os0,Os) :-
	atomic(I),
	length([[W|Ws0]|Ws], KernelSizeD1),
	length([W|Ws0],KernelSizeD2),
	% length(W,TempNodeNumb),
	% length(Bs,N), TempNodeNumb is N /4,
	% writeln("before conv"),
	% writeln([[[I|Is0]|Is1]|Is2]),
	% writeln(KernelSizeD2),
	% length([I|Is0],LD3),
	% writeln(LD3),
	% empty_field4D(1,KernelSizeD1,KernelSizeD2,LD3,LD3,TW),
	% writeln(TW),
	% empty_list(LD3,TW1),
	% writeln(TW1),
	% conv2D_layer([[[[I|Is0]|Is1]|Is2]],KernelSizeD1,KernelSizeD2,TW,TW1,[CO|_]),
	
	/* encapsulate_atoms([[[I|Is0]|Is1]|Is2],ITemp),
	conv3D_layer(ITemp,KernelSizeD1,KernelSizeD2,1,[TW],TW1,COTemp),
	decapsulate_atoms(COTemp,CO), */
	/*empty_field4D(1,KernelSizeD1,KernelSizeD2,LD3,1,TW),
	writeln(TW),
	empty_list(LD3,TW1),
	writeln(TW1),
	depthwise_conv2D_layer([[[I|Is0]|Is1]|Is2],KernelSizeD1,KernelSizeD2,TW,TW1,CO),*/
	% writeln("after conv"),
	% writeln(CO),
	(Ct0 = [] -> 
		(
			initialize_convlstm2d_variables([[[[I|Is0]|Is1]|Is2]],KernelSizeD1,KernelSizeD2,Os0Ready,Ct0Ready,[[W|Ws0]|Ws],Us,Bs,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo),
			apply_lstm_step_convlstm2d([[[[I|Is0]|Is1]|Is2]],KernelSizeD1,KernelSizeD2,Os0Ready,Ct0Ready,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo,Os1,Ct1)
		);
		(	
			PadLeftD1 is div(KernelSizeD1-1,2), 
			PadRightD1 is KernelSizeD1 - 1 - PadLeftD1,
			PadLeftD2 is div(KernelSizeD2-1,2), 
			PadRightD2 is KernelSizeD2 - 1 - PadLeftD2,
			split_convlstm_weights(4,[[W|Ws0]|Ws],Wi,Wf,Wc,Wo),
			split_convlstm_weights(4,Us,Ui,Uf,Uc,Uo),
			split_convlstm_bias(Bs,Bi,Bf,Bc,Bo),
			padding2D(Os0,0,PadLeftD1,PadRightD1,PadLeftD2,PadRightD2,Os0Ready),
			apply_lstm_step_convlstm2d([[[[I|Is0]|Is1]|Is2]],KernelSizeD1,KernelSizeD2,Os0Ready,Ct0,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo,Os1,Ct1)
		)
	),
	conv_lstm2D_layer(Is,[[W|Ws0]|Ws],Us,Bs,Ct1,Os1,Os).
/* nth0_2D(0,0, [[W|Ws0]|Ws],WsT),
	nth0_2D(0,0, Us,UsT),
	
	split_lstm_weights(WsT, Wi,Wf,Wc,Wo),
	split_lstm_weights(UsT, Ui,Uf,Uc,Uo),
	split_lstm_weights([Bs], Bi,Bf,Bc,Bo),
	write('Wi: '),
	writeln(Wi),
	
	sig_gate(CO,Os0,Wi,Ui,Bi,It),
	write('sig_done: '),
	sig_gate(CO,Os0,Wf,Uf,Bf,Ft),
	sig_gate(CO,Os0,Wo,Uo,Bo,Ot),
	write('Ot: '),
	writeln(Ot),
	
	tanh_gate(CO,Os0,Wc,Uc,Bc,Ctt),
	write('Ctt: '),
	writeln(Ctt),
	multiply_lists(Ft,Ct0,Ct1),
	multiply_lists(It,Ctt,Ct2),
	add_lists(Ct1,Ct2,Ct),
	tanh(Ct,TanhCt),
	multiply_lists(Ot,TanhCt,Os1),
	write('Os1: '),
	writeln(Os1),
	conv_lstm2D_layer(Is,[[W|Ws0]|Ws],Us,Bs,Ct1,Os1,Os). */
/*   i = self.recurrent_activation(x_i + h_i)
    f = self.recurrent_activation(x_f + h_f)
    o = self.recurrent_activation(x_o + h_o)
    ctt =  self.activation(x_c + h_c)
    c1 = f * c_tm1 
    c2 = i * ctt
    cF = c1 + c2
    h = o * self.activation(cF) */
%apply_lstm_step_conv1Test(Is,Ws,Us,Bs,Ct0,Ct,Os0,Os) :-

initialize_convlstm2d_variables(Is,KernelSizeD1,KernelSizeD2,Os0,Ct0,Ws,Us,Bs,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo) :-
	length(Is,L0),
	sub_length(Is,L1),
	sub_sub_length(Is,L2),
	sub_sub_sub_length(Is,L3),
	empty_field4D(0,L0,L1,L2,L3,Os0),
	split_convlstm_weights(4,Ws,Wi,Wf,Wc,Wo),
	split_convlstm_hidden_weights(4,Bs,Us,Ui,Uf,Uc,Uo),
	split_convlstm_bias(Bs,Bi,Bf,Bc,Bo),
	conv2D_layer(Is,KernelSizeD1,KernelSizeD2,Wi,Bi,Xi),
	length(Xi,CL0),
	sub_length(Xi,CL1),
	sub_sub_length(Xi,CL2),
	sub_sub_sub_length(Xi,CL3),
	empty_field4D(0,CL0,CL1,CL2,CL3,Ct0).

apply_lstm_step_convlstm2d(Is,KernelSizeD1,KernelSizeD2,Os0,Ct0,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo,Os1,Ct1) :-
	length(Bi,Lb),
	empty_list(0,Lb,Bempty),
	conv2D_layer(Is,KernelSizeD1,KernelSizeD2,Wi,Bi,Xi),
	conv2D_layer(Is,KernelSizeD1,KernelSizeD2,Wf,Bf,Xf),
	conv2D_layer(Is,KernelSizeD1,KernelSizeD2,Wc,Bc,Xc),
	conv2D_layer(Is,KernelSizeD1,KernelSizeD2,Wo,Bo,Xo),
	conv2D_layer(Os0,KernelSizeD1,KernelSizeD2,Ui,Bempty,Hi),
	conv2D_layer(Os0,KernelSizeD1,KernelSizeD2,Uf,Bempty,Hf),
	conv2D_layer(Os0,KernelSizeD1,KernelSizeD2,Uc,Bempty,Hc),
	conv2D_layer(Os0,KernelSizeD1,KernelSizeD2,Uo,Bempty,Ho),
	% write('Ct0: '),writeln(Ct0),
	add_layer([Xi,Hi],[It0]),
	keep(It0,It),
	% write('It: '),writeln(It),
	add_layer([Xf,Hf],[Ft0]),
	keep(Ft0,Ft),
	% write('Ft: '),writeln(Ft),
	add_layer([Xo,Ho],[Ot0]),
	keep(Ot0,Ot),
	% write('Ot: '),writeln(Ot),
	multiply_lists([Ft],Ct0,CtTemp0),
	% write('CtTemp0: '),writeln(CtTemp0),
	add_layer([Xc,Hc],CtTemp1),
	multiply_lists([It],CtTemp1,CtTemp2),
	% write('CtTemp2: '),writeln(CtTemp2),
	add_lists(CtTemp2,CtTemp0,Ct1),
	multiply_lists([Ot],Ct1,Os1).

conv_lstm3D_layer([[[[[I|Is0]|Is1]|Is2]|Is3]|Is],Ws,Us,Bs,Os) :- 
	is_list(I), conv_lstm3D_layer([[[[[I|Is0]|Is1]|Is2]|Is3]|Is],Ws,Us,Bs,[],Os).
conv_lstm3D_layer([[[[[I|Is0]|Is1]|Is2]|Is3]|Is],Ws,Us,Bs,Os) :- 
	atomic(I), 
	conv_lstm3D_layer([[[[[I|Is0]|Is1]|Is2]|Is3]|Is],Ws,Us,Bs,[],[],Os).
conv_lstm3D_layer([[[[[I|Is0]|Is1]|Is2]|Is3]|Is],Ws,Us,Bs,Os0,Os) :-
	is_list(I),
	conv_lstm3D_layer([[[[I|Is0]|Is1]|Is2]|Is3],Ws,Us,Bs,O),
	append(Os0,O,Os1),
	conv_lstm3D_layer(Is,Ws,Us,Bs,Os1,Os).	
conv_lstm3D_layer([],_,_,_,Os,Os).
conv_lstm3D_layer([],_,_,_,_,Os,Os).

conv_lstm3D_layer([[[[[I|Is0]|Is1]|Is2]|Is3]|Is],[[W|Ws0]|Ws],Us,Bs,Ct0,Os0,Os) :-
	atomic(I),
	length([[W|Ws0]|Ws], KernelSizeD1),
	length([W|Ws0],KernelSizeD2),
	length(W,KernelSizeD3),
	(Ct0 = [] -> 
		(
			initialize_convlstm3d_variables([[[[[I|Is0]|Is1]|Is2]|Is3]],KernelSizeD1,KernelSizeD2,KernelSizeD3,Os0Ready,Ct0Ready,[[W|Ws0]|Ws],Us,Bs,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo),
			apply_lstm_step_convlstm3d([[[[[I|Is0]|Is1]|Is2]|Is3]],KernelSizeD1,KernelSizeD2,KernelSizeD3,Os0Ready,Ct0Ready,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo,Os1,Ct1)
		);
		(	
			PadLeftD1 is div(KernelSizeD1-1,2), 
			PadRightD1 is KernelSizeD1 - 1 - PadLeftD1,
			PadLeftD2 is div(KernelSizeD2-1,2), 
			PadRightD2 is KernelSizeD2 - 1 - PadLeftD2,
			PadLeftD3 is div(KernelSizeD3-1,2), 
			PadRightD3 is KernelSizeD3 - 1 - PadLeftD3,
			split_convlstm_weights(5,[[W|Ws0]|Ws],Wi,Wf,Wc,Wo),
			split_convlstm_weights(5,Us,Ui,Uf,Uc,Uo),
			split_convlstm_bias(Bs,Bi,Bf,Bc,Bo),
			padding3D(Os0,0,PadLeftD1,PadRightD1,PadLeftD2,PadRightD2,PadLeftD3,PadRightD3,Os0Ready),
			apply_lstm_step_convlstm3d([[[[[I|Is0]|Is1]|Is2]|Is3]],KernelSizeD1,KernelSizeD2,KernelSizeD3,Os0Ready,Ct0,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo,Os1,Ct1)
		)
	),
	conv_lstm3D_layer(Is,[[W|Ws0]|Ws],Us,Bs,Ct1,Os1,Os).

initialize_convlstm3d_variables(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Os0,Ct0,Ws,Us,Bs,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo) :-
	length(Is,L0),
	sub_length(Is,L1),
	sub_sub_length(Is,L2),
	sub_sub_sub_length(Is,L3),
	sub_sub_sub_sub_length(Is,L4),
	empty_field5D(0,L0,L1,L2,L3,L4,Os0),
	split_convlstm_weights(5,Ws,Wi,Wf,Wc,Wo),
	split_convlstm_hidden_weights(5,Bs,Us,Ui,Uf,Uc,Uo),
	split_convlstm_bias(Bs,Bi,Bf,Bc,Bo),
	conv3D_layer(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Wi,Bi,Xi),
	length(Xi,CL0),
	sub_length(Xi,CL1),
	sub_sub_length(Xi,CL2),
	sub_sub_sub_length(Xi,CL3),
	sub_sub_sub_sub_length(Xi,CL4),
	empty_field5D(0,CL0,CL1,CL2,CL3,CL4,Ct0).

apply_lstm_step_convlstm3d(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Os0,Ct0,Wi,Wf,Wc,Wo,Ui,Uf,Uc,Uo,Bi,Bf,Bc,Bo,Os1,Ct1) :-
	length(Bi,Lb),
	empty_list(0,Lb,Bempty),
	conv3D_layer(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Wi,Bi,Xi),
	conv3D_layer(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Wf,Bf,Xf),
	conv3D_layer(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Wc,Bc,Xc),
	conv3D_layer(Is,KernelSizeD1,KernelSizeD2,KernelSizeD3,Wo,Bo,Xo),
	conv3D_layer(Os0,KernelSizeD1,KernelSizeD2,KernelSizeD3,Ui,Bempty,Hi),
	conv3D_layer(Os0,KernelSizeD1,KernelSizeD2,KernelSizeD3,Uf,Bempty,Hf),
	conv3D_layer(Os0,KernelSizeD1,KernelSizeD2,KernelSizeD3,Uc,Bempty,Hc),
	conv3D_layer(Os0,KernelSizeD1,KernelSizeD2,KernelSizeD3,Uo,Bempty,Ho),
	% write('Ct0: '),writeln(Ct0),
	add_layer([Xi,Hi],[It0]),
	keep(It0,It),
	% write('It: '),writeln(It),
	add_layer([Xf,Hf],[Ft0]),
	keep(Ft0,Ft),
	% write('Ft: '),writeln(Ft),
	add_layer([Xo,Ho],[Ot0]),
	keep(Ot0,Ot),
	multiply_lists([Ft],Ct0,CtTemp0),
	add_layer([Xc,Hc],CtTemp1),
	multiply_lists([It],CtTemp1,CtTemp2),
	add_lists(CtTemp2,CtTemp0,Ct1),
	multiply_lists([Ot],Ct1,Os1).

split_convlstm_weights(_,[],[],[],[],[]).
split_convlstm_weights(5,[W0|Ws],[Wi0|Wis],[Wf0|Wfs],[Wc0|Wcs],[Wo0|Wos]) :-
	check_dimensions([W0|Ws], 5),
	split_convlstm_weights(4,W0,Wi0,Wf0,Wc0,Wo0),
	split_convlstm_weights(5,Ws,Wis,Wfs,Wcs,Wos).
split_convlstm_weights(4,[W0|Ws],[Wi0|Wis],[Wf0|Wfs],[Wc0|Wcs],[Wo0|Wos]) :-
	check_dimensions([W0|Ws], 4),
	split_convlstm_weights(3,W0,Wi0,Wf0,Wc0,Wo0),
	split_convlstm_weights(4,Ws,Wis,Wfs,Wcs,Wos).
split_convlstm_weights(3,[W0|Ws],[Wi0|Wis],[Wf0|Wfs],[Wc0|Wcs],[Wo0|Wos]) :-
	check_dimensions([W0|Ws], 3),
	split_convlstm_weights(2,W0,Wi0,Wf0,Wc0,Wo0),
	split_convlstm_weights(3,Ws,Wis,Wfs,Wcs,Wos).
split_convlstm_weights(2,[W0|Ws],[Wi0|Wis],[Wf0|Wfs],[Wc0|Wcs],[Wo0|Wos]) :-
	check_dimensions([W0|Ws],2),
	length(W0,L),
	LN is L / 4,
	split_at(LN,W0,Wi0,WT),
	split_at(LN,WT,Wf0,WT1),
	split_at(LN,WT1,Wc0,Wo0),
	split_convlstm_weights(2,Ws,Wis,Wfs,Wcs,Wos).

split_convlstm_hidden_weights(_,_,[],[],[],[],[]).
split_convlstm_hidden_weights(5,Bs,[W0|Ws],[Wi0|Wis],[Wf0|Wfs],[Wc0|Wcs],[Wo0|Wos]) :-
	check_dimensions([W0|Ws], 5),
	split_convlstm_hidden_weights(4,Bs,W0,Wi0,Wf0,Wc0,Wo0),
	split_convlstm_hidden_weights(5,Bs,Ws,Wis,Wfs,Wcs,Wos).
split_convlstm_hidden_weights(4,Bs,[W0|Ws],[Wi0|Wis],[Wf0|Wfs],[Wc0|Wcs],[Wo0|Wos]) :-
	check_dimensions([W0|Ws], 4),
	split_convlstm_hidden_weights(3,Bs,W0,Wi0,Wf0,Wc0,Wo0),
	split_convlstm_hidden_weights(4,Bs,Ws,Wis,Wfs,Wcs,Wos).
split_convlstm_hidden_weights(3,Bs,[W0|Ws],[Wi0|Wis],[Wf0|Wfs],[Wc0|Wcs],[Wo0|Wos]) :-
	check_dimensions([W0|Ws], 3),
	length(Bs,CL),
	N is CL / 4,
	split_to_equal_n_element_lists(N,W0,[],U0),
	split_convlstm_hidden_weights(2,Bs,U0,Wi0,Wf0,Wc0,Wo0),
	split_convlstm_hidden_weights(3,Bs,Ws,Wis,Wfs,Wcs,Wos).
split_convlstm_hidden_weights(2,Bs,[W0|Ws],[Wi0|Wis],[Wf0|Wfs],[Wc0|Wcs],[Wo0|Wos]) :-
	check_dimensions([W0|Ws],2),
	length(W0,L),
	LN is L / 4,
	split_at(LN,W0,Wi0,WT),
	split_at(LN,WT,Wf0,WT1),
	split_at(LN,WT1,Wc0,Wo0),
	split_convlstm_hidden_weights(2,Bs,Ws,Wis,Wfs,Wcs,Wos).

split_to_equal_n_element_lists(_,[],Os,Os).
split_to_equal_n_element_lists(0,Ws,_,Ws).
split_to_equal_n_element_lists(1,Ws,_,Ws).
split_to_equal_n_element_lists(N,Is,Os0,Os):-	
	check_dimensions(Is,2), 
	split_at(N,Is,Is0,Is1),
	add_layer(Is0,I0),
	append(Os0,[I0],Os1),
	split_to_equal_n_element_lists(N,Is1,Os1,Os).

split_convlstm_bias(Bs,Bi,Bf,Bc,Bo) :-
	is_list(Bs),
	length(Bs,L),
	LN is L / 4,
	split_at(LN,Bs,Bi,BT),
	split_at(LN,BT,Bf,BT1),
	split_at(LN,BT1,Bc,Bo).
% apply_lstm_step_conv1Test(Is,_,_,_,Ct0,Ct,Os0,Os) :-
% %apply_lstm_step_conv1Test([I|IsT],Ws,Us,Bs,Ct0,Ct,[O0|Os0T],Os) :-
% 		write('Ct0: '),writeln(Ct0),
% 		write('Os0: '),writeln(Os0),
% 	%TODO Check	
% 	%(contains_only_zero([O0|Os0T]) -> (Is = [I|IsT], Os0 = [O0|Os0T]);(add_layer([I,O0],[I1]),Is = [I1|IsT], Os0 = [O0|Os0T]) ),
	
% 	add_layer([Is,Os0],[It0]),%add_layer([Is,Ct0,Os0],[It0]),
% 	%(contains_only_zero(Os0) -> add_layer([Is,Os0],[It0]);add_layer([Is,Ct0,Os0],[It0])),
% 	keep(It0,It),
% 		% write('It: '),writeln(It),
% 	add_layer([Is,Os0],[Ft0]),%add_layer([Is,Ct0,Os0],[Ft0]),
% 	%(contains_only_zero(Os0) -> add_layer([Is,Os0],[Ft0]);add_layer([Is,Ct0,Os0],[Ft0])),
% 	keep(Ft0,Ft),
% 		% write('Ft: '),writeln(Ft),
% 	add_layer([Is,Os0],[Ot0]),
% 	%(contains_only_zero(Os0) -> add_layer([Is,Os0],[Ot0]);add_layer([Is,Ct,Os0],[Ot0])),
% 	keep(Ot0,Ot),
% 	% writeln(Ot),
% 	add_layer([Is,Os0],[CtTemp0]),%add_layer([Is,Ct0,Os0],[CtTemp0]),
% 	%(contains_only_zero(Os0) -> add_layer([Is,Os0],[CtTemp0]);add_layer([Is,Ct0,Os0],[CtTemp0])),
% 	keep(CtTemp0,Ctt),
% 		% write('Ctt: '),writeln(Ctt),
% 	multiply_lists([Ft],Ct0,Ct1),
% 		% write('Ct1: '),writeln(Ct1),
% 	multiply_lists(It,Ctt,Ct2),
% 		% write('Ct2: '),writeln(Ct2),
% 	add_lists(Ct1,[Ct2],Ct),
% 		write('Ct: '),writeln(Ct),
% 	keep(Ct,TanhCt),
% 		% write('TanhCt: '),writeln(TanhCt),
% 	multiply_lists([Ot],TanhCt,Os),
% 	write('Os1: '),writeln(Os).
	
apply_lstm_step_conv(Is,Ws,Us,Bs,Ct0,Ct,Os0,Os) :- apply_lstm_step_conv(Is,0,0,Ws,Us,Bs,Ct0,Ct,Os0,Os).
apply_lstm_step_conv([I|Is],X,Y,_,_,_,Ct,Ct,Os,Os) :-
	length([I|Is],LX), 
	length(I,LY),
	(X>= LX;Y >=LY),
	writeln("EXIT apply_lstm_step_conv").
apply_lstm_step_conv(Is,X,Y,Ws,Us,Bs,Ct0,Ct,Os0,Os) :-
	length(Is,LX), 
		write('x: '),writeln(X),
		write('y: '),writeln(Y),
		write('Os0: '),writeln(Os0),
		write('Ct0: '),writeln(Ct0),
	nth0_2D(0,0, Ws,WsM),
	nth0_2D(0,0, Us,UsM),
	nth0_2D(X,Y, Is,IsM),
	nth0_2D(X,Y, Os0,OsM),
	nth0_2D(X,Y, Ct0,CtM),
	
	split_lstm_weights(WsM, Wi,Wf,Wc,Wo),
	split_lstm_weights(UsM, Ui,Uf,Uc,Uo),
	split_lstm_weights([Bs], Bi,Bf,Bc,Bo),
		write('Wi: '),writeln(Wi),
		write('Ui: '),writeln(Ui),
		write('Bi: '),writeln(Bi),

	sig_gate_conv([IsM],[OsM],Wi,Ui,Bi,[CtM],Wc,It),
	sig_gate_conv([IsM],[OsM],Wf,Uf,Bf,[CtM],Wc,Ft),
	%sig_gate_conv([IsM],[OsM],Wo,Uo,Bo,[CtM],Wc,Ot),
		write('Ot: '),writeln(Ot),
	
	tanh_gate([IsM],[OsM],Wc,Uc,Bc,Ctt),
		write('Ctt: '),writeln(Ctt),
	multiply_lists(Ft,[CtM],Ct1),
	multiply_lists(It,Ctt,Ct2),
	add_lists(Ct1,Ct2,[CtF]),
		write('CtF: '),writeln(CtF),
	tanh([CtF],TanhCt),
		write('TanhCt: '),writeln(TanhCt),
	sig_gate_conv([IsM],[OsM],Wo,Uo,Bo,[CtF],Wc,Ot),
	multiply_lists(Ot,TanhCt,[Os1]),
		write('Os1: '),writeln(Os1),
	replace(Os0,X,Y,Os1,Os2),
		write('Os2: '),writeln(Os2),
	replace(Ct0,X,Y,CtF,CtN),
		write('CtN: '),writeln(CtN),
	((X < LX - 1) -> X1 is X + 1,Y1 is Y;X1 is 0,Y1 is Y+1),
	apply_lstm_step_conv(Is,X1,Y1,Ws,Us,Bs,CtN,Ct,Os2,Os).
	
sig_gate_conv(Is,HtPast,W,U,B,CtPast,C,Os) :-
	mmult(Is,W,Os0),
	mmult(HtPast,U,Os1),
	multiply_lists(CtPast,C,Os2),
	add_layer([Os0,Os1,Os2,B],[Os5]),
	%add_lists(Os0,Os1,Os3),
	%add_lists(Os3,Os2,Os4),
	%add_lists(Os4,B,Os5),
	sigmoid_func(Os5,Os).	
	
contains_only_zero([]).	
contains_only_zero(X) :-
	atomic(X),
	X = 0.
contains_only_zero([X|Xs]) :-
	is_list([X|Xs]),
	contains_only_zero(X),
	contains_only_zero(Xs).

/*
model = keras.Sequential([
keras.layers.ConvLSTM2D(1, (1, 1),recurrent_activation='linear', activation='linear',  input_shape=(3, 1, 1, 1))])
w = model.get_weights()
w[0] = np.array([[[[1, 1, 1, 1]]]])
w[1] = np.array([[[[1, 1, 1, 1]]]])
w[2] = np.array([0, 0, 0, 0])
model.set_weights(w)
x = tf.constant([[[[[2]]], [[[5]]], [[[3]]]]])
print (np.array2string(model.predict(x,steps=1), separator=', '))

-------------------------------------------------------------------------------------
2021-02-24 06:47:27.614278: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcudart.so.11.0'; dlerror: libcudart.so.11.0: cannot open shared object file: No such file or directory2021-02-24 06:47:27.614305: I tensorflow/stream_executor/cuda/cudart_stub.cc:29] Ignore above cudart dlerror if you do not have a GPU set up on your machine.2021-02-24 06:47:28.443538: I tensorflow/compiler/jit/xla_cpu_device.cc:41] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-02-24 06:47:28.443638: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcuda.so.1'; dlerror: libcuda.so.1: cannot open shared object file: No such file or directory2021-02-24 06:47:28.443645: W tensorflow/stream_executor/cuda/cuda_driver.cc:326] failed call to cuInit: UNKNOWN ERROR (303)2021-02-24 06:47:28.443662: I tensorflow/stream_executor/cuda/cuda_diagnostics.cc:156] kernel driver does not appear to be running on this host (admin1-ThinkPad-X1-Carbon-7th): /proc/driver/nvidia/version does not exist2021-02-24 06:47:28.443996: I tensorflow/compiler/jit/xla_gpu_device.cc:99] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-02-24 06:47:28.569278: I tensorflow/compiler/mlir/mlir_graph_optimization_pass.cc:116] None of the MLIR optimization passes are enabled (registered 2)2021-02-24 06:47:28.586440: I tensorflow/core/platform/profile_utils/cpu_utils.cc:112] CPU Frequency: 1999965000 Hz

-------------------------------------------------------------------------------------
Prolog Script:
-------------------------------------------------------------------------------------
conv_lstm2D_layer([[[[[2]]], [[[5]]], [[[3]]]]], [[[[1, 1, 1, 1]]]],[[[[1, 1, 1, 1]]]],[0, 0, 0, 0], X)
-------------------------------------------------------------------------------------
before conv[[[2]]]111[[[[1]]]][0]after conv[[[2]]]Ct0: [[[0]]]Os0: [[[0]]]It: [[[2]]]Ft: [[[2]]]Ctt: [[[2]]]Ct: [[[4]]]TanhCt: [[[4]]]Os1: [[[8]]]aapply_lstm_step_conv doneCt1: [[[4]]]Os1: [[[8]]]before conv[[[5]]]111[[[[1]]]][0]after conv[[[5]]]Ct0: [[[4]]]Os0: [[[8]]]It: [[[13]]]Ft: [[[13]]]Ctt: [[[13]]]Ct: [[[221]]]TanhCt: [[[221]]]Os1: [[[2873]]]aapply_lstm_step_conv doneCt1: [[[221]]]Os1: [[[2873]]]before conv[[[3]]]111[[[[1]]]][0]after conv[[[3]]]Ct0: [[[221]]]Os0: [[[2873]]]It: [[[2876]]]Ft: [[[2876]]]Ctt: [[[2876]]]Ct: [[[8906972]]]TanhCt: [[[8906972]]]Os1: [[[25616451472]]]aapply_lstm_step_conv doneCt1: [[[8906972]]]Os1: [[[25616451472]]]X = [[[[25616451472]]]] X = [[[[25616451472]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:523:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[25616451584.0000000]]]]
Expected (Unparsed): [[[[25616451472]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:523:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[25616451584]]]]
Expected: [[[[25616451472]]]]


model = keras.Sequential([
keras.layers.ConvLSTM2D(1, (2, 3),recurrent_activation='linear', activation='linear',  input_shape=(2, 2, 3, 1))])
w = model.get_weights()
w[0] = np.array([[[[1, 1, 1, 1]], [[1, 1, 1, 1]], [[1, 1, 1, 1]]], [[[1, 1, 1, 1]], [[1, 1, 1, 1]], [[1, 1, 1, 1]]]])
w[1] = np.array([[[[1, 1, 1, 1]], [[1, 1, 1, 1]], [[1, 1, 1, 1]]], [[[1, 1, 1, 1]], [[1, 1, 1, 1]], [[1, 1, 1, 1]]]])
w[2] = np.array([0, 0, 0, 0])
model.set_weights(w)
x = tf.constant([[[[[3], [5], [5]], [[1], [5], [5]]], [[[4], [4], [2]], [[4], [4], [3]]]]])
print (np.array2string(model.predict(x,steps=1), separator=', '))

-------------------------------------------------------------------------------------
2021-02-24 04:28:15.872170: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcudart.so.11.0'; dlerror: libcudart.so.11.0: cannot open shared object file: No such file or directory2021-02-24 04:28:15.872189: I tensorflow/stream_executor/cuda/cudart_stub.cc:29] Ignore above cudart dlerror if you do not have a GPU set up on your machine.2021-02-24 04:28:16.657072: I tensorflow/compiler/jit/xla_cpu_device.cc:41] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-02-24 04:28:16.657166: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcuda.so.1'; dlerror: libcuda.so.1: cannot open shared object file: No such file or directory2021-02-24 04:28:16.657173: W tensorflow/stream_executor/cuda/cuda_driver.cc:326] failed call to cuInit: UNKNOWN ERROR (303)2021-02-24 04:28:16.657189: I tensorflow/stream_executor/cuda/cuda_diagnostics.cc:156] kernel driver does not appear to be running on this host (admin1-ThinkPad-X1-Carbon-7th): /proc/driver/nvidia/version does not exist2021-02-24 04:28:16.657488: I tensorflow/compiler/jit/xla_gpu_device.cc:99] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-02-24 04:28:16.774385: I tensorflow/compiler/mlir/mlir_graph_optimization_pass.cc:116] None of the MLIR optimization passes are enabled (registered 2)2021-02-24 04:28:16.793595: I tensorflow/core/platform/profile_utils/cpu_utils.cc:112] CPU Frequency: 1999965000 Hz

-------------------------------------------------------------------------------------
Prolog Script:
-------------------------------------------------------------------------------------
conv_lstm2D_layer([[[[[3], [5], [5]], [[1], [5], [5]]], [[[4], [4], [2]], [[4], [4], [3]]]]], [[[[1, 1, 1, 1]], [[1, 1, 1, 1]], [[1, 1, 1, 1]]], [[[1, 1, 1, 1]], [[1, 1, 1, 1]], [[1, 1, 1, 1]]]],[[[[1, 1, 1, 1]], [[1, 1, 1, 1]], [[1, 1, 1, 1]]], [[[1, 1, 1, 1]], [[1, 1, 1, 1]], [[1, 1, 1, 1]]]],[0, 0, 0, 0], X)
-------------------------------------------------------------------------------------
before conv[[[3],[5],[5]],[[1],[5],[5]]]231[[[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]]]][0]after conv[[[24]]]Ct0: [[[0]]]Os0: [[[0]]]It: [[[24]]]Ft: [[[24]]]Ctt: [[[24]]]Ct: [[[576]]]TanhCt: [[[576]]]Os1: [[[13824]]]aapply_lstm_step_conv doneCt1: [[[576]]]Os1: [[[13824]]]before conv[[[4],[4],[2]],[[4],[4],[3]]]231[[[[1]],[[1]],[[1]]],[[[1]],[[1]],[[1]]]][0]after conv[[[21]]]Ct0: [[[576]]]Os0: [[[13824]]]It: [[[13845]]]Ft: [[[13845]]]Ctt: [[[13845]]]Ct: [[[199658745]]]TanhCt: [[[199658745]]]Os1: [[[2764275324525]]]aapply_lstm_step_conv doneCt1: [[[199658745]]]Os1: [[[2764275324525]]]X = [[[[2764275324525]]]] X = [[[[2764275324525]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:523:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[2764275449856.0000000]]]]
Expected (Unparsed): [[[[2764275324525]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:523:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[2764275449856]]]]
Expected: [[[[2764275324525]]]]

keras.layers.ConvLSTM2D(1, (2, 2),recurrent_activation='sigmoid', activation='tanh',  input_shape=(2, 3, 2, 1))])
w = model.get_weights()
w[0] = np.array([[[[1, 1, 1, 1]], [[1, 1, 1, 1]]], [[[1, 1, 1, 1]], [[1, 1, 1, 1]]]])
w[1] = np.array([[[[1, 1, 1, 1]], [[1, 1, 1, 1]]], [[[1, 1, 1, 1]], [[1, 1, 1, 1]]]])
w[2] = np.array([0, 0, 0, 0])
model.set_weights(w)
x = tf.constant([[[[[0.07], [0.8051]], [[0.589], [0.8446]], [[0.8147], [0.869]]], [[[0.9435], [0.2307]], [[0.4907], [0.6512]], [[0.6688], [0.455]]]]])
print (np.array2string(model.predict(x,steps=1), separator=', '))

-------------------------------------------------------------------------------------
2021-01-13 05:10:40.359760: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcudart.so.11.0'; dlerror: libcudart.so.11.0: cannot open shared object file: No such file or directory2021-01-13 05:10:40.359775: I tensorflow/stream_executor/cuda/cudart_stub.cc:29] Ignore above cudart dlerror if you do not have a GPU set up on your machine.2021-01-13 05:10:41.158173: I tensorflow/compiler/jit/xla_cpu_device.cc:41] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-01-13 05:10:41.158290: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcuda.so.1'; dlerror: libcuda.so.1: cannot open shared object file: No such file or directory2021-01-13 05:10:41.158298: W tensorflow/stream_executor/cuda/cuda_driver.cc:326] failed call to cuInit: UNKNOWN ERROR (303)2021-01-13 05:10:41.158314: I tensorflow/stream_executor/cuda/cuda_diagnostics.cc:156] kernel driver does not appear to be running on this host (admin1-ThinkPad-X1-Carbon-7th): /proc/driver/nvidia/version does not exist2021-01-13 05:10:41.158707: I tensorflow/compiler/jit/xla_gpu_device.cc:99] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-01-13 05:10:41.278142: I tensorflow/compiler/mlir/mlir_graph_optimization_pass.cc:116] None of the MLIR optimization passes are enabled (registered 2)2021-01-13 05:10:41.298844: I tensorflow/core/platform/profile_utils/cpu_utils.cc:112] CPU Frequency: 1999965000 Hz

-------------------------------------------------------------------------------------
Prolog Script:
-------------------------------------------------------------------------------------
conv_lstm2D_layer([[[[[0.07], [0.8051]], [[0.589], [0.8446]], [[0.8147], [0.869]]], [[[0.9435], [0.2307]], [[0.4907], [0.6512]], [[0.6688], [0.455]]]]], [[[[1, 1, 1, 1]], [[1, 1, 1, 1]]], [[[1, 1, 1, 1]], [[1, 1, 1, 1]]]],[[[[1, 1, 1, 1]], [[1, 1, 1, 1]]], [[[1, 1, 1, 1]], [[1, 1, 1, 1]]]],[0, 0, 0, 0], X)
-------------------------------------------------------------------------------------
before conv[[[0.07],[0.8051]],[[0.589],[0.8446]],[[0.8147],[0.869]]]221[[[[1]],[[1]]],[[[1]],[[1]]]][0]after conv[[[2.3087]],[[3.1173]]]Ct0: [[[0]],[[0]]]Os0: [[[0]],[[0]]]It: [[[0.9095950106986722]],[[0.9576007392791888]]]Ft: [[[0.9095950106986722]],[[0.9576007392791888]]]Ctt: [[[0.9804363650003088]],[[0.9960868449552862]]]Ct: [[[0.8918000259118232]],[[0.9538534991154568]]]TanhCt: [[[0.7122816607661794]],[[0.741522643630449]]]Os1: [[[0.647887844845081]],[[0.7100826317327763]]]aapply_lstm_step_conv doneCt1: [[[0.8918000259118232]],[[0.9538534991154568]]]Os1: [[[0.647887844845081]],[[0.7100826317327763]]]before conv[[[0.9435],[0.2307]],[[0.4907],[0.6512]],[[0.6688],[0.455]]]221[[[[1]],[[1]]],[[[1]],[[1]]]][0]after conv[[[2.3161]],[[2.2657]]]Ct0: [[[0.8918000259118232]],[[0.9538534991154568]]]Os0: [[[0.647887844845081]],[[0.7100826317327763]]]It: [[[0.9509204446648665]],[[0.9514679977309033]]]Ft: [[[0.9509204446648665]],[[0.9514679977309033]]]Ctt: [[[0.9946864166262805]],[[0.9948099734647711]]]Ct: [[[1.7938985267925758]],[[1.8540909325072583]]]TanhCt: [[[0.9461704907330338]],[[0.9521297432638247]]]Os1: [[[0.8997328637766314]],[[0.9059209804032703]]]aapply_lstm_step_conv doneCt1: [[[1.7938985267925758]],[[1.8540909325072583]]]Os1: [[[0.8997328637766314]],[[0.9059209804032703]]]X = [[[[0.8997328637766314]], [[0.9059209804032703]]]] X = [[[[0.8997328637766314]], [[0.9059209804032703]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:522:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.92761576]], [[0.905921 ]]]]
Expected (Unparsed): [[[[0.8997328637766314]], [[0.9059209804032703]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:522:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[0.9277]], [[0.906]]]]
Expected: [[[[0.8998]], [[0.906]]]]




model = keras.Sequential([
keras.layers.ConvLSTM2D(1, (1, 2),recurrent_activation='sigmoid', activation='tanh',  input_shape=(2, 1, 3, 1))])
w = model.get_weights()
w[0] = np.array([[[[1, 1, 1, 1]], [[1, 1, 1, 1]]]])
w[1] = np.array([[[[1, 1, 1, 1]], [[1, 1, 1, 1]]]])
w[2] = np.array([0, 0, 0, 0])
model.set_weights(w)
x = tf.constant([[[[[0.3533], [0.6746], [0.8438]]], [[[0.1289], [0.0789], [0.4247]]]]])
print (np.array2string(model.predict(x,steps=1), separator=', '))

conv_lstm2D_layer([[[[[0.3533], [0.6746], [0.8438]]], [[[0.1289], [0.0789], [0.4247]]]]], [[[[1, 1, 1, 1]], [[1, 1, 1, 1]]]],[[[[1, 1, 1, 1]], [[1, 1, 1, 1]]]],[0, 0, 0, 0], X)
-------------------------------------------------------------------------------------
before conv[[[0.3533],[0.6746],[0.8438]]]121[[[[1]],[[1]]]][0]after conv[[[1.0279],[1.5184]]]Ct0: [[[0],[0]]]Os0: [[[0],[0]]]It: [[[0.7365085645238311],[0.8203027516146936]]]Ft: [[[0.7365085645238311],[0.8203027516146936]]]Ctt: [[[0.7730647317064894],[0.9084184229795329]]]Ct: [[[0.569368795833147],[0.7451781319875914]]]TanhCt: [[[0.5148955678463898],[0.6322634796629434]]]Os1: [[[0.3792249955542274],[0.5186474721129933]]]aapply_lstm_step_conv doneCt1: [[[0.569368795833147],[0.7451781319875914]]]Os1: [[[0.3792249955542274],[0.5186474721129933]]]before conv[[[0.1289],[0.0789],[0.4247]]]121[[[[1]],[[1]]]][0]after conv[[[0.20779999999999998],[0.5036]]]Ct0: [[[0.569368795833147],[0.7451781319875914]]]Os0: [[[0.3792249955542274],[0.5186474721129933]]]It: [[[0.6426822507710395],[0.735410148537774]]]Ft: [[[0.6426822507710395],[0.735410148537774]]]Ctt: [[[0.5277525806260718],[0.7707803610118106]]]Ct: [[[0.7051004355918317],[1.1148512605137904]]]TanhCt: [[[0.6075952487197132],[0.805770556312181]]]Os1: [[[0.3904906820049748],[0.5925718445049057]]]aapply_lstm_step_conv doneCt1: [[[0.7051004355918317],[1.1148512605137904]]]Os1: [[[0.3904906820049748],[0.5925718445049057]]]X = [[[[0.3904906820049748], [0.5925718445049057]]]] X = [[[[0.3904906820049748], [0.5925718445049057]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:522:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.5816753 ], [0.59257185]]]]
Expected (Unparsed): [[[[0.3904906820049748], [0.5925718445049057]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:522:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[0.5817], [0.5926]]]]
Expected: [[[[0.3905], [0.5926]]]]





keras.layers.ConvLSTM2D(1, (1, 2),recurrent_activation='sigmoid', activation='tanh',  input_shape=(2, 3, 3, 1))])
w = model.get_weights()
w[0] = np.array([[[[1, 1, 1, 1]], [[1, 1, 1, 1]]]])
w[1] = np.array([[[[1, 1, 1, 1]], [[1, 1, 1, 1]]]])
w[2] = np.array([0, 0, 0, 0])
model.set_weights(w)
x = tf.constant([[[[[0.4609], [0.1127], [0.6412]], [[0.9091], [0.0442], [0.2777]], [[0.8949], [0.7041], [0.4194]]], [[[0.157], [0.4177], [0.0378]], [[0.2437], [0.7087], [0.943]], [[0.4343], [0.3117], [0.4831]]]]])
print (np.array2string(model.predict(x,steps=1), separator=', '))

-------------------------------------------------------------------------------------
2021-01-13 04:38:40.102739: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcudart.so.11.0'; dlerror: libcudart.so.11.0: cannot open shared object file: No such file or directory2021-01-13 04:38:40.102758: I tensorflow/stream_executor/cuda/cudart_stub.cc:29] Ignore above cudart dlerror if you do not have a GPU set up on your machine.2021-01-13 04:38:40.902236: I tensorflow/compiler/jit/xla_cpu_device.cc:41] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-01-13 04:38:40.902333: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcuda.so.1'; dlerror: libcuda.so.1: cannot open shared object file: No such file or directory2021-01-13 04:38:40.902341: W tensorflow/stream_executor/cuda/cuda_driver.cc:326] failed call to cuInit: UNKNOWN ERROR (303)2021-01-13 04:38:40.902382: I tensorflow/stream_executor/cuda/cuda_diagnostics.cc:156] kernel driver does not appear to be running on this host (admin1-ThinkPad-X1-Carbon-7th): /proc/driver/nvidia/version does not exist2021-01-13 04:38:40.902712: I tensorflow/compiler/jit/xla_gpu_device.cc:99] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-01-13 04:38:41.023737: I tensorflow/compiler/mlir/mlir_graph_optimization_pass.cc:116] None of the MLIR optimization passes are enabled (registered 2)2021-01-13 04:38:41.042765: I tensorflow/core/platform/profile_utils/cpu_utils.cc:112] CPU Frequency: 1999965000 Hz

-------------------------------------------------------------------------------------
Prolog Script:
-------------------------------------------------------------------------------------
conv_lstm2D_layer([[[[[0.4609], [0.1127], [0.6412]], [[0.9091], [0.0442], [0.2777]], [[0.8949], [0.7041], [0.4194]]], [[[0.157], [0.4177], [0.0378]], [[0.2437], [0.7087], [0.943]], [[0.4343], [0.3117], [0.4831]]]]], [[[[1, 1, 1, 1]], [[1, 1, 1, 1]]]],[[[[1, 1, 1, 1]], [[1, 1, 1, 1]]]],[0, 0, 0, 0], X)
-------------------------------------------------------------------------------------
before conv[[[0.4609],[0.1127],[0.6412]],[[0.9091],[0.0442],[0.2777]],[[0.8949],[0.7041],[0.4194]]]121[[[[1]],[[1]]]][0]after conv[[[0.5736],[0.7539]],[[0.9533],[0.3219]],[[1.599],[1.1235]]]Ct0: [[[0],[0]],[[0],[0]],[[0],[0]]]Os0: [[[0],[0]],[[0],[0]],[[0],[0]]]It: [[[0.6395934407075302],[0.6800278951591646]],[[0.7217783501750786],[0.5797872267914884]],[[0.8318785749340855],[0.7546373532360188]]]Ft: [[[0.6395934407075302],[0.6800278951591646]],[[0.7217783501750786],[0.5797872267914884]],[[0.8318785749340855],[0.7546373532360188]]]Ctt: [[[0.5179982279132685],[0.6374698761565406]],[[0.7412733869535948],[0.31122389983955184]],[[0.9215178885168622],[0.8087828938827835]]]Ct: [[[0.3313082688714509],[0.4334972981101056]],[[0.5350350822640583],[0.18044364179920572]],[[0.7665909878756748],[0.6103377823822715]]]TanhCt: [[[0.3196958243955492],[0.4082399028167504]],[[0.48922051790317506],[0.17851040683133573]],[[0.6449427966269341],[0.5443648288505605]]]Os1: [[[0.2044753523049797],[0.27761452183245666]],[[0.3531087782839512],[0.10349805373016051]],[[0.5365140945720176],[0.4107980336385653]]]aapply_lstm_step_conv doneCt1: [[[0.3313082688714509],[0.4334972981101056]],[[0.5350350822640583],[0.18044364179920572]],[[0.7665909878756748],[0.6103377823822715]]]Os1: [[[0.2044753523049797],[0.27761452183245666]],[[0.3531087782839512],[0.10349805373016051]],[[0.5365140945720176],[0.4107980336385653]]]before conv[[[0.157],[0.4177],[0.0378]],[[0.2437],[0.7087],[0.943]],[[0.4343],[0.3117],[0.4831]]]121[[[[1]],[[1]]]][0]after conv[[[0.5747],[0.4555]],[[0.9524],[1.6517]],[[0.746],[0.7948]]]Ct0: [[[0.3313082688714509],[0.4334972981101056]],[[0.5350350822640583],[0.18044364179920572]],[[0.7665909878756748],[0.6103377823822715]]]Os0: [[[0.2044753523049797],[0.27761452183245666]],[[0.3531087782839512],[0.10349805373016051]],[[0.5365140945720176],[0.4107980336385653]]]It: [[[0.6855023562711297],[0.6754883605111452]],[[0.7867606415227935],[0.8526072297285583]],[[0.782877427038306],[0.7695191452298357]]]Ft: [[[0.6855023562711297],[0.6754883605111452]],[[0.7867606415227935],[0.8526072297285583]],[[0.782877427038306],[0.7695191452298357]]]Ctt: [[[0.6522331248630457],[0.6249670849825476]],[[0.8631345873316975],[0.9419642538098467]],[[0.8571533140535699],[0.8353541698926285]]]Ct: [[[0.6742199428951883],[0.7149803707946971]],[[1.100024866208869],[0.9569730865006951]],[[1.2711927612624772],[1.1124876353802333]]]TanhCt: [[[0.587748903152244],[0.6137903975560117]],[[0.8005079535577908],[0.7429236622578348]],[[0.8541205976919417],[0.8049399727297785]]]Os1: [[[0.4029032580066353],[0.4146082693425944]],[[0.629808151085226],[0.6334220855774476]],[[0.6686717359014874],[0.6194167197763464]]]aapply_lstm_step_conv doneCt1: [[[0.6742199428951883],[0.7149803707946971]],[[1.100024866208869],[0.9569730865006951]],[[1.2711927612624772],[1.1124876353802333]]]Os1: [[[0.4029032580066353],[0.4146082693425944]],[[0.629808151085226],[0.6334220855774476]],[[0.6686717359014874],[0.6194167197763464]]]X = [[[[0.4029032580066353], [0.4146082693425944]], [[0.629808151085226], [0.6334220855774476]], [[0.6686717359014874], [0.6194167197763464]]]] X = [[[[0.4029032580066353], [0.4146082693425944]], [[0.629808151085226], [0.6334220855774476]], [[0.6686717359014874], [0.6194167197763464]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:522:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.5041533 ], [0.41460827]], [[0.6552774 ], [0.63342214]], [[0.7543414 ], [0.61941683]]]]
Expected (Unparsed): [[[[0.4029032580066353], [0.4146082693425944]], [[0.629808151085226], [0.6334220855774476]], [[0.6686717359014874], [0.6194167197763464]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:522:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[0.5042], [0.4147]], [[0.6553], [0.6335]], [[0.7544], [0.6195]]]]
Expected: [[[[0.403], [0.4147]], [[0.6299], [0.6335]], [[0.6687], [0.6195]]]]


conv_lstm2D_layer([[[[[0.8236]]], [[[0.1255]]]]], [[[[1, 1, 1, 1]]]],[[[[1, 1, 1, 1]]]],[0, 0, 0, 0], X)
-------------------------------------------------------------------------------------
before conv[[[0.8236]]]111[[[[1]]]][0]after conv[[[0.8236]]]Ct0: [[[0]]]Os0: [[[0]]]It: [[[0.6949999853827591]]]Ft: [[[0.6949999853827591]]]Ctt: [[[0.677024526490023]]]Ct: [[[0.47053203601433535]]]TanhCt: [[[0.4386290897781112]]]Os1: [[[0.3048472109842402]]]aapply_lstm_step_conv doneCt1: [[[0.47053203601433535]]]Os1: [[[0.3048472109842402]]]before conv[[[0.1255]]]111[[[[1]]]][0]after conv[[[0.1255]]]Ct0: [[[0.47053203601433535]]]Os0: [[[0.3048472109842402]]]It: [[[0.7111301546350611]]]Ft: [[[0.7111301546350611]]]Ctt: [[[0.7167257212553418]]]Ct: [[[0.8442947925188614]]]TanhCt: [[[0.6880771730472838]]]Os1: [[[0.5377573200798925]]]aapply_lstm_step_conv doneCt1: [[[0.8442947925188614]]]Os1: [[[0.5377573200798925]]]X = [[[[0.5377573200798925]]]] X = [[[[0.5377573200798925]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:522:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.2945388]]]]
Expected (Unparsed): [[[[0.5377573200798925]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:522:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[0.2946]]]]
Expected: [[[[0.5378]]]]


keras.layers.ConvLSTM2D(1, (2, 1),recurrent_activation='sigmoid', activation='tanh',  input_shape=(3, 3, 1, 1))])
w = model.get_weights()
w[0] = np.array([[[[1, 1, 1, 1]]], [[[1, 1, 1, 1]]]])
w[1] = np.array([[[[1, 1, 1, 1]]], [[[1, 1, 1, 1]]]])
w[2] = np.array([0, 0, 0, 0])
model.set_weights(w)
x = tf.constant([[[[[0.6163]], [[0.6118]], [[0.3773]]], [[[0.6997]], [[1]], [[0.6291]]], [[[0.5918]], [[0.8288]], [[0.9397]]]]])
print (np.array2string(model.predict(x,steps=1), separator=', '))

-------------------------------------------------------------------------------------
2021-01-13 00:33:02.336323: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcudart.so.11.0'; dlerror: libcudart.so.11.0: cannot open shared object file: No such file or directory2021-01-13 00:33:02.336341: I tensorflow/stream_executor/cuda/cudart_stub.cc:29] Ignore above cudart dlerror if you do not have a GPU set up on your machine.2021-01-13 00:33:03.107539: I tensorflow/compiler/jit/xla_cpu_device.cc:41] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-01-13 00:33:03.107636: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcuda.so.1'; dlerror: libcuda.so.1: cannot open shared object file: No such file or directory2021-01-13 00:33:03.107644: W tensorflow/stream_executor/cuda/cuda_driver.cc:326] failed call to cuInit: UNKNOWN ERROR (303)2021-01-13 00:33:03.107659: I tensorflow/stream_executor/cuda/cuda_diagnostics.cc:156] kernel driver does not appear to be running on this host (admin1-ThinkPad-X1-Carbon-7th): /proc/driver/nvidia/version does not exist2021-01-13 00:33:03.107969: I tensorflow/compiler/jit/xla_gpu_device.cc:99] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-01-13 00:33:03.228083: I tensorflow/compiler/mlir/mlir_graph_optimization_pass.cc:116] None of the MLIR optimization passes are enabled (registered 2)2021-01-13 00:33:03.246996: I tensorflow/core/platform/profile_utils/cpu_utils.cc:112] CPU Frequency: 1999965000 Hz

-------------------------------------------------------------------------------------
Prolog Script:
-------------------------------------------------------------------------------------
conv_lstm2D_layer([[[[[0.6163]], [[0.6118]], [[0.3773]]], [[[0.6997]], [[1]], [[0.6291]]], [[[0.5918]], [[0.8288]], [[0.9397]]]]], [[[[1, 1, 1, 1]]], [[[1, 1, 1, 1]]]],[[[[1, 1, 1, 1]]], [[[1, 1, 1, 1]]]],[0, 0, 0, 0], X)
-------------------------------------------------------------------------------------
before conv[[[0.6163]],[[0.6118]],[[0.3773]]]211[[[[1]]],[[[1]]]][0]after conv[[[1.2281]],[[0.9891000000000001]]]x: 0y: 0Wi: [[1]]Ui: [[1]]Bi: [[0]]Ot: [[0.7734858568336082]]Ctt: [[0.842027328478536]]CtF: [0.6512962296455345]TanhCt: [[0.57254193276279]]Os1: [0.44285308743619667]Os2: [[[0.44285308743619667]],[[0]]]CtN: [[[0.6512962296455345]],[[0]]]x: 1y: 0Wi: [[1]]Ui: [[1]]Bi: [[0]]Ot: [[0.7289101188504873]]Ctt: [[0.756978300480743]]CtF: [0.5517691429706583]TanhCt: [[0.5018449731635023]]Os1: [0.36579987903312805]Os2: [[[0.44285308743619667]],[[0.36579987903312805]]]CtN: [[[0.6512962296455345]],[[0.5517691429706583]]]EXIT apply_lstm_step_convaapply_lstm_step_conv doneCt1: [[[0.6512962296455345]],[[0.5517691429706583]]]Os1: [[[0.44285308743619667]],[[0.36579987903312805]]]before conv[[[0.6997]],[[1]],[[0.6291]]]211[[[[1]]],[[[1]]]][0]after conv[[[1.6997]],[[1.6291]]]x: 0y: 0Wi: [[1]]Ui: [[1]]Bi: [[0]]Ot: [[0.8949708377990795]]Ctt: [[0.9728298729421162]]CtF: [1.4535454987242233]TanhCt: [[0.896391718232561]]Os1: [0.8022444470627516]Os2: [[[0.8022444470627516]],[[0.36579987903312805]]]CtN: [[[1.4535454987242233]],[[0.5517691429706583]]]x: 1y: 0Wi: [[1]]Ui: [[1]]Bi: [[0]]Ot: [[0.880260557171496]]Ctt: [[0.9636654751162667]]CtF: [1.33397732127417]TanhCt: [[0.8702180584621083]]Os1: [0.7660186330025529]Os2: [[[0.8022444470627516]],[[0.7660186330025529]]]CtN: [[[1.4535454987242233]],[[1.33397732127417]]]EXIT apply_lstm_step_convaapply_lstm_step_conv doneCt1: [[[1.4535454987242233]],[[1.33397732127417]]]Os1: [[[0.8022444470627516]],[[0.7660186330025529]]]before conv[[[0.5918]],[[0.8288]],[[0.9397]]]211[[[[1]]],[[[1]]]][0]after conv[[[1.4205999999999999]],[[1.7685]]]x: 0y: 0Wi: [[1]]Ui: [[1]]Bi: [[0]]Ot: [[0.9022822748072612]]Ctt: [[0.9768139038752246]]CtF: [2.1928702103766464]TanhCt: [[0.97539904449092]]Os1: [0.8800852687080962]Os2: [[[0.8800852687080962]],[[0.7660186330025529]]]CtN: [[[2.1928702103766464]],[[1.33397732127417]]]x: 1y: 0Wi: [[1]]Ui: [[1]]Bi: [[0]]Ot: [[0.9265265532625876]]Ctt: [[0.9875016527931114]]CtF: [2.1509119123141263]TanhCt: [[0.9732742986994461]]Os1: [0.90176448135306]Os2: [[[0.8800852687080962]],[[0.90176448135306]]]CtN: [[[2.1928702103766464]],[[2.1509119123141263]]]EXIT apply_lstm_step_convaapply_lstm_step_conv doneCt1: [[[2.1928702103766464]],[[2.1509119123141263]]]Os1: [[[0.8800852687080962]],[[0.90176448135306]]]X = [[[[0.8800852687080962]], [[0.90176448135306]]]] X = [[[[0.8800852687080962]], [[0.90176448135306]]]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.9379821]], [[0.9017646]]]]
Expected (Unparsed): [[[[0.8800852687080962]], [[0.90176448135306]]]]
-------------------------------------------------------------------------------------
Actual:   [[[[0.938]], [[0.9018]]]]
Expected: [[[[0.8801]], [[0.9018]]]]

conv_lstm2D_layer([[[[[0.6954, 0.6053]]]]], [[[[1, 1, 1, 1], [1, 1, 1, 1]]]],[[[[1, 1, 1, 1]]]],[0, 0, 0, 0], X)
-------------------------------------------------------------------------------------
before conv[[[0.6954,0.6053]]]112[[[[1,1],[1,1]]]][0,0]after conv[[[1.3007,1.3007]]]x: 0y: 0Wi: [[1],[1]]Ui: [[1]]Bi: [[0]]Ot: [[0.9309516269437087]]Ctt: [[0.9890579146492317]]CtF: [0.920765074784254]TanhCt: [[0.7262591500630224]]Os1: [0.6761121373339258]Os2: [[[0.6761121373339258]]]CtN: [[[0.920765074784254]]]EXIT apply_lstm_step_convaapply_lstm_step_conv doneCt1: [[[0.920765074784254]]]Os1: [[[0.6761121373339258]]]X = [[[[0.6761121373339258]]]] X = [[[[0.6761121373339258]]]] 

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[0.46358365]]]]
Expected (Unparsed): [[[[0.6761121373339258]]]]
-------------------------------------------------------------------------------------
Actual:   [[[[0.4636]]]]
Expected: [[[[0.6762]]]]


conv_lstm2D_layer([[[[[10]]]]], [[[[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]]],[[[[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]]],[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], X).
conv_lstm2D_layer([[[[[2]]]]], [[[[1, 1, 1, 1]]]],[[[[1, 1, 1, 1]]]],[0, 0, 0, 0], X).

conv_lstm2D_layer([[[[[8, 5], [7, 9]], [[3, 1], [1, 9]]], [[[10, 5], [9, 6]], [[3, 6], [2, 1]]]]], [[[[1, 1, 1, 1], [1, 1, 1, 1]]]],[[[[1, 1, 1, 1]]]],[0, 0, 0, 0], X)

apply_lstm_step_conv([[[0.3173,0.4853],[0.7123,0.6301]],[[0.5427,0.2192],[0.8144,0.5035]]],[[[[1, 1, 1, 1], [1, 1, 1, 1]]]],[[[[1, 1, 1, 1]]]],[0, 0, 0, 0],[[[[0]],[[0]]],[[[0]],[[0]]]],Y, [[[[0]],[[0]]],[[[0]],[[0]]]], X)

conv_lstm2D_layer([[[[[0.3173, 0.4853], [0.7123, 0.6301]], [[0.5427, 0.2192], [0.8144, 0.5035]]], [[[0.4764, 0.7637], [0.4707, 0.8289]], [[0.1355, 0.83], [0.3803, 0.5917]]]]], [[[[1, 1, 1, 1], [1, 1, 1, 1]]]],[[[[1, 1, 1, 1]]]],[0, 0, 0, 0], X)

conv_lstm2D_layer([[[[[0.9482, 0.7359], [0.7579, 0.2638]], [[0.4483, 0.5616], [0.774, 0.0418]]], [[[0.3467, 0.6406], [0.0994, 0.6151]], [[0.3175, 0.0376], [0.1639, 0.6057]]]]], [[[[1, 1, 1, 1], [1, 1, 1, 1]], [[1, 1, 1, 1], [1, 1, 1, 1]]], [[[1, 1, 1, 1], [1, 1, 1, 1]], [[1, 1, 1, 1], [1, 1, 1, 1]]]],[[[[1, 1, 1, 1]], [[1, 1, 1, 1]]], [[[1, 1, 1, 1]], [[1, 1, 1, 1]]]],[0, 0, 0, 0], X)
conv_lstm2D_layer([[[[[0.2389, 0.5865], [0.1241, 0.9544]], [[0.1207, 0.0613], [0.3419, 0.3447]]], [[[0.6111, 0.299], [0.222, 0.1005]], [[0.43, 0.1239], [0.2027, 0.3152]]]]], [[[[1, 1, 1, 1], [1, 1, 1, 1]]]],[[[[1, 1, 1, 1]]]],[0, 0, 0, 0], X)

# model = keras.Sequential([
# keras.layers.Conv2D(3, (3, 2),strides=(1, 1), padding='same', dilation_rate=(1, 2),  input_shape=(3, 3, 3))
# ])
# w = model.get_weights()
# w[0] = np.array([[[[0.1275, 0.3556, 0.7511], [0.238, 0.4984, 0.4262], [0.0162, 0.1249, 0.1828]], [[0.3952, 0.0265, 0.7978], [0.7009, 0.2559, 0.2575], [0.2629, 0.7711, 0.0218]]], [[[0.5836, 0.1737, 0.3354], [0.283, 0.2096, 0.9674], [0.6366, 0.4834, 0.1544]], [[0.1233, 0.3204, 0.1033], [0.4756, 0.7937, 0.8225], [0.4785, 0.0416, 0.0571]]], [[[0.4907, 0.6863, 0.6753], [0.693, 0.9935, 0.7837], [0.9206, 0.6916, 0.57]], [[0.6999, 0.5182, 0.6738], [0.5869, 0.2488, 0.9134], [0.0212, 0.6862, 0.0572]]]])
# w[1] = np.array([0.7661, 0.7928, 0.5321])
# model.set_weights(w)
# x = tf.constant([[[[0.485, 0.4415, 0.7918], [0.8309, 0.2635, 0.931], [0.526, 0.3917, 0.9637]], [[0.1056, 0.6032, 0.9285], [0.4597, 0.0631, 0.1024], [0.4068, 0.7343, 0.846]], [[0.923, 0.1744, 0.0997], [0.9774, 0.9837, 0.6435], [0.4079, 0.2436, 0.456]]]])
# print (np.array2string(model.predict(x,steps=1), separator=', '))

conv_lstm2D_layer([[[I|Is0]|Is1]|Is],Ws,Us,Bs,Ct0,Os0,Os) :-
	atomic(I),
	
	length([[[I|Is0]|Is1]|Is],LX), 
	length([[I|Is0]|Is1],LY), 
	get_pool_res2D(sum_list,[[[I|Is0]|Is1]|Is],X,Y,Z,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,IWs,Bs,false,O),
	insert_pool_field(Os0,O,true,X,Y,Z,StridesD1,StridesD2,Os1),
	(X+StridesD1+PoolSizeD1 =< LX -> X1 is X + StridesD1,Y1 is Y, Z1 is Z; 
	(Y+StridesD2+PoolSizeD2 =< LY -> X1 is 0,Y1 is Y+StridesD2, Z1 is Z; 
					X1 is LX +1, Y1 is LY + 1, Z1 is Z + 1)),
	pool2D_layer(sum_list,[[[I|Is0]|Is1]|Is],X1,Y1,Z1,PoolSizeD1,PoolSizeD2,StridesD1,StridesD2,Padding,IWs,Bs,false,Os1,Os).
	
tf.keras.backend.set_floatx('float64')
model = keras.Sequential([
keras.layers.ConvLSTM2D(1, (2, 1),recurrent_activation='linear', activation='linear',  input_shape=(2, 3, 3, 1))])
w = model.get_weights()
w[0] = np.array([[[[1, 1, 1, 1]]], [[[1, 1, 1, 1]]]])
w[1] = np.array([[[[1, 1, 1, 1]]], [[[1, 1, 1, 1]]]])
w[2] = np.array([0, 0, 0, 0])
model.set_weights(w)
x = tf.constant([[[[[2], [1], [1]], [[1], [2], [1]], [[2], [1], [2]]], [[[1], [1], [1]], [[1], [1], [2]], [[2], [1], [2]]]]])
print (np.array2string(model.predict(x,steps=1), separator=', '))

-------------------------------------------------------------------------------------
2021-03-10 00:29:48.895668: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcudart.so.11.0'; dlerror: libcudart.so.11.0: cannot open shared object file: No such file or directory2021-03-10 00:29:48.895689: I tensorflow/stream_executor/cuda/cudart_stub.cc:29] Ignore above cudart dlerror if you do not have a GPU set up on your machine.2021-03-10 00:29:50.601084: I tensorflow/compiler/jit/xla_cpu_device.cc:41] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-03-10 00:29:50.601253: W tensorflow/stream_executor/platform/default/dso_loader.cc:60] Could not load dynamic library 'libcuda.so.1'; dlerror: libcuda.so.1: cannot open shared object file: No such file or directory2021-03-10 00:29:50.601266: W tensorflow/stream_executor/cuda/cuda_driver.cc:326] failed call to cuInit: UNKNOWN ERROR (303)2021-03-10 00:29:50.601290: I tensorflow/stream_executor/cuda/cuda_diagnostics.cc:156] kernel driver does not appear to be running on this host (admin1-ThinkPad-X1-Carbon-7th): /proc/driver/nvidia/version does not exist2021-03-10 00:29:50.602181: I tensorflow/compiler/jit/xla_gpu_device.cc:99] Not creating XLA devices, tf_xla_enable_xla_devices not set2021-03-10 00:29:50.797662: I tensorflow/compiler/mlir/mlir_graph_optimization_pass.cc:116] None of the MLIR optimization passes are enabled (registered 2)2021-03-10 00:29:50.817727: I tensorflow/core/platform/profile_utils/cpu_utils.cc:112] CPU Frequency: 1999965000 Hz

-------------------------------------------------------------------------------------
Prolog Script:
-------------------------------------------------------------------------------------
conv_lstm2D_layer([[[[[2], [1], [1]], [[1], [2], [1]], [[2], [1], [2]]], [[[1], [1], [1]], [[1], [1], [2]], [[2], [1], [2]]]]], [[[[1, 1, 1, 1]]], [[[1, 1, 1, 1]]]],[[[[1, 1, 1, 1]]], [[[1, 1, 1, 1]]]],[0, 0, 0, 0], X)
-------------------------------------------------------------------------------------
before conv[[[2],[1],[1]],[[1],[2],[1]],[[2],[1],[2]]]211[[[[1]]],[[[1]]]][0]after conv[[[3],[3],[2]],[[3],[3],[3]]]Ct0: [[[0],[0],[0]],[[0],[0],[0]]]Os0: [[[0],[0],[0]],[[0],[0],[0]]]It: [[[3],[3],[2]],[[3],[3],[3]]]Ft: [[[3],[3],[2]],[[3],[3],[3]]]Ctt: [[[3],[3],[2]],[[3],[3],[3]]]Ct1: [[[0],[0],[0]],[[0],[0],[0]]]Ct2: [[[9],[9],[4]],[[9],[9],[9]]]Ct: [[[9],[9],[4]],[[9],[9],[9]]]TanhCt: [[[9],[9],[4]],[[9],[9],[9]]]Os1: [[[27],[27],[8]],[[27],[27],[27]]]aapply_lstm_step_conv doneCt1: [[[9],[9],[4]],[[9],[9],[9]]]Os1: [[[27],[27],[8]],[[27],[27],[27]]]before conv[[[1],[1],[1]],[[1],[1],[2]],[[2],[1],[2]]]211[[[[1]]],[[[1]]]][0]after conv[[[2],[2],[3]],[[3],[2],[4]]]Ct0: [[[9],[9],[4]],[[9],[9],[9]]]Os0: [[[27],[27],[8]],[[27],[27],[27]]]It: [[[29],[29],[11]],[[30],[29],[31]]]Ft: [[[29],[29],[11]],[[30],[29],[31]]]Ctt: [[[29],[29],[11]],[[30],[29],[31]]]Ct1: [[[261],[261],[44]],[[270],[261],[279]]]Ct2: [[[841],[841],[121]],[[900],[841],[961]]]Ct: [[[1102],[1102],[165]],[[1170],[1102],[1240]]]TanhCt: [[[1102],[1102],[165]],[[1170],[1102],[1240]]]Os1: [[[31958],[31958],[1815]],[[35100],[31958],[38440]]]aapply_lstm_step_conv doneCt1: [[[1102],[1102],[165]],[[1170],[1102],[1240]]]Os1: [[[31958],[31958],[1815]],[[35100],[31958],[38440]]]X = [[[[31958], [31958], [1815]], [[35100], [31958], [38440]]]] X = [[[[31958], [31958], [1815]], [[35100], [31958], [38440]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:543:Warning:    Singleton variables: [Ws,Us,Bs]

-------------------------------------------------------------------------------------
Actual (Unparsed): [[[[203840.0000000], [203840.0000000], [60648.0000000]], [[35100.0000000], [31958.0000000], [38440.0000000]]]]
Expected (Unparsed): [[[[31958], [31958], [1815]], [[35100], [31958], [38440]]]] Warning: /home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl:543:Warning: Singleton variables: [Ws,Us,Bs]
-------------------------------------------------------------------------------------
Actual:   [[[[203840], [203840], [60648]], [[35100], [31958], [38440]]]]
Expected: [[[[31958], [31958], [1815]], [[35100], [31958], [38440]]]]
-------------------------------------------------------------------------------------

Test 4 failed!

*/