package Main;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import layer.*;
import util.Config;
import util.GenUtils;
import util.ListHelper;
import util.ModelError;
import util.ScriptProlog;
import util.ScriptPython;

public class ModelRepairer {
	
	public static List<Layer> findFixes(Random r, LayerGraph oriLG, Map<String, ModelError> errors, int maxFixes) {
		List<Layer> fixes = new ArrayList<>();
		findFixes(r, oriLG, fixes, new ArrayList<>(), new ArrayList<>(), maxFixes, errors);
		return fixes;
	}
	public static int fixedIssueNumber = 0;
	
	public static void findFixes(Random r, LayerGraph oriLG, List<Layer>modelFixes, List<String> prologSrcs, List<Object> inputs, int maxFixes) {
		Map<String, ModelError> errors = new HashMap<String, ModelError>();
    	ScriptProlog.runScript(oriLG.toPrologString(oriLG.generateInput(r)), oriLG.getUniqueName(), errors);
    	if(errors.isEmpty()) {
    		return;
    	}
    	findFixes(r, oriLG, modelFixes, prologSrcs, inputs, maxFixes, errors);
	}
	
	public static void findFixes(Random r, LayerGraph oriLG, List<Layer>modelFixes, List<String> prologSrcs, List<Object> inputs, int maxFixes, Map<String, ModelError> errors) {
		if(errors == null) {
			errors = new HashMap<String, ModelError>();
	    	ScriptProlog.runScript(oriLG.toPrologString(oriLG.generateInput(r)), oriLG.getUniqueName(), errors);
	    	if(errors.isEmpty()) {
	    		//System.out.println();
	    		return;
	    	}
		}
		
		Set<Integer> prologModelHashes = new HashSet<Integer>();
		List<LayerGraph> fixes  = findPossibleFixes(r, oriLG, errors, maxFixes);
		//System.out.println("########################"+fixes.size() +" possible fixes found!");
		int j = 0;
		for (LayerGraph l : fixes) {
			Object in = l.generateInput(r);
			String prologSrc = l.toPrologString(in);
			//System.out.println(prologSrc);
			int hash = prologSrc.hashCode();
			if(!prologModelHashes.contains(hash)) {
				prologModelHashes.add(hash);
//		    	Map<String, ModelError> newErrors = new HashMap<String, ModelError>();
//		    	String expected = ScriptProlog.runScript(prologSrc, l.getUniqueName(), newErrors);
//		    	if(newErrors.isEmpty() && expected.contains("[")) {
//		    		modelFixes.add(l);
//		    		inputs.add(in);
//		    		prologSrcs.add(prologSrc);
//		    	}
//		    	l.validateGraph(r);
				Map<String, ModelError> newErrors = new HashMap<String, ModelError>();
				if(!modelWorks(r, l, newErrors)) {
					l = findFixWithMinimalChange(r, l, newErrors, maxFixes);
				}
				
				if(l != null) {
			    	in = l.generateInput(r);
		    		modelFixes.add(l);
		    		inputs.add(in);
		    		prologSrcs.add(l.toPrologString(in));
			    	ScriptPython.runScript(l.toTensorflowString(in));
				}
			}
			j++;
			if(fixes.size() == 2*maxFixes && j >= maxFixes && modelFixes.size()>0) {
				 break;
			}
			else if(fixes.size() == 3*maxFixes && j >= 2*maxFixes && modelFixes.size()>0) {
				 break;
			}
		}
	}
	
	public static boolean modelWorks(Random r, LayerGraph l, Map<String,ModelError> errors) {
		Object in = l.generateInput(r);
		String prologSrc = l.toPrologString(in);
		String expected = ScriptProlog.runScript(prologSrc, l.getUniqueName(), errors);
		//System.out.println("@@@@@@@@Expected Out "+ expected);
		if(errors.isEmpty() && !expected.contains("[")) {
			System.out.println("@@@@@@@@Expected Out "+ expected);
			System.out.println(l.toPrologString(in));
		}
		return (errors.isEmpty() && expected.contains("["));
	}
	
