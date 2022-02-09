package layer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import gen.GraphGen;
import util.GenUtils;
import util.ListHelper;
import util.ModelError;
import util.ScriptProlog;

public class LayerGraph extends Layer {

	private Layer root = null;
	Map<String, Layer> graphLayerMap = null;
	Map<String,Object> lastInput = null;
	private Layer lastModel = null;
	public static boolean ShowDebugInfo = true;
	
	
	public LayerGraph(Layer layer) {
		this.name = "Graph";
		this.setRoot(layer);
		buildGraphLayerMap(this.root);
	}
	
	public LayerGraph(LayerGraph l) {
		//super(l);
		this.name = l.name;
		this.root = l.root.copy();
		buildGraphLayerMap(this.root);
	}
	
	private void buildGraphLayerMap(Layer l) {
		graphLayerMap = new HashMap<String, Layer>();
		recursiveBuildMap(l);
	}
	private void recursiveBuildMap(Layer l) {
		graphLayerMap.put(l.getUniqueName(),l);
		if(l.getChildLayers() != null) {
			for (Layer l1 : l.getChildLayers()) {
				recursiveBuildMap(l1);
			}
		}
	}
	
	public String toTensorflowString(Object in) {	
		String ret = libImports;
		ArrayList<String> inputDef = new ArrayList<>();
		ArrayList<String> inputs= new ArrayList<>();
		ArrayList<String> inputSet= new ArrayList<>();
		
		String layers = recursiveTensorflowString(getRoot(),(Map<String,Object>)in, inputDef,inputs,inputSet);
		String ins="[";
		String inSet ="";
		for(int i = 0; i < inputDef.size();i++) {
			ret += inputDef.get(i);
			ins+= inputs.get(i)+",";
			inSet+=inputSet.get(i);
		}
		ins = ins.substring(0,ins.length()-1)+"]";
		ret += "\n"+ layers;
		
		ret += "model = tf.keras.models.Model(inputs="+ins+", outputs="+getRoot().getUniqueName()+")\n";
		
//		ArrayList<String> weightStrings = new ArrayList<>();
//		recursiveWeightString(getRoot(),weightStrings);
//		String weightStr ="w = model.get_weights()\n";
//		for (String w : weightStrings) {
//			weightStr += w +"\n";
//		}
//		weightStr += "model.set_weights(w)\n";
		String weightStr = recursiveWeightString(getRoot());
		
		ret += weightStr;
		ret += inSet;
		ret += "print (np.array2string(model.predict("+ins+",steps=1), separator=', '))\n";
//		ret += "from tensorflow.keras.utils import plot_model\n" + 
//				"plot_model(model, to_file='"+root.getUniqueName()+".png')";
		return ret;
	}
	
	public String recursiveTensorflowString(Layer l, Map<String,Object> in, ArrayList<String> inputDef, ArrayList<String> inputs, ArrayList<String> inputSet) {
		boolean noInputShape = l.getChildLayers().size() > 0;
		String ret = "";
		String ins = "";
		if(!l.getChildLayers().isEmpty()) {
			ins += "";
			for(Layer l1: l.getChildLayers()) {
				ret += recursiveTensorflowString(l1, in,inputDef,inputs,inputSet);
				ins += l1.getUniqueName()+",";
			}
			ins = ins.substring(0,ins.length()-1);
			if(l.getChildLayers().size()>1) {
				ins = "(["+ins+"])";
			}
			else {
				ins = "("+ins+")";
			}
		}
		if(!(l.getParentLayer() instanceof TimeDistributedLayer)) {
			ret += l.getUniqueName() + " = " +l.toString(noInputShape);
		}
		
		if(in.containsKey(l.getUniqueName())) {
			if(l instanceof MultiInputLayer || l instanceof TwoInputLayer) {
				if(!ins.isEmpty())
				{
					String input = "in0"+l.getUniqueName();
					inputs.add(input);
					inputDef.add(input+" = tf.keras.layers.Input(shape=("+l.getInputShape()+"))\n");
					if(ins.contains("["))
					{
						ins = ins.replace("]", ","+input+"]");
					}
					else {
						ins = ins.replace("(", "([").replace(")", ","+input+"])");
					}
					inputSet.add(input+" = tf.constant("+ListHelper.printList(in.get(l.getUniqueName()))+")\n");
				}
				else {
					ins += "([";
					for(int i = 0; i < ((Object[])in.get(l.getUniqueName())).length;i++) {
						String input = "in"+i+l.getUniqueName();
						inputs.add(input);
						inputDef.add(input+" = tf.keras.layers.Input(shape=("+l.getInputShape()+"))\n");
						ins += input+",";
//						if(l.getName().equals("Concatenate")) {
							inputSet.add(input+" = tf.constant("+ListHelper.printList(((Object[])in.get(l.getUniqueName()))[i])+")\n");
//						}
//						else {
//							inputSet.add(input+" = tf.constant(["+ListHelper.printList(((Object[])in.get(l.getUniqueName()))[i])+"])\n");
//						}
					}
					ins = ins.substring(0,ins.length()-1)+"])";
				}
			}
			else {
				String input = "in0"+l.getUniqueName();
				inputs.add(input);
				inputDef.add(input+" = tf.keras.layers.Input(shape=("+l.getInputShape()+"))\n");
				//inputSet.add(input+" = tf.constant(["+ListHelper.printList(((Object)in.get(l.getUniqueName())))+"])\n");
				inputSet.add(input+" = tf.constant("+ListHelper.printList(((Object)in.get(l.getUniqueName())))+")\n");
				ins += "("+input+")";
			}	
		}
		ret += ins + "\n";
		
		return ret;
	}
//	public void recursiveWeightStringOld(Layer l,ArrayList<String> weightStrings) {
//		if(l.getChildLayers() != null) {
//			for(Layer l1: l.getChildLayers()) {
//				recursiveWeightStringOld(l1, weightStrings);
//			}
//		}
//		String w = l.getWeightString(weightStrings.size());
//		if(!w.isEmpty()) {
//			String lines[] = w.split("\\r?\\n");
//			for (String line : lines) {
//				if(!line.trim().isEmpty()) {
//					weightStrings.add(line.trim());
//				}
//			}
//			
//		}
//	}
	
	public String recursiveWeightString(Layer l) {
		String ret = "";
		if(l.getChildLayers() != null) {
			for(Layer l1: l.getChildLayers()) {
				ret += recursiveWeightString(l1);
			}
		}
		String w = l.getWeightString(0);
		if(!w.isEmpty()) {
			w = "w = model.get_layer('"+l.getUniqueName()+"').get_weights() \n"+ w +
				"model.get_layer('"+l.getUniqueName()+"').set_weights(w) \n";
		}
		return ret + w;
	}
	
