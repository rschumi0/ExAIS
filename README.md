# TensorFlowPrologSpec
This project aims to provide a Prolog specification of individual TensorFlow layers. Most layers are specified assuming statically given weights. Taking these weights as input parameter enables a deterministic computation of outputs for given inputs.

# Prerequisites

pack_install(list_util).
pack_install(cplint).
pack_install(lambda).

# Implemented layers

 | Layer | Comment |
 | --- | --- |
 |  Add|   |  
 |  AlphaDropout|   |  
 |  Average|   |   
 |  AveragePooling1D|   |  
 |  AveragePooling2D|   | 
 |  AveragePooling3D|   | 
 |  BatchNormalization|   | 
 |  Concatenate|   |    
 |  Conv1D|   |  
 |  Conv2D|   |  
 |  Conv3D|   |  
 |  Conv2DTranspose|   |  
 |  Conv3DTranspose|   |  
 |  ConvLSTM2D|   |  
 |  Cropping1D|   |
 |  Cropping2D|   |  
 |  Cropping3D|   |    
 |  Dense|   |  
 |  DepthwiseConv2D|   |  
 |  Dot|   |  
 |  Dropout|   |  
 |  Embedding|   |  
 |  ELU|   |  
 |  Flatten|   | 
 |  GaussianDropout|   |  
 |  GaussianNoise|   |   
 |  GlobalAveragePooling1D|   |  
 |  GlobalAveragePooling2D|   |  
 |  GlobalAveragePooling3D|   |  
 |  GlobalMaxPool1D|   |  
 |  GlobalMaxPool2D|   |  
 |  GlobalMaxPool3D|   | 
 |  GRU|   |    
 |  LayerNormalization|   |  
 |  LeakyReLU|   |  
 |  LocallyConnected1D|   |  
 |  LocallyConnected2D|   |  
 |  LSTM|   |  
 |  Masking|   |  
 |  Maximum|   |  
 |  MaxPool1D|   |  
 |  MaxPool2D|   |  
 |  MaxPool3D|   |   
 |  Minimum|   |  
 |  Multiply|   |
 |  Permute|   |  
 |  PReLU|   |  
 |  ReLU|   |  
 |  RepeatVector|   | 
 |  Reshape|   |    
 |  SeparableConv1D|   |  
 |  SeparableConv2D|   | 
 |  SimpleRNN|   |  
 |  Softmax|   |  
 |  SpatialDropout1D|   |  
 |  SpatialDropout2D|   |  
 |  SpatialDropout3D|   |   
 |  Subtract|   | 
 |  ThresholdedReLU|   | 
 |  TimeDistributed|   | 
 |  UpSampling1D|   |  
 |  UpSampling2D|   |  
 |  UpSampling3D|   |  
 |  ZeroPadding1D|   |  
 |  ZeroPadding2D|   |  
 |  ZeroPadding3D|   | 

