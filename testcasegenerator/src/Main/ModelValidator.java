package Main;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import layer.*;
import util.Config;
import util.GenUtils;
import util.ListHelper;
import util.ModelError;
import util.ScriptProlog;

public class ModelValidator {
	public List<LayerGraph> findFixes(Random r, LayerGraph oriLG, Map<String,ModelError> errors, int maxFixTries) {
		//Map<String,Object> lastlastInput = new HashMap<>(lastInput);
		int maxFixes =5;
		List<LayerGraph> ret = new ArrayList<>();
		Map<String,ModelError> lastErrors = new HashMap<>(errors);
		for (String location : errors.keySet()) {
			
			ModelError e = errors.get(location);
			Layer l = oriLG.graphLayerMap.get(location);
			if(Config.ShowDebugInfo) {
				System.out.println("########################################################################################");
				System.out.println("TryFix " + location + " -- " + e.toString());
				System.out.println("########################################################################################");
			}
			if(l == null) {
				if(Config.ShowDebugInfo) {
				System.out.println("########################################################################################");
				System.out.println("Layer " + location + "not found for " + e.toString());
				System.out.println("########################################################################################");}
			}
			
			if(e.getMessage().startsWith("Dimension error") || e.getMessage().startsWith("Inconsistent Input Dimensions")) {
				ret.addAll(fixDimensionError(r,oriLG, l, e,true));
			}
			else if(e.getMessage().startsWith("Inconsistent Input Shapes")) {
				ret.addAll(fixInconsistenInputShapes(r, oriLG, l, e,true,false));
			}
			else if(e.getMessage().startsWith("Pool Shape Error")){
				while(maxFixes-- > 0) {
					ret.addAll(fixPoolShapeError(r, oriLG, l, e));
				}
			}
			else if(e.getMessage().startsWith("Argument Error") || e.getMessage().startsWith("Cropping Error")) {
				while(maxFixes-- > 0) {
					ret.addAll(fixArgumentError(r, oriLG, l, e));
				}
			}
			else if(e.getMessage().startsWith("Dot Axis Error")){
				while(maxFixes-- > 0) {
					ret.addAll(fixDotAxisError(r, oriLG, l, e));
				}
			}
			else {	
				System.out.println("TryFix " + location + " -- " + e.toString());
				return ret;
			}
		}
		return ret;
	}



