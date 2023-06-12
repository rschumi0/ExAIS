package util;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Random;
import java.util.Set;

import org.bytedeco.javacpp.indexer.IntArrayIndexer;
import org.bytedeco.onnx.TensorProto;

import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;

public class ListHelper {
	static String sep = ",";
	
	public static Object parseList(String list) {
		
		list = list.trim().replace("\n", "").replace("\r", "").replace(" ", "");
		if(list.startsWith("[")){
			list = list.substring(1, list.length()-1);
			list = list.trim();
		}
		else {
			System.out.print("Invalid list input!!!");
			return null;
		}
		index = 0;
		if(!list.contains("[")){
			Object[] tmp = (Object[]) recursiveParse("["+list+"]");
			if(tmp.length == 0) {
				return tmp;
			}
			return tmp[0];
		}
		return recursiveParse(list);
	}
	
	private static int index = 0;
	
	public static Object recursiveParse(String p) {
		List<Object> list = new ArrayList<Object>();
		while(index < p.length()) {
			String p1 = p.substring(index);
			if(p1.startsWith("[")) {
				//p = p.substring(1, p.length());
				index++;
				list.add(recursiveParse(p));
			}
			else if(p1.startsWith("]")){
				//p = p.substring(1,p.length());
				index++;
				break;
			}
			else if(p1.startsWith(sep)){
				//p = p.substring(1,p.length());
				index++;
			}
			else{
				if(p1.contains(sep)) {
					int index2;
					if(p1.contains("]")){
						index2 = Math.min(p1.indexOf(sep), p1.indexOf("]"));
					}
					else {
						index2 = p1.indexOf(sep);
					}
					try {
						list.add(Double.parseDouble(p1.substring(0,index2).trim()));
					}catch (Exception e) {
						System.err.println("Error parsing: " + p1.substring(0,index2).trim());
						throw e;
						// TODO: handle exception
					}
					index += index2;
				}
				else if(p.contains("]"))
				{
					int index2 = p1.indexOf("]");
					try {
						list.add(Double.parseDouble(p1.substring(0,index2).trim()));
					}catch (Exception e) {
						System.err.println("Error parsing: " + p1.substring(0,index2).trim());
						throw e;
						// TODO: handle exception
					}
					//p = p.substring(p.indexOf("]"));
					index += index2;
				}
				else {
					System.out.println("Shouldn't happen!!! "  + p);
					return null;
				}

			}
		}
		return (Object)list.toArray();
	}
	
	public static boolean compareLists(Object o1, Object o2) {
		if(o1 instanceof Object[])
		{
			if(o2 instanceof Object[])
			{
				if(((Object[])o1).length == ((Object[])o2).length) {
					for (int i = 0; i < ((Object[])o1).length; i++) {
						if(!compareLists(((Object[])o1)[i], ((Object[])o2)[i])) {
							return false;
						}
						
					}
					return true;
				}
				else {
					return false;
				}
			}
			else {
				return false;
			}
		}
		else if(o1 instanceof Double){
			if(o2 instanceof Double) {
				//System.out.println(o1 + " "+ o2 + " "+(Math.abs(((Double)o1)-((Double)o2)) <  0.01));
				return (Math.abs(((Double)o1)-((Double)o2)) <  0.01);
			}
			else {
				return false;
			}
		}
		else if(o1 == null && o2 != null) {
			return false;
		}
		else if(o1 != null && o2 == null) {
			return false;
		}
		
		return true;
	}
	public static String printList(Object o) {
		return printList(o,false);
	}
	public static String printListWithoutEncapsulation(Object o) {
		String inStr = printList(o,false);
		if(inStr.startsWith("[")){
			inStr = inStr.substring(1, inStr.length()-1);
			inStr = inStr.trim();
		}
		return inStr;
	}
	public static String printList(Object o, boolean encapsulateAtoms) {
		String ret = "";
		//DecimalFormat df = new DecimalFormat("#.####");
		DecimalFormat df = new DecimalFormat("#.##################");
		df.setRoundingMode(RoundingMode.CEILING);
		if(o instanceof Object[]) {
			ret += "[";
			for (int i = 0; i < ((Object[])o).length; i++) {
				ret += printList(((Object[])o)[i],encapsulateAtoms) + ", ";
			}
			if(((Object[])o).length >0) {
				ret = ret.substring(0,ret.length()-2);
			}
			ret += "]";
		}
		else if(o instanceof Double) {
			if(encapsulateAtoms) {
				//ret += "["+(Math.round(((Double)o).doubleValue()*1000.0)/1000.0)+"]";
				ret += "[" + df.format((Double)o)+"]";
			}
			else {
				//ret += (Math.round(((Double)o).doubleValue()*1000.0)/1000.0);
				ret += df.format((Double)o);
			}
		}
		else if(o instanceof Integer) {
			if(encapsulateAtoms) {
				ret += "["+((Integer)o).toString()+"]";
			}
			else {
				ret += ((Integer)o).toString();
			}
		}
		else if(o instanceof Boolean) {
			if(encapsulateAtoms) {
				ret += "["+((Boolean)o).toString()+"]";
			}
			else {
				ret += ((Boolean)o).toString();
			}
		}if(o instanceof String) {
			if(encapsulateAtoms) {
				ret += "[" + o+"]";
			}
			else {
				//ret += (Math.round(((Double)o).doubleValue()*1000.0)/1000.0);
				ret += ""+o;
			}
		}
		return ret;
	}

