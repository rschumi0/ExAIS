package gen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.DropoutLayer;
import layer.Layer;

public class DropoutGen extends Gen {

	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape,
			LinkedHashMap<String, Object> config) {
		
		int dimensions;
		if(inputShape != null) {
			dimensions = inputShape.size()-1; 
			int expectedDim = name.contains("3D")? 3 : 
				 name.contains("2D") ? 2 : 1;
			if(dimensions != expectedDim) {
				return null;
			}
		}
		else {
			dimensions = name.equals("Alpha_Dropout") ? 0 : 
						 name.contains("3D") ? 3 : 
				         name.contains("2D") ? 2 : 
				         name.contains("1D") ? 1 :  rand.nextInt(2)+1;
			inputShape = new ArrayList<>();//Arrays.asList(3,3));
			for(int i = 0; i < dimensions; i++) {
				inputShape.add(rand.nextInt(3)+3);
			}
			inputShape.add(rand.nextInt(10)+100);
		}
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		
		if(name.equals("Dropout") || name.equals("Alpha_Dropout") || name.startsWith("Spatial_Dropout")|| name.startsWith("Gaussian_Dropout")) {
			params.put("rate", ""+(randDoubleRange(rand, 0.0, 1.0)));
			if(!name.startsWith("Spatial_Dropout") && !name.startsWith("Gaussian_Dropout")) {
				params.put("seed", ""+(rand.nextInt(10)+1));
			}	
			if(!name.startsWith("Gaussian_Dropout")) {
				params.put("AcceptedRateDiff", "0.1");
			}
		}
		else if(name.startsWith("Gaussian_Noise")) {
			params.put("stddev", ""+(randDoubleRange(rand, 0.0, 1.0)));
		}
		return new DropoutLayer(name, inputShape, params);
	}

}
