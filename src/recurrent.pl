:-use_module(library(clpfd)).
:-use_module(library(list_util)).
:-use_module(library(matrix)).
:-use_module(library(lambda)).
:-[util].


simple_rnn_layer([[I|Is0]|Is],Ws,RWs,Bs,Os) :- 
	is_list(I), simple_rnn_layer([[I|Is0]|Is],Ws,RWs,Bs,[],Os).
simple_rnn_layer([[I|Is0]|Is],Ws,RWs,Bs,Os) :- 
	atomic(I), length(Bs,N), empty_list(N,Os0), simple_rnn_layer([[I|Is0]|Is],Ws,RWs,Bs,Os0,Os).
simple_rnn_layer([],_,_,_,Os,Os).
simple_rnn_layer([[I|Is0]|Is],Ws,RWs,Bs,Os0,Os) :-
	is_list(I),
	simple_rnn_layer([I|Is0],Ws,RWs,Bs,O),
	append(Os0,[O],Os1),
	simple_rnn_layer(Is,Ws,RWs,Bs,Os1,Os).
simple_rnn_layer([[I|Is0]|Is],Ws,RWs,Bs,Os0,Os) :-
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
	simple_rnn_layer(Is,Ws,RWs,Bs,Os1,Os).
	
unpack([X|_],X).
	
temp(Is,Is).

	
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





gru_layer([[I|Is0]|Is],Ws,RWs,Bs,ResetAfter,Os) :- 
	is_list(I), gru_layer([[I|Is0]|Is],Ws,RWs,Bs,ResetAfter,[],Os).
gru_layer([[I|Is0]|Is],[W|Ws],RWs,Bs,ResetAfter,Os) :- 
	atomic(I), length(W,N), N1 is N /3, empty_list(N1,Os0), gru_layer([[I|Is0]|Is],[W|Ws],RWs,Bs,ResetAfter,[Os0],[Os]).
gru_layer([],_,_,_,_,Os,Os).
gru_layer([[I|Is0]|Is],Ws,RWs,Bs,ResetAfter,Os0,Os) :-
	is_list(I),
	gru_layer([I|Is0],Ws,RWs,Bs,ResetAfter,O),
	append(Os0,[O],Os1),
	gru_layer(Is,Ws,RWs,Bs,ResetAfter,Os1,Os).
gru_layer([[I|Is0]|Is],Ws,Us,Bs,false,Os0,Os) :-
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
	sigmoid_matrix(Z3,Zt),
	%write('Zt: '),
	%writeln(Zt),
	
	mmult([[I|Is0]],Wr,R0),
	mmult(Os0,Ur,R1),
	add_lists(R0,R1,R2),
	add_lists(R2,Br,R3),
	sigmoid_matrix(R3,Rt),
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
	gru_layer(Is,Ws,Us,Bs,false,Os1,Os). 
	
	
gru_layer([[I|Is0]|Is],Ws,Us,[Bs1,Bs2],true,Os0,Os) :-
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
	sigmoid_matrix(Z3,Zt),
	%write('Zt: '),
	%writeln(Zt),
	
	mmult([[I|Is0]],Wr,R0),
	mmult(Os0,Ur,R1),
	add_lists(R0,R1,R2),
	add_lists(R2,Br,R3),
	sigmoid_matrix(R3,Rt),
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
	gru_layer(Is,Ws,Us,[Bs1,Bs2],true,Os1,Os). 

	
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

%sigmoid_matrix(Is,Is).


sigmoid_list(Is,Y) :- sigmoid_layer(Is,[],Y).
sigmoid_matrix([],[]).
sigmoid_matrix([X|Xs],[Y|Ys]) :-
	sigmoid_list(X,Y),
	sigmoid_matrix(Xs,Ys).
	
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


lstm_layer([[I|Is0]|Is],Ws,Us,Bs,Os) :- 
	is_list(I), lstm_layer([[I|Is0]|Is],Ws,Us,Bs,[],Os).
lstm_layer([[I|Is0]|Is],Ws,Us,Bs,Os) :- 
	atomic(I), length(Bs,N), N1 is N /4, empty_list(N1,Os0), lstm_layer([[I|Is0]|Is],Ws,Us,Bs,[Os0],[Os0],[Os]).
lstm_layer([],_,_,_,Os,Os).
lstm_layer([[I|Is0]|Is],Ws,RWs,Bs,Os0,Os) :-
	is_list(I),
	lstm_layer([I|Is0],Ws,RWs,Bs,O),
	append(Os0,[O],Os1),
	lstm_layer(Is,Ws,RWs,Bs,Os1,Os).
lstm_layer([],_,_,_,_,Os,Os).
lstm_layer([[I|Is0]|Is],Ws,Us,Bs,Ct0,Os0,Os) :-
	atomic(I),
	split_lstm_weights(Ws, Wi,Wf,Wc,Wo),
	split_lstm_weights(Us, Ui,Uf,Uc,Uo),
	split_lstm_weights([Bs], Bi,Bf,Bc,Bo),
	write('Wi: '),
	writeln(Wi),
	
	sig_gate([[I|Is0]],Os0,Wi,Ui,Bi,It),
	sig_gate([[I|Is0]],Os0,Wf,Uf,Bf,Ft),
	sig_gate([[I|Is0]],Os0,Wo,Uo,Bo,Ot),
	write('Ot: '),
	writeln(Ot),
	
	tanh_gate([[I|Is0]],Os0,Wc,Uc,Bc,Ctt),
	write('Ctt: '),
	writeln(Ctt),
	
	multiply_lists(Ft,Ct0,Ct1),
	multiply_lists(It,Ctt,Ct2),
	add_lists(Ct1,Ct2,Ct),
	tanh(Ct,TanhCt),
	multiply_lists(Ot,TanhCt,Os1),
	write('Os1: '),
	writeln(Os1),
	
	lstm_layer(Is,Ws,Us,Bs,Ct,Os1,Os). 
	
