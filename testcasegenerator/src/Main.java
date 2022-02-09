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
import java.util.function.Function;
import java.util.stream.Stream;

import gen.*;
import layer.*;
import util.*;

public class Main {
	
	public static void main(String[] args) {
		//CountLines();
		//runtimeTest2();
		//runtimeTest3();
		ConfigUtil.readConfig();
		switch (ConfigUtil.testMode) {
			case "normal":regularTests();
				break;
			case "nodeterministic":nondeterminicTests();
				break;
			case "semanticruntime":runtimeTest();
				break;
		default:regularTests();
			break;
		}
		//nondeterminicTests();
		//croppingTest1();
		//croppingTest2();
		//realModelTest();
//		multiInputTest2();
//try {
//	convModel();
//} catch (IOException e) {
//	// TODO Auto-generated catch block
//	e.printStackTrace();
//}
		
		//runtimeTest1();
		
		//bugLocalisationTests();
		//singleLayerTest();
		//singleLayerTest1();
		//regularTests();
		//multiInputTest2();
		//multiInputTest1();
		//runtimeTest();
//		bugLocalisationTests();
		//multiInputTest1();
//		for(int i = 0; i < 2; i++) {
//			regularTests();
//		}
		//regularTests();
		//threeLayerSeqTest();
		//twoLayerSeqTest();
		//multiInputTest1();
		//multiInputTest2();
		//twoLayerSeqTest();
	}
	
	
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
			
			if(!runSingleLayerTest(rand,l,i)) {failCnt++;}
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
			
