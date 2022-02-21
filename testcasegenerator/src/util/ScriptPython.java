package util;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class ScriptPython {
	//public static String pythonCommand = "python";//"python -W ignore";
	public static String pythonCommand = "python3";//"python -W ignore";
	public static String tempPythonFilePath = System.getProperty("user.dir")+"/temp.py";
	//public static String tempPythonFilePath ="/home/admin1/Documents/GitHub/TensorFlowPrologSpecTest/temp.py";
	     
	public static String runScript(String script){
		return runScript(script, null);
	}
	public static String runScript(String script, ArrayList<String> errors){
		String ret = "";
		Util.writeFile("temp.py", script);
		String err ="";
		Process p;
		try {
			p = Runtime.getRuntime().exec(pythonCommand + " " + tempPythonFilePath);
			BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while((line = in.readLine()) != null){
				ret += line;
			}
		    BufferedReader in1 = new BufferedReader(new InputStreamReader(p.getErrorStream()));
		    while((line = in1.readLine()) != null){
		       err += line;
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
}