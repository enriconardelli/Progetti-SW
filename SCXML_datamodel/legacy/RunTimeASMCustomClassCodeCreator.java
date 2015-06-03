package legacy;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.filter.ElementFilter;
import org.jdom.filter.Filter;
import org.jdom.input.SAXBuilder;

public class RunTimeASMCustomClassCodeCreator {
	private RunTimeASMCustomClassCodeCreator() {/*never create instances of a helper class*/}

	public static void create(String pSCName) throws JDOMException, IOException {
		
		File file = new File("support" + File.separator + pSCName + "ASM.java");
		String classContent = "";
		if (file.exists()) {
			classContent = readFile("support" + File.separator + pSCName + "ASM.java");
		} else {
			classContent = writeImports();
			classContent += writeSignatureAndConstructor(pSCName);
			classContent += writeEndOfClass();
		}

		classContent = updateStateMethods(pSCName, classContent);
		
		BufferedWriter out = new BufferedWriter(new FileWriter("support" + File.separator + pSCName + "ASM.java"));
		out.write(classContent);
		out.close();
	}

	private static String readFile( String file ) throws IOException {
	    BufferedReader reader = new BufferedReader( new FileReader (file));
	    String line  = null;
	    StringBuilder stringBuilder = new StringBuilder();
	    String ls = System.getProperty("line.separator");
	    while( ( line = reader.readLine() ) != null ) {
	        stringBuilder.append( line );
	        stringBuilder.append( ls );
	    }
	    return stringBuilder.toString();
	 }

	private static String writeImports() throws IOException {
		String result = "";
		result += "/*\n";
		result += " * @generated\n";
		result += " */\n";
		result += "package core;\n\n";
		// writing imports
		result += "import java.io.File;\n";
		result += "import java.net.MalformedURLException;\n";
		result += "import java.net.URL;\n";
		result += "import java.util.List;\n";
		result += "import org.apache.commons.scxml.env.jsp.ELContext;\n";
		result += "import org.apache.commons.scxml.env.jsp.ELEvaluator;\n";
		result += "import org.apache.commons.scxml.model.Assign;\n";
		result += "import org.apache.commons.scxml.model.Transition;\n";
		result += "import org.apache.commons.scxml.model.TransitionTarget;\n";
		result += "import org.apache.commons.scxml.SCXMLListener;\n\n";
		return result;
	}
	
	private static String writeSignatureAndConstructor(String pSCName) throws IOException {
		String result = "";
		result += "public class " + pSCName + "ASM extends AbstractASM{\n\n";
		// writing a the initial private variable
		result += "\tstatic private boolean firstEnterInitialState = true;\n\n";
		// writing our constructor
		result += "\tpublic " + pSCName + "ASM(String aSCName) throws MalformedURLException {\n";
		result += "\t\tsuper(new URL(\"file:data\" + File.separator + aSCName + \".scxml\"));\n";
		result += "\t}\n\n";
		return result;
	}


	private static String writeEndOfClass() throws IOException {
		String result = "";
		result += "\t//supercalifragilistichespiralitoso\n";
		result += "}\n";
		return result;
	}

	private static String updateStateMethods(String pSCName, String classContent) throws IOException, JDOMException {
				
		String SCXMLFileName = "data" + File.separator + pSCName + ".scxml";
		SAXBuilder builder = new SAXBuilder();
		Document myDocument = builder.build(SCXMLFileName);
		Element documentRoot = myDocument.getRootElement();
		String initialState = documentRoot.getAttributeValue("initial");
		ElementFilter stateFilter = new ElementFilter("state");
		Filter stateOrFinalFilter = stateFilter.or(new ElementFilter("final"));
		ArrayList<String> stateNames = new ArrayList<String>();
		Iterator<Element> itrS = documentRoot.getDescendants(stateOrFinalFilter);
		while (itrS.hasNext())
			stateNames.add(itrS.next().getAttributeValue("id"));
		
		List<String> methodsAlreadyPresent = getMarkedMethods(classContent, "public void");
		stateNames.removeAll(methodsAlreadyPresent);
		
		// writing state methods
		for (int j = 0; j < stateNames.size(); j++) {
			String stateName = stateNames.get(j);
			classContent = appendMethod(stateName, initialState, classContent);
		}
		return classContent;
	}

	private static String appendMethod(String stateName, String initialState, String classContent) throws IOException {
		
		classContent = classContent.split("//supercalifragilistichespiralitoso")[0];
				
		classContent += "public void " + stateName + "() {\n";
		if (stateName.equals(initialState)) {
			classContent += "\t\tif (firstEnterInitialState) {\n";
			classContent += "\t\t\tfirstEnterInitialState = false;\n";
			classContent += "\t\t} else {\n";			classContent += "\t\t\tSystem.out.println(\" --> ENTER " + stateName + "\");\n";
			classContent += "\t\t\tmyGUI.statechartTraceAppend(\" --> ENTER " + stateName + "\");\n";
			classContent += "\t\t\tmyGUI.variablesDisplayUpdate();\n";
			classContent += "\t\t}\n";
			classContent += "\t}\n\n";
		} else {
			classContent += "\t\tSystem.out.println(\" --> ENTER " + stateName + "\");\n";
			classContent += "\t\tmyGUI.statechartTraceAppend(\" --> ENTER " + stateName + "\");\n";
			classContent += "\t\tmyGUI.variablesDisplayUpdate();\n";
			classContent += "\t}\n\n";
		}
		
		classContent += writeEndOfClass();
		return classContent;
	}

	private static List<String> getMarkedMethods(String classContent, String marker) {
		List<String> methods = new ArrayList<String>();
		int current = 0;
		while (current != -1) {
			current = classContent.indexOf(marker, current+1);
			if(current != -1) {
				String methodName = classContent.substring(current+marker.length(), classContent.indexOf("(", current) ).trim();
				methods.add(methodName);
			}
		}
		return methods;
	}

}
