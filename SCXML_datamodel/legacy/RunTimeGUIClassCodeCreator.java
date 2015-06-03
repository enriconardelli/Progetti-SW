package legacy;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.filter.ElementFilter;
import org.jdom.input.SAXBuilder;

public class RunTimeGUIClassCodeCreator {
	private RunTimeGUIClassCodeCreator() {
		// with a private constructor instances of this class cannot be created,
		// which is what we want
		// since the actual generation of code is made through a class method
	}

	public static void create(String pSCName) throws JDOMException, IOException {
		String SCXMLFileName = "data" + File.separator + pSCName + ".scxml";
		ArrayList<String[]> dataIdName = new ArrayList<String[]>(0);
		ArrayList<String> eventName = new ArrayList<String>(0);
		SAXBuilder builder = new SAXBuilder();
		Document myDocument = builder.build(SCXMLFileName);
		Element documentRoot = myDocument.getRootElement();
		ElementFilter dataFilter = new ElementFilter("data");
		Iterator<Element> itrD = (documentRoot.getDescendants(dataFilter));
		while (itrD.hasNext()) {
			Element aDataElement = (Element) itrD.next();
			String[] dataIdNameArgument = new String[2];
			dataIdNameArgument[0] = aDataElement.getAttributeValue("id");
			dataIdNameArgument[1] = aDataElement.getText();
			dataIdName.add(dataIdNameArgument);
		}
		ElementFilter transitionFilter = new ElementFilter("transition");
		Iterator<Element> itrT = (documentRoot.getDescendants(transitionFilter));
		while (itrT.hasNext()) {
			Element aTransitionElement = (Element) itrT.next();
			String eventValue = aTransitionElement.getAttributeValue("event");
			if (!eventName.contains(eventValue) && eventValue != null) {
				eventName.add(eventValue);
			}
		}
		BufferedWriter out = new BufferedWriter(new FileWriter("support" + File.separator + pSCName + "GUI.java"));
		// writing generated annotation and package declaration
		out.write("/*\n");
		out.write(" * @generated\n");
		out.write(" */\n");
		out.write("package core;\n\n");
		// writing imports
		out.write("import java.awt.Color;\n");
		out.write("import java.awt.FlowLayout;\n");
		out.write("import java.awt.event.ActionEvent;\n");
		out.write("import java.awt.event.ActionListener;\n");
		out.write("import javax.swing.BoxLayout;\n");
		out.write("import javax.swing.JButton;\n");
		out.write("import javax.swing.JFrame;\n");
		out.write("import javax.swing.JLabel;\n");
		out.write("import javax.swing.JPanel;\n");
		out.write("import javax.swing.JScrollPane;\n");
		out.write("import javax.swing.JTextField;\n");
		out.write("import javax.swing.ScrollPaneConstants;\n");
		out.write("import javax.swing.JTextArea;\n");
		out.write("import org.apache.commons.scxml.TriggerEvent;\n");
		out.write("import org.apache.commons.scxml.model.ModelException;\n\n");
		// writing class signature
		out.write("public class " + pSCName + "GUI extends StateChartGUI {\n\n");
		// writing private variables and their update methods for fields displaying datamodel elements
		for (int j = 0; j < dataIdName.size(); j++) {
			String stateName = dataIdName.get(j)[0];
			out.write("\tprivate JTextField " + stateName + "F;\n");
		}
		// writing display update method called by ASM
		out.write("\t@Override\n");
		out.write("\tpublic void variablesDisplayUpdate() {\n");
		for (int j = 0; j < dataIdName.size(); j++) {
			String stateName = dataIdName.get(j)[0];
			out.write("\t\t" + stateName + "F.setText(String.valueOf(myASM.get_value(\"" + stateName + "\")));\n");
		}
		out.write("\t}\n\n");
		// writing constructor
		out.write("\tpublic " + pSCName + "GUI(String pSCName) {\n\n");
		out.write("\t\tJFrame myFrame = new JFrame();\n");
		out.write("\t\tmyFrame.setTitle(pSCName);\n");
		out.write("\t\tmyFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);\n");
		out.write("\t\tmyFrame.setSize(500, 700);\n");
		out.write("\t\tmyFrame.setLayout(new FlowLayout());\n\n");
		// writing buttons launching events labeling transitions
		out.write("\t\tString[] eventList = { ");
		for (int j = 0; j < eventName.size(); j++) {
			out.write("\"" + eventName.get(j) + "\"");
			if (j != eventName.size() - 1)
				out.write(", ");
		}
		out.write(" };\n");
		out.write("\t\tfor (String event : eventList) {\n");
		out.write("\t\t\tJButton aButton = new JButton(\"LAUNCH \" + event);\n");
		out.write("\t\t\taButton.setActionCommand(event);\n");
		out.write("\t\t\taButton.addActionListener(this);\n");
		out.write("\t\t\tmyFrame.getContentPane().add(aButton);\n");
		out.write("\t\t}\n\n");
		// writing panels with labels and fields to display state values
		for (int j = 0; j < dataIdName.size(); j++) {
			String stateName = dataIdName.get(j)[0];
			out.write("\t\tJPanel " + stateName + "P = new JPanel();\n");
			out.write("\t\t" + stateName + "P.setBackground(Color.LIGHT_GRAY);\n");
			out.write("\t\t" + stateName + "P.setLayout(new BoxLayout(" + stateName + "P, BoxLayout.Y_AXIS));\n");
			out.write("\t\t" + stateName + "P.add(new JLabel(\"" + stateName + "\"));\n");
			out.write("\t\t" + stateName + "F = new JTextField(\"\", 5);\n");
			out.write("\t\t" + stateName + "P.add(" + stateName + "F);\n");
			out.write("\t\tmyFrame.getContentPane().add(" + stateName + "P);\n\n");
		}
		// writing TextArea
		out.write("\t\tstatechartTrace = new JTextArea(40,40);\n");
		out.write("\t\tstatechartTrace.setLineWrap(false);\n");
		out.write("\t\tJScrollPane aScroller = new JScrollPane(statechartTrace);\n");
		out.write("\t\taScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);\n");
		out.write("\t\taScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);\n");
		out.write("\t\tmyFrame.getContentPane().add(aScroller);\n\n");
		// writing GUI start
		out.write("\t\tmyFrame.setVisible(true);\n");
		// closing class definition
		out.write("\t}\n\n");
		out.write("\t}\n");
		out.close();
	}
}
