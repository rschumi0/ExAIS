package gen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.ConvLayer;
import layer.Layer;
import util.ListHelper;

public class ConvGen extends Gen {

	public ConvGen() {
		super();
		paramAliases.put("kernelSizes", Arrays.asList("kernelsizes", "kernel_sizes", "kernel", "kernels"));
		paramAliases.put("nodeNumber", Arrays.asList("nodenumber", "node_number","node","node"));
		paramAliases.put("strides", Arrays.asList("strides", "stride"));
		paramAliases.put("dilation_rates", Arrays.asList("dilationrates", "dilationrate","dilation_rates", "dilation_rate","dilation", "dilations"));
		paramAliases.put("padding", Arrays.asList("padding"));
	}

	public Layer generateLayer(Random rand, String name, List<Integer> inputShape, LinkedHashMap<String, Object> config) {
		//String[] names = {"Conv3D_Transpose","Conv2D_Transpose"};// "Separable_Conv", "Conv","Locally_Connected"};//,"Conv2DTranspose"};//
		//String name = names[rand.nextInt(names.length)];
		config = fillParams(config);
		int dimensions = 0;
		if(inputShape != null) {
			dimensions = inputShape.size() -1; 
			
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
				inputShape.add(rand.nextInt(2)+1);//rand.nextInt(3)+1);
			}	
		}
		
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		List<Integer> kernelSizes = new ArrayList<>();
		if(config != null && !config.isEmpty() && config.containsKey("kernelSizes")){
			kernelSizes = (List<Integer>)config.get("kernelSizes");
		}
		else if(config != null && !config.isEmpty() && config.containsKey("weights")){
			List<Integer> tempshape = ListHelper.getShape(((Object[])config.get("weights")));
			for(int i = 0; i < dimensions; i++) {
				kernelSizes.add(tempshape.get(i));
			}
		}
		else {
			for(int i = 0; i < dimensions; i++) {
				kernelSizes.add(rand.nextInt(inputShape.get(i))+1);
			}
		}
		int nodeNumber = rand.nextInt(3)+2;//1;//rand.nextInt(3)+1;
		if(config != null && !config.isEmpty() && config.containsKey("bias")){
			nodeNumber = ((Object[])config.get("bias")).length;
		}
		if(config != null && !config.isEmpty() && config.containsKey("nodeNumber")){
			nodeNumber = (int)config.get("nodeNumber");
		}

		
		
