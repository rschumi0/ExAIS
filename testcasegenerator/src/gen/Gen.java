package gen;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.Layer;

public abstract class Gen {
	
	public Gen() {}
	
	public abstract Layer generateLayer(Random rand, String name, List<Integer> inputShape, LinkedHashMap<String, Object> config);

	
	protected static Double randDoubleRange(Random r, Double min, Double max) {
		return min + r.nextDouble() * (max - min);
	}
	
}
