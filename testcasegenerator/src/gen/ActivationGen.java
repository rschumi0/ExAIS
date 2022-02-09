package gen;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.ActivationLayer;
import layer.Layer;
import util.ListHelper;

public class ActivationGen extends Gen {

	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape, LinkedHashMap<String, Object> config) {
		//String[] names = {"PReLU"};//{"ReLU","Thresholded_ReLU","ELU"};//,"Softmax"};//,"Leaky_ReLU"
		int dimensions;
		if(inputShape != null) {
			dimensions = inputShape.size()-1; 
		}
		else {
			dimensions = rand.nextInt(3)+1;
			inputShape = new ArrayList<>();//Arrays.asList(3,3));
			for(int i = 0; i <= dimensions; i++) {
				inputShape.add(rand.nextInt(2)+1);
			}
		}
		
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		Object alphas = null;
		if(name.equals("ReLU")) {
			if(config != null && !config.isEmpty() && config.containsKey("max_value")) {
				params.put("max_value",config.get("max_value").toString());
			}
			else {
				params.put("max_value",randDoubleRange(rand,0.01,10.0)+"");
			}
			if(config != null && !config.isEmpty() && config.containsKey("negative_slope")) {
				params.put("negative_slope",config.get("negative_slope").toString());
			}
			else {
				params.put("negative_slope",randDoubleRange(rand,0.01,10.0)+"");
			}
			if(config != null && !config.isEmpty() && config.containsKey("threshold")) {
				params.put("threshold",config.get("threshold").toString());
			}
			else {
				params.put("threshold",randDoubleRange(rand,0.01,10.0)+"");
			}
		}
		else if(name.equals("Thresholded_ReLU")) {
			params.put("theta",randDoubleRange(rand,0.01,10.0)+"");
		}
		else if(name.equals("Leaky_ReLU")) {
			params.put("alpha",randDoubleRange(rand,0.01,10.0)+"");
		}
		else if(name.equals("ELU")) {
			params.put("alpha",randDoubleRange(rand,-10.0,10.0)+"");
		}
		else if(name.equals("PReLU")){
			alphas = ListHelper.genList(rand, inputShape);
		}
		else if(name.equals("Softmax")) {
			params.put("axis","1");//(rand.nextInt(dimensions+2)-1)+"");
		}

		
		return new ActivationLayer(name,inputShape,alphas,params);
	}

}
