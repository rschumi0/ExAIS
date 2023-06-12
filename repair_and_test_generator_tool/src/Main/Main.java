package Main;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import javax.swing.JButton;
import javax.swing.JFrame;

import org.json.simple.parser.ParseException;

import gen.ConvGen;
import layer.ConvLayer;
import layer.Layer;
import layer.LayerGraph;
import util.*;

public class Main {
	
	public static void main(String[] args) { 
		Random rand = new Random();
		TestCaseGenerator.initLayerGenMap();
		Config.readConfig();
	
		switch (Config.testMode) {
			case "generate":TestCaseGenerator.regularTests();
				break;
			case "nodeterministic":TestCaseGenerator.nondeterminicTests();
				break;
			case "semanticruntime":TestCaseGenerator.runtimeTest();
				break;
			case "gui":new Gui().start(rand);
				break;
			case "parse":parseModelsTest(rand);
				break;
			case "repair": TestCaseGenerator.fixingTimeJsonTest(Config.buggyModelJsonFile, Config.socratesMode);
				break;
			case "repairtime": repairTimeTests();
				break;
			case "generaterandrepair": TestCaseGenerator.fixingAccuracyTest(rand);
				break;
			default:TestCaseGenerator.regularTests();
		}
		
		
		
		//TestCaseGenerator.singleLayerTVMTest();
		//new Gui().start(rand);
		//TestCaseGenerator.fixLoadedModelTest(rand, "/home/admin1/AIModelWithBug/AIModelWithBug.json");
		//TestCaseGenerator.fixLoadedModelTest(rand, "/home/admin1/AIModelWithBug/specWithBug.json");

		//TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu/spec.json","/home/admin1/Downloads/benchmark/eran/data/cifar_conv/","/home/admin1/Downloads/benchmark/eran/data/labels/y_cifar.txt");
		
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu_diffai/spec.json","/home/admin1/Downloads/benchmark/eran/data/cifar_conv/","/home/admin1/Downloads/benchmark/eran/data/labels/y_cifar.txt");
//		//TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_big_relu_diffai/spec.json","/home/admin1/Downloads/benchmark/eran/data/cifar_conv/","/home/admin1/Downloads/benchmark/eran/data/labels/y_cifar.txt");
//		//TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/cifar_relu_7_1024/spec.json","/home/admin1/Downloads/benchmark/eran/data/cifar_conv/","/home/admin1/Downloads/benchmark/eran/data/labels/y_cifar.txt");
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/cifar_relu_9_200/spec.json","/home/admin1/Downloads/benchmark/eran/data/cifar_conv/","/home/admin1/Downloads/benchmark/eran/data/labels/y_cifar.txt");
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/cifar_relu_6_100/spec.json","/home/admin1/Downloads/benchmark/eran/data/cifar_conv/","/home/admin1/Downloads/benchmark/eran/data/labels/y_cifar.txt");
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu_pgd/spec.json","/home/admin1/Downloads/benchmark/eran/data/cifar_conv/","/home/admin1/Downloads/benchmark/eran/data/labels/y_cifar.txt");
//		
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/fairness/bank/spec.json","/home/admin1/Downloads/benchmark/fairness/bank/data/","/home/admin1/Downloads/benchmark/fairness/bank/data/labels.txt");
//		
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/fairness/census/spec.json",
//				 "/home/admin1/Downloads/benchmark/fairness/census/data/",
//				"/home/admin1/Downloads/benchmark/fairness/census/data/labels.txt");
//
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/fairness/credit/spec.json",
//				"/home/admin1/Downloads/benchmark/fairness/credit/data/",
//				"/home/admin1/Downloads/benchmark/fairness/credit/data/labels.txt");
//
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu_diffai/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/data/mnist_conv/",
//				"/home/admin1/Downloads/benchmark/eran/data/labels/y_mnist.txt");
		
//		TestCaseGenerator.singleLayerTest();
			
		
		List<String> mnistModels = Arrays.asList(
//						"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/mnist_relu_9_200/spec.json",
//						"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/mnist_conv_small_relu/spec.json",
//						"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/mnist_conv_small_relu_diffai/spec.json",
//						"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/cifar_conv_small_relu/spec.json",
//						"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/cifar_conv_small_relu_diffai/spec.json"
						
//				"/home/admin1/Downloads/benchmark/rnn/nnet/jigsaw_lstm/spec.json",
//				"/home/admin1/Downloads/benchmark/rnn/nnet/jigsaw_gru/spec.json",
//				"/home/admin1/Downloads/benchmark/rnn/nnet/wiki_gru/spec.json",
//				"/home/admin1/Downloads/benchmark/rnn/nnet/wiki_lstm/spec.json"

				
				
		//"/home/admin1/Downloads/benchmark/eran/nnet/mnist_relu_6_100/spec.json"
				//"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu/spec.json"
//		"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu_pgd/spec.json",
		////,
//		"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_super_relu_diffai/spec.json",
//		"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_big_relu_diffai/spec.json",
//		"/home/admin1/Downloads/benchmark/eran/nnet/mnist_sigmoid_6_500_pgd_0.1/spec.json",
//		"/home/admin1/Downloads/benchmark/eran/nnet/mnist_relu_9_200/spec.json",
//		"/home/admin1/Downloads/benchmark/eran/nnet/mnist_sigmoid_6_500_pgd_0.3/spec.json",
//		"/home/admin1/Downloads/benchmark/eran/nnet/mnist_sigmoid_6_500/spec.json"
		);
		//TestCaseGenerator.fixingTimeJsonTest("/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/mnist_relu_9_200/spec_added_bugs.json");
		//TestCaseGenerator.fixingTimeJsonTest("/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/cifar_conv_small_relu/spec_added_bugs.json");
		//TestCaseGenerator.fixingTimeJsonTest("/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/mnist_conv_small_relu/spec_added_bugs.json");
		//TestCaseGenerator.fixingTimeJsonTest("/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/wiki_lstm/spec_added_bugs.json",true);
		//TestCaseGenerator.fixingTimeJsonTest("/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/jigsaw_gru/spec_added_bugs.json",true);
		
		//TestCaseGenerator.fixingTimeJsonTest("/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/svhn/spec_added_bugs.json",false);
		//TestCaseGenerator.fixingTimeJsonTest("/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/svhn/spec.json",false);
		
		//TestCaseGenerator.fixingTimeJsonTest("/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/fashion_mnist/spec_added_bugs.json",false);
		
		
		//TestCaseGenerator.fixingTimeJsonTest("/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/tests/benchmark/fashion_mnist/spec.json",false);
		for (String path : mnistModels) {
			//TestCaseGenerator.fixingTimeJsonTest(path,true);//SimpleLoadJsonTest(path,true);
//			TestCaseGenerator.loadedModelAndCheckAccuracy(rand,path,
//					"/home/admin1/Downloads/benchmark/eran/data/mnist_fc/",
//					"/home/admin1/Downloads/benchmark/eran/data/labels/y_mnist.txt");
		}
		
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/data/mnist_conv/",
//				"/home/admin1/Downloads/benchmark/eran/data/labels/y_mnist.txt");
		
		
		//TestCaseGenerator.JsonSeqTest();
		
		
		//TestCaseGenerator.regularTests();
		
		//TestCaseGenerator.singleLayerOutputTest();
		
		
		List<String> buggyModels = Arrays.asList(
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec1.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec2.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec3.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec4.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec5.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec6.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec7.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec8.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec9.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec10.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec11.json",
//				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec12.json",
				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec13.json",
				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec14.json",
				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec15.json",
				"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec16.json"
					);
		
		
		for (String path : buggyModels) {
			//TestCaseGenerator.fixingTimeJsonTest(path,false);
		}
		//TestCaseGenerator.singleLayerTest();
		
		//TestCaseGenerator.longdurationJsonTest();
		
		//TestCaseGenerator.dotTest();
		
//		
//		TestCaseGenerator.fixingAccuracyTest(rand);
		//TestCaseGenerator.singleLayerTest();
		
//		TestCaseGenerator.longdurationJsonTest();
		
//		TestCaseGenerator.croppingTest();
		
//		TestCaseGenerator.SimpleLoadJsonTest();	
		
//		TestCaseGenerator.fixingAccuracyTest(rand);	
//		
//		

		
		
//		TestCaseGenerator.JsonSaveLoadTest();

		
//		TestCaseGenerator.SimpleLoadJsonTest("/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu/spec.json",true);
		//TestCaseGenerator.longdurationJsonTest();
		
		
		
		//TestCaseGenerator.fixingAccuracyTest(rand);
//for(int i = 0; i<10;i++) {
//	TestCaseGenerator.fixingAccuracyTest(rand);
//	        
//}

//TestCaseGenerator.dotTest();

		//TestCaseGenerator.testModelFixingImplementation(rand);
		
	//	TestCaseGenerator.singleLayerOutputTest();
//		for (String m : mnistModels) {
//			try {
//				LayerGraph l = JsonModelParser.parseModel(rand,m);
//				
//				
//				
//				do {
//					System.out.println(l.toArchitectureString());
//					Object randLK = l.graphLayerMap.keySet().toArray()[rand.nextInt(l.graphLayerMap.size())];
//					Layer randL = l.graphLayerMap.get(randLK);
//					//l.removeLayer(rand, randL);
//					Layer lNew = GenUtils.genLayer(rand,GenUtils.singleInputLayers);	
//					l.replaceLayer(rand, randL, lNew);
//				}while(ModelValidator.modelWorks(rand, (LayerGraph)l, new HashMap<String,ModelError>()));
//					
//
//				
//				System.out.println("removed Layer Model: " );
//				System.out.println(l.toArchitectureString());
//				TestCaseGenerator.testModelFixingImplementationForGivenModel(rand, new ArrayList<Layer>(Arrays.asList(l)));
//							
//				
//			} catch (ParseException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//		}
		
//	    TestCaseGenerator.testModelFixingImplementation(rand);
	//	TestCaseGenerator.twoLayerSeqTestWithNewFixingStragy();
		//TestCaseGenerator.threeLayerSeqTestWithNewFixingStragy();
		//TestCaseGenerator.multiInputTestWithNewFixingStragy();
		//TestCaseGenerator.threeLayerSeqTestWithNewFixingStragy();
		
		//TestCaseGenerator.denseReluSeqTest();
		
		//TestCaseGenerator.multiInputTestWithNewFixingStragyTempDel();
		//TestCaseGenerator.layerSeqTestWithNewFixingStragyWithPlots();
		
//		LinkedHashMap<String, Object> config0 = new LinkedHashMap<>();
//		config0.put("nodeNumber", 80);
//		config0.put("kernelSizes", Arrays.asList(8,8));
//		config0.put("strides", Arrays.asList(4,4));
//		config0.put("dilation_rates", Arrays.asList(1,1));
//		config0.put("padding", false);	
//		ConvLayer l = (ConvLayer)GenUtils.genLayer(rand, "Conv2D", Arrays.asList(80,80,1), config0);
//		LayerGraph lg = new LayerGraph(l);
//		TestCaseGenerator.runSingleLayerTest(rand, l, 0);
		//TestCaseGenerator.runModel(rand, lg, in, errors)
		
	
				
//		LinkedHashMap<String, Object> config0 = new LinkedHashMap<>();
//		config0.put("nodeNumber", 160);
//		config0.put("kernelSizes", Arrays.asList(4,4));
//		config0.put("strides", Arrays.asList(2,2));
//		config0.put("dilation_rates", Arrays.asList(1,1));
//		config0.put("padding", false);	
//		ConvLayer l = (ConvLayer)GenUtils.genLayer(rand, "Conv2D", Arrays.asList(19, 19, 80), config0);
//		LayerGraph lg = new LayerGraph(l);
//		TestCaseGenerator.runSingleLayerTest(rand, l, 0);
//		
//		
//		System.out.println(ListHelper.printList(l.getInputWeights()));
//		System.out.println(ListHelper.getShapeString(l.getInputWeights()));
//		for (String p : l.getParams().keySet()) {
//			System.out.println(p+": "+ l.getParams().get(p));
//		}
//		System.out.println(Arrays.toString((l.getInputShape().toArray())));
//		System.out.println("-------------------------------");
//		System.out.println(ListHelper.printList(l.getOutputWeights()));
//		
//		
		
		
		
//		
//		LayerGraph l;
//		try {
//			l = JsonModelParser.parseModel(rand,"/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/model_bugs/spec11.json",false);
//			System.out.println(l.toPrologString(l.generateInput(rand)));
//			TestCaseGenerator.testModelFixingImplementationForGivenModel(rand, new ArrayList<Layer>(Arrays.asList(l)));
//		} catch (ParseException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		TestCaseGenerator.bugLocalisationTests();
		
		
		//new GraphViz().simpleGraphCreation("1->2;2->3;3->\"WER234: Cropping1D\"", "asdfdot");
		
		
//		String transposeTest = "[[[[1,2,3],[4,5,6]],[[7,8,9],[10,11,12]]], [[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]]]]";
//		Object o = ListHelper.parseList(transposeTest);
//		System.out.println(ListHelper.printList(o));
//		System.out.println("Shape: "+ Arrays.toString(ListHelper.getShape(o).toArray()));
//		Object o1 = ListHelper.transpose3D((Object[]) o);
//		System.out.println(ListHelper.printList(o1));
//		X = [[[[1, 2, 3], [4, 5, 6]], [[13, 14, 15], [16, 17, 18]]], [[[7, 8, 9], [10, 11, 12]], [[19, 20, 21], [22, 23, 24]]]].

//		Object[] o2 = new Object[((Object[])o).length];
//		int i = 0;
//		for (Object o3 : (Object[])o) {
//			o2[i]=ListHelper.transpose2D((Object[]) o3);
//			i++;
//		}
//		Object[] o2 = (Object[]) ListHelper.transpose2D((Object[]) o);
//		System.out.println(ListHelper.printList(o2));
		
		
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/mnist_relu_6_100/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/data/mnist_fc/",
//				"/home/admin1/Downloads/benchmark/eran/data/labels/y_mnist.txt");
//		
//		TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/data/cifar_conv/",
//				"/home/admin1/Downloads/benchmark/eran/data/labels/y_cifar.txt");
		
//		
		
		//TestCaseGenerator.loadedModelAndCheckAccuracy(rand,"/home/admin1/Downloads/benchmark/fairness/bank/spec.json","/home/admin1/Downloads/benchmark/fairness/bank/data/","/home/admin1/Downloads/benchmark/fairness/bank/data/labels.txt");
//		"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu/spec.json",
//		"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu_diffai/spec.json",
//		//"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_big_relu_diffai/spec.json",
//		//"/home/admin1/Downloads/benchmark/eran/nnet/cifar_relu_7_1024/spec.json",
//		"/home/admin1/Downloads/benchmark/eran/nnet/cifar_relu_9_200/spec.json",
//		"/home/admin1/Downloads/benchmark/eran/nnet/cifar_relu_6_100/spec.json",
//		"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu_pgd/spec.json",
		
		//new Gui().start(rand);
		
		//new GraphViz().simpleGraphCreation("1->2;1->3;1->4;4->5;4->6;6->7;5->7;3->8;3->6;8->7;2->8;", "asdfdot");;
	///	TestCaseGenerator.twoLayerSeqTestWithNewFixingStragy();
	//	TestCaseGenerator.threeLayerSeqTestWithNewFixingStragy();
		//TestCaseGenerator.twoLayerSeqTestWithInputShape1();
		//TestCaseGenerator.singleLayerTest();
		//TestCaseGenerator.singleLayerTest();
		//TestCaseGenerator.nondeterminicTests();
		//TestCaseGenerator.croppingTest1();
		//TestCaseGenerator.croppingTest2();
		//TestCaseGenerator.realModelTest();
		//try {
		//	TestCaseGenerator.convModel();
		//} catch (IOException e) {
		//	// TODO Auto-generated catch block
		//	e.printStackTrace();
		//}	
		//TestCaseGenerator.bugLocalisationTests();
		//TestCaseGenerator.singleLayerTest();
		//TestCaseGenerator.singleLayerTest1();
		//TestCaseGenerator.regularTests();
		//TestCaseGenerator.multiInputTest2();
		//TestCaseGenerator.multiInputTest1();
		//TestCaseGenerator.runtimeTest();
		//TestCaseGenerator.multiInputTest1();
		//TestCaseGenerator.regularTests();
		//TestCaseGenerator.threeLayerSeqTest();
		//TestCaseGenerator.twoLayerSeqTest();
		//TestCaseGenerator.multiInputTest1();
		//TestCaseGenerator.multiInputTest2();
		//TestCaseGenerator.twoLayerSeqTest();
	}
	
