package util;

import java.io.IOException;

//import ai.onnxruntime.OrtEnvironment;
//import ai.onnxruntime.OrtException;
//import ai.onnxruntime.OrtSession;
//import ai.onnxruntime.OrtSession.Result;
//import ai.onnxruntime.OrtSession.SessionOptions;
//import ai.onnxruntime.OrtSession.SessionOptions.ExecutionMode;
//import ai.onnxruntime.OrtSession.SessionOptions.OptLevel;

import java.nio.file.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.bytedeco.javacpp.*;
import org.bytedeco.onnx.*;

import layer.*;

import static org.bytedeco.onnx.global.onnx.*;

public class OnnxModelParser {
    public void loadModel(Random rand, String path) throws IOException {
    	Map<String,InputOutput> inouts = new HashMap<>();
    	Map<String,LayerWrapper> layers = new HashMap<>();
//        OpSchemaVector allSchemas = OpSchemaRegistry.get_all_schemas();
//        System.out.println(allSchemas.size());

        byte[] bytes = Files.readAllBytes(Paths.get(path));

        ModelProto model = new ModelProto();
        ParseProtoFromBytes(model, new BytePointer(bytes), bytes.length);

        check_model(model);
        InferShapes(model);

//        StringVector passes = new StringVector("eliminate_nop_transpose", "eliminate_nop_pad", "fuse_consecutive_transposes", "fuse_transpose_into_gemm");
//        Optimize(model, passes);

        check_model(model);
        

        System.out.println(model.graph().input_size());
        System.out.println(model.graph().node_size());
        for(int i = 0; i < model.graph().node_size(); i++) {
        	System.out.println(model.graph().node(i).toString());
        	System.out.println(model.graph().node(i).name().getString());
        	String name = model.graph().node(i).name().getString();
        	LayerWrapper lw = new LayerWrapper(name);
        	System.out.println(model.graph().node(i).op_type().getString());
        	lw.type = model.graph().node(i).op_type().getString();
        	for(int j = 0; j < model.graph().node(i).attribute_size(); j++) {
        		System.out.println( "     "+model.graph().node(i).attribute(j).name().getString());
        		System.out.println( "     "+model.graph().node(i).attribute(j).type());
//        		System.out.println( "     "+model.graph().node(i).attribute(j).GetTypeName());
//        		System.out.println( "     "+model.graph().node(i).attribute(j).g());
//        		System.out.println( "     "+model.graph().node(i).attribute(j).descriptor());
//        		System.out.println( "     "+model.graph().node(i).attribute(j).i());
//        		System.out.println( "     "+model.graph().node(i).attribute(j).f());
//        		System.out.println( "     "+model.graph().node(i).attribute(j).ints_size());
//        		if(model.graph().node(i).attribute(j).ints_size()> 0)
//        		{
//        			System.out.println( "     "+model.graph().node(i).attribute(j).ints(0));
//        		}
        		int t = model.graph().node(i).attribute(j).type();
        		if(t == AttributeProto.FLOAT ) {
					lw.params.put("", ""+model.graph().node(i).attribute(j).f());
        		} else if(t == AttributeProto.INT) {
					lw.params.put("", ""+model.graph().node(i).attribute(j).i());
				} else if(t == AttributeProto.STRING) {
					lw.params.put("", ""+model.graph().node(i).attribute(j).s().getString());
				}
				else if(t == AttributeProto.INTS) {
					String p = "";
					for(int k = 0; k < model.graph().node(i).attribute(j).ints_size(); k++) {
						p += model.graph().node(i).attribute(j).ints(k) + ",";
					}
					p = p.substring(1,p.length()-1) +")";
					lw.params.put("", p);
				}
				else if(t == AttributeProto.FLOATS) {
					String p = "";
					for(int k = 0; k < model.graph().node(i).attribute(j).floats_size(); k++) {
						p += model.graph().node(i).attribute(j).floats(k) + ",";
					}
					p = p.substring(1,p.length()-1) +")";
					lw.params.put("", p);
				}
        		
        	}
    		for(int j = 0; j < model.graph().node(i).input_size(); j++){
    			String in  = model.graph().node(i).input(j).getString();
    			InputOutput tempIO = new InputOutput(in);
    			inouts.put(in, tempIO);
    			lw.inputs.put(in,tempIO);
//    			System.out.println( "     "+model.graph().node(i).input(0).getString());
    		}
    		for(int j = 0; j < model.graph().node(i).output_size(); j++){
    			String out  = model.graph().node(i).output(j).getString();
    			InputOutput tempIO = new InputOutput(out);
    			inouts.put(out, tempIO);
    			lw.outputs.put(out, tempIO);
//    			System.out.println( "     "+model.graph().node(i).input(0).getString());
    		}
    		
    		layers.put(name, lw);
        }
        for(int i = 0; i < model.graph().initializer_size(); i++) {
	    	System.out.println(model.graph().initializer(i).toString());
	    	System.out.println(model.graph().initializer(i).dims_size());
	    	System.out.println(model.graph().initializer(i).name().getString());
	    	
	    	InputOutput inout = inouts.get(model.graph().initializer(i).name().getString());
	    	System.out.print("DIMS: ");
	    	for(int j = 0; j < model.graph().initializer(i).dims_size(); j++) {
	    		System.out.print((int)model.graph().initializer(i).dims(j)+ " ");
	    		inout.shape.add((int)model.graph().initializer(i).dims(j));
	    	}
	    	System.out.println();
//	    	System.out.println(model.graph().initializer(i).data_type());
//	    	System.out.println(model.graph().initializer(i).doc_string());
//	    	System.out.println(model.graph().initializer(i).ByteSize());
//	    	System.out.println(model.graph().initializer(i).data_location());
//	    	System.out.println(model.graph().initializer(i).ByteSize());
//	    	System.out.println(model.graph().initializer(i).string_data_size());
//	    	System.out.println(model.graph().initializer(i).external_data_size());
//	    	System.out.println(model.graph().initializer(i).int64_data_size());
//	    	System.out.println(model.graph().initializer(i).int64_data_size());
//	    	System.out.println(model.graph().initializer(i).uint64_data_size());
//	    	System.out.println( model.graph().initializer(i));
//	    	System.out.println(model.graph().initializer(i).has_raw_data());
//	    	System.out.println(model.graph().initializer(i).raw_data().capacity());
	    	
	    	if(model.graph().initializer(i).has_raw_data())
	    	{
	    		System.out.println("DataSize: " + inout.getDataSize() + " = " + (model.graph().initializer(i).raw_data().capacity()/4));
//		    	for(int j = 0; j < model.graph().initializer(i).raw_data().capacity()/4; j++) {
//		    		System.out.print(model.graph().initializer(i).raw_data().getFloat(j)+",");
//		    	}
	    		dataIndex = 0;
	    		inout.data = buildObjectArrayStructue(inout.shape,model.graph().initializer(i));
	    	}
//	    	if(model.graph().initializer(i).name().getString().contains("bias") || model.graph().initializer(i).name().getString().contains("weight")) {
//		    	for(int j = 0; j < model.graph().initializer(i).raw_data().capacity()/4; j++) {
//		    		System.out.print(model.graph().initializer(i).raw_data().getFloat(j)+",");
//		    	}
//	    	}
//	    	System.out.println();
//	    	System.out.println();
	    }

        
//        for(int i = 0; i < model.graph().value_info_size(); i++) {
//        	System.out.println(model.graph().value_info(i).toString());
//        	System.out.println(model.graph().value_info(i).doc_string());
//        	System.out.println(model.graph().value_info(i).name().getString());
//        	System.out.println(model.graph().value_info(i).type());
//        	System.out.println(model.graph().value_info(i).GetMetadata());
//        }
//        System.out.println(model.doc_string());        
//        System.out.println(model.graph().doc_string()); 
        
        LayerGraph lg = buildGraph(rand, inouts, layers);
        Object in = lg.generateInput(new Random());
        System.out.println(lg.toPrologString(in));//(Object)new HashMap<>()));
    }
    
