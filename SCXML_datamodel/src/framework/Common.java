package framework;
/*
 * file per contenere funzioni comuni a più classi
 */

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.filter.ElementFilter;
import org.jdom.input.SAXBuilder;

public class Common {
	
    /**
	 * Return the root of the XML file
	 *
	 * @param aXMLFile The SCXML file containing the StateChart
	 */
	public static Element getDocumentRoot(File aXMLFile) {
//		System.out.println("SAXBuilder parsing file " + aXMLFile.getAbsolutePath() );
		Element returnElement = null;
		try {
			SAXBuilder aSAXBuilder = new SAXBuilder();
//			System.out.println("SAXBuilder istanziato ");
			Document doc = aSAXBuilder.build(aXMLFile);
//			System.out.println("SAXBuilder costruito sul file ");
			returnElement = doc.getRootElement();
		} catch (JDOMException a_JDOMException) {
			a_JDOMException.printStackTrace();
		} catch (IOException an_IOException) {
			an_IOException.printStackTrace();
		}
		return returnElement;
	}

    /**
	 * Return the list of names of Statechart's states
	 *
	 * @param documentRoot The root element of the StateChart
	 */
	public static List<String> getStateNames(Element documentRoot) throws JDOMException {
		ArrayList<String> stateNames = new ArrayList<String>();
		Iterator<Element> itrS = documentRoot.getDescendants(new ElementFilter("state").or(new ElementFilter("final")
				.or(new ElementFilter("parallel"))));
		while (itrS.hasNext())
			stateNames.add(itrS.next().getAttributeValue("id"));
		return stateNames;
	}

    /**
	 * Return the list of names of Statechart's variables
	 *
	 * @param documentRoot The root element of the StateChart
	 */
	public static List<String> getVariableNames(Element documentRoot) throws JDOMException {
		ArrayList<String> variableNames = new ArrayList<String>();
		Iterator<Element> itrD = documentRoot.getDescendants(new ElementFilter("data"));
		while (itrD.hasNext())
			variableNames.add(itrD.next().getAttributeValue("id"));
		return variableNames;
	}

    /**
	 * Return the list of names of Statechart's events
	 *
	 * @param documentRoot The root element of the StateChart
	 */
	public static List<String> getEventNames(Element documentRoot) throws JDOMException {
		ArrayList<String> eventNames = new ArrayList<String>();
		Iterator<Element> itrT = documentRoot.getDescendants(new ElementFilter("transition"));
		while (itrT.hasNext()) {
			Element aTransitionElement = (Element) itrT.next();
			String eventValue = aTransitionElement.getAttributeValue("event");
			if (!eventNames.contains(eventValue) && eventValue != null) eventNames.add(eventValue);
		}
		return eventNames;
	}


}