		List<Integer> strides = new ArrayList<>();
		List<Integer> dilation_rates = new ArrayList<>();
		if(name.startsWith("Separable_Conv")|| name.startsWith("Depthwise_Conv") ) {
			strides.add(rand.nextInt(inputShape.get(0))+1);
			for(int i = 1; i < dimensions; i++) {
				strides.add(strides.get(0));
			}
		}
		else if(rand.nextBoolean()) {
			for(int i = 0; i < dimensions; i++) {
				if(rand.nextBoolean()) {
					strides.add(rand.nextInt(1)+1);
				}
				else if(rand.nextBoolean()) {
					strides.add(rand.nextInt(inputShape.get(i))+1);
				}
				else {
					strides.add(rand.nextInt(12)+1);
				}
				dilation_rates.add(1);
			}
		}
		else {
			for(int i = 0; i < dimensions; i++) {
				strides.add(1);
				dilation_rates.add(1);
//				if(kernelSizes.get(i) > 1) {
//					do {
//						dilation_rates.set(i,(rand.nextInt(3)+1));
//					} while(kernelSizes.get(i)+((dilation_rates.get(i)-1)*(kernelSizes.get(i)-1)) > inputShape.get(i));
//					
//				}
			}
		}
		if(config != null && !config.isEmpty() && config.containsKey("strides")){
			strides = (List<Integer>)config.get("strides");
			while(strides.size() < dimensions) {
				strides.add(strides.get(0));
			}
		}
		if(config != null && !config.isEmpty() && config.containsKey("dilation_rates")){
			dilation_rates = (List<Integer>)config.get("dilation_rates");
			while(dilation_rates.size() < dimensions) {
				dilation_rates.add(dilation_rates.get(0));
			}
		}
		String stride = Arrays.toString(strides.toArray()).replace("[", "(").replace("]", ")");
		params.put("strides", stride);
		
		
		ArrayList<Integer> inWS = null;
		ArrayList<Integer> outWS = null;
		Object inputWeights1 = null;
		if(name.equals("Conv1D_Transpose")|| name.equals("Conv2D_Transpose")|| name.equals("Conv3D_Transpose")) {
			if(config != null && !config.isEmpty() && config.containsKey("padding")){
				params.put("padding",config.get("padding")+"");
			}
			else {
				params.put("padding",rand.nextBoolean()+"");
			}
			
			inWS = new ArrayList<>(kernelSizes);
			inWS.add(nodeNumber);
			inWS.add(inputShape.get(dimensions));
			
			
			outWS = new ArrayList<>();
			outWS.add(nodeNumber);
		}
		else if(name.startsWith("Conv") && !name.contains("LSTM")) {
			if(config != null && !config.isEmpty() && config.containsKey("padding")){
				params.put("padding",config.get("padding")+"");
			}
			else {
				params.put("padding",rand.nextBoolean()+"");
			}	
			String dilation_rate = Arrays.toString(dilation_rates.toArray()).replace("[", "(").replace("]", ")");
			params.put("dilation_rate",dilation_rate);
			
			inWS = new ArrayList<>(kernelSizes);
			inWS.add(inputShape.get(dimensions));
			inWS.add(nodeNumber);
			
			outWS = new ArrayList<>();
			outWS.add(nodeNumber);
			
		}
		else if(name.startsWith("Locally_Connected")) {
			ArrayList<Integer> kernel_comps_per_dim = new ArrayList<>();
			int kernel_comps = (int) Math.ceil((double)(inputShape.get(0) - kernelSizes.get(0) +1) / (double)strides.get(0));
			kernel_comps_per_dim.add(kernel_comps);
			if(dimensions > 1) {
				kernel_comps_per_dim.add((int) Math.ceil((double)(inputShape.get(1) - kernelSizes.get(1) +1) / (double)strides.get(1)));
				kernel_comps *= kernel_comps_per_dim.get(1);
			}
			inWS = new ArrayList<>();
			inWS.add(kernel_comps);
			int tempKernelPlaces = kernelSizes.get(0);
			for(int i = 1; i < kernelSizes.size(); i++) {
				tempKernelPlaces = tempKernelPlaces * kernelSizes.get(i);
			}
			tempKernelPlaces *= inputShape.get(dimensions);
			inWS.add(tempKernelPlaces);
			inWS.add(nodeNumber);
			
			outWS = new ArrayList<>(kernel_comps_per_dim);//kernelSizes);
			//outWS.add(kernel_comps);
			outWS.add(nodeNumber);
		}
		else if(name.startsWith("Separable_Conv")) {
			params.put("padding",rand.nextBoolean()+"");
			inWS = new ArrayList<>(kernelSizes);
			inWS.add(inputShape.get(dimensions));
			inWS.add(1);
			
			ArrayList<Integer> inWS1 = new ArrayList<>();
			for(int i = 0; i < dimensions; i++) {
				inWS1.add(1);
			}
			
			inWS1.add(inputShape.get(dimensions));
			inWS1.add(nodeNumber);
			
			outWS = new ArrayList<>();
			outWS.add(nodeNumber);
			
			inputWeights1 = ListHelper.genList(rand, inWS1);
		}
		else if(name.startsWith("Depthwise_Conv")) {
			params.put("padding",rand.nextBoolean()+"");
			inWS = new ArrayList<>(kernelSizes);
			inWS.add(inputShape.get(dimensions));
			inWS.add(1);
			outWS = new ArrayList<>();
			outWS.add(inputShape.get(dimensions));
		}
		else if(name.startsWith("Conv_LSTM")) {
			inputShape.set(0, rand.nextInt(3)+1);
			
			
			params.clear();
			params.put("recurrent_activation", "'linear'");//"'sigmoid'");
			params.put("activation", "'linear'");//, "'tanh'");
			inputShape.add(1);//rand.nextInt(3)+2);
			kernelSizes.clear();
			for(int i = 0; i < dimensions; i++) {
				kernelSizes.add(rand.nextInt(inputShape.get(i+1))+1);
			}
			
			//params.put("padding",rand.nextBoolean()+"");
			inWS = new ArrayList<>(kernelSizes);
			inWS.add(inputShape.get(inputShape.size()-1));
			inWS.add(4*nodeNumber);
			
			ArrayList<Integer> inWS1 = new ArrayList<>(kernelSizes);
			
			inWS1.add(nodeNumber);
			inWS1.add(4*nodeNumber);
			
			outWS = new ArrayList<>();
			outWS.add(4*nodeNumber);
			
			inputWeights1 = ListHelper.genList(rand, inWS1,1);
		}

//		else {
//			name = name+dimensions+"D";
//		}
		Object inputWeights = ListHelper.genList(rand, inWS);//(rand, "int", inWS, 1, 5);//ListHelper.genList(rand, inWS,1);
		Object outputWeights = ListHelper.genList(rand, outWS,0);

		
		return new ConvLayer(name,nodeNumber,inputShape,kernelSizes,inputWeights,outputWeights,params, inputWeights1);
	}
	


}
