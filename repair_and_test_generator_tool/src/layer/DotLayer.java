package layer;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.json.simple.JSONObject;

import util.ListHelper;

public class DotLayer extends TwoInputLayer {

	private List<Integer> inputShape1;
	public DotLayer(String name, List<Integer> inputShape, List<Integer> inputShape1, LinkedHashMap<String, String> params) {
		super(name, inputShape, params);
		this.setInputShape1(inputShape1);
	}
	
	public DotLayer(DotLayer l) {
		super(l);
		this.setInputShape1(l.getInputShape1());
	}
	
	@Override
	public Object generateInput(Random r) {
		if(this.fixedInput != null) {
			return this.fixedInput;
		}
		ArrayList<Integer> tempShape = new ArrayList<>(this.getInputShape());
		ArrayList<Integer> tempShape1 = new ArrayList<>(getInputShape1());
		tempShape.add(0,1);
		tempShape1.add(0,1);
		Object[] o = new Object[2];
		o[0] = ListHelper.genList(r, tempShape);//ListHelper.genList(r, "int", inputShape,0,9);//ListHelper.genList(r, inputShape);//
		o[1] = ListHelper.genList(r, tempShape1);//ListHelper.genList(r, "int", inputShape1,0,9);//ListHelper.genList(r, inputShape1);
		return o;
	}
	
	@Override
	public JSONObject toJsonObject(boolean includeInOuputNodes, Map<String,Object> input, boolean omitInputsAndWeights) {
		JSONObject o = super.toJsonObject(includeInOuputNodes, input, omitInputsAndWeights);
		List<Integer> tempShape = new ArrayList<Integer>(inputShape1);
		tempShape.add(0,1);
		o.put("input_shape1",ListHelper.getShapeString(tempShape));
		return o;
	}
	
	
	@Override
	public Layer copy() {
		return new DotLayer(this);
	}

	public List<Integer> getInputShape1() {
		return inputShape1;
	}

	public void setInputShape1(List<Integer> inputShape1) {
		this.inputShape1 = inputShape1;
	}

}
