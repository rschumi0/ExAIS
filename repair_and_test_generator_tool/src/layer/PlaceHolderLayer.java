package layer;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;

import util.ListHelper;

public class PlaceHolderLayer extends Layer {

	
	public PlaceHolderLayer(String name, List<Integer> shape, LinkedHashMap<String, String> params) {
		super(shape, params);
		this.name = name;
	}
	public PlaceHolderLayer(PlaceHolderLayer l) {
		super(l);
		this.name = l.name;
	}
	
	public  String toPrologString(Object in) {	
		return "place_holder_layer("+ListHelper.printList(in)+ ", "+"X)";
	}
	
	
	@Override
	public Layer copy() {
		return new PlaceHolderLayer(this);
	}

}
