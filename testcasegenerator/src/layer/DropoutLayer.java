package layer;

import java.util.List;
import java.util.Random;

import util.ListHelper;

import java.util.Arrays;
import java.util.LinkedHashMap;

public class DropoutLayer extends Layer{

	//int dimensions;
	
	public DropoutLayer(String name,List<Integer> inputShape, LinkedHashMap<String, String> params) {
		super(name, inputShape, params);
		this.isNonDetLayer = true;
	}
	
	public DropoutLayer(DropoutLayer l) {
		super(l);
		this.isNonDetLayer = l.isNonDetLayer;
	}
	

	@Override
	public String parameterString() {
		String p = super.parameterString();
		p = p.replace("AcceptedRateDiff=0.1, ", "");
		return p;
	}
	
	public  String toString() {
		String inpS = Arrays.toString(inputShape.toArray());
		inpS = inpS.substring(1,inpS.length()-1);
		if(inputShape.size() == 1) {
			inpS += ",";
		}
		
		return "keras.layers."+name.replace("_", "")+"("+this.parameterString()+"input_shape=("+inpS+"))";
	}
	
	public  String toString(boolean noInputShape) {
		return "keras.layers."+name.replace("_", "")+"("+this.parameterString()+")";
	}

	
	public  String toPrologString(Object in,Object out) {
		params.remove("seed");
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(par.length() > 0) {
			//par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
		return name.toLowerCase().replaceAll("(\\d)[d]", "$1D")+"_layer("+ListHelper.printList(in)+", "+ListHelper.printList(out)+", "+par+")";
	}

	@Override
	public Layer copy() {
		return new DropoutLayer(this);
	}
	

}
