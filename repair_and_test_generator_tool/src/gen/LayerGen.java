package gen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.*;
import util.ListHelper;

public class LayerGen {
	
	public static PoolLayer genPoolLayer(Random rand) {
		int dimensions = 3;//rand.nextInt(3)+1;
		List<Integer> inputShape = new ArrayList<>();//Arrays.asList(3,3));
		for(int i = 0; i <= dimensions; i++) {
			inputShape.add(rand.nextInt(2)+3);
		}
		
		String[] names = { "Global_Max_Pool", "Global_Average_Pooling", "Average_Pooling","Max_Pool"};//, 
		String name = names[rand.nextInt(names.length)];
		//String inputShape ="(3,3,)";
		
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		if(!name.startsWith("Global")) {
			List<Integer> poolSizes = new ArrayList<>();
			
			for(int i = 0; i < dimensions; i++) {
				poolSizes.add(rand.nextInt(inputShape.get(i))+1);
			}
			String size = Arrays.toString(poolSizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("pool_size", size);
			
			if(rand.nextBoolean()) {
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
	
	public static MultiInputLayer genMultiInputLayer(Random rand) {
		String[] names = {"Average","Add","Multiply","Minimum", "Maximum"};//, "Concatenate"};//,
		String name = names[rand.nextInt(names.length)];
		int dimensions = rand.nextInt(2)+1;
		List<Integer> inputShape = new ArrayList<>();//Arrays.asList(3,3));
		for(int i = 0; i <= dimensions; i++) {
			inputShape.add(rand.nextInt(2)+3);
		}
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		if(name.equals("Concatenate")) {
			params.put("axis",rand.nextInt(dimensions+1)+"");
		}
		
		return new MultiInputLayer(name,inputShape,params);
	}
	public static MultiInputLayer genTwoInputLayer(Random rand) {
		String[] names = {"Subtract", "Dot", "Concatenate"};
		String name = names[rand.nextInt(names.length)];
		//String name = "Concatenate";
		int dimensions = rand.nextInt(2)+1;
		List<Integer> inputShape = new ArrayList<>();//Arrays.asList(3,3));
		for(int i = 0; i <= dimensions; i++) {
			inputShape.add(rand.nextInt(2)+3);
		}
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		if(name.equals("Concatenate")) {
			params.put("axis",rand.nextInt(dimensions+1)+"");
		}
		return new MultiInputLayer(name,inputShape,params);
	}
	
	public static ActivationLayer genActivationLayer(Random rand) {
		String[] names = {"PReLU"};//{"ReLU","Thresholded_ReLU","ELU"};//,"Softmax"};//,"Leaky_ReLU"
		String name = names[rand.nextInt(names.length)];
		int dimensions = rand.nextInt(2)+1;
		List<Integer> inputShape = new ArrayList<>();//Arrays.asList(3,3));
		for(int i = 0; i <= dimensions; i++) {
			inputShape.add(rand.nextInt(2)+3);
		}
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		Object alphas = null;
		if(name.equals("ReLU")) {
			params.put("max_value",randDoubleRange(rand,0.01,10.0)+"");
			params.put("negative_slope",randDoubleRange(rand,0.01,10.0)+"");
			params.put("threshold",randDoubleRange(rand,-10.0,10.0)+"");
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
			alphas  = ListHelper.genList(rand, inputShape);
		}
//		else if(name.equals("Softmax")) {
//			params.put("axis",rand.nextInt(dimensions+1)+"");
//		}
		
		return new ActivationLayer(name,inputShape,alphas,params);
	}
	
	public static HelperLayer genHelperLayer(Random rand) {
		String[] names = {"Repeat_Vector"};//{"Cropping","Up_Sampling","Zero_Padding","Repeat_Vector"};
		String name = names[rand.nextInt(names.length)];
		int dimensions = name.equals("Repeat_Vector") ? 0: rand.nextInt(2)+1;
		List<Integer> inputShape = new ArrayList<>();//Arrays.asList(3,3));
		for(int i = 0; i <= dimensions; i++) {
			inputShape.add(rand.nextInt(2)+3);
		}
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		if(name.equals("Cropping")) {
			List<Object> sizes = new ArrayList<>();
			for(int i = 0; i < dimensions; i++) {
				int s1 = rand.nextInt(inputShape.get(i)-1)+1;
				int s2 = rand.nextInt(inputShape.get(i)-s1);
				Object[] o = {s1,s2};
				sizes.add(o);
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("cropping", size);
		}
		else if(name.equals("Up_Sampling")) {
			List<Integer> sizes = new ArrayList<>();
			
			for(int i = 0; i < dimensions; i++) {
				sizes.add(rand.nextInt(inputShape.get(i)-1)+1);
			}
			String size = Arrays.toString(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			params.put("size", size);
		}
		else if(name.equals("Zero_Padding")) {
			List<Object> sizes = new ArrayList<>();
			for(int i = 0; i < dimensions; i++) {
				int s1 = rand.nextInt(2)+1;
				int s2 = rand.nextInt(2)+1;
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
		return new HelperLayer(name,dimensions,inputShape,params);
	}
	/*tf.keras.layers.Dense(
		    units, activation=None, use_bias=True, kernel_initializer='glorot_uniform',
		    bias_initializer='zeros', kernel_regularizer=None, bias_regularizer=None,
		    activity_regularizer=None, kernel_constraint=None, bias_constraint=None,
		    **kwargs
		)*/
	
	public static DenseLayer genDenseLayer(Random rand) {
		
		String name  = "Dense";
		int nodeNumber = rand.nextInt(4)+1;
		int dimensions = name.equals("Dense") ? rand.nextInt(3)+1 : rand.nextInt(2)+1;
		
		List<Integer> inputShape = new ArrayList<>();
		for(int i = 0; i <= dimensions; i++) {
			inputShape.add(rand.nextInt(4)+2);
		}
		
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		
		//List<Integer> kernelSizes = new ArrayList<>();
		
		for(int i = 0; i < dimensions; i++) {
			System.out.println("nput shape oth index"+inputShape.get(i));
			int temp = rand.nextInt(inputShape.get(i));
			System.out.println("ith ="+temp);
			Integer wDim = temp+1;
			//kernelSizes.add(wDim);	
		}
		
		ArrayList<Integer> inWS = null;
		ArrayList<Integer> outWS = null;
		
		/*if(name.equals("Dense")) {
			inWS = new ArrayList<>(kernelSizes);//1
			inWS.add(inputShape.get(dimensions));	
			inWS.add(nodeNumber);
			outWS = new ArrayList<>();
			outWS.add(nodeNumber);	
		}*/
		
		String[] activations = {"None","ReLU","Thresholded_ReLU","ELU","Softmax"};		
		//String activation = activations[rand.nextInt(activations.length)];
		String activation = "None";
		String[] initializers = {"tf.keras.initializers.ones","tf.keras.initializers.zeros","random-weights"};
		//String kernel_initializer = initializers[rand.nextInt(initializers.length)];
		//String bias_initializer = initializers[rand.nextInt(initializers.length)];
		String kernal_initializer = "tf.keras.initializers.ones";
		String bias_initializer = "tf.keras.initializers.zeros";
		params.put("activation",activation);
		params.put("kernel_initializer",kernal_initializer);// This is actually input weight initializer
		params.put("use_bias","True");
		params.put("bias_initializer",bias_initializer);
		
		Object inputWeights = ListHelper.genList(rand, inWS);
		Object outputWeights = ListHelper.genList(rand, outWS);

		return new DenseLayer(name,nodeNumber,inputShape,inputWeights,outputWeights,params);
		
	}	


	public static ConvLayer genConvLayer(Random rand) {

		String[] names = {"Conv3D_Transpose","Conv2D_Transpose","Separable_Conv", "Conv","Locally_Connected"};//,"Conv2DTranspose"};// 
		String name = names[rand.nextInt(names.length)];
		
		int dimensions = name.equals("Conv3D_Transpose")? 3 : 
						 name.equals("Conv2D_Transpose") ? 2 : 
					     name.equals("Conv") ? rand.nextInt(3)+1 : rand.nextInt(2)+1;
		
		
		List<Integer> inputShape = new ArrayList<>();//Arrays.asList(3,3));
		for(int i = 0; i <= dimensions; i++) {
			inputShape.add(rand.nextInt(4)+2);
		}

		
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		List<Integer> kernelSizes = new ArrayList<>();
		for(int i = 0; i < dimensions; i++) {
			kernelSizes.add(rand.nextInt(inputShape.get(i))+1);
		}
		int nodeNumber = rand.nextInt(3)+1;
		
		
		List<Integer> strides = new ArrayList<>();
		ArrayList<Integer> dilation_rates = new ArrayList<>();
		if(name.equals("Separable_Conv")) {
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
		}else {
			for(int i = 0; i < dimensions; i++) {
				strides.add(1);
				dilation_rates.add(1);
				if(kernelSizes.get(i) > 1) {
					do {
						dilation_rates.set(i,(rand.nextInt(3)+1));
					} while(kernelSizes.get(i)+((dilation_rates.get(i)-1)*(kernelSizes.get(i)-1)) > inputShape.get(i));
					
				}
			}
		}
		String stride = Arrays.toString(strides.toArray()).replace("[", "(").replace("]", ")");
		params.put("strides", stride);
		
		
		ArrayList<Integer> inWS = null;
		ArrayList<Integer> outWS = null;
		Object inputWeights1 = null;
		if(name.equals("Conv")) {
			params.put("padding",rand.nextBoolean()+"");
			String dilation_rate = Arrays.toString(dilation_rates.toArray()).replace("[", "(").replace("]", ")");
			params.put("dilation_rate",dilation_rate);
			
			inWS = new ArrayList<>(kernelSizes);
			inWS.add(inputShape.get(dimensions));
			inWS.add(nodeNumber);
			
			outWS = new ArrayList<>();
			outWS.add(nodeNumber);
			
		}
		else if(name.equals("Locally_Connected")) {
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
		else if(name.equals("Separable_Conv")) {
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

			
			
			
		if(name.equals("Conv2D_Transpose" )|| name.equals("Conv3D_Transpose")) {
			params.put("padding",rand.nextBoolean()+"");
			
			inWS = new ArrayList<>(kernelSizes);
			inWS.add(nodeNumber);
			inWS.add(inputShape.get(dimensions));
			
			
			outWS = new ArrayList<>();
			outWS.add(nodeNumber);
		}
		else {
			name = name+dimensions+"D";
		}
		Object inputWeights = ListHelper.genList(rand, inWS);
		Object outputWeights = ListHelper.genList(rand, outWS);

		
		return new ConvLayer(name,nodeNumber,inputShape,kernelSizes,inputWeights,outputWeights,params, inputWeights1);
	}
	
	public static EmbeddingLayer genEmbeddingLayer(Random rand) {
		int input_dim = rand.nextInt(4)+1;
		int output_dim = rand.nextInt(4)+1;
		List<Integer> weightShape = Arrays.asList(input_dim,output_dim);
		Object weights = ListHelper.genList(rand, weightShape);

		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		
		List<Integer> inputShape = new ArrayList<>();
		inputShape.add(rand.nextInt(3)+1);
		
		return new EmbeddingLayer(weights,inputShape,params);
	}
	
	private static Double randDoubleRange(Random r, Double min, Double max) {
		return min + r.nextDouble() * (max - min);
	}
}
