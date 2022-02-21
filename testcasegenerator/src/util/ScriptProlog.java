package util;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;



public class ScriptProlog {     
	public static String prologCommand = "/usr/bin/swipl --stack-limit=8g --table-space=4g -q -s";
	public static String prologMainFile = "/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/main.pl";
	//public static String prologCommand = "/Applications/SWI-Prolog.app/Contents/MacOS/swipl -q -s";
	//public static String prologMainFile = "/Users/ayeshasadiq/eclipse-workspace/TensorFlowPrologSpec/src/main.pl";
	//public static boolean Config.ShowDebugInfo = true;
	
	public static String runScript(String script){
		return runScript(script,null,new HashMap<String, ModelError>());
	}
	
	public static String runScript(String script, String resVar){
		return runScript(script,resVar,new HashMap<String, ModelError>());
	}
	public static String runScript(String script, String resVar, Map<String, ModelError> errors) {
		return runScript(script,resVar,errors,false);
	}
	
	public static String runScript(String script, String resVar, Map<String, ModelError> errors, boolean removeTrueCase){
		if(errors == null) {
			errors = new HashMap<String, ModelError>();
		}
		String ret = "";
		Process p;
		try {
			p = Runtime.getRuntime().exec(prologCommand +" "+ prologMainFile);
			OutputStream stdin = p.getOutputStream ();
			if(removeTrueCase) {
				stdin.write((script + ".\n").getBytes());
			}
			else {
				stdin.write((script + ";true.\n").getBytes());
				stdin.flush();
				stdin.write("w\n".getBytes());
				stdin.flush();
				stdin.write(".\n".getBytes());
			}
			stdin.flush();
			stdin.write("halt.\n".getBytes());
			stdin.flush();
			stdin.close();
			BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
		    while((line = in.readLine()) != null){
		       ret += line;
		    }
		    BufferedReader in1 = new BufferedReader(new InputStreamReader(p.getErrorStream()));
		    while((line = in1.readLine()) != null){
		       ret += line;
		    }
		} catch (IOException e) {
			e.printStackTrace();
		}
		if(Config.ShowDebugInfo) {System.out.println(ret);}
		if(ret.contains("Invalid Model")) {
			if(Config.ShowDebugInfo) {System.out.println("########################################################################################");
			System.out.println("Invalid model detected!");
			System.out.println("########################################################################################");}
			String[] retParts = ret.split("Badness Value:");
			
//			System.out.println("ret PArts1"+retParts[1]);
			String[] retParts1 = retParts[1].split("Aborted at");
			long badness = Long.parseLong(retParts1[0].trim());
			String[] retParts2 = retParts1[1].split(":");
			String position = retParts2[0].trim();
			String error = retParts2[1].split("!!!")[0].trim();
			String[] errorParts = error.split(", Expected ");
			String expected = "";
			if(errorParts.length > 1) {
				expected = errorParts[1];
			}
			
			errors.put(position, new ModelError(errorParts[0], badness,expected));
			
			return "";
		}
		if(ret.contains("=")) {
			if(resVar == null || resVar.isEmpty()) {
				String[] retParts = ret.split("=");
				ret = retParts[retParts.length-1];
			}
			else {
				String[] retParts = ret.split(resVar + " =");
				if(retParts.length < 2) {
					System.out.println(resVar);
				}
				ret = retParts[1];
				String[] retParts1 = ret.split("=");
				for(int i =0; i< retParts1.length;i++) {
					if(retParts1[i].contains("[") ) {
						ret  = retParts1[i];
						break;
					}
				}
				ret = ret.trim();
				ret = ret.substring(ret.indexOf("["),ret.lastIndexOf("]")+1);
			}
		}
		ret = ret.replace("\r\n", "");
		ret = ret.replace("\n", "");
		ret = ret.replaceAll(" +", " ");
		ret = ret.replace("[ ","[");
		
		//System.out.println("return = "+ret);
		return ret.trim();
	}
}
