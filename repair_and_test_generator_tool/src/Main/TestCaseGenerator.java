package Main;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.stream.Stream;

import org.json.simple.parser.ParseException;

import gen.*;
import layer.*;
import util.*;

public class TestCaseGenerator {
	
	
	public static void croppingTest1() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 1;
		int failCnt = 0;
		List<Integer> inputShape = Arrays.asList(1,1,2);
		for(int i = 0; i < testNumber; i++) {
			//Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Separable_Conv1D","Separable_Conv2D", "Conv2D_Transpose", "Conv3D_Transpose"));
			//Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			Layer l0 = GenUtils.genLayer(rand, "Average_Pooling2D",inputShape);
			LinkedHashMap<String, Object> config0 = new LinkedHashMap<>();
			config0.put("nodeNumber", 32);
			config0.put("croppingSizes", Arrays.asList(new Object[] {0,0},new Object[] {1,0}));
			Layer l1 = GenUtils.genLayer(rand, "Cropping2D",null,config0);
			
			//Layer l3 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			
		//		Layer l0 = GenUtils.genLayer(rand,Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
		//		Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//, "Max_Pool1D", "Max_Pool1D", "ReLU"));
		//	    Layer l2 = GenUtils.genLayer(rand,Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			
			
			l0.connectParent(l1);

			
			LayerGraph l = new LayerGraph(l1);
			
			
			((LayerGraph)l).validateGraph(rand);
			
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void croppingTest2() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 1;
		int failCnt = 0;
		List<Integer> inputShape = Arrays.asList(3,2);
		for(int i = 0; i < testNumber; i++) {
			//Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Separable_Conv1D","Separable_Conv2D", "Conv2D_Transpose", "Conv3D_Transpose"));
			//Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			Layer l0 = GenUtils.genLayer(rand, "Dot",inputShape);
			LinkedHashMap<String, Object> config0 = new LinkedHashMap<>();
			config0.put("nodeNumber", 32);
			config0.put("croppingSizes", Arrays.asList(new Object[] {0,0},new Object[] {1,0},new Object[] {1,0} ));
			Layer l1 = GenUtils.genLayer(rand, "Cropping3D",null,config0);
			
	;
			//Layer l3 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			
		//		Layer l0 = GenUtils.genLayer(rand,Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
		//		Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//, "Max_Pool1D", "Max_Pool1D", "ReLU"));
		//	    Layer l2 = GenUtils.genLayer(rand,Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			
			
			l0.connectParent(l1);

			
			LayerGraph l = new LayerGraph(l1);
			
			
			((LayerGraph)l).validateGraph(rand);
			
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}

	
	public static void realModelTest() {
		initLayerGenMap();
		
		String csvData = Util.readFile("/home/admin1/pima-indians-diabetes.csv");
		String[] csvLines = csvData.split("\n");
		Random rand = new Random();
		
		//LZer70528 = zero_padding3D_layer(Res70716, 2, 1, 1, 2, 2, 1, Zer70528), 
		int testNumber = csvLines.length;
		int failCnt = 0;
		
		LinkedHashMap<String, Object> config = new LinkedHashMap<>();
		config.put("nodeNumber",12);
		List<Integer> inputShape = Arrays.asList(8);
		Layer l0 = GenUtils.genLayer(rand,"Dense",inputShape,config);
		((DenseLayer)l0).setInputWeights("[[ 0.1311245 , -0.00922409, -0.48566583, -0.11899793,  0.6214077 ,\n" + 
				"		         0.4049127 , -0.09946192,  0.34042144,  0.15917094,  1.1511256 ,\n" + 
				"		         0.82193536, -0.14905454],\n" + 
				"		       [ 0.36898074,  0.07661073, -0.25299007, -0.0147076 ,  0.26987216,\n" + 
				"		        -0.20582986,  0.09280762, -0.01671833,  0.00199427, -0.4918853 ,\n" + 
				"		         0.0246823 ,  0.29521954],\n" + 
				"		       [-0.21997656,  0.3258979 , -0.48247713,  0.42031544, -0.44813985,\n" + 
				"		         0.28347465,  0.48165897,  0.58176106, -0.5317643 , -0.04399274,\n" + 
				"		         0.49898538,  0.3684929 ],\n" + 
				"		       [-0.11634863, -0.07904698, -0.30268788, -0.03609374,  0.2138545 ,\n" + 
				"		         0.10930742, -0.23222432, -0.13824135, -0.41570076,  0.02220961,\n" + 
				"		         0.10793082, -0.28351647],\n" + 
				"		       [-0.46073782,  0.02486273, -0.54278713, -0.32627425, -0.21089028,\n" + 
				"		         0.3302474 , -0.20073093, -0.30120912,  0.01133793, -0.4205152 ,\n" + 
				"		         0.46883115,  0.11988363],\n" + 
				"		       [-0.61266106, -0.5106592 , -0.03951883, -0.34959224, -0.32944545,\n" + 
				"		         0.05692549, -0.33346295,  0.11182452, -0.2632843 ,  0.04002919,\n" + 
				"		        -0.2398297 , -0.20755558],\n" + 
				"		       [ 0.659286  , -0.8194371 , -0.5392151 , -1.2162774 ,  0.56135875,\n" + 
				"		        -0.11014035, -0.40612265,  0.8756339 , -0.7232851 ,  0.7307163 ,\n" + 
				"		         0.24925789, -0.04300505],\n" + 
				"		       [ 0.283452  ,  0.01978269, -0.44067982,  0.5383437 , -0.34572205,\n" + 
				"		        -0.36493164, -0.30183217, -0.43831086,  0.3901968 ,  0.20144309,\n" + 
				"		        -0.26502678, -0.00254193]]");
		((DenseLayer)l0).setOutputWeights("[-0.90209216,  0.72558546,  0.        ,  0.6841779 , -0.4666804 ,\n" + 
				"		        0.9780964 ,  0.76574105, -0.8136202 ,  0.41952458, -0.49807957,\n" + 
				"		       -0.64042866,  0.6591721 ]");
		
		
		LinkedHashMap<String, Object> params = new LinkedHashMap<>();
		params.put("max_value",Float.MAX_VALUE);
		params.put("negative_slope",0);
		params.put("threshold",0);
		Layer l1 = GenUtils.genLayer(rand,"ReLU",null,params);
		
		List<Integer> inputShape1 = Arrays.asList(1, 12);
		LinkedHashMap<String, Object> config1 = new LinkedHashMap<>();
		config1.put("nodeNumber",8);
		Layer l2 = GenUtils.genLayer(rand,"Dense",inputShape1,config1);
		((DenseLayer)l2).setInputWeights("[[-0.13309488,  0.00519468,  0.49498007,  0.37179777,  0.20727552,\n" + 
				"		         0.24444173, -0.37516472,  0.02231264],\n" + 
				"		       [-0.54720837, -0.09534471,  0.03939335,  0.43669537,  0.43648806,\n" + 
				"		         0.049711  , -0.5601354 , -0.53864837],\n" + 
				"		       [ 0.34664446,  0.12783247,  0.09287035,  0.3109542 ,  0.16747642,\n" + 
				"		        -0.25977224,  0.00391251,  0.54592705],\n" + 
				"		       [ 0.29931825, -0.2412267 ,  0.5496003 ,  0.23582795,  0.42996004,\n" + 
				"		         0.2510104 , -0.31761917,  0.10822939],\n" + 
				"		       [ 0.35270303, -0.29648715, -0.06794734, -0.18245502, -0.6368916 ,\n" + 
				"		         0.01631845, -0.6429269 ,  0.3143477 ],\n" + 
				"		       [ 0.00511199, -0.24278164, -0.104385  , -0.31235927, -0.04213273,\n" + 
				"		        -0.43001184, -0.6471533 , -0.36831832],\n" + 
				"		       [ 0.09500808,  0.45524278, -0.0315711 , -0.20569552,  0.3168611 ,\n" + 
				"		         0.2358086 , -0.23532961, -0.5111957 ],\n" + 
				"		       [-0.4688599 , -0.2236504 , -0.11771461,  0.05959994, -0.46548042,\n" + 
				"		        -0.6840669 , -0.3792941 ,  0.2335614 ],\n" + 
				"		       [ 0.35753158, -0.18367827, -0.42358235, -0.30737463, -0.4581151 ,\n" + 
				"		         0.24900264, -0.09455369,  0.01341713],\n" + 
				"		       [ 0.36977786, -0.58183116,  0.5617567 ,  0.04768349, -0.24657953,\n" + 
				"		         0.37963998, -0.21496293,  0.13674837],\n" + 
				"		       [-0.33749518,  0.4907564 ,  0.4311377 ,  0.16200316,  0.38816792,\n" + 
				"		        -0.5639093 , -0.12789884, -0.22833797],\n" + 
				"		       [-0.3417267 , -0.2153773 ,  0.3799089 , -0.00756761,  0.05776551,\n" + 
				"		        -0.07448619,  0.46330464, -0.4923052 ]]");
		((DenseLayer)l2).setOutputWeights("[-0.08861464, -0.91063285, -1.3090453 , -1.3076004 ,  1.260963  ,\n" + 
				"		        0.21173564,  0.32993656, -0.20614973]");
		Layer l3 = GenUtils.genLayer(rand,"ReLU",null,params);
		
		
		List<Integer> inputShape2 = Arrays.asList(1, 8);
		LinkedHashMap<String, Object> config2 = new LinkedHashMap<>();
		config2.put("nodeNumber",1);
		Layer l4 = GenUtils.genLayer(rand,"Dense",inputShape2,config2);
		

	    ((DenseLayer)l4).setInputWeights("			[[-0.46321943],\n" + 
	    		"		       [ 0.5804569 ],\n" + 
	    		"		       [ 0.16045076],\n" + 
	    		"		       [ 0.4660679 ],\n" + 
	    		"		       [-0.52302784],\n" + 
	    		"		       [-0.72243696],\n" + 
	    		"		       [-0.7823286 ],\n" + 
	    		"		       [-0.55840576]]");
	    ((DenseLayer)l4).setOutputWeights("[-1.2867831]");
		Layer l5 = GenUtils.genLayer(rand,"Sigmoid");
	    l0.initUniqueName(rand);
	    l1.initUniqueName(rand);
	    l2.initUniqueName(rand);
	    l3.initUniqueName(rand);
	    l4.initUniqueName(rand);
	    l5.initUniqueName(rand);
	    l0.connectParent(l1);
	    l1.connectParent(l2);
	    l2.connectParent(l3);
	    l3.connectParent(l4);
	    l4.connectParent(l5);

		LayerGraph l = new LayerGraph(l5);
		
		
		for(int i = 0; i < 10; i++) {
			int output = Integer.parseInt(csvLines[i].substring(csvLines[i].lastIndexOf(",")+1,csvLines[i].length()));
			Object[] input = csvLines[i].substring(0,csvLines[i].lastIndexOf(",")).split(",");
			Object[] input1 = new Object[] {input};
			HashMap<String, Object> tempinput = new HashMap<String, Object>();
			System.out.println(ListHelper.printList(tempinput));
			
		
			
			tempinput.put(l0.getUniqueName(),input1);
			//((LayerGraph)l).validateGraph(rand);
			//if(!runGivenModelTest(rand,l,i,tempinput)) {failCnt++;}
			String expected = ScriptProlog.runScript(l.toPrologString(tempinput), l.getUniqueName()).trim();
			//String actual = ScriptPython.runScript(l.toTensorflowString(tempinput)).trim();
	    	///Object a = ListHelper.parseList(actual);
			System.out.println(l.toPrologString(tempinput));
	    	Object e = ListHelper.parseList(expected);
    		System.out.println("-------------------------------------------------------------------------------------");
    		
    		//System.out.println("Actual:   "+ListHelper.printList(a));
	    	System.out.println("Expected: " + ListHelper.printList(e));
	    	int expectedInt = (int)Math.round(Double.parseDouble(ListHelper.printList(e).replace("[", "").replace("]", "")));
			System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@real Output: "+ output);
			if(expectedInt != output)
			{
				failCnt++;
			}
		}
		printTestSummary(testNumber,failCnt);
		
	
	}
	
	public static void convModel() throws IOException {
		initLayerGenMap();
		
		Random rand = new Random();
		
		String wData = Util.readFile("/home/admin1/tempWeights.txt");
		String[] weights = wData.split("###Sep###");
		
		System.out.println("Weights read");
		System.out.println("w1: "+ weights[1]);
		

		
		
		LinkedHashMap<String, Object> config0 = new LinkedHashMap<>();
		config0.put("nodeNumber", 32);
		config0.put("kernelSizes", Arrays.asList(3,3));
		config0.put("strides", Arrays.asList(1,1));
		config0.put("dilation_rates", Arrays.asList(1,1));
		config0.put("padding", false);	
		Layer l0 = GenUtils.genLayer(rand,"Conv2D",Arrays.asList(32,32,3),config0);
		((ConvLayer)l0).setInputWeights(weights[0]);
		((ConvLayer)l0).setOutputWeights(weights[1]);
		System.out.println("Weights set");
		
		LinkedHashMap<String, Object> reluParams = new LinkedHashMap<>();
		reluParams.put("max_value",Float.MAX_VALUE);
		reluParams.put("negative_slope",0);
		reluParams.put("threshold",0);
		Layer l1 = GenUtils.genLayer(rand,"ReLU",null,reluParams);
		
		LinkedHashMap<String, Object> config2 = new LinkedHashMap<>();
		config2.put("poolSizes", Arrays.asList(2,2));
		config2.put("strides", Arrays.asList(2,2));
		config2.put("padding", false);	
		Layer l2 = GenUtils.genLayer(rand,"Max_Pool2D",null,config2);
		
		LinkedHashMap<String, Object> config3 = new LinkedHashMap<>();
		config3.put("nodeNumber", 64);
		config3.put("kernelSizes", Arrays.asList(3,3));
		config3.put("strides", Arrays.asList(1,1));
		config3.put("dilation_rates", Arrays.asList(1,1));
		config3.put("padding", false);	
		Layer l3 = GenUtils.genLayer(rand,"Conv2D",Arrays.asList(15,15,32),config3);
		((ConvLayer)l3).setInputWeights(weights[2]);
		((ConvLayer)l3).setOutputWeights(weights[3]);
		System.out.println("Weights set");
		
		
		Layer l4 = GenUtils.genLayer(rand,"ReLU",null,reluParams);
		
		Layer l5 = GenUtils.genLayer(rand,"Max_Pool2D",null,config2);
		
		Layer l6 = GenUtils.genLayer(rand,"Conv2D",Arrays.asList(6,6,64),config3);
		((ConvLayer)l6).setInputWeights(weights[4]);
		((ConvLayer)l6).setOutputWeights(weights[5]);
		System.out.println("Weights set");
		
		Layer l7 = GenUtils.genLayer(rand,"Flatten",null,null);
		
		
		LinkedHashMap<String, Object> config4 = new LinkedHashMap<>();
		config4.put("nodeNumber",64);
		Layer l8 = GenUtils.genLayer(rand,"Dense",null,config4);
		((DenseLayer)l8).setInputWeights(weights[6]);
		((DenseLayer)l8).setOutputWeights(weights[7]);
		System.out.println("Weights set");
		
		Layer l9 = GenUtils.genLayer(rand,"ReLU",null,reluParams);
		
		LinkedHashMap<String, Object> config5 = new LinkedHashMap<>();
		config5.put("nodeNumber",10);
		Layer l10 = GenUtils.genLayer(rand,"Dense",null,config5);
		((DenseLayer)l10).setInputWeights(weights[8]);
		((DenseLayer)l10).setOutputWeights(weights[9]);
		System.out.println("Weights set");

	    l0.initUniqueName(rand);
	    l1.initUniqueName(rand);
	    l2.initUniqueName(rand);
	    l3.initUniqueName(rand);
	    l4.initUniqueName(rand);
	    l5.initUniqueName(rand);
	    l6.initUniqueName(rand);
	    l7.initUniqueName(rand);
	    l8.initUniqueName(rand);
	    l9.initUniqueName(rand);
	    l10.initUniqueName(rand);
	    l0.connectParent(l1);
	    l1.connectParent(l2);
	    l2.connectParent(l3);
	    l3.connectParent(l4);
	    l4.connectParent(l5);
	    l5.connectParent(l6);
	    l6.connectParent(l7);
	    l7.connectParent(l8);
	    l8.connectParent(l9);
	    l9.connectParent(l10);
		LayerGraph l = new LayerGraph(l10);
		
		HashMap<String, Object> tempinput = new HashMap<String, Object>();
		Object input = ImageHelper.readImage("/home/admin1/Downloads/truck.png");
		tempinput.put(l0.getUniqueName(),input);
		System.out.println("Image: "+ ListHelper.printList(input));
		System.out.println("Prolog: "+ l.toPrologString(tempinput));
		String expected = ScriptProlog.runScript(l.toPrologString(tempinput), l.getUniqueName()).trim();
		System.out.println("Expected (unparsed): " + expected);
		Object e = ListHelper.parseList(expected);
		System.out.println("Expected: " + ListHelper.printList(e));

//		Layer l0 = GenUtils.genLayer(rand,"Dense",inputShape,config);
//		model.add(layers.Conv2D(32, (3, 3), activation='relu', input_shape=(32, 32, 3)))
//		model.add(layers.MaxPooling2D((2, 2)))
//		model.add(layers.Conv2D(64, (3, 3), activation='relu'))
//		model.add(layers.MaxPooling2D((2, 2)))
//		model.add(layers.Conv2D(64, (3, 3), activation='relu'))
	}
	


	public static void runtimeTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 3;//ConfigUtil.testNumber; 
		String summary = "";
		List<Integer> inputShape = Arrays.asList(16,8,8,8);//Arrays.asList(16,64,8);//Arrays.asList(16,8,8,8);//Arrays.asList(8,8,4,2);//Arrays.asList(8,4,4);//Arrays.asList(2,1,1);
//		ArrayList<Layer> models = new ArrayList<>();
//		for(int i = 0; i < testNumber; i++) {
//	    	Layer l = new GraphGen().generateLayer(rand, "", inputShape, null);
//	    	((LayerGraph)l).validateGraph(rand);	
//	    	
//	    	 ((LayerGraph)l).resetInputs(Arrays.asList(3,3,5));
//	    	 
//	    	 Object in = l.generateInput(rand);
//	    	 Map<String, ModelError> errors = new HashMap<>();
//	    	 String expected = ScriptProlog.runScript(l.toPrologString(in), l.getUniqueName(), errors).trim();
//	    	 if(!errors.isEmpty() || expected.contains("[") || ((LayerGraph)l).getLayerCount() < 7) {
//	    		 i--;
//	    		 continue;
//	    	 }
//	    	 System.out.println("-------------------------------------------------------------------------------------");
//	    	 System.out.println(l.toPrologString(in));
//	    	 models.add(l);
//		}
//
//		for(int i = 0; i < testNumber; i++) {
//			System.out.println("test "+ i +" size: "+ models.get(i).getLayerCount());
//			summary += "test "+ i +" size: "+ models.get(i).getLayerCount() + "\n";
//		}
		
		
		outer: for(int j = 15; j <=18; j=j+3) {
//			if(j > 16) {
//				j = j -2;
//			}
	    	long totalelapsedTimeMillis = 0;
	    	float totalelapsedTimeSec = 0;
	    	int layerCount = 0;
	    	int maxTries = 0;
			for(int i = 0; i < testNumber; i++) {
				if(j > 16 && maxTries > 300) {
					break outer;
				}
//		    	Layer l = models.get(i);//new GraphGen().generateLayer(rand, "", inputShape, null);
////		    	((LayerGraph)l).validateGraph(rand);	
////		    	 Object in = l.generateInput(rand);
////		    	//System.out.println(l.toPrologString(in));
////		    	System.out.println("-------------------------------------------------------------------------------------");
//		    	 ((LayerGraph)l).resetInputs(Arrays.asList(3,3,j));
//		    	 
//		    	 Object in = l.generateInput(rand);
				LinkedHashMap<String, Object> config = new LinkedHashMap<>();
				config.put("maxLevel",j);
		    	Layer l = new GraphGen().generateLayer(rand, "", inputShape, config);
		    	if(l.getLayerCount() > j*2.5 || l.getLayerCount() < j*1.5) {
		    		maxTries++;
		    		System.out.println("###### Model rejected: " + l.getLayerCount());
		    		i--;
		    		continue;
		    	}
		    	System.out.println("##before Valid: "+ l.getLayerCount());
		    	((LayerGraph)l).validateGraph(rand,j+100,false);	
		    	
		    	 //((LayerGraph)l).resetInputs(Arrays.asList(3,3,5));
		    	 
		    	 Object in = l.generateInput(rand);
		    	 Map<String, ModelError> errors = new HashMap<>();
		    	 String prologScr = l.toPrologString(in);
				String expected = ScriptProlog.runScript(prologScr, l.getUniqueName(), errors);
				
				if(l.getLayerCount() < (j*0.9) || !errors.isEmpty() || expected.contains("error") || !expected.contains("[")) {
					System.out.println("expected: " +expected);
					System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "+j+" Model rejected: " + l.getLayerCount() + " " +(!errors.isEmpty()) +" "+ expected.contains("error") + " " + (!expected.contains("[")));
					if(!errors.isEmpty()) {
						System.out.println(errors.get(errors.keySet().toArray()[0]).toString());
					}
					//System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "+j+" Model rejected: " + l.getLayerCount() + " " +(!errors.isEmpty()) +" "+ expected.contains("error") + " " + (!expected.contains("[")));
					i--;
					 continue;
				 }
		    	 System.out.println("-------------------------------------------------------------------------------------");
		    	 //System.out.println(l.toPrologString(in));
		    	 saveTestCase(l.toPrologString(in), true);
				
//		    	if(j == 100 & i ==0) {
//		    		
//		    	}
		    	long start = System.currentTimeMillis();
		    	expected = ScriptProlog.runScript(prologScr, l.getUniqueName());
		    	
		    	
		    	//System.out.println("expected "+expected);
		    	long elapsedTimeMillis = System.currentTimeMillis()-start;
		    	float elapsedTimeSec = elapsedTimeMillis/1000F;
		    	totalelapsedTimeMillis +=elapsedTimeMillis;
		    	totalelapsedTimeSec += elapsedTimeSec;
		    	System.out.println();
		    	System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println("Duration Model "+i+": " +elapsedTimeMillis + "ms "+ elapsedTimeSec +"s layers: " + l.getLayerCount());
		    	layerCount += l.getLayerCount();
			}
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("Average Duration (InSize:"+ListHelper.printList(inputShape.toArray())+") Size "+j+": " +(totalelapsedTimeMillis/testNumber) + "ms "+ (totalelapsedTimeSec/(float)testNumber) +"s, Average Layers: "+ ((double)layerCount/(double)testNumber));
	    	summary += "Average Duration (InSize:"+ListHelper.printList(inputShape.toArray())+") Size "+j+": " +(totalelapsedTimeMillis/testNumber) + "ms "+ (totalelapsedTimeSec/(float)testNumber) +"s, Average Layers: "+ ((double)layerCount/(double)testNumber) +" \n";
			SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
			Date date = new Date(System.currentTimeMillis());
			System.out.println();
			String filename = "runtimesummary_" + formatter.format(date)+ ".txt";
			Util.writeFile(filename, summary);
		}
	}
	

	
	public static void runtimeTestOld() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 5;
		String summary = "";
		List<Integer> inputShape = Arrays.asList(3,3,3);
		ArrayList<Layer> models = new ArrayList<>();
		for(int i = 0; i < testNumber; i++) {
	    	Layer l = new GraphGen().generateLayer(rand, "", inputShape, null);
	    	((LayerGraph)l).validateGraph(rand);	
	    	
	    	 ((LayerGraph)l).resetInputs(Arrays.asList(3,3,5));
	    	 
	    	 Object in = l.generateInput(rand);
	    	 Map<String, ModelError> errors = new HashMap<>();
	    	 String expected = ScriptProlog.runScript(l.toPrologString(in), l.getUniqueName(), errors).trim();
	    	 if(!errors.isEmpty() || expected.contains("[") || ((LayerGraph)l).getLayerCount() < 7) {
	    		 i--;
	    		 continue;
	    	 }
	    	 System.out.println("-------------------------------------------------------------------------------------");
	    	 System.out.println(l.toPrologString(in));
	    	 models.add(l);
		}

		for(int i = 0; i < testNumber; i++) {
			System.out.println("test "+ i +" size: "+ models.get(i).getLayerCount());
			summary += "test "+ i +" size: "+ models.get(i).getLayerCount() + "\n";
		}
		
		
		for(int j = 50; j <= 30000; j=j+50) {
	    	long totalelapsedTimeMillis = 0;
	    	float totalelapsedTimeSec = 0;
	    	inputShape = Arrays.asList(3,3,j);
			for(int i = 0; i < testNumber; i++) {
		    	Layer l = models.get(i);//new GraphGen().generateLayer(rand, "", inputShape, null);
//		    	((LayerGraph)l).validateGraph(rand);	
//		    	 Object in = l.generateInput(rand);
//		    	//System.out.println(l.toPrologString(in));
//		    	System.out.println("-------------------------------------------------------------------------------------");
		    	 ((LayerGraph)l).resetInputs(Arrays.asList(3,3,j));
		    	 
		    	 Object in = l.generateInput(rand);
		    	if(j == 100 & i ==0) {
		    		saveTestCase(l.toPrologString(in), true);
		    	}
		    	long start = System.currentTimeMillis();
		    	String expected = ScriptProlog.runScript(l.toPrologString(in), l.getUniqueName()).trim();
		    	//System.out.println("expected "+expected);
		    	long elapsedTimeMillis = System.currentTimeMillis()-start;
		    	float elapsedTimeSec = elapsedTimeMillis/1000F;
		    	totalelapsedTimeMillis +=elapsedTimeMillis;
		    	totalelapsedTimeSec += elapsedTimeSec;
		    	System.out.println();
		    	System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println("Duration Model "+i+": " +elapsedTimeMillis + "ms "+ elapsedTimeSec +"s");
			}
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("Average Duration Size "+j+": " +(totalelapsedTimeMillis/testNumber) + "ms "+ (totalelapsedTimeSec/(float)testNumber) +"s");
	    	summary += "Average Duration Size "+j+": " +(totalelapsedTimeMillis/testNumber) + "ms "+ (totalelapsedTimeSec/(float)testNumber) +"s \n";
			SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
			Date date = new Date(System.currentTimeMillis());
			System.out.println();
			String filename = "runtimesummary_" + formatter.format(date)+ ".txt";
			Util.writeFile(filename, summary);
		}
	}
	
