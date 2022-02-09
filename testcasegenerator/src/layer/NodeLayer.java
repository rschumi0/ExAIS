package layer;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import util.ListHelper;

public class NodeLayer extends Layer {
	protected int nodeNumber;
	Object inputWeights;
	Object outputWeights;
	Object inputWeights1 = null;
	
	public NodeLayer(int nodeNumber, Object inputWeights, Object outputWeights, List<Integer> inputShape, LinkedHashMap<String, String> params) {
		super(inputShape,params);
		this.nodeNumber = nodeNumber;
		this.inputWeights = inputWeights;
		this.outputWeights = outputWeights;
		
	}
	
	public NodeLayer(int nodeNumber, Object inputWeights, Object inputWeights1, Object outputWeights, List<Integer> inputShape, LinkedHashMap<String, String> params) {
		super(inputShape,params);
		this.nodeNumber = nodeNumber;
		this.inputWeights = inputWeights;
		this.outputWeights = outputWeights;
		this.inputWeights1 = inputWeights1;
	}
	
	public NodeLayer(NodeLayer l) {
		super(l);
		this.nodeNumber = l.nodeNumber;
		this.inputWeights = l.inputWeights;
		this.outputWeights = l.outputWeights;
		this.inputWeights1 = l.inputWeights1;
	}
	
	
	public 	String toString() {
		String inpS = Arrays.toString(inputShape.toArray());
		inpS = inpS.substring(1,inpS.length()-1);
		return "keras.layers."+name.replace("_", "")+"("+nodeNumber+","+this.parameterString()+" input_shape=("+inpS+"))";
	}
	
	public  String toString(boolean noInputShape) {
		return "keras.layers."+name.replace("_", "")+"("+nodeNumber+","+this.parameterString()+")";
	}
	
	public  String toPrologString(Object in) {
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(par.length() > 0) {
			par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
		String inW = ListHelper.printList(inputWeights);
		return name.toLowerCase().replaceAll("(\\d)[d]", "$1D")+"_layer("+ListHelper.printList(in)+", "+inW+","+ListHelper.printList(outputWeights)+", "+par+"X)";
	}
	
//	public static String weightString(Object weights) {
////		String ret = "[";
////		for(Float f : weights) {
////			ret += f + ",";
////		}
////		ret = ret.substring(0,ret.length()-1);
////		ret+= "]";
////		return ret;
//		return ListHelper.printList(weights);
//	}

	public String getWeightString(int index) {
		return "w["+(index++)+"] = np.array("+ ListHelper.printList(inputWeights) +")\n"+
    			((this.inputWeights1 == null) ?
    			"w["+(index++)+"] = np.array("+ ListHelper.printList(outputWeights) +")\n" 
    			:
    			"w["+(index++)+"] = np.array("+ ListHelper.printList(inputWeights1)+")\n"+
    			"w["+(index++)+"] = np.array("+ ListHelper.printList(outputWeights) +")\n");
	}
	@Override
	public Layer copy() {
		return new NodeLayer(this);
	}

	public void setInputWeights(String w) {
		w = w.replace("\r\n", "");
		w = w.replace("\n", "");
		w = w.replaceAll(" +", " ");
		w = w.replace("[ ","[");
		w = w.replace(" [ ","[");
		w = w.replaceAll("\\s+","");
		//System.out.print(w);
		this.inputWeights = ListHelper.parseList(w);
	}
	
	public void setOutputWeights(String w) {
		w = w.replace("\r\n", "");
		w = w.replace("\n", "");
		w = w.replaceAll(" +", " ");
		w = w.replace("[ ","[");
		w = w.replace(" [ ","[");
		w = w.replaceAll("\\s+","");
		if(!w.startsWith("[[")) {
			this.outputWeights = ((Object[])ListHelper.parseList("["+w+"]"))[0];
		}
		else {
			this.outputWeights = ListHelper.parseList(w);
		}
		
	}
}
