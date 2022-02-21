package layer;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;

import util.ListHelper;

public class EmbeddingLayer extends Layer {
	
	int input_dim;
	int output_dim;
	Object weights;
	
	public EmbeddingLayer(int input_dim, int output_dim, Object weights, List<Integer> inputShape, LinkedHashMap<String, String> params) {
		super(inputShape,params);
		this.input_dim = input_dim;
		this.output_dim = output_dim;
		this.weights = weights;
		this.name = "Embedding";
	}
	
	public EmbeddingLayer(EmbeddingLayer l) {
		super(l);
		this.input_dim = l.input_dim;
		this.output_dim = l.output_dim;
		this.weights = l.weights;
		this.name = l.name;
	}
	
	
	public int getInput_dim() {
		return input_dim;
	}

	public void setInput_dim(int input_dim) {
		this.input_dim = input_dim;
	}

	public int getOutput_dim() {
		return output_dim;
	}

	public void setOutput_dim(int output_dim) {
		this.output_dim = output_dim;
	}
	
	public Object getWeights() {
		return weights;
	}


	public void setWeights(Object weights) {
		this.weights = weights;
	}


	public  String toString() {
		return "keras.layers."+name.replace("_", "")+"("+input_dim+", "+output_dim+", "+this.parameterString()+")";
	}
	public  String toString(boolean noInputShape) {
		return this.toString();
	}
	
//	public  String toTensorflowString(Object in) {		
//    	String weightStr ="w = model.get_weights()\n" + 
//    			this.getWeightString(0)+
//    			//"w[0] = np.array("+ ListHelper.printList(weights) +")\n"+
//    			"model.set_weights(w)\n";
//
//		return super.toTensorflowString(in, weightStr);
//	}
	
	public String getWeightString(int index) {
		return "w["+(index++)+ "] =  np.array("+ ListHelper.printList(weights) +")\n";
	}

	public  String toPrologString(Object in) {
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(par.length() > 0) {
			par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
	
		return name.toLowerCase()+"_layer("+ListHelper.printList(in)+", "+ListHelper.printList(weights)+", "+par+"X)";
	}

	@Override
	public Layer copy() {
		return new EmbeddingLayer(this);
	}
}
