package layer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.json.simple.JSONObject;

import util.ListHelper;

public class ConvLayer extends NodeLayer {
	List<Integer> kernelShape;
	
	public ConvLayer(String name, int nodeNumber, List<Integer> inputShape,  List<Integer> kernelShape, Object inputWeights, Object outputWeights, LinkedHashMap<String, String> params) {
		super(nodeNumber, inputWeights, outputWeights,inputShape,params);
		this.name = name;
		this.kernelShape = kernelShape;
		if(!name.toLowerCase().startsWith("locally")) {
			this.setGroupName("conv");
		}
	}
	public ConvLayer(String name, int nodeNumber, List<Integer> inputShape,  List<Integer> kernelShape, Object inputWeights, Object outputWeights, LinkedHashMap<String, String> params, Object inputWeights1) {
		super(nodeNumber, inputWeights, inputWeights1, outputWeights,inputShape,params);
		this.name = name;
		this.kernelShape = kernelShape;
		if(!name.toLowerCase().startsWith("locally")) {
			this.setGroupName("conv");
		}
	}
	
	public ConvLayer(ConvLayer l) {
		super(l);
		this.name = l.name;
		this.kernelShape = l.kernelShape;
		if(!name.toLowerCase().startsWith("locally")) {
			this.setGroupName("conv");
		}
	}
	
	public 	String toString() {
		String inpS = Arrays.toString(inputShape.toArray());
		inpS = inpS.substring(1,inpS.length()-1);
		
		String kernelS = Arrays.toString(kernelShape.toArray());
		kernelS = kernelS.substring(1,kernelS.length()-1);
		if(name.equals("Depthwise_Conv2D")) {
			return "keras.layers."+name.replace("_", "")+"(("+kernelS+"),"+this.parameterString()+" input_shape=("+inpS+"))";
		}
		return "keras.layers."+name.replace("_", "")+"("+nodeNumber+", ("+kernelS+"),"+this.parameterString()+" input_shape=("+inpS+"))";
	}
	public  String toString(boolean noInputShape) {
		String kernelS = Arrays.toString(kernelShape.toArray());
		kernelS = kernelS.substring(1,kernelS.length()-1);
		if(name.equals("Depthwise_Conv2D")) {
			return "keras.layers."+name.replace("_", "")+"(("+kernelS+"),"+this.parameterString()+")";
		}
		return "keras.layers."+name.replace("_", "")+"("+nodeNumber+", ("+kernelS+"),"+this.parameterString()+")";
	}
	
	public  String toTensorflowString(Object in) {
		String weightStr ="w = model.get_weights()\n" + 
				this.getWeightString(0)+
//    			"w[0] = np.array("+ ListHelper.printList(inputWeights) +")\n"+
//    			((this.inputWeights1 == null) ?
//    			"w[1] = np.array("+ ListHelper.printList(ouptutWeights) +")\n" 
//    			:
//    			"w[1] = np.array("+ ListHelper.printList(inputWeights1)+")\n"+
//    			"w[2] = np.array("+ ListHelper.printList(ouptutWeights) +")\n")+
    			"model.set_weights(w)\n";
		return super.toTensorflowString(in, weightStr);
	}
	

	
	
