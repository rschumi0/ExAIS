package gen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.EmbeddingLayer;
import layer.Layer;
import util.ListHelper;

public class EmbeddingGen extends Gen {
	
	public EmbeddingGen() {
		super();
		paramAliases.put("input_dim", Arrays.asList("input_dim", "inputdim","inputDim","input_dims","Input_Dim","Input_Dims"));
		paramAliases.put("output_dim", Arrays.asList("output_dim", "outputdim","outputDim","output_dims","Output_Dim","Output_Dims"));
	}
	
	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape,
			LinkedHashMap<String, Object> config) {
		config = fillParams(config);
		int input_dim = rand.nextInt(4)+1;
		if(config != null && !config.isEmpty() && config.containsKey("input_dim")){
			input_dim = (int)config.get("input_dim");
		}
		int output_dim = rand.nextInt(4)+1;
		if(config != null && !config.isEmpty() && config.containsKey("output_dim")){
			output_dim = (int)config.get("output_dim");
		}
		
		if(inputShape == null) {
			inputShape = new ArrayList<>();
			inputShape.add(rand.nextInt(3)+1);
			//inputShape.add(rand.nextInt(3)+1);
		}
		else {
			input_dim = inputShape.get(inputShape.size()-1);
		}
		
		List<Integer> weightShape = Arrays.asList(input_dim,output_dim);
		Object weights = ListHelper.genList(rand, weightShape);

		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		params.put("input_dim", ""+input_dim);
		params.put("output_dim", ""+output_dim);
		
		return new EmbeddingLayer(weights,inputShape,params);
	}

}
