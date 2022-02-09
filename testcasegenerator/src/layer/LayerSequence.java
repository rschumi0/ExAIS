package layer;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.regex.Pattern;

import gen.Gen;
import util.ListHelper;
import util.ScriptProlog;

public class LayerSequence extends Layer {

	ArrayList<Layer> layers = null;
	
	public LayerSequence() {
		this.layers = new ArrayList<>();
	}
	
	public LayerSequence(ArrayList<Layer> layers) {
		this.layers = layers;
	}
	
	public LayerSequence(LayerSequence l) {
		this.layers = new ArrayList<>();
		for (Layer l1: l.layers) {
			layers.add(l1.copy());
		}
	}
	
	public ArrayList<Layer> getLayers() {
		return layers;
	}
	public void setLayers(ArrayList<Layer> layers) {
		this.layers = layers;
	}
	
	public  String toTensorflowString(Object in) {	
		String ret = layers.get(0).toTensorflowString(in);
		
		int weightIndex = countStringMatches(ret, "np.array(");
		for (int i = 1; i < layers.size();i++) {
			ret = ret.replaceFirst("]", ",\n"+layers.get(i).toString(true)+"]");
			String weightString = layers.get(i).getWeightString(weightIndex);
			if(!weightString.isEmpty())
			{
				if(weightIndex == 0) {
					String insert = "w = model.get_weights()\n" + 
							weightString+
			    			"model.set_weights(w)\n";
					ret = ret.replaceFirst("x = tf.constant", insert+"x = tf.constant");
				}
				else {
					ret = ret.replaceFirst("model.set_weights", weightString+"model.set_weights");
				}
				weightIndex += countStringMatches(weightString, "np.array(");
			}
		}
		return ret;
	}
	
	public String toPrologString(Object in) {
		String ret = layers.get(0).toPrologString(in).replace(", X",", A");
		char resLetter ='B';
		char lastResLetter = 'A';
		for (int i = 1; i < layers.size();i++) {
			ret = ret + ", \n"+ layers.get(i).toPrologString((lastResLetter+"")).replace(", X",", "+resLetter);
			lastResLetter = resLetter;
			resLetter++;
		}
		return ret;
	}
	
	public Object generateInput(Random r) {
		return layers.get(0).generateInput(r);
	}
	
	public void generateSequence(Random rand, Map<String,Gen> layerGenMap, int length) {

		List<String> layerNames = new ArrayList<>(layerGenMap.keySet());
		Layer currLayer = null;
    	List<Integer> shape = null;
		
		for(int i = 1;i< length;i++) {
		    String layer = layerNames.get(rand.nextInt(layerNames.size()));
		    currLayer= layerGenMap.get(layer).generateLayer(rand, layer, shape, null);
		    if(currLayer == null) {
		    	i--;
		    	continue;
		    }
		    
			Object in = currLayer.generateInput(rand);
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(currLayer.toPrologString(in));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	try {
		    	String expected = ScriptProlog.runScript(currLayer.toPrologString(in)).trim();
		    	System.out.println();
				System.out.println("Expected (Unparsed): " + expected);
				if(expected.contains("error") || expected.contains("invalid") || !expected.contains("[") || !expected.contains("]")){
			    	i--;
			    	continue;
				}
		    	Object e = ListHelper.parseList(expected);
		    	
		    	shape = ListHelper.getShape(e);
		    	
		    	shape.remove(0);
	    	}
	    	catch(Exception e) {
		    	i--;
		    	continue;
	    	}
		    layers.add(currLayer);
		}
		
	}
	
	private int countStringMatches(String str,String findStr) {
		int lastIndex = 0;
		int count = 0;

		while(lastIndex != -1){

		    lastIndex = str.indexOf(findStr,lastIndex);

		    if(lastIndex != -1){
		        count ++;
		        lastIndex += findStr.length();
		    }
		}
		return count;
	}

	@Override
	public Layer copy() {
		return new LayerSequence(this);
	}
}
