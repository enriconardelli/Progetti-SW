package framework;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;




public class GUICodeCreator {

	
	private GUICodeCreator() {
		// with a private constructor instances of this class cannot be created,
		// which is what we want since the actual generation of code is made
		// through a class method
	}

	public static void create(String pSCName, List<String> variableNames, List<String> eventNames) throws IOException {
		//LEGGO I PARAMETRI
		ParamReader.Parameters=ParamReader.readConfFile(pSCName, eventNames, variableNames);
		
		
		//***************BOTTONI E FRAME************************
		//LEGGO IL DEFAULT
		String[] Def = ParamReader.getDefaultButton();
		//SALVO I NOMI
		ArrayList<String> buttonNames= ParamReader.getEventNames(ParamReader.Parameters);
		//PRENDO I COLORI
		ArrayList<String> colorsList= ParamReader.getcolors(Def[0]);
		//PRENDO I TOOLTIPS
		ArrayList<String> tooltipList=ParamReader.getTTList(Def[1]);
		//PARAMETRI DI FRAME
		String[] frameParam = new String[2];
		frameParam=ParamReader.getFrameParam();
		
		//*****************PANEL****************************
		
		//LEGGO IL DEFAULT
		String[] Defp = ParamReader.getDefaultPanel();
		//SALVO I NOMI
		ArrayList<String> panelNames= ParamReader.getPanelNames(ParamReader.Parameters);
		//PRENDO I COLORI
		ArrayList<String> colorsPList= ParamReader.getPanelColor(Defp[0]);
		//PRENDO I TOOLTIPS
		ArrayList<String> tooltipPList=ParamReader.getTTPList(Defp[1]);
		
		
		
 		BufferedWriter out = new BufferedWriter(new FileWriter(Conf.source_dir + Conf.filesep + pSCName + Conf.filesep + "ImplGUI.java"));
		String classContent = "";
		classContent = writePreambleAndImports(pSCName);
		classContent += Conf.linesep;
		classContent += writeSignature();
		classContent += writeBLists(buttonNames, colorsList, tooltipList);
		classContent += writePLists(panelNames, colorsPList, tooltipPList);
		classContent += writeConstructor(frameParam);
																 
		classContent += writeButtons(); //QUI POSSO TOGLIERE IL PARAMETRO
		classContent += writePanelsAndFields();//ANCHE QUI
		classContent += writeTextArea();
		classContent += writeGUIstartAndClassClosure();
		out.write(classContent);
		out.close();
	}

	private static String writePreambleAndImports(String pSCName) {
		// writing generated annotation and package declaration
		String result = "";
		result += "/*" + Conf.linesep;
		result += " * @generated" + Conf.linesep;
		result += " */" + Conf.linesep;
		result += "package " + pSCName + ";" + Conf.linesep + Conf.linesep;

		// writing imports
		result += "import java.util.HashMap;" + Conf.linesep; //MI SERVE QUESTO IMPORT PER LA HASH MAP
		result += "import java.awt.Color;" + Conf.linesep;
		result += "import java.awt.FlowLayout;" + Conf.linesep;
		result += "import javax.swing.BoxLayout;" + Conf.linesep;
		result += "import javax.swing.JButton;" + Conf.linesep;
		result += "import javax.swing.JFrame;" + Conf.linesep;
		result += "import javax.swing.JLabel;" + Conf.linesep;
		result += "import javax.swing.JPanel;" + Conf.linesep;
		result += "import javax.swing.JScrollPane;" + Conf.linesep;
		result += "import javax.swing.JTextField;" + Conf.linesep;
		result += "import javax.swing.ScrollPaneConstants;" + Conf.linesep;
		result += "import javax.swing.JTextArea;" + Conf.linesep;
		result += "import core.AbstractGUI;" + Conf.linesep;
		return result;
	}

		private static String writeSignature() {
		String result = "";
		// writing class signature
		result += "public class ImplGUI extends AbstractGUI {" + Conf.linesep + Conf.linesep;
		return result;
		}
		
		private static String writeConstructor(String[] frameParam){
			String result = "";
		
		// writing constructor
		result += "\tpublic ImplGUI(String pSCName) {" + Conf.linesep + Conf.linesep;

		//INSERISCO LA HASH MAP DEL JFRAME
		result += "\t\tHashMap<String,Integer> frameParameters = new HashMap<String,Integer>();" + Conf.linesep;
		result += "\t\tString[] paramList = {" + "\"width\"" + ", " + "\"height\"" + "};" + Conf.linesep;
		result += "\t\tInteger[] valueList = {" + frameParam[0] + ", " + frameParam[1] + "};" + Conf.linesep;
		result += "\t\tfor (int i=0; i<paramList.length; i++) {" + Conf.linesep;
		result += "\t\t\t frameParameters.put(paramList[i], valueList[i]);" + Conf.linesep;
		result += "\t\t}" + Conf.linesep + Conf.linesep;
		
		result += "\t\tJFrame myFrame = new JFrame();" + Conf.linesep;
		result += "\t\tmyFrame.setTitle(pSCName);" + Conf.linesep;
		result += "\t\tmyFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);" + Conf.linesep;
		result += "\t\tmyFrame.setSize(frameParameters.get(" + "\"width\"" + "), frameParameters.get(" + "\"height\"" + "));" + Conf.linesep;
		result += "\t\tmyFrame.setLayout(new FlowLayout());" + Conf.linesep + Conf.linesep;
		return result;
	}
		//AGGIUNTA DA ME, SCRIVE LE LISTE DEI PARAMETRI PER BOTTONI
		private static String writeBLists(ArrayList<String> buttonNames, ArrayList<String> colorsList, ArrayList<String> tooltipList){
			String result = "";
			result += ParamReader.writeButtonList(buttonNames);
			result += ParamReader.writeColorList(colorsList);
			result += ParamReader.writeTTList(tooltipList);
			return result;
		}
		
