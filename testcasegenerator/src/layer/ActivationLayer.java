package layer;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;

import util.ListHelper;

public class ActivationLayer extends Layer {
	
	Object alphas = null;

	public ActivationLayer(String name, List<Integer> inputShape, Object alphas,  LinkedHashMap<String, String> params) {
		super(name, inputShape, params);
		this.alphas = alphas;
	}
	
	public ActivationLayer(ActivationLayer l) {
		super(l);
		this.alphas = l.alphas;
	}
	
	public  String toString() {
//		String inpS = Arrays.toString(inputShape.toArray());
//		inpS = inpS.substring(1,inpS.length()-1);
//		return "keras.layers."+name.replace("_", "")+"("+this.parameterString()+"input_shape=("+inpS+"))";
		return toString(false);
	}
	
	public String toString(boolean noInputShape) {
		String inpS = "";
		if(!noInputShape) {
			inpS = Arrays.toString(inputShape.toArray());
			inpS = inpS.substring(1,inpS.length()-1);
			inpS = "input_shape=("+inpS+")";
		}
		if(name.equals("Sigmoid")) {
			return "keras.layers.Activation"+"('"+name.replace("_", "").toLowerCase()+"', "+this.parameterString()+inpS+")";
		}
		return "keras.layers."+name.replace("_", "")+"("+this.parameterString()+inpS+")";
	}
	
//	public  String toTensorflowString(Object in) {		
//    	String weightStr ="";
//		if(alphas != null) {
//			weightStr = "w = model.get_weights()\n" + 
//					this.getWeightString(0)+
//	    			//"w[0] = np.array("+ ListHelper.printList(alphas) +")\n"+
//	    			"model.set_weights(w)\n";
//		}
//		return super.toTensorflowString(in, weightStr);
//	}
	public String getWeightString(int index) {
		if(alphas == null) {
			return "";
		}
		return "w["+(index++)+"] = np.array("+ ListHelper.printList(alphas) +")\n";
	}

	public  String toPrologString(Object in) {
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(par.length() > 0) {
			par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
		if(alphas != null) {
			par = ListHelper.printList(alphas) + ", "+par;
		}
		
	
		if(in instanceof String )
		{
			return name.toLowerCase()+"_layer("+in+", "+par+"X)";
		}
		return name.toLowerCase()+"_layer("+ListHelper.printList(in)+", "+par+"X)";
	}

	@Override
	public Layer copy() {
		return new ActivationLayer(this);
	}
	

}