	public String toPrologString(Object in) {
		ArrayList<String> layerNames = new ArrayList<>();
		String ret = recursivePrologString(getRoot(), (Map<String,Object>)in,layerNames);
		String layers = "";
		String layerNs = "";
		for (String l : layerNames) {
			layers += l+",";
			layerNs += "\""+l.substring(1)+"\",";
		}
		layers = layers.substring(0,layers.length() -1 );
		layerNs = layerNs.substring(0,layerNs.length() - 1);
		ret += ", \n";
		ret += "exec_layers(["+layers+"],["+layerNs+"],"+getRoot().getUniqueName()+",\""+getRoot().getUniqueName()+"\")";
		return ret;
	}
	
	public void printPrologString(Object in) {
		ArrayList<String> layerNames = new ArrayList<>();
		printrecursivePrologString(getRoot(), (Map<String,Object>)in,layerNames);
		String ret = "";
		String layers = "";
		String layerNs = "";
		for (String l : layerNames) {
			layers += l+",";
			layerNs += "\""+l.substring(1)+"\",";
		}
		layers = layers.substring(0,layers.length() -1 );
		layerNs = layerNs.substring(0,layerNs.length() - 1);
		ret += ", \n";
		ret += "exec_layers(["+layers+"],["+layerNs+"],"+getRoot().getUniqueName()+",\""+getRoot().getUniqueName()+"\")";
		System.out.println(ret);
		//return ret;
	}
	
	public void printrecursivePrologString(Layer l,Map<String,Object> in,ArrayList<String> layers) {
		Object in1 = null;
		boolean mutliInput =false;
		//String ret = "";
		if(l.getChildLayers() != null) {
			for (Layer l1 : l.getChildLayers()) {
				printrecursivePrologString(l1,in,layers);
			}
		}

		if(l.getChildLayers().size() > 1)
		{
			String inT ="[";
			for (Layer l1 : l.getChildLayers()) {
				inT += l1.getUniqueName() + ",";
			}
			in1 = (inT.substring(0, inT.length()-1)+"]");
			mutliInput = true;
		}
		else if(l.getChildLayers().size() == 1) {
			if(l.getChildLayers().isEmpty()) {
				if(ShowDebugInfo) {System.out.println(l.getName() + l.getUniqueName());}
			}
			in1 = l.getChildLayers().get(0).getUniqueName();
		}
		
		if(in.containsKey(l.getUniqueName()))
		{
			Object in2 = in.get(l.getUniqueName());
			if(in1 != null) {
				if(mutliInput) {
					in1 = ((String)in1).substring(0, ((String)in1).length()-1)+ ","+ListHelper.printList(in2)+"]";
				}
				else {
					in1 = "[" + in1 +"," + ListHelper.printList(in2)+"]";
				}
				mutliInput = true;
			}
			else {
				in1 = in2;
			}
		}
		//}
		String name = l.getUniqueName();//mutliInput && !l.getName().equals("Concatenate") ? "["+l.getUniqueName()+"]" : l.getUniqueName();
		
		if(!(l.getParentLayer() instanceof TimeDistributedLayer)) {
			if(l.isModified || l.isNewlyAdded) {
				System.err.println("L"+l.getUniqueName()+ " = "+ l.toPrologString(in1).replace(", X",", " + name));
			}
			else 
			{
				System.out.println("L"+l.getUniqueName()+ " = "+ l.toPrologString(in1).replace(", X",", " + name));
			}
			//layers.add(0,"L"+l.getUniqueName());
			layers.add("L"+l.getUniqueName());
		}
		//return ret;
	}
	
	public String recursivePrologString(Layer l,Map<String,Object> in,ArrayList<String> layers) {
		Object in1 = null;
		boolean mutliInput =false;
		String ret = "";
		if(l.getChildLayers() != null) {
			for (Layer l1 : l.getChildLayers()) {
				ret += recursivePrologString(l1,in,layers) + ", \n";
			}
		}

		if(l.getChildLayers().size() > 1)
		{
			String inT ="[";
			for (Layer l1 : l.getChildLayers()) {
				inT += l1.getUniqueName() + ",";
			}
			in1 = (inT.substring(0, inT.length()-1)+"]");
			mutliInput = true;
		}
		else if(l.getChildLayers().size() == 1) {
			if(l.getChildLayers().isEmpty()) {
				if(ShowDebugInfo) {System.out.println(l.getName() + l.getUniqueName());}
			}
			in1 = l.getChildLayers().get(0).getUniqueName();
		}
		
		if(in.containsKey(l.getUniqueName()))
		{
			Object in2 = in.get(l.getUniqueName());
			if(in1 != null) {
				if(mutliInput) {
					in1 = ((String)in1).substring(0, ((String)in1).length()-1)+ ","+ListHelper.printList(in2)+"]";
				}
				else {
					in1 = "[" + in1 +"," + ListHelper.printList(in2)+"]";
				}
				mutliInput = true;
			}
			else {
				in1 = in2;
			}
		}
		//}
		String name = l.getUniqueName();//mutliInput && !l.getName().equals("Concatenate") ? "["+l.getUniqueName()+"]" : l.getUniqueName();
		
		if(!(l.getParentLayer() instanceof TimeDistributedLayer)) {
			ret += "L"+l.getUniqueName()+ " = "+ l.toPrologString(in1).replace(", X",", " + name);
			//layers.add(0,"L"+l.getUniqueName());
			layers.add("L"+l.getUniqueName());
		}
		return ret;
	}
	
	
	public String recursivePrologStringOld(Layer l,Map<String,Object> in) {
		Object in1 = null;
		boolean hasChildNodes =false;
		if(in.containsKey(l.getUniqueName()))
		{
			in1 = in.get(l.getUniqueName());
		}
		else {
			if(l.getChildLayers().size() > 1)
			{
				String inT ="[";
				for (Layer l1 : l.getChildLayers()) {
					inT += l1.getUniqueName() + ",";
				}
				in1 = (inT.substring(0, inT.length()-1)+"]");
				hasChildNodes = true;
			}
			else {
				in1 = l.getChildLayers().get(0).getUniqueName();
			}
		}
		String name = hasChildNodes ? "["+l.getUniqueName()+"]" : l.getUniqueName();
		String ret = l.toPrologString(in1).replace(", X",", " + name);
		for (Layer l1 : l.getChildLayers()) {
			
			ret = recursivePrologStringOld(l1,in) + ", \n"+ ret;
		}
		
		return ret;
	}
	
	public Object generateInput(Random r) {
		if(lastInput != null) {
			return lastInput;
		}
		lastInput = findLeafInputs(r,getRoot(),new HashMap<String, Object>());
		return lastInput;
	}
	