    public LayerGraph buildGraph(Random rand, Map<String,InputOutput> inouts, Map<String,LayerWrapper> layers) {
    	Layer root = null;
    	
    	for (LayerWrapper lw : layers.values()) {
        	for (InputOutput out : lw.outputs.values()) {
        		inouts.get(out.name).outputOf = lw;
    		}
		}
    	for (LayerWrapper lw : layers.values()) {
    		List<Integer> shape = null;
    		InputOutput weights = null;
    		InputOutput bias = null;
        	for (InputOutput in : lw.inputs.values()) {
        		if(in.outputOf == null)
        		{
        			if(in.hasData()) {
        				if(weights == null)
        				{
        					weights = in;
        				}
        				else if(weights.getDataSize() < in.getDataSize())
        				{
        					bias = weights;
        					weights = in;
        				}
        				else if(bias == null) {
        					bias = in;
        				}
        			}
        			else
        			{
        				shape = in.shape;
        			}
        		}
    			if(!in.hasData()) {
    				shape = in.shape;
    			}
    		}
        	//lw.name = lw.name.split("model/")[1];
        	lw.layer = GenUtils.genLayer(rand,lw.name,lw.type,shape,lw.params,weights,bias);
		}
    	for (LayerWrapper lw : layers.values()) {
        	for (InputOutput in : lw.inputs.values()) {
        		if(in.outputOf != null)
        		{
        			in.outputOf.layer.connectParent(lw.layer);
        			in.outputOf.hasParent = true;
        		}
    		}
		}
    	for (LayerWrapper lw : layers.values()) {
        	if(!lw.hasParent)
        	{
        		root = lw.layer;
        		break;
        	}
		}
    	LayerGraph lg = new LayerGraph(root);
    	
//    	for (LayerWrapper lw : layers.values()) {
//    		String tmpname = lw.name.toLowerCase();
//    		//System.out.println("VALID: " + tmpname);
//    		boolean validL = false;
//        	for(String l : GenUtils.layers)
//        	{
//        		//System.out.println("check: " + l.toLowerCase());
//        		if(tmpname.endsWith(l.toLowerCase())) {
//        			validL = true;
//        			
//        			break;
//        		}
//        	}
//        	if(!validL) {
//        		lg.removeLayer(rand, lw.layer);
//        	}
////        	else {
////        		lw.name =lw.name.split("model/")[1];
////        		lw.layer.setUniqueName(uniqueName);
////        		
////        	}
//		}
    	
    	for (LayerWrapper lw : layers.values()) {
    		System.out.println(lw.name);
    		System.out.println(lw.params.size());
    		System.out.println(lw.layer.getInputShape().size());
    	}
    	
    	return lg;
    }
    
    
    class InputOutput{
    	public String name;
    	LayerWrapper outputOf = null;
    	List<Integer> shape = new ArrayList<>();
    	Object data = null;
    	public InputOutput(String name) {
    		this.name = name;
    	}
    	public boolean hasData() {return data!=null;}
    	
