package util;
import Main.TestCaseGenerator;
import layer.Layer;
import layer.LayerGraph;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.management.loading.MLet;
import javax.swing.*;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.DefaultTreeSelectionModel;
import javax.swing.tree.MutableTreeNode;
import javax.swing.tree.TreeNode;
import javax.swing.tree.TreePath;
import javax.swing.tree.TreeSelectionModel;

import org.json.simple.parser.ParseException;

public class Gui implements ActionListener {
	
	Random rand;
	JTextField config0;
	JTextField config1;
	JTextField config2;
	JTextField config3;
	JTextField config4;
	JTextField config5;
	JTextField config6;
	JTextField config7;
	
	//JList<String> testList;
	//DefaultListModel<String> testlistModel = new DefaultListModel<>();
	JTextArea prologText;
	JTextArea tensorflowText;
	JTextArea resultText;
	JPanel centralPanel;
	JPanel plotPanel;
	JTabbedPane regularTabPane;
	JPanel updatedplotPanel;
	boolean isResultTabVisible = false;
	boolean isValidationTabVisible = false;
	
	JMenuBar menuBar;
	JMenu menu;
	
	
//	List<Layer> models = new ArrayList<Layer>(); 
//	List<Object> inputs = new ArrayList<Object>();
//	List<String> prologSrcs = new ArrayList<String>();
//	List<String> tensorflowSrcs= new ArrayList<String>();
//	List<String> results= new ArrayList<String>();
//	List<Boolean> successes= new ArrayList<Boolean>();
	HashMap<String, Layer> models = new HashMap<String, Layer>(); 
	HashMap<String, Object> inputs = new HashMap<String, Object>();
	HashMap<String, String> prologSrcs = new HashMap<String, String>();
	HashMap<String, String> tensorflowSrcs = new HashMap<String, String>();
	HashMap<String, String> results = new HashMap<String, String>();
	HashMap<String, Boolean> successes = new HashMap<String, Boolean>();
	private JMenuItem open;
	private JMenuItem save;
	private JMenuItem saveAs;
	
	private JTree tree;
	DefaultMutableTreeNode root;
	JScrollPane treeJScrollPane;
	