	public static void parseModelsTest(Random rand) {
		List<String> jsonModels = Arrays.asList(
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_2_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_2_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_5_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_4_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_1_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_4_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_5_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_5_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_3_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_5_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_2_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_1_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_4_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_3_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_3_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_1_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_3_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_4_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_3_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_5_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_4_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_4_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_1_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_3_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_1_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_4_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_5_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_2_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_2_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_4_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_5_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop1/prop1_nnet_2_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop7/prop7_nnet_1_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_5_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_5_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_3_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_3_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_2_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_3_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_1_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_4_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_2_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_3_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_5_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_3_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_5_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_3_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_2_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_1_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_4_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_3_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_1_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_2_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_5_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_1_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_2_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_3_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_3_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_5_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_2_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_2_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_1_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_4_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_5_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_4_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_4_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_5_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_4_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_2_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_4_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_2_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_1_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_4_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_5_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop4/prop4_nnet_4_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop8/prop8_nnet_2_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop9/prop9_nnet_3_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop10/prop10_nnet_4_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop5/prop5_nnet_1_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_1_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_3_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_2_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_5_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_5_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_4_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_4_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_3_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_4_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_1_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_2_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_5_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_2_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_1_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_1_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_4_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_5_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_3_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_4_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_2_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_3_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_3_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_5_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_3_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_2_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_4_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_2_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_4_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_5_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_5_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_2_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_4_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_5_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_1_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_3_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_4_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_5_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_2_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_2_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_3_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_3_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop3/prop3_nnet_1_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_2_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_2_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_5_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_2_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_4_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_5_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_3_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_5_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_5_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_3_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_4_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_5_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_4_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_3_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_2_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_5_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_3_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_3_8.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_4_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_2_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_4_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_4_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_3_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_3_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_4_5.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_5_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_3_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_2_3.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_5_1.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_4_6.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_2_2.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_2_7.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_3_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_4_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_5_4.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop2/prop2_nnet_2_9.json",
//				"/home/admin1/Downloads/benchmark/reluplex/specs/prop6/prop6_nnet_1_1.json",
//				//"/home/admin1/Downloads/benchmark/eran/nnet/mnist_tanh_6_500_pgd_0.3/spec.json",
//				//"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_big_relu_diffai/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu_diffai/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_relu_6_100/spec.json",
//				//"/home/admin1/Downloads/benchmark/eran/nnet/cifar_relu_7_1024/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/cifar_relu_9_200/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_sigmoid_6_500/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_super_relu_diffai/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_relu_4_1024/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_relu_9_200/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/cifar_relu_6_100/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu_pgd/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_tanh_6_500_pgd_0.1/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_sigmoid_6_500_pgd_0.1/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu_pgd/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu/specWithBug.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_tanh_6_500/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_big_relu_diffai/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu_diffai/spec.json",
//				"/home/admin1/Downloads/benchmark/eran/nnet/mnist_sigmoid_6_500_pgd_0.3/spec.json",
//				"/home/admin1/Downloads/benchmark/mnist_challenge/spec.json",
//				"/home/admin1/Downloads/benchmark/fairness/credit/spec.json",
//				"/home/admin1/Downloads/benchmark/fairness/bank/spec.json",
//				"/home/admin1/Downloads/benchmark/fairness/census/spec.json");
				"/home/admin1/Downloads/benchmark/rnn/nnet/jigsaw_lstm/spec.json");
//				"/home/admin1/Downloads/benchmark/rnn/nnet/jigsaw_gru/spec.json");
//				"/home/admin1/Downloads/benchmark/rnn/nnet/wiki_gru/spec.json",
//				"/home/admin1/Downloads/benchmark/rnn/nnet/wiki_lstm/spec.json");
		int i = 0;
		for (String json : jsonModels) {
			try {
				//LayerGraph l = JsonModelParser.parseModel(rand,"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu/specWithBug.json");
						//"/home/admin1/Downloads/benchmark/eran/nnet/cifar_conv_small_relu_pgd/spec.json");
						//"/home/admin1/Downloads/benchmark/eran/nnet/mnist_sigmoid_6_500/spec.json");
						//"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_super_relu_diffai/spec.json");
						//"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu_pgd/spec.json");
						//"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu_diffai/spec.json");
						//"/home/admin1/Downloads/benchmark/eran/nnet/mnist_conv_small_relu/spec.json");
						//"/home/admin1/Downloads/benchmark/fairness/census/spec.json");
				LayerGraph l = JsonModelParser.parseModelFromPathGraph(rand,json);
				l.validateGraph(rand);
				TestCaseGenerator.givenLayerTest(l);
				//new OnnxModelParser().loadModel(rand,"/home/admin1/Downloads/tinyyolov2-7.onnx");//("/home/admin1/mymodel2.onnx");//"/home/admin1/Downloads/mobilenetv2_7.onnx");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("Modle " + (i++) + " finished!");
		}
		
	}
	
	public static void repairTimeTests() {
		TestCaseGenerator.fixtimeTest(Arrays.asList("Dense"));
		TestCaseGenerator.fixtimeTest(GenUtils.recurrentLayers);
		TestCaseGenerator.fixtimeTest(GenUtils.poolLayers);
		TestCaseGenerator.fixtimeTest(GenUtils.convLayers);
		
		List<String> allowedLayers = new ArrayList<>(GenUtils.multiInputLayers);
		allowedLayers.add("Dense");
		TestCaseGenerator.fixtimeTest(allowedLayers);
		
		allowedLayers = new ArrayList<>(GenUtils.multiInputLayers);
		allowedLayers.addAll(GenUtils.recurrentLayers);
		TestCaseGenerator.fixtimeTest(allowedLayers);
		
        allowedLayers = new ArrayList<>(GenUtils.multiInputLayers);
		allowedLayers.addAll(GenUtils.poolLayers);
		TestCaseGenerator.fixtimeTest(allowedLayers);
		
        allowedLayers = new ArrayList<>(GenUtils.multiInputLayers);
		allowedLayers.addAll(GenUtils.convLayers);
		TestCaseGenerator.fixtimeTest(allowedLayers);
	}
	

}
