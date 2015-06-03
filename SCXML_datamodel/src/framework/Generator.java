package framework;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.filter.ElementFilter;
import org.jdom.filter.Filter;
import org.jdom.input.SAXBuilder;

public class Generator {
	// To pass arguments in Eclipse: "Run Configurations...", "Arguments", "Program Arguments"
	public static void main(String[] args) throws Exception {
		// checking input file name(s)
		if (args.length <= 0) {
			System.err.println("No args! Give the NAME(s) of the file(s) NAME.scxml containing the StateChart specification(s)");
			return;
		}
		for (String SCXMLModel : args) {
			File inputFile = new File(Conf.data_dir + Conf.filesep + SCXMLModel + Conf.scxml_extension);
//			System.out.println("inputFile absolutePath: " + inputFile.getAbsolutePath());
			if (!inputFile.exists()) {
				System.err.println("ERROR: the file " + inputFile.getAbsolutePath() + " for the model " + SCXMLModel + " does not exist.");
				System.err.println("The Generator is halted.");
				return;
			} else { // working on file
				System.out.println("Start generation of StateChart for model '" + SCXMLModel + "' specified in the file " + inputFile.getAbsolutePath());
				if (new File(Conf.source_dir + Conf.filesep + SCXMLModel).mkdir())
					System.out.println("First time for this StateChart, the package is created");
				else
					System.out.println("Modifying the existing package of the StateChart for model '" + SCXMLModel + "'");
//				Element documentRoot = getDocumentRoot(inputFile.getAbsolutePath());
				Element documentRoot = getDocumentRoot(inputFile);
				if (!(SCXMLDocumentSyntaxOK(documentRoot))){
					System.err.println("Syntax error(s) in file " + inputFile.getAbsolutePath());
					System.err.println("The creation of this StateChart is interrupted.\n");
				}
				else
					stateChartGeneration(SCXMLModel, documentRoot, inputFile);
			Thread.sleep(100); // to avoid mixing printouts
			}
		}
	}

	private static boolean SCXMLDocumentSyntaxOK(Element pDocumentRoot) {
		boolean checkOK = true;
		//checking initial state
		if (pDocumentRoot.getAttribute("initial")==null){
			System.err.println("ERROR: initial not found");
			checkOK = false;
		}
		// checking "data" node in the document
		Iterator<Element> anElement = pDocumentRoot.getDescendants(new ElementFilter("data"));
		while (anElement.hasNext()) {
			Element currentElement = anElement.next();
			if (currentElement.getAttribute("expr") == null) {
				System.err.println("ERROR: 'data' element '" + currentElement.getAttribute("id").getValue() + "' has no 'expr' attribute");
				checkOK = false;
			} else {
				if (currentElement.getAttribute("expr").getValue() == "") {
					System.err.println("ERROR: 'data' element '" + currentElement.getAttribute("id").getValue()
							+ "' has no value for the 'expr' attribute");
					checkOK = false;
				}
			}
		}
		return checkOK;
	}

	private static void stateChartGeneration(String pSCXMLModel, Element pDocumentRoot, File pInputFile) {
		try {
			String initialState = pDocumentRoot.getAttribute("initial").getValue();
			List<String> stateNames = getStateNames(pSCXMLModel, pDocumentRoot);
			List<String> variableNames = getVariableNames(pSCXMLModel, pDocumentRoot);
			List<String> eventNames = getEventNames(pSCXMLModel, pDocumentRoot);
			ASMCodeCreator.create(pSCXMLModel, stateNames, initialState);
			GUICodeCreator.create(pSCXMLModel, variableNames, eventNames);
			LauncherCodeCreator.create(pSCXMLModel);
			copyModelFile(pSCXMLModel, pInputFile);
			System.out.println("End generation for model '" + pSCXMLModel + "', run the Launcher in its package to execute the StateChart.\n");
		} catch (JDOMException a_JDOMException) {
			a_JDOMException.printStackTrace();
		} catch (IOException an_IOException) {
			an_IOException.printStackTrace();
		}
	}

	private static Element getDocumentRoot(File SCXMLFile) {
//		System.out.println("SAXBuilder parsing file " + SCXMLFile.getAbsolutePath() );
		Element returnElement = null;
		try {
			SAXBuilder aSAXBuilder = new SAXBuilder();
//			System.out.println("SAXBuilder istanziato ");
			Document doc = aSAXBuilder.build(SCXMLFile);
//			System.out.println("SAXBuilder costruito sul file ");
			returnElement = doc.getRootElement();
		} catch (JDOMException a_JDOMException) {
			a_JDOMException.printStackTrace();
		} catch (IOException an_IOException) {
			an_IOException.printStackTrace();
		}
		return returnElement;
	}

	private static List<String> getStateNames(String SCXMLName, Element documentRoot) throws JDOMException {
		ArrayList<String> stateNames = new ArrayList<String>();
		Iterator<Element> itrS = documentRoot.getDescendants(new ElementFilter("state").or(new ElementFilter("final")
				.or(new ElementFilter("parallel"))));
		while (itrS.hasNext())
			stateNames.add(itrS.next().getAttributeValue("id"));
		return stateNames;
	}

	private static List<String> getVariableNames(String SCXMLName, Element documentRoot) throws JDOMException {
		ArrayList<String> variableNames = new ArrayList<String>();
		Iterator<Element> itrD = documentRoot.getDescendants(new ElementFilter("data"));
		while (itrD.hasNext())
			variableNames.add(itrD.next().getAttributeValue("id"));
		return variableNames;
	}

	private static List<String> getEventNames(String SCXMLName, Element documentRoot) throws JDOMException {
		ArrayList<String> eventNames = new ArrayList<String>();
		Iterator<Element> itrT = documentRoot.getDescendants(new ElementFilter("transition"));
		while (itrT.hasNext()) {
			Element aTransitionElement = (Element) itrT.next();
			String eventValue = aTransitionElement.getAttributeValue("event");
			if (!eventNames.contains(eventValue) && eventValue != null) eventNames.add(eventValue);
		}
		return eventNames;
	}

	private static void copyModelFile(String pSCXMLModel, File pInputFile) {
		try {
			BufferedReader bufferedInput = new BufferedReader(new FileReader(pInputFile));
			BufferedWriter bufferedOutput = new BufferedWriter(new FileWriter(new File(Conf.source_dir + Conf.filesep + pSCXMLModel
					+ Conf.filesep + "model.scxml")));
			String inputLine = "";
			inputLine = bufferedInput.readLine();
			// copying the first line and writing the warning
			bufferedOutput.write(inputLine + Conf.linesep);
			bufferedOutput.write("<!--\n\t Never change this 'model' file!\n\t Modify the original one in Conf.data_dir.\n -->" + Conf.linesep);
			// copying the rest of the file
			inputLine = bufferedInput.readLine();
//			System.out.println("Letta linea " + inputLine);
			while (inputLine != null) {
//				System.out.println("Letta linea " + inputLine);
				bufferedOutput.write(inputLine + Conf.linesep);
				inputLine = bufferedInput.readLine();
			}
			bufferedInput.close();
			bufferedOutput.close();
		} catch (IOException an_IOException) {
			an_IOException.printStackTrace();
		}
	}

}