    public void start(Random rand){
    	this.rand = rand;
        JFrame frame = new JFrame("ExAIS: Executable AI Semantics Tool");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(800,800);
        
        centralPanel = new JPanel();
        centralPanel.setLayout( new BorderLayout() );
 
        JButton button1 = new JButton("Test Case Generation");
        button1.setActionCommand("Test Case Generation");
        button1.addActionListener(this);
      
//        testList = new JList<>(testlistModel);
//        testList.setCellRenderer(new DefaultListCellRenderer() {
//			private static final long serialVersionUID = 1L;
//
//			@Override
//            public Component getListCellRendererComponent(JList list, Object value, int index,
//                      boolean isSelected, boolean cellHasFocus) {
//                 Component c = super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
//                  if (successes.get(index)) {
//                       setBackground(Color.GREEN);
//                  } else {
//                       setBackground(Color.RED);
//                  }
//                  if (isSelected) {
//                       setBackground(getBackground().darker());
//                  }
//                 return c;
//            }
//
//       });
//        testList.setSelectionMode(DefaultListSelectionModel.SINGLE_SELECTION);
//        ListSelectionListener listSelectionListener = new ListSelectionListener() {
//            public void valueChanged(ListSelectionEvent listSelectionEvent) {
////              System.out.println("First index: " + listSelectionEvent.getFirstIndex());
////              System.out.println(", Last index: " + listSelectionEvent.getLastIndex());
//              //boolean adjust = listSelectionEvent.getValueIsAdjusting();
////              System.out.println(", Adjusting? " + adjust);
////              if (!adjust) {
//            	
//                JList list = (JList) listSelectionEvent.getSource();
//                int selections[] = list.getSelectedIndices();
//                if(selections.length == 0) {
//                	return;
//                }
//                //Object selectionValues[] = list.getSelectedValues();
//                if(new File(Config.plotPath+models.get(selections[0]).getUniqueName()+".png").exists()) {
//	                BufferedImage image;
//					try {
//						plotPanel.removeAll();
//						image = ImageIO.read(new File(Config.plotPath+models.get(selections[0]).getUniqueName()+".png"));
//						JLabel label = new JLabel(new ImageIcon(image));
//						
//						plotPanel.add(label);
//						plotPanel.doLayout();
//					} catch (IOException e) {
//						// TODO Auto-generated catch block
//						e.printStackTrace();
//					}
//                }
//                prologText.setText(prologSrcs.get(selections[0])+"\n");
//                tensorflowText.setText(tensorflowSrcs.get(selections[0]));
//                resultText.setText(results.get(selections[0]));
//                
//                if(new File(Config.plotPath+models.get(testList.getSelectedIndex()).getUniqueName()+"Changed.png").exists()) {
//	                BufferedImage image1;
//	        		try {
//	        			updatedplotPanel.removeAll();
//	        			image1 = ImageIO.read(new File(Config.plotPath+models.get(testList.getSelectedIndex()).getUniqueName()+"Changed.png"));
//	        			JLabel label = new JLabel(new ImageIcon(image1));
//	        			
//	        			updatedplotPanel.add(label);
//	        			updatedplotPanel.doLayout();
//	        		} catch (IOException ex) {
//	        			// TODO Auto-generated catch block
//	        			ex.printStackTrace();
//	        		}
//                }
//                
//              }
////            }
//          };
//          testList.addListSelectionListener(listSelectionListener);
        
        
        JButton button2 = new JButton("Non-deterministic Tests");
        button2.setActionCommand("Non-deterministic Tests");
        button2.addActionListener(this);
        

        regularTabPane = new JTabbedPane();
      
        plotPanel = new JPanel();
        regularTabPane.addTab("Model Plot", new JScrollPane(plotPanel));
        prologText = new JTextArea();
        //prologText.setLineWrap(true);
        regularTabPane.addTab("Prolog Source", new JScrollPane(prologText));
        tensorflowText = new JTextArea();
        //tensorflowText.setLineWrap(true);
        regularTabPane.addTab("TensorFlow Source", new JScrollPane(tensorflowText));
        resultText = new JTextArea();
        //regularTabPane.addTab("Test Result", new JScrollPane(resultText));
    	updatedplotPanel = new JPanel();
        //regularTabPane.addTab("Model Validation Plot", new JScrollPane(updatedplotPanel));
        
        
        centralPanel.add(regularTabPane, java.awt.BorderLayout.CENTER);
        
        
        
//        JButton button3 = new JButton("Load Model");
//        button3.setActionCommand("open");
//        button3.addActionListener(this);
        
        JButton button4 = new JButton("Execute/Check Model");
        button4.setActionCommand("execute");
        button4.addActionListener(this);
        
        JButton button5 = new JButton("Fix Model");
        button5.setActionCommand("fix");
        button5.addActionListener(this);
        
        JPanel actionPanel = new JPanel();
        actionPanel.setLayout(new FlowLayout());  
        actionPanel.add(button1); 
        actionPanel.add(button2);
        //actionPanel.add(button3);
        actionPanel.add(button4);
        actionPanel.add(button5);
        
        centralPanel.add(actionPanel, java.awt.BorderLayout.PAGE_END);
        centralPanel.add(buildConfigPanel(), java.awt.BorderLayout.PAGE_START);
              
        root = new DefaultMutableTreeNode("Root");
        tree = new JTree(root);
        tree.setRootVisible(false);
        treeJScrollPane = new JScrollPane(tree);
        tree.getSelectionModel().setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION);
        tree.addTreeSelectionListener(new TreeSelectionListener() {
            public void valueChanged(TreeSelectionEvent e) {
                DefaultMutableTreeNode node = (DefaultMutableTreeNode)tree.getLastSelectedPathComponent();
                if (node == null) return;
                refreshTabDisplay();
            }
        });
        
       centralPanel.add(treeJScrollPane, java.awt.BorderLayout.LINE_START);
        
       frame.getContentPane().add(centralPanel);
       
       
       menuBar = new JMenuBar();
       menu = new JMenu("File");
       menu.setMnemonic(KeyEvent.VK_A);
      
       open = new JMenuItem( "Open") ;
       open.setActionCommand("open");
       open.addActionListener( this ) ;
       save = new JMenuItem( "Save") ;
       save.setActionCommand("save");
       save.addActionListener( this ) ;
       saveAs = new JMenuItem( "Save As") ;
       saveAs.setActionCommand("saveAs");
       saveAs.addActionListener( this ) ;
       