	public void resetInputs(List<Integer> inputShape) {
		lastInput = null;
		findandUpateLeafInputs(getRoot(), inputShape);
	}
	private void findandUpateLeafInputs(Layer l,List<Integer> inputShape) {
		if(!l.getChildLayers().isEmpty()){
			for (Layer l1 : l.getChildLayers()) {
				findandUpateLeafInputs(l1, inputShape);
			}
		}
		else {
			l.inputShape = inputShape;
		}

	}
	
	public Map<String, Object> findLeafInputs(Random r, Layer l, Map<String, Object> in ){ 
		if(l instanceof MultiInputLayer && ((MultiInputLayer)l).getFixedInput() != null)
		{
			in.put(l.getUniqueName(), ((MultiInputLayer)l).getFixedInput());
		}
		
		if(l.getChildLayers() == null || l.getChildLayers().isEmpty())
		{
			in.put(l.getUniqueName(), l.generateInput(r));
		}
		else {
			for (Layer l1 : l.getChildLayers()) {
				in = findLeafInputs(r, l1, in);
			}
		}
		return in;
	}
	
	public String getUniqueName() {
		return this.getRoot().getUniqueName();
	}
	
	public void validateGraph(Random rand) {
		this.validateGraph(rand, 30);
	}
	public void validateGraph(Random rand, int maxFixTries) {
		
		int maxTries = 2; //TODO change back to 50, 30
		for(int i = 1;i< maxTries;i++) {
			Map<String,ModelError> errors = new HashMap<>();
			Object in = this.generateInput(rand);
			if(ShowDebugInfo) {
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script for Model " + root.getUniqueName());
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(this.toPrologString(in));
	    	System.out.println("-------------------------------------------------------------------------------------");}
	    	try {
	    		if(ShowDebugInfo) {
				System.out.println("########################################################################################");
				System.out.println("Testing model: " + root.getUniqueName() +" TryIndex: "+i);
				System.out.println("########################################################################################");}
		    	String expected = ScriptProlog.runScript(
		    			this.toPrologString(in),
		    			this.root.getUniqueName(),errors);
		    	if(ShowDebugInfo) {
		    	System.out.println();
				System.out.println("Expected (Unparsed): " + expected);
		    	}
				boolean succFix = true;
				if(!errors.isEmpty())
				{
					if(ShowDebugInfo) {
					System.out.println("########################################################################################");
					System.out.println("Trying to fix model! " + root.getUniqueName());
					System.out.println("########################################################################################");}
					succFix = tryfixGraph(rand, errors,maxFixTries);
					if(succFix) {
						if(ShowDebugInfo) {
						System.out.println("########################################################################################");
						System.out.println("Graph model validation successful! " + root.getUniqueName());
						System.out.println("########################################################################################");}
						return;
					}
				}
				if(!succFix || expected == "" || expected.contains("error") || expected.contains("invalid") || !expected.contains("[") || !expected.contains("]") || expected.trim().endsWith("false.")){
			    	//i--;
					if(true) {//ShowDebugInfo) {
					System.out.println("########################################################################################");
					System.out.println("Unfixable Model! ");
					if(!errors.isEmpty())
					{
						System.out.println("Error: ");
						ModelError errrrr = errors.get(errors.keySet().toArray()[0]);
						System.out.println(errrrr.toString());
					}
					System.out.println("########################################################################################");
					System.out.println("Regenerate model! " + root.getUniqueName());
					System.out.println("########################################################################################");}
					GenUtils.regenerationCounter++;
					this.root = new GraphGen().recursiveGeneration(rand,0,null);
		    		buildGraphLayerMap(this.root);
		    		lastInput = null;
			    	continue;
				}
				else {
					if(ShowDebugInfo) {
					System.out.println("########################################################################################");
					System.out.println("Graph model validation successful! " + root.getUniqueName());
					System.out.println("########################################################################################");}
					return;
				}
	    	}
	    	catch(Exception e) {
				throw e;
	    	}
		}
	}
	
	
	public boolean tryfixGraph(Random r, Map<String,ModelError> errors, int maxFixTries) {
		lastModel = this.root.copy();
		Map<String,Object> lastlastInput = new HashMap<>(lastInput);
		Map<String,ModelError> lastErrors = new HashMap<>(errors);
		for(int i = 0; i < maxFixTries; i++) {
			GenUtils.totalFixIterations++;
			for (String location : errors.keySet()) {
				ModelError e = errors.get(location);
				Layer l = graphLayerMap.get(location);
				if(ShowDebugInfo) {
				System.out.println("########################################################################################");
				System.out.println("TryFix " + location + " -- " + e.toString() + " FixTry: "+i +" #Es "+errors.size());
				System.out.println("########################################################################################");}
				
				if(l == null) {
					if(ShowDebugInfo) {
					System.out.println("########################################################################################");
					System.out.println("Layer " + location + "not found for " + e.toString());
					System.out.println("########################################################################################");}
				}
				if(e.getMessage().startsWith("Dimension error") || e.getMessage().startsWith("Inconsistent Input Dimensions")) {
					List<Integer> newShape = null;
//					String tempShape = e.getMessage().split(", Input Shape")[1].trim();
//					tempShape = tempShape.replace("[", "").replace("]", "");
//					List<Integer> shape = new ArrayList<>();
//					String[] tempShapeParts = tempShape.split(",");
//					for (int i1 = 0; i1 < tempShapeParts.length; i1++) {
//						shape.add(Integer.parseInt(tempShapeParts[i1]));
//					}
//					shape.remove(0);
					List<Integer> shape = e.getInputShape();
//					if(!(l.getChildLayers().size() == 1 && l.getChildLayers().get(0).getName().contains("Global"))){
//						shape.remove(0);
//					}
//					else {
//						boolean globalChild = false;
//						for (Layer l1 : l.getChildLayers()) {
//							if(l1.getName().contains("Global")) {
//								globalChild = true;
//								break;
//							}
//						}
//						if(globalChild) {
//							if(r.nextBoolean()) {
//								shape.remove(0);
//							}
//						}
//						else {
//							shape.remove(0);
//						}
//					}
					
//					
//					List<String> options = null;
//					if(e.get() < 0) {
//		
//						options = Arrays.asList("Reshape");//, "Reshape");///"Repeat_Vector", 
//					}
//					else {
//						options = Arrays.asList("Global_Average_Pooling1D", "Global_Average_Pooling2D", "Global_Average_Pooling3D");//, "Reshape");
//					}
					Layer newLayer = null;
					if(e.getBadness() < 0) {
						newLayer = GenUtils.genLayer(r,"Reshape");
						newLayer.setInputShape(shape);
						newShape = new ArrayList<>(shape);
						newShape.add(1);
						String size = ListHelper.printList(newShape.toArray());
						size = size.replace("[", "(").replace("]", ")");
						
						newLayer.getParams().put("Reshape_Sizes",size);
					}
					else if(shape.size() >= 2){
						newLayer = GenUtils.genLayer(r,"Reshape");
						newLayer.setInputShape(shape);
						newShape = new ArrayList<>(shape);
						int lastD =newShape.get(newShape.size()-1);
						int secondlastD =newShape.get(newShape.size()-2);
						int newD = lastD*secondlastD;
						newShape.remove(newShape.size()-1);
						newShape.remove(newShape.size()-1);
						newShape.add(newD);
						if(newShape.size() == 1) {
							newLayer = GenUtils.genLayer(r,"Flatten");
							newLayer.setInputShape(shape);
						}
						else {
							String size = ListHelper.printList(newShape.toArray());
							size = size.replace("[", "(").replace("]", ")");
							newLayer.getParams().put("Reshape_Sizes",size);
						}
//						if(shape.size() >= 4) {
//							newLayer = GenUtils.genLayer(r,"Global_Average_Pooling3D");
//						}
//						else if(shape.size() >= 3) {
//							newLayer = GenUtils.genLayer(r,"Global_Average_Pooling2D");
//						}
//						else {
//							newLayer = GenUtils.genLayer(r,"Global_Average_Pooling1D");
//						}
					}
					else {
						newLayer = GenUtils.genLayer(r,"Flatten");
						newLayer.setInputShape(shape);
					}
					insertLayerBefore(r,l,newLayer);
					regenerateLayerArgs(r, newLayer.getParentLayer(), newShape);
//					if(r.nextBoolean() && e.getBadness() > 0) {
//						insertLayerBefore(r,l,Arrays.asList("Repeat_Vector"));
//					}
					
//					if(r.nextInt(10)>3) {
//						
//						insertLayerBefore(r,l,newLayer);
//						if(r.nextBoolean() && e.getBadness() > 0) {
//							insertLayerBefore(r,l,Arrays.asList("Repeat_Vector"));
//						}
//					}
//					else if(r.nextInt(10)>5) {
//						if(r.nextBoolean()  && !l.getChildLayers().isEmpty()){
//							Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
//							replaceLayer(r, l1, new ArrayList<>());
//						}
//						else {
//							replaceLayer(r, l, new ArrayList<>());
//						}	
//					}
//					else if(r.nextInt(10)>7)
//					{
//						if(r.nextBoolean() && !l.getChildLayers().isEmpty()){
//							Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
//							removeLayer(r, l1);
//						}
//						else {
//							removeLayer(r, l);
//						}
//					}
//					else {
//						if(r.nextBoolean() && !l.getChildLayers().isEmpty()){
//							Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
//							regenerateLayerArgs(r,l1);
//						}
//						else {
//							regenerateLayerArgs(r,l);
//						}
//					}
				}
				else if(e.getMessage().startsWith("Inconsistent Input Shapes")) {
					fixInconsistenInputShapes(r, l, e,false,false);
					
//					if(r.nextInt(10)>3) {
//						insertLayerBefore(r,l,options);
//					}
//					else if(r.nextInt(10)>5) {
//						
//						if(r.nextBoolean() && !l.getChildLayers().isEmpty()){
//							Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
//							replaceLayer(r, l1, options);
//						}
//						else {
//							replaceLayer(r, l, new ArrayList<>());
//						}
//						
//					}
//					else if(r.nextInt(10)>7) {
//						if(r.nextBoolean() && !l.getChildLayers().isEmpty()){
//							Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
//							removeLayer(r, l1);
//						}
//						else {
//							removeLayer(r, l);
//						}
//					}
//					else {
//						if(r.nextBoolean() && !l.getChildLayers().isEmpty()){
//							Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
//							regenerateLayerArgs(r,l1);
//						}
//						else {
//							regenerateLayerArgs(r,l);
//						}
//					}
					
				}
				else if(e.getMessage().startsWith("Pool Shape Error"))
				{
					fixPoolShapeError(r, l, e);
				}
				else if(e.getMessage().startsWith("Argument Error") || e.getMessage().startsWith("Cropping Error")) {
//					String tempShape = e.getMessage().split(", Input Shape")[1].trim();
//					//System.out.println(tempShape);
//					tempShape = tempShape.replace("[", "").replace("]", "");
//					if(ShowDebugInfo) {System.out.println(tempShape);}
//					List<Integer> shape = new ArrayList<>();
//					String[] tempShapeParts = tempShape.split(",");
//					for (int i1 = 0; i1 < tempShapeParts.length; i1++) {
//						shape.add(Integer.parseInt(tempShapeParts[i1]));
//					}
					List<Integer> shape = e.getInputShape(false);
					
					if(!(l.getChildLayers().size() == 1 && l.getChildLayers().get(0).getName().contains("Global"))){
						shape.remove(0);
					}
					else {
						boolean globalChild = false;
						for (Layer l1 : l.getChildLayers()) {
							if(l1.getName().contains("Global")) {
								globalChild = true;
								break;
							}
						}
						if(globalChild) {
							if(r.nextBoolean()) {
								shape.remove(0);
							}
						}
						else {
							shape.remove(0);
						}
					}
					l.setInputShape(shape);
					regenerateLayerArgs(r,l,shape);
				}
				else if(e.getMessage().startsWith("Dot Axis Error")){
//					String tempShape = e.getMessage().split(", Input Shape")[1].trim();
//					//System.out.println(tempShape);
//					tempShape = tempShape.replace("[", "").replace("]", "");
//					if(ShowDebugInfo) {System.out.println(tempShape);}
//					List<Integer> shape = new ArrayList<>();
//					String[] tempShapeParts = tempShape.split(",");
//					
//					for (int i1 = 0; i1 < tempShapeParts.length; i1++) {
//						shape.add(Integer.parseInt(tempShapeParts[i1]));
//					}
//					shape.remove(0);
					List<Integer> shape = e.getInputShape();
					if(e.getBadness() == 99999){
						regenerateLayerArgs(r,l,shape);
					}
					else if(r.nextInt(10)>3) {
//						useSameLastChild = true;
//						tempLastChild = 0;
						fixInconsistenInputShapes(r,l,e,true,true);
						//fixShapeError(r,l,e);
//						useSameLastChild = false;
					}		
					else {
						if(r.nextBoolean()) {
							regenerateLayerArgs(r,l,shape);
						}
						else {
							if(r.nextBoolean() && !l.getChildLayers().isEmpty()){
								Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
								replaceLayer(r, l1, new ArrayList<>());
							}
							else {
								replaceLayer(r, l, new ArrayList<>());
							}
						}
					}
				}
				else {	
					if(r.nextInt(10)>3) {
						if(r.nextBoolean() && !l.getChildLayers().isEmpty()) {
							Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
							regenerateLayerArgs(r,l1,null);
						}
						else {
							regenerateLayerArgs(r,l,null);
						}
					}
					else {
						if(r.nextBoolean() && !l.getChildLayers().isEmpty()){
							Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
							replaceLayer(r, l1, new ArrayList<>());
						}
						else {
							replaceLayer(r, l, new ArrayList<>());
						}
					}
				}
			}
			
			Object in = this.generateInput(r);
			if(ShowDebugInfo) {
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script for Model " + this.root.getUniqueName());
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(this.toPrologString(in));
	    	System.out.println("-------------------------------------------------------------------------------------");
			System.out.println("########################################################################################");
			System.out.println("Testing model: " + root.getUniqueName());
			System.out.println("########################################################################################");}
			errors = new HashMap<String, ModelError>();
	    	String expected = ScriptProlog.runScript(
	    			this.toPrologString(in),
	    			this.getUniqueName(),errors);
	    	if(ShowDebugInfo) {
	    	System.out.println();
			System.out.println("Expected (Unparsed): " + expected);}
			useSameLastChild = false;
			if(!errors.isEmpty()) {

				String lel = (String)lastErrors.keySet().toArray()[0];
				String el = (String)errors.keySet().toArray()[0];
				if(ShowDebugInfo) {
				System.out.println("########################################################################################");
				System.out.println("NewError " + el + " -- " + errors.get(el).toString() + " FixTry: "+i);
				System.out.println("########################################################################################");}
				
				if(errors.get(el).getMessage().contains("Reshape Error") || checkIfErrorIsBeforeLast(lel,el) || (lel.equals(el) && Math.abs(lastErrors.get(lel).getBadness()) <= Math.abs(errors.get(el).getBadness()))){//|| (lel.equals(el) && lastErrors.get(lel).getMessage().equals(errors.get(el).getMessage()) && Math.abs(lastErrors.get(lel).getBadness()) <= Math.abs(errors.get(el).getBadness()))) {
					
//					System.out.println("checkIfErrorIsBeforeLast " + checkIfErrorIsBeforeLast(lel,el));
//					System.out.println("lel.equals(el) " + lel.equals(el));
//					System.out.println("Math.abs(lastErrors.get(lel).getBadness()) <= Math.abs(errors.get(el).getBadness() " + (Math.abs(lastErrors.get(lel).getBadness()) <= Math.abs(errors.get(el).getBadness())));
//					System.out.println("Math.abs(lastErrors.get(lel).getBadness())" +Math.abs(lastErrors.get(lel).getBadness()));
//					System.out.println("Math.abs(errors.get(el).getBadness())" +Math.abs(errors.get(el).getBadness()));
//					
					if(ShowDebugInfo) {System.out.println("######################restore Model####################################");}
					this.root = lastModel.copy();
					recursiveBuildMap(this.root);
					errors = new HashMap<>(lastErrors);
					lastInput = new HashMap<>(lastlastInput);
					useSameLastChild = false;
					tempLastChild = null;
				}
				else {
					if((lel.equals(el) && Math.abs(lastErrors.get(lel).getBadness()) > Math.abs(errors.get(el).getBadness())))
					{
						useSameLastChild = true;
					}
					if(ShowDebugInfo) {System.out.println("######################keep Fix####################################");}
					lastModel = this.root.copy();
					lastErrors = new HashMap<>(errors);
					lastlastInput = new HashMap<>(lastInput);
				}
				
			}
			else if(expected == "" || expected.contains("error") || expected.contains("invalid") || !expected.contains("[") || !expected.contains("]") || expected.trim().endsWith("false.")){
				if(ShowDebugInfo) {System.out.println("########################################################################################");
				System.out.println("Unfixable Model! " + root.getUniqueName());
				System.out.println("########################################################################################");}
				return false;
			}
			else {
				if(ShowDebugInfo) {System.out.println("########################################################################################");
				System.out.println("Model fixed! " + root.getUniqueName());
				System.out.println("########################################################################################");}
				return true;
				
			}
		}
		return false;
	}
	
