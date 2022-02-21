package layer;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import util.ListHelper;


public class MultiInputLayer extends Layer {

	private Object fixedInput = null;
	
	public MultiInputLayer(String name, List<Integer> inputShape, LinkedHashMap<String, String> params) {
		super(name, inputShape, params);
	}
	
	public MultiInputLayer(MultiInputLayer l) {
		super(l);
	}
	
	public  String toTensorflowString(Object in) {
		return toTensorflowStringMultipleInputs(in);
//    	String ret = "import tensorflow as tf\n"
//    			+ "from tensorflow import keras\n" + 
//    			"from tensorflow.keras import layers\n"
//    			+ "import numpy as np\n"
//    			+ "np.set_printoptions(suppress=True)\n";
//
//		String inpS = Arrays.toString(inputShape.toArray());
//		String ins = "[";
//		String ins1 = "";
//		
//		for(int i = 0; i < inputs.length;i++) {
//			ret += "input"+i+" = tf.keras.layers.Input(shape=("+inpS+"))\n";
//			ins += "input"+i+",";
//			ins1 += "input"+i+" = tf.constant(["+inputs[i]+"])\n";
//		}
//		ins = ins.substring(0,ins.length()-1)+"]";
//		ret += "func = keras.layers."+this.getClass().getSimpleName()+"("+parameterString()+")("+ins+")\n";
//		ret += "model = tf.keras.models.Model(inputs="+ins+", outputs=func)\n";
//		ret += ins1;
//		ret += "print np.array2string(model.predict("+ins+",steps=1), separator=', ')\n";
//		return ret;
	}
	
	@Override
	public Object generateInput(Random r) {
		ArrayList<Integer> tempShape = new ArrayList<>(this.getInputShape());
		tempShape.add(0, 2);//r.nextInt(3)+2);
		//if(name.equals("Concatenate")) {
			tempShape.add(1, 1);//r.nextInt(2)+1);
		//}
    	return ListHelper.genList(r, tempShape);
	}

	@Override
	public Layer copy() {
		return new MultiInputLayer(this);
	}

	public Object getFixedInput() {
		return fixedInput;
	}

	public void setFixedInput(Object fixedInput) {
		this.fixedInput = fixedInput;
	}

}