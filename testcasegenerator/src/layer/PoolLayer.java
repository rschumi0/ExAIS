package layer;

import java.util.List;
import java.util.Random;
import util.ListHelper;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;

public class PoolLayer extends Layer{

	int dimensions;
	
	public PoolLayer(String name, int dimensions, List<Integer> inputShape, LinkedHashMap<String, String> params) {
		super(name, inputShape, params);
		this.dimensions = dimensions;
	}
	
	public PoolLayer(PoolLayer l) {
		super(l);
		this.dimensions = l.dimensions;
	}
	
	public  String toTensorflowString(Object in, String weightDefinition) {
		String ret = super.toTensorflowString(in,weightDefinition);
		if(name.equals("Max_Pool3D") || name.equals("Average_Pooling3D")) {
			ret = ret.replace("tf.keras.backend.set_floatx('float64')", "");
		}
		return ret;
	}

	public int getDimensions() {
		return dimensions;
	}

	public void setDimensions(int dimensions) {
		this.dimensions = dimensions;
	}
	public String parameterString() {
		String ret = super.parameterString();
		if(ret.contains("padding") )
		{
			ret=ret.replace("padding=true", "padding='same'").replace("padding=false", "padding='valid'");
		}
		return ret;
	}
	public  String toString() {
		String inpS = Arrays.toString(inputShape.toArray());
		inpS = inpS.substring(1,inpS.length()-1);
		return "keras.layers."+name.replace("_", "")+"("+this.parameterString()+"input_shape=("+inpS+"))";
	}
	
	public  String toString(boolean noInputShape) {
		return "keras.layers."+name.replace("_", "")+"("+this.parameterString()+")";
	}

	
	public  String toPrologString(Object in) {
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(par.length() > 0) {
			par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
		return name.toLowerCase().replaceAll("(\\d)[d]", "$1D")+"_layer("+ListHelper.printList(in)+", "+par+"X)";
	}
	
	public Object generateInput(Random r) {
		
		ArrayList<Integer> tempShape = new ArrayList<>(this.getInputShape());
		tempShape.add(0,1);//2);//r.nextInt(3)+2);
    	return ListHelper.genList(r, tempShape,1,2);
		//return ListHelper.genListandAddDefaultDim(r, this.getInputShape(),1,2);
	}

	@Override
	public Layer copy() {
		return new PoolLayer(this);
	}

}