	private int getNthDigit(long number, int base, int n) {    
		  return (int) ((number / Math.pow(base, n - 1)) % base);
		}
	private boolean checkIfErrorIsBeforeLast(String lastErrorLocation, String newErrorLocation)
	{
		Layer l = graphLayerMap.get(lastErrorLocation);
		Layer l1 = graphLayerMap.get(newErrorLocation);
		if(l == null || l1 == null) {
			return false;
		}
		return l1.isAncestor(l);
	}
	
	private Integer tempLastChild = null;
	private boolean useSameLastChild = false;
	
	public void replaceLayer(Random r, Layer l, List<String> options) {
		String newL;
		if(options != null && !options.isEmpty()) {
			newL = options.get(r.nextInt(options.size()));
		}
		else {
			newL = GenUtils.singleInputLayers.get(r.nextInt(GenUtils.singleInputLayers.size()));
		}
		Layer newLayer = GenUtils.genLayer(r,newL);
		replaceLayer(r,l,newLayer);
	}
	public void replaceLayer(Random r, Layer l, Layer lNew) {
		lNew.initUniqueName(r);
		lNew.isNewlyAdded = true;
		if(!(lNew instanceof MultiInputLayer) && l.getChildLayers().size() > 1)
		{
			Layer lc = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
			lc.setParentLayer(lNew);
			lNew.getChildLayers().add(lc);
		}
		else {
			for(Layer lc : l.getChildLayers()){
				lc.setParentLayer(lNew);
				lNew.getChildLayers().add(lc);
			}
		}
		if(l == root) {
			setRoot(lNew);
		}
		else
		{
			if(l.getParentLayer() == null) {
				if(ShowDebugInfo) {System.out.println("" +root.getUniqueName());
				System.out.println("" +l.getUniqueName());
				System.out.println("" +lNew.getUniqueName());}
			}
			int tmpindex = l.getParentLayer().getChildLayers().indexOf(l);
			l.getParentLayer().getChildLayers().remove(l);
			l.getParentLayer().getChildLayers().add(tmpindex,lNew);
			lNew.setParentLayer(l.getParentLayer());
		}
		graphLayerMap.put(lNew.getUniqueName(),lNew);
		graphLayerMap.remove(l.getUniqueName());
		if(lNew.getChildLayers().isEmpty()) {
			lastInput.put(lNew.getUniqueName(), lNew.generateInput(r));
			lastInput.remove(l.getUniqueName());
		}
	}
	
