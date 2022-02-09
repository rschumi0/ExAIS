package gen;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.Layer;
import layer.RecurrentLayer;
import util.ListHelper;

public class RecurrentGen extends Gen {

	public Layer generateLayer(Random rand, String name, List<Integer> inputShape, LinkedHashMap<String, Object> config) {
		
		int dimensions;
		if(inputShape != null) {
			dimensions = inputShape.size(); 
			int expectedDim = name.startsWith("Simple_RNN")? 2 : name.startsWith("GRU") ? 2 : 2;
			if(dimensions != expectedDim) {
				return null;
			}
		}
		else {
			dimensions = name.startsWith("Simple_RNN")? 2 : name.startsWith("GRU") ? 2 : 2;
			
			inputShape = new ArrayList<>();//Arrays.asList(3,3));
			for(int i = 0; i < dimensions; i++) {
				inputShape.add(rand.nextInt(3)+1);
			}
		}

		
		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		int nodeNumber = rand.nextInt(3)+1;
	
		
		ArrayList<Integer> inWS = null;
		ArrayList<Integer> recurrentWS = null;
		ArrayList<Integer> outWS = null;
		if(name.startsWith("Simple_RNN")) {
			inWS = new ArrayList<>();
			inWS.add(inputShape.get(dimensions-1));
			inWS.add(nodeNumber);
			
			recurrentWS = new ArrayList<>();
			recurrentWS.add(nodeNumber);
			recurrentWS.add(nodeNumber);
			
			outWS = new ArrayList<>();
			outWS.add(nodeNumber);
		}
		else if(name.startsWith("GRU")) {
			inWS = new ArrayList<>();
			inWS.add(inputShape.get(dimensions-1));
			inWS.add(nodeNumber*3);
			
			recurrentWS = new ArrayList<>();
			recurrentWS.add(nodeNumber);
			recurrentWS.add(nodeNumber*3);
			
			boolean reset_after = rand.nextBoolean();
			if(reset_after) {
				outWS = new ArrayList<>();
				outWS.add(2);
				outWS.add(nodeNumber*3);
			}else {
				outWS = new ArrayList<>();
				outWS.add(nodeNumber*3);
			}
			
			
			params.put("reset_after",reset_after+"");//"False");
			params.put("recurrent_activation", "'sigmoid'");
		}
		else if(name.startsWith("LSTM")) {
			inWS = new ArrayList<>();
			inWS.add(inputShape.get(dimensions-1));
			inWS.add(nodeNumber*4);
			
			recurrentWS = new ArrayList<>();
			recurrentWS.add(nodeNumber);
			recurrentWS.add(nodeNumber*4);
			
			outWS = new ArrayList<>();
			//outWS.add(2);
			outWS.add(nodeNumber*4);
			params.put("recurrent_activation", "'sigmoid'");
		}

		Object inputWeights = ListHelper.genList(rand, "int", inWS, 1,10);//(rand, inWS, 1,10);
		Object recurrentWeights = ListHelper.genList(rand, "int", recurrentWS, 1,10);//(rand, recurrentWS);
		Object outputWeights = ListHelper.genList(rand, "int", outWS, 1,10);//(rand, outWS);

		return new RecurrentLayer(name,nodeNumber,inputWeights,recurrentWeights,outputWeights,inputShape,params);
	}
}