	private static LayerGraph closestFix(List<LayerGraph> fixes) {
		if(fixes.isEmpty())
		{
			return null;
		}
		LayerGraph smallestFix = fixes.get(0);
		for (LayerGraph f : fixes) {
			if(f.modelChangeIndicator < smallestFix.modelChangeIndicator) {
				smallestFix = f;
			}
		}
		return smallestFix;
	}
	
	
	public static LayerGraph findFixWithMinimalChange(Random r, LayerGraph oriLG, int maxFixes) {
		Map<String, ModelError> errors = new HashMap<String, ModelError>();
    	ScriptProlog.runScript(oriLG.toPrologString(oriLG.generateInput(r)), oriLG.getUniqueName(), errors);
    	if(errors.isEmpty()) {
    		System.out.println("Cannot fix Model with empty errors!!!!");
    		System.out.println();
    		return null;
    	}
    	return findFixWithMinimalChange(r, oriLG, errors, maxFixes);
	}
	

	public static LayerGraph findFixWithMinimalChange(Random r, LayerGraph oriLG, Map<String,ModelError> errors, int maxFixes) {
		int tempMaxFixes = maxFixes;
		if(errors.isEmpty()) {
			System.out.println("Cannot fix Model with empty errors!!!!");
			return null;
		}
		fixedIssueNumber++;
		
		//System.out.println("findFixWithMinimalChange " + errors.keySet().toArray()[0] + " -- " + errors.get(errors.keySet().toArray()[0] ).toString());
		List<LayerGraph> workingFixes = new ArrayList<>();
		do {
			
			//System.out.println("findFixWithMinimalChange findPossibleFixes called");
			List<LayerGraph> fixes = findPossibleFixes(r, oriLG, errors, maxFixes);
			//.out.println("findFixWithMinimalChange findPossibleFixes fixsize"+fixes.size());
			int j = 0;
			for (LayerGraph f : fixes) {
				Map<String,ModelError> newErrors = new HashMap<>();
				if(modelWorks(r, f, newErrors)) {
					workingFixes.add(f);
					//System.out.println("findFixWithMinimalChange "+"succesfully added!"+ " workingFixesSize"+ workingFixes.size());
				}
				else if(newErrors.isEmpty()) {
					//System.out.println(f.toPrologString(f.generateInput(r)));
					System.out.println("New Errors shouldn't be empty!!!!!");
				}
				else if(f.checkIfErrorIsBeforeLast((String)errors.keySet().toArray()[0],(String)newErrors.keySet().toArray()[0]) ||
						(errors.keySet().toArray()[0].equals(newErrors.keySet().toArray()[0]) && 
						 Math.abs(errors.get(errors.keySet().toArray()[0]).getBadness()) <= Math.abs(newErrors.get(newErrors.keySet().toArray()[0]).getBadness()))){
					//check if lastFix 
//					System.out.println(f.toPrologString(f.generateInput(r)));
//					System.out.println("newError " + newErrors.keySet().toArray()[0] + " -- " + newErrors.get(newErrors.keySet().toArray()[0] ).toString());
//					System.out.println("Fix made it worse!!!!!");
				}
				else if(newErrors.get(newErrors.keySet().toArray()[0]).getMessage().contains("Reshape Error") || newErrors.get(newErrors.keySet().toArray()[0]).getMessage().contains("Concatenate Error")) {
//					System.out.println("newError " + newErrors.keySet().toArray()[0] + " -- " + newErrors.get(newErrors.keySet().toArray()[0] ).toString());
//					System.out.println("Fix shouldn't cause reshape or Concatenate error!!!!!");
				}
				else {
					//System.out.println("newError " + newErrors.keySet().toArray()[0] + " -- " + newErrors.get(newErrors.keySet().toArray()[0] ).toString());
					if(!workingFixes.isEmpty()) {
						//System.out.println("findFixWithMinimalChange aborted");
						break;
					}
					//System.out.println("findFixWithMinimalChange "+"recursive Fix step!" + " workingFixesSize"+ workingFixes.size());
					LayerGraph fn = findFixWithMinimalChange(r,f,newErrors,maxFixes);
					//System.out.println("findFixWithMinimalChange "+"recursive Fix step finished!");
					Map<String,ModelError> newErrors1 = new HashMap<>();
					if(fn != null && modelWorks(r, fn, newErrors1)) {
						workingFixes.add(fn);
						//System.out.println("findFixWithMinimalChange "+"succesfully added after fix!"+" workingFixesSize"+ workingFixes.size());
					}
					else if(fn == null ){
						//System.out.println("findFixWithMinimalChange "+"after recursive Fix step: no Fix");
					}
					else {
						//System.out.println("findFixWithMinimalChange "+"after recursive Fix step: no Fix"+ " -- " + newErrors.get(errors.keySet().toArray()[0] ).toString());
					}
				}
				j++;
				if(fixes.size() == 2*maxFixes && j >= maxFixes && workingFixes.size()>0) {
					 break;
				}
				else if(fixes.size() == 3*maxFixes && j >= 2*maxFixes && workingFixes.size()>0) {
					 break;
				}
			}
			
		}while(workingFixes.isEmpty() && (tempMaxFixes--) > 0);
		//System.out.println("findFixWithMinimalChange before return");
		return closestFix(workingFixes);
	}
	