	public void insertLayerBefore(Random r, Layer l, List<String> options) {
			String newL;
			if(options != null && !options.isEmpty()) {
				newL = options.get(r.nextInt(options.size()));
			}
			else {
				newL = GenUtils.singleInputLayers.get(r.nextInt(GenUtils.singleInputLayers.size()));
			}
			Layer newLayer = GenUtils.genLayer(r,newL);
			insertLayerBefore(r,l,newLayer);	
	}
	
	public void insertLayerBefore(Random r, Layer l, Layer newLayer) {
		newLayer.initUniqueName(r);
		int insertIndex = l.getChildLayers().size();
		if(!l.getChildLayers().isEmpty()) {
			Layer l1;
			if(useSameLastChild && tempLastChild != null && tempLastChild < l.getChildLayers().size())
			{
				l1 = l.getChildLayers().get(tempLastChild);
			}
			else {
				l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
				tempLastChild = l.getChildLayers().indexOf(l1);
			}
			l1.setParentLayer(newLayer);
			newLayer.getChildLayers().add(l1);
			insertIndex = l.getChildLayers().indexOf(l1);
			
			l.getChildLayers().remove(l1);
		}	
		newLayer.setParentLayer(l);
		newLayer.isNewlyAdded = true;
		l.getChildLayers().add(insertIndex,newLayer);
		graphLayerMap.put(newLayer.getUniqueName(),newLayer);
		
		if(newLayer.getChildLayers().isEmpty()) {
			lastInput.put(newLayer.getUniqueName(), newLayer.generateInput(r));
			if(l.getChildLayers().size() == 1 && !(l instanceof MultiInputLayer && ((MultiInputLayer)l).getFixedInput() != null)) {
				lastInput.remove(l.getUniqueName());
			}
		}
		else if(newLayer instanceof MultiInputLayer && ((MultiInputLayer)newLayer).getFixedInput() != null) {
			lastInput.put(newLayer.getUniqueName(), ((MultiInputLayer)newLayer).getFixedInput());
		}
	}
	
