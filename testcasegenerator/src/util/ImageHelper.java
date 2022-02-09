package util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;

import javax.imageio.ImageIO;

public class ImageHelper {

	public static Object readImage(String path) throws IOException{
		File f = new File(path);
		BufferedImage image = ImageIO.read(f);
		
		Object[] input = new Object[32];
		
		HashMap<String, Object> tempinput = new HashMap<String, Object>();
		System.out.println(ListHelper.printList(tempinput));
	    int[][] pixels = new int[32][32];

	    for( int i = 0; i < 32; i++ ) {
	    	Object[] inJ = new Object[32];
	        for( int j = 0; j < 32; j++ ) {
	            int rgb = image.getRGB( i, j );
			    int red = (rgb >> 16) & 0x000000FF;
			    int green = (rgb >>8 ) & 0x000000FF;
			    int blue = (rgb) & 0x000000FF;
			    inJ[j] = new Object[] {(red/ 255.0), (green/ 255.0), (blue/ 255.0)};
	        }
	        input[i] = inJ;
	    }
	    Object[] input1 = new Object[] {input};
	    return input1;
	}
	
}
