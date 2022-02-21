package util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

public class Config {
	
	public static boolean ShowDebugInfo = true;
	
	public static int testNumber = 10;
	public static String testMode = "normal";
	public static String plotPath = "";
	public static String testCaseOutputPath = "";
	
	public static void readConfig() {
		Properties prop = new Properties();
		String fileName = "app.config";
		try (FileInputStream fis = new FileInputStream(fileName)) {
		    prop.load(fis);
		} catch (FileNotFoundException ex) {
			try (FileInputStream fis = new FileInputStream("../"+fileName)) {
			    prop.load(fis);
			} catch (FileNotFoundException ex1) {
				System.err.println("Didn't find config file "+ fileName +"!!!");
				System.exit(0);
			} catch (IOException ex1) {
				System.err.println("Could not read config file "+ fileName +"!!!");
				System.exit(0);
			}
		} catch (IOException ex) {
			System.err.println("Could not read config file "+ fileName +"!!!");
			System.exit(0);
		}
		System.out.println("Reading Config: commands and paths:");
		System.out.println(prop.getProperty("pythonCommand"));
		ScriptPython.pythonCommand = prop.getProperty("pythonCommand");
		System.out.println(prop.getProperty("tempPythonFilePath"));
		ScriptPython.tempPythonFilePath = prop.getProperty("tempPythonFilePath");
		System.out.println(prop.getProperty("prologCommand"));
		ScriptProlog.prologCommand = prop.getProperty("prologCommand");
		System.out.println(prop.getProperty("prologMainFile"));
		ScriptProlog.prologMainFile = prop.getProperty("prologMainFile");
		System.out.println("test number: "+prop.getProperty("testNumber"));
		testNumber = Integer.parseInt(prop.getProperty("testNumber"));
		System.out.println("test mode: "+prop.getProperty("testMode"));
		testMode = prop.getProperty("testMode");
		System.out.println("Path to save Plots: "+prop.getProperty("plotPath"));
		plotPath = prop.getProperty("plotPath");
		System.out.println("TestCase Output (Save) Path: "+prop.getProperty("testCaseOutputPath"));
		testCaseOutputPath = prop.getProperty("testCaseOutputPath");
	}
	

}
