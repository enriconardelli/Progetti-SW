package framework;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.jdom.JDOMException;

public class ASMCodeCreator {
	
	private ASMCodeCreator() {
		// with a private constructor instances of this class cannot be created,
		// which is what we want since the actual generation of code is made
		// through a class method
	}

	public static void create(String pSCName, List<String> allStateNames, String pInitialState) throws JDOMException, IOException {
		File file = new File(Conf.source_dir + Conf.filesep + pSCName + Conf.filesep + "ImplASM.java");
		String classContent = "";
		if (file.exists()) {
			classContent = readFile(Conf.source_dir + Conf.filesep + pSCName + Conf.filesep + "ImplASM.java");
		} else {
			classContent = writePreambleAndImports(pSCName);
			classContent += writeSignatureAndConstructor(pSCName);
			classContent += writeEndOfClass();
		}
		List<String> existingStateMethods  = getStateMethodsAlreadyPresent(classContent);
		List<String> stateMethodsToAdd = subtractStates(allStateNames, existingStateMethods);
		checkPossiblyDeletedStates(allStateNames, existingStateMethods);
		classContent = appendStateMethods(pSCName, classContent, stateMethodsToAdd, pInitialState);
		BufferedWriter out = new BufferedWriter(new FileWriter(Conf.source_dir + Conf.filesep + pSCName + Conf.filesep + "ImplASM.java"));
		out.write(classContent);
		out.close();
	}

	private static String readFile(String file) throws IOException {
		BufferedReader reader = new BufferedReader(new FileReader(file));
		String line = null;
		StringBuilder stringBuilder = new StringBuilder();
		while ((line = reader.readLine()) != null) {
			stringBuilder.append(line);
			stringBuilder.append(Conf.linesep);
		}
		return stringBuilder.toString();
	}

	private static String writePreambleAndImports(String pSCName) {
		String result = "";
		// writing generated annotation and package declaration
		result += "/*" + Conf.linesep;
		result += " * @generated" + Conf.linesep;
		result += " */" + Conf.linesep;
		result += "package " + pSCName + ";" + Conf.linesep + Conf.linesep;
		// writing imports
		result += "import java.net.MalformedURLException;" + Conf.linesep;
		result += "import java.net.URL;" + Conf.linesep;
		result += "import core.AbstractASM;" + Conf.linesep;
		result += "import framework.Conf;" + Conf.linesep;
		return result;
	}

	private static String writeSignatureAndConstructor(String pSCName) {
		String result = "";
		// writing class signature
		result += "public class ImplASM extends AbstractASM{" + Conf.linesep + Conf.linesep;
		// writing constructor
		result += "\tpublic ImplASM(String aSCName) throws MalformedURLException {" + Conf.linesep;
		result += "\t\tsuper(new URL(Conf.protocol + Conf.source_dir + Conf.filesep + aSCName + Conf.filesep + Conf.model_name + Conf.scxml_extension));" + Conf.linesep;
		result += "\t}" + Conf.linesep + Conf.linesep;
		return result;
	}
	

	private static String writeEndOfClass() {
		String result = "";
		result += Conf.endASMcurrentMethods + Conf.linesep;
		result += "}" + Conf.linesep;
		return result;
	}

	private static List<String> getStateMethodsAlreadyPresent(String classContent) {
		List<String> stateMethods = new ArrayList<String>();
		int currentPosition = 0;
		while (currentPosition != -1) {
			currentPosition = classContent.indexOf("public void", currentPosition + 1);
			// indexOf returns -1 when the searched string does not exist
			if (currentPosition != -1) {
				String stateMethodName = classContent.substring(currentPosition + "public void".length(), classContent.indexOf("(", currentPosition)).trim();
				stateMethods.add(stateMethodName);
			}
		}
		return stateMethods;
	}

	private static List<String> subtractStates(List<String> pAllStateNames, List<String> pExistingStateMethods){
		// removeAll method does not return a List and it is safer not to change allStateNames
		List<String> statesToAdd = new ArrayList<String>();
		statesToAdd.addAll(pAllStateNames);
		statesToAdd.removeAll(pExistingStateMethods);
		return statesToAdd;
	}

	private static void checkPossiblyDeletedStates(List<String>pAllStateNames, List<String> pExistingStateMethods) {
		List<String> possiblyDeletedStates = new ArrayList<String>();
		possiblyDeletedStates.addAll(pExistingStateMethods);
		possiblyDeletedStates.removeAll(pAllStateNames);
		if (possiblyDeletedStates.size()>0) {
			System.err.println("The following " + possiblyDeletedStates.size() + " method(s) may correspond to deleted states:");
			for (String stateName : possiblyDeletedStates)
				System.err.print(stateName + ", ");
			System.err.println();
		}
	}
	
	private static String appendStateMethods(String pSCName, String classContent, List<String> pstateNames, String pInitialState) {
		classContent = classContent.split(Conf.endASMcurrentMethods)[0];
		for (int j = 0; j < pstateNames.size(); j++)
			classContent = appendMethod(pstateNames.get(j), classContent, pInitialState);
		classContent += writeEndOfClass();
		return classContent;
	}

	private static String appendMethod(String pStateName, String classContent, String pInitialState) {
		classContent += "\tpublic void " + pStateName + "() {" + Conf.linesep;
		classContent += "\t" + Conf.placeholder_for_code + Conf.linesep;
		if (pStateName.equals(pInitialState))
			classContent += "\t" + Conf.warning_for_initial_state + Conf.linesep;
		classContent += "\t}" + Conf.linesep + Conf.linesep;
		return classContent;
	}

}
