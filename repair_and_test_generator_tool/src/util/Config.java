package util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

public class Config {
	
	public static boolean ShowDebugInfo = false;
	
	public static int testNumber = 10;
	public static String testMode = "normal";
	public static String plotPath = "";
	public static String testCaseOutputPath = "";
	
	public static String prologCommand = "/usr/bin/swipl --stack-limit=8g --table-space=4g -q -s";
	public static String prologMainFile = "/home/admin1/Documents/GitHub/TensorFlowPrologSpec/src/main.pl";
	public static String pythonCommand = "python3";//"python -W ignore";
	public static String tempPythonFilePath = System.getProperty("user.dir")+"/temp.py";
	
	public static String dotCommand = "dot";
	
	public static boolean saveTestsAsJson = true;
	
	public static String buggyModelJsonFile = "";
	public static boolean socratesMode = false;
	
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
		pythonCommand = prop.getProperty("pythonCommand");
		System.out.println(prop.getProperty("tempPythonFilePath"));
		tempPythonFilePath = prop.getProperty("tempPythonFilePath");
		System.out.println(prop.getProperty("prologCommand"));
		prologCommand = prop.getProperty("prologCommand");
		System.out.println(prop.getProperty("prologMainFile"));
		prologMainFile = prop.getProperty("prologMainFile");
		System.out.println("test number: "+prop.getProperty("testNumber"));
		testNumber = Integer.parseInt(prop.getProperty("testNumber"));
		System.out.println("test mode: "+prop.getProperty("testMode"));
		testMode = prop.getProperty("testMode");
		System.out.println("Path to save Plots: "+prop.getProperty("plotPath"));
		plotPath = prop.getProperty("plotPath");
		System.out.println("TestCase Output (Save) Path: "+prop.getProperty("testCaseOutputPath"));
		testCaseOutputPath = prop.getProperty("testCaseOutputPath");
		System.out.println("Dot Command: "+prop.getProperty("dotCommand"));
		dotCommand = prop.getProperty("dotCommand");
		System.out.println("Buggy Model file path that should be repaired: "+prop.getProperty("buggyModelJsonFile"));
		buggyModelJsonFile = prop.getProperty("buggyModelJsonFile");
		System.out.println("Model loaded from Socrates Json: "+prop.getProperty("socratesMode"));
		dotCommand = prop.getProperty("socratesMode");
		
	}
	

}
