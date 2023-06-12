/*package util;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;

import layer.LayerGraph;

public class ScriptTVM {

	public static String runScript(String script){
		return runScript(script, null);
	}
	public static String runScript(String script, ArrayList<String> errors){
		return runScript(script,null,null);
	}
	public static String runScript(String script, ArrayList<String> errors, LayerGraph lg){
		String ret = "";
		Util.writeFile("temp.py", script);
		String err ="";
		Process p;
		try {
			
			String cmd0 = Config.pythonCommand + " " + Config.tempPythonFilePath;
			String cmd1 = "cd /home/admin1/Documents/GitHub/TensorFlowPrologSpecTest";
			String cmd2 = "python -m tf2onnx.convert --saved-model ./tsmodel --output temp.onnx";
			String cmd3 = "tvmc compile --target \"llvm\" --input-shapes \"data:"+ListHelper.getShapeString(lg.getInputShape())+"\" --output temp.tar temp.onnx";
			String cmd4 = "tvmc run --inputs data.npz --output pred.npz temp.tar";
			String cmd5 = "python3 << EOF \n"+"import numpy as np\n"+"b=np.load('pred.npz')\n"+"print(b[\"output_0\"])\n"+"EOF";
			
			p = Runtime.getRuntime().exec(cmd0+" ; "+cmd1+" ; "+cmd2 + " ; "+cmd3+ " ; "+cmd4+ " ; "+cmd5);
			
			
			BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while((line = in.readLine()) != null){
				ret += line;
				System.out.println(line);
			}
		    BufferedReader in1 = new BufferedReader(new InputStreamReader(p.getErrorStream()));
		    while((line = in1.readLine()) != null){
		       err += line;
		       System.out.println(line);
		    }
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		if(!err.contains("I tensorflow/core/platform/cpu_feature_guard.cc:142")) {
			System.out.println(err);
		}
		ret = ret.replace("\r\n", "");
		ret = ret.replace("\n", "");
		ret = ret.replaceAll(" +", " ");
		ret = ret.replace("[ ","[");
		if(errors != null && !err.isEmpty()) {
			errors.add(err);
		}
		return ret.trim();
	}
}*/