	public static String printWeightList(Object o, boolean encapsulateAtoms) {
		String ret = "";
		//DecimalFormat df = new DecimalFormat("#.####");
		DecimalFormat df = new DecimalFormat("#.##################");
		df.setRoundingMode(RoundingMode.CEILING);
		if(o instanceof Object[]) {
			ret += "";
			for (int i = 0; i < ((Object[])o).length; i++) {
				ret += printList(((Object[])o)[i],encapsulateAtoms) + ", ";
			}
			if(((Object[])o).length > 0) {
				ret = ret.substring(0,ret.length()-2);
			}
			ret += "";
		}
		return ret;
	}

	
	public static Object genListandAddDefaultDim(Random r, List<Integer> dimensions)
	{
		dimensions = new ArrayList<>(dimensions);
		dimensions.add(0, 1);
		return genList(r,"double",dimensions,null);
	}
	public static Object genListandAddDefaultDim1(Random r, List<Integer> dimensions)
	{
		dimensions = new ArrayList<>(dimensions);
		dimensions.add(1);
		return genList(r,"double",dimensions,null);
	}
	
	public static Object genList(Random r, List<Integer> dimensions)
	{
		return genList(r,"double",dimensions,null);
	}
	public static Object genList(Random r, List<Integer> dimensions,Integer defaultValue)
	{
		return genList(r,"double",dimensions,defaultValue);
	}
	public static Object genList(Random r, String type, List<Integer> dimensions, Integer defaultValue)
	{
		ArrayList<Object> list = new ArrayList<Object>();
		dimensions = new ArrayList<>(dimensions);
		if(dimensions.size() == 1){
			for(int i = 0; i < dimensions.get(0);i++) {
				switch (type) {
				case "int": list.add((defaultValue == null) ? (Object)r.nextInt() : (Object)defaultValue);
					break;
				case "boolean": list.add((defaultValue == null) ? (Object)r.nextInt() : (Object)(defaultValue.intValue() > 0));
					break;
				case "double": list.add((defaultValue == null) ? (Object)r.nextDouble() : (Object)((double)defaultValue.intValue()));
					break;
				default: list.add((defaultValue == null) ? (Object)r.nextDouble() : (Object)((double)defaultValue.intValue()));
					break;
				}
			}
		}
		else {
			int d0 = dimensions.get(0);
			dimensions.remove(0);
			for(int i = 0; i < d0;i++) {
				list.add(genList(r, type, dimensions,defaultValue));
			}
		}
		return (Object)list.toArray();
	}
	public static Object genList(Random r, List<Integer> dimensions,int min,int max)
	{
		return genListMinMax(r,"double",dimensions,min,max);
	}
	
	public static Object genListandAddDefaultDim(Random r, List<Integer> dimensions,int min,int max)
	{
		dimensions = new ArrayList<>(dimensions);
		dimensions.add(0, 1);
		return genList(r,"int",dimensions,min,max);
	}
	
