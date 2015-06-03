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
import org.jdom.filter.Filter;
import org.jdom.input.SAXBuilder;

public class RunTimeASMClassCodeCreator {
	private RunTimeASMClassCodeCreator() {
		// with a private constructor instances of this class cannot be created,
		// which is what we want
		// since the actual generation of code is made through a class method
	}

	public static void create(String pSCName) throws JDOMException, IOException {
		String SCXMLFileName = "data" + File.separator + pSCName + ".scxml";
		ArrayList<String[]> dataIdName = new ArrayList<String[]>(0);
		SAXBuilder builder = new SAXBuilder();
		Document myDocument = builder.build(SCXMLFileName);
		Element documentRoot = myDocument.getRootElement();
		String initialState = documentRoot.getAttributeValue("initial");
		ElementFilter dataFilter = new ElementFilter("data");
		Iterator<Element> itrD = (documentRoot.getDescendants(dataFilter));
		while (itrD.hasNext()) {
			Element aDataElement = (Element) itrD.next();
			String[] dataIdNameArgument = new String[2];
			dataIdNameArgument[0] = aDataElement.getAttributeValue("id");
			dataIdNameArgument[1] = aDataElement.getAttributeValue("expr");
			dataIdName.add(dataIdNameArgument);
		}
		// adding an array for states, not only data 04/08/12 trycz
		ArrayList<String> stateNames = new ArrayList<String>();
		ElementFilter stateFilter = new ElementFilter("state");
		Filter stateOrFinalFilter = stateFilter.or(new ElementFilter("final"));
		Iterator<Element> itrS = documentRoot.getDescendants(stateOrFinalFilter);
		while (itrS.hasNext())
			stateNames.add(itrS.next().getAttributeValue("id"));
		// System.out.println("  finito parsing di " + SCXMLFileName);
		BufferedWriter out = new BufferedWriter(new FileWriter("support" + File.separator + pSCName + "ASM.java"));
		// writing generated annotation and package declaration
		out.write("/*\n");
		out.write(" * @generated\n");
		out.write(" */\n");
		out.write("package core;\n\n");
		// writing imports
		out.write("import java.io.File;\n");
		out.write("import java.net.MalformedURLException;\n");
		out.write("import java.net.URL;\n");
		out.write("import java.util.List;\n");
		out.write("import org.apache.commons.scxml.env.jsp.ELContext;\n");
		out.write("import org.apache.commons.scxml.env.jsp.ELEvaluator;\n");
		out.write("import org.apache.commons.scxml.model.Assign;\n");
		out.write("import org.apache.commons.scxml.model.Transition;\n");
		out.write("import org.apache.commons.scxml.model.TransitionTarget;\n");
		out.write("import org.apache.commons.scxml.SCXMLListener;\n\n");
		// writing class signature
		out.write("public class " + pSCName + "ASM extends AbstractASM{\n\n");
		// writing a the initial private variable
		out.write("\tstatic private boolean firstEnterInitialState = true;\n\n");
		// writing our constructor
		out.write("\tpublic " + pSCName + "ASM(String aSCName) throws MalformedURLException {\n");
		out.write("\t\tsuper(new URL(\"file:data\" + File.separator + aSCName + \".scxml\"));\n");
		out.write("\t}\n\n");
		// writing state methods
		for (int j = 0; j < stateNames.size(); j++) {
			String stateName = stateNames.get(j);
			out.write("\tpublic void " + stateName + "() {\n");
			if (stateName.equals(initialState)) {
				out.write("\t\tif (firstEnterInitialState) {\n");
				out.write("\t\t\tfirstEnterInitialState = false;\n");
				out.write("\t\t} else {\n");
				out.write("//\t\t\tSystem.out.println(\" --> ENTER " + stateName + "\");\n");
				out.write("\t\t\tmyGUI.statechartTraceAppend(\" --> ENTER " + stateName + "\");\n");
				out.write("\t\t\tmyGUI.variablesDisplayUpdate();\n");
				out.write("\t\t}\n");
				out.write("\t}\n\n");
			} else {
				out.write("//\t\tSystem.out.println(\" --> ENTER " + stateName + "\");\n");
				out.write("\t\tmyGUI.statechartTraceAppend(\" --> ENTER " + stateName + "\");\n");
				out.write("\t\tmyGUI.variablesDisplayUpdate();\n");
				out.write("\t}\n\n");
			}
		}
		out.write("}\n");
		out.close();
	}
}
