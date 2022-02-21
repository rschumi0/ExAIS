package util;
import Main.TestCaseGenerator;
import layer.Layer;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.filechooser.FileNameExtensionFilter;

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
	
	JList<String> testList;
	DefaultListModel<String> testlistModel = new DefaultListModel<>();
	JTextArea prologText;
	JTextArea tensorflowText;
	JTextArea resultText;
	JPanel centralPanel;
	JPanel plotPanel;
	JTabbedPane regularTabPane;
	JTabbedPane nondetTabPane;
	JTabbedPane validTabPane;
	JPanel updatedplotPanel;
	
	
	List<Layer> models = new ArrayList<Layer>(); 
	List<Object> inputs = new ArrayList<Object>();
	List<String> prologSrcs = new ArrayList<String>();
	List<String> tensorflowSrcs= new ArrayList<String>();
	List<String> results= new ArrayList<String>();
	List<Boolean> successes= new ArrayList<Boolean>();
	
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
      
        testList = new JList<>(testlistModel);
        testList.setCellRenderer(new DefaultListCellRenderer() {

            @Override
            public Component getListCellRendererComponent(JList list, Object value, int index,
                      boolean isSelected, boolean cellHasFocus) {
                 Component c = super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
                  if (successes.get(index)) {
                       setBackground(Color.GREEN);
                  } else {
                       setBackground(Color.RED);
                  }
                  if (isSelected) {
                       setBackground(getBackground().darker());
                  }
                 return c;
            }

       });
        testList.setSelectionMode(DefaultListSelectionModel.SINGLE_SELECTION);
        ListSelectionListener listSelectionListener = new ListSelectionListener() {
            public void valueChanged(ListSelectionEvent listSelectionEvent) {
//              System.out.println("First index: " + listSelectionEvent.getFirstIndex());
//              System.out.println(", Last index: " + listSelectionEvent.getLastIndex());
              //boolean adjust = listSelectionEvent.getValueIsAdjusting();
//              System.out.println(", Adjusting? " + adjust);
//              if (!adjust) {
            	
                JList list = (JList) listSelectionEvent.getSource();
                int selections[] = list.getSelectedIndices();
                if(selections.length == 0) {
                	return;
                }
                //Object selectionValues[] = list.getSelectedValues();
                if(new File(Config.plotPath+models.get(selections[0]).getUniqueName()+".png").exists()) {
	                BufferedImage image;
					try {
						plotPanel.removeAll();
						image = ImageIO.read(new File(Config.plotPath+models.get(selections[0]).getUniqueName()+".png"));
						JLabel label = new JLabel(new ImageIcon(image));
						
						plotPanel.add(label);
						plotPanel.doLayout();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
                }
                prologText.setText(prologSrcs.get(selections[0])+"\n");
                tensorflowText.setText(tensorflowSrcs.get(selections[0]));
                resultText.setText(results.get(selections[0]));
                
                if(new File(Config.plotPath+models.get(testList.getSelectedIndex()).getUniqueName()+"Changed.png").exists()) {
	                BufferedImage image1;
	        		try {
	        			updatedplotPanel.removeAll();
	        			image1 = ImageIO.read(new File(Config.plotPath+models.get(testList.getSelectedIndex()).getUniqueName()+"Changed.png"));
	        			JLabel label = new JLabel(new ImageIcon(image1));
	        			
	        			updatedplotPanel.add(label);
	        			updatedplotPanel.doLayout();
	        		} catch (IOException ex) {
	        			// TODO Auto-generated catch block
	        			ex.printStackTrace();
	        		}
                }
                
              }
//            }
          };
          testList.addListSelectionListener(listSelectionListener);
        
        
        JButton button2 = new JButton("Non-deterministic Tests");
        button2.setActionCommand("Non-deterministic Tests");
        button2.addActionListener(this);
        

        regularTabPane = new JTabbedPane();
    	nondetTabPane = new JTabbedPane();
    	validTabPane = new JTabbedPane();
         
        plotPanel = new JPanel();
        regularTabPane.addTab("Model Plot", new JScrollPane(plotPanel));
        prologText = new JTextArea();
        //prologText.setLineWrap(true);
        regularTabPane.addTab("Prolog Source", new JScrollPane(prologText));
        tensorflowText = new JTextArea();
        //tensorflowText.setLineWrap(true);
        regularTabPane.addTab("TensorFlow Source", new JScrollPane(tensorflowText));
        resultText = new JTextArea();
        regularTabPane.addTab("Test Result", new JScrollPane(resultText));
    	updatedplotPanel = new JPanel();
        regularTabPane.addTab("Model Validation Plot", new JScrollPane(updatedplotPanel));
        
//        nondetTabPane.addTab("Prolog Source", new JScrollPane(prologText));
//        nondetTabPane.addTab("TensorFlow Source", new JScrollPane(tensorflowText));
//        nondetTabPane.addTab("Test Result", new JScrollPane(resultText));
//        //nondetTabPane.setVisible(false);
//        
//        validTabPane.addTab("Model Plot", new JScrollPane(plotPanel));
//        validTabPane.addTab("Prolog Source", new JScrollPane(prologText));
//        validTabPane.addTab("TensorFlow Source", new JScrollPane(tensorflowText));
//        validTabPane.addTab("Test Result", new JScrollPane(resultText));
//        //validTabPane.setVisible(false);
        
        centralPanel.add(testList, java.awt.BorderLayout.LINE_START);
        centralPanel.add(regularTabPane, java.awt.BorderLayout.CENTER);
//        centralPanel.add(nondetTabPane, java.awt.BorderLayout.CENTER);
//        centralPanel.add(validTabPane, java.awt.BorderLayout.CENTER);
        
        JButton button3 = new JButton("Load Model");
        button3.setActionCommand("Load Model");
        button3.addActionListener(this);
        
//        JButton button4 = new JButton("Fix Model");
//        button4.setActionCommand("Fix Model");
//        button4.addActionListener(this);
        
        JPanel actionPanel = new JPanel();
        actionPanel.setLayout(new FlowLayout());  
        actionPanel.add(button1); 
        actionPanel.add(button2);
        actionPanel.add(button3);
        //actionPanel.add(button4);
        centralPanel.add(actionPanel, java.awt.BorderLayout.PAGE_END);
        
        
        centralPanel.add(buildConfigPanel(), java.awt.BorderLayout.PAGE_START);
        
        
        frame.getContentPane().add(centralPanel);
        

       frame.setVisible(true);
  }
    
  public JPanel buildConfigPanel() {
	  JPanel labelPanel = new JPanel(new GridLayout(7, 1));
	  JPanel fieldPanel = new JPanel(new GridLayout(7, 1));
	  
	  JPanel panel = new JPanel();
	  panel.setLayout( new BorderLayout() );
	  panel.add(labelPanel, BorderLayout.WEST);
	  panel.add(fieldPanel, BorderLayout.CENTER);
      
      JLabel l0 = new JLabel("pythonCommand: ", JLabel.RIGHT);
      config0 = new JTextField();
      config0.setText(ScriptPython.pythonCommand);
      l0.setLabelFor(config0);
      labelPanel.add(l0);
      fieldPanel.add(config0);
      
      JLabel l1 = new JLabel("tempPythonFilePath: ", JLabel.RIGHT);
      config1 = new JTextField();
      config1.setText(ScriptPython.tempPythonFilePath);
      l1.setLabelFor(config1);
      labelPanel.add(l1);
      fieldPanel.add(config1);
      
      JLabel l2 = new JLabel("prologCommand: ", JLabel.RIGHT);
      config2 = new JTextField();
      config2.setText(ScriptProlog.prologCommand);
      l2.setLabelFor(config2);
      labelPanel.add(l2);
      fieldPanel.add(config2);
      
      JLabel l3 = new JLabel("prologMainFile: ", JLabel.RIGHT);
      config3 = new JTextField();
      config3.setText(ScriptProlog.prologMainFile);
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
     
      return panel;
  }
  
