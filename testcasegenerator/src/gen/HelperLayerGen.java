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

	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape, LinkedHashMap<String, Object> config) {
		
		int dimensions;
		if(inputShape != null) {
			dimensions = inputShape.size() -1; 
			
			int expectedDim = name.equals("Reshape") ? 0 : 
				name.equals("Repeat_Vector") ? 0 : 
				//name.equals("Layer_Normalization") ? 0 : 
				name.equals("Permute") ? 1 :
				name.contains("3D") ? 3 : 
				name.contains("2D") ? 2 : 1;
			
			if(!name.equals("Flatten") && !name.equals("Batch_Normalization") && !name.equals("Layer_Normalization")  && !name.equals("Masking")  &&  dimensions != expectedDim) {
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
			List<Integer> sizes = new ArrayList<>();
			
			for(int i = 0; i < dimensions; i++) {
//				if(i<2) {
//					sizes.add(1);
//				}
//				else {
				//sizes.add(rand.nextInt(inputShape.get(i)-1)+1);
				sizes.add(rand.nextInt(2)+1);
//				}
			}
			String size = Arrays.toString(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("size", size);
		}
		else if(name.startsWith("Zero_Padding")) {
			List<Object> sizes = new ArrayList<>();
			for(int i = 0; i < dimensions; i++) {
				int s1 = rand.nextInt(1)+1;
				int s2 = rand.nextInt(1)+1;
				Object[] o = {s1,s2};
				sizes.add(o);
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("padding", size);
		}
		else if(name.equals("Repeat_Vector")) {
			params.put("Repeat_Vector_N", ""+(rand.nextInt(3)+1));
		}
		else if(name.equals("Permute")) {
			int d1 = rand.nextInt(2) + 1;
			int d2 = 0;
			do {
				d2 = rand.nextInt(2) + 1;	
			} while(d1 == d2);
			params.put("Permute_Dims","("+d1 + ","+d2+")");
		}
		else if(name.equals("Reshape"))
		{
			
			List<Integer> sizes = new ArrayList<>();
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
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("Reshape_Sizes",size);
		}
		else if(name.equals("Layer_Normalization")) {
			params.put("axis",""+(rand.nextInt(inputShape.size())+1));
			params.put("epsilon",""+(randDoubleRange(rand, 1.0, 3.0)));
		}
		else if(name.equals("Batch_Normalization")) {
			int axis = rand.nextInt(inputShape.size())+1;
			params.put("axis",""+axis);
			params.put("epsilon",""+(randDoubleRange(rand, 0.1, 1.0)));
			
			ArrayList<Integer> tmpShape = new ArrayList<>();
			tmpShape.add(inputShape.get(axis-1));
			
			params.put("gammas", ListHelper.printList(ListHelper.genList(rand, tmpShape)));
			params.put("betas", ListHelper.printList(ListHelper.genList(rand, tmpShape)));
			params.put("means", ListHelper.printList(ListHelper.genList(rand, tmpShape)));
			params.put("variances", ListHelper.printList(ListHelper.genList(rand, tmpShape)));
		}
		else if(name.equals("Masking")) {
			params.put("mask_value",""+(rand.nextInt(2)+1));//rand.nextDouble());
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