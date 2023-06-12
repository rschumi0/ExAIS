package util;

import java.util.ArrayList;
import java.util.List;

public class ModelError {
	private String message;
	private long badness;
	private String expected;
	
	public ModelError(String message, long badness) {
		this.message = message;
		this.badness = badness;
		this.expected = "";
	}
	
	public ModelError(String message, long badness, String expected) {
		this.message = message;
		this.badness = badness;
		this.expected = expected;
	}
	
	public long getBadness() {
		return badness;
	}
	public void setBadness(long badness) {
		this.badness = badness;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
	public String toString() {
		return "Error " + message+ ", Badness: " + badness + ", Expected: "+this.getExpected();
	}
	
	public String toFormattedString(String location) {
		return "Model invalid due to: " + message.split("Input Shape")[0]+ " (Badness: " + badness + "),\n"+
				(message.contains("Input Shape") ? "Input Shape"+message.split("Input Shape")[1]+",\n" : "")+
				"Expected: "+this.getExpected()+",\n"+
				"At Layer: "+ location;
	}

	public String getExpected() {
		return expected;
	}

	public void setExpected(String expected) {
		this.expected = expected;
	}
	
	
	public List<Integer> getExpectedShape()
	{
		return this.getExpectedShape(true);
	}
	public List<Integer> getExpectedShape(boolean ignoreFirst){
		List<Integer> s = new ArrayList<Integer>();
		if(this.expected == null || this.expected.isEmpty()) {
			return null;
		}
		if(expected.contains("[")) {
			String tempShape = expected.replace("Shape","").replace("[", "").replace("]", "").trim();
			String[] tempShapeParts = tempShape.split(",");
			for (int i1 = 0; i1 < tempShapeParts.length; i1++) {
				s.add(Integer.parseInt(tempShapeParts[i1]));
			}
		}
		if(ignoreFirst && s.size() > 0) {
			s.remove(0);
		}
		return s;
	}
	
	public List<Integer> getInputShape()
	{
		return this.getInputShape(true);
	}
	public List<Integer> getInputShape(boolean ignoreFirst){
		List<Integer> s = new ArrayList<Integer>();
		if(message.contains(", Input Shape")) {
			String tempShape = message.split(", Input Shape")[1].trim();
			tempShape = tempShape.split("]")[0].trim();
			tempShape = tempShape.replace("[", "").replace("]", "");
			String[] tempShapeParts = tempShape.split(",");
			for (int i1 = 0; i1 < tempShapeParts.length; i1++) {
				s.add(Integer.parseInt(tempShapeParts[i1]));
			}
		}
		else {
			return null;
		}
		if(ignoreFirst && s.size() > 0) {
			s.remove(0);
		}
		return s;
	}
	
	public List<Integer> getExpectedVsAcutualShape(){
		return this.getExpectedVsAcutualShape(true);
	}
	public List<Integer> getExpectedVsAcutualShape(boolean ignoreFirst){
		List<Integer> actual =  getInputShape(false);
		List<Integer> expected = getExpectedShape(false);
		List<Integer> diff = new ArrayList<>();
		//boolean onlZerosSoFar = true;
		for (int i = 0; i < actual.size(); i++) {
			int d = expected.get(i) - actual.get(i);
			diff.add(d);
//			if(d ==0) {
//				if(!onlZerosSoFar) {
//					diff.add(d);
//				}
//			}
//			else {
//				onlZerosSoFar = false;
//				diff.add(d);
//			}
		}
		if(ignoreFirst && diff.size() > 0) {
			diff.remove(0);
		}
		return diff;
	}
	public int getBiggestDiffDim(List<Integer> diff) {
		for (int i = 0; i < diff.size(); i++) {
			if(Math.abs(diff.get(i)) > 0){
				return diff.size()-i;
			}
		}
		return 0;
	}
	
	public boolean allNegative(List<Integer> diff) {
		for (Integer d : diff) {
			if(d > 0) {
				return false;
			}
		}
		return true;
	}
	
}
