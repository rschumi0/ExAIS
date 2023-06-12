package util;

import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.stream.Stream;

public class Util {
    public static String readFile(String filePath) 
    {
        StringBuilder contentBuilder = new StringBuilder();
 
        try (Stream<String> stream = Files.lines( Paths.get(filePath), StandardCharsets.UTF_8)) 
        {
            stream.forEach(s -> contentBuilder.append(s).append("\n"));
        }
        catch (IOException e) 
        {
            e.printStackTrace();
        }
 
        return contentBuilder.toString();
    }

    public static void writeFile(String filename, String content,boolean includeDate){
    	if(includeDate)
    	{
    		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss_z");
    		Date date = new Date(System.currentTimeMillis());
    		filename = filename.substring(0, filename.lastIndexOf(".")) +"_"+ formatter.format(date) + filename.substring(filename.lastIndexOf(".",filename.length()-1));
    	}
    	writeFile(filename, content);
    	
    }
	
	public static void writeFile(String filename, String content){
		try (FileWriter fileWriter = new FileWriter(filename,false)){
			fileWriter.write(content);
		}catch (IOException e){
			System.out.println(e.getMessage());
		}
	} 
	
	public static String capitaliseFirstLetter(String str) {
		return str.substring(0, 1).toUpperCase() + str.substring(1);
	}
	
	public static boolean isInt(String str) { 
		  try {  
		    Integer.parseInt(str.trim());  
		    return true;
		  } catch(NumberFormatException e){  
		    return false;  
		  }  
		}
	
}