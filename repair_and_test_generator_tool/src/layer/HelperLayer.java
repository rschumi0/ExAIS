package layer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;

import util.ListHelper;

public class HelperLayer extends PoolLayer {

	public HelperLayer(String name, int dimensions, List<Integer> inputShape, LinkedHashMap<String, String> params) {
		super(name, dimensions, inputShape, params);
	}
	
	public HelperLayer(HelperLayer l) {
		super(l);
	}
	
	public  String toString() {
//		String inpS = Arrays.toString(inputShape.toArray());
//		inpS = inpS.substring(1,inpS.length()-1);
//		if(dimensions == 0) {// && (name.equals("Reshape") || name.equals("Layer_Normalization"))){
//			inpS+=",";
//		}
//		if(name.equals("Repeat_Vector")|| name.equals("Permute")) {
//		
//			return "keras.layers."+name.replace("_", "")+"("+this.parameterString().substring(0,this.parameterString().length()-1)+")";
//		}
//		return "keras.layers."+name.replace("_", "")+"("+this.parameterString()+"input_shape=("+inpS+"))";
		return toString(false);
	}
	
	public String toTensorflowString(Object in, String weightDefinition) {
		String ret = super.toTensorflowString(in, weightDefinition);
		if(name.equals("Input_Spec")) {
			String tempLayer = "class TempInputSpecLayer(tf.keras.layers.Activation):\n" + 
					"    def __init__(self):\n" + 
					"        super(keras.layers.Activation, self).__init__()\n" + 
					"        self.input_spec = keras.layers.InputSpec("+this.parameterString().replace("dtype='float',","")+")\n" + 
					"    def call(self, input_1, training=False):\n" + 
					"        return input_1\n";
			ret = ret.replace("model =", tempLayer+"model =");
		}
		return ret;
	}
	
	
	
	public  String toString(boolean noInputShape) {
		String inpS = "";
		if(!noInputShape && !name.contains("Input")) {
			inpS = Arrays.toString(inputShape.toArray());
			inpS = inpS.substring(1,inpS.length()-1);
			if(dimensions == 0) {// && (name.equals("Reshape") || name.equals("Layer_Normalization"))){
				inpS+=",";
			}
			inpS = " input_shape=("+inpS+")";
		}

		if(name.equals("Repeat_Vector")|| name.equals("Permute")) {
		
			return "keras.layers."+name.replace("_", "")+"("+this.parameterString().substring(0,this.parameterString().length()-1)+")";
		}
		else if(name.equals("Input_Spec")) {
			return "TempInputSpecLayer()";
		}
		return "keras.layers."+name.replace("_", "")+"("+this.parameterString()+inpS+")";
	}
	
	public  String toPrologString(Object in) {
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(name.equals("Reshape") || name.contains("Input")) {
			par = par.replace("(", "[").replace(")", "]");
		}
		if(par.length() > 0) {
			par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
		par=par.replace("shape=", "");
		par=par.replace("batch_size=", "");
		par=par.replace("dtype=", "");
		par=par.replace("ragged=", "");
		par=par.replace("ndim=", "");
		par=par.replace("max_ndim=", "");
		par=par.replace("min_ndim=", "");
		par=par.replace("allow_last_axis_squeeze=", "");
		par=par.replace("dtype=", "");
		
		if(name.equals("Repeat_Vector") || name.equals("Permute")) {
			return name.toLowerCase()+"_layer("+ListHelper.printList(in)+", "+par+"X)";
		}
		return name.toLowerCase().replaceAll("(\\d)[d]", "$1D")+"_layer("+ListHelper.printList(in)+", "+par+"X)";
	}

	public String parameterString() {
		String ret = super.parameterString();
		ret=ret.replace("Permute_Dims=", "");
		ret=ret.replace("Repeat_Vector_N=", "");
		ret=ret.replace("Reshape_Sizes=", "");
		if(name.equals("Batch_Normalization")) {
			String[] retParts1 = ret.split("gammas");
			String[] retParts2 = retParts1[1].split("],");
			ret = retParts1[0] + retParts2[retParts2.length -1 ];
		}
		
		return ret;
	}
	
	public String getWeightString(int index) {
		if(!name.equals("Batch_Normalization")) {
			return "";
		}
		return "w["+(index++)+"] = np.array("+ this.params.get("gammas") +")\n"+
		"w["+(index++)+"] = np.array("+ this.params.get("betas") +")\n"+
		"w["+(index++)+"] = np.array("+ this.params.get("means") +")\n"+
		"w["+(index++)+"] = np.array("+ this.params.get("variances") +")\n";
	}
//	public  String toTensorflowString(Object in) {
//		String weightStr ="w = model.get_weights()\n" + 
//				this.getWeightString(0)+
//    			"model.set_weights(w)\n";
//		return super.toTensorflowString(in, weightStr);
//	}
	
	@Override
	public Layer copy() {
		return new HelperLayer(this);
	}
	
	@Override
	public List<Integer> getOutputShape(){
		List<Integer> outputShape = new ArrayList<Integer>(inputShape);
		outputShape.add(0,1);
		if(name.toLowerCase().contains("flatten")) {
			int prod = 1;
			for (Integer i : outputShape) {
				prod *= i;
			}
			outputShape.clear();
			outputShape.add(1);
			outputShape.add(prod);
		}
		else if(name.startsWith("Cropping")){
			List<Integer> sizes = ListHelper.parseIntegerListString(params.get("cropping"));
			int i = 1;
			for (int s = 0; s < sizes.size(); s= s+2) {
				outputShape.set(i, outputShape.get(i)-sizes.get(s)-sizes.get(s+1));
				i++;
			}	
		}	
		else if(name.startsWith("Zero_Padding")){
			List<Integer> sizes = ListHelper.parseIntegerListString(params.get("padding"));
			int i = 1;
			for (int s = 0; s < sizes.size(); s= s+2) {
				outputShape.set(i, outputShape.get(i)+sizes.get(s)+sizes.get(s+1));
				i++;
			}	
		}	
		else if(name.startsWith("Up_Sampling")) {
			List<Integer> sizes = ListHelper.parseIntegerListString(params.get("size"));
			int i = 1;
			for (Integer s : sizes) {
				outputShape.set(i, outputShape.get(i)*s);
				i++;
			}
		}
		else if(name.equals("Repeat_Vector")) {
			outputShape.add(1,Integer.parseInt(params.get("Repeat_Vector_N")));
		}
		else if(name.equals("Permute")) {
			List<Integer> dims = ListHelper.parseIntegerListString(params.get("Permute_Dims"));
			int tempDim = outputShape.get(dims.get(0));
			outputShape.set(dims.get(0), outputShape.get(dims.get(1)));
			outputShape.set(dims.get(1), tempDim);
		}
		else if(name.equals("Reshape")) {
			outputShape = ListHelper.parseIntegerListString(params.get("Reshape_Sizes"));
			outputShape.add(0,1);
		}
		return outputShape;
	}

}
