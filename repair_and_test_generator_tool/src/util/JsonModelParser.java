package util;

import Main.TestCaseGenerator;
import layer.DotLayer;
import layer.Layer;
import layer.LayerGraph;
import layer.NodeLayer;
import layer.PlaceHolderLayer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class JsonModelParser {
	
	
	public static LayerGraph parseModelFromPathGraph(Random rand, String path) throws ParseException {
		return parseModelFromPath(rand, path,true);
	}
	
	public static LayerGraph parseModelFromPath(Random rand, String path, boolean socratesMode) throws ParseException {
		String json = Util.readFile(path);
		return parseModelFromJsonString(rand, json, socratesMode,path);
	}
	
	public static LayerGraph parseModelFromJsonString(Random rand, String json, boolean socratesMode) throws ParseException {
		return parseModelFromJsonString(rand, json, socratesMode,"");
	}
	
	
	public static LayerGraph parseModelFromJsonString(Random rand, String json, boolean socratesMode, String path) throws ParseException {
        JSONObject jsonObject = (JSONObject) new JSONParser().parse(json);
        JSONArray jlayers;
        List<Integer> inputShape = null;
        int tempShape = 1;
		if(jsonObject.containsKey("model")) {
			JSONObject model = (JSONObject)jsonObject.get("model");
			
			String shapeString = (String) model.get("shape");
			
			shapeString = shapeString.substring(1,shapeString.length()-1);
			System.out.println(shapeString);
			inputShape = new ArrayList<>();
			for(String s: shapeString.split(","))
			{
				inputShape.add(Integer.parseInt(s.trim()));
			}
			tempShape = inputShape.get(0);
			inputShape.remove(0);
			if(socratesMode) {
				Collections.reverse(inputShape);
			}
			System.out.println(Arrays.toString(inputShape.toArray()));
			jlayers = (JSONArray) model.get("layers");
		}
		else {
			jlayers = (JSONArray) jsonObject.get("layers");
		}
		
		Map<String,List<String>> layerInputs = new HashMap<String,List<String>>();
		ArrayList<Layer> layers = new ArrayList<>();
		Map<String,Layer> layerMap = new HashMap<String, Layer>();
		for(int i = 0; i< jlayers.size(); i++) {
			JSONObject jlayer = (JSONObject)jlayers.get(i);
			Layer layer = parseLayer(rand,jlayer,path, layerInputs, socratesMode);
			if(layer.getName().toLowerCase().equals("dropout")) {
				continue;
			}
			
			layers.add(layer);
			layerMap.put(layer.getUniqueName(), layer);
			
			if(!((String)jlayer.get("type")).equalsIgnoreCase("activation") && jlayer.containsKey("activation") &&  !((String)jlayer.get("activation")).equalsIgnoreCase("linear")) {
				Layer layer1 = GenUtils.genLayer(rand,(String)jlayer.get("activation"),null,new LinkedHashMap<>(),null,null);
				layer1.initUniqueName(rand);
				layers.add(layer1);
				layerMap.put(layer1.getUniqueName(), layer1);	
			}
		}
		Layer root = null;
		HashSet<String> rootTempSet = new HashSet<>();
		if(!layerInputs.isEmpty()) {
			for (String layerName : layerInputs.keySet()) {
				List<String> inputs = layerInputs.get(layerName);
				for (String in : inputs) {
					if(!in.contains("[")) {
						//layerMap.get(layerName).connectParent(layerMap.get(in));
						layerMap.get(in).connectParent(layerMap.get(layerName));
						rootTempSet.add(in);
					}
					else {
						layerMap.get(layerName).setFixedInput(ListHelper.parseList(in));
					}
				}
			}
			for(int i = 0; i < layers.size(); i++) {
				if(!rootTempSet.contains(layers.get(i).getUniqueName())) {
					root = layers.get(i);
					break;
				}
			}
		}
		else{
			for(int i = 1; i < layers.size(); i++) {
				layers.get(i-1).connectParent(layers.get(i));
			}
			root = layers.get(layers.size()-1);
		}
		LayerGraph lg = new LayerGraph(root);
		
		
		
		if(socratesMode) {
			if(layers.get(0).getName().toLowerCase().contains("lstm") || layers.get(0).getName().toLowerCase().contains("gru")) {
				inputShape.add(tempShape);
				inputShape.set(inputShape.size()-1,((Object[])((NodeLayer)layers.get(0)).getInputWeights()).length);
			}
		}
		if(inputShape != null) {
			layers.get(0).setInputShape(inputShape);
		}
		return lg;
	}
	
	private static Layer parseLayer(Random rand, JSONObject jlayer, String modelPath,Map<String,List<String>> layerInputs,boolean socratesMode){
		String type = (String) jlayer.get("type");
		if(type.equals("function")){
			type = (String) jlayer.get("func");
		}
		else if(type.equals("linear")){ 
			type = "dense";
		}
		else if (type.equalsIgnoreCase("activation")) {
			type = (String) jlayer.get("activation");
		}
		//System.out.println(type);
		if(type.contains("conv") && !jlayer.containsKey("weights")) {
			jlayer.put("weights",  jlayer.get("filters"));
			jlayer.remove("filters");
		}
		if(type.contains("gru") && !jlayer.containsKey("weights")) {
			jlayer.put("weights",  jlayer.get("gate_weights"));
			jlayer.remove("gate_weights");
		}
		if(type.contains("gru") && !jlayer.containsKey("bias")) {
			jlayer.put("bias",  jlayer.get("gate_bias"));
			jlayer.remove("gate_bias");
		}
//		if(type.contains("gru") && !jlayer.containsKey("recurrent_weights")) {
//			jlayer.put("recurrent_weights",  jlayer.get("candidate_weights"));
//			jlayer.remove("candidate_weights");
//		}
		LinkedHashMap<String, Object> params = new LinkedHashMap<>();
		Object weights = null;
		if(jlayer.containsKey("weights")) {
			System.out.println(jlayer.get("weights"));
			String jw = (String) jlayer.get("weights");
			System.out.println(jw);
			jw = jw.replace("\r\n", "");
			jw = jw.replace("\n", "");
			jw = jw.replaceAll(" +", " ");
			jw = jw.replace("[ ","[");
			if(jw.contains("[") && !jw.contains("/")) {
				weights = ListHelper.parseList(jw);
			}
			else if(jw.contains(".txt")){
				String ws = Util.readFile(combinePaths(modelPath,jw));
				weights = ListHelper.parseList(ws);
			}
			List<Integer> oldShape = ListHelper.getShape(weights);
			System.out.println("Original Weight shape: " + Arrays.toString(oldShape.toArray()));
			//if(type.equals("dense")) {
//			if(oldShape.size() == 2 && oldShape.get(0) == oldShape.get(1)) {
//				
//			}
//			else {
			if(socratesMode) {
				weights = ListHelper.transposeList(weights);
			}
			//}
			params.put("weights",weights);
			System.out.println("Weight shape: " + Arrays.toString(ListHelper.getShape(weights).toArray()));
		}
		else if(jlayer.containsKey("weight_shape")) {
			String shapeString = (String) jlayer.get("weight_shape");
			shapeString = shapeString.substring(1,shapeString.length()-1);
			List<Integer> shape = new ArrayList<>();
			for(String s: shapeString.split(","))
			{
				shape.add(Integer.parseInt(s.trim()));
			}
			weights = ListHelper.genList(rand, shape); 
			params.put("weights",weights);
			System.out.println("Weight shape: " + Arrays.toString(ListHelper.getShape(weights).toArray()));
		}
		
		if(jlayer.containsKey("recurrent_weights")) {
			Object recweights = null;
			String jw = (String) jlayer.get("recurrent_weights");
			System.out.println(jw);
			jw = jw.replace("\r\n", "");
			jw = jw.replace("\n", "");
			jw = jw.replaceAll(" +", " ");
			jw = jw.replace("[ ","[");
			if(jw.contains("[") && !jw.contains("/")) {
				recweights = ListHelper.parseList(jw);
			}
			else if(jw.contains(".txt")){
				String ws = Util.readFile(combinePaths(modelPath,jw));
				recweights = ListHelper.parseList(ws);
			}
			List<Integer> oldShape = ListHelper.getShape(recweights);
			System.out.println("Original Recurrent Weight shape: " + Arrays.toString(oldShape.toArray()));

			if(socratesMode) {
				recweights = ListHelper.transposeList(recweights);
			}
			params.put("recurrent_weights",recweights);
			
			System.out.println("recurrent_weights shape: " + Arrays.toString(ListHelper.getShape(recweights).toArray()));
		}
		else if(jlayer.containsKey("recurrent_weight_shape")) {
			String shapeString = (String) jlayer.get("recurrent_weight_shape");
			shapeString = shapeString.substring(1,shapeString.length()-1);
			List<Integer> shape = new ArrayList<>();
			for(String s: shapeString.split(","))
			{
				shape.add(Integer.parseInt(s.trim()));
			}
			Object recweights = ListHelper.genList(rand, shape); 
			params.put("recurrent_weights",recweights);
			System.out.println("recurrent weights shape: " + Arrays.toString(ListHelper.getShape(recweights).toArray()));
		}
		
		if(jlayer.containsKey("weights1")) {
			Object weights1 = null;
			String jw = (String) jlayer.get("weights1");
			System.out.println(jw);
			jw = jw.replace("\r\n", "");
			jw = jw.replace("\n", "");
			jw = jw.replaceAll(" +", " ");
			jw = jw.replace("[ ","[");
			if(jw.contains("[") && !jw.contains("/")) {
				weights1 = ListHelper.parseList(jw);
			}
			else if(jw.contains(".txt")){
				String ws = Util.readFile(combinePaths(modelPath,jw));
				weights1 = ListHelper.parseList(ws);
			}
			List<Integer> oldShape = ListHelper.getShape(weights1);
			System.out.println("Original Recurrent Weight shape: " + Arrays.toString(oldShape.toArray()));

			if(socratesMode) {
				weights1 = ListHelper.transposeList(weights1);
			}
			params.put("weights1",weights1);
			System.out.println("weights1 shape: " + Arrays.toString(ListHelper.getShape(weights1).toArray()));
		}
		else if(jlayer.containsKey("weight1_shape")) {
			String shapeString = (String) jlayer.get("weight1_shape");
			shapeString = shapeString.substring(1,shapeString.length()-1);
			List<Integer> shape = new ArrayList<>();
			for(String s: shapeString.split(","))
			{
				shape.add(Integer.parseInt(s.trim()));
			}
			Object weights1 = ListHelper.genList(rand, shape); 
			params.put("weights1",weights1);
			System.out.println("Weight shape: " + Arrays.toString(ListHelper.getShape(weights1).toArray()));
		}
		
		
		Object bias = null;
		if(jlayer.containsKey("bias")) {
			String jw = (String) jlayer.get("bias");
			//System.out.println(jw);
			jw = jw.replace("\r\n", "");
			jw = jw.replace("\n", "");
			jw = jw.replaceAll(" +", " ");
			jw = jw.replace("[ ","[");
			if(jw.contains("[") && !jw.contains("/")) {
				bias = ListHelper.parseList(jw);
			}
			else if(jw.contains(".txt")){
				String ws = Util.readFile(combinePaths(modelPath,jw));
				bias = ListHelper.parseList(ws);
				//System.out.println(ListHelper.printList(bias));
			}
			System.out.println("bias shape: " + Arrays.toString(ListHelper.getShape(bias).toArray()));
			params.put("bias",bias);
		}
		else if(jlayer.containsKey("bias_shape")) {
			String shapeString = (String) jlayer.get("bias_shape");
			shapeString = shapeString.substring(1,shapeString.length()-1);
			List<Integer> shape = new ArrayList<>();
			for(String s: shapeString.split(","))
			{
				shape.add(Integer.parseInt(s.trim()));
			}
			bias = ListHelper.genList(rand, shape); 
			params.put("bias",bias);
			System.out.println("bias shape: " + Arrays.toString(ListHelper.getShape(bias).toArray()));
		}
		
		for (Object ok : jlayer.keySet()) {
			String k = (String)ok;
			if(!k.equals("type") && !k.equals("func") && !k.equals("weights")&& !k.equals("bias") && !params.containsKey(k)) {
				if(k.equals("stride") && !((String)jlayer.get(k)).contains("(")) {
					params.put(k, (Object)("("+jlayer.get(k)+")"));
				}
				else if(k.equals("padding") && !((String)jlayer.get(k)).contains("(")) {
					boolean b = (jlayer.get(k).toString().equals("1") || jlayer.get(k).toString().equalsIgnoreCase("true") || jlayer.get(k).toString().equalsIgnoreCase("same"));
					params.put(k, (Object)(b));
				}
				else if(jlayer.get(k) instanceof JSONArray){
					ArrayList<Object> list = new ArrayList<>();
					for (Object in : (JSONArray)jlayer.get(k)) {
						if(in instanceof Integer) {
							list.add((int)in);
						}
						else if(in instanceof Long) {
							list.add(Math.toIntExact((long)in));
						}
						else if(in instanceof String && Util.isInt((String)in)){
							list.add(Integer.parseInt(((String)in).trim()));
						}
						else {
							list.add(in);
						}
					}
					params.put(k, (Object)list);
				}
				else
				{
					params.put(k, (Object)jlayer.get(k));
				}
			}
		}
		System.out.println(Arrays.toString(params.keySet().toArray()));
		
		
		List<Integer> inputShape = null;
		if(jlayer.containsKey("input_shape")) {
			inputShape = new ArrayList<>();
			if(jlayer.get("input_shape") instanceof JSONArray) {
				
				for (Object in : (JSONArray)jlayer.get("input_shape")) {
					if(in instanceof Integer) {
						inputShape.add((int)in);
					}
					else if(in instanceof Long) {
						inputShape.add(Math.toIntExact((long)in));
					}
					else {
						inputShape.add(Integer.parseInt(((String)in).trim()));
					}
				}
			}
			else {
				String is = (String) jlayer.get("input_shape");
				is = is.substring(1,is.length()-1);
				
				for(String s: is.split(","))
				{
					inputShape.add(Integer.parseInt(s.trim()));
				}
			}
			inputShape.remove(0);
			System.out.println("Input Shape set: "+ ListHelper.printList(inputShape));
		}
		
		Layer l = GenUtils.genLayer(rand,type,inputShape,params,weights,bias);
		if(jlayer.containsKey("name")) {
			l.setUniqueName(Util.capitaliseFirstLetter((String)jlayer.get("name")));
		}
		else {
			l.initUniqueName(rand);
		}
		if(jlayer.containsKey("inputs")) {
			JSONArray inputs = (JSONArray) jlayer.get("inputs");
			List<String> ins = new ArrayList<>();
			for (Object in : inputs) {
				ins.add((String)in);
				System.out.println("input added "+ (String)in);
			}
			if(!ins.isEmpty()) {
				layerInputs.put(l.getUniqueName(), ins);
			}
			
		}
		if(jlayer.containsKey("input_shape1")) {
			String is = (String) jlayer.get("input_shape1");
			is = is.substring(1,is.length()-1);
			List<Integer> inputShape1 = new ArrayList<>();
			for(String s: is.split(","))
			{
				inputShape1.add(Integer.parseInt(s.trim()));
			}
			inputShape1.remove(0);
			System.out.println("Input Shape 1 set: "+is);
			((DotLayer)l).setInputShape1(inputShape1);
		}
		
		return l;
	}
	
	

	
	private static String combinePaths(String p1, String p2) {
		if(p1.endsWith(".json")) {
			p1 = p1.substring(0,p1.lastIndexOf("/"));
		}
		String p = "";
		String[] p1s = p1.trim().split("/");
		String[] p2s = p2.trim().split("/");
		for (int i = 0; i < p1s.length; i++) {
			if(p1s[i].equals(p2s[0])) {
				break;
			}
			p +=p1s[i]+"/";
		}
		System.out.println( p1 + "###"+ p2 + p);
		return p+p2;		
	}
	
//	def parse_layers(spec):
//	    layers = list()
//
//	    for layer in spec:
//	        type = layer['type'].lower()
//
//	        if type == 'linear':
//
//	            weights = np.array(ast.literal_eval(read(layer['weights'])))
//	            bias = np.array(ast.literal_eval(read(layer['bias'])))
//	            name = layer['func'].lower() if 'func' in layer else None
//
//	            layers.append(Linear(weights, bias, name))
//
//	        elif type == 'conv1d' or type == 'conv2d' \
//	            or type == 'conv3d':
//
//	            filters = np.array(ast.literal_eval(read(layer['filters'])))
//	            bias = np.array(ast.literal_eval(read(layer['bias'])))
//
//	            stride = ast.literal_eval(read(layer['stride']))
//	            padding = ast.literal_eval(read(layer['padding']))
//
//	            if type == 'conv1d':
//	                layers.append(Conv1d(filters, bias, stride, padding))
//	            elif type == 'conv2d':
//	                layers.append(Conv2d(filters, bias, stride, padding))
//	            elif type == 'conv3d':
//	                layers.append(Conv3d(filters, bias, stride, padding))
//
//	        elif type == 'maxpool1d' or type == 'maxpool2d' \
//	            or type == 'maxpool3d':
//
//	            kernel = np.array(ast.literal_eval(read(layer['kernel'])))
//
//	            stride = ast.literal_eval(read(layer['stride']))
//	            padding = ast.literal_eval(read(layer['padding']))
//
//	            if type == 'maxpool1d':
//	                layers.append(MaxPool1d(kernel, stride, padding))
//	            elif type == 'maxpool2d':
//	                layers.append(MaxPool2d(kernel, stride, padding))
//	            elif type == 'maxpool3d':
//	                layers.append(MaxPool3d(kernel, stride, padding))
//
//	        elif type == 'resnet2l':
//
//	            filters1 = np.array(ast.literal_eval(read(layer['filters1'])))
//	            bias1 = np.array(ast.literal_eval(read(layer['bias1'])))
//	            filters2 = np.array(ast.literal_eval(read(layer['filters2'])))
//	            bias2 = np.array(ast.literal_eval(read(layer['bias2'])))
//
//	            stride1 = ast.literal_eval(read(layer['stride1']))
//	            padding1 = ast.literal_eval(read(layer['padding1']))
//	            stride2 = ast.literal_eval(read(layer['stride2']))
//	            padding2 = ast.literal_eval(read(layer['padding2']))
//
//	            if 'filterX' in layer:
//	                filtersX = np.array(ast.literal_eval(read(layer['filtersX'])))
//	                biasX = np.array(ast.literal_eval(read(layer['biasX'])))
//
//	                strideX = ast.literal_eval(read(layer['strideX']))
//	                paddingX = ast.literal_eval(read(layer['paddingX']))
//
//	                layers.append(ResNet2l(filters1, bias1, stride1, padding1,
//	                    filters2, bias2, stride2, padding2,
//	                    filtersX, biasX, strideX, paddingX))
//	            else:
//	                layers.append(ResNet2l(filters1, bias1, stride1, padding1,
//	                    filters2, bias2, stride2, padding2))
//
//	        elif type == 'resnet3l':
//
//	            filters1 = np.array(ast.literal_eval(read(layer['filters1'])))
//	            bias1 = np.array(ast.literal_eval(read(layer['bias1'])))
//	            filters2 = np.array(ast.literal_eval(read(layer['filters2'])))
//	            bias2 = np.array(ast.literal_eval(read(layer['bias2'])))
//	            filters3 = np.array(ast.literal_eval(read(layer['filters3'])))
//	            bias3 = np.array(ast.literal_eval(read(layer['bias3'])))
//
//	            stride1 = ast.literal_eval(read(layer['stride1']))
//	            padding1 = ast.literal_eval(read(layer['padding1']))
//	            stride2 = ast.literal_eval(read(layer['stride2']))
//	            padding2 = ast.literal_eval(read(layer['padding2']))
//	            stride3 = ast.literal_eval(read(layer['stride3']))
//	            padding3 = ast.literal_eval(read(layer['padding3']))
//
//	            if 'filterX' in layer:
//	                filtersX = np.array(ast.literal_eval(read(layer['filtersX'])))
//	                biasX = np.array(ast.literal_eval(read(layer['biasX'])))
//
//	                strideX = ast.literal_eval(read(layer['strideX']))
//	                paddingX = ast.literal_eval(read(layer['paddingX']))
//
//	                layers.append(ResNet3l(filters1, bias1, stride1, padding1,
//	                    filters2, bias2, stride2, padding2,
//	                    filters3, bias3, stride3, padding3,
//	                    filtersX, biasX, strideX, paddingX))
//	            else:
//	                layers.append(ResNet3l(filters1, bias1, stride1, padding1,
//	                    filters2, bias2, stride2, padding2,
//	                    filters3, bias3, stride3, padding3))
//
//	        elif type == 'rnn':
//
//	            weights = np.array(ast.literal_eval(read(layer['weights'])))
//	            bias = np.array(ast.literal_eval(read(layer['bias'])))
//	            h0 = np.array(ast.literal_eval(read(layer['h0'])))
//	            name = layer['func'].lower() if 'func' in layer else None
//
//	            layers.append(BasicRNN(weights, bias, h0, name))
//
//	        elif type == 'lstm':
//
//	            weights = np.array(ast.literal_eval(read(layer['weights'])))
//	            bias = np.array(ast.literal_eval(read(layer['bias'])))
//
//	            h0 = np.array(ast.literal_eval(read(layer['h0'])))
//	            c0 = np.array(ast.literal_eval(read(layer['c0'])))
//
//	            layers.append(LSTM(weights, bias, h0, c0))
//
//	        elif type == 'gru':
//
//	            gate_weights = np.array(ast.literal_eval(read(layer['gate_weights'])))
//	            candidate_weights = np.array(ast.literal_eval(read(layer['candidate_weights'])))
//
//	            gate_bias = np.array(ast.literal_eval(read(layer['gate_bias'])))
//	            candidate_bias = np.array(ast.literal_eval(read(layer['candidate_bias'])))
//
//	            h0 = np.array(ast.literal_eval(read(layer['h0'])))
//
//	            layers.append(GRU(gate_weights, candidate_weights, gate_bias, candidate_bias, h0))
//
//	        elif type == 'function':
//	            name = layer['func'].lower()
//
//	            if name == 'reshape':
//	                ns = ast.literal_eval(read(layer['newshape']))
//	                params = (ns)
//	            elif name == 'transpose':
//	                ax = ast.literal_eval(read(layer['axes']))
//	                params = (ax)
//	            else:
//	                params = None
//
//	            layers.append(Function(name, params))
//
//	    return layers
//
//
//	def parse_bounds(size, spec):
//	    bounds = np.array(ast.literal_eval(read(spec)))
//
//	    lower = np.zeros(size)
//	    upper = np.zeros(size)
//
//	    step = int(size / len(bounds))
//
//	    for i in range(len(bounds)):
//	        bound = bounds[i]
//
//	        lower[i * step : (i + 1) * step] = bound[0]
//	        upper[i * step : (i + 1) * step] = bound[1]
//
//	    return lower, upper
//
//
//	def parse_model(spec):
//	    shape = np.array(ast.literal_eval(read(spec['shape'])))
//	    lower, upper = parse_bounds(np.prod(shape), spec['bounds'])
//	    layers = parse_layers(spec['layers']) if 'layers' in spec else None
//	    path = spec['path'] if 'path' in spec else None
//
//	    return Model(shape, lower, upper, layers, path)

}