    	public int getDataSize() {
    		if (shape.isEmpty()) {
				return 0;
			}
    		int ret = 1;
    		for (Integer s : shape) {
				ret *= s;
			}
    		return ret;
    	}
    } 
    class LayerWrapper  {
    	boolean hasParent = false;
    	Map<String,InputOutput> inputs = new HashMap<>();
    	Map<String,InputOutput> outputs = new HashMap<>();
    	String name;
    	String type;
    	LinkedHashMap<String, Object> params = new LinkedHashMap<>();
    	Layer layer;
    	public LayerWrapper(String name) {
    		this.name = name;
    	}
    }
    
    private static int dataIndex = 0;
    private Object buildObjectArrayStructue(List<Integer> shape, TensorProto tp) {
		ArrayList<Object> list = new ArrayList<Object>();
		ArrayList<Integer> dimensions = new ArrayList<>(shape);
		if(dimensions.size() == 1){
			for(int i = 0; i < dimensions.get(0);i++) {
				int data_type = tp.data_type();
				if (data_type == TensorProto.FLOAT || data_type == TensorProto.FLOAT16) {
					list.add(tp.raw_data().getFloat(dataIndex++));
				} else if (data_type == TensorProto.DOUBLE) {
					list.add(tp.raw_data().getDouble(dataIndex++));
				} else if (data_type == TensorProto.INT32 || data_type == TensorProto.UINT32) {
					list.add(tp.raw_data().getInt(dataIndex++));
				} else if (data_type == TensorProto.INT16 || data_type == TensorProto.UINT16) {
					list.add(tp.raw_data().getShort(dataIndex++));
				} else if (data_type == TensorProto.INT8 || data_type == TensorProto.UINT8) {
					list.add(tp.raw_data().getShort(dataIndex++));
				} else if (data_type == TensorProto.INT64 || data_type == TensorProto.UINT64) {
					list.add(tp.raw_data().getLong(dataIndex++));
				} else if (data_type == TensorProto.BOOL) {
					list.add(tp.raw_data().getBool(dataIndex++));
				} else {
					list.add(tp.raw_data().getFloat(dataIndex++));
				}
			}
		}
		else {
			int d0 = dimensions.get(0);
			dimensions.remove(0);
			for(int i = 0; i < d0;i++) {
				list.add(buildObjectArrayStructue(dimensions,tp));
			}
		}
		return (Object)list.toArray();
    }
}


