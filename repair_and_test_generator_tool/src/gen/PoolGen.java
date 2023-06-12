package gen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.Layer;
import layer.PoolLayer;

public class PoolGen extends Gen {

	public PoolGen() {
		super();
		paramAliases.put("poolSizes", Arrays.asList("poolSizes","poolsizes","poolsize", "pool_sizes","pool_size","size","sizes"));
		paramAliases.put("strides", Arrays.asList("strides","stride"));
		paramAliases.put("padding", Arrays.asList("padding"));
	}
	
	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape, LinkedHashMap<String, Object> config) {
//		String[] names = { "Global_Max_Pool", "Global_Average_Pooling", "Average_Pooling","Max_Pool"};//, 
//		String name = names[rand.nextInt(names.length)];
		//int dimensions = 3;//rand.nextInt(3)+1;
		config = fillParams(config);
		int dimensions = 0;
		if(inputShape != null) {
			dimensions = inputShape.size()-1; 
			int expectedDim = name.contains("3D")? 3 : 
				 name.contains("2D") ? 2 : 1;
			if(dimensions != expectedDim) {
//				System.out.println("Dimension Error!");
//				System.out.println("Expected: " + expectedDim + " Actual: "+ dimensions);
//				return null;
				inputShape = null;
			}
		}
		if(inputShape == null) {
			dimensions = name.contains("3D")? 3 : 
				 name.contains("2D") ? 2 : 1;
			inputShape = new ArrayList<>();//Arrays.asList(3,3));
			for(int i = 0; i <= dimensions; i++) {
				inputShape.add(rand.nextInt(2)+1);
			}
		}

		
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		if(!name.startsWith("Global")) {
			List<Integer> poolSizes = new ArrayList<>();
			if(config != null && !config.isEmpty() && config.containsKey("poolSizes")){
				poolSizes = (List<Integer>)config.get("poolSizes");
			}
			else {
				for(int i = 0; i < dimensions; i++) {
					poolSizes.add(rand.nextInt(inputShape.get(i))+1);
				}
			}
			String size = Arrays.toString(poolSizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("pool_size", size);
			
			
			if((config != null && !config.isEmpty() && config.containsKey("strides"))) {
				List<Integer> strides = new ArrayList<>();
				if(config != null && !config.isEmpty() && config.containsKey("strides")){
					strides = (List<Integer>)config.get("strides");
				}
				String stride = Arrays.toString(strides.toArray());
				stride = stride.replace("[", "(").replace("]", ")");
				params.put("strides", stride);
				if(config != null && !config.isEmpty() && config.containsKey("padding")){
					params.put("padding",config.get("padding")+"");
				}
			}
			else if((config == null || !config.containsKey("poolSizes")) && rand.nextBoolean()) {
				List<Integer> strides = new ArrayList<>();
				for(int i = 0; i < dimensions; i++) {
					if(rand.nextInt(66)<30) {
						strides.add(rand.nextInt(1)+1);
					}
					else if(rand.nextInt(50)<30) {
						strides.add(rand.nextInt(inputShape.get(i))+1);
					}
					else {
						strides.add(rand.nextInt(12)+1);
					}
				}
				String stride = Arrays.toString(strides.toArray());
				stride = stride.replace("[", "(").replace("]", ")");
				params.put("strides", stride);
				params.put("padding",rand.nextBoolean()+"");
				
			}
		}
		return new PoolLayer(name,dimensions,inputShape,params);
	}

}