	public static void multiInputTest2() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 10;
		int failCnt = 0;
		List<Integer> inputShape = Arrays.asList(16,8,8,8);
		for(int i = 0; i < testNumber; i++) {
			//Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Separable_Conv1D","Separable_Conv2D", "Conv2D_Transpose", "Conv3D_Transpose"));
			//Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Separable_Conv1D","Separable_Conv2D", "Conv2D_Transpose", "Conv3D_Transpose"),inputShape);
			Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"),inputShape);
			
			Layer l2 = GenUtils.genLayer(rand, "Dense");
			Layer l3 = GenUtils.genLayer(rand, "Conv3D_Transpose");
			
			Layer l4 = GenUtils.genLayer(rand, "Add");
			//Layer l3 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			
		//		Layer l0 = GenUtils.genLayer(rand,Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
		//		Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//, "Max_Pool1D", "Max_Pool1D", "ReLU"));
		//	    Layer l2 = GenUtils.genLayer(rand,Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			l3.initUniqueName(rand);
			l4.initUniqueName(rand);
			
			
			l0.setParentLayer(l2);
			l1.setParentLayer(l3);
			l2.getChildLayers().add(l0);
			l3.getChildLayers().add(l1);
			l2.setParentLayer(l4);
			l3.setParentLayer(l4);
			l4.getChildLayers().add(l2);
			l4.getChildLayers().add(l3);
			
			LayerGraph l = new LayerGraph(l4);
			
			
			((LayerGraph)l).validateGraph(rand);
			
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	
	public static void twoLayerSeqTestWithInputShape() {
		initLayerGenMap();
		Random rand = new Random();
		List<Integer> inputShape = Arrays.asList(2,1);
		int testNumber = 5;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, "Permute", inputShape);
			Layer l1 = GenUtils.genLayer(rand, "Cropping3D");
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l0.setParentLayer(l1);
			l1.getChildLayers().add(l0);
			LayerGraph l = new LayerGraph(l1);
			
			((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void twoLayerSeqTestWithInputShape1() {
		initLayerGenMap();
		Random rand = new Random();
		List<Integer> inputShape = Arrays.asList(2,1);
		int testNumber = 5;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, "Conv1D", inputShape);
			Layer l1 = GenUtils.genLayer(rand, "ReLU");
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l0.setParentLayer(l1);
			l1.getChildLayers().add(l0);
			LayerGraph l = new LayerGraph(l1);
			
			((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void singleLayerTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 5;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, "Embedding");//GenUtils.recurrentLayers);//Arrays.asList("Locally_Connected1D"));//GenUtils.convLayers);//"Dense");//"Embedding");//"Conv_LSTM2D");
			l0.initUniqueName(rand);
			LayerGraph l = new LayerGraph(l0);
			
			
			//((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
			System.out.println(l.toJsonString());
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void givenLayerTest(Layer l) {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 1;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			
			//((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void fixLoadedModel(Layer modelToFix, List<Layer> fixedModels, List<String> prologSrcs, List<Object> inputs) {
		initLayerGenMap();
    	Random rand = new Random();
    	ModelRepairer.findFixes(rand, (LayerGraph)modelToFix,fixedModels, prologSrcs, inputs, 4);
	}
	
	
	public static String runModel(Random r, LayerGraph l, Object in, Map<String,ModelError> errors) {
		String prologSrc = l.toPrologString(in);
		//System.out.println(prologSrc);
		String expected = ScriptProlog.runScript(prologSrc, l.getUniqueName(), errors);
		return expected;
	}
	public static void loadedModelAndCheckAccuracy(Random rand, String modelPath, String inputPath, String otputPath) {
		LayerGraph loadedModel = null;
		try {
			loadedModel =JsonModelParser.parseModelFromPathGraph(rand, modelPath);
			System.out.println(loadedModel.toPrologString(loadedModel.generateInput(rand)));
			System.out.println(loadedModel.toArchitectureString());
		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		if(loadedModel != null) {
			String output = Util.readFile(otputPath);
			output = output.replace("[", "").replace("]", "");
			String[] outputs = output.split(",");
			File folder = new File(inputPath);
			File[] listOfFiles = folder.listFiles();
			int correctPredictions = 0;
			int correctTop3Pred = 0;
			int dataFiles = 0;
			int i = 1;
			for (File file : listOfFiles) {
			    if (file.isFile() && file.getName().contains(".txt") && file.getName().contains("data")) {
//			        if(!file.getName().contains("99")){
//			        	
//			        	
//			        	continue;}
			    	
			        int fileIndex = Integer.parseInt(file.getName().replace(".txt", "").replace("data", ""));
			        System.out.println(file.getName() + " " + outputs[fileIndex]);
			        String input = Util.readFile(file.getAbsolutePath());
			        Object in = ListHelper.parseList(input);
			        
			        
			        
			        
			        
			        Map<String,Object> inMap = new HashMap<String, Object>();
			        List<Integer> tempShape = new ArrayList<>(loadedModel.findFirstInputNode().getInputShape());
			        tempShape.add(0,1);
			        //System.out.println(ListHelper.getShapeString(in));
			        in = ListHelper.reshapeList(tempShape,in);
			        //System.out.println(ListHelper.getShapeString(in));
			        //in = ListHelper.transposeList(in);
			        //System.out.println(ListHelper.getShapeString(in));
			        
			        inMap.put(loadedModel.findFirstInputNode().getUniqueName(),in);
			        loadedModel.lastInput = inMap;
			        
			        
			        
			        //System.out.println(loadedModel.toPrologString(inMap));
			        
			        
			        Map<String,ModelError> errors = new HashMap<>();
			        String expected = runModel(rand,loadedModel,inMap,errors);
					System.out.println("-------------------------------------------------------------------------------------");
					System.out.println("-------------------------------------------------------------------------------------");
			        if(!errors.isEmpty()) {
			        	System.out.println(errors.get(errors.keySet().toArray()[0]));
			        }
			        
			        System.out.println(expected);
			        Object[] e = (Object[])ListHelper.getInnerMostList(ListHelper.parseList(expected));
			        
			        System.out.println("outShape: "+Arrays.toString(ListHelper.getShape(e).toArray()));
			        
			        int expectedOut = Integer.parseInt(outputs[fileIndex].trim());
			        int max = ListHelper.getMaxIndex(e);
			        
			        System.out.println(file.getName() + " e:" + outputs[fileIndex] + " a:"+ max+ " " + expected + "!!!");
			        Set<Integer> top3 = ListHelper.getTop3Index(e);
			        if(expectedOut == max) {
			        	correctPredictions++;
			        	correctTop3Pred++;
			        }
			        else if(top3 != null && top3.contains(expectedOut)) {
			        	correctTop3Pred++;
			        }
			        dataFiles++;
			        System.out.println( "current accuracy: "+ ((float)correctPredictions/(i++)));  
					System.out.println("-------------------------------------------------------------------------------------");
					System.out.println("-------------------------------------------------------------------------------------");
			    }
			}
			System.out.println("-------------------------------------------------------------------------------------");
			String res = modelPath + ":\n Prediction Accuracy: " + ((float)correctPredictions/dataFiles) + "\n"+
					   " Top 3 Prediction Accuracy: "+((float)correctTop3Pred/dataFiles);
			System.out.println(res);
			SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
			String filename = "accuracytestsummary_" + formatter.format(new Date(System.currentTimeMillis()))+ ".txt";
			Util.writeFile(filename, res);
			
		}
	}
	
	public static void fixLoadedModelTest(Random rand, String path) {
		LayerGraph fixModel = null;
		try {
			fixModel =JsonModelParser.parseModelFromPathGraph(rand, path);
		} catch (ParseException e1) {
			e1.printStackTrace();
		}
		if(fixModel != null) {
			System.out.println("try to fix loaded model");
			
			List<Layer> models = new ArrayList<>();
			List<Object> inputs =  new ArrayList<>();
			List<String> prologSrcs = new ArrayList<>();
			TestCaseGenerator.fixLoadedModel(fixModel,models, prologSrcs, inputs);
			System.out.println("-------------------------------------------------------------------------------------");
			System.out.println("-------------------------------------------------------------------------------------");
			System.out.println(+models.size() + " fixes found!!!");
			System.out.println("-------------------------------------------------------------------------------------");
			System.out.println("-------------------------------------------------------------------------------------");
		
	    	for(int i = 0; i < models.size();i++) {
	    		//testlistModel.addElement(models.get(i).getUniqueName());
	    		System.out.println("Fix " + i + " of model: "+models.get(i).getUniqueName()+": ");
	    		System.out.println(prologSrcs.get(i));
	    	}
		}
	}
	
	
	
	public static void loadedModelTest(List<Layer> models, List<Object> inputs, List<String> prologSrcs, List<String> tensorflowSrcs, List<String> results, List<Boolean> successes) 
	{
		loadedModelTest(models, inputs, prologSrcs, tensorflowSrcs, results, successes, true, false);
	}
	
	public static void loadedModelTest(List<Layer> models, List<Object> inputs, List<String> prologSrcs, List<String> tensorflowSrcs, List<String> results, List<Boolean> successes, boolean doValidation, boolean makeErrorPlot) {
		initLayerGenMap();
    	Random rand = new Random();
    	int failCnt = 0;
    	int totalLayerCnt = 0;
    	int testNumber = Config.testNumber; //10000;//100;//50;//500;
    	long start = System.currentTimeMillis();
	    for(int i = 0; i < models.size(); i++) {
	    	String resVar =null;
		    Layer l = models.get(i);
		    Object in = null;
		    if(doValidation) {
		    	((LayerGraph)l).validateGraph(rand);	
		    }
		    if(makeErrorPlot) {
		    	l.errorMode = true;
		    }
			resVar = l.getUniqueName();
			totalLayerCnt += ((LayerGraph)l).getLayerCount();

		    
		    //in = ListHelper.genListandAddDefaultDim(rand, l.getInputShape());
		    in = l.generateInput(rand);
		    inputs.add(i);
		    
		    System.out.println("----------------------------------Test "+i+" started-------------------------------------");
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
		    String prologSrc = l.toPrologString(in);
	    	System.out.println(prologSrc);
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	Map<String, ModelError> errors = new HashMap<String, ModelError>();
	    	String expected = ScriptProlog.runScript(prologSrc, resVar, errors).trim();
	    	System.out.println();
	    	prologSrcs.add(prologSrc);
	    	if(!errors.isEmpty()) {
	    		((LayerGraph)l).graphLayerMap.get(errors.keySet().toArray()[0]).hasError = true;
	    	}
		    
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Python Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
		    String tensorflowScr = l.toTensorflowString(in);
	    	System.out.println(tensorflowScr);
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String actual = ScriptPython.runScript(tensorflowScr).trim();
	    	System.out.println();
	    	tensorflowSrcs.add(tensorflowScr);
	    	

	    	
    		System.out.println("-------------------------------------------------------------------------------------");
    		
    		String result = "Actual (Unparsed): " + actual+ "\n" + 
    					    "Expected (Unparsed): " + expected + "\n" +
    					    "-------------------------------------------------------------------------------------" + "\n";
    		//System.out.println(result);
	    	
	    	Object a = ListHelper.parseList(actual);
	    	Object e = ListHelper.parseList(expected);
	    	boolean success = ListHelper.compareLists(a, e);
	    	
	    	result += "Actual:   "+ListHelper.printList(a)+ "\n" + 
	    					 "Expected: " + ListHelper.printList(e)+ "\n";
	    	System.out.println(result);
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	
	    	successes.add(success);
	    	
	    	if(!success) 
	    	{	   	
//	    		String saveTest = l.toTensorflowString(in)+"\n\n"+l.toPrologString(in)+ "\n\n"+
//						  "Actual (Unparsed): " + actual + "\n\n"+ "Expected (Unparsed): " + expected + "\n\n"+
//						  "Actual:   "+ListHelper.printList(a) + "\n\n"+ "Expected: " + ListHelper.printList(e);
//	    		saveTestCase(saveTest);
			    System.out.println("Test "+ i+ " failed!");
			    System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println();
	    	}
	    	else 
	    	{
			    System.out.println("-------------------------------------------------------------------------------------");
			    System.out.println("Test "+ i+ " passed!");
			    System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println();
			}

    		String saveTest = l.toTensorflowString(in)+"\n\n"+l.toPrologString(in)+ "\n\n"+
					  "Actual (Unparsed): " + actual + "\n\n"+ "Expected (Unparsed): " + expected + "\n\n"+
					  "Actual:   "+ListHelper.printList(a) + "\n\n"+ "Expected: " + ListHelper.printList(e);
    		  
	    	if(!errors.isEmpty()) {
	    		result = errors.get(errors.keySet().toArray()[0]).toFormattedString((String)errors.keySet().toArray()[0]);
	    		saveTest += "\n\n"+ result;
	    	}
	    	results.add(result);
    		saveTestCase(saveTest,success);
	    	
	    	if(!success) {failCnt++;}
    	}
	    long elapsedTimeMillis = System.currentTimeMillis()-start;
	    float elapsedTimeSec = elapsedTimeMillis/1000F;
	    float elapsedTimeMin = elapsedTimeMillis/(60*1000F);
	    float elapsedTimeHour = elapsedTimeMillis/(60*60*1000F);
	    String summary =  "Summary: "+failCnt + " tests failed "+ (testNumber-failCnt) +" tests successful in " + elapsedTimeMillis+"ms (" + elapsedTimeSec+"s, "+elapsedTimeMin+"min, "+ elapsedTimeHour+ "h)" +"\n"+
    	"Average Layer Number per Model: " +((double)totalLayerCnt/(double)testNumber) + "Total Layers" +totalLayerCnt +"\n"+
    	"Number of Model Regeneration: " +(GenUtils.regenerationCounter) +"\n"+
    	"Average Number of Model Repair Iterations: " +((double)GenUtils.totalFixIterations/(double)testNumber) + " Total Iterations: " +GenUtils.totalFixIterations;
    	System.out.println(summary);
    	GenUtils.regenerationCounter=0;
    	GenUtils.totalFixIterations=0;
    
		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
		Date date = new Date(System.currentTimeMillis());
		System.out.println();
		String filename = "testgenerationsummary_" + formatter.format(date)+ ".txt";
		Util.writeFile(filename, summary);
	}
	
	public static void twoLayerSeqTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 5;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l0.setParentLayer(l1);
			l1.getChildLayers().add(l0);
			LayerGraph l = new LayerGraph(l1);
			
			((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	
	public static void denseReluSeqTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 2;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Dense","ReLU"));
			Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Dense","ReLU"));
			Layer l2 = GenUtils.genLayer(rand, Arrays.asList("Dense","ReLU"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			l0.connectParent(l1);
			l1.connectParent(l2);
			LayerGraph l = new LayerGraph(l2);
			
			((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
			
    		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
    		Date date = new Date(System.currentTimeMillis());
    		String filename = "model_"+i+"_" + formatter.format(date)+ ".json";
			Util.writeFile(filename, l.toJsonString());
			System.out.println(l.toJsonString());
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void JsonSeqTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 10;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Conv1D"));//GenUtils.recurrentLayers);//GenUtils.poolLayers);//
			Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Zero_Padding1D","Zero_Padding2D","Zero_Padding3D"));//Arrays.asList("Cropping1D","Cropping2D","Cropping3D"));
			Layer l2 = GenUtils.genLayer(rand, GenUtils.activationLayers);
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			l0.connectParent(l1);
			l1.connectParent(l2);
			LayerGraph l = new LayerGraph(l2);
			
			((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
			
    		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
    		Date date = new Date(System.currentTimeMillis());
    		String filename = "model_"+i+"_" + formatter.format(date)+ ".json";
			Util.writeFile(filename, l.toJsonString());
			System.out.println(l.toJsonString());
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void twoLayerSeqTestWithNewFixingStragy() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 150;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l0.setParentLayer(l1);
			l1.getChildLayers().add(l0);
			LayerGraph l = new LayerGraph(l1);
			Map<String, ModelError> errors = new HashMap<String, ModelError>();
			
			System.out.println("Trying to fix model: ");
			System.out.println(l.toPrologString(l.generateInput(rand)));
			
			if(!ModelRepairer.modelWorks(rand,l,errors)) {
				l1 = ModelRepairer.findFixWithMinimalChange(rand, l, errors, 4);
				if (l1 == null) {
					System.out.println(l.toPrologString(l.generateInput(rand)));
					failCnt++;
					testNumber = i;
					System.out.println("no fix found!");
					break;
				}
				l = (LayerGraph)l1;
			}
			
			
			//((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}

	
	public static void threeLayerSeqTestWithNewFixingStragy() {
		initLayerGenMap();
		Random rand = new Random();
		//List<Integer> inputShape = Arrays.asList(1, 1, 1,1);
		//LZer70528 = zero_padding3D_layer(Res70716, 2, 1, 1, 2, 2, 1, Zer70528), 
		int testNumber = 1;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			//LLST97647 = lstm_layer(Zer70528,[[1, 7, 9, 2, 8, 7, 2, 3], [2, 3, 6, 4, 10, 5, 10, 8], [1, 9, 5, 7, 2, 3, 6, 4]],[[2, 7, 4, 3, 6, 10, 5, 10], [4, 1, 6, 10, 4, 2, 10, 3]],[5, 2, 1, 5, 6, 3, 2, 5]
//			Layer l0 = GenUtils.genLayer(rand, "Global_Average_Pooling2D");
//			Layer l1 = GenUtils.genLayer(rand, "Global_Average_Pooling3D");
//			Layer l2 = GenUtils.genLayer(rand, "Conv1D");
			
			Layer l0 = GenUtils.genLayer(rand,GenUtils.singleInputLayers);//Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));//("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			Layer l1 = GenUtils.genLayer(rand, GenUtils.singleInputLayers);//Arrays.asList("Depthwise_Conv2D"));//("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//, "Max_Pool1D", "Max_Pool1D", "ReLU"));
		    Layer l2 = GenUtils.genLayer(rand,GenUtils.singleInputLayers);//Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			l0.setParentLayer(l1);
			l1.getChildLayers().add(l0);
			l1.setParentLayer(l2);
			l2.getChildLayers().add(l1);
			LayerGraph l = new LayerGraph(l2);
			
			System.out.println("Trying to fix model: ");
			System.out.println(l.toPrologString(l.generateInput(rand)));
			
			Map<String, ModelError> errors = new HashMap<String, ModelError>();
			if(!ModelRepairer.modelWorks(rand,l,errors)) {
				l1 = ModelRepairer.findFixWithMinimalChange(rand, l, errors, 4);
				if (l1 == null) {
					System.out.println(l.toPrologString(l.generateInput(rand)));
					failCnt++;
					testNumber = i;
					System.out.println("no fix found!");
					break;
				}
				l = (LayerGraph)l1;
			}
			
			//((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
			Util.writeFile("savetest.json", l.toJsonString());
		}
		printTestSummary(testNumber,failCnt);
	}
	
	
	public static void layerSeqTestWithNewFixingStragyWithPlots() {
		initLayerGenMap();
		Random rand = new Random();
		//List<Integer> inputShape = Arrays.asList(1, 1, 1,1);
		//LZer70528 = zero_padding3D_layer(Res70716, 2, 1, 1, 2, 2, 1, Zer70528), 
		int testNumber = 1;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			//LLST97647 = lstm_layer(Zer70528,[[1, 7, 9, 2, 8, 7, 2, 3], [2, 3, 6, 4, 10, 5, 10, 8], [1, 9, 5, 7, 2, 3, 6, 4]],[[2, 7, 4, 3, 6, 10, 5, 10], [4, 1, 6, 10, 4, 2, 10, 3]],[5, 2, 1, 5, 6, 3, 2, 5]
//			Layer l0 = GenUtils.genLayer(rand, "Global_Average_Pooling2D");
//			Layer l1 = GenUtils.genLayer(rand, "Global_Average_Pooling3D");
//			Layer l2 = GenUtils.genLayer(rand, "Conv1D");
			
			Layer l0 = GenUtils.genLayer(rand,"Cropping2D");//Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));//("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			Layer l1 = GenUtils.genLayer(rand, "Conv3D");//Arrays.asList("Depthwise_Conv2D"));//("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//, "Max_Pool1D", "Max_Pool1D", "ReLU"));
		    Layer l2 = GenUtils.genLayer(rand,"Dense");
		    Layer l3 = GenUtils.genLayer(rand,"Conv2D");
		    Layer l4 = GenUtils.genLayer(rand,"Max_Pool2D");
		    //Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			l3.initUniqueName(rand);
			l4.initUniqueName(rand);
			l0.connectParent(l1);
			l1.connectParent(l2);
			l2.connectParent(l3);
			l3.connectParent(l4);

			LayerGraph l = new LayerGraph(l4);
			
			new GraphViz().simpleGraphCreation(l.toDotString(), "origanlM");
			
			System.out.println("Trying to fix model: ");
			System.out.println(l.toPrologString(l.generateInput(rand)));
			
			Map<String, ModelError> errors = new HashMap<String, ModelError>();
			if(!ModelRepairer.modelWorks(rand,l,errors)) {
				List<Layer> fixes =  ModelRepairer.findFixes(rand, l, errors, 4);
				int j = 0;
				for (Layer fix : fixes) {
					if (fix == null) {
						System.out.println(l.toPrologString(l.generateInput(rand)));
						failCnt++;
						testNumber = i;
						System.out.println("no fix found!");
						break;
					}
					new GraphViz().simpleGraphCreation(((LayerGraph)fix).toDotString(), "fix"+(j++)+"M");
					if(!runGivenModelTest(rand,fix,i)) {failCnt++;}
				}
			}
			
		}
		printTestSummary(testNumber,failCnt);
	}
	
	
	public static void multiInputTestWithNewFixingStragy() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 1;
		int failCnt = 0;
		List<Integer> inputShape = Arrays.asList(2,2);
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, GenUtils.singleInputLayers);//"Conv1D",inputShape);//Arrays.asList("Multiply","Add", "Subtract","Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));//GenUtils.genLayer(rand, "Multiply",inputShape);//,"Locally_Connected2D","Depthwise_Conv2D"));
			Layer l1 = GenUtils.genLayer(rand, GenUtils.singleInputLayers);//"Max_Pool1D",inputShape);//Arrays.asList("Multiply","Add", "Subtract","Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));//GenUtils.genLayer(rand, "Global_Average_Pooling3D");//"Conv2D",inputShape);//,"Conv2D","Conv3D"));
			//Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			//Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			Layer l2 = GenUtils.genLayer(rand, GenUtils.multiInputLayers);//"Cropping1D");
			Layer l3 = GenUtils.genLayer(rand, GenUtils.singleInputLayers);//"Concatenate");
			//Layer l3 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			
		//		Layer l0 = GenUtils.genLayer(rand,Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
		//		Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//, "Max_Pool1D", "Max_Pool1D", "ReLU"));
		//	    Layer l2 = GenUtils.genLayer(rand,Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			l3.initUniqueName(rand);
			
			l0.connectParent(l2);
			l1.connectParent(l2);
			l2.connectParent(l3);
			
			//l2.setParentLayer(l3);
			//l3.getChildLayers().add(l2);
			
			LayerGraph l = new LayerGraph(l3);
			
			System.out.println("Trying to fix model: ");
			System.out.println(l.toPrologString(l.generateInput(rand)));
			
			Map<String, ModelError> errors = new HashMap<String, ModelError>();
			if(!ModelRepairer.modelWorks(rand,l,errors)) {
				l1 = ModelRepairer.findFixWithMinimalChange(rand, l, errors, 4);
				if (l1 == null) {
					System.out.println(l.toPrologString(l.generateInput(rand)));
					failCnt++;
					testNumber = i;
					System.out.println("no fix found!");
					break;
				}
				l = (LayerGraph)l1;
			}
			
			//((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
			
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void multiInputTestWithNewFixingStragyTempDel() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 30;
		int failCnt = 0;
		List<Integer> inputShape = Arrays.asList(2,2);
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, GenUtils.singleInputLayers);//"Conv1D",inputShape);//Arrays.asList("Multiply","Add", "Subtract","Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));//GenUtils.genLayer(rand, "Multiply",inputShape);//,"Locally_Connected2D","Depthwise_Conv2D"));
			Layer l1 = GenUtils.genLayer(rand, GenUtils.singleInputLayers);//"Max_Pool1D",inputShape);//Arrays.asList("Multiply","Add", "Subtract","Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));//GenUtils.genLayer(rand, "Global_Average_Pooling3D");//"Conv2D",inputShape);//,"Conv2D","Conv3D"));
			//Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			//Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			Layer l2 = GenUtils.genLayer(rand, "Add");//"Cropping1D");
			//Layer l3 = GenUtils.genLayer(rand, GenUtils.singleInputLayers);//"Concatenate");
			//Layer l3 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			
		//		Layer l0 = GenUtils.genLayer(rand,Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
		//		Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//, "Max_Pool1D", "Max_Pool1D", "ReLU"));
		//	    Layer l2 = GenUtils.genLayer(rand,Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			//l3.initUniqueName(rand);
			
			l0.connectParent(l2);
			l1.connectParent(l2);
			//l2.connectParent(l3);
			
			//l2.setParentLayer(l3);
			//l3.getChildLayers().add(l2);
			
			LayerGraph l = new LayerGraph(l2);
			
			System.out.println("Trying to fix model: ");
			System.out.println(l.toPrologString(l.generateInput(rand)));
			
			Map<String, ModelError> errors = new HashMap<String, ModelError>();
			if(!ModelRepairer.modelWorks(rand,l,errors)) {
				l1 = ModelRepairer.findFixWithMinimalChange(rand, l, errors, 1);
				if (l1 == null) {
					System.out.println(l.toPrologString(l.generateInput(rand)));
					failCnt++;
					//testNumber = i;
					System.out.println("no fix found!");
					//break;
					continue;
				}
				l = (LayerGraph)l1;
			}
			
			//((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	
	public static void multiInputTest1() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 5;
		int failCnt = 0;
		List<Integer> inputShape = Arrays.asList(2,2);
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, "Conv1D",inputShape);//Arrays.asList("Multiply","Add", "Subtract","Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));//GenUtils.genLayer(rand, "Multiply",inputShape);//,"Locally_Connected2D","Depthwise_Conv2D"));
			Layer l1 = GenUtils.genLayer(rand, "Max_Pool1D",inputShape);//Arrays.asList("Multiply","Add", "Subtract","Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));//GenUtils.genLayer(rand, "Global_Average_Pooling3D");//"Conv2D",inputShape);//,"Conv2D","Conv3D"));
			//Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			//Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","Locally_Connected1D","Locally_Connected2D","Depthwise_Conv2D"));
			Layer l2 = GenUtils.genLayer(rand, "Cropping1D");
			Layer l3 = GenUtils.genLayer(rand, "Concatenate");
			//Layer l3 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			
		//		Layer l0 = GenUtils.genLayer(rand,Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
		//		Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//, "Max_Pool1D", "Max_Pool1D", "ReLU"));
		//	    Layer l2 = GenUtils.genLayer(rand,Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			l3.initUniqueName(rand);
			
			l0.setParentLayer(l2);
			l1.setParentLayer(l3);
			l2.getChildLayers().add(l0);
			l2.setParentLayer(l3);
			l3.getChildLayers().add(l1);
			l3.getChildLayers().add(l2);
			
			//l2.setParentLayer(l3);
			//l3.getChildLayers().add(l2);
			
			LayerGraph l = new LayerGraph(l3);
			
			((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	
	public static void multiInputTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 5;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			Layer l2 = GenUtils.genLayer(rand, "Add");
			Layer l3 = GenUtils.genLayer(rand, Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM","Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			
		//		Layer l0 = GenUtils.genLayer(rand,Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
		//		Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//, "Max_Pool1D", "Max_Pool1D", "ReLU"));
		//	    Layer l2 = GenUtils.genLayer(rand,Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			l3.initUniqueName(rand);
			
			l0.setParentLayer(l2);
			l1.setParentLayer(l2);
			l2.getChildLayers().add(l0);
			l2.getChildLayers().add(l1);
			
			l2.setParentLayer(l3);
			l3.getChildLayers().add(l2);
			
			LayerGraph l = new LayerGraph(l3);
			
			((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
			Util.writeFile("savetest.json", l.toJsonString());
			System.out.println(l.toJsonString());
		}
		printTestSummary(testNumber,failCnt);
	}
		
	public static void singleLayerTest1() {
		initLayerGenMap();
		Random rand = new Random();
		//List<Integer> inputShape = Arrays.asList(1, 1, 1,1);
		//LZer70528 = zero_padding3D_layer(Res70716, 2, 1, 1, 2, 2, 1, Zer70528), 
		int testNumber = 100;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {

			
			Layer l0 = GenUtils.genLayer(rand,Arrays.asList("Simple_RNNCell","GRUCell","LSTMCell"));//Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));//("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
		    l0.initUniqueName(rand);

			LayerGraph l = new LayerGraph(l0);
			
			//((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	
	public static void threeLayerSeqTest() {
		initLayerGenMap();
		Random rand = new Random();
		//List<Integer> inputShape = Arrays.asList(1, 1, 1,1);
		//LZer70528 = zero_padding3D_layer(Res70716, 2, 1, 1, 2, 2, 1, Zer70528), 
		int testNumber = 5;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			//LLST97647 = lstm_layer(Zer70528,[[1, 7, 9, 2, 8, 7, 2, 3], [2, 3, 6, 4, 10, 5, 10, 8], [1, 9, 5, 7, 2, 3, 6, 4]],[[2, 7, 4, 3, 6, 10, 5, 10], [4, 1, 6, 10, 4, 2, 10, 3]],[5, 2, 1, 5, 6, 3, 2, 5]
//			Layer l0 = GenUtils.genLayer(rand, "Global_Average_Pooling2D");
//			Layer l1 = GenUtils.genLayer(rand, "Global_Average_Pooling3D");
//			Layer l2 = GenUtils.genLayer(rand, "Conv1D");
			
			Layer l0 = GenUtils.genLayer(rand,Arrays.asList("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D","Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));//("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//"Zero_Padding1D","Zero_Padding2D","Zero_Padding3D","Max_Pool1D", "Max_Pool1D", "ReLU"));
			Layer l1 = GenUtils.genLayer(rand, Arrays.asList("Depthwise_Conv2D"));//("Global_Average_Pooling1D","Global_Average_Pooling2D","Global_Average_Pooling3D"));//, "Max_Pool1D", "Max_Pool1D", "ReLU"));
		    Layer l2 = GenUtils.genLayer(rand,Arrays.asList("Conv1D","Conv2D","Conv3D","LSTM"));
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			l0.setParentLayer(l1);
			l1.getChildLayers().add(l0);
			l1.setParentLayer(l2);
			l2.getChildLayers().add(l1);
			LayerGraph l = new LayerGraph(l2);
			
			((LayerGraph)l).validateGraph(rand);
			if(!runGivenModelTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void regularTests()
	{
		regularTests(new ArrayList<Layer>(), new ArrayList<Object>(), new ArrayList<String>(), new ArrayList<String>(), new ArrayList<String>(), new ArrayList<Boolean>());
	}
	public static void regularTests(List<Layer> models, List<Object> inputs, List<String> prologSrcs, List<String> tensorflowSrcs, List<String> results, List<Boolean> successes) {
		initLayerGenMap();
		Map<String,Gen> layerGenMap = GenUtils.layerGenMap;
		List<String> layers = GenUtils.layers;
		//layers = new ArrayList<>();
//		layers.add("Sigmoid");
//		layers.add("Time_Distributed");
//		layers.add("Softmax");
//		layers.add("Simple_RNNCell");
//		layers.add("GRUCell");
		
//		layers.add("LSTMCell");
//		layers.add("Locally_Connected2D");
//		layers.add("Layer_Normalization");
//		layers.add("Masking");
//		layers.add("Softmax");
//		layers.add("Flatten");
//		layers.add("Up_Sampling2D");
//		layers.add("Up_Sampling3D");
		//layers.add("Concatenate");
		//layers.add("Subtract");
//		layers.add("Time_Distributed");
		//layers.add("ReLU");
//		layers.add("Conv_LSTM2D");
		//layers.add("Depthwise_Conv2D");
		//layers.add("LSTM");
		
    	Random rand = new Random();
    	int failCnt = 0;
    	int totalLayerCnt = 0;
    	int testNumber = Config.testNumber; //10000;//100;//50;//500;
    	boolean sequenceMode = false;
    	boolean graphMode = true;
    	int layerSequenceLen = 5;
    	long start = System.currentTimeMillis();
	    for(int i = 0; i < testNumber; i++) {
	    	String resVar =null;
		    Layer l = null;
		    Object in = null;
		    if(graphMode) {
		    	l = new GraphGen().generateLayer(rand, "", null, null);
				((LayerGraph)l).validateGraph(rand);	
				resVar = l.getUniqueName();
				totalLayerCnt += ((LayerGraph)l).getLayerCount();
		    }
		    else if(sequenceMode ) {
				    l = new LayerSequence();
				    ((LayerSequence)l).generateSequence(rand, layerGenMap, layerSequenceLen);
		    }
		    else {
			    String layer = layers.get(rand.nextInt(layers.size()));
			    l= layerGenMap.get(layer).generateLayer(rand, layer, null,null);
		    }
		    
		    //in = ListHelper.genListandAddDefaultDim(rand, l.getInputShape());
		    in = l.generateInput(rand);
		    
		    models.add(l);
		    inputs.add(i);
		    
		    System.out.println("----------------------------------Test "+i+" started-------------------------------------");
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Python Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
		    String tensorflowScr = l.toTensorflowString(in);
	    	System.out.println(tensorflowScr);
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String actual = ScriptPython.runScript(tensorflowScr).trim();
	    	System.out.println();
	    	tensorflowSrcs.add(tensorflowScr);
	    	
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
		    String prologSrc = l.toPrologString(in);
	    	System.out.println(prologSrc);
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String expected = ScriptProlog.runScript(prologSrc, resVar).trim();
	    	System.out.println();
	    	prologSrcs.add(prologSrc);
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
    		
    		String result = "Actual (Unparsed): " + actual+ "\n" + 
    					    "Expected (Unparsed): " + expected + "\n" +
    					    "-------------------------------------------------------------------------------------" + "\n";
    		System.out.println(result);
	    	
	    	Object a = ListHelper.parseList(actual);
	    	Object e = ListHelper.parseList(expected);
	    	boolean success = ListHelper.compareLists(a, e);
	    	
	    	String result1 = "Actual:   "+ListHelper.printList(a)+ "\n" + 
	    					 "Expected: " + ListHelper.printList(e)+ "\n";
	    	System.out.println(result1);
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	results.add(result+result1);
	    	successes.add(success);
	    	
	    	if(!success) 
	    	{	   		
//	    		String saveTest = l.toTensorflowString(in)+"\n\n"+l.toPrologString(in)+ "\n\n"+
//						  "Actual (Unparsed): " + actual + "\n\n"+ "Expected (Unparsed): " + expected + "\n\n"+
//						  "Actual:   "+ListHelper.printList(a) + "\n\n"+ "Expected: " + ListHelper.printList(e);
//	    		saveTestCase(saveTest);
			    System.out.println("Test "+ i+ " failed!");
			    System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println();
	    	}
	    	else 
	    	{
			    System.out.println("-------------------------------------------------------------------------------------");
			    System.out.println("Test "+ i+ " passed!");
			    System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println();
			}
    		String saveTest = l.toTensorflowString(in)+"\n\n"+l.toPrologString(in)+ "\n\n"+
					  "Actual (Unparsed): " + actual + "\n\n"+ "Expected (Unparsed): " + expected + "\n\n"+
					  "Actual:   "+ListHelper.printList(a) + "\n\n"+ "Expected: " + ListHelper.printList(e);
    		saveTestCase(saveTest,success);
    		if(Config.saveTestsAsJson)
    		{
        		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
        		Date date = new Date(System.currentTimeMillis());
        		String filename = "model_"+i+"_" + formatter.format(date)+ ".json";
    			Util.writeFile(filename, ((LayerGraph)l).toJsonString());
    			System.out.println(((LayerGraph)l).toJsonString());
    		}
    		
	    	if(!success) {failCnt++;}
    	}
	    long elapsedTimeMillis = System.currentTimeMillis()-start;
	    float elapsedTimeSec = elapsedTimeMillis/1000F;
	    float elapsedTimeMin = elapsedTimeMillis/(60*1000F);
	    float elapsedTimeHour = elapsedTimeMillis/(60*60*1000F);
	    String summary =  "Summary: "+failCnt + " tests failed "+ (testNumber-failCnt) +" tests successful in " + elapsedTimeMillis+"ms (" + elapsedTimeSec+"s, "+elapsedTimeMin+"min, "+ elapsedTimeHour+ "h)" +"\n"+
    	"Average Layer Number per Model: " +((double)totalLayerCnt/(double)testNumber) + "Total Layers" +totalLayerCnt +"\n"+
    	"Number of Model Regeneration: " +(GenUtils.regenerationCounter) +"\n"+
    	"Average Number of Model Repair Iterations: " +((double)GenUtils.totalFixIterations/(double)testNumber) + " Total Iterations: " +GenUtils.totalFixIterations;
    	System.out.println(summary);
    	GenUtils.regenerationCounter=0;
    	GenUtils.totalFixIterations=0;
    
		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
		Date date = new Date(System.currentTimeMillis());
		System.out.println();
		String filename = "testgenerationsummary_" + formatter.format(date)+ ".txt";
		Util.writeFile(filename, summary);
	}
	
	
	
	public static void bugLocalisationTests() {
		initLayerGenMap();
		Map<String,Gen> layerGenMap = GenUtils.layerGenMap;
		List<String> layers = GenUtils.layers;
//		layers = new ArrayList<>();
//		layers.add("Dot");
//		layers.add("Locally_Connected2D");
//		layers.add("Layer_Normalization");
//		layers.add("Masking");
//		layers.add("Softmax");
//		layers.add("Flatten");
//		layers.add("Up_Sampling2D");
//		layers.add("Up_Sampling3D");
		//layers.add("Concatenate");
		//layers.add("Subtract");
//		layers.add("Time_Distributed");
		//layers.add("ReLU");
		//layers.add("Conv_LSTM2D");
		//layers.add("Depthwise_Conv2D");
		//layers.add("LSTM");
		
    	Random rand = new Random();
    	int failCnt = 0;
    	int totalLayerCnt = 0;
    	int testNumber = 100;//10000;//100;//50;//500;
    	boolean sequenceMode = false;
    	boolean graphMode = true;
    	int layerSequenceLen = 5;
    	long start = System.currentTimeMillis();
    	String summary = "";
    	String locations = "";
    	int dimensionErrorCount = 0;
    	int inconsistenInputsCount = 0;
    	int shapeError = 0;
    	int weightErrorCount = 0;
    	int argumentErrorCount = 0;
    	
	    for(int i = 0; i < testNumber; i++) {
	    	String resVar =null;
		    Layer l = null;
		    Object in = null;
		    if(graphMode) {
		    	
		    	l = new GraphGen().generateLayer(rand, "", null, null);
		    	//if(i < (testNumber/2)) {
			    	///Layer tempModel = ((LayerGraph)l).copy();

					((LayerGraph)l).validateGraph(rand);	
					if(((LayerGraph)l).getAndRestoreLastModel() != null)
					{
						l = ((LayerGraph)l).getAndRestoreLastModel();
					}
					else
					{
						//l = tempModel;
			    		i--;
			    		continue;
					}
			    //}

				resVar = l.getUniqueName();
				totalLayerCnt += ((LayerGraph)l).getLayerCount();
		    }
		    else if(sequenceMode ) {
				    l = new LayerSequence();
				    ((LayerSequence)l).generateSequence(rand, layerGenMap, layerSequenceLen);
		    }
		    else {
			    String layer = layers.get(rand.nextInt(layers.size()));
			    l= layerGenMap.get(layer).generateLayer(rand, layer, null,null);
		    }
		    
		    //in = ListHelper.genListandAddDefaultDim(rand, l.getInputShape());
		    in = l.generateInput(rand);
		    
		    System.out.println("----------------------------------Test "+i+" started-------------------------------------");
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Python Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toTensorflowString(in));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	ArrayList<String> pyErrors = new ArrayList<>();
	    	String actual = ScriptPython.runScript(l.toTensorflowString(in),pyErrors).trim();
	    	System.out.println();
	    	
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
		    try {
		    	System.out.println(l.toPrologString(in));
	    	}
		    catch (Exception e) {
	    		i--;
	    		continue;
			}
		    
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	Map<String, ModelError> errors = new HashMap<>();
	    	String expected = ScriptProlog.runScript(l.toPrologString(in), resVar, errors).trim();
	    	String er = "";
	    	String proEr = "";
	    	String loc = "";
	    	if(!errors.isEmpty()) {
	    		loc = (String)errors.keySet().toArray()[0];
	    		proEr = errors.get(errors.keySet().toArray()[0]).getMessage();
	    		
	    		if(!pyErrors.isEmpty()) {
	    			if(pyErrors.get(0).contains("raise")) {
	    				er = pyErrors.get(0).split("raise")[1];
	    			}
	    			else {
	    				er = pyErrors.get(0);
	    			}
	    		}
	    		else {
		    		i--;
		    		continue;
	    		}
	    		
	    		if(er.contains("not compatible with provided weight shape"))
	    		{
	    			weightErrorCount++;
	    		}
	    		else if(proEr.contains("Dimension Error") || proEr.contains("Inconsistent Input Dimensions"))
				{
	    			dimensionErrorCount++;
				}
	    		else if(proEr.contains("Inconsistent Input Shapes"))
	    		{
	    			inconsistenInputsCount++;
	    		}
	    		else if(proEr.contains("Shape Error")) {
	    			shapeError++;
	    		}
	    		else if(proEr.contains("Argument Error")){
	    			argumentErrorCount++;
	    		}
	    	
	    		
	    		if((proEr.contains("Dimension Error") || proEr.contains("Inconsistent Input Dimensions")) && 
	    			(er.contains("is incompatible with the layer") && (er.contains("expected ndim") || er.contains("expected min_ndim") || er.contains("expected max_ndim")) 
	    					|| er.contains("Dimension incompatibility")
	    					|| er.contains("Shape must be rank")
	    					|| er.contains("not compatible with provided weight shape")	
	    					)
	    			|| (proEr.contains("Argument Error") && er.contains("not compatible with provided weight shape"))	
	    			|| (proEr.contains("Inconsistent Input Shapes") && (er.contains("Operands could not be broadcast together with shapes") || er.isEmpty()))
	    				)
	    		{
	    			//TODO known error handling
	    			summary += i + " " +loc + ":" + proEr + "###" + er + "###"  + "\n" ;
	    		}
	    		else {
	    			summary += i + " " +loc + ":" + proEr + "###" + er + "###"  + "\n" ;
	    		}
	    		

	    		if(!pyErrors.isEmpty()) {
	    			if(!pyErrors.get(0).contains(loc)) {
	    				locations += i + " " + loc +" failed! \n" + pyErrors.get(0) + "\n\n";
	    			}
	    			
	    			///Remove
	    			else {
	    				locations += i + " ---"  +" failed! \n" + pyErrors.get(0) + "\n\n";
	    			}
	    			
	    			
	    			
	    		}
	    		else if(actual.contains("error") || !actual.contains("[") || actual.contains("[]")) {
	    			locations += i + " " + loc +" failed!\n " + actual + "\n\n";
				}
	    		
	    	}
	    	else if(!pyErrors.isEmpty()) {
	    		summary += i + " " + l.getUniqueName() + "##########TensorflowOnlyError#######"+ pyErrors.get(0);
			}
	    	else {
	    		i--;
	    		continue;
	    	}
	    	
	    	System.out.println();
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
    		System.out.println("Actual (Unparsed): " + actual);
    		System.out.println("Expected (Unparsed): " + expected);
	    	
    		String as ="";
    		String es="";
    		boolean success = false;
    		try {
	    	Object a = ListHelper.parseList(actual);
	    	Object e = ListHelper.parseList(expected);
	    	success = ListHelper.compareLists(a, e);
	    	as = ListHelper.printList(a);
	    	es = ListHelper.printList(e);
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("Actual:   "+as);
	    	System.out.println("Expected: " + es);
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	if(!success) 
	    	{	   		
//	    		String saveTest = l.toTensorflowString(in)+"\n\n"+l.toPrologString(in)+ "\n\n"+
//						  "Actual (Unparsed): " + actual + "\n\n"+ "Expected (Unparsed): " + expected + "\n\n"+
//						  "Actual:   "+ListHelper.printList(a) + "\n\n"+ "Expected: " + ListHelper.printList(e);
//	    		saveTestCase(saveTest);
			    System.out.println("Test "+ i+ " failed!");
			    System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println();
	    	}
	    	else 
	    	{
			    System.out.println("-------------------------------------------------------------------------------------");
			    System.out.println("Test "+ i+ " passed!");
			    System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println();
			}
    		}
    		catch(Exception e) {
        		System.out.println("-------------------------------------------------------------------------------------");
        		System.out.println("--------------------Parsing Error--------------------------------------");
        		System.out.println("-------------------------------------------------------------------------------------");
    		}
    		String saveTest = l.toTensorflowString(in)+"\n\n"+l.toPrologString(in)+ "\n\n"+
					  "Actual (Unparsed): " + actual + "\n"+ er+ "\n\n"+ "Expected (Unparsed): " + expected + "\n"+loc+": "+proEr+ "\n\n"+
					  "Actual:   "+as + "\n\n"+ "Expected: " + es;
    		//saveTestCase(saveTest,success);
	    	
    		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
    		Date date = new Date(System.currentTimeMillis());
    		String filename = "buglocalisationtest_"+i+"_" + formatter.format(date)+ ".txt";
    		Util.writeFile(filename, saveTest);
	    	
	    	if(!success) {failCnt++;}
    	}
//	    long elapsedTimeMillis = System.currentTimeMillis()-start;
//	    float elapsedTimeSec = elapsedTimeMillis/1000F;
//	    float elapsedTimeMin = elapsedTimeMillis/(60*1000F);
//	    float elapsedTimeHour = elapsedTimeMillis/(60*60*1000F);
//	    String summary =  "Summary: "+failCnt + " tests failed "+ (testNumber-failCnt) +" tests successful in " + elapsedTimeMillis+"ms (" + elapsedTimeSec+"s, "+elapsedTimeMin+"min, "+ elapsedTimeHour+ "h)" +"\n"+
//    	"Average Layer Number per Model: " +((double)totalLayerCnt/(double)testNumber) + "Total Layers" +totalLayerCnt +"\n"+
//    	"Number of Model Regeneration: " +(GenUtils.regenerationCounter) +"\n"+
//    	"Average Number of Model Repair Iterations: " +((double)GenUtils.totalFixIterations/(double)testNumber) + "Total Iterations" +GenUtils.totalFixIterations;
//    	System.out.println(summary);
//    	GenUtils.regenerationCounter=0;
//    	GenUtils.totalFixIterations=0;
	    
	    
    	String errorTypes = "dimensionErrorCount: " + dimensionErrorCount  + " \n"+
    	"inconsistenInputsCount: "+ inconsistenInputsCount  + " \n"+
    	"shapeError: " + shapeError  + " \n"+
    	"weightErrorCount: " + weightErrorCount  + " \n"+
    	"argumentErrorCount: "+ argumentErrorCount  + " \n";
    	
		System.out.println(errorTypes);

		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
		Date date = new Date(System.currentTimeMillis());

		
		String filename = "buglocalisationsummary_" + formatter.format(date)+ ".txt";
		Util.writeFile(filename, summary+"\n\n "+ locations +"\n\n "+ errorTypes);
	}
	
	
	
	public static void nondeterminicTests()
	{
		nondeterminicTests(new ArrayList<Layer>(), new ArrayList<Object>(), new ArrayList<String>(), new ArrayList<String>(), new ArrayList<String>(), new ArrayList<Boolean>());
	}
	public static void nondeterminicTests(List<Layer> models, List<Object> inputs, List<String> prologSrcs, List<String> tensorflowSrcs, List<String> results, List<Boolean> successes) {
		Map<String,Gen> layerGenMap = new HashMap<>();
		layerGenMap.put("Dropout",new DropoutGen());
		layerGenMap.put("Alpha_Dropout",new DropoutGen());		
		layerGenMap.put("Spatial_Dropout1D",new DropoutGen());
		layerGenMap.put("Spatial_Dropout2D",new DropoutGen());
		layerGenMap.put("Spatial_Dropout3D",new DropoutGen());		
		layerGenMap.put("Gaussian_Dropout",new DropoutGen());
		layerGenMap.put("Gaussian_Noise",new DropoutGen());
		
		List<String> layers = new ArrayList<>(layerGenMap.keySet());
		
    	Random rand = new Random();
    	int failCnt = 0;
    	int testNumber = Config.testNumber;
    	long start = System.currentTimeMillis();
	    for(int i = 0; i < testNumber; i++) {
	    	String resVar = null;
		    Layer l = null;
		    Object in = null;
		    
		    String layer = layers.get(rand.nextInt(layers.size()));
		    l= layerGenMap.get(layer).generateLayer(rand, layer, null,null);
		    l.initUniqueName(rand);
		    models.add(l);

		    
		    //in = ListHelper.genListandAddDefaultDim(rand, l.getInputShape());
		    in = l.generateInput(rand);
		    inputs.add(in);
		    
		    System.out.println("----------------------------------Test "+i+" started-------------------------------------");
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Python Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
		    String ts = l.toTensorflowString(in);
		    tensorflowSrcs.add(ts);
		    System.out.println(ts);
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String actual = ScriptPython.runScript(ts).trim();
	    	System.out.println();
	    	
	    	Object a = ListHelper.parseList(actual);
	    	
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
		    String ps = l.toPrologString(in, a);
		    prologSrcs.add(ps);
	    	System.out.println(ps);
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String expected = ScriptProlog.runScript(ps,resVar,null,true).trim();
	    	System.out.println();
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
    		String result ="Actual (Unparsed): " + actual + "\n"+
    	                   "Expected (Unparsed): " + expected+"\n";
	    	
	    	
	    	//Object e = ListHelper.parseList(expected);
	    	boolean success = expected.toLowerCase().equals("true.") || expected.startsWith("true Action? Actions");//ListHelper.compareLists(a, e);
	    	successes.add(success);
	    	result+="-------------------------------------------------------------------------------------" + "\n"+
	    	        "Actual:   "+ListHelper.printList(a) + "\n";
	    	//System.out.println("Result: " + ListHelper.printList(e));
	    	result+="-------------------------------------------------------------------------------------"+"\n" ;
	    	if(!success) {
	    		result+="Test "+ i+ " failed!"+ "\n"+
			            "-------------------------------------------------------------------------------------"+ "\n";
	    	}
	    	else {
	    		result+="Test "+ i+ " passed!"+ "\n"+
			            "-------------------------------------------------------------------------------------"+ "\n";
			}
	    	System.out.println(result);
	    	results.add(result);
	    	
    		String saveTest = l.toTensorflowString(in)+"\n\n"+l.toPrologString(in)+ "\n\n"+result;
    		saveTestCase(saveTest,success);
	    	
	    	if(!success) {failCnt++;}
    	}
	    long elapsedTimeMillis = System.currentTimeMillis()-start;
	    float elapsedTimeSec = elapsedTimeMillis/1000F;
	    float elapsedTimeMin = elapsedTimeMillis/(60*1000F);
	    float elapsedTimeHour = elapsedTimeMillis/(60*60*1000F);
    	System.out.println("Summary: "+failCnt + " tests failed "+ (testNumber-failCnt) +" tests successful in " + elapsedTimeMillis+"ms (" + elapsedTimeSec+"s, "+elapsedTimeMin+"min, "+ elapsedTimeHour+ "h)");
    }
    
	public static void saveTestCase(String t, boolean success) {
		if(Config.testCaseOutputPath != null && !Config.testCaseOutputPath.isEmpty()) {
			SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
			Date date = new Date(System.currentTimeMillis());
			System.out.println();
			String filename = success ? ("testcase_" + formatter.format(date)+ ".txt") : ("failedtest_" + formatter.format(date)+ ".txt");
			//String filename = "/tmptests/buglocalisationtest_" + formatter.format(date)+ ".txt"
			Util.writeFile(Config.testCaseOutputPath+filename, t);
		}
	}
	
	
	public static void initLayerGenMap() {
		Map<String,Gen> layerGenMap = GenUtils.layerGenMap;
		
		layerGenMap.put("Conv1D_Transpose",new ConvGen());
		layerGenMap.put("Conv2D_Transpose",new ConvGen());
		layerGenMap.put("Conv3D_Transpose",new ConvGen());
		layerGenMap.put("Separable_Conv1D",new ConvGen());
		layerGenMap.put("Separable_Conv2D",new ConvGen());
		layerGenMap.put("Conv1D",new ConvGen());
		layerGenMap.put("Conv2D",new ConvGen());
		layerGenMap.put("Conv3D",new ConvGen());
		layerGenMap.put("Locally_Connected1D",new ConvGen());
		layerGenMap.put("Locally_Connected2D",new ConvGen());
		layerGenMap.put("Depthwise_Conv2D",new ConvGen());
	
		layerGenMap.put("Permute",new HelperLayerGen());
		layerGenMap.put("Repeat_Vector",new HelperLayerGen());
		layerGenMap.put("Cropping1D",new HelperLayerGen());
		layerGenMap.put("Cropping2D",new HelperLayerGen());
		layerGenMap.put("Cropping3D",new HelperLayerGen());
		layerGenMap.put("Up_Sampling1D",new HelperLayerGen());
		layerGenMap.put("Up_Sampling2D",new HelperLayerGen());
		layerGenMap.put("Up_Sampling3D",new HelperLayerGen());
		layerGenMap.put("Zero_Padding1D",new HelperLayerGen());
		layerGenMap.put("Zero_Padding2D",new HelperLayerGen());
		layerGenMap.put("Zero_Padding3D",new HelperLayerGen());
		layerGenMap.put("Reshape",new HelperLayerGen());	
		layerGenMap.put("Flatten",new HelperLayerGen());
		layerGenMap.put("Embedding",new EmbeddingGen());
		
		layerGenMap.put("Batch_Normalization",new HelperLayerGen());
		layerGenMap.put("Layer_Normalization",new HelperLayerGen());
		layerGenMap.put("Masking",new HelperLayerGen());
		
		layerGenMap.put("ReLU",new ActivationGen());	
		layerGenMap.put("Softmax",new ActivationGen());
		layerGenMap.put("Leaky_ReLU",new ActivationGen());
		layerGenMap.put("PReLU",new ActivationGen());
		layerGenMap.put("Thresholded_ReLU",new ActivationGen());
		layerGenMap.put("ELU",new ActivationGen());
		
		layerGenMap.put("Average_Pooling1D",new PoolGen());
		layerGenMap.put("Average_Pooling2D",new PoolGen());
		//layerGenMap.put("Average_Pooling3D",new PoolGen());
		layerGenMap.put("Global_Average_Pooling1D",new PoolGen());
		layerGenMap.put("Global_Average_Pooling2D",new PoolGen());
		layerGenMap.put("Global_Average_Pooling3D",new PoolGen());
		layerGenMap.put("Global_Max_Pool1D",new PoolGen());
		layerGenMap.put("Global_Max_Pool2D",new PoolGen());
		layerGenMap.put("Global_Max_Pool3D",new PoolGen());
		layerGenMap.put("Max_Pool1D",new PoolGen());
		layerGenMap.put("Max_Pool2D",new PoolGen());
		layerGenMap.put("Max_Pool3D",new PoolGen());
	
		layerGenMap.put("Average",new MultiInputGen());
		layerGenMap.put("Add",new MultiInputGen());
		layerGenMap.put("Multiply",new MultiInputGen());
		layerGenMap.put("Minimum",new MultiInputGen());
		layerGenMap.put("Maximum",new MultiInputGen());
		layerGenMap.put("Subtract",new TwoInputGen());	
		layerGenMap.put("Concatenate",new MultiInputGen());
		layerGenMap.put("Dot",new TwoInputGen());
		
		layerGenMap.put("Simple_RNN",new RecurrentGen());
		layerGenMap.put("LSTM",new RecurrentGen());
		layerGenMap.put("GRU",new RecurrentGen());
		layerGenMap.put("Dense",new DenseGen());
	
		layerGenMap.put("Time_Distributed",new TimeDistributedGen());
		
		layerGenMap.put("Simple_RNNCell", new RecurrentGen());
		layerGenMap.put("GRUCell", new RecurrentGen());
		layerGenMap.put("LSTMCell", new RecurrentGen());
		
		layerGenMap.put("Input",new HelperLayerGen());
		layerGenMap.put("Input_Spec",new HelperLayerGen());
		
		layerGenMap.put("Sigmoid",new ActivationGen());
		
//		layerGenMap.put("Conv_LSTM1D",new ConvGen());
//		layerGenMap.put("Conv_LSTM2D",new ConvGen());
//		layerGenMap.put("Conv_LSTM3D",new ConvGen());
		
		GenUtils.init();
		GenUtils.removeLayerfromSelectionNotGeneration("Reshape");
		GenUtils.removeLayerfromSelectionNotGeneration("Embedding");
		GenUtils.removeLayerfromSelectionNotGeneration("Concatenate");
		GenUtils.removeLayerfromSelectionNotGeneration("Input_Spec");
		GenUtils.removeLayerfromSelectionNotGeneration("Input");
		GenUtils.removeLayerfromSelectionNotGeneration("Repeat_Vector");
		GenUtils.removeLayerfromSelectionNotGeneration("Average_Pooling3D");
		GenUtils.removeLayerfromSelectionNotGeneration("Max_Pool3D");
		GenUtils.removeLayerfromSelectionNotGeneration("Time_Distributed");
	}
	
	public static boolean runGivenModelTest(Random rand, Layer l, int index) {
		return runGivenModelTest(rand, l, index, null);
	}
	
	public static boolean runGivenModelTest(Random rand, Layer l, int index, Object input) {

	    	String resVar =null;
		    if(l instanceof LayerGraph) {
				resVar = l.getUniqueName();
		    }
//		    else if(l instanceof LayerSequence ) {
//				    l = new LayerSequence();
//				    ((LayerSequence)l).generateSequence(rand, layerGenMap, layerSequenceLen);
//		    }
//		    else {
//		    }
		    
		    //in = ListHelper.genListandAddDefaultDim(rand, l.getInputShape());
		    if(input == null) {
		    	input = l.generateInput(rand);
		    }
		    
		    System.out.println("----------------------------------Test "+index+" started-------------------------------------");
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Python Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toTensorflowString(input));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String actual = ScriptPython.runScript(l.toTensorflowString(input)).trim();
	    	System.out.println();
	    	
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toPrologString(input));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String expected = ScriptProlog.runScript(l.toPrologString(input), resVar).trim();
	    	System.out.println();
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
    		System.out.println("Actual (Unparsed): " + actual);
    		System.out.println("Expected (Unparsed): " + expected);
    		
	    	
	    	Object a = ListHelper.parseList(actual);
	    	Object e = ListHelper.parseList(expected);
	    	boolean success = ListHelper.compareLists(a, e);
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("Actual:   "+ListHelper.printList(a));
	    	System.out.println("Expected: " + ListHelper.printList(e));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	
	    	if(a != null) {
		    	System.out.println("Output shape: "+ ListHelper.getShapeString(a));
	    	}
	    	else if(e != null) {
		    	System.out.println("Output shape: "+ ListHelper.getShapeString(e));
	    	}
	    	
	    	if(!success) 
	    	{
	    		String saveTest = l.toTensorflowString(input)+"\n\n"+l.toPrologString(input)+ "\n\n"+
	    						  "Actual (Unparsed): " + actual + "\n\n"+ "Expected (Unparsed): " + expected + "\n\n"+
	    						  "Actual:   "+ListHelper.printList(a) + "\n\n"+ "Expected: " + ListHelper.printList(e);
	    		saveTestCase(saveTest,success);
			    System.out.println("Test "+ index+ " failed!");
			    System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println();
		    	return false;
	    	}
	    	else 
	    	{
			    System.out.println("-------------------------------------------------------------------------------------");
			    System.out.println("Test "+ index+ " passed!");
			    System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println();		    	
		    	return true;
			}

    	}
	
	public static void printTestSummary(int total, int failCnt) {
		System.out.println("Summary: "+failCnt + " tests failed "+ (total-failCnt) +" tests successful!");
	}
	
	

	
	public static String filterString(String code) {
		  String partialFiltered = code.replaceAll("(?s)/\\*.*?\\*/","");//("(?:/\\*(?:[^*]|(?:\\*+[^*/]))*\\*+/)|(?://.*)","");//("/\\*.*\\*/", "");
		  String fullFiltered = partialFiltered.replaceAll("%.*(?:\r\n|\r|\n)?", "");
		  return fullFiltered;
	}
	
	private static int countNonBlankLines(String str){
		String adjusted = str.replaceAll("(?m)^[ \t]*\r?\n", "");
		
		   String[] lines = adjusted.split("\r\n|\r|\n");
		   return  lines.length;
		}
	
	public static void CountLines() {
		initLayerGenMap();
		List<String> layers = GenUtils.layers;
		layers.add("Dropout");
		layers.add("Alpha_Dropout");
		layers.add("Spatial_Dropout1D");
		layers.add("Spatial_Dropout2D");
		layers.add("Spatial_Dropout3D");
		layers.add("Gaussian_Dropout");
		layers.add("Gaussian_Noise");
		layers.add("Repeat_Vector");
		layers.add("Average_Pooling3D");
		layers.add("Max_Pool3D");
		layers.add("Conv_LSTM2D");
		layers.add("Time_Distributed");
		layers.add("Input");
		layers.add("Input_Spec");
		layers.add("Reshape");
		layers.add("Concatenate");
		
		HashMap<String, Integer> lineCount = new HashMap<>();
		for (int i = 0; i < layers.size(); i++) {
			layers.set(i, layers.get(i).toLowerCase()+"_layer");
			lineCount.put(layers.get(i),0);
		}
		layers.sort((s2, s1) -> s1.length() - s2.length());
		
		
//		for (int i = 0; i < layers.size(); i++) {
//			System.out.println(layers.get(i));
//			
//		}
		
		String[] files = {	"/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/helperlayer.pl",
							"/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/activation.pl", 
							"/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/pooling.pl",
							"/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/conv.pl",
							"/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/denselayer.pl",
							"/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/dropout.pl",
							"/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/input.pl",
							"/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/locallyconnected.pl",
							"/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/recurrent.pl",
							"/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/math.pl"
							};
		for (String f : files) {
			String code = Util.readFile(f);
			code = filterString(code);
			
//			if(f.contains("conv")) {
//				System.out.print(code);
//			}
			String[] codeParts = code.toLowerCase().split("\n\n\n");
			
			
			for (String c : codeParts) {
				//System.out.println("###########" + c + "###########");
				for (String l : layers) {
					if(c.contains(l)) {
						int lc = countNonBlankLines(c);
						//System.out.println(l+", "+ lc);
						lineCount.put(l,lc);
						layers.remove(l);
						break;
					}
				}
			}
			
			//System.out.println(code);
		}
		
		for (String layer : lineCount.keySet()) {
			System.out.println(layer+", "+ lineCount.get(layer));
		}
		
	}

	
	public static void ModelValidationTest(List<Layer> models, List<Object> inputs, List<String> prologSrcs, List<String> tensorflowSrcs, List<String> results, List<Boolean> successes) {
		initLayerGenMap();
		Map<String,Gen> layerGenMap = GenUtils.layerGenMap;
		List<String> layers = GenUtils.layers;
    	Random rand = new Random();
    	int failCnt = 0;
    	int totalLayerCnt = 0;
    	int testNumber = Config.testNumber;
    	int layerSequenceLen = 5;
    	long start = System.currentTimeMillis();
	    for(int i = 0; i < testNumber; i++) {
	    	String resVar =null;
		    Layer l = null;
		    Object in = null;
		    	l = new GraphGen().generateLayer(rand, "", null, null);
				((LayerGraph)l).validateGraph(rand);	
				resVar = l.getUniqueName();

		    
		    //in = ListHelper.genListandAddDefaultDim(rand, l.getInputShape());
		    in = l.generateInput(rand);
		    
		    models.add(l);
		    inputs.add(i);
	    }
	}
	
	
	public static void generageModelsWithBugs(List<Layer> models, List<Object> inputs, List<String> errorCategories) {
		initLayerGenMap();
		Map<String,Gen> layerGenMap = GenUtils.layerGenMap;
		List<String> layers = GenUtils.layers;
    	Random rand = new Random();
    	int failCnt = 0;
    	int totalLayerCnt = 0;
    	int testNumber = 1000;//Config.testNumber;//100;//10000;//100;//50;//500;
    	boolean sequenceMode = false;
    	boolean graphMode = true;
    	int layerSequenceLen = 5;
    	long start = System.currentTimeMillis();
    	String summary = "";
    	String locations = "";
    	int dimensionErrorCount = 0;
    	int inconsistenInputsCount = 0;
    	int shapeError = 0;
    	int weightErrorCount = 0;
    	int argumentErrorCount = 0;
    	
	    for(int i = 0; i < testNumber; i++) {
	    	String resVar =null;
		    Layer l = null;
		    Object in = null;

	    	l = new GraphGen().generateLayer(rand, "", null, null);
			((LayerGraph)l).validateGraph(rand);	
			if(((LayerGraph)l).getAndRestoreLastModel() != null)
			{
				l = ((LayerGraph)l).getAndRestoreLastModel();
			}
			else
			{
	    		i--;
	    		continue;
			}

			resVar = l.getUniqueName();
			totalLayerCnt += ((LayerGraph)l).getLayerCount();
		    in = l.generateInput(rand);
		    
		    System.out.println("----------------------------------Test "+i+" started-------------------------------------");
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Python Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toTensorflowString(in));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	ArrayList<String> pyErrors = new ArrayList<>();
	    	String actual = ScriptPython.runScript(l.toTensorflowString(in),pyErrors).trim();
	    	System.out.println();
	    	
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
		    try {
		    	System.out.println(l.toPrologString(in));
	    	}
		    catch (Exception e) {
	    		i--;
	    		continue;
			}
		    
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	Map<String, ModelError> errors = new HashMap<>();
	    	String expected = ScriptProlog.runScript(l.toPrologString(in), resVar, errors).trim();
	    	String er = "";
	    	String proEr = "";
	    	String loc = "";
	    	if(!errors.isEmpty()) {
	    		loc = (String)errors.keySet().toArray()[0];
	    		proEr = errors.get(errors.keySet().toArray()[0]).getMessage();
	    		
	    		if(!pyErrors.isEmpty()) {
	    			if(pyErrors.get(0).contains("raise")) {
	    				er = pyErrors.get(0).split("raise")[1];
	    			}
	    			else {
	    				er = pyErrors.get(0);
	    			}
	    		}
	    		else {
		    		i--;
		    		continue;
	    		}
	    		
	    		if(er.contains("not compatible with provided weight shape"))
	    		{
	    			errorCategories.add("Weight Shape");
	    			weightErrorCount++;
	    		}
	    		else if(proEr.contains("Dimension Error") || proEr.contains("Inconsistent Input Dimensions"))
				{
	    			errorCategories.add("Dimension");
	    			dimensionErrorCount++;
				}
	    		else if(proEr.contains("Inconsistent Input Shapes"))
	    		{
	    			errorCategories.add("Inconsistent Input Shapes");
	    			inconsistenInputsCount++;
	    		}
	    		else if(proEr.contains("Shape Error")) {
	    			errorCategories.add("Shapes");
	    			shapeError++;
	    		}
	    		else if(proEr.contains("Argument Error")){
	    			errorCategories.add("Argument");
	    			argumentErrorCount++;
	    		}
	    		else {
	    			errorCategories.add("Other");
	    		}
	    	
	    		
	    		if((proEr.contains("Dimension Error") || proEr.contains("Inconsistent Input Dimensions")) && 
	    			(er.contains("is incompatible with the layer") && (er.contains("expected ndim") || er.contains("expected min_ndim") || er.contains("expected max_ndim")) 
	    					|| er.contains("Dimension incompatibility")
	    					|| er.contains("Shape must be rank")
	    					|| er.contains("not compatible with provided weight shape")	
	    					)
	    			|| (proEr.contains("Argument Error") && er.contains("not compatible with provided weight shape"))	
	    			|| (proEr.contains("Inconsistent Input Shapes") && (er.contains("Operands could not be broadcast together with shapes") || er.isEmpty()))
	    				)
	    		{
	    			//TODO known error handling
	    			summary += i + " " +loc + ":" + proEr + "###" + er + "###"  + "\n" ;
	    		}
	    		else {
	    			summary += i + " " +loc + ":" + proEr + "###" + er + "###"  + "\n" ;
	    		}
	    		

	    		if(!pyErrors.isEmpty()) {
	    			if(!pyErrors.get(0).contains(loc)) {
	    				locations += i + " " + loc +" failed! \n" + pyErrors.get(0) + "\n\n";
	    			}
	    		}
	    		else if(actual.contains("error") || !actual.contains("[") || actual.contains("[]")) {
	    			locations += i + " " + loc +" failed!\n " + actual + "\n\n";
				}
	    		
	    	}
//	    	else if(!pyErrors.isEmpty()) {
//	    		summary += i + " " + l.getUniqueName() + "##########TensorflowOnlyError#######"+ pyErrors.get(0);
//			}
	    	else {
	    		i--;
	    		continue;
	    	}
	    	models.add(l);
	    	inputs.add(in);
	    	
	    	System.out.println();
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
    		System.out.println("Actual (Unparsed): " + actual);
    		System.out.println("Expected (Unparsed): " + expected);
	    	
    		String as ="";
    		String es="";
    		boolean success = false;
    		try {
		    	Object a = ListHelper.parseList(actual);
		    	Object e = ListHelper.parseList(expected);
		    	success = ListHelper.compareLists(a, e);
		    	as = ListHelper.printList(a);
		    	es = ListHelper.printList(e);
		    	
	    		System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println("Actual:   "+as);
		    	System.out.println("Expected: " + es);
		    	System.out.println("-------------------------------------------------------------------------------------");
		    	if(!success) 
		    	{	   		
				    System.out.println("Test "+ i+ " failed!");
				    System.out.println("-------------------------------------------------------------------------------------");
			    	System.out.println();
		    	}
		    	else 
		    	{
				    System.out.println("-------------------------------------------------------------------------------------");
				    System.out.println("Test "+ i+ " passed!");
				    System.out.println("-------------------------------------------------------------------------------------");
			    	System.out.println();
				}
    		}
    		catch(Exception e) {
        		System.out.println("-------------------------------------------------------------------------------------");
        		System.out.println("--------------------Parsing Error--------------------------------------");
        		System.out.println("-------------------------------------------------------------------------------------");
    		}
    		String saveTest = l.toTensorflowString(in)+"\n\n"+l.toPrologString(in)+ "\n\n"+
					  "Actual (Unparsed): " + actual + "\n"+ er+ "\n\n"+ "Expected (Unparsed): " + expected + "\n"+loc+": "+proEr+ "\n\n"+
					  "Actual:   "+as + "\n\n"+ "Expected: " + es;
    		//saveTestCase(saveTest,success);
	    	
//    		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
//    		Date date = new Date(System.currentTimeMillis());
//    		String filename = "buglocalisationtest_"+i+"_" + formatter.format(date)+ ".txt";
//    		Util.writeFile(filename, saveTest);
	    	
	    	if(!success) {failCnt++;}
    	}

	    
	    
    	String errorTypes = "dimensionErrorCount: " + dimensionErrorCount  + " \n"+
    	"inconsistenInputsCount: "+ inconsistenInputsCount  + " \n"+
    	"shapeError: " + shapeError  + " \n"+
    	"weightErrorCount: " + weightErrorCount  + " \n"+
    	"argumentErrorCount: "+ argumentErrorCount  + " \n";
    	
		System.out.println(errorTypes);

//		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
//		Date date = new Date(System.currentTimeMillis());
//
//		
//		String filename = "buglocalisationsummary_" + formatter.format(date)+ ".txt";
//		Util.writeFile(filename, summary+"\n\n "+ locations +"\n\n "+ errorTypes);
	}
	
	public static void testModelFixingImplementation(Random rand) {
		GenUtils.initilised = false;
		initLayerGenMap();
		List<Layer> models = new ArrayList<>();
		List<Object> inputs = new ArrayList<>();
		List<String> errorCategories = new ArrayList<>();
		long totalelapsedTimeMillis = 0;
		generageModelsWithBugs(models, inputs, errorCategories);
		int i = 0;
		String summary = "";
		int fails = 0;
		for (Layer modelToFix : models) {
			List<Layer> fixedModels = new ArrayList<>();
			List<Object> inputs1 = new ArrayList<>();
			List<String> prologSrcs = new ArrayList<>();
			
			
			
	    	long start = System.currentTimeMillis();

	    	
	    	ModelRepairer.findFixes(rand, (LayerGraph)modelToFix,fixedModels, prologSrcs, inputs1, 4);

	    	
	    	//System.out.println("expected "+expected);
	    	long elapsedTimeMillis = System.currentTimeMillis()-start;
	    	totalelapsedTimeMillis +=elapsedTimeMillis;
			
			
			
			
			String fixChangeValues = "";
			for (Layer m : fixedModels) {
				fixChangeValues += ((LayerGraph)m).modelChangeIndicator + " ";
			}
			fixChangeValues = "["+fixChangeValues+"]";
			
			String ermsg = errorCategories.get(i);
			String fixRes = "FixModel "+ (i++) + " Number of Fixes "+fixedModels.size() + " fixes model change value " +fixChangeValues + " for "+ermsg;
			System.out.println(fixRes);
			summary += fixRes + "\n";
			if(fixedModels.isEmpty()) {
				fails++;
			}
		}
		 System.out.println("-------------------Fails "+fails+"------------------- time ms: "+totalelapsedTimeMillis+"-----------------------------------------------");
		System.out.println(summary);
	}
	
	
	public static void testModelFixingImplementationForGivenModel(Random rand, List<Layer> models) {
		// = new ArrayList<>();
//		List<Object> inputs = new ArrayList<>();
//		List<String> errorCategories = new ArrayList<>();
//		generageModelsWithBugs(models, inputs, errorCategories);
		int i = 0;
		String summary = "";
		for (Layer modelToFix : models) {
			HashMap<String,ModelError> errs = new HashMap<String,ModelError>();
			if(ModelRepairer.modelWorks(rand, (LayerGraph)modelToFix, errs)) {//new HashMap<String,ModelError>())) {
				System.out.println("Model works");
				continue;
			}
			else {
				System.out.println("errors at " +errs.keySet().toArray()[0]+ ": "+errs.get(errs.keySet().toArray()[0]));
			}
			List<Layer> fixedModels = new ArrayList<>();
			List<Object> inputs1 = new ArrayList<>();
			List<String> prologSrcs = new ArrayList<>();
			ModelRepairer.findFixes(rand, (LayerGraph)modelToFix,fixedModels, prologSrcs, inputs1, 4);
			String fixChangeValues = "";
			for (Layer m : fixedModels) {
				fixChangeValues += ((LayerGraph)m).modelChangeIndicator + " ";
			}
			fixChangeValues = "["+fixChangeValues+"]";
			
			//String ermsg = errorCategories.get(i);
			String fixRes = "FixModel "+ (i++) + " Number of Fixes "+fixedModels.size() + " fixes model change value " +fixChangeValues;// + " for "+ermsg;
			System.out.println(fixRes);
			summary += fixRes + "\n";
		}
		 System.out.println("-------------------------------------------------------------------------------------");
		System.out.println(summary);
	}
	
	
	public static void singleLayerOutputTest() {
		initLayerGenMap();
		Random rand = new Random();
		//List<Integer> inputShape = Arrays.asList(1, 1, 1,1);
		int testNumber = 50;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand,GenUtils.convLayers);//Arrays.asList("Depthwise_Conv2D"));//"Conv1D_Transpose","Conv2D_Transpose", "Conv3D_Transpose"));//GenUtils.singleInputLayers);
			l0.initUniqueName(rand);

			LayerGraph l = new LayerGraph(l0);
			
			//((LayerGraph)l).validateGraph(rand);
			
			
	    	String resVar =null;
		    if(l instanceof LayerGraph) {
				resVar = l.getUniqueName();
		    }

		    Object input = l.generateInput(rand);
		    System.out.println("Input shape: " + ListHelper.getShapeString(input));
		    

		    System.out.println("Python Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toTensorflowString(input));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String actual = ScriptPython.runScript(l.toTensorflowString(input)).trim();
	    	System.out.println();
	    	
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toPrologString(input));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String expected = ScriptProlog.runScript(l.toPrologString(input), resVar).trim();
	    	System.out.println();
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
    		System.out.println("Actual (Unparsed): " + actual);
    		System.out.println("Expected (Unparsed): " + expected);
    		
	    	
	    	Object a = ListHelper.parseList(actual);
	    	Object e = ListHelper.parseList(expected);
	    	//boolean success = ListHelper.compareLists(a, e);
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("Actual:   "+ListHelper.printList(a));
	    	System.out.println("Expected: " + ListHelper.printList(e));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	
	    	System.out.println("Input shape: "+ ListHelper.getShapeString(((Map<String,Object>)input).get(resVar)));
	    	String tempOutShape = "";
	    	if(e != null) {
		    	System.out.println("Output shape: "+ ListHelper.getShapeString(e));
		    	tempOutShape = ListHelper.getShapeString(e);
	    	}
	    	if(a != null) {
		    	System.out.println("Output shape: "+ ListHelper.getShapeString(a));
		    	//tempOutShape = ListHelper.getShapeString(a);
	    	}
	    	System.out.println("Expected Output shape: "+ ListHelper.getShapeString(l0.getOutputShape()));
	    	
	    	
	    	String expOutShape = ListHelper.getShapeString(l0.getOutputShape());
	    	boolean success = expOutShape.equals(tempOutShape);
	    	System.out.println("-------------------------------------------------------------------------------------");
			
			if(!success) {failCnt++;System.out.println("Test failed!!!!!!!!!!!!!!!!!!!");}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	
	public static void fixtimeTest(List<String> mainLayers) {
		
		Random rand = new Random();
		int testNumber = 5;//ConfigUtil.testNumber; 
		String summary = "";
		//List<Integer> inputShape = Arrays.asList(16,8,8,8);//Arrays.asList(16,64,8);//Arrays.asList(16,8,8,8);//Arrays.asList(8,8,4,2);//Arrays.asList(8,4,4);//Arrays.asList(2,1,1);
		
		GenUtils.initilised = false;
		initLayerGenMap();
		List<String> allowedLayers = new ArrayList<>(mainLayers);
		allowedLayers.addAll(GenUtils.activationLayers);
		//allowedLayers.addAll(GenUtils.helperLayers);
		//allowedLayers.addAll(GenUtils.multiInputLayers);
		//allowedLayers.add("Dense");
		
		GenUtils.restrictLayersToList(allowedLayers);
		
		
		int begin = 10;
		int end = 50;
		int inc = 10;
		if(allowedLayers.contains("Add")) {
			begin = 5;
			end = 20;
			inc = 5;
		}
		
		outer:for(int j = begin; j <=end; j=j+inc) {
	    	long totalelapsedTimeMillis = 0;
	    	float totalelapsedTimeSec = 0;
	    	int layerCount = 0;
	    	int maxTries = 0;
	    	int totalFixedIssues = 0;
	    	long totalInputSize = 0;
	    	long totalFixInputSize = 0;
	    	
			for(int i = 0; i < testNumber; i++) {
				if(j > 16 && maxTries > 300) {
					break outer;
				}
				LinkedHashMap<String, Object> config = new LinkedHashMap<>();
	
				config.put("maxLevel",j);
				if(allowedLayers.contains("Add")) {
					config.put("minLayers",j);
					config.put("maxLayers",j*2);
				}
				config.put("sequenceMode",!allowedLayers.contains("Add"));
		    	Layer l = new GraphGen().generateLayer(rand, "", null, config);//inputShape, config);

		    	 
		    	 Object in = l.generateInput(rand);
		    	 Map<String, ModelError> errors = new HashMap<>();
		    	 String prologScr = l.toPrologString(in);
				String expected = ScriptProlog.runScript(prologScr, l.getUniqueName(), errors);
				
				if(errors.isEmpty()) {// || expected.contains("error") || !expected.contains("[")) {
					//System.out.println("expected: " +expected);
					System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "+j+" Model rejected: " + l.getLayerCount() + " " +(!errors.isEmpty()) +" "+ expected.contains("error") + " " + (!expected.contains("[")));
//					if(!errors.isEmpty()) {
//						System.out.println(errors.get(errors.keySet().toArray()[0]).toString());
//					}
					//System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "+j+" Model rejected: " + l.getLayerCount() + " " +(!errors.isEmpty()) +" "+ expected.contains("error") + " " + (!expected.contains("[")));
					i--;
					 continue;
				 }
				saveTempJson((LayerGraph)l);
		    	 System.out.println("-------------------------------------------------------------------------------------");
		    	 //System.out.println(l.toPrologString(in));
		    	 //saveTestCase(l.toPrologString(in), true);
				
		    	long start = System.currentTimeMillis();
		    	//expected = ScriptProlog.runScript(prologScr, l.getUniqueName());
		    	
		    	ModelRepairer.fixedIssueNumber = 0;
		    	
		    	LayerGraph fix = ModelRepairer.findFixWithMinimalChange(rand, (LayerGraph) l, errors, 5);
//		    	System.out.println("Found fixes count: "+ fixes.size());
		    	totalFixedIssues += ModelRepairer.fixedIssueNumber;
		    	//System.out.println("expected "+expected);
		    	long elapsedTimeMillis = System.currentTimeMillis()-start;
		    	float elapsedTimeSec = elapsedTimeMillis/1000F;
		    	totalelapsedTimeMillis +=elapsedTimeMillis;
		    	totalelapsedTimeSec += elapsedTimeSec;
		    	
		    	
		    	
		    	System.out.println();
		    	System.out.println("-------------------------------------------------------------------------------------");
		    	System.out.println("-------------------------------------------------------------------------------------");
		    	if(fix != null) {
		    		System.out.println("Duration Model "+i+": " + elapsedTimeSec +"s, layers: " + l.getLayerCount() + ", fixed layers: " + fix.getLayerCount());
		    		saveRepairTest(rand, "fix_time_test_"+i, l, fix, elapsedTimeSec,totalelapsedTimeSec);
		    	
			    	long inputsize = ListHelper.estimateSize(l.generateInput(rand));
			    	long fixinputsize = ListHelper.estimateSize(fix.generateInput(rand));
			    	totalInputSize += inputsize;
			    	totalFixInputSize += fixinputsize;
			    	System.out.println("origin input size: " + inputsize + ", repaired input size: "+fixinputsize + " issues: "+ModelRepairer.fixedIssueNumber);
		    	}
		    	else {
		    		saveRepairTest(rand, "fix_time_test_"+i, l, fix, elapsedTimeSec, totalelapsedTimeSec);
		    		System.out.println("------Duration Model "+i+": "+ elapsedTimeSec +"s, layers: " + l.getLayerCount());
				}
		    	
		    	layerCount += l.getLayerCount();
			}
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String output = 
	    			  "Size: "+j + ", "
	    			+ "Average Time Per Issue: "+(totalelapsedTimeSec/(float)totalFixedIssues) + ", "
	    			+ "Average Fixed Issue Nr: " + (totalFixedIssues/testNumber) + ", " 
	    			+ "Average Repair Time: " +(totalelapsedTimeSec/(float)testNumber) +"s, "
	    			+ "Average Layers: "+ ((double)layerCount/(double)testNumber) + ", "
	    			+ "Average Input Size: " +(totalInputSize/testNumber) + ", "
					+ "Average Fix Input Size: " +(totalFixInputSize/testNumber)+"\n";
	    	System.out.print(output);
	    	summary += output;
	    	
	    	
	    	
			SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
			Date date = new Date(System.currentTimeMillis());
			System.out.println();
			String filename = "runtimesummary_" + formatter.format(date)+ ".txt";
			Util.writeFile(filename, summary);
		}
	}
	
	

	
	public static void fixingAccuracyTest(Random rand) {
		GenUtils.initilised = false;
		initLayerGenMap();
    	long totalelapsedTimeMillis = 0;
    	float totalelapsedTimeSec = 0;
    	int layerCount = 0;
    	int fixlayerCount = 0;
    	int maxTries = 0;
    	int fails =0;
    	int totalFixedIssues = 0;
    	int totalChangeValue = 0;
    	long totalInputSize = 0;
    	long totalFixInputSize = 0;
    	
    	int fixedArguments = 0;
    	int addedLayers = 0;
    	int replacedLayers = 0;
    	int reshapeLayersAdded = 0;
    	int paddingLayersAdded = 0;
    	int concatenateLayerAdded = 0;
    	int weightRegenerations = 0;
    	
    	
//    	int validationFails = 0;
//    	int validationRegenerations = 0;
//    	float oldValidationTime = 0;
    	
		String summary = "";
		int testNumber = Config.testNumber;
		for (int i = 0; i < testNumber;i++) {
			
			LinkedHashMap<String, Object> config = new LinkedHashMap<>();
			
			config.put("maxLevel",6);
			config.put("minLayers",5);
			Layer modelToFix = new GraphGen().generateLayer(rand, "", null, config);
			Map<String, ModelError> errors = new HashMap<>();
			if(ModelRepairer.modelWorks(rand, (LayerGraph) modelToFix, errors)) {
				i--;
				System.out.println("skipped model!");
				continue;
			}
			saveTempJson((LayerGraph)modelToFix);
			
//			List<Object> inputs1 = new ArrayList<>();
//			List<String> prologSrcs = new ArrayList<>();
			ModelRepairer.fixedIssueNumber = 0;
			
	    	long start = System.currentTimeMillis();
	    	LayerGraph fix = ModelRepairer.findFixWithMinimalChange(rand, (LayerGraph)modelToFix, 5);
	    	
	    	long elapsedTimeMillis = System.currentTimeMillis()-start;
	    	float elapsedTimeSec = elapsedTimeMillis/1000F;
	    	totalelapsedTimeMillis +=elapsedTimeMillis;
	    	totalelapsedTimeSec += elapsedTimeSec;
			
			totalFixedIssues += ModelRepairer.fixedIssueNumber;
			String fixChangeValues = "";
//			for (Layer m : fixedModels) {
//				fixChangeValues += ((LayerGraph)m).modelChangeIndicator + " ";
//			}
			
			layerCount += modelToFix.getLayerCount();
			//String ermsg = errorCategories.get(i);
			if(fix != null) {
				fixChangeValues = "["+fix.modelChangeIndicator+"]";
				totalChangeValue += fix.modelChangeIndicator;
				fixlayerCount += fix.getLayerCount();

		    	long inputsize = ListHelper.estimateSize(modelToFix.generateInput(rand));
		    	long fixinputsize = ListHelper.estimateSize(fix.generateInput(rand));
		    	totalInputSize += inputsize;
		    	totalFixInputSize += fixinputsize;
		    	
				String fixRes = "test "+ i + ", "
						+ "number of issues: "+ModelRepairer.fixedIssueNumber + ", "
				        + "change value: " +fixChangeValues + ", "
				        + "input size: " + inputsize + ", "
				        + "total input size: "+totalInputSize + ", "
				        + "model size: " + modelToFix.getLayerCount() + ", "
				        + "total model size "+ layerCount + ", "
				        + "repair time: " + elapsedTimeSec + ", "
				        + "total: " + totalelapsedTimeSec + ", "
						+ "fixedArguments: " + fix.fixedArguments + ", "
						+ "addedLayers: " + fix.addedLayers + ", "
						+ "replacedLayers: " + fix.replacedLayers + ", "
						+ "reshapeLayersAdded: " + fix.reshapeLayersAdded + ", "
						+ "paddingLayersAdded: " + fix.paddingLayersAdded + ", "
						+ "concatenateLayerAdded: " + fix.concatenateLayerAdded + ", "
						+ "weightRegenerations: " + fix.weightRegenerations;
				
				
				
		    	fixedArguments += fix.fixedArguments;
		    	addedLayers += fix.addedLayers;
		    	replacedLayers += fix.replacedLayers;
		    	reshapeLayersAdded += fix.reshapeLayersAdded;
		    	paddingLayersAdded += fix.paddingLayersAdded;
		    	concatenateLayerAdded += fix.concatenateLayerAdded;
		    	weightRegenerations += fix.weightRegenerations;
				
				System.out.println(fixRes);
		
				
				
				
				summary += fixRes + ", origin size: " + modelToFix.getLayerCount() + ", repaired size: "+fix.getLayerCount()+ ", repair duration: "+elapsedTimeSec+ "s\n";

//				LayerGraph fix1 = (LayerGraph)modelToFix.copy();
//				long start1 = System.currentTimeMillis();
//				((LayerGraph)fix1).validateGraph(rand);
//		    	long elapsedTimeMillis1 = System.currentTimeMillis()-start1;
//		    	float elapsedTimeSec1 = elapsedTimeMillis1/1000F;
//		    	oldValidationTime += elapsedTimeSec;
//				
//				String validationRes = "validation "+ i + ", "
//				        + "valid time: " + elapsedTimeSec1 + ", "
//				        + "total: " + oldValidationTime + ", "
//						+ "fixedArguments: " + fix1.fixedArguments + ", "
//						+ "addedLayers: " + fix1.addedLayers + ", "
//						+ "replacedLayers: " + fix1.replacedLayers + ", "
//						+ "reshapeLayersAdded: " + fix1.reshapeLayersAdded + ", "
//						+ "paddingLayersAdded: " + fix1.paddingLayersAdded + ", "
//						+ "concatenateLayerAdded: " + fix1.concatenateLayerAdded + ", "
//						+ "weightRegenerations: " + fix1.weightRegenerations;
//				System.out.println(validationRes);
//				summary += validationRes + "\n";
//		    	
//				
//				for (String k : ((LayerGraph)modelToFix).graphLayerMap.keySet()) {
//					if(!fix1.graphLayerMap.containsKey(k)) {
//						validationRegenerations++;
//						break;
//					}
//				}
//				Map<String, ModelError> errors1 = new HashMap<>();
//				if(!ModelValidator.modelWorks(rand, fix1, errors1)) {
//					validationFails++;
//				}
				
			}
			else {
				fails++;
			}
			saveRepairTest(rand, "random_repaired_test_"+i, modelToFix, fix, elapsedTimeSec,totalelapsedTimeSec);
			
		}
		System.out.println("-------------------------------------------------------------------------------------");
		System.out.println(summary);	
    	String output = 
    			  "Average Change Value"+(totalChangeValue/testNumber)+", "
    			+ "Number of Fails "+fails + ",\n"
    			+ "Average Fixed Model Layers "+(fixlayerCount/testNumber)+", "
    		    + "Average Number of Fixed Issues: "+(totalFixedIssues/testNumber)+", "
    		    + "Total Number of Issues: "+totalFixedIssues+",\n"
    		    + "Average Time Per Issue: "+(totalelapsedTimeSec/(float)totalFixedIssues)+ ", "
    		    + "Average Duration: " + (totalelapsedTimeSec/(float)testNumber) +"s,\n"
    		    + "Average Layers: " + ((double)layerCount/(double)testNumber) +","
    		    + "Total Input Size: " + totalelapsedTimeSec + "s,\n"
    		    + "Total Reapir Duration: " + totalelapsedTimeSec + "s,"
    		    + "Average Input Size: " +(totalInputSize/testNumber) +",\n"
    			+ "Average Fix Input Size: " +(totalFixInputSize/testNumber)+",\n"
//    		    + "Total validationRegenerations: " +validationRegenerations+",\n"
//    			+ "Total validationFails: " +(validationFails) + "\n"
		+ "Total fixedArguments: " + fixedArguments + ", "
		+ "Total addedLayers: " + addedLayers + ", "
		+ "Total replacedLayers: " + replacedLayers + ", "
		+ "Total reshapeLayersAdded: " + reshapeLayersAdded + ", "
		+ "Total paddingLayersAdded: " + paddingLayersAdded + ", "
		+ "Total concatenateLayerAdded: " + concatenateLayerAdded + ", "
		+ "Total weightRegenerations: " + weightRegenerations;
    	
    	summary += output;
    	System.out.println(output);
		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
		Date date = new Date(System.currentTimeMillis());
		System.out.println();
		String filename = "rapair_summary_" + formatter.format(date)+ ".txt";
		Util.writeFile(filename, summary);
		
	}
	
	
	
	
	
	public static void dotTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 30;
		int failCnt = 0;
		List<Integer> inputShape = Arrays.asList(1,1);
		List<Integer> inputShape1 = Arrays.asList(2,2);
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, "ReLU",inputShape);
			Layer l1 = GenUtils.genLayer(rand, "ReLU",inputShape1);
			
			LinkedHashMap<String, Object> params = new LinkedHashMap<>();
			params.put("axes", Arrays.asList(2,2));
			Layer l2 = GenUtils.genLayer(rand, "Dot",null,params);

		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			
			
			l0.connectParent(l2);
			l1.connectParent(l2);
			
			LayerGraph l = new LayerGraph(l2);
			System.out.println(l.toPrologString(l.generateInput(rand)));
			
			LayerGraph fix = ModelRepairer.findFixWithMinimalChange(rand, (LayerGraph)l, 5); 
			
			if(fix != null) {
				System.out.println("#######################################3   passed!!!");
				System.out.println(fix.toPrologString(fix.generateInput(rand)));
			}
			else {
				System.out.println("########################################### failed!");
			}

		}
	}
	
	public static void saveTempJson(LayerGraph m) {
		saveJson("tempdel.json", m);
	}
	public static void saveJson(String name, LayerGraph m)
	{
		String json = ((LayerGraph)m).toJsonString();
		
		if(!name.equals("tempdel.json")) {
			SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
			Date date = new Date(System.currentTimeMillis());
			name = name+"_" + formatter.format(date)+ ".json";
		}
		Util.writeFile(name, json);
	}	
	
	private static void saveRepairTest(Random rand, String name, Layer modelToFix, Layer fix, float elapsedTimeSec, float totalElapsedTime) {
	
		String saveTC = "origninal model:\n"+modelToFix.toPrologString(modelToFix.generateInput(rand))+"\n";
		saveTC += "-------------------------------------------------------------------------------------\n";
		saveTC += "json model:\n"+((LayerGraph)modelToFix).toJsonString()+"\n";
		saveTC += "-------------------------------------------------------------------------------------\n";
		
		if(fix != null) {
			saveTC += "-------------------------------------------------------------------------------------\n";
			saveTC += "repaired model:\n"+fix.toPrologString(fix.generateInput(rand))+"\n";
			saveTC += "-------------------------------------------------------------------------------------\n";
			saveTC += "origin size: " + modelToFix.getLayerCount() + " repaired size: "+fix.getLayerCount()+ "\n";
			saveTC += "origin input size: " + ListHelper.estimateSize(modelToFix.generateInput(rand)) + " repaired input size: "+ListHelper.estimateSize(fix.generateInput(rand))+ "\n";
			saveTC += "number of issues: "+ ModelRepairer.fixedIssueNumber;
		}
		else {
			name = "failed_"+name;
			saveTC += "number of issues: "+ ModelRepairer.fixedIssueNumber;
		}
		

		if(totalElapsedTime > 0.0) {
			saveTC += " total repair duration: "+totalElapsedTime +"s";
		}
		
		if(elapsedTimeSec > 0.0) {
			saveTC += " repair duration: "+elapsedTimeSec +"s";
		}

		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
		Date date = new Date(System.currentTimeMillis());
		String filename = name+"_" + formatter.format(date)+ ".txt";
		Util.writeFile(filename, saveTC);
	}
	
	public static void longdurationTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 10;
		int failCnt = 0;
		List<Integer> inputShape = Arrays.asList(2,1);
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, "Leaky_ReLU",inputShape);
			Layer l1 = GenUtils.genLayer(rand, "GRUCell");
			Layer l2 = GenUtils.genLayer(rand, "Simple_RNNCell");
			Layer l3 = GenUtils.genLayer(rand, "Leaky_ReLU");
			Layer l4 = GenUtils.genLayer(rand, "LSTM");
			Layer l5 = GenUtils.genLayer(rand, "Simple_RNN");
			Layer l6 = GenUtils.genLayer(rand, "Softmax");
			Layer l7 = GenUtils.genLayer(rand, "ELU");
			Layer l8 = GenUtils.genLayer(rand, "Simple_RNN");
			Layer l9 = GenUtils.genLayer(rand, "Thresholded_ReLU");
			
		    l0.initUniqueName(rand);
			l1.initUniqueName(rand);
			l2.initUniqueName(rand);
			l3.initUniqueName(rand);
			l4.initUniqueName(rand);
			l5.initUniqueName(rand);
			l6.initUniqueName(rand);
			l7.initUniqueName(rand);
			l8.initUniqueName(rand);
			l9.initUniqueName(rand);
			
			l0.connectParent(l1);
			l1.connectParent(l2);
			l2.connectParent(l3);
			l3.connectParent(l4);
			l4.connectParent(l5);
			l5.connectParent(l6);
			l6.connectParent(l7);
			l7.connectParent(l8);
			l8.connectParent(l9);

			LayerGraph l = new LayerGraph(l9);
			System.out.println(l.toPrologString(l.generateInput(rand)));
			
			 
			System.out.println();
			System.out.println(l.toJsonString());
			System.out.println();
			
	    	long start = System.currentTimeMillis();
	    	LayerGraph fix = ModelRepairer.findFixWithMinimalChange(rand, (LayerGraph)l, 5);
	    	
	    	
	    	//System.out.println("expected "+expected);
	    	long elapsedTimeMillis = System.currentTimeMillis()-start;
	    	float elapsedTimeSec = elapsedTimeMillis/1000F;
			
			if(fix != null) {
				System.out.println();
				System.out.println(fix.toPrologString(fix.generateInput(rand)));
				System.out.println("TIME: "+ elapsedTimeSec);
			}

		}
	}
	
	
	public static void longdurationJsonTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 10;
		int failCnt = 0;
		//List<Integer> inputShape = Arrays.asList(2,1);
		for(int i = 0; i < testNumber; i++) {
			LayerGraph l = null;
			try {
				l =JsonModelParser.parseModelFromPath(rand, "/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tempdelDotConcatenate.json", false);
				System.out.println(l.toPrologString(l.generateInput(rand)));
				System.out.println(l.toArchitectureString());
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			if(l != null) {
				
				System.out.println();
				System.out.println(l.toJsonString());
				System.out.println();
				
		    	long start = System.currentTimeMillis();
		    	LayerGraph fix = ModelRepairer.findFixWithMinimalChange(rand, (LayerGraph)l, 5);
		    	
		    	
		    	//System.out.println("expected "+expected);
		    	long elapsedTimeMillis = System.currentTimeMillis()-start;
		    	float elapsedTimeSec = elapsedTimeMillis/1000F;
				
				if(fix != null) {
					System.out.println();
					System.out.println(fix.toPrologString(fix.generateInput(rand)));
					System.out.println();
					System.out.println(fix.toJsonString());
					System.out.println("TIME: "+ elapsedTimeSec);
				}
			}

		}
	}
	
	public static void SimpleLoadJsonTest(String path) {
		SimpleLoadJsonTest(path, false);
	}
	
	public static void SimpleLoadJsonTest(String path, boolean socratesMode) {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 1;
		int failCnt = 0;
		//List<Integer> inputShape = Arrays.asList(2,1);
		for(int i = 0; i < testNumber; i++) {
			LayerGraph l = null;
			try {
				l =JsonModelParser.parseModelFromPath(rand, path, socratesMode);
				//System.out.println(l.toPrologString(l.generateInput(rand)));
				System.out.println("---------------------------------------------------");
				//System.out.println(l.toJsonString());
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			if(l != null) {
				if(!runGivenModelTest(rand,l,i)) {failCnt++;}
			}
			printTestSummary(testNumber,failCnt);
		}
	}
	
	
//	public static void croppingTest() {
//		initLayerGenMap();
//		Random rand = new Random();
//		int testNumber = 1;
//		int failCnt = 0;
//		List<Integer> inputShape = Arrays.asList();
//		for(int i = 0; i < testNumber; i++) {
//			LinkedHashMap<String, Object> params = new LinkedHashMap<>();
//			
//			Layer l0 = GenUtils.genLayer(rand, "Add",inputShape,null);
//			
//			params.put("croppingSizes", Arrays.asList(new Object[] {0,0},new Object[] {0,0},new Object[] {0,1}));
//			Layer l1 = GenUtils.genLayer(rand, "Cropping3D",null,params);
//			//l1.setInputShape(inputShape);
//			
//			l0.initUniqueName(rand);
//		    l1.initUniqueName(rand);
//		    
//		    l0.connectParent(l1);
//			
//			LayerGraph l = new LayerGraph(l1);
//			System.out.println(l.toPrologString(l.generateInput(rand)));
//			
//			LayerGraph fix = ModelValidator.findFixWithMinimalChange(rand, (LayerGraph)l, 5); 
//			
//			if(fix != null) {
//				System.out.println(fix.toPrologString(fix.generateInput(rand)));
//			}
//
//		}
//	}
	
	public static void JsonSaveLoadTest() {
		initLayerGenMap();

    	Random rand = new Random();
    	int failCnt = 0;
    	int testNumber = 100;//50;//500;
	    for(int i = 0; i < testNumber; i++) {
	    	String resVar =null;
	    	LayerGraph l = (LayerGraph) new GraphGen().generateLayer(rand, "", null, null);
			l.validateGraph(rand);	
	    	//l.pruneLayers();
			
			l.generateInput(rand);
			String origJson = l.toJsonString();
			
			try {
				LayerGraph l1 = JsonModelParser.parseModelFromJsonString(rand, origJson, false);
				
				l1.generateInput(rand);
				String outJson = l1.toJsonString();
			
				if(!origJson.equals(outJson)) {
					failCnt++;
					System.out.println("Test "+ i + " failed!");
					System.out.println("Original:");
					System.out.println("-----------------");
					System.out.println(l.toPrologString(l.generateInput(rand)));
					System.out.println("-----------------");
					System.out.println(origJson);
					System.out.println("-----------------");
					System.out.println("Output:");
					System.out.println(outJson);
					System.out.println("-----------------");
				}
				else {
					System.out.println("Test "+ i + " passed!");
				}
			} catch (Exception e) {
				System.out.println("Test "+ i + " exception!");
				System.out.println("Original:");
				System.out.println("-----------------");
				System.out.println(origJson);
				e.printStackTrace();
				break;
			}   
	    }
	    System.out.println(failCnt+"/"+testNumber + " failed!!" );
	}
	
	
	public static void fixingTimeJsonTest(String path, boolean socratesMode) {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 1;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			LayerGraph l = null;
			try {
				l =JsonModelParser.parseModelFromPath(rand, path, socratesMode);
				//System.out.println(l.toPrologString(l.generateInput(rand)));
				System.out.println(l.toArchitectureString());
				
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			if(l != null) {
//				System.out.println();
//				System.out.println(l.toJsonString());
//				System.out.println();
				HashMap<String,ModelError> errors = new HashMap<String,ModelError>();
				if(!ModelRepairer.modelWorks(rand, l, errors)) {
					System.out.println("errors at " +errors.keySet().toArray()[0]+ ": "+errors.get(errors.keySet().toArray()[0]));
				}
				else {
					System.out.println();
					//System.out.println(l.toPrologString(l.generateInput(rand)));
					System.out.println("Model works!");
				}
				
				
		    	long start = System.currentTimeMillis();
		    	LayerGraph fix = ModelRepairer.findFixWithMinimalChange(rand, (LayerGraph)l, 5);
		    	
		    	
		    	//System.out.println("expected "+expected);
		    	long elapsedTimeMillis = System.currentTimeMillis()-start;
		    	float elapsedTimeSec = elapsedTimeMillis/1000F;
				
		    	//saveRepairTest(rand, "realModel", l, fix, elapsedTimeSec, elapsedTimeSec);
		    	saveRepairTest(rand, "repairOverview", l, fix, elapsedTimeSec, elapsedTimeSec);
		    	
				if(fix != null) {
					Util.writeFile("FixedModelSmallJson.txt", fix.toJsonString(true),true);
					System.out.println();
					//System.out.println(fix.toPrologString(fix.generateInput(rand)));
					System.out.println("Fixed Model Architecture: ");
					System.out.println(fix.toArchitectureString());
					System.out.println();
					System.out.println("Fixed Model Small JSON: ");
					System.out.println(fix.toJsonString(true));
					System.out.println("TIME: "+ elapsedTimeSec);
				}
			}

		}
	}
	
	/* public static void singleLayerTVMTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 3;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, GenUtils.singleInputLayers);//"Embedding");//GenUtils.recurrentLayers);//Arrays.asList("Locally_Connected1D"));//GenUtils.convLayers);//"Dense");//"Embedding");//"Conv_LSTM2D");
			l0.initUniqueName(rand);
			
			LayerGraph l = new LayerGraph(l0);
			
			String m = l.toTensorflowString(l.generateInput(rand));
			m = m.replaceFirst("shape=","name=\"data\",shape=");
			m = m +"\n"+ Layer.saveModelAndData("tsmodel","in0"+l.findFirstInputNode().getUniqueName());
			
			System.out.println(""+m);	
			
			
	    	String resVar =null;
		    if(l instanceof LayerGraph) {
				resVar = l.getUniqueName();
		    }
//		    else if(l instanceof LayerSequence ) {
//				    l = new LayerSequence();
//				    ((LayerSequence)l).generateSequence(rand, layerGenMap, layerSequenceLen);
//		    }
//		    else {
//		    }
		    
		    //in = ListHelper.genListandAddDefaultDim(rand, l.getInputShape());
		    Object input = l.generateInput(rand);
		    
		    System.out.println("----------------------------------Test "+i+" started-------------------------------------");
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Python Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(m);
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	//String actual = ScriptPython.runScript(m).trim();
	    	
	    	String actual = ScriptTVM.runScript(m,new ArrayList<String>(), l);
	    	
	    	System.out.println();
	    	
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toPrologString(input));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String expected = ScriptProlog.runScript(l.toPrologString(input), resVar).trim();
	    	System.out.println();
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
    		System.out.println("Actual (Unparsed): " + actual);
    		System.out.println("Expected (Unparsed): " + expected);
    		
	    	
	    	Object a = ListHelper.parseList(actual);
	    	Object e = ListHelper.parseList(expected);
	    	boolean success = ListHelper.compareLists(a, e);
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("Actual:   "+ListHelper.printList(a));
	    	System.out.println("Expected: " + ListHelper.printList(e));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	
	    	if(a != null) {
		    	System.out.println("Output shape: "+ ListHelper.getShapeString(a));
	    	}
	    	else if(e != null) {
		    	System.out.println("Output shape: "+ ListHelper.getShapeString(e));
	    	}
	    	
	    	System.out.println("Success: "+ success);
			
			if(!success) {
				failCnt++;
			}
			
			
		}
		printTestSummary(testNumber,failCnt);
	} */

	
}