       menu.add( open ) ;
       menu.add( save ) ;     
       menu.add( saveAs ) ;  
       menuBar.add(menu);
       
       menu = new JMenu("Action");
       menu.setMnemonic(KeyEvent.VK_N);
       
       JMenuItem tcg = new JMenuItem( "Test Case Generation") ;
       tcg.setActionCommand("Test Case Generation");
       tcg.addActionListener( this ) ;
       
       JMenuItem ndt = new JMenuItem( "Non-deterministic Tests") ;
       ndt.setActionCommand("Non-deterministic Tests");
       ndt.addActionListener( this ) ;
       
       JMenuItem exec = new JMenuItem( "Execute/Check Model") ;
       exec.setActionCommand("execute");
       exec.addActionListener( this ) ;
       
       JMenuItem fix = new JMenuItem( "Fix Model") ;
       fix.setActionCommand("fix");
       fix.addActionListener( this ) ;
       
       menu.add( tcg ) ;
       menu.add( ndt ) ;     
       menu.add( exec ) ;
       menu.add( fix ) ;
       menuBar.add(menu);
       
       frame.setJMenuBar(menuBar);
        
       frame.setVisible(true);
  }
    
  public JPanel buildConfigPanel() {
	  JPanel labelPanel = new JPanel(new GridLayout(8, 1));
	  JPanel fieldPanel = new JPanel(new GridLayout(8, 1));
	  
	  JPanel panel = new JPanel();
	  panel.setLayout( new BorderLayout() );
	  panel.add(labelPanel, BorderLayout.WEST);
	  panel.add(fieldPanel, BorderLayout.CENTER);
      
      JLabel l0 = new JLabel("pythonCommand: ", JLabel.RIGHT);
      config0 = new JTextField();
      config0.setText(Config.pythonCommand);
      l0.setLabelFor(config0);
      labelPanel.add(l0);
      fieldPanel.add(config0);
      
      JLabel l1 = new JLabel("tempPythonFilePath: ", JLabel.RIGHT);
      config1 = new JTextField();
      config1.setText(Config.tempPythonFilePath);
      l1.setLabelFor(config1);
      labelPanel.add(l1);
      fieldPanel.add(config1);
      
      JLabel l2 = new JLabel("prologCommand: ", JLabel.RIGHT);
      config2 = new JTextField();
      config2.setText(Config.prologCommand);
      l2.setLabelFor(config2);
      labelPanel.add(l2);
      fieldPanel.add(config2);
      
      JLabel l3 = new JLabel("prologMainFile: ", JLabel.RIGHT);
      config3 = new JTextField();
      config3.setText(Config.prologMainFile);
      l3.setLabelFor(config3);
      labelPanel.add(l3);
      fieldPanel.add(config3);
      
      JLabel l4 = new JLabel("testNumber: ", JLabel.RIGHT);
      config4 = new JTextField();
      config4.setText(""+Config.testNumber);
      l4.setLabelFor(config4);
      labelPanel.add(l4);
      fieldPanel.add(config4);
      
      JLabel l5 = new JLabel("plotPath: ", JLabel.RIGHT);
      config5 = new JTextField();
      config5.setText(""+Config.plotPath);
      l5.setLabelFor(config5);
      labelPanel.add(l5);
      fieldPanel.add(config5);
      
      JLabel l6 = new JLabel("testCaseOutputPath: ", JLabel.RIGHT);
      config6 = new JTextField();
      config6.setText(""+Config.testCaseOutputPath);
      l6.setLabelFor(config6);
      labelPanel.add(l6);
      fieldPanel.add(config6);
      
      JLabel l7 = new JLabel("dotCommand: ", JLabel.RIGHT);
      config7 = new JTextField();
      config7.setText(""+Config.dotCommand);
      l7.setLabelFor(config7);
      labelPanel.add(l7);
      fieldPanel.add(config7);
     
      return panel;
  }
  
public void updateConfig() {
	Config.pythonCommand = config0.getText();
	Config.tempPythonFilePath = config1.getText();
	Config.prologCommand = config2.getText();
	Config.prologMainFile = config3.getText();
	Config.testNumber = Integer.parseInt(config4.getText());
	Config.plotPath = config5.getText();
	Config.testCaseOutputPath = config6.getText();
	Config.dotCommand = config7.getText();
}

