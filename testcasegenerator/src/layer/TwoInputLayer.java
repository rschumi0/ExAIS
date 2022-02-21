package layer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import util.ListHelper;

public class TwoInputLayer extends MultiInputLayer {

	public TwoInputLayer(String name, List<Integer> inputShape, LinkedHashMap<String, String> params) {
		super(name, inputShape, params);
	}
	
	public TwoInputLayer(TwoInputLayer l) {
		super(l);
	}
	
	@Override
	public  String toPrologString(Object in) {
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(par.length() > 0) {
			par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
		String in1 = "";
		if(in instanceof String) {
			if(((String)in).length() >2) {
				in1 = ((String)in).substring(1, ((String)in).length()-1);
			}
		}
		else {
			in1 = ListHelper.printList(((Object[])in)[0])+", "+ListHelper.printList(((Object[])in)[1]);
		}
		return name.toLowerCase()+"_layer("+in1+", "+par+"X)";
	}
	
	@Override
	public Object generateInput(Random r) {
		ArrayList<Integer> tempShape = new ArrayList<>(this.getInputShape());
		tempShape.add(0,2);
		tempShape.add(1, 1);//r.nextInt(2)+1);
    	return ListHelper.genList(r, tempShape);
	}

	@Override
	public Layer copy() {
		return new TwoInputLayer(this);
	}
}
