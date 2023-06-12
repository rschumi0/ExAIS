package gen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.HelperLayer;
import layer.Layer;
import util.ListHelper;

public class HelperLayerGen extends Gen {

	public HelperLayerGen() {
		super();
		paramAliases.put("croppingSizes", Arrays.asList("croppingsizes", "croppingsize", "size", "sizes", "cropping"));
		paramAliases.put("upSamplingSize", Arrays.asList("upsamplingsize","sizes", "size"));
		paramAliases.put("paddingSizes", Arrays.asList("padding","sizes", "size"));
		paramAliases.put("Repeat_Vector_N", Arrays.asList("repeat_vector_v","repeat", "size","n","number"));
		paramAliases.put("Permute_Dims", Arrays.asList("permute_dims","permutations","dims","dimensions"));
		paramAliases.put("Reshape_Sizes", Arrays.asList("reshape_sizes", "reshape_size","reshapesizes", "reshapesize", "newshape", "size", "sizes","reshape"));
		paramAliases.put("axis", Arrays.asList("axis"));
		//TODO finish parameter assignment
		paramAliases.put("epsilon", Arrays.asList("epsilon","e"));
		paramAliases.put("gammas", Arrays.asList("gammas","gamma"));
		paramAliases.put("betas", Arrays.asList("betas","beta"));
		paramAliases.put("means", Arrays.asList("means","mean"));
		paramAliases.put("variances", Arrays.asList("variances","variance"));
		paramAliases.put("mask_value", Arrays.asList("mask_value","maskvalue","mask","value"));
		
		paramAliases.put("shape", Arrays.asList("shape"));
		paramAliases.put("batch_size", Arrays.asList("batch_size"));
		paramAliases.put("dtype", Arrays.asList("dtype"));
		paramAliases.put("ragged", Arrays.asList("ragged"));
		paramAliases.put("ndim", Arrays.asList("ndim"));
		paramAliases.put("max_ndim", Arrays.asList("max_ndim"));
		paramAliases.put("min_ndim", Arrays.asList("min_ndim"));
		paramAliases.put("allow_last_axis_squeeze", Arrays.asList("allow_last_axis_squeeze"));
	}
	
	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape, LinkedHashMap<String, Object> config) {
		config = fillParams(config);
		int dimensions;
		if(inputShape != null) {
			dimensions = inputShape.size() -1; 
			
			int expectedDim = name.equals("Reshape") ? 0 : 
				name.equals("Repeat_Vector") ? 0 : 
				//name.equals("Layer_Normalization") ? 0 : 
				name.equals("Permute") ? 1 :
				name.contains("3D") ? 3 : 
				name.contains("2D") ? 2 : 1;
			
			if(!name.equals("Reshape") && !name.equals("Flatten") && !name.equals("Batch_Normalization") && !name.equals("Layer_Normalization")  && !name.equals("Masking")  &&  dimensions != expectedDim) {
				return null;
			}
		}
		else {
			dimensions= name.equals("Reshape") ? 0 : 
				name.equals("Repeat_Vector") ? 0 : 
				name.equals("Permute") ? 1 :
				name.contains("3D") ? 3 : 
				name.contains("2D") ? 2 :
				name.equals("Batch_Normalization")? rand.nextInt(3) :
				name.equals("Layer_Normalization") ? rand.nextInt(3) :
				name.equals("Flatten") ? rand.nextInt(3) :
				name.equals("Masking") ? rand.nextInt(3) :
				name.equals("Input") ? rand.nextInt(3):
				name.equals("Input_Spec") ? rand.nextInt(3):	1;
			inputShape = new ArrayList<>();//Arrays.asList(3,3));
			for(int i = 0; i <= dimensions; i++) {
				inputShape.add(rand.nextInt(4)+1);
			}	
		}
		
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		if(name.startsWith("Cropping")) {
			List<Object> sizes = new ArrayList<>();
			if(config != null && !config.isEmpty() && config.containsKey("croppingSizes")){
				sizes = (List<Object>)config.get("croppingSizes");
			}
			else {		
				for(int i = 0; i < dimensions; i++) {
					int s1 = rand.nextInt(inputShape.get(i));
					int s2 = rand.nextInt(inputShape.get(i)-s1);
					Object[] o = {s1,s2};
					sizes.add(o);
				}
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("cropping", size);
		}
		else if(name.startsWith("Up_Sampling")) {
			List<Object> sizes = new ArrayList<>();
			if(config != null && !config.isEmpty() && config.containsKey("upSamplingSize")){
				sizes = (List<Object>)config.get("upSamplingSize");
			}
			else {
				for(int i = 0; i < dimensions; i++) {
	//				if(i<2) {
	//					sizes.add(1);
	//				}
	//				else {
					//sizes.add(rand.nextInt(inputShape.get(i)-1)+1);
					sizes.add(rand.nextInt(2)+1);
	//				}
				}

			}
			String size = Arrays.toString(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("size", size);
		}
		else if(name.startsWith("Zero_Padding")) {
			List<Object> sizes = new ArrayList<>();
			if(config != null && !config.isEmpty() && config.containsKey("paddingSizes")){
				sizes = (List<Object>)config.get("paddingSizes");
			}
			else {
				for(int i = 0; i < dimensions; i++) {
					int s1 = rand.nextInt(1)+1;
					int s2 = rand.nextInt(1)+1;
					Object[] o = {s1,s2};
					sizes.add(o);
				}
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("padding", size);
		}
		else if(name.equals("Repeat_Vector")) {
			if(config != null && !config.isEmpty() && config.containsKey("Repeat_Vector_N")){
				params.put("Repeat_Vector_N", ""+config.get("Repeat_Vector_N"));
			}
			else {
				params.put("Repeat_Vector_N", ""+(rand.nextInt(3)+1));
			}
		}
		else if(name.equals("Permute")) {
			if(config != null && !config.isEmpty() && config.containsKey("Permute_Dims")){
				
				String size = ListHelper.printList(((List<Integer>)config.get("Permute_Dims")).toArray());
				size = size.replace("[", "(").replace("]", ")");
				params.put("Permute_Dims", ""+size);
			}
			else {
				int d1 = rand.nextInt(2) + 1;
				int d2 = 0;
				do {
					d2 = rand.nextInt(2) + 1;	
				} while(d1 == d2);
				params.put("Permute_Dims","("+d1 + ", "+d2+")");
			}

		}
		else if(name.equals("Reshape"))
		{
			List<Integer> sizes = new ArrayList<>();
			if(config != null && !config.isEmpty() && config.containsKey("Reshape_Sizes")){
				sizes = (List<Integer>)config.get("Reshape_Sizes");
			}
			else {
				do {
					inputShape.clear();
					inputShape.add(rand.nextInt(33)*2+2);
					sizes.clear();
					if(rand.nextBoolean())
					{
						sizes.add(rand.nextInt(4)+1);
						sizes.add((int)inputShape.get(0)/sizes.get(0));
					}
					else if(rand.nextBoolean()){
						sizes.add(rand.nextInt(4)+1);
						sizes.add(rand.nextInt(3)+1);
						sizes.add((int)inputShape.get(0)/listProduct(sizes));
					}
					else if(rand.nextBoolean()){
						sizes.add(rand.nextInt(4)+1);
						sizes.add(rand.nextInt(3)+1);
						sizes.add(rand.nextInt(3)+1);
						sizes.add((int)inputShape.get(0)/listProduct(sizes));
					}
					else if(rand.nextBoolean()){
						sizes.add(rand.nextInt(4)+1);
						sizes.add(rand.nextInt(3)+1);
						sizes.add(rand.nextInt(3)+1);
						sizes.add(rand.nextInt(3)+1);
						sizes.add((int)inputShape.get(0)/listProduct(sizes));
					}
				}while(listProduct(inputShape) != listProduct(sizes));
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("Reshape_Sizes",size);
		}
		else if(name.equals("Layer_Normalization")) {
			if(config != null && !config.isEmpty() && config.containsKey("axis")){
				params.put("axis", ""+config.get("axis"));
			}
			else {
				params.put("axis",""+(rand.nextInt(inputShape.size())+1));
			}
			if(config != null && !config.isEmpty() && config.containsKey("epsilon")){
				params.put("epsilon", ""+config.get("epsilon"));
			}
			else {
				params.put("epsilon",""+(randDoubleRange(rand, 1.0, 3.0)));
			}
			
			
		}
		else if(name.equals("Batch_Normalization")) {
			int axis = rand.nextInt(inputShape.size())+1;
			if(config != null && !config.isEmpty() && config.containsKey("axis")){
				params.put("axis", ""+config.get("axis"));
				axis = (int) config.get("axis");
			}
			else {
				params.put("axis",""+axis);
			}

			if(config != null && !config.isEmpty() && config.containsKey("epsilon")){
				params.put("epsilon", ""+config.get("epsilon"));
			}
			else {
				params.put("epsilon",""+(randDoubleRange(rand, 0.1, 1.0)));
			}
			
			
			ArrayList<Integer> tmpShape = new ArrayList<>();
			while(inputShape.size() < axis) {
				inputShape.add(rand.nextInt(4)+1);
			}
			tmpShape.add(inputShape.get(axis-1));
			
			if(config != null && !config.isEmpty() && config.containsKey("gammas")){
				params.put("gammas", ListHelper.printList(config.get("gammas")));
			}
			else {
				params.put("gammas", ListHelper.printList(ListHelper.genList(rand, tmpShape)));
			}
			if(config != null && !config.isEmpty() && config.containsKey("betas")){
				params.put("betas", ListHelper.printList(config.get("betas")));
			}
			else {
				params.put("betas", ListHelper.printList(ListHelper.genList(rand, tmpShape)));
			}
			if(config != null && !config.isEmpty() && config.containsKey("means")){
				params.put("means", ListHelper.printList(config.get("means")));
			}
			else {
				params.put("means", ListHelper.printList(ListHelper.genList(rand, tmpShape)));
			}
			if(config != null && !config.isEmpty() && config.containsKey("variances")){
				params.put("variances", ListHelper.printList(config.get("variances")));
			}
			else {
				params.put("variances", ListHelper.printList(ListHelper.genList(rand, tmpShape)));
			}
			
			
		}
		else if(name.equals("Masking")) {
			if(config != null && !config.isEmpty() && config.containsKey("mask_value")){
				params.put("mask_value", ""+config.get("mask_value"));
			}
			else {
				params.put("mask_value",""+(rand.nextInt(2)+1));//rand.nextDouble());
			}
			
		}
		else if(name.equals("Input")) {
			String inpS = Arrays.toString(inputShape.toArray());
			inpS = inpS.substring(1,inpS.length()-1);
			params.put("shape","("+inpS+")");
			params.put("batch_size","1");
			params.put("dtype","float");
			params.put("ragged",""+rand.nextBoolean());
		}
		else if(name.equals("Input_Spec")) {
			String inpS = Arrays.toString(inputShape.toArray());
			inpS = inpS.substring(1,inpS.length()-1);
			params.put("dtype","'float'");
			params.put("shape","(1,"+inpS+")");
			params.put("ndim",""+(inputShape.size()+1));
			params.put("max_ndim",""+(inputShape.size()+1));
			params.put("min_ndim",""+(inputShape.size()+1));
			params.put("allow_last_axis_squeeze",""+rand.nextBoolean());
		}
		return new HelperLayer(name,dimensions,inputShape,params);
	}

	private int listProduct(List<Integer> list) {
		int ret = 1;
		for (Integer i : list) {
			ret *= i;
		}
		return ret;
	}
}
