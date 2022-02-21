package gen;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Arrays;
import java.util.HashMap;

import layer.Layer;

public abstract class Gen {
	
	protected LinkedHashMap<String,List<String>> paramAliases = new LinkedHashMap<>();
	protected Map<String,Map<String,String>> defaultValues = new HashMap<>();
	
	public Gen() {
		paramAliases.put("weights", Arrays.asList("weights"));
		paramAliases.put("bias", Arrays.asList("bias"));
	}
	
	public abstract Layer generateLayer(Random rand, String name, List<Integer> inputShape, LinkedHashMap<String, Object> config);

	
	public Layer generateLayerwithDefaultValues(Random rand, String name, List<Integer> inputShape,LinkedHashMap<String, Object> config) {
		Layer l = generateLayer(rand, name, inputShape, config);
		if(defaultValues.containsKey(name)) {
			LinkedHashMap<String, String> params = l.getParams();
			for (String k : defaultValues.get(name).keySet()) {
				params.put(k, defaultValues.get(name).get(k));
			}
			l.setParams(params);
		}
		return l;
	}
	
	protected static Double randDoubleRange(Random r, Double min, Double max) {
		return min + r.nextDouble() * (max - min);
	}
	
	
	
	
	public LinkedHashMap<String,Object> fillParams(LinkedHashMap<String,Object> params){
		if(params == null) {
			return null;
		}
		LinkedHashMap<String,Object> p = new LinkedHashMap<>();
		for (String k : paramAliases.keySet()) {
			List<String> aliases = paramAliases.get(k);
			for (String a : aliases) {
				if(params.containsKey(a)) {
					Object value = params.get(a);
					value = checkAndParse(value);
					p.put(k, value);
					break;
				}
			}
		}
		return p;
	}
	
	public Object checkAndParse(Object o) {
		if(o instanceof String) {
			String s = (String) o;
			if(s.contains("(") || s.contains(",")) {
				s = s.replace("(", "").replace(")", "");
				List<Integer> is = new ArrayList<Integer>();
				for(String i: s.split(",")) {
					is.add(Integer.parseInt(i));
				}
				return (Object)is;
			}
		}
		return o;
	}
}
