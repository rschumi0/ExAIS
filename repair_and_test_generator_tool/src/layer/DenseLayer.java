package layer;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

public class DenseLayer extends NodeLayer {
	
	public DenseLayer(String name, int nodeNumber, List<Integer> inputShape,  Object inputWeights, Object outputWeights, LinkedHashMap<String, String> params) {
		super(nodeNumber, inputWeights, outputWeights,inputShape,params);
		this.name = name;
	}
	public DenseLayer(String name, int nodeNumber, List<Integer> inputShape,  Object inputWeights, Object outputWeights, LinkedHashMap<String, String> params, Object inputWeights1) {
		super(nodeNumber, inputWeights, inputWeights1, outputWeights,inputShape,params);
		this.name = name;
	}
	
	public DenseLayer(DenseLayer l) {
		super(l);
		this.name = l.name;
	}
	
	
	public Layer copy() {
		return new DenseLayer(this);
	}
	
	@Override
	public List<Integer> getOutputShape(){
		List<Integer> outputShape = new ArrayList<Integer>(inputShape);
		outputShape.add(0,1);
		outputShape.remove(outputShape.size()-1);
		outputShape.add(nodeNumber);
		return outputShape;
	}
}
