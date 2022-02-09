package gen;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.Layer;
import layer.TimeDistributedLayer;
import util.GenUtils;

public class TimeDistributedGen extends Gen {

	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape,
			LinkedHashMap<String, Object> config) {
		// TODO Auto-generated method stub
		Layer layer = GenUtils.genLayer(rand);
		if(inputShape == null) {
			inputShape = layer.getInputShape();
			inputShape.add(0,1);//rand.nextInt()+1);
		}
		
		return new TimeDistributedLayer(name, inputShape, layer, null);
		
	}

}