	public void removeLayer(Random r, Layer l) {
		if(l == root)
		{
			root = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
			root.setParentLayer(null);
		}
		else {
			if(l.getParentLayer() == null) {
				if(ShowDebugInfo) {System.out.println("" +root.getUniqueName());
				System.out.println("" +l.getUniqueName());}
			}
			
			int tempindex = l.getParentLayer().getChildLayers().indexOf(l);
			l.getParentLayer().getChildLayers().remove(l);
			if(!l.getChildLayers().isEmpty()) {
				Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
				l1.setParentLayer(l.getParentLayer());
				l.getParentLayer().getChildLayers().add(tempindex,l1);
			}
		}
		buildGraphLayerMap(getRoot());
		if(l.getChildLayers().isEmpty()) {
			lastInput.remove(l.getUniqueName());
			if(l.getParentLayer() != null && l.getParentLayer().getChildLayers().isEmpty()) {
				lastInput.put(l.getParentLayer().getUniqueName(), l.getParentLayer().generateInput(r));
			}
		}
	}
	
	public void regenerateLayerArgs(Random r, Layer l, List<Integer> inputShape) {
		Layer l1 = GenUtils.genLayer(r,l.getName(),inputShape);
		if(l1 == null){
			if(ShowDebugInfo) {System.out.println("Arg Regeneration failed.");}
			return;
		}
		l1.isModified = true;
		l1.setUniqueName(l.getUniqueName());
		if(l == getRoot()) {
			setRoot(l1);
		}
		else {			
			int tempindex = l.getParentLayer().getChildLayers().indexOf(l);
			l.getParentLayer().getChildLayers().remove(l);
			l.getParentLayer().getChildLayers().add(tempindex,l1);
			l1.setParentLayer(l.getParentLayer());
		}
		for (Layer lc : l.getChildLayers()) {
			lc.setParentLayer(l1);
			l1.getChildLayers().add(lc);
		}
//		graphLayerMap.put(l1.getUniqueName(), l1);
//		graphLayerMap.remove(l.getUniqueName());
		buildGraphLayerMap(getRoot());
	}

	public Layer getRoot() {
		return root;
	}

	public void setRoot(Layer root) {
		this.root = root;
	}

	@Override
	public Layer copy() {
		return new LayerGraph(this);
	}
	
	@Override
	public int getLayerCount() {
		return root.getLayerCount();
	}
	
