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
	writeln("last res"),
	writeln(Os0),
	
	split_weights(Ws, Wr,Wz,Wh),
	split_weights(Us, Ur,Uz,Uh),
	split_weights([Bs], Br,Bz,Bh),
	writeln(Wr),
	writeln(Ur),
	writeln(Br),
	writeln("start"),
	
	mmult([[I|Is0]],Wz,Z0),
	writeln(Z0),
	mmult(Os0,Uz,Z1),
	writeln(Z1),
	add_lists(Z0,Z1,Z2),
	writeln(Z2),
	add_lists(Z2,Bz,Z3),
	writeln(Z3),
	sigmoid_matrix(Z3,Zt),
	writeln(Zt),
	
	mmult([[I|Is0]],Wr,R0),
	mmult(Os0,Ur,R1),
	add_lists(R0,R1,R2),
	add_lists(R2,Br,R3),
	sigmoid_matrix(R3,Rt),
	writeln(Rt),
	
	mmult([[I|Is0]],Wh,H0),
	multiply_lists(Rt,Os0,H1),
	mmult(H1,Uh,H2),
	add_lists(H0,H2,H3),
	add_lists(H3,Bh,H4),
	writeln(H4),
	tanh(H4,Htt),
	writeln(Htt),
	
	one_minus_x(Zt,Zt1),
	writeln(Zt1),
	multiply_lists(Zt1,Os0,Ht0),
	writeln(Ht0),
	multiply_lists(Zt,Htt,Ht1),
	writeln(Ht1),
	add_lists(Ht0,Ht1,Os1),
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

sigmoid_list(Is,Y) :- sigmoid_layer(Is,[],Y).
sigmoid_matrix([],[]).
sigmoid_matrix([X|Xs],[Y|Ys]) :-
	sigmoid_list(X,Y),
	sigmoid_matrix(Xs,Ys).

