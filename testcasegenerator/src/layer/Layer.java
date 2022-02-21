package layer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;


import util.ListHelper;

public abstract class Layer {
	
	public boolean isNonDetLayer = false;
	
	public boolean isNewlyAdded = false;
	
	public boolean isModified = false;
	
	public boolean hasError = false;
	public boolean errorMode = false;
	
	public int getLayerCount() {
		int r = 1;
		for (Layer l : childLayers) {
			r+= l.getLayerCount();
		}
		return r;
	}
	
	public Layer(String name,List<Integer> inputShape, LinkedHashMap<String, String> params) {
		this.name = name;
		this.inputShape = inputShape;
		this.params = params;
	}
	public Layer(List<Integer> inputShape, LinkedHashMap<String, String> params) {
		this.inputShape = inputShape;
		this.params = params;
	}
	public Layer(LinkedHashMap<String, String> params) {
		this.params = params;
	}
	public Layer() {}
	
	public Layer(Layer l) {
		this.name = l.name;
		this.inputShape = l.inputShape;
		this.params = l.params;
//		if(l.parentLayer != null) {
//			this.parentLayer = l.parentLayer.copy();
//		}
		this.childLayers = new ArrayList<>();
		for (Layer l1 : l.childLayers) {
			Layer l2 = l1.copy();
			l2.parentLayer = this;
			this.childLayers.add(l2);
		}
		this.uniqueName = l.uniqueName;
	}
	
	protected LinkedHashMap<String, String> params = null;
	public LinkedHashMap<String, String> getParams() {
		return params;
	}

	public void setParams(LinkedHashMap<String, String> params) {
		this.params = params;
	}
	
	public String parameterString() {
		return this.parameterString(false);
	}
	
	public String parameterString(boolean excludeName) {
		String ret = "";
		if(params != null) {
			for (String k : params.keySet()) {
				ret += k +"="+ params.get(k) + ", ";
			}
		}
		if(ret.contains("padding") )
		{
			ret=ret.replace("padding=true", "padding='same'").replace("padding=false", "padding='valid'");
		}
		ret = ret.replace("false", "False").replace("true", "True");
		if(this.uniqueName != null && !this.uniqueName.isEmpty() && !excludeName)
		{
			ret += "name = '"+this.uniqueName+"', ";
		}
		return ret;
	}
	
	
	protected List<Integer> inputShape;
	public List<Integer> getInputShape() {
		return inputShape;
	}

	public void setInputShape(List<Integer> inputShape) {
		this.inputShape = inputShape;
	}
	
