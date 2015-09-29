package framework;
/*
 * file per contenere funzioni comuni a più classi
 */

import java.io.File;
import java.io.IOException;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

public class Common {
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

}
