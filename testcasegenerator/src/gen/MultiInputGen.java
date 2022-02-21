package gen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.Layer;
import layer.MultiInputLayer;

public class MultiInputGen extends Gen {

	public MultiInputGen() {
		super();
		paramAliases.put("axis", Arrays.asList("axis"));
	}
	
	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape, LinkedHashMap<String, Object> config) {
		//String[] names = {"Average","Add","Multiply","Minimum", "Maximum"};//, "Concatenate"};//,
		//String name = names[rand.nextInt(names.length)];
		config = fillParams(config);
		int dimensions;
		if(inputShape != null) {
			dimensions = inputShape.size()-1; 
		}
		else {
			dimensions = rand.nextInt(3)+1;//
			inputShape = new ArrayList<>();//Arrays.asList(3,3));
			for(int i = 0; i <= dimensions; i++) {
				inputShape.add(rand.nextInt(2)+1);
			}
		}
		
		
		
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		if(name.equals("Concatenate")) {
			params.put("axis",rand.nextInt(dimensions+2)+"");
		}
		
		return new MultiInputLayer(name,inputShape,params);
	}

}
