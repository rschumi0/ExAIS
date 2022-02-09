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

	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape,
			LinkedHashMap<String, Object> config) {
		
		int input_dim = rand.nextInt(4)+1;
		int output_dim = rand.nextInt(4)+1;
		
		if(inputShape == null) {
			inputShape = new ArrayList<>();
			inputShape.add(rand.nextInt(3)+1);
			//inputShape.add(rand.nextInt(3)+1);
		}
		
		List<Integer> weightShape = Arrays.asList(input_dim,output_dim);
		Object weights = ListHelper.genList(rand, weightShape);

		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		
		return new EmbeddingLayer(input_dim,output_dim,weights,inputShape,params);
	}

}