private void clearTree() {
	tree.clearSelection();
    DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
    DefaultMutableTreeNode root = (DefaultMutableTreeNode) model.getRoot();
    root.removeAllChildren();
    model.reload();
}

@Override
public void actionPerformed(ActionEvent e) {
    String command = e.getActionCommand();
    updateConfig();
    if (command.equals("Test Case Generation")) {
//    	if(regularTabPane.getTabCount() < 5)
//    	{
//	    	regularTabPane.insertTab("Model Plot", null, new JScrollPane(plotPanel), null, 0);
//	    	regularTabPane.insertTab("Model Validation Plot", null, new JScrollPane(updatedplotPanel), null, 4);
//    	}
    	
    	clearTree();
//    	testList.clearSelection();
//    	testlistModel.clear();
    	
    	models = new HashMap<String,Layer>();
    	inputs = new HashMap<String,Object>();
    	prologSrcs = new HashMap<String,String>();
    	tensorflowSrcs = new HashMap<String,String>();
    	results = new HashMap<String,String>();
    	successes = new HashMap<String,Boolean>();
    	
    	ArrayList<Layer> modelsL = new ArrayList<Layer>();
    	ArrayList<Object> inputsL = new ArrayList<Object>();
    	ArrayList<String> prologSrcsL = new ArrayList<String>();
    	ArrayList<String> tensorflowSrcsL = new ArrayList<String>();
    	ArrayList<String>resultsL = new ArrayList<String>();
    	ArrayList<Boolean> successesL = new ArrayList<Boolean>();
    	TestCaseGenerator.regularTests(modelsL,inputsL,prologSrcsL,tensorflowSrcsL,resultsL,successesL);
    	for(int i = 0; i < modelsL.size();i++) {
    		models.put(modelsL.get(i).getUniqueName(), modelsL.get(i));
    		inputs.put(modelsL.get(i).getUniqueName(), inputsL.get(i));
    		prologSrcs.put(modelsL.get(i).getUniqueName(), prologSrcsL.get(i));
    		tensorflowSrcs.put(modelsL.get(i).getUniqueName(), tensorflowSrcsL.get(i));
    		results.put(modelsL.get(i).getUniqueName(), resultsL.get(i));
    		successes.put(modelsL.get(i).getUniqueName(), successesL.get(i));
    		
    		//testlistModel.addElement(models.get(i).getUniqueName());
    		DefaultMutableTreeNode node = new DefaultMutableTreeNode(modelsL.get(i).getUniqueName());
    		root.add(node);
    		refreshTree();
    	}
    	//testList.setSelectedIndex(0);

    } else if(command.equals("Non-deterministic Tests")){
//    	if(regularTabPane.getTabCount() > 3)
//    	{
//    		regularTabPane.removeTabAt(4);
//    		regularTabPane.removeTabAt(0);
//    	}
    		
    	clearTree();
//    	testList.clearSelection();
//    	testlistModel.clear();

    	models = new HashMap<String,Layer>();
    	inputs = new HashMap<String,Object>();
    	prologSrcs = new HashMap<String,String>();
    	tensorflowSrcs = new HashMap<String,String>();
    	results = new HashMap<String,String>();
    	successes = new HashMap<String,Boolean>();
    	
    	ArrayList<Layer> modelsL = new ArrayList<Layer>();
    	ArrayList<Object> inputsL = new ArrayList<Object>();
    	ArrayList<String> prologSrcsL = new ArrayList<String>();
    	ArrayList<String> tensorflowSrcsL = new ArrayList<String>();
    	ArrayList<String>resultsL = new ArrayList<String>();
    	ArrayList<Boolean> successesL = new ArrayList<Boolean>();
    	TestCaseGenerator.nondeterminicTests(modelsL,inputsL,prologSrcsL,tensorflowSrcsL,resultsL,successesL);
    	for(int i = 0; i < modelsL.size();i++) {
    		models.put(modelsL.get(i).getUniqueName(), modelsL.get(i));
    		inputs.put(modelsL.get(i).getUniqueName(), inputsL.get(i));
    		prologSrcs.put(modelsL.get(i).getUniqueName(), prologSrcsL.get(i));
    		tensorflowSrcs.put(modelsL.get(i).getUniqueName(), tensorflowSrcsL.get(i));
    		results.put(modelsL.get(i).getUniqueName(), resultsL.get(i));
    		successes.put(modelsL.get(i).getUniqueName(), successesL.get(i));
//    	TestCaseGenerator.nondeterminicTests(models,inputs,prologSrcs,tensorflowSrcs,results,successes);
//    	for(int i = 0; i < models.size();i++) {
    		//testlistModel.addElement(models.get(i).getUniqueName());
    		root.add(new DefaultMutableTreeNode(modelsL.get(i).getUniqueName()));
    		System.out.println("Node Added!!!!!!!!!!!!!!!!!!!!!!!!!!! " + modelsL.get(i).getUniqueName());
    		refreshTree();
    	}
    	//testList.setSelectedIndex(0);
    	
    }
    else if(command.equals("open")){
    	openModel();
    }
    else if(command.equals("fix")){
    	fixModel();
    }
    else if(command.equals("execute")) {
    	executeModel();
    }
    else if(command.equals("save")) {
    	saveModel();
    }
    else if(command.equals("saveAs")) {
    	saveModelAs();
    }
	
}

