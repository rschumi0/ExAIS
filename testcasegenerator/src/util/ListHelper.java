package util;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

import org.bytedeco.onnx.TensorProto;

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
		DecimalFormat df = new DecimalFormat("#.####");
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
		DecimalFormat df = new DecimalFormat("#.####");
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
		List<Integer> shape = getShape(o);
		Object tmpO = flatten(o);
		Collections.reverse(shape);
		dataIndex = 0;
		return buildObjectArrayStructue(shape,(Object[])tmpO);
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
}