	private void fixInconsistenInputShapesOld(Random r, Layer l, ModelError e, boolean avoidParentArgRegeneration, boolean onlyFirstItemConcatenate) {
		List<Integer> newShape = null;
		String tempShape = e.getMessage().split(", Input Shape")[1].trim();
		//System.out.println(tempShape);
		tempShape = tempShape.replace("[", "").replace("]", "");
		if(ShowDebugInfo) {System.out.println(tempShape);}
		List<Integer> shape = new ArrayList<>();
		String[] tempShapeParts = tempShape.split(",");
		boolean isConcatenate = false;
		
		for (int i1 = 0; i1 < tempShapeParts.length; i1++) {
			shape.add(Integer.parseInt(tempShapeParts[i1]));
		}
		int tempShape0 = shape.get(0);
		shape.remove(0);
//		if(!(l.getChildLayers().size() == 1 && l.getChildLayers().get(0).getName().contains("Global"))){
//			shape.remove(0);
//		}
//		else {
//			boolean globalChild = false;
//			for (Layer l1 : l.getChildLayers()) {
//				if(l1.getName().contains("Global")) {
//					globalChild = true;
//					break;
//				}
//			}
//			if(globalChild) {
//				if(r.nextBoolean()) {
//					shape.remove(0);
//				}
//			}
//			else {
//				shape.remove(0);
//			}
//		}
		newShape = new ArrayList<>(shape);
		
		//List<String> options = Arrays.asList("Zero_Padding1D", "Zero_Padding2D", "Zero_Padding3D","Cropping1D", "Cropping2D", "Cropping3D");
		
		Layer newLayer = null;
		if(e.getBadness() >= 1000000000000l)
		{
			isConcatenate = true;
			newLayer = GenUtils.genLayer(r,"Concatenate");
			
			newLayer.setInputShape(shape);
			newLayer.getParams().put("axis","0");
			
			newShape.set(0, tempShape0 + 1);//((int)e.getBadness()/100000000));
			List<Integer> tempConcShape = new ArrayList<>(shape);
			tempConcShape.add(0, 1);//((int)e.getBadness()/100000000));
			((MultiInputLayer)newLayer).setFixedInput(ListHelper.genList(r, tempConcShape));
		}
		if(shape.size() == 4 && e.getBadness() >= 1000) {//e.getBadness() >= 1000) {
			newLayer = GenUtils.genLayer(r,"Zero_Padding3D");
			List<Object> sizes = new ArrayList<>();
			for(int i1 = 0; i1 < 3; i1++) {
				int s1 = getNthDigit(e.getBadness(),10,7-(i1*2))+10*getNthDigit(e.getBadness(),10,8-(i1*2))+100*getNthDigit(e.getBadness(),10,9-(i1*2));
				int s2 = 0;
				newShape.set(i1+1,newShape.get(i1+1)+s1);
				Object[] o = {s1,s2};
				sizes.add(o);
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			newLayer.params.put("padding", size);
		}
		else if(shape.size() == 3 && e.getBadness() >= 1000000000)
		{
			isConcatenate = true;
			newLayer = GenUtils.genLayer(r,"Concatenate");
			
			newLayer.setInputShape(shape);
			newLayer.getParams().put("axis","0");
			
			newShape.set(0, tempShape0 + 1);//((int)e.getBadness()/1000000));
			List<Integer> tempConcShape = new ArrayList<>(shape);
			tempConcShape.add(0, 1);//((int)e.getBadness()/1000000));
			((MultiInputLayer)newLayer).setFixedInput(ListHelper.genList(r, tempConcShape));
		}
		else if(shape.size() == 3 && e.getBadness() >= 1000) {//if(e.getBadness() >= 100) {
			newLayer = GenUtils.genLayer(r,"Zero_Padding2D");
			List<Object> sizes = new ArrayList<>();
			for(int i1 = 0; i1 < 2; i1++) {
				int s1 = getNthDigit(e.getBadness(),10,5-(i1*2))+10*getNthDigit(e.getBadness(),10,6-(i1*2))+100*getNthDigit(e.getBadness(),10,7-(i1*2));
				int s2 = 0;
				newShape.set(i1+1,newShape.get(i1+1)+s1);
				Object[] o = {s1,s2};
				sizes.add(o);
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			newLayer.params.put("padding", size);
		}
		else if(shape.size() == 2 && e.getBadness() >= 1000000)
		{
			isConcatenate = true;
			newLayer = GenUtils.genLayer(r,"Concatenate");
			
			newLayer.setInputShape(shape);
			newLayer.getParams().put("axis","0");
			
			newShape.set(0, tempShape0 + 1);//((int)e.getBadness()/10000));
			List<Integer> tempConcShape = new ArrayList<>(shape);
			tempConcShape.add(0, 1);//((int)e.getBadness()/10000));
			((MultiInputLayer)newLayer).setFixedInput(ListHelper.genList(r, tempConcShape));
		}
		else if(shape.size() == 2 && e.getBadness() >= 1000) {//if(e.getBadness() >= 10) {
			newLayer = GenUtils.genLayer(r,"Zero_Padding1D");
			List<Object> sizes = new ArrayList<>();
			for(int i1 = 0; i1 < 1; i1++) {
				int s1 = getNthDigit(e.getBadness(),10,3-(i1*2))+10*getNthDigit(e.getBadness(),10,4-(i1*2))+100*getNthDigit(e.getBadness(),10,5-(i1*2));
				int s2 = 0;
				newShape.set(i1+1,newShape.get(i1+1)+s1);
				Object[] o = {s1,s2};
				sizes.add(o);
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			newLayer.params.put("padding", size);
		}
		else {
			isConcatenate = true;
			newLayer = GenUtils.genLayer(r,"Concatenate");
			shape.set(shape.size()-1, (int)e.getBadness());
			newShape.set(newShape.size()-1,newShape.get(newShape.size()-1)+(int)e.getBadness());
			newLayer.setInputShape(shape);
			newLayer.getParams().put("axis",""+(shape.size()));
			
			List<Integer> tempConcShape = new ArrayList<>(shape);
			tempConcShape.add(0, tempShape0);
			((MultiInputLayer)newLayer).setFixedInput(ListHelper.genList(r, tempConcShape));
		}
		if(isConcatenate && onlyFirstItemConcatenate) {
			useSameLastChild = true;
			tempLastChild = 0;
			insertLayerBefore(r,l,newLayer);
			useSameLastChild = false;
		}
		else {
			insertLayerBefore(r,l,newLayer);
		}
		
		if(avoidParentArgRegeneration) {
			regenerateLayerArgs(r, newLayer.getParentLayer(), newShape);
		}	
	}
	

	
	
	private void fixInconsistenInputShapes(Random r, Layer l, ModelError e, boolean avoidParentArgRegeneration, boolean onlyFirstItemConcatenate) {

		boolean isConcatenate = false;
		List<Integer> newShape = null;
//		String tempShape = e.getMessage().split(", Input Shape")[1].trim();
//		//System.out.println(tempShape);
//		tempShape = tempShape.replace("[", "").replace("]", "");
//		if(ShowDebugInfo) {System.out.println(tempShape);}
		List<Integer> shape = e.getInputShape(false);
//		String[] tempShapeParts = tempShape.split(",");
//		
//		for (int i1 = 0; i1 < tempShapeParts.length; i1++) {
//			shape.add(Integer.parseInt(tempShapeParts[i1]));
//		}
		int tempShape0 = shape.get(0);
		shape.remove(0);
//		if(!(l.getChildLayers().size() == 1 && l.getChildLayers().get(0).getName().contains("Global"))){
//			shape.remove(0);
//		}
//		else {
//			boolean globalChild = false;
//			for (Layer l1 : l.getChildLayers()) {
//				if(l1.getName().contains("Global")) {
//					globalChild = true;
//					break;
//				}
//			}
//			if(globalChild) {
//				if(r.nextBoolean()) {
//					shape.remove(0);
//				}
//			}
//			else {
//				shape.remove(0);
//			}
//		}
		newShape = new ArrayList<>(shape);
		List<Integer> expectedShape = e.getExpectedShape();
		List<Integer> diff = e.getExpectedVsAcutualShape();
		int biggestDiffDim = e.getBiggestDiffDim(diff);
		
		System.out.println("expected Shape parsed:" + Arrays.toString(expectedShape.toArray()));
		System.out.println("input Shape parsed:" + Arrays.toString(e.getInputShape().toArray()));
		for(int i1 = 0; i1 < diff.size(); i1++) {
			System.out.println("%%%%%%%%%%%%%%%%%%%%%%% diff init "+ i1 + ": " + diff.get(i1) + " biggestDiffDim "+ biggestDiffDim + " shape.size: "+ shape.size());
		}
		
		
		//List<String> options = Arrays.asList("Zero_Padding1D", "Zero_Padding2D", "Zero_Padding3D","Cropping1D", "Cropping2D", "Cropping3D");
		
		Layer newLayer = null;
		if(biggestDiffDim>4)//e.getBadness() >= 1000000000000l)
		{
			isConcatenate = true;
			newLayer = GenUtils.genLayer(r,"Concatenate");
			
			newLayer.setInputShape(shape);
			newLayer.getParams().put("axis","0");
			
			newShape.set(0, tempShape0 + 1);//((int)e.getBadness()/100000000));
			List<Integer> tempConcShape = new ArrayList<>(shape);
			tempConcShape.add(0, 1);//((int)e.getBadness()/100000000));
			((MultiInputLayer)newLayer).setFixedInput(ListHelper.genList(r, tempConcShape));
		}
		if(shape.size() == 4 && biggestDiffDim>1) {//e.getBadness() >= 1000) {
			newLayer = GenUtils.genLayer(r,"Zero_Padding3D");
			List<Object> sizes = new ArrayList<>();
			for(int i1 = 0; i1 < 3; i1++) {
				int tempdiff = 0;
				if(i1 < diff.size()){
					//if(allNegative(diff) || diff.get(i1) > 0) {
						tempdiff = Math.abs(diff.get(i1));
					//}
				}
				int s1 = tempdiff;
				int s2 = 0;
				newShape.set(i1+1,newShape.get(i1+1)+s1);
				Object[] o = {s1,s2};
				sizes.add(o);
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			newLayer.params.put("padding", size);
		}
		else if(shape.size() == 3 && biggestDiffDim>3)
		{
			isConcatenate = true;
			newLayer = GenUtils.genLayer(r,"Concatenate");
			
			newLayer.setInputShape(shape);
			newLayer.getParams().put("axis","0");
			
			newShape.set(0, tempShape0 + 1);//((int)e.getBadness()/1000000));
			List<Integer> tempConcShape = new ArrayList<>(shape);
			tempConcShape.add(0, 1);//((int)e.getBadness()/1000000));
			((MultiInputLayer)newLayer).setFixedInput(ListHelper.genList(r, tempConcShape));
		}
		else if(shape.size() == 3 && biggestDiffDim >1) {//if(e.getBadness() >= 100) {
			newLayer = GenUtils.genLayer(r,"Zero_Padding2D");
			List<Object> sizes = new ArrayList<>();
			for(int i1 = 0; i1 < 2; i1++) {
				int tempdiff = 0;
				if(i1 < diff.size()){
					//if(allNegative(diff) || diff.get(i1) > 0) {
						tempdiff = Math.abs(diff.get(i1));
					//}
				}
				int s1 = tempdiff;
				int s2 = 0;
				newShape.set(i1+1,newShape.get(i1+1)+s1);
				Object[] o = {s1,s2};
				sizes.add(o);
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			newLayer.params.put("padding", size);
		}
		else if(shape.size() == 2 && biggestDiffDim>2)
		{
			for(int i1 = 0; i1 < diff.size(); i1++) {
				System.out.println("############################################ diff at "+ i1 + ": " + diff.get(i1) + " biggestDiffDim "+ biggestDiffDim);
			}
			isConcatenate = true;
			newLayer = GenUtils.genLayer(r,"Concatenate");
			
			newLayer.setInputShape(shape);
			newLayer.getParams().put("axis","0");
			
			newShape.set(0, tempShape0 + 1);//((int)e.getBadness()/10000));
			List<Integer> tempConcShape = new ArrayList<>(shape);
			tempConcShape.add(0, 1);//((int)e.getBadness()/10000));
			((MultiInputLayer)newLayer).setFixedInput(ListHelper.genList(r, tempConcShape));
		}
		else if(shape.size() == 2 && biggestDiffDim>1) {//if(e.getBadness() >= 10) {
			
			newLayer = GenUtils.genLayer(r,"Zero_Padding1D");
			List<Object> sizes = new ArrayList<>();
			for(int i1 = 0; i1 < 1; i1++) {
				int tempdiff = 0;
				System.out.println("############################################ diff at "+ i1 + ": " + diff.get(i1) + " biggestDiffDim "+ biggestDiffDim);
				if(i1 < diff.size()){
					//if(allNegative(diff) || diff.get(i1) > 0) {
						tempdiff = Math.abs(diff.get(i1));
					//}
				}
				int s1 = tempdiff;
				int s2 = 0;
				newShape.set(i1+1,newShape.get(i1+1)+s1);
				Object[] o = {s1,s2};
				sizes.add(o);
			}
			String size = ListHelper.printList(sizes.toArray());
			size = size.replace("[", "(").replace("]", ")");
			newLayer.params.put("padding", size);
		}
		else {
			isConcatenate = true;
			newLayer = GenUtils.genLayer(r,"Concatenate");
			System.out.println("############################################ diff at "+ (diff.size()-1) + ": " + diff.get(diff.size()-1)+ " biggestDiffDim "+ biggestDiffDim);
			shape.set(shape.size()-1, Math.abs(diff.get(diff.size()-1)));
			newShape.set(newShape.size()-1,expectedShape.get(expectedShape.size()-1));//newShape.get(newShape.size()-1)+diff.get(0));//(int)e.getBadness());
			newLayer.setInputShape(shape);
			newLayer.getParams().put("axis",""+(shape.size()));
			
			List<Integer> tempConcShape = new ArrayList<>(shape);
			tempConcShape.add(0, tempShape0);
			((MultiInputLayer)newLayer).setFixedInput(ListHelper.genList(r, tempConcShape));
		}
		newLayer.isNewlyAdded = true;
		if(isConcatenate && onlyFirstItemConcatenate) {
			useSameLastChild = true;
			tempLastChild = 0;
			insertLayerBefore(r,l,newLayer);
			useSameLastChild = false;
		}
		else {
			insertLayerBefore(r,l,newLayer);
		}
		
		if(avoidParentArgRegeneration) {
			regenerateLayerArgs(r, newLayer.getParentLayer(), newShape);
		}	
	}
	
	
	
	
	private void fixPoolShapeError(Random r, Layer l, ModelError e) {
//		List<String> options = null;
//		if(e.getBadness() < 0) {
//			options = Arrays.asList("Zero_Padding1D", "Zero_Padding2D", "Zero_Padding3D");
//		}
//		else {
//			options = Arrays.asList("Cropping1D", "Cropping2D", "Cropping3D");
//		}
//		if(r.nextInt(10)>2) {
//			insertLayerBefore(r,l,options);
//		}
//		else {
//			if(r.nextBoolean() && !l.getChildLayers().isEmpty()){
//				Layer l1 = l.getChildLayers().get(r.nextInt(l.getChildLayers().size()));
//				regenerateLayerArgs(r,l1,null);
//			}
//			else {
			//if(r.nextBoolean()
				regenerateLayerArgs(r,l,e.getInputShape());
//			}
//		}
	}
	
	

	public Layer getAndRestoreLastModel() {
		if(lastModel == null)
		{
			return null;
		}
		this.root = lastModel;
		recursiveBuildMap(this.root);
		return this;
	}


}