public void openModel() {
//	if(regularTabPane.getTabCount() < 5)
//	{
//    	regularTabPane.insertTab("Model Plot", null, new JScrollPane(plotPanel), null, 0);
//    	regularTabPane.insertTab("Model Validation Plot", null, new JScrollPane(updatedplotPanel), null, 4);
//	}
	
	clearTree();
//	testList.clearSelection();
//	testlistModel.clear();
	JFileChooser fileChooser = new JFileChooser();
	fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
	fileChooser.setAcceptAllFileFilterUsed(false);
    FileNameExtensionFilter extFilter = new FileNameExtensionFilter("JSON file", "json");
    fileChooser.addChoosableFileFilter(extFilter);
    fileChooser.setMultiSelectionEnabled(true);
	int result = fileChooser.showOpenDialog(regularTabPane);
	if (result == JFileChooser.APPROVE_OPTION) {
//    	models = new ArrayList<Layer>();
//    	inputs = new ArrayList<Object>();
//    	prologSrcs = new ArrayList<String>();
//    	tensorflowSrcs = new ArrayList<String>();
//    	results = new ArrayList<String>();
//    	successes = new ArrayList<Boolean>();
		
    	models = new HashMap<String,Layer>();
    	inputs = new HashMap<String,Object>();
    	prologSrcs = new HashMap<String,String>();
    	tensorflowSrcs = new HashMap<String,String>();
    	results = new HashMap<String,String>();
    	successes = new HashMap<String,Boolean>();
    	
    	ArrayList<Layer> modelsL = new ArrayList<Layer>();
    	ArrayList<Object> inputsL = new ArrayList<Object>();
    	ArrayList<String> prologSrcsL = new ArrayList<String>();
    	ArrayList<String> tensorflowSrcsL = new ArrayList<String>();
    	ArrayList<String>resultsL = new ArrayList<String>();
    	ArrayList<Boolean> successesL = new ArrayList<Boolean>();
		File[] files = fileChooser.getSelectedFiles();
		for (File file : files) {
			System.out.println("Selected file: " + file.getAbsolutePath());
			try {
				Layer l = JsonModelParser.parseModelFromPathGraph(rand, file.getAbsolutePath());
				modelsL.add(l);
				root.add(new DefaultMutableTreeNode(l.getUniqueName()));
				
				models.put(l.getUniqueName(), l);
				Object in = l.generateInput(rand);
				inputs.put(l.getUniqueName(), in);
				prologSrcs.put(l.getUniqueName(), l.toPrologString(in));
				tensorflowSrcs.put(l.getUniqueName(), l.toTensorflowString(in));
				results.put(l.getUniqueName(), "");
				successes.put(l.getUniqueName(), true);
				refreshTree();
				
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}
}

private void saveModelAs() {
    DefaultMutableTreeNode node = (DefaultMutableTreeNode)tree.getLastSelectedPathComponent();
    if (node == null) return;
    Object nodeInfo = node.getUserObject();          
    String selectedModel = nodeInfo.toString();
    Layer model = models.get(selectedModel);
	
	JFileChooser fileChooser = new JFileChooser();
	fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
	fileChooser.setAcceptAllFileFilterUsed(false);
    FileNameExtensionFilter extFilter = new FileNameExtensionFilter("JSON file", "json");
    fileChooser.addChoosableFileFilter(extFilter);
    fileChooser.setMultiSelectionEnabled(false);
	fileChooser.setDialogTitle("Specify a file to save");   
	 
	int userSelection = fileChooser.showSaveDialog(regularTabPane);
	 
	if (userSelection == JFileChooser.APPROVE_OPTION) {
	    File fileToSave = fileChooser.getSelectedFile();
	    
	    String path = fileToSave.getAbsolutePath();
	    if(!path.toLowerCase().endsWith(".json")) {
	    	path = path + ".json";
	    }
	    System.out.println("Save as file: " + path);
	    Util.writeFile(path, ((LayerGraph)model).toJsonString());
	}
}

private void saveModel() {
    DefaultMutableTreeNode node = (DefaultMutableTreeNode)tree.getLastSelectedPathComponent();
    if (node == null) return;
    Object nodeInfo = node.getUserObject();          
    String selectedModel = nodeInfo.toString();
    Layer model = models.get(selectedModel);
    
    String path = Config.plotPath+model.getUniqueName()+".json";
    System.out.println("Save as file: " + path);
    Util.writeFile(path, ((LayerGraph)model).toJsonString());
}

private void executeModel() {
    DefaultMutableTreeNode node = (DefaultMutableTreeNode)tree.getLastSelectedPathComponent();
    if (node == null) return;
    Object nodeInfo = node.getUserObject();          
    String selectedModel = nodeInfo.toString();
    Layer model = models.get(selectedModel);
	
	ArrayList<Layer> modelsL = new ArrayList<Layer>();
	ArrayList<Object> inputsL = new ArrayList<Object>();
	
	modelsL.add(model);
	inputsL.add(inputs.get(model.getUniqueName()));
	
	ArrayList<String> prologSrcsL = new ArrayList<String>();
	ArrayList<String> tensorflowSrcsL = new ArrayList<String>();
	ArrayList<String>resultsL = new ArrayList<String>();
	ArrayList<Boolean> successesL = new ArrayList<Boolean>();
	TestCaseGenerator.loadedModelTest(modelsL, inputsL, prologSrcsL, tensorflowSrcsL, resultsL, successesL,false,true);
	for(int i = 0; i < modelsL.size();i++) {
		//testlistModel.addElement(`	models.get(i).getUniqueName());
		//root.add(new DefaultMutableTreeNode(modelsL.get(i).getUniqueName()));
		models.put(modelsL.get(i).getUniqueName(), modelsL.get(i));
		inputs.put(modelsL.get(i).getUniqueName(), inputsL.get(i));
		prologSrcs.put(modelsL.get(i).getUniqueName(), prologSrcsL.get(i));
		tensorflowSrcs.put(modelsL.get(i).getUniqueName(), tensorflowSrcsL.get(i));
		results.put(modelsL.get(i).getUniqueName(), resultsL.get(i));
		successes.put(modelsL.get(i).getUniqueName(), successesL.get(i));
	}
	refreshTabDisplay();
}

private void fixModel() {
    DefaultMutableTreeNode node = (DefaultMutableTreeNode)tree.getLastSelectedPathComponent();
    if (node == null) return;
    Object nodeInfo = node.getUserObject();          
    String selectedModel = nodeInfo.toString();
    Layer fixModel = models.get(selectedModel);
//    	models = new HashMap<String,Layer>();
//    	inputs = new HashMap<String,Object>();
//    	prologSrcs = new HashMap<String,String>();
//    	tensorflowSrcs = new HashMap<String,String>();
//    	results = new HashMap<String,String>();
//    	successes = new HashMap<String,Boolean>();
		
	ArrayList<Layer> modelsL = new ArrayList<Layer>();
	ArrayList<Object> inputsL = new ArrayList<Object>();
	ArrayList<String> prologSrcsL = new ArrayList<String>();
	ArrayList<String> tensorflowSrcsL = new ArrayList<String>();
	ArrayList<String>resultsL = new ArrayList<String>();
	ArrayList<Boolean> successesL = new ArrayList<Boolean>();

	if(fixModel != null) {
		System.out.println("try to fix loaded model");
		TestCaseGenerator.fixLoadedModel(fixModel,modelsL, prologSrcsL, inputsL);
    	for(int i = 0; i < modelsL.size();i++) {
    		modelsL.get(i).setUniqueName(modelsL.get(i).getUniqueName()+"F"+i);
    		
    		node.add(new DefaultMutableTreeNode(modelsL.get(i).getUniqueName()));
    		//testlistModel.addElement(models.get(i).getUniqueName());
    		
    		models.put(modelsL.get(i).getUniqueName(), modelsL.get(i));
    		inputs.put(modelsL.get(i).getUniqueName(), inputsL.get(i));
    		prologSrcs.put(modelsL.get(i).getUniqueName(), prologSrcsL.get(i));
    		tensorflowSrcs.put(modelsL.get(i).getUniqueName(),modelsL.get(i).toTensorflowString(inputsL.get(i)));
    		results.put(modelsL.get(i).getUniqueName(),"");
    		successes.put(modelsL.get(i).getUniqueName(),true);
    	}
	}
	tree.expandPath(new TreePath(node.getPath()));
	//refreshTree();
	centralPanel.doLayout();
}


public void refreshTabDisplay() {
    DefaultMutableTreeNode node = (DefaultMutableTreeNode)tree.getLastSelectedPathComponent();
    if (node == null) return;
    Object nodeInfo = node.getUserObject();          
    String selectedModel = nodeInfo.toString();
    Layer model = models.get(selectedModel);
    
    
    if(!new File(Config.plotPath+model.getUniqueName()+".png").exists()) {
    	if(node.getParent().equals(root)) {
    		new GraphViz().simpleGraphCreation(model.toDotString(), Config.plotPath+model.getUniqueName());
    	}
    	else {
    		new GraphViz().simpleGraphCreation(model.toDotValidationString(), Config.plotPath+model.getUniqueName());
    	}
    }
    if(new File(Config.plotPath+model.getUniqueName()+".png").exists()) {
        BufferedImage image;
		try {
			plotPanel.removeAll();
			image = ImageIO.read(new File(Config.plotPath+model.getUniqueName()+".png"));
			JLabel label = new JLabel(new ImageIcon(image));
			
			plotPanel.add(label);
			plotPanel.doLayout();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
    }
	prologText.setText(prologSrcs.get(selectedModel)+"\n");
	tensorflowText.setText(tensorflowSrcs.get(selectedModel));
	
	if(results.get(selectedModel).isEmpty()) {
		if(isResultTabVisible) {
			regularTabPane.removeTabAt(3);
			isResultTabVisible = false;
		}
	}
	else {
		if(!isResultTabVisible) {
			regularTabPane.addTab("Test Result", new JScrollPane(resultText));
			isResultTabVisible = true;
		}
		resultText.setText(results.get(selectedModel));
	}
		
	if(!new File(Config.plotPath+models.get(selectedModel).getUniqueName()+"Changed.png").exists()) {
		if(!results.get(selectedModel).isEmpty()) {
			new GraphViz().simpleGraphCreation(model.toDotValidationString(), Config.plotPath+model.getUniqueName()+"Changed");
		}
	}
  
	if(new File(Config.plotPath+models.get(selectedModel).getUniqueName()+"Changed.png").exists()) {
		if(!isValidationTabVisible){
			regularTabPane.addTab("Model Validation Plot", new JScrollPane(updatedplotPanel));
			isValidationTabVisible = true;
		}
		BufferedImage image1;
		try {
			updatedplotPanel.removeAll();
			image1 = ImageIO.read(new File(Config.plotPath+model.getUniqueName()+"Changed.png"));
			JLabel label = new JLabel(new ImageIcon(image1));
			
			updatedplotPanel.add(label);
			updatedplotPanel.doLayout();
			//regularTabPane.insertTab("Model Validation Plot", null, new JScrollPane(updatedplotPanel), null, 4);
		} catch (IOException ex) {
			// TODO Auto-generated catch block
				ex.printStackTrace();
		}
	}
	else if(isValidationTabVisible) {
		if(isResultTabVisible) {
			regularTabPane.removeTabAt(4);
		}
		else {
			regularTabPane.removeTabAt(3);
		}
		isValidationTabVisible = false;
	}
	regularTabPane.doLayout();
}

private void refreshTree(){
	((DefaultTreeModel)tree.getModel()).reload();
	tree.doLayout();
	treeJScrollPane.doLayout();
	centralPanel.doLayout();
}
}
