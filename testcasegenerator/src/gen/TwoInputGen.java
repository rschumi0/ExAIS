package gen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;

import layer.*;
import util.ListHelper;

public class TwoInputGen extends MultiInputGen {
	
	
	@Override
	public Layer generateLayer(Random rand, String name, List<Integer> inputShape, LinkedHashMap<String, Object> config) {
//		String[] names = {"Subtract"};
//		String name = names[rand.nextInt(names.length)];
		
		int dimensions;
		if(inputShape != null) {
			dimensions = inputShape.size(); 
		}
		else {
			dimensions = name.equals("Dot")? rand.nextInt(2)+1 : rand.nextInt(4)+1;
			inputShape = new ArrayList<>();//Arrays.asList(3,3));
			for(int i = 0; i < dimensions; i++) {
				inputShape.add(rand.nextInt(2)+2);
			}
		}

		LinkedHashMap<String, String> params = new LinkedHashMap<>();
		
		if(name.equals("Dot")) {
			List<Integer> inputShape1 = new ArrayList<>();//Arrays.asList(3,3));
			List<Integer> axes = new ArrayList<>();
//			axes.add(rand.nextInt(dimensions)+1);
//			axes.add(rand.nextInt(dimensions)+1);

			axes.add(0);axes.add(0);
			do {
				inputShape1 = new ArrayList<>();
				inputShape1.add(inputShape.get(0));
				for(int i = 1; i < dimensions; i++) {
//					if(rand.nextInt(10) < 3) {
//						inputShape1.add(rand.nextInt(3)+2);
//					}
//					else {
						inputShape1.add(inputShape.get(rand.nextInt(inputShape.size())));
//					}
					
//					if(rand.nextBoolean() || (!matchingDim && i == dimensions-1))
//					{
//						matchingDim = true;
//						inputShape1.add(inputShape.get(rand.nextInt(inputShape.size())));
//					}
//					else {
//						inputShape1.add(rand.nextInt(3)+1);
//					}
				}
				axes.set(0, rand.nextInt(inputShape.size())+1);
				axes.set(1, rand.nextInt(inputShape1.size())+1);
			} while(!(inputShape.get(axes.get(0)-1) == inputShape1.get(axes.get(1)-1) 
					&&
					inputShape.get((axes.get(0) % dimensions)) == inputShape1.get((axes.get(1)% dimensions))));

//			
//			outerLoop: while(true) {
//				for(int i = 0; i < inputShape.size(); i++) {
//					for(int j = 0; j < inputShape1.size(); j++) {
//						if(rand.nextInt(10) < 3 && inputShape.get(i) == inputShape1.get(j))
//						{
//							axes.add(i+1);
//							axes.add(j+1);
//							break outerLoop;
//						}
//					}
//				}
//			}
			
			String axStr = Arrays.toString(axes.toArray());
			axStr = axStr.replace("[", "(").replace("]", ")");
			params.put("axes", axStr);
			return new DotLayer(name, inputShape, inputShape1, params);
		}
		
		return new TwoInputLayer(name,inputShape,params);
	}
	


}