public void updateConfig() {
	ScriptPython.pythonCommand = config0.getText();
	ScriptPython.tempPythonFilePath = config1.getText();
	ScriptProlog.prologCommand = config2.getText();
	ScriptProlog.prologMainFile = config3.getText();
	Config.testNumber = Integer.parseInt(config4.getText());
	Config.plotPath = config5.getText();
	Config.testCaseOutputPath = config6.getText();
}

@Override
public void actionPerformed(ActionEvent e) {
    String command = e.getActionCommand();
    updateConfig();
    if (command.equals("Test Case Generation")) {
//    	centralPanel.add(regularTabPane, java.awt.BorderLayout.CENTER);
//    	centralPanel.remove(nondetTabPane);
//    	centralPanel.remove(validTabPane);
    	if(regularTabPane.getTabCount() < 5)
    	{
	    	regularTabPane.insertTab("Model Plot", null, new JScrollPane(plotPanel), null, 0);
	    	regularTabPane.insertTab("Model Validation Plot", null, new JScrollPane(updatedplotPanel), null, 4);
    	}
    	
    	testList.clearSelection();
    	testlistModel.clear();
    	models = new ArrayList<Layer>();
    	inputs = new ArrayList<Object>();
    	prologSrcs = new ArrayList<String>();
    	tensorflowSrcs = new ArrayList<String>();
    	results = new ArrayList<String>();
    	successes = new ArrayList<Boolean>();
    	TestCaseGenerator.regularTests(models,inputs,prologSrcs,tensorflowSrcs,results,successes);
    	for(int i = 0; i < models.size();i++) {
    		testlistModel.addElement(models.get(i).getUniqueName());
    	}

    } else if(command.equals("Non-deterministic Tests")){
//    	centralPanel.add(nondetTabPane, java.awt.BorderLayout.CENTER);
//    	centralPanel.remove(validTabPane);
//    	centralPanel.remove(regularTabPane);
    	if(regularTabPane.getTabCount() > 3)
    	{
    		regularTabPane.removeTabAt(4);
    		regularTabPane.removeTabAt(0);
    	}
    		
    	
    	testList.clearSelection();
    	testlistModel.clear();

    	models = new ArrayList<Layer>();
    	inputs = new ArrayList<Object>();
    	prologSrcs = new ArrayList<String>();
    	tensorflowSrcs = new ArrayList<String>();
    	results = new ArrayList<String>();
    	successes = new ArrayList<Boolean>();
    	TestCaseGenerator.nondeterminicTests(models,inputs,prologSrcs,tensorflowSrcs,results,successes);
    	for(int i = 0; i < models.size();i++) {
    		testlistModel.addElement(models.get(i).getUniqueName());
    	}
    }
    else if(command.equals("Load Model")){
    	if(regularTabPane.getTabCount() < 5)
    	{
	    	regularTabPane.insertTab("Model Plot", null, new JScrollPane(plotPanel), null, 0);
	    	regularTabPane.insertTab("Model Validation Plot", null, new JScrollPane(updatedplotPanel), null, 4);
    	}
    	
    	testList.clearSelection();
    	testlistModel.clear();
    	JFileChooser fileChooser = new JFileChooser();
    	fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
    	fileChooser.setAcceptAllFileFilterUsed(false);
        FileNameExtensionFilter extFilter = new FileNameExtensionFilter("JSON file", "json");
        fileChooser.addChoosableFileFilter(extFilter);
        fileChooser.setMultiSelectionEnabled(true);
    	int result = fileChooser.showOpenDialog(regularTabPane);
    	if (result == JFileChooser.APPROVE_OPTION) {
        	models = new ArrayList<Layer>();
        	inputs = new ArrayList<Object>();
        	prologSrcs = new ArrayList<String>();
        	tensorflowSrcs = new ArrayList<String>();
        	results = new ArrayList<String>();
        	successes = new ArrayList<Boolean>();
    		File[] files = fileChooser.getSelectedFiles();
    		for (File file : files) {
    			System.out.println("Selected file: " + file.getAbsolutePath());
    			try {
					models.add(JsonModelParser.parseModel(rand, file.getAbsolutePath()));
				} catch (ParseException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
    		TestCaseGenerator.loadedModelTest(models, inputs, prologSrcs, tensorflowSrcs, results, successes,false,true);
        	for(int i = 0; i < models.size();i++) {
        		testlistModel.addElement(models.get(i).getUniqueName());
        	}
    	}
    }
    else if(command.equals("Fix Model")){
    	testList.clearSelection();
    	testlistModel.clear();
    	
    	JFileChooser fileChooser = new JFileChooser();
    	fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
    	fileChooser.setAcceptAllFileFilterUsed(false);
        FileNameExtensionFilter extFilter = new FileNameExtensionFilter("JSON file", "json");
        fileChooser.addChoosableFileFilter(extFilter);
        fileChooser.setMultiSelectionEnabled(true);
    	int result = fileChooser.showOpenDialog(regularTabPane);
    	if (result == JFileChooser.APPROVE_OPTION) {
        	models = new ArrayList<Layer>();
        	inputs = new ArrayList<Object>();
        	prologSrcs = new ArrayList<String>();
        	tensorflowSrcs = new ArrayList<String>();
        	results = new ArrayList<String>();
        	successes = new ArrayList<Boolean>();
    		File[] files = fileChooser.getSelectedFiles();
    		for (File file : files) {
    			System.out.println("Selected file: " + file.getAbsolutePath());
    			try {
					models.add(JsonModelParser.parseModel(rand, file.getAbsolutePath()));
				} catch (ParseException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
    		TestCaseGenerator.fixLoadedModel(models, inputs, prologSrcs, tensorflowSrcs, results, successes);
        	for(int i = 0; i < models.size();i++) {
        		testlistModel.addElement(models.get(i).getUniqueName());
        	}
    	}
    }
	
}

}
