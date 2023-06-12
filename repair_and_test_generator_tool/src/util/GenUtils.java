package util;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import gen.Gen;
import gen.MultiInputGen;
import gen.TwoInputGen;
import layer.ConvLayer;
import layer.EmbeddingLayer;
import layer.Layer;
import layer.NodeLayer;
import layer.PlaceHolderLayer;
import layer.RecurrentLayer;

public class GenUtils {

	public static Map<String,Gen> layerGenMap = new HashMap<>();
	public static List<String> layers = null;
	
	public static List<String> multiInputLayers = new ArrayList<String>();
	public static List<String> singleInputLayers = new ArrayList<String>();
	public static List<String> convLayers = new ArrayList<String>();
	public static List<String> poolLayers = new ArrayList<String>();
	public static List<String> recurrentLayers = new ArrayList<String>();
	public static List<String> activationLayers = new ArrayList<String>();
	public static List<String> helperLayers = new ArrayList<String>();
		
	public static Map<String,String> dimensionLayerMap = new HashMap<>();
	public static Map<String,String> layerNameAliase = new HashMap<>();
	
	public static int regenerationCounter = 0;
	public static int totalFixIterations = 0;
	
	
	public static boolean initilised = false;
	public static void init() {
		if(!initilised) {
			layers = null;
			
			multiInputLayers = new ArrayList<String>();
			singleInputLayers = new ArrayList<String>();
			convLayers = new ArrayList<String>();
			poolLayers = new ArrayList<String>();
			recurrentLayers = new ArrayList<String>();
			activationLayers = new ArrayList<String>();
			helperLayers = new ArrayList<String>();
			dimensionLayerMap = new HashMap<>();
			layerNameAliase = new HashMap<>();
			
			regenerationCounter = 0;
			totalFixIterations = 0;
			
			if(layers == null) {
				layers = new ArrayList<>(layerGenMap.keySet());
				for(String l : layers){
					layerNameAliase.put(l.toLowerCase().replace("_", ""), l);
				}
				layers = new ArrayList<>(layerGenMap.keySet());
			}
			for (String l : layers) {
				if(layerGenMap.get(l) instanceof MultiInputGen || layerGenMap.get(l) instanceof TwoInputGen) {
					multiInputLayers.add(l);
				}
				else {
					singleInputLayers.add(l);
				}
				if(l.toLowerCase().contains("conv") || l.toLowerCase().contains("locally_connected")) {
					convLayers.add(l);
				}
				else if(l.toLowerCase().contains("rnn") || l.toLowerCase().contains("gru") || l.toLowerCase().contains("lstm")) {
					recurrentLayers.add(l);
				}
				else if(l.toLowerCase().contains("pool")) {
					poolLayers.add(l);
				}
				else if(l.toLowerCase().contains("relu") || l.toLowerCase().contains("softmax") || l.toLowerCase().contains("sigmoid") || l.toLowerCase().equals("elu")) {
					activationLayers.add(l);
				}
				else if(l.toLowerCase().contains("up_sampling") || l.toLowerCase().contains("zero_padding") || l.toLowerCase().contains("cropping") || l.toLowerCase().contains("normalization") || l.toLowerCase().contains("flatten") || l.toLowerCase().contains("repeat")) {
					helperLayers.add(l);
				}
			}
			initilised = true;
		}
	}
	public static void restrictLayersToList(List<String> reslayers) {
		HashSet<String> lset = new HashSet<>(reslayers);
		List<String> tmplayer = new ArrayList<>(layers);
		for (String l : tmplayer) {
			if(!reslayers.contains(l)) {
				removeLayerfromSelectionNotGeneration(l);
			}
		}
	}
	
	public static void removeLayerfromSelectionNotGeneration(String layer) {
		if(layers.contains(layer)) {
			layers.remove(layer);
		}
		if(multiInputLayers.contains(layer)) {
			multiInputLayers.remove(layer);
		}
		if(singleInputLayers.contains(layer)) {
			singleInputLayers.remove(layer);
		}
	}
	
	
	
	public static Layer genLayer(Random rand) {
		init();
	    String layer = layers.get(rand.nextInt(layers.size()));
	    return layerGenMap.get(layer).generateLayer(rand, layer, null,null);
	}
	
	public static Layer genLayer(Random rand, String layer) {
		init();
		if(!layerGenMap.containsKey(layer)) {
			System.out.println(layer + " not found in generator map!");
		}
		return layerGenMap.get(layer).generateLayer(rand, layer, null,null);
	}
	
	public static Layer genLayer(Random rand, List<String> options) {
		init();
		String layer = options.get(rand.nextInt(options.size()));
		if(!layerGenMap.containsKey(layer)) {
			System.out.println(layer + " not found in generator map!");
		}
		return layerGenMap.get(layer).generateLayer(rand, layer, null,null);
	}
	
