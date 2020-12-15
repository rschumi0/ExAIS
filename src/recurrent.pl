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





gru_layer([[I|Is0]|Is],Ws,RWs,Bs,Os) :- 
	is_list(I), gru_layer([[I|Is0]|Is],Ws,RWs,Bs,[],Os).
gru_layer([[I|Is0]|Is],Ws,RWs,Bs,Os) :- 
	atomic(I), length(Bs,N), N1 is N /3, empty_list(N1,Os0), gru_layer([[I|Is0]|Is],Ws,RWs,Bs,[Os0],[Os]).
gru_layer([],_,_,_,Os,Os).
gru_layer([[I|Is0]|Is],Ws,RWs,Bs,Os0,Os) :-
	is_list(I),
	gru_layer([I|Is0],Ws,RWs,Bs,O),
	append(Os0,[O],Os1),
	gru_layer(Is,Ws,RWs,Bs,Os1,Os).
gru_layer([[I|Is0]|Is],Ws,Us,Bs,Os0,Os) :-
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
	gru_layer(Is,Ws,Us,Bs,Os1,Os). 
	
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