# Examples
An example graph model (with the functional API) in Prolog is shown below. It can be seen that it consists of a number of layers with various arguments. The first argument is always the input and the last is the output. Layers are connected by using the output arguments as input. The final output of the model is the one from the last layer. Details about the arguments can be found in the source code and also in the [TensorFlow documentation](https://www.tensorflow.org/api_docs/python/tf/keras/layers).



```
reshape_layer, locally_connected1D_layer,locally_connected2D_layer,
zero_padding1D_layer,concatenate_layer,average_layer,conv3D_layer}]
maximum_layer([[[[[[0.9903]]]]], [[[[[0.1242]]]]]], Max14865),
reshape_layer(Max14865, [1, 1, 1], Res73393),
reshape_layer(Res73393, [1, 1], Res5986),
locally_connected1D_layer(Res5986, 1,[[[0.4653, 0.853]]],[[0, 0]], 1, Loc25172),
zero_padding1D_layer(Loc25172, 2, 0, Zer22853),
conv3D_layer([[[[[0.882, 0.6724], [0.4326, 0.7933]], [[0.6456, 0.7993], [0.5321, 0.3591]]]]], 1, 2, 1,[[[[[0.9195, 0.7384, 0.0497, 0.5772], [0.7679, 0.6823, 0.2288, 0.6998]]], [[[0.6827, 0.3927, 0.3891, 0.0145], [0.9637, 0.1379, 0.4071, 0.4857]]]]],[0, 0, 0, 0], 1, 1, 1, true, 1, 1, 1, Con37808),
reshape_layer(Con37808, [1, 2, 8], Res99128),
locally_connected2D_layer(Res99128, 1, 2,[[[0.622, 0.071], [0.9607, 0.5085], [0.7626, 0.5006], [0.6814, 0.3886], [0.0624, 0.0347], [0.0862, 0.1592], [0.7725, 0.4884], [0.1679, 0.5544], [0.5163, 0.4594], [0.7273, 0.2557], [0.8881, 0.2729], [0.5535, 0.6189], [0.7538, 0.6971], [0.0001, 0.3174], [0.4875, 0.3755], [0.3907, 0.0656]]],[[[0, 0]]], 1, 1, Loc74658),
reshape_layer(Loc74658, [1, 2], Res24234),
lstm_layer(Res24234,[[10, 2, 10, 6, 4, 1, 3, 1, 9, 5, 9, 10], [4, 10, 7, 8, 3, 7, 10, 4, 3, 10, 7, 8]],[[4, 8, 3, 9, 9, 6, 4, 8, 7, 4, 2, 10], [2, 6, 6, 8, 1, 2, 5, 2, 6, 3, 7, 3], [6, 1, 5, 1, 1, 9, 6, 10, 7, 4, 3, 10]],[6, 3, 6, 4, 7, 4, 3, 2, 6, 8, 7, 7], LST23580),
reshape_layer(LST23580, [3, 1], Res81602),
concatenate_layer([Res81602,[[[0.6724], [0.6533], [0.4308]]]], 2, Con9076),
average_layer([Zer22853,Con9076], Ave51565).
```

The corresponding TensorFlow code is shown below. First, there are a number of input definitions that specify the input shape. After that, the layers which have various arguments, and need to specify their input (layers). Next the model is defined with an input list and by specifying the output (or root) layer. At the end we set the weight and inputs statically and perform a prediction.

```
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers, models
import numpy as np

in0Max14865 = tf.layers.Input(shape=([1, 1, 1, 1]))
in1Max14865 = tf.layers.Input(shape=([1, 1, 1, 1]))
in0Con37808 = tf.layers.Input(shape=([1, 2, 2, 2]))
in0Con9076 = tf.layers.Input(shape=([3, 1]))

Max1486 = layers.Maximum(name = 'Max1486', )([in0Max14865,in1Max14865])
Res73393 = layers.Reshape((1, 1, 1), name = 'Res73393', )(Max1486)
Res5986 = layers.Reshape((1, 1), name = 'Res5986', )(Res73393)
Loc25172 = layers.LocallyConnected1D(2, (1),strides=(1), name = 'Loc25172', )(Res5986)
Zer22853 = layers.ZeroPadding1D(padding=((2, 0)), name = 'Zer22853', )(Loc25172)
Con37808 = layers.Conv3D(4, (1, 2, 1),strides=(1, 1, 1), padding='same', dilation_rate=(1, 1, 1), name = 'Con37808', )(in0Con37808)
Res99128 = layers.Reshape((1, 2, 8), name = 'Res99128', )(Con37808)
Loc74658 = layers.LocallyConnected2D(2, (1, 2),strides=(1, 1), name = 'Loc74658', )(Res99128)
Res24234 = layers.Reshape((1, 2), name = 'Res24234', )(Loc74658)
LST23580 = layers.LSTM(3,recurrent_activation='sigmoid', name = 'LST23580', )(Res24234)
Res81602 = layers.Reshape((3, 1), name = 'Res81602', )(LST23580)
Con9076 = layers.Concatenate(axis=2, name = 'Con9076', )([Res81602,in0Con9076])
Ave51565 = layers.Average(name = 'Ave51565', )([Zer22853,Con9076])

model = models.Model(inputs=[in0Max1486,in1Max14865,in0Con37808,in0Con9076], outputs=Ave51565)

w = model.get_layer('Loc25172').get_weights()
w[0] = np.array([[[0.4653, 0.853]]])
w[1] = np.array([[0, 0]])
model.get_layer('Loc25172').set_weights(w)
w = model.get_layer('Con37808').get_weights()
w[0] = np.array([[[[[0.9195, 0.7384, 0.0497, 0.5772], [0.7679, 0.6823, 0.2288, 0.6998]]], [[[0.6827, 0.3927, 0.3891, 0.0145], [0.9637, 0.1379, 0.4071, 0.4857]]]]])
w[1] = np.array([0, 0, 0, 0])
model.get_layer('Con37808').set_weights(w)
w = model.get_layer('Loc74658').get_weights()
w[0] = np.array([[[0.622, 0.071], [0.9607, 0.5085], [0.7626, 0.5006], [0.6814, 0.3886], [0.0624, 0.0347], [0.0862, 0.1592], [0.7725, 0.4884], [0.1679, 0.5544], [0.5163, 0.4594], [0.7273, 0.2557], [0.8881, 0.2729], [0.5535, 0.6189], [0.7538, 0.6971], [0.0001, 0.3174], [0.4875, 0.3755], [0.3907, 0.0656]]])
w[1] = np.array([[[0, 0]]])
model.get_layer('Loc74658').set_weights(w)
w = model.get_layer('LST23580').get_weights()
w[0] = np.array([[10, 2, 10, 6, 4, 1, 3, 1, 9, 5, 9, 10], [4, 10, 7, 8, 3, 7, 10, 4, 3, 10, 7, 8]])
w[1] = np.array([[4, 8, 3, 9, 9, 6, 4, 8, 7, 4, 2, 10], [2, 6, 6, 8, 1, 2, 5, 2, 6, 3, 7, 3], [6, 1, 5, 1, 1, 9, 6, 10, 7, 4, 3, 10]])
w[2] = np.array([6, 3, 6, 4, 7, 4, 3, 2, 6, 8, 7, 7])
model.get_layer('LST23580').set_weights(w)
in0Max14865 = tf.constant([[[[[0.9903]]]]])
in1Max14865 = tf.constant([[[[[0.1242]]]]])
in0Con37808 = tf.constant([[[[[0.882, 0.6724], [0.4326, 0.7933]], [[0.6456, 0.7993], [0.5321, 0.3591]]]]])
in0Con9076 = tf.constant([[[0.6724], [0.6533], [0.4308]]])

print (np.array2string(model.predict([in0Max14865,in1Max14865,in0Con37808,in0Con9076],steps=1), separator=', '))
```