	public  String toPrologString(Object in) {
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(par.length() > 0) {
			par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
	
		String kernelS = Arrays.toString(kernelShape.toArray());
		kernelS = kernelS.substring(1,kernelS.length()-1) +",";
		String inW = ListHelper.printList(getInputWeights());
		if(this.getInputWeights1() != null) {
			if(name.startsWith("Conv_LSTM")) {
				inW = inW+"," + ListHelper.printList(getInputWeights1());
			}
			else {
				inW = "["+inW+"," + ListHelper.printList(getInputWeights1())+"]";
			}
		}
		if(name.startsWith("Conv_LSTM")) {
			par = "";
			kernelS = "";
		}
		return name.toLowerCase().replaceAll("(\\d)[d]", "$1D")+"_layer("+ListHelper.printList(in)+", "+kernelS+inW+","+ListHelper.printList(getOutputWeights())+", "+par+"X)";
	}
	
	public Object generateInput(Random r) {
		if(this.fixedInput != null) {
			return this.fixedInput;
		}
		return ListHelper.genListandAddDefaultDim(r, this.getInputShape());//,1,10);//,1,2);
	}

	@Override
	public Layer copy() {
		return new ConvLayer(this);
	}
	
	@Override
	public JSONObject toJsonObject(boolean includeInOuputNodes, Map<String,Object> input, boolean omitInputsAndWeights) {
		JSONObject o = super.toJsonObject(includeInOuputNodes, input, omitInputsAndWeights);
		String size = ListHelper.printList(kernelShape.toArray());
		size = size.replace("[", "(").replace("]", ")");
		o.put("kernel_shape",size);
		return o;
	}
	
	public List<Integer> getOutputShape(){
		List<Integer> outputShape = new ArrayList<Integer>(inputShape);
		outputShape.add(0,1);
		
		if(name.equals("Conv1D_Transpose")|| name.equals("Conv2D_Transpose")|| name.equals("Conv3D_Transpose")) {
			boolean padding = Boolean.parseBoolean(params.get("padding"));
			List<Integer> strides = ListHelper.parseIntegerListString(params.get("strides"));
			System.out.println("####################### strides"+ Arrays.toString(strides.toArray())+ " "+ Arrays.toString(kernelShape.toArray()) + " "+ Arrays.toString(outputShape.toArray()));

			outputShape.clear();
			outputShape.add(1);
			
			//List<Integer> TEMPoutputShape = new ArrayList<Integer>();
			//TEMPoutputShape.add(1);
			
			int i =0;
			for (Integer pi : kernelShape) {
				int dim = 0;
				
				if(padding) {
					 dim = inputShape.get(i) * strides.get(i);
				}
				else {
					
					 dim = (inputShape.get(i)-1) * strides.get(i)+ (pi);
					 //if(inputShape.get(i) <= 3) {
					 dim = Math.max(dim,inputShape.get(i)*strides.get(i));
					 //}
					 //TEMPoutputShape.add(dim);
					 //dim = dim1;
				}
				//System.out.println("######## "+ dim + " " +pi + " "+ strides.get(i) + " " + inputShape.get(i));
				outputShape.add(dim);
				i++;
			}
			outputShape.add(nodeNumber);
			//TEMPoutputShape.add(nodeNumber);
			//System.out.println("######## TEMP Expected Output shape "+ Arrays.toString(TEMPoutputShape.toArray()));
		}
		else if(name.startsWith("Separable_Conv") || name.startsWith("Locally_Connected") || name.startsWith("Conv") && !name.contains("LSTM")) {
			boolean padding = Boolean.parseBoolean(params.get("padding"));
			
			List<Integer> strides = ListHelper.parseIntegerListString(params.get("strides"));
			while(kernelShape.size() > strides.size())
			{
				if(strides.size() == 0) {
					strides.add(1);
				}
				else {
					strides.add(strides.get(0));
				}
			}

			int i = 0;
			if(padding) {
				for (Integer pi : kernelShape) {
					int dim =(int)Math.ceil(( (double) outputShape.get(i+1)) / (double) strides.get(i));
					outputShape.set(i+1, dim);
					i++;
				}
			}
			else {
			for (Integer pi : kernelShape) {
				int dim =(int)Math.ceil(( (double) outputShape.get(i+1)-pi +1) / (double) strides.get(i));
				outputShape.set(i+1, dim);
				i++;
			}
			}
			outputShape.set(outputShape.size()-1, nodeNumber);
		}	
//		else if(name.startsWith("Locally_Connected")) {
//			
//		}
//		else if(name.startsWith("Separable_Conv")) {
//			
//		}
		else if(name.startsWith("Depthwise_Conv")) {
			boolean padding = Boolean.parseBoolean(params.get("padding"));
			
			List<Integer> strides = ListHelper.parseIntegerListString(params.get("strides"));
			while(kernelShape.size() > strides.size())
			{
				if(strides.size() == 0) {
					strides.add(1);
				}
				else {
					strides.add(strides.get(0));
				}
			}
			System.out.println("### strides"+ Arrays.toString(strides.toArray())+ " "+ Arrays.toString(kernelShape.toArray()) + " "+ Arrays.toString(outputShape.toArray()));		
			

			outputShape.clear();
			outputShape.add(1);
			//outputShape.add(inputShape.get(0));

			int i = 0;
			for (Integer pi : kernelShape) {
				int dim = 0;
				if(padding) {
					 dim = (int)Math.ceil((double)(inputShape.get(i))/(double)strides.get(i));//Math.ceil(( (double) inputShape.get(i)-pi +1) / (double) strides.get(i));//inputShape.get(i) ;
//					 if(inputShape.get(i) <= 2) {
//						 dim = Math.max(dim,(int) Math.ceil((double)(inputShape.get(i))/(double)strides.get(i)));
//					 }
				}
				else{
					dim =(int)Math.ceil(( (double) inputShape.get(i)-pi +1) / (double) strides.get(i));
				}
				outputShape.add(dim);
				i++;
			}	
			outputShape.add(inputShape.get(inputShape.size()-1));
		}
		else if(name.startsWith("Conv_LSTM")) {
			boolean padding = Boolean.parseBoolean(params.get("padding"));
			List<Integer> strides = ListHelper.parseIntegerListString(params.get("strides"));
			outputShape.clear();
			outputShape.add(1);
			outputShape.add(nodeNumber);
			int i =0;
			for (Integer pi : kernelShape) {
				int dim = 0;
				if(padding) {
					 dim = inputShape.get(i+1) * strides.get(i);
				}
				else {
					dim = (inputShape.get(i+1)-1) * strides.get(i) + kernelShape.get(i);
				}
				outputShape.add(dim);
				i++;
			}
		}
		return outputShape;
	}
}