sig_gate(Is,HtPast,W,U,B,Os) :-
	mmult(Is,W,Os0),
	mmult(HtPast,U,Os1),
	add_lists(Os0,Os1,Os2),
	add_lists(Os2,B,Os3),
	sigmoid_matrix(Os3,Os).
	
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


tempdelX(Is,Os) :- tempdelX(Is,[],Os).
tempdelX([],Os,Os).
tempdelX([I|Is],Os0,Os) :-
	writeln("----"),
	lstm_layer([[[4], [1]]],[I],[[0, 0, 0, 0]],[0, 0, 0, 0], O),
	writeln("----"),
	writeln(I),
	writeln(O),
	append(Os0,[O],Os1),
	tempdelX(Is,Os1,Os).
	

conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],Ws,Us,Bs,Os) :- 
	is_list(I), conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],Ws,Us,Bs,[],Os).
conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],Ws,Us,Bs,Os) :- 
	atomic(I), %length(Bs,N), N1 is N /4, empty_list(N1,Os0), 
	conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],Ws,Us,Bs,[],[],Os).
conv_lstm2D_layer([],_,_,_,Os,Os).
conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],Ws,Us,Bs,Os0,Os) :-
	is_list(I),
	conv_lstm2D_layer([[[I|Is0]|Is1]|Is2],Ws,Us,Bs,O),
	append(Os0,[O],Os1),
	conv_lstm2D_layer(Is,Ws,Us,Bs,Os1,Os).
conv_lstm2D_layer([],_,_,_,_,Os,Os).
conv_lstm2D_layer([[[[I|Is0]|Is1]|Is2]|Is],[[W|Ws0]|Ws],Us,Bs,Ct0,Os0,Os) :-
	atomic(I),
	length([[W|Ws0]|Ws], KernelSizeD1),
	length([W|Ws0],KernelSizeD2),
	%length(W,TempNodeNumb),
	length(Bs,N), TempNodeNumb is N /4,
	writeln("before conv"),
	writeln([[[I|Is0]|Is1]|Is2]),
	writeln(KernelSizeD1),
	writeln(KernelSizeD2),
	length([I|Is0],LD3),
	writeln(LD3),
	empty_field4D(1,KernelSizeD1,KernelSizeD2,LD3,LD3,TW),
	writeln(TW),
	empty_list(LD3,TW1),
	writeln(TW1),
	conv2D_layer([[[I|Is0]|Is1]|Is2],KernelSizeD1,KernelSizeD2,TW,TW1,CO),
	/*empty_field4D(1,KernelSizeD1,KernelSizeD2,LD3,1,TW),
	writeln(TW),
	empty_list(LD3,TW1),
	writeln(TW1),
	depthwise_conv2D_layer([[[I|Is0]|Is1]|Is2],KernelSizeD1,KernelSizeD2,TW,TW1,CO),*/
	writeln("after conv"),
	writeln(CO),
	(Ct0 = [] -> (length(CO,L1), sub_length(CO,L2), empty_field(L1,L2,TempNodeNumb,TOs), apply_lstm_step_conv(CO,[[W|Ws0]|Ws],Us,Bs,TOs,Ct1,TOs,Os1));
			(apply_lstm_step_conv(CO,[[W|Ws0]|Ws],Us,Bs,Ct0,Ct1,Os0,Os1))),
	writeln("aapply_lstm_step_conv done"),
	write('Ct1: '),writeln(Ct1),
	write('Os1: '),writeln(Os1),
	conv_lstm2D_layer(Is,[[W|Ws0]|Ws],Us,Bs,Ct1,Os1,Os). 
	/*nth0_2D(0,0, [[W|Ws0]|Ws],WsT),
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

	sig_gate([IsM],[OsM],Wi,Ui,Bi,It),
	sig_gate([IsM],[OsM],Wf,Uf,Bf,Ft),
	sig_gate([IsM],[OsM],Wo,Uo,Bo,Ot),
		write('Ot: '),writeln(Ot),
	
	tanh_gate([IsM],[OsM],Wc,Uc,Bc,Ctt),
		write('Ctt: '),writeln(Ctt),
	
	multiply_lists(Ft,[CtM],Ct1),
	multiply_lists(It,Ctt,Ct2),
	add_lists(Ct1,Ct2,[CtF]),
		write('CtF: '),writeln(CtF),
	tanh([CtF],TanhCt),
		write('TanhCt: '),writeln(TanhCt),
	multiply_lists(Ot,TanhCt,[Os1]),
		write('Os1: '),writeln(Os1),

	replace(Os0,X,Y,Os1,Os2),
		write('Os2: '),writeln(Os2),
	replace(Ct0,X,Y,CtF,CtN),
		write('CtN: '),writeln(CtN),
	((X < LX - 1) -> X1 is X + 1,Y1 is Y;X1 is 0,Y1 is Y+1),
	apply_lstm_step_conv(Is,X1,Y1,Ws,Us,Bs,CtN,Ct,Os2,Os).
		
	
/*

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
	*/