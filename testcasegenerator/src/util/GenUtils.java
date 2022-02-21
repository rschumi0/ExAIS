package util;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import gen.Gen;
import gen.MultiInputGen;
import gen.TwoInputGen;
import layer.Layer;
import layer.NodeLayer;
import layer.PlaceHolderLayer;

public class GenUtils {

	public static Map<String,Gen> layerGenMap = new HashMap<>();
	public static List<String> layers = null;
	
	public static List<String> multiInputLayers = new ArrayList<String>();
	public static List<String> singleInputLayers = new ArrayList<String>();
		
	public static Map<String,String> dimensionLayerMap = new HashMap<>();
	public static Map<String,String> layerNameAliase = new HashMap<>();
	
	public static int regenerationCounter = 0;
	public static int totalFixIterations = 0;
	
	
	public static boolean initilised = false;
	public static void init() {
		if(!initilised) {
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
			}
			initilised = true;
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
		init();
		if(!layerGenMap.containsKey(layer)) {
			System.out.println(layer + " not found in generator map!");
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
		if(rand.nextBoolean()) {//if(rand.nextInt(11) > 5){
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
			else if(layerNameAliase.containsKey(layer)) {
				layer = layerNameAliase.get(layer);
			}
			else {
				System.out.println(layer + " not found");
				Layer l = new PlaceHolderLayer(layer,inputShape,new LinkedHashMap<>());
				l.setInputShape(inputShape);
				//l.setParams(config);
				return l;
			}
		}
		System.out.println(layer+  " "+"found");
		Layer l = layerGenMap.get(layer).generateLayerwithDefaultValues(rand, layer,null,config);//, inputShape);//,config);
		if(weights != null) {
			((NodeLayer)l).setInputWeights(weights);
			((NodeLayer)l).setOutputWeights(bias);
		}
		
	    return l;
	}
}
