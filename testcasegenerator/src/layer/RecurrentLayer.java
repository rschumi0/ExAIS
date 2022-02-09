package layer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import util.ListHelper;

public class RecurrentLayer extends NodeLayer {
	
	Object recurrentWeights = null;
	

	public Object getRecurrentWeights() {
		return recurrentWeights;
	}
	public void setRecurrentWeights(Object recurrentWeights) {
		this.recurrentWeights = recurrentWeights;
	}


	public RecurrentLayer(String name, int nodeNumber, Object inputWeights, Object recurrentWeights, Object outputWeights, List<Integer> inputShape,
			LinkedHashMap<String, String> params) {
		super(nodeNumber, inputWeights, outputWeights, inputShape, params);
		this.name = name;
		this.recurrentWeights = recurrentWeights;
	}
	
	public RecurrentLayer(RecurrentLayer l) {
		super(l);
		this.name = l.name;
		this.recurrentWeights = l.recurrentWeights;
	}
	
	
	
	public 	String toString() {
		return this.toString(false);
	}
	
	public  String toString(boolean noInputShape) {
		String inputShapeStr = "";
		if(!noInputShape){
			String inpS = Arrays.toString(inputShape.toArray());
			inpS = inpS.substring(1,inpS.length()-1);
			inputShapeStr = " input_shape=("+inpS+")";
		}
		if(name.contains("Cell")) {
			String nameStr = ",";
			if(this.uniqueName != null && !this.uniqueName.isEmpty()){
				nameStr = ", name = '"+this.uniqueName+"',";
			}			
			String ret = "keras.layers."+name.replace("_", "")+"("+nodeNumber+","+this.parameterString(true)+ ")";
			ret = "keras.layers.RNN("+ret+nameStr+inputShapeStr+")";
			return ret;
		}
		else {
			return "keras.layers."+name.replace("_", "")+"("+nodeNumber+","+this.parameterString()+")";
		}

	}
	
	
	public String getWeightString(int index) {
		return "w["+(index++)+"] = np.array("+ ListHelper.printList(inputWeights) +")\n"+
    			((this.recurrentWeights == null) ?
    			"w["+(index++)+"] = np.array("+ ListHelper.printList(outputWeights) +")\n" 
    			:
    			"w["+(index++)+"] = np.array("+ ListHelper.printList(recurrentWeights)+")\n"+
    			"w["+(index++)+"] = np.array("+ ListHelper.printList(outputWeights) +")\n");
	}
	
	public String toPrologString(Object in) {
		String par = Arrays.toString(params.values().toArray());
		par = par.substring(1,par.length()-1);
		if(par.length() > 0) {
			par += ", ";
			par = par.replace("(", "").replace(")", "");
		}
		par = par.replace(" 'sigmoid',", "");
		par = par.replace("'sigmoid',", "");
		par = par.replace("False',", "false");
		par = par.replace("True',", "true");
		par = par.replace(",  ", ", ");
		if(par.length() <= 2) {
			par = "";
		}
		String W = ListHelper.printList(inputWeights)+"," + 
				   ListHelper.printList(recurrentWeights) +"," + 
				   ListHelper.printList(outputWeights);

		return name.toLowerCase().replaceAll("(\\d)[d]", "$1D")+"_layer("+ListHelper.printList(in)+","+W+", "+par+"X)";
	}

	
	public Object generateInput(Random r) {
		ArrayList<Integer> tmpS = new ArrayList<>(this.inputShape);
		tmpS.add(0,1);
		return ListHelper.genList(r, "int", tmpS,1,10);
	}
	
	@Override
	public Layer copy() {
		return new RecurrentLayer(this);
	}
}