	protected String name = null;
	public String getName() {
		if(name == null || name.equals(""))
		{
			return this.getClass().getSimpleName();
		}
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getWeightString(int index) {
			return "";
	}
	
//	public  String toTensorFlowString(Object in) {
//		return null;
//	}
	
	static final String libImports = "import os\n" + 
			"os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'\n"+
			"import tensorflow as tf\n"
			+ "from tensorflow import keras\n" 
			+ "from tensorflow.keras import layers\n"
			+ "import numpy as np\n"
			//+ "tf.get_logger().setLevel('WARNING')\n"
			+ "np.set_printoptions(suppress=True,threshold=np.inf,formatter={'float_kind':'{:16.7f}'.format})\n"
			+ "tf.keras.backend.set_floatx('float64')\n";
	
	public  String toTensorflowString(Object in, String weightDefinition) {
    	String ret = libImports;
		ret += "model = keras.Sequential([\n" + this.toString() + "])\n";
		ret += weightDefinition;
		ret +="x = tf.constant("+ListHelper.printList(in)+")\n";
		if(!this.isNonDetLayer) {
			ret += "print (np.array2string(model.predict(x,steps=1), separator=', '))\n";
		}else {
			ret += "print (np.array2string(model(x,training=True).numpy(), separator=', '))\n";
		}
		return ret;
	}
	
	public  String toTensorflowString(Object in) {
		String weightStr = this.getWeightString(0);
		if(!weightStr.isEmpty()) {
			weightStr ="w = model.get_weights()\n" + 
					this.getWeightString(0)+
	    			"model.set_weights(w)\n";
		}
		return this.toTensorflowString(in,weightStr);
	}
	
	public  String toTensorflowStringMultipleInputs(Object in) {
		String ret = libImports;

		//String inpS = Arrays.toString(inputShape.toArray());
		String ins = "[";
		String ins1 = "";
		
		for(int i = 0; i < ((Object[])in).length;i++) {
			
			List<Integer> tempS = ListHelper.getShape(((Object[])in)[i]);

//			if(name.equals("Concatenate"))
//			{
				tempS.remove(0);
				ins1 += "input"+i+" = tf.constant("+ListHelper.printList(((Object[])in)[i])+")\n";
//			}
//			else {
//				ins1 += "input"+i+" = tf.constant(["+ListHelper.printList(((Object[])in)[i])+"])\n";
//			}
			String inpS = Arrays.toString(tempS.toArray());
			ret += "input"+i+" = tf.keras.layers.Input(shape=("+inpS+"))\n";
			ins += "input"+i+",";
		}
		ins = ins.substring(0,ins.length()-1)+"]";
		if(name != null) {
			ret += "func = keras.layers."+name.replace("_", "")+"("+this.parameterString()+")("+ins+")\n";	
		}
		else {
			ret += "func = keras.layers."+this.getClass().getSimpleName()+"("+this.parameterString()+")("+ins+")\n";	
		}
		ret += "model = tf.keras.models.Model(inputs="+ins+", outputs=func)\n";
		ret += ins1;
		ret += "print (np.array2string(model.predict("+ins+",steps=1), separator=', '))\n";
		return ret;
	}
	
	public  String toPrologString(Object in) {
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(par.length() > 0) {
			par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
		if(name != null) {
			return name.toLowerCase()+"_layer("+ListHelper.printList(in)+", "+par+"X)";
		}
		return this.getClass().getSimpleName().toLowerCase()+"_layer("+ListHelper.printList(in)+", "+par+"X)";
	}
	
	
	public  String toPrologString(Object in,Object out) {
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(par.length() > 0) {
			par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
		return name.toLowerCase().replaceAll("(\\d)[d]", "$1D")+"_layer("+ListHelper.printList(in)+", "+ListHelper.printList(out)+", "+par+"X)";
	}

	
	public  String toString(boolean noInputShape) {
		if(name != null && !name.isEmpty()) {
			return "keras.layers."+name.replace("_", "")+"("+this.parameterString()+")";
		}
		return this.getClass().getSimpleName()+"("+this.parameterString()+")";
	}
	

	
	public Object generateInput(Random r) {
		return ListHelper.genListandAddDefaultDim(r, this.getInputShape());
	}
	
	
	public ArrayList<Layer> getChildLayers() {
		return childLayers;
	}
	public void setChildLayers(ArrayList<Layer> childLayers) {
		this.childLayers = childLayers;
	}

	public Layer getParentLayer() {
		return parentLayer;
	}
	public void setParentLayer(Layer parentLayer) {
		this.parentLayer = parentLayer;
	}
	
	public void connectParent(Layer p)
	{
		this.setParentLayer(p);
		p.getChildLayers().add(this);
	}

	public String getUniqueName() {
		return uniqueName;
	}
	public void setUniqueName(String uniqueName) {
		this.uniqueName = uniqueName;
	}
	
	public void initUniqueName(Random r) {
		this.uniqueName = this.getName().substring(0,3) +r.nextInt(100000);
	}


	private ArrayList<Layer> childLayers = new ArrayList<>();
	private Layer parentLayer = null;
	
	public boolean isDescendant(Layer l) {
		if(this.childLayers.contains(l)) {
			return true;
		}
		else {
			for (Layer l1 : childLayers) {
				if(l1.isDescendant(l))
				{
					return true;
				}
			}
		}
		return false;
	}
	public boolean isAncestor(Layer l) {
		if(this.parentLayer == l)
		{
			return true;
		}
		else if(this.parentLayer == null) {
			return false;
		}
		return this.parentLayer.isAncestor(l);
	}
	
	protected String uniqueName = "";
	
	public abstract Layer copy();

}
