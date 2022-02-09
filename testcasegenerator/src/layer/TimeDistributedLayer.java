package layer;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;

import util.ListHelper;

public class TimeDistributedLayer extends Layer {
	
	private Layer layer;

	public TimeDistributedLayer(String name, List<Integer> inputShape, Layer layer, LinkedHashMap<String, String> params) {
		super(name, inputShape, params);
		this.setLayer(layer);
	}
	
	
	public TimeDistributedLayer(TimeDistributedLayer l) {
		super(l);
		this.layer = l.layer;
	}
	
	public  String toPrologString(Object in) {
		if(!this.getChildLayers().isEmpty())
		{
			this.layer = this.getChildLayers().get(0);
		}
		String str = this.layer.toPrologString("#REPLACE#");
		
		String input = "";
		if(in instanceof String )
		{
			input = (String)in;
		}
		else {
			input = ListHelper.printList(in);
		}
		
		return name.toLowerCase()+"_layer("+ input + ", "+ str.replaceFirst("\\(#REPLACE#", "");
	}


	protected Layer getLayer() {
		return layer;
	}


	protected void setLayer(Layer layer) {
		this.layer = layer;
	}
	
	public  String toString() {
		if(!this.getChildLayers().isEmpty())
		{
			this.layer = this.getChildLayers().get(0);
		}
		String inpS = Arrays.toString(inputShape.toArray());
		inpS = inpS.substring(1,inpS.length()-1);
		return "keras.layers."+name.replace("_", "")+"("+ this.layer.toString(true) +", input_shape=("+inpS+"))";
	}
	
	public  String toString(boolean noInputShape) {
		if(!this.getChildLayers().isEmpty())
		{
			this.layer = this.getChildLayers().get(0);
		}
		if(noInputShape) {
			return "keras.layers."+name.replace("_", "")+"("+ this.layer.toString(noInputShape) +")";
		}
		return this.toString();
	}
	
	public String getWeightString(int index) {
		return this.layer.getWeightString(index);
	}


	@Override
	public Layer copy() {
		return new TimeDistributedLayer(this);
	}
	
}