			if(!runSingleLayerTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
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
		    	((LayerGraph)l).validateGraph(rand,j+100);	
		    	
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
			ScriptPython.writeToFile(filename, summary);
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
			ScriptPython.writeToFile(filename, summary);
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
			
			if(!runSingleLayerTest(rand,l,i)) {failCnt++;}
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
			if(!runSingleLayerTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void singleLayerTest() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 5;
		int failCnt = 0;
		for(int i = 0; i < testNumber; i++) {
			Layer l0 = GenUtils.genLayer(rand, "Cropping1D");
		    l0.initUniqueName(rand);
			LayerGraph l = new LayerGraph(l0);
			
			((LayerGraph)l).validateGraph(rand);
			if(!runSingleLayerTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
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
			if(!runSingleLayerTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	public static void multiInputTest1() {
		initLayerGenMap();
		Random rand = new Random();
		int testNumber = 25;
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
			
			//((LayerGraph)l).validateGraph(rand);
			if(!runSingleLayerTest(rand,l,i)) {failCnt++;}
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
			if(!runSingleLayerTest(rand,l,i)) {failCnt++;}
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
			if(!runSingleLayerTest(rand,l,i)) {failCnt++;}
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
			if(!runSingleLayerTest(rand,l,i)) {failCnt++;}
		}
		printTestSummary(testNumber,failCnt);
	}
	
	
	public static void regularTests() {
		initLayerGenMap();
		Map<String,Gen> layerGenMap = GenUtils.layerGenMap;
		List<String> layers = GenUtils.layers;
//		layers = new ArrayList<>();
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
		//layers.add("Conv_LSTM2D");
		//layers.add("Depthwise_Conv2D");
		//layers.add("LSTM");
		
    	Random rand = new Random();
    	int failCnt = 0;
    	int totalLayerCnt = 0;
    	int testNumber = ConfigUtil.testNumber; //10000;//100;//50;//500;
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
		    
		    System.out.println("----------------------------------Test "+i+" started-------------------------------------");
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Python Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toTensorflowString(in));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String actual = ScriptPython.runScript(l.toTensorflowString(in)).trim();
	    	System.out.println();
	    	
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toPrologString(in));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String expected = ScriptProlog.runScript(l.toPrologString(in), resVar).trim();
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
		ScriptPython.writeToFile(filename, summary);
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
	    		else if(proEr.contains("Dimension error") || proEr.contains("Inconsistent Input Dimensions"))
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
	    	
	    		
	    		if((proEr.contains("Dimension error") || proEr.contains("Inconsistent Input Dimensions")) && 
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
    		ScriptPython.writeToFile(filename, saveTest);
	    	
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
		ScriptPython.writeToFile(filename, summary+"\n\n "+ locations +"\n\n "+ errorTypes);
	}
	
	
	
	
	
	public static void nondeterminicTests() {
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
    	int testNumber = ConfigUtil.testNumber;
    	long start = System.currentTimeMillis();
	    for(int i = 0; i < testNumber; i++) {
	    	String resVar = null;
		    Layer l = null;
		    Object in = null;
		    
		    String layer = layers.get(rand.nextInt(layers.size()));
		    l= layerGenMap.get(layer).generateLayer(rand, layer, null,null);
		    

		    
		    //in = ListHelper.genListandAddDefaultDim(rand, l.getInputShape());
		    in = l.generateInput(rand);
		    
		    System.out.println("----------------------------------Test "+i+" started-------------------------------------");
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Python Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toTensorflowString(in));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String actual = ScriptPython.runScript(l.toTensorflowString(in)).trim();
	    	System.out.println();
	    	
	    	Object a = ListHelper.parseList(actual);
	    	
		    System.out.println("-------------------------------------------------------------------------------------");
		    System.out.println("Prolog Script:");
		    System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println(l.toPrologString(in, a));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	String expected = ScriptProlog.runScript(l.toPrologString(in,a),resVar,null,true).trim();
	    	System.out.println();
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
    		System.out.println("Actual (Unparsed): " + actual);
    		System.out.println("Expected (Unparsed): " + expected);
	    	
	    	
	    	//Object e = ListHelper.parseList(expected);
	    	boolean success = expected.toLowerCase().equals("true.") || expected.startsWith("true Action? Actions");//ListHelper.compareLists(a, e);
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("Actual:   "+ListHelper.printList(a));
	    	//System.out.println("Result: " + ListHelper.printList(e));
	    	System.out.println("-------------------------------------------------------------------------------------");
	    	if(!success) 
	    	{
//	    		String saveTest = l.toTensorflowString(in)+"\n\n"+l.toPrologString(in)+ "\n\n"+
//	    						  "Actual (Unparsed): " + actual + "\n\n"+ "Expected (Unparsed): " + expected + "\n\n"+
//	    						  "Actual:   "+ListHelper.printList(a) + "\n\n"+ "Expected: " + ListHelper.printList(e);
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

	    	if(!success) {failCnt++;}
    	}
	    long elapsedTimeMillis = System.currentTimeMillis()-start;
	    float elapsedTimeSec = elapsedTimeMillis/1000F;
	    float elapsedTimeMin = elapsedTimeMillis/(60*1000F);
	    float elapsedTimeHour = elapsedTimeMillis/(60*60*1000F);
    	System.out.println("Summary: "+failCnt + " tests failed "+ (testNumber-failCnt) +" tests successful in " + elapsedTimeMillis+"ms (" + elapsedTimeSec+"s, "+elapsedTimeMin+"min, "+ elapsedTimeHour+ "h)");
    }
    
	public static void saveTestCase(String t, boolean success) {
		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
		Date date = new Date(System.currentTimeMillis());
		System.out.println();
		String filename = success ? ("testcase_" + formatter.format(date)+ ".txt") : ("failedtest_" + formatter.format(date)+ ".txt");
		//String filename = "/tmptests/buglocalisationtest_" + formatter.format(date)+ ".txt"
		ScriptPython.writeToFile(filename, t);
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
		layerGenMap.put("Average_Pooling3D",new PoolGen());
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
		//layerGenMap.put("Conv_LSTM2D",new ConvGen());
		layerGenMap.put("Dense",new DenseGen());
	
		layerGenMap.put("Time_Distributed",new TimeDistributedGen());
		
		layerGenMap.put("Simple_RNNCell", new RecurrentGen());
		layerGenMap.put("GRUCell", new RecurrentGen());
		layerGenMap.put("LSTMCell", new RecurrentGen());
		
		layerGenMap.put("Input",new HelperLayerGen());
		layerGenMap.put("Input_Spec",new HelperLayerGen());
		
		layerGenMap.put("Sigmoid",new ActivationGen());
		
		GenUtils.init();
		GenUtils.removeLayerfromSelectionNotGeneration("Reshape");
		GenUtils.removeLayerfromSelectionNotGeneration("Concatenate");
		GenUtils.removeLayerfromSelectionNotGeneration("Input_Spec");
		GenUtils.removeLayerfromSelectionNotGeneration("Input");
		GenUtils.removeLayerfromSelectionNotGeneration("Repeat_Vector");
		GenUtils.removeLayerfromSelectionNotGeneration("Average_Pooling3D");
		GenUtils.removeLayerfromSelectionNotGeneration("Max_Pool3D");
		GenUtils.removeLayerfromSelectionNotGeneration("Time_Distributed");
	}
	
	public static boolean runSingleLayerTest(Random rand, Layer l, int index) {
		return runSingleLayerTest(rand, l, index, null);
	}
	
	public static boolean runSingleLayerTest(Random rand, Layer l, int index, Object input) {

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
    		
//    		if(l instanceof LayerGraph) {
//	    		System.out.println("@@@@@@@@@@@@@@@@@@@ Model modifications");
//	    		((LayerGraph)l).printPrologString(input);
//    		}
	    	
	    	Object a = ListHelper.parseList(actual);
	    	Object e = ListHelper.parseList(expected);
	    	boolean success = ListHelper.compareLists(a, e);
	    	
    		System.out.println("-------------------------------------------------------------------------------------");
	    	System.out.println("Actual:   "+ListHelper.printList(a));
	    	System.out.println("Expected: " + ListHelper.printList(e));
	    	System.out.println("-------------------------------------------------------------------------------------");
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


}