	public static Object genList(Random r, String type, List<Integer> dimensions,int min,int max)
	{
		return genListMinMax(r,type,dimensions,min,max);
	}
	
	
	public static Object genListMinMax(Random r, String type, List<Integer> dimensions, int min, int max)
	{
		ArrayList<Object> list = new ArrayList<Object>();
		dimensions = new ArrayList<>(dimensions);
		if(dimensions.size() == 1){
			for(int i = 0; i < dimensions.get(0);i++) {
				switch (type) {
				case "int": list.add(r.nextInt((max - min) + 1) + min);
					break;
				case "double": list.add((double)min + ((double)max - min) * r.nextDouble());
					break;
				default: list.add((double)min + ((double)max - min) * r.nextDouble());
					break;
				}
			}
		}
		else {
			int d0 = dimensions.get(0);
			dimensions.remove(0);
			for(int i = 0; i < d0;i++) {
				list.add(genListMinMax(r, type, dimensions,min,max));
			}
		}
		return (Object)list.toArray();
	}
	
	public static List<Integer> getShape(Object o){
		List<Integer> shapes = new ArrayList<>();
		while(o instanceof Object[])
		{
			shapes.add(((Object[])o).length);
			
			if(((Object[])o).length > 0) {
				o = ((Object[])o)[0];
			}
			
		}
		return shapes;
	}
	public static String getShapeString(List<Integer> o){
		return Arrays.toString(o.toArray());
	}
	public static String getShapeString(Object o){
		return Arrays.toString(getShape(o).toArray());
	}
	public static int getDimensions(Object o){
		return getShape(o).size();
	}
	
	public static Object flatten(Object o) {
		List<Object> res = new ArrayList<Object>();
		for (Object o1 : (Object[])o) {
			if(o1 instanceof Object[])
			{
				Object[] o2 = (Object[])flatten(o1);
				for (Object o3 : o2) {
					res.add(o3);
				}
			}
			else {
				res.add(o1);
			}
		}
		return res.toArray();
	}
	
	public static Object transposeList(Object o) {
//		List<Integer> shape = getShape(o);
//		Object tmpO = flatten(o);
//		Collections.reverse(shape);
//		dataIndex = 0;
//		return buildObjectArrayStructue(shape,(Object[])tmpO);
		int dim = getDimensions(o);
		if(dim <= 1) {
			return o;
		}
		if(dim == 2) {
			return transpose2D((Object[])o);
		}
		if(getDimensions(o) == 3) {
			o = transpose2D((Object[]) o);
			for(int i = 0; i < ((Object[])o).length; i++) {
				((Object[])o)[i] = transpose2D((Object[]) ((Object[])o)[i]);
			}
			return transpose2D((Object[]) o);
		}
		if(getDimensions(o) == 4) {
			o = transpose2D((Object[]) o);
			for(int i = 0; i < ((Object[])o).length; i++) {
				((Object[])o)[i] = transpose2D((Object[]) ((Object[])o)[i]);
				for(int j = 0; j < ((Object[])((Object[])o)[i]).length; j++) {
					((Object[])((Object[])o)[i])[j] = transpose2D((Object[]) ((Object[])((Object[])o)[i])[j]);
				}
			}
			o = transpose2D((Object[]) o);
			for(int i = 0; i < ((Object[])o).length; i++) {
				((Object[])o)[i] = transpose2D((Object[]) ((Object[])o)[i]);
			}
			o = transpose2D((Object[]) o);
			return o;
		}
		return o;
	}
	
	public static Object transpose2D(Object[] o) {
		if(o.length == 0) {
			return o;
		}
	    int nRows = o.length;
	    int nCols = ((Object[])o[0]).length;
	    Object[] transpose = new Object[nCols];
	    for (int i = 0; i < nCols; i++) {
	    	transpose[i]= new Object[nRows];
	    }
	    for (int i = 0; i < nRows; i++) {
	        for (int j = 0; j < nCols; j++) {
	        	((Object[])transpose[j])[i] = ((Object[])o[i])[j];
	        }
	    }
	    return transpose;
	}
	
//	public static Object transpose3D(Object[] o) {
//		if(o.length == 0) {
//			return o;
//		}
//	    int d1 = o.length;
//	    int d2 = ((Object[])o[0]).length;
//	    int d3 = ((Object[])((Object[])o[0])[0]).length;
//	    Object[] transpose = new Object[d2];
//	    for (int i = 0; i < d2; i++) {
//	    	transpose[i]= new Object[d3];
//	        for (int j = 0; j < d1; j++) {
//	        	((Object[])transpose[i])[j] = new Object[d1];
//	        }
//	    }
//	   for (int i = 0; i < d2; i++){
//		    for(int j = 0; j < d1; j++){
//		        for (int k = 0; k < d3; k++){
//		        	 Object[] o1 = (Object[])o[j];
//		        	 Object v = ((Object[])o1[i])[k];
//		        	 System.out.print(v + " ");
//		        	 //((Object[])((Object[])transpose[i])[j])[k] = v;
//		        }
//		        System.out.print(" # ");
//		    }
//		    System.out.println();
//		}
//	    return transpose;
//	}
	

	
	
	
	public static Object reshapeList(List<Integer> shape, Object data) {
		data = flatten(data);
		dataIndex = 0;
		return buildObjectArrayStructue(shape, (Object[]) data);
	}
	
