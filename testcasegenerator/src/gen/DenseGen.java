package gen;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.DenseLayer;
import layer.Layer;
import util.ListHelper;

public class DenseGen extends Gen {

	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape,
			LinkedHashMap<String, Object> config) {
		
		
		int nodeNumber = rand.nextInt(4)+1;
		if(config != null && !config.isEmpty() && config.containsKey("nodeNumber")){
			nodeNumber = (int)config.get("nodeNumber");
		}
		int dimensions;
		if(inputShape != null) {
			dimensions = inputShape.size() -1; 
		}
		else {
			dimensions = rand.nextInt(2)+1;
			inputShape = new ArrayList<>();
			for(int i = 0; i <= dimensions; i++) {
				inputShape.add(rand.nextInt(4)+2);
			}	
		}
		
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		

		ArrayList<Integer> inWS = new ArrayList<>();
		ArrayList<Integer> outWS = new ArrayList<>();
		inWS.add(inputShape.get(inputShape.size()-1));
		inWS.add(nodeNumber);
		outWS.add(nodeNumber);	
		
//		String[] activations = {"None","ReLU","Thresholded_ReLU","ELU","Softmax"};		
//		//String activation = activations[rand.nextInt(activations.length)];
//		String activation = "None";
//		String[] initializers = {"tf.keras.initializers.ones","tf.keras.initializers.zeros","random-weights"};
//		//String kernel_initializer = initializers[rand.nextInt(initializers.length)];
//		//String bias_initializer = initializers[rand.nextInt(initializers.length)];
//		String kernal_initializer = "tf.keras.initializers.ones";
//		String bias_initializer = "tf.keras.initializers.zeros";
//		params.put("activation",activation);
//		params.put("kernel_initializer",kernal_initializer);// This is actually input weight initializer
//		params.put("use_bias","True");
//		params.put("bias_initializer",bias_initializer);
		
		Object inputWeights = ListHelper.genList(rand, inWS);
		Object outputWeights = ListHelper.genList(rand, outWS);

		return new DenseLayer(name,nodeNumber,inputShape,inputWeights,outputWeights,params);
	}

}