	public List<LayerGraph> fixDimensionError(Random r, LayerGraph oriLG, Layer l, ModelError e, boolean avoidParentArgRegeneration){
		List<LayerGraph> ret = new ArrayList<>();
		List<Integer> newShape = null;
		List<Integer> shape = e.getInputShape();
		LayerGraph lgn = (LayerGraph)oriLG.copy();
		l = lgn.graphLayerMap.get(l.getName());

		Layer newLayer = null;
		if(l.getName().endsWith("1D") && e.getBadness() > 0){
			Layer lNew = GenUtils.genLayer(r,l.getName().replace("1D", "2D"),shape);
			lgn.replaceLayer(r, l, lNew);
			ret.add(lgn);
		}
		else if(l.getName().endsWith("2D") && e.getBadness() > 0){
			Layer lNew = GenUtils.genLayer(r,l.getName().replace("2D", "3D"),shape);
			lgn.replaceLayer(r, l, lNew);
			ret.add(lgn);
		}
		else if(l.getName().endsWith("2D") && e.getBadness() < 0){
			Layer lNew = GenUtils.genLayer(r,l.getName().replace("2D", "1D"),shape);
			lgn.replaceLayer(r, l, lNew);
			ret.add(lgn);
		}
		else if(l.getName().endsWith("3D") && e.getBadness() < 0){
			Layer lNew = GenUtils.genLayer(r,l.getName().replace("3D", "2D"),shape);
			lgn.replaceLayer(r, l, lNew);
			ret.add(lgn);
		}
		
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
		}
		else {
			newLayer = GenUtils.genLayer(r,"Flatten");
			newLayer.setInputShape(shape);
		}
		LayerGraph lgn1 = (LayerGraph)oriLG.copy();
		lgn1.insertLayerBefore(r,l,newLayer);
		if(!avoidParentArgRegeneration) {
			lgn1.regenerateLayerArgs(r, newLayer.getParentLayer(), newShape);
		}
		ret.add(lgn);
		return ret;
	}
	

	private List<LayerGraph> fixInconsistenInputShapes(Random r, LayerGraph oriLG, Layer l, ModelError e, boolean avoidParentArgRegeneration, boolean onlyFirstItemConcatenate) {
		List<LayerGraph> ret = new ArrayList<>();
		boolean isConcatenate = false;
		List<Integer> newShape = null;
		LayerGraph lgn = (LayerGraph)oriLG.copy();
		l = lgn.graphLayerMap.get(l.getName());
//		String tempShape = e.getMessage().split(", Input Shape")[1].trim();
//		//System.out.println(tempShape);
//		tempShape = tempShape.replace("[", "").replace("]", "");
//		if(Config.ShowDebugInfo) {System.out.println(tempShape);}
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
			newLayer.getParams().put("padding", size);
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
			newLayer.getParams().put("padding", size);
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
			newLayer.getParams().put("padding", size);
		}
		else {
			isConcatenate = true;
			newLayer = GenUtils.genLayer(r,"Concatenate");
			//System.out.println("############################################ diff at "+ (diff.size()-1) + ": " + diff.get(diff.size()-1)+ " biggestDiffDim "+ biggestDiffDim);
			shape.set(shape.size()-1, Math.abs(diff.get(diff.size()-1)));
			newShape.set(newShape.size()-1,expectedShape.get(expectedShape.size()-1));//newShape.get(newShape.size()-1)+diff.get(0));//(int)e.getBadness());
			newLayer.setInputShape(shape);
			newLayer.getParams().put("axis",""+(shape.size()));
			
			List<Integer> tempConcShape = new ArrayList<>(shape);
			tempConcShape.add(0, tempShape0);
			((MultiInputLayer)newLayer).setFixedInput(ListHelper.genList(r, tempConcShape));
		}
		newLayer.isNewlyAdded = true;
		
		lgn.insertLayerBefore(r,l,newLayer);
		if(!avoidParentArgRegeneration) {
			lgn.regenerateLayerArgs(r, newLayer.getParentLayer(), newShape);
		}	
		ret.add(lgn);
		return ret;
	}
	
	private List<LayerGraph> fixPoolShapeError(Random r, LayerGraph oriLG, Layer l, ModelError e) {
		List<LayerGraph> ret = new ArrayList<>();
		LayerGraph lgn = (LayerGraph)oriLG.copy();
		l = lgn.graphLayerMap.get(l.getName());
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
//				regenerateLayerArgs(r,l,e.getInputShape());
//			}
//		}
		
		lgn.regenerateLayerArgs(r, l,e.getInputShape());
		ret.add(lgn);
		return ret;
	}
	
	private List<LayerGraph> fixArgumentError(Random r, LayerGraph oriLG, Layer l, ModelError e) {
		List<LayerGraph> ret = new ArrayList<>();
		LayerGraph lgn = (LayerGraph)oriLG.copy();
		l = lgn.graphLayerMap.get(l.getName());
//		String tempShape = e.getMessage().split(", Input Shape")[1].trim();
//		//System.out.println(tempShape);
//		tempShape = tempShape.replace("[", "").replace("]", "");
//		if(Config.ShowDebugInfo) {System.out.println(tempShape);}
//		List<Integer> shape = new ArrayList<>();
//		String[] tempShapeParts = tempShape.split(",");
//		for (int i1 = 0; i1 < tempShapeParts.length; i1++) {
//			shape.add(Integer.parseInt(tempShapeParts[i1]));
//		}
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
		lgn.regenerateLayerArgs(r,l,shape);
		ret.add(lgn);
		return ret;
	}
	
	private List<LayerGraph> fixDotAxisError(Random r, LayerGraph oriLG, Layer l, ModelError e) {
		List<LayerGraph> ret = new ArrayList<>();
		LayerGraph lgn = (LayerGraph)oriLG.copy();
		l = lgn.graphLayerMap.get(l.getName());
//		String tempShape = e.getMessage().split(", Input Shape")[1].trim();
//		//System.out.println(tempShape);
//		tempShape = tempShape.replace("[", "").replace("]", "");
//		if(Config.ShowDebugInfo) {System.out.println(tempShape);}
//		List<Integer> shape = new ArrayList<>();
//		String[] tempShapeParts = tempShape.split(",");
//		
//		for (int i1 = 0; i1 < tempShapeParts.length; i1++) {
//			shape.add(Integer.parseInt(tempShapeParts[i1]));
//		}
//		shape.remove(0);
		List<Integer> shape = e.getInputShape();
		if(e.getBadness() == 99999){
			lgn.regenerateLayerArgs(r,l,shape);
			ret.add(lgn);
			return ret;
		}

		ret = fixInconsistenInputShapes(r,lgn, l,e,true,true);
		lgn.regenerateLayerArgs(r,l,shape);
		ret.add(lgn);
		return ret;
	}
	
}