    private static int dataIndex = 0;
    private static Object buildObjectArrayStructue(List<Integer> shape, Object[] data) {
		ArrayList<Object> list = new ArrayList<Object>();
		ArrayList<Integer> dimensions = new ArrayList<>(shape);
		if(dimensions.size() == 1){
			for(int i = 0; i < dimensions.get(0);i++) {
				list.add(data[dataIndex++]);
			}
		}
		else {
			int d0 = dimensions.get(0);
			dimensions.remove(0);
			for(int i = 0; i < d0;i++) {
				list.add(buildObjectArrayStructue(dimensions,data));
			}
		}
		return (Object)list.toArray();
    }
    
    public static Object[] getInnerMostList(Object o) {
    	if(o instanceof Object[] ) {
    		if(((Object[])o)[0] instanceof Object[]) {
    			return getInnerMostList((Object)((Object[])o)[0]);
    		}
    		else {
    			return (Object[])o;
    		}
    	}
    	return (Object[])o;
    }
    
    public static int getMaxIndex(Object[] o) {
    	int maxIndex = 0;
    	for (int i = 1; i < o.length; i++) {
			if(o[i] instanceof Integer  && (int)o[i] > (int)o[maxIndex]){
				maxIndex = i;
			}
			else if(o[i] instanceof Double  && (double)o[i] > (double)o[maxIndex]){
				maxIndex = i;
			}
			if(o[i] instanceof Float  && (float)o[i] > (float)o[maxIndex]){
				maxIndex = i;
			}
		}
    	return maxIndex;
    }
    
    public static Set<Integer> getTop3Index(Object[] o) {
    	Object[] to = o.clone();
    	if(o.length < 3) {
    		return null;
    	}
    	int maxIndex =getMaxIndex(to);
    	if(to[maxIndex] instanceof Integer) {
    		to[maxIndex] = Integer.MIN_VALUE;
    	}
    	else if(to[maxIndex] instanceof Double) {
    		to[maxIndex] = Double.MIN_VALUE;
    	}
    	else if(to[maxIndex] instanceof Float) {
    		to[maxIndex] = Float.MIN_VALUE;
    	}
    	int maxIndex1 =getMaxIndex(to);
    	if(to[maxIndex1] instanceof Integer) {
    		to[maxIndex1] = Integer.MIN_VALUE;
    	}
    	else if(to[maxIndex1] instanceof Double) {
    		to[maxIndex1] = Double.MIN_VALUE;
    	}
    	else if(to[maxIndex1] instanceof Float) {
    		to[maxIndex1] = Float.MIN_VALUE;
    	}
    	int maxIndex2 =getMaxIndex(to);
    	return new HashSet<>(Arrays.asList(maxIndex,maxIndex1,maxIndex2));
    }
    public static Object reverseList(Object l) {
    	ArrayList<Object> ret = new ArrayList<Object>(Arrays.asList((Object[])l));
    	
    	Collections.reverse(ret);
    	
    	return ret.toArray();
    }
    
    public static List<Integer> parseIntegerListString(String l){
    	List<Integer> list = new ArrayList<>();
    	if(l == null) {
    		return list;
    	}
    	l = l.replace("(", "").replace(")", "").replace("[", "").replace("]", "").replace("{", "").replace("}", "");
    	if(l.trim().isEmpty()) {
    		return list;
    	}
    	String[] listParts = l.split(",");
    	for (String i : listParts) {
			list.add(Integer.parseInt(i.trim()));
		}
    	return list;
    }
    
    public static int shapeProduct(List<Integer> shape) {
    	int prod = 1;
    	for (Integer integer : shape) {
			prod = prod * integer;
		}
    	return prod;
    }
    
    
    public static int estimateSize(Object o) {
    	if(o instanceof Map) {
    		o = ((Map<String,Object>)o).get(((Map<String,Object>)o).keySet().toArray()[0]);
    	}
    	List<Integer> shape = getShape(o);
    	int prod = shapeProduct(shape);
    	return prod * 4;
    }
}
