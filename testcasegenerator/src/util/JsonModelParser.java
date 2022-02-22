package util;

import Main.TestCaseGenerator;
import layer.Layer;
import layer.LayerGraph;
import layer.NodeLayer;
import layer.PlaceHolderLayer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class JsonModelParser {
	
	
	public static LayerGraph parseModel(Random rand, String path) throws ParseException {
		String json = Util.readFile(path);
		
        JSONObject jsonObject = (JSONObject) new JSONParser().parse(json);
		
		
		JSONObject model = (JSONObject)jsonObject.get("model");
		
		String shapeString = (String) model.get("shape");
		
		
		shapeString = shapeString.substring(1,shapeString.length()-1);
		System.out.println(shapeString);
		List<Integer> inputShape = new ArrayList<>();
		for(String s: shapeString.split(","))
		{
			inputShape.add(Integer.parseInt(s));
		}
		int tempShape = inputShape.get(0);
		inputShape.remove(0);
		Collections.reverse(inputShape);
		System.out.println(Arrays.toString(inputShape.toArray()));
		
		JSONArray jlayers = (JSONArray) model.get("layers");
		ArrayList<Layer> layers = new ArrayList<>();
		for(int i = 0; i< jlayers.size(); i++) {
			JSONObject jlayer = (JSONObject)jlayers.get(i);
			Layer layer = parseLayer(rand,jlayer,path);
			if(!layers.isEmpty()) {
				layers.get(layers.size()-1).connectParent(layer);
			}
			layers.add(layer);
			layer.initUniqueName(rand);
		}
		if(layers.get(0).getName().toLowerCase().contains("lstm") || layers.get(0).getName().toLowerCase().contains("gru")) {
			inputShape.add(tempShape);
			inputShape.set(inputShape.size()-1,((Object[])((NodeLayer)layers.get(0)).getInputWeights()).length);
		}
		layers.get(0).setInputShape(inputShape);
		return new LayerGraph(layers.get(layers.size()-1));
	}
	
	private static Layer parseLayer(Random rand, JSONObject jlayer, String modelPath){
		String type = (String) jlayer.get("type");
		if(type.equals("function")){
			type = (String) jlayer.get("func");
		}
		else if(type.equals("linear")){ 
			type = "dense";
		}
		if(type.contains("conv")) {
			jlayer.put("weights",  jlayer.get("filters"));
			jlayer.remove("filters");
		}
		LinkedHashMap<String, Object> params = new LinkedHashMap<>();
		Object weights = null;
		if(jlayer.containsKey("weights")) {
			String jw = (String) jlayer.get("weights");
			System.out.println(jw);
			jw = jw.replace("\r\n", "");
			jw = jw.replace("\n", "");
			jw = jw.replaceAll(" +", " ");
			jw = jw.replace("[ ","[");
			if(jw.contains("[") && !jw.contains("/")) {
				weights = ListHelper.parseList(jw);
			}
			else {
				String ws = Util.readFile(combinePaths(modelPath,jw));
				weights = ListHelper.parseList(ws);
			}
			//if(type.equals("dense")) {
				weights = ListHelper.transposeList(weights);
			//}
			params.put("weights",weights);
			System.out.println("Weight shape: " + Arrays.toString(ListHelper.getShape(weights).toArray()));
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
			else {
				String ws = Util.readFile(combinePaths(modelPath,jw));
				bias = ListHelper.parseList(ws);
				//System.out.println(ListHelper.printList(bias));
			}
			System.out.println("bias shape: " + Arrays.toString(ListHelper.getShape(bias).toArray()));
			params.put("bias",bias);
		}
		
		for (Object ok : jlayer.keySet()) {
			String k = (String)ok;
			if(!k.equals("type") && !k.equals("func") && !k.equals("weights")&& !k.equals("bias")) {
				if(k.equals("stride") && !((String)jlayer.get(k)).contains("(")) {
					params.put(k, (Object)("("+jlayer.get(k)+")"));
				}
				else if(k.equals("padding") && !((String)jlayer.get(k)).contains("(")) {
					boolean b = (jlayer.get(k).toString().equals("1") || jlayer.get(k).toString().equalsIgnoreCase("true") || jlayer.get(k).toString().equalsIgnoreCase("same"));
					params.put(k, (Object)(b));
				}
				else {
					params.put(k, (Object)jlayer.get(k));
				}
			}
		}
		System.out.println(Arrays.toString(params.keySet().toArray()));
		return GenUtils.genLayer(rand,type,null,params,weights,bias);
	}
	
	private static String combinePaths(String p1, String p2) {
		if(p1.endsWith(".json")) {
			p1 = p1.substring(0,p1.lastIndexOf("/"));
		}
		String p = "";
		String[] p1s = p1.split("/");
		String[] p2s = p2.split("/");
		for (int i = 0; i < p1s.length; i++) {
			if(p1s[i].equals(p2s[0])) {
				break;
			}
			p +=p1s[i]+"/";
		}
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
