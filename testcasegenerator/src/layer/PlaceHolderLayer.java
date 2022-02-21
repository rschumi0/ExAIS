package layer;

import java.util.LinkedHashMap;
import java.util.List;

public class PlaceHolderLayer extends Layer {

	
	public PlaceHolderLayer(String name, List<Integer> shape, LinkedHashMap<String, String> params) {
		super(name, shape, params);
	}
	@Override
	public Layer copy() {
		return new PlaceHolderLayer(name,inputShape,params);
	}

}