	public static Layer genLayer(Random rand, List<String> options, List<Integer> inputShap) {
		init();
		Layer l = null;
		do {
			String layer = options.get(rand.nextInt(options.size()));
			if(!layerGenMap.containsKey(layer)) {
				System.out.println(layer + " not found in generator map!");
			}
			l = layerGenMap.get(layer).generateLayer(rand, layer, inputShap,null);
		} while(l == null || l.getInputShape() == null);
		return l;
	}
	
	public static Layer genLayer(Random rand, String layer, List<Integer> inputShape) {

	    return genLayer(rand, layer, inputShape,null);
	}
	
	public static Layer genLayer(Random rand, String layer, List<Integer> inputShape, LinkedHashMap<String, Object> config) {
		return genLayer(rand, layer, inputShape, config, true);
	}
	public static Layer genLayer(Random rand, String layer, List<Integer> inputShape, LinkedHashMap<String, Object> config, boolean showWarning) {
		init();
		if(!layerGenMap.containsKey(layer)) {
			if(showWarning) {
				System.out.println(layer + " not found in generator map!");
			}
			return null;
		}
	    return layerGenMap.get(layer).generateLayer(rand, layer, inputShape,config);
	}
	
	
	public static Layer genGraphLayer(Random rand, int level, List<Integer> inputShape) {
		init();
		String layer = "";
//		if(level < 3) {
//			//if(rand.nextInt(11) > 2) {
//			if(rand.nextBoolean()) {
//				layer = multiInputLayers.get(rand.nextInt(multiInputLayers.size()));
//			}
//			else {
//				layer = singleInputLayers.get(rand.nextInt(singleInputLayers.size()));
//			}
//		}
//		else 
		if(rand.nextBoolean() && multiInputLayers.size() > 0) {//if(rand.nextInt(11) > 5){
			layer = multiInputLayers.get(rand.nextInt(multiInputLayers.size()));
		}
		else {
			layer = singleInputLayers.get(rand.nextInt(singleInputLayers.size()));
		}
		Layer l = layerGenMap.get(layer).generateLayer(rand, layer, inputShape,null);
		
		//System.out.println("asdf"+layer);
		//System.out.println(l.toString());
		if(l != null) {
			l.initUniqueName(rand);
		}
		return l;
	}
	
	
	public static Layer genLayer(Random rand, String name, String layer, List<Integer> inputShape, LinkedHashMap<String, Object> config, Object weights, Object bias) {
		init();
		if(!layerGenMap.containsKey(layer)) {
			
			int dimensions = inputShape == null ? 0 :  inputShape.size() -1; 
			if(layerGenMap.containsKey(layer+dimensions+"D")){
				layer = layer+dimensions+"D";
			}
			else {
				Layer l = new PlaceHolderLayer(layer,inputShape,new LinkedHashMap<>());
				l.setInputShape(inputShape);
				l.setUniqueName(name);
				//l.setParams(config);
				return l;
			}
		}
		System.out.println(layer+" "+ name);
		Layer l = layerGenMap.get(layer).generateLayer(rand, layer,null,null);//, inputShape);//,config);
		l.setUniqueName(name);
//		if(weights != null) {
//			((NodeLayer)l).setInputWeights(weights);
//			((NodeLayer)l).setOutputWeights(bias);
//		}
	    return l;
	}
	
	public static Layer genLayer(Random rand, String layer, List<Integer> inputShape, LinkedHashMap<String, Object> config, Object weights, Object bias) {
		init();
		if(!layerGenMap.containsKey(layer)) {
			int dimensions = inputShape == null ? 0 :  inputShape.size() -1; 
			if(layerGenMap.containsKey(layer+dimensions+"D")){
				layer = layer+dimensions+"D";
			}
			else if(layerNameAliase.containsKey(layer.toLowerCase())) {
				layer = layerNameAliase.get(layer.toLowerCase());
			}
			else {
				System.err.println(layer + " not found");
				Layer l = new PlaceHolderLayer(layer,inputShape,new LinkedHashMap<>());
				l.setInputShape(inputShape);
				//l.setParams(config);
				return l;
			}
		}
		System.out.println(layer+  " "+"found");
		Layer l = layerGenMap.get(layer).generateLayerwithDefaultValues(rand, layer,inputShape,config);//, inputShape);//,config);
		if(weights != null) {
			if(l instanceof EmbeddingLayer) {
				((EmbeddingLayer)l).setWeights(weights);
			}
			else {
				((NodeLayer)l).setInputWeights(weights);
			}
		}
		if(bias != null) {
			((NodeLayer)l).setOutputWeights(bias);
		}
		if(config.containsKey("recurrent_weights")) {
			((RecurrentLayer)l).setRecurrentWeights(config.get("recurrent_weights"));
		}
		if(config.containsKey("weights1")) {
			((NodeLayer)l).setInputWeights1(config.get("weights1"));
		}
		
		
	    return l;
	}
}
