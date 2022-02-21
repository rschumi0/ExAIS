package layer;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import util.ListHelper;

public class ConvLayer extends NodeLayer {
	List<Integer> kernelShape;

	
	public ConvLayer(String name, int nodeNumber, List<Integer> inputShape,  List<Integer> kernelShape, Object inputWeights, Object outputWeights, LinkedHashMap<String, String> params) {
		super(nodeNumber, inputWeights, outputWeights,inputShape,params);
		this.name = name;
		this.kernelShape = kernelShape;
	}
	public ConvLayer(String name, int nodeNumber, List<Integer> inputShape,  List<Integer> kernelShape, Object inputWeights, Object outputWeights, LinkedHashMap<String, String> params, Object inputWeights1) {
		super(nodeNumber, inputWeights, inputWeights1, outputWeights,inputShape,params);
		this.name = name;
		this.kernelShape = kernelShape;
	}
	
	public ConvLayer(ConvLayer l) {
		super(l);
		this.name = l.name;
		this.kernelShape = l.kernelShape;
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
		return ListHelper.genListandAddDefaultDim(r, this.getInputShape());//,1,10);//,1,2);
	}

	@Override
	public Layer copy() {
		return new ConvLayer(this);
	}
}