		//SCRIVE LE LISTE PARAM DEI PANEL
		private static String writePLists(ArrayList<String> panelNames, ArrayList<String> colorsPList, ArrayList<String> tooltipPList){
			String result = "";
			result += ParamReader.writePanelList(panelNames);
			result += ParamReader.writeColorPList(colorsPList);
			result += ParamReader.writeTTPList(tooltipPList);
			return result;
		}

		private static String writeButtons() {
		String result = "";
		result += "\t\tfor (int i=0 ; i<eventList.length ; i++) {" + Conf.linesep;
		result += "\t\t\tJButton aButton = new JButton(\"LAUNCH \" + eventList[i]);" + Conf.linesep;
		result += "\t\t\taButton.setActionCommand(eventList[i]);" + Conf.linesep;
		result += "\t\t\taButton.setBackground(eventColorValue[i]);" + Conf.linesep;
		result += "\t\t\t aButton.setToolTipText(eventTTValue[i]);" + Conf.linesep;
		result += "\t\t\taButton.addActionListener(this);" + Conf.linesep;
		result += "\t\t\tmyFrame.getContentPane().add(aButton);" + Conf.linesep;
		result += "\t\t\teventButtons.put(eventList[i], aButton);" + Conf.linesep;
		result += "\t\t}" + Conf.linesep + Conf.linesep;
		return result;
	}

		private static String writePanelsAndFields() {
		String result = "";
		// writing panels with labels and fields to display and change state values
		
		
//		result += "\t\tString[] variableList = { ";
//		for (int j = 0; j < variableNames.size(); j++) {
//			result += "\"" + variableNames.get(j) + "\"";
//			if (j != variableNames.size() - 1)
//				result += ", ";
//		}
		
//		result += " };" + Conf.linesep;
		result += "\t\tfor (int i=0 ; i<panelList.length ; i++) {" + Conf.linesep;
//		result += "\t\tfor (String variable : variableList) {" + Conf.linesep;
		result += "\t\t\tJPanel panel = new JPanel();" + Conf.linesep;
		result += "\t\t\tpanel.setBackground(panelColorValue[i]);" + Conf.linesep;
		result += "\t\t\tpanel.setToolTipText(panelTTValue[i]);" + Conf.linesep;
		result += "\t\t\tpanel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));" + Conf.linesep;
		result += "\t\t\tpanel.add(new JLabel(panelList[i]));" + Conf.linesep;
		result += "\t\t\tJTextField textField = new JTextField(\"\", 5);" + Conf.linesep;
		result += "\t\t\ttextField.setActionCommand(panelList[i]);" + Conf.linesep;
		result += "\t\t\ttextField.addActionListener(this);" + Conf.linesep;
		result += "\t\t\tpanel.add(textField);" + Conf.linesep;
		result += "\t\t\tmyFrame.getContentPane().add(panel);" + Conf.linesep;
		result += "\t\t\tvariableFields.put(panelList[i], textField);" + Conf.linesep;
		result += "\t\t}" + Conf.linesep;
		return result;
	}

		private static String writeTextArea() {
		String result = "";
		// writing TextArea
		result += "\t\tstatechartTrace = new JTextArea(40,40);" + Conf.linesep;
		result += "\t\tstatechartTrace.setLineWrap(false);" + Conf.linesep;
		result += "\t\tJScrollPane aScroller = new JScrollPane(statechartTrace);" + Conf.linesep;
		result += "\t\taScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);" + Conf.linesep;
		result += "\t\taScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);" + Conf.linesep;
		result += "\t\tmyFrame.getContentPane().add(aScroller);" + Conf.linesep + Conf.linesep;
		return result;
	}

		private static String writeGUIstartAndClassClosure() {
		String result = "";
		// writing GUI start
		result += "\t\tmyFrame.setVisible(true);" + Conf.linesep;

		// closing class definition
		result += "\t}" + Conf.linesep + Conf.linesep;
		result += "\t}" + Conf.linesep;
		return result;
	}
		
		
	
		
}
