package gen;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.Layer;
import layer.LayerGraph;
import layer.MultiInputLayer;
import layer.TwoInputLayer;
import util.GenUtils;

public class GraphGen extends Gen {

	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape,
			LinkedHashMap<String, Object> config) {
		Layer root;
		layerCount = 0;
		if(config != null && !config.isEmpty() && config.containsKey("maxCount"))
		{
			root = recursiveGeneration(rand,0, 10, (int)config.get("maxCount"),inputShape);
		}
		else if(config != null && !config.isEmpty() && config.containsKey("maxLevel"))
		{
			root = recursiveGeneration(rand,0, (int)config.get("maxLevel"),inputShape);
		}
		else {
			root = recursiveGeneration(rand,0, 6,inputShape);
		}
		LayerGraph lg = new LayerGraph(root);
		return  lg;
		
	}
	public Layer recursiveGeneration(Random rand, int level, List<Integer> inputShape) {
		return recursiveGeneration(rand, level, 6, 0, inputShape);
	}
	
	public Layer recursiveGeneration(Random rand, int level, int maxLevel, List<Integer> inputShape) {
		return recursiveGeneration(rand, level, maxLevel, 0, inputShape);
	}
	
	private static int layerCount = 0;
	public Layer recursiveGeneration(Random rand, int level, int maxLevel, int maxCount, List<Integer> inputShape) {
		Layer l = null;
			
//		if(maxCount != 0) {
//			System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "+ maxCount +" " + layerCount);
//			if(layerCount < maxCount){
//				layerCount++;
//				do {
//					l = GenUtils.genGraphLayer(rand, level,inputShape);
//				}while(l == null);
//				
//			}
//			else {
//				return null;
//			}
//		}
		if(rand.nextInt(maxLevel-1) + level < maxLevel) {
		//if(level < maxLevel) {
			layerCount++;
			do {
				l = GenUtils.genGraphLayer(rand, level,inputShape);
			}while(l == null);
			
		}
		else {
			return null;
		}
		
		ArrayList<Layer> children = new ArrayList<>();
		if(l instanceof TwoInputLayer) {
			Layer l1 = recursiveGeneration(rand,level+1,maxLevel,maxCount,inputShape);
			Layer l2 = recursiveGeneration(rand,level+1,maxLevel,maxCount,inputShape);
			if(l1 != null) {
				l1.setParentLayer(l);
				children.add(l1);
				if(l2 != null) {
					l2.setParentLayer(l);
					children.add(l2);	
				}
				else {
					children.clear();
				}
			}
		}
		else if(l instanceof MultiInputLayer)
		{
			int ChildNumber = 2;//rand.nextInt(3)+2;
			for(int i = 0; i < ChildNumber;i++) {
				Layer l1 = recursiveGeneration(rand,level+1,maxLevel,maxCount,inputShape);
				if(l1 != null) {
					l1.setParentLayer(l);
					children.add(l1);
				}
				else {
					children.clear();
					break;
				}
			}
		}
		else {
			Layer l1 = recursiveGeneration(rand,level+1,maxLevel,maxCount,inputShape);
			if(l1 != null) {
				l1.setParentLayer(l);
				children.add(l1);
			}
		}
		l.setChildLayers(children);
		return l;
	}

}
