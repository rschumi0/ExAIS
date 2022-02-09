package layer;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import util.ListHelper;

public class DotLayer extends TwoInputLayer {

	List<Integer> inputShape1;
	public DotLayer(String name, List<Integer> inputShape, List<Integer> inputShape1, LinkedHashMap<String, String> params) {
		super(name, inputShape, params);
		this.inputShape1 = inputShape1;
	}
	
	public DotLayer(DotLayer l) {
		super(l);
		this.inputShape1 = l.inputShape1;
	}
	
	@Override
	public Object generateInput(Random r) {
		ArrayList<Integer> tempShape = new ArrayList<>(this.getInputShape());
		ArrayList<Integer> tempShape1 = new ArrayList<>(inputShape1);
		tempShape.add(0,1);
		tempShape1.add(0,1);
		Object[] o = new Object[2];
		o[0] = ListHelper.genList(r, tempShape);//ListHelper.genList(r, "int", inputShape,0,9);//ListHelper.genList(r, inputShape);//
		o[1] = ListHelper.genList(r, tempShape1);//ListHelper.genList(r, "int", inputShape1,0,9);//ListHelper.genList(r, inputShape1);
		return o;
	}
	
	
	@Override
	public Layer copy() {
		return new DotLayer(this);
	}

}
