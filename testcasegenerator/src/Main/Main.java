package Main;
import java.util.Arrays;
import java.util.List;
import java.util.Random;
import layer.LayerGraph;
import util.*;

public class Main {
	public static void main(String[] args) {
		Random rand = new Random();
		TestCaseGenerator.initLayerGenMap();
		 Config.readConfig();
		 switch (Config.testMode) {
		 	case "normal":TestCaseGenerator.regularTests();
		 		break;
		 	case "nodeterministic":TestCaseGenerator.nondeterminicTests();
		 		break;
		 	case "semanticruntime":TestCaseGenerator.runtimeTest();
		 		break;
		 	case "gui":new Gui().start(rand);
		 		break;
		 	case "parse":parseModelsTest(rand);
		 		break;
		 	default:TestCaseGenerator.regularTests();
		 	break;
		 }
		//new Gui().start();
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
				LayerGraph l = JsonModelParser.parseModel(rand,json);
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

}