	public static List<LayerGraph> findPossibleFixes(Random r, LayerGraph oriLG, Map<String,ModelError> errors, int maxFixes) {
		//System.out.println("findPossibleFixes called");
		//Map<String,Object> lastlastInput = new HashMap<>(lastInput);
		List<LayerGraph> ret = new ArrayList<>();
		//Map<String,ModelError> lastErrors = new HashMap<>(errors);
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
			
			if(e.getMessage().startsWith("Dimension Error") || e.getMessage().startsWith("Inconsistent Input Dimensions")) {
				if(l instanceof MultiInputLayer) {
					while(maxFixes-- > 0) {
						ret.addAll(fixDimensionError(r,oriLG, l, e,false));
					}
				}
				else {
					ret.addAll(fixDimensionError(r,oriLG, l, e,false));
				}
			}
			else if(e.getMessage().startsWith("Inconsistent Input Shapes")) {
				if(l instanceof MultiInputLayer) {
					while(maxFixes-- > 0) {
						ret.addAll(fixInconsistenInputShapes(r, oriLG, l, e,false,false));
					}
				}
				else {
					ret.addAll(fixInconsistenInputShapes(r, oriLG, l, e,false,false));
				}
			}
			else if(e.getMessage().startsWith("Weight Dimension Error") || e.getMessage().startsWith("Pool Shape Error") || e.getMessage().startsWith("Weight Shape Error")){
				while(maxFixes-- > 0) {
					ret.addAll(fixPoolShapeError(r, oriLG, l, e));
				}
			}
			else if(e.getMessage().startsWith("Argument Error") || e.getMessage().startsWith("Cropping Error") || e.getMessage().contains("Dilation Error")) {
				//while(maxFixes-- > 0) {
					ret.addAll(fixArgumentError(r, oriLG, l, e,maxFixes));
				//}
			}
			else if(e.getMessage().startsWith("Dot Axis Error")){
				//while(maxFixes-- > 0) {
					//System.out.println("DOT Axis fixing: "+ maxFixes);
					ret.addAll(fixDotAxisError(r, oriLG, l, e));
				//}
			}
			else {	
				//System.out.println("TryFix " + location + " -- " + e.toString());
				return ret;
			}
		}
		return ret;
	}

	private static List<LayerGraph> fixDimensionError(Random r, LayerGraph oriLG, Layer l, ModelError e, boolean avoidParentArgRegeneration){
		if(Config.ShowDebugInfo) {
			System.out.println("########################################################################################");
			System.out.println("fixDimensionError");
			System.out.println("########################################################################################");
		}
		
		List<LayerGraph> ret = new ArrayList<>();
		List<Integer> newShape = null;
		List<Integer> shape = e.getInputShape();
		LayerGraph lgn = (LayerGraph)oriLG.copy();
		//System.out.println(l.getUniqueName());
		//System.out.println(Arrays.toString(lgn.graphLayerMap.keySet().toArray()));
		l = lgn.graphLayerMap.get(l.getUniqueName());
		
		if(l == null) {
			System.out.println("-----------------------------");
			System.out.println(oriLG.toArchitectureString());
			System.out.println("-----------------------------");
			System.out.println(lgn.toArchitectureString());
			System.out.println("-----------------------------");
		}

		Layer newLayer = null;
		
		
		if(l.getName().endsWith("1D")){
			Layer lNew = GenUtils.genLayer(r,l.getName().replace("1D", "2D"),null, null, false);
			
			if(lNew != null) {
				lNew.setUniqueName(l.getUniqueName());
				lgn.modelChangeIndicator += 10;
				lgn.replaceLayer(r, l, lNew);
				ret.add(lgn);
			}
			
			lgn = (LayerGraph)oriLG.copy();
			l = lgn.graphLayerMap.get(l.getUniqueName());
			lNew = GenUtils.genLayer(r,l.getName().replace("1D", "3D"),null,null, false);
			
			if(lNew != null) {
				lNew.setUniqueName(l.getUniqueName());
				lgn.modelChangeIndicator += 10;
				lgn.replaceLayer(r, l, lNew);
				ret.add(lgn);
			}
		}
		else if(l.getName().endsWith("2D")){
			Layer lNew = GenUtils.genLayer(r,l.getName().replace("2D", "1D"),null,null, false);
			
			if(lNew != null) {
				lNew.setUniqueName(l.getUniqueName());
				lgn.modelChangeIndicator += 10;
				lgn.replaceLayer(r, l, lNew);
				ret.add(lgn);
			}
			
			lgn = (LayerGraph)oriLG.copy();
			l = lgn.graphLayerMap.get(l.getUniqueName());
			lNew = GenUtils.genLayer(r,l.getName().replace("2D", "3D"),null,null, false);
			
			if(lNew != null) {
				lNew.setUniqueName(l.getUniqueName());
				lgn.modelChangeIndicator += 10;
				lgn.replaceLayer(r, l, lNew);
				ret.add(lgn);
			}
		}
		else if(l.getName().endsWith("3D")){
			Layer lNew = GenUtils.genLayer(r,l.getName().replace("3D", "2D"),null, null, false);
			
			if(lNew != null) {
				lNew.setUniqueName(l.getUniqueName());
				lgn.modelChangeIndicator += 10;
				lgn.replaceLayer(r, l, lNew);
				ret.add(lgn);
			}
			
			lgn = (LayerGraph)oriLG.copy();
			l = lgn.graphLayerMap.get(l.getUniqueName());
			lNew = GenUtils.genLayer(r,l.getName().replace("3D", "1D"),null, null, false);
			
			if(lNew != null) {
				lNew.setUniqueName(l.getUniqueName());
				lgn.modelChangeIndicator += 10;
				lgn.replaceLayer(r, l, lNew);
				ret.add(lgn);
			}
		}
		
		if(e.getBadness() < 0) {
			newLayer = GenUtils.genLayer(r,"Reshape");
			newLayer.setInputShape(shape);
			newShape = new ArrayList<>(shape);
			newShape.add(1);
			if(newShape.size() == 1) {
				newShape.add(1);
			}
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
		lgn = (LayerGraph)oriLG.copy();
		l = lgn.graphLayerMap.get(l.getUniqueName());
		lgn.insertLayerBefore(r,l,newLayer,true);
		lgn.modelChangeIndicator += 15;
		if(!avoidParentArgRegeneration) {
			lgn.regenerateLayerArgs(r, newLayer.getParentLayer(), newShape);
		}
		//System.out.println("##"+lgn.toPrologString(lgn.generateInput(r)));
		ret.add(lgn);
		return ret;
	}
	private static List<LayerGraph> fixInconsistenInputShapes(Random r, LayerGraph oriLG, Layer l, ModelError e, boolean avoidParentArgRegeneration, boolean onlyFirstItemConcatenate){
		return fixInconsistenInputShapes(r, oriLG, l, e, avoidParentArgRegeneration, onlyFirstItemConcatenate,false, 0);
	}
	
	private static List<LayerGraph> fixInconsistenInputShapes(Random r, LayerGraph oriLG, Layer l, ModelError e, boolean avoidParentArgRegeneration, boolean onlyFirstItemConcatenate,boolean setFixedChild, int childId) {
		if(Config.ShowDebugInfo) {
			System.out.println("########################################################################################");
			System.out.println("fixInconsistenInputShapes");
			System.out.println("########################################################################################");
		}
		List<LayerGraph> ret = new ArrayList<>();
		boolean isConcatenate = false;
		List<Integer> newShape = null;
		LayerGraph lgn = (LayerGraph)oriLG.copy();
		l = lgn.graphLayerMap.get(l.getUniqueName());
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
		
//		System.out.println("expected Shape parsed:" + Arrays.toString(expectedShape.toArray()));
//		System.out.println("input Shape parsed:" + Arrays.toString(e.getInputShape().toArray()));
//		for(int i1 = 0; i1 < diff.size(); i1++) {
//			System.out.println("%%%%%%%%%%%%%%%%%%%%%%% diff init "+ i1 + ": " + diff.get(i1) + " biggestDiffDim "+ biggestDiffDim + " shape.size: "+ shape.size());
//		}
		
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
		else if(shape.size() == 3 && biggestDiffDim>3){
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
		else if(shape.size() == 2 && biggestDiffDim>2){
//			for(int i1 = 0; i1 < diff.size(); i1++) {
//				System.out.println("############################################ diff at "+ i1 + ": " + diff.get(i1) + " biggestDiffDim "+ biggestDiffDim);
//			}
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
				//System.out.println("############################################ diff at "+ i1 + ": " + diff.get(i1) + " biggestDiffDim "+ biggestDiffDim);
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
			tempConcShape.add(0, tempShape0); //TODO Check this case!!!!!!!!!!!!!!!!!!!!
//			System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Case reached");
//			System.out.println("input shape "+ ListHelper.getShapeString(e.getInputShape(false)));
//			System.out.println("expected shape "+ListHelper.getShapeString(e.getExpectedShape(false)));
//			System.out.println("shape "+ ListHelper.getShapeString(shape));
//			System.out.println("newShape "+ListHelper.getShapeString(newShape));
//			System.out.println("tempConcShape "+ListHelper.getShapeString(tempConcShape));

			((MultiInputLayer)newLayer).setFixedInput(ListHelper.genList(r, tempConcShape));
		}
		newLayer.isNewlyAdded = true;
		if(l.getName().equals("Concatenate")) {
			lgn.modelChangeIndicator += 20;
		}
		else {
			lgn.modelChangeIndicator += 15;
		}
		lgn.insertLayerBefore(r,l,newLayer, true,setFixedChild,childId);
		if(!avoidParentArgRegeneration) {
			lgn.regenerateLayerArgs(r, newLayer.getParentLayer(), newShape);
		}	
		ret.add(lgn);
		return ret;
	}
	
	private static List<LayerGraph> fixPoolShapeError(Random r, LayerGraph oriLG, Layer l, ModelError e) {
		if(Config.ShowDebugInfo) {
			System.out.println("########################################################################################");
			System.out.println("fixPoolShapeError");
			System.out.println("########################################################################################");
		}
		List<LayerGraph> ret = new ArrayList<>();
		LayerGraph lgn = (LayerGraph)oriLG.copy();
		
		//System.out.println(lgn.toArchitectureString());
		
		l = lgn.graphLayerMap.get(l.getUniqueName());

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
		
		lgn.regenerateLayerArgs(r, l,e.getInputShape(),true);
		ret.add(lgn);
		lgn = (LayerGraph)lgn.copy();
		l = lgn.graphLayerMap.get(l.getUniqueName());
		lgn.regenerateLayerArgs(r, l,e.getInputShape());
		ret.add(lgn);
		return ret;
	}
	
	private static List<LayerGraph> fixArgumentError(Random r, LayerGraph oriLG, Layer l, ModelError e, int maxTries) {
		if(Config.ShowDebugInfo) {
			System.out.println("########################################################################################");
			System.out.println("fixArgumentError");
			System.out.println("########################################################################################");
		}
		List<LayerGraph> ret = new ArrayList<>();
		LayerGraph lgn = (LayerGraph)oriLG.copy();
		l = lgn.graphLayerMap.get(l.getUniqueName());
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
		
		if(l.getParams().size() > 1) {
			for (int i = 0; i < maxTries; i++) {
				lgn.regenerateSingleLayerArg(r,l,shape);
				ret.add(lgn); 
				
				lgn = (LayerGraph)lgn.copy();
				l = lgn.graphLayerMap.get(l.getUniqueName());
			}
			for (int i = 0; i < maxTries; i++) {
				lgn.regenerateTwoLayerArg(r,l,shape);
				ret.add(lgn); 
				
				lgn = (LayerGraph)lgn.copy();
				l = lgn.graphLayerMap.get(l.getUniqueName());
			}
		}
		for (int i = 0; i < maxTries; i++) {
			lgn.regenerateLayerArgs(r,l,shape);
			ret.add(lgn); 
			lgn = (LayerGraph)lgn.copy();
			l = lgn.graphLayerMap.get(l.getUniqueName());
		}

		return ret;
	}
	
	

	
	private static List<LayerGraph> fixDotAxisError(Random r, LayerGraph oriLG, Layer l, ModelError e) {
		if(Config.ShowDebugInfo) {
			System.out.println("########################################################################################");
			System.out.println("fixDotAxisError");
			System.out.println("########################################################################################");
		}
		List<LayerGraph> ret = new ArrayList<>();
		LayerGraph lgn = (LayerGraph)oriLG.copy();
		l = lgn.graphLayerMap.get(l.getUniqueName());
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

		ret.addAll(fixInconsistenInputShapes(r,lgn, l,e,true,true,true,0));
		ret.addAll(fixInconsistenInputShapes(r,lgn, l,e,true,true,true,1));
		lgn.regenerateLayerArgs(r,l,shape);
		ret.add(lgn);
		return ret;
	}
	
}
