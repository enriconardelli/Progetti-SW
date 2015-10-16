package framework;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import org.jdom.Element;
import org.jdom.filter.ElementFilter;



/*
 * Questa classe implementa i metodi
 * che servono alla lettura del file dei parametri
 * in GUICodeCreator
 */


public class ParamReader {
	
	public static Element Parameters;

	public static Element readConfFile(String file_name, List<String> eventNames){
		//Legge il file dei parametri e lo salva in Parameters, una variabile della classe
		File inputFile = new File(Conf.data_dir + Conf.filesep + Conf.param_dir + Conf.filesep + file_name + Conf.xml_conf_extension);
		Element documentRoot = Common.getDocumentRoot(inputFile);
		
		//Riempie eventuali bottoni mancanti
		ParamReader.fillEvents(eventNames, ParamReader.getEventNames(documentRoot), documentRoot);
		
		//Riempie figli dei bottoni
		List<Element> lista = new CopyOnWriteArrayList<Element>(documentRoot.getChild("buttons").getChildren("button"));
		Iterator<Element> anElement = lista.iterator();
		
		while(anElement.hasNext()){
			Element currentElement = anElement.next();
			
			Iterator<Element> bla = currentElement.getDescendants(new ElementFilter("color"));
			
			if(!bla.hasNext()){
				Element newC = new Element("color");
				newC.setAttribute("expr", "");
				currentElement.addContent(newC);
				}
		
			
			Iterator<Element> blo = currentElement.getDescendants(new ElementFilter("tooltip"));
			if(!blo.hasNext()){
				Element newT = new Element("tooltip");
				newT.setAttribute("expr", "");
				currentElement.addContent(newT);
				}
			
			}
		return documentRoot;	
		}

	
	public static ArrayList<String> getEventNames(Element doc){
		//Trova i nomi degli eventi, mi servirà per il caso in cui manca tutto il button nei parametri
		ArrayList<String> eventListNames= new ArrayList<String>();
		Iterator<Element> anElement = doc.getDescendants(new ElementFilter("button"));
		while (anElement.hasNext()) {
			Element currentElement = anElement.next();
			eventListNames.add(currentElement.getAttributeValue("id"));
		}
		return eventListNames;
	}
		
	public static ArrayList<String> getcolors(String dcolor){
		//Trova la lista dei colori completando col default quando mancanti
		ArrayList<String> colorsList= new ArrayList<String>();
		Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("color"));
		while (anElement.hasNext()) {
			Element currentElement = anElement.next();
			if (!currentElement.getAttributeValue("expr").isEmpty()){
				colorsList.add(currentElement.getAttributeValue("expr").toUpperCase());
			}else{
				colorsList.add(dcolor.toUpperCase());
			}
		}
		return colorsList;
	}
	
	public static ArrayList<String> getTTList(String dtooltip){
		//Trova la lista dei tooltip completando col default quando mancanti
		ArrayList<String> TTList= new ArrayList<String>();
		Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("tooltip"));
		while (anElement.hasNext()) {
			Element currentElement = anElement.next();
			if (!currentElement.getAttributeValue("expr").isEmpty()){
				TTList.add(currentElement.getAttributeValue("expr"));
			}else{
				TTList.add(dtooltip);
			}
			
		}
		return TTList;
	}
	
	public static String[] getDefaultButton(){
		//Trova i parametri di default dei button
		Element Default = Parameters.getChild("defaultb");
		Iterator<Element> col = Default.getDescendants(new ElementFilter("dcolor") );
		Element Col = col.next();
		String dcolor=Col.getAttributeValue("expr");
		
		Iterator<Element> tol =Default.getDescendants(new ElementFilter("dtooltip") );
		Element Tol = tol.next();
		String dtooltip = Tol.getAttributeValue("expr");
		
		String[] Ris = new String[2];
		Ris[0]=dcolor;
		Ris[1]=dtooltip;
		return Ris;
		
	}
	
	public static String writeButtonList(List<String> eventNames) {
		//Stampa sul file la lista dei bottoni
		String result = "";
		// writing the list of all buttons' names 
		result += "\tprivate String[] eventList = { ";
		for (int j = 0; j < eventNames.size(); j++) {
			result += "\"" + eventNames.get(j) + "\"";
			if (j != eventNames.size() - 1)
				result += ", ";
		}
		result += " };" + Conf.linesep;
		return result;
	}
	
	public static String writeColorList(List<String> colorNames) {
		String result = "";
		// writing the list of all colors names  
		result += "\tprivate Color[] eventColorValue = { ";
		for (int j = 0; j < colorNames.size(); j++) {
			result +="Color." + colorNames.get(j);
			if (j != colorNames.size() - 1)
				result += ", ";
		}
		result += " };" + Conf.linesep;
		return result;
	}
	
	
	public static String writeTTList(List<String> toolTips) {
		String result = "";
		// writing the list of all tooltips 
		result += "\tprivate String[] eventTTValue = { ";
		for (int j = 0; j < toolTips.size(); j++) {
			result += "\"" + toolTips.get(j) + "\"";
			if (j != toolTips.size() - 1)
				result += ", ";
		}
		result += " };" + Conf.linesep;
		return result;
	}
	
	
	public static String[] getFrameParam(){
		//Controlla il frame e riempie dove serve col default
		
		String[] params = new String[2];
		
		Iterator<Element> frame = Parameters.getDescendants(new ElementFilter("frame"));
		if(frame.hasNext()){
			Element frameElement = frame.next();
			
			Iterator<Element> bla = frameElement.getDescendants(new ElementFilter("width"));
			if(bla.hasNext())
				params[0]=Parameters.getChild("frame").getChild("width").getValue();
			else
				params[0]=Parameters.getChild("defaultf").getChild("width").getValue();
			
			Iterator<Element> blo = frameElement.getDescendants(new ElementFilter("height"));
			if(blo.hasNext())
				params[1]=Parameters.getChild("frame").getChild("height").getValue();
			else
				params[1]=Parameters.getChild("defaultf").getChild("height").getValue();
			
		}else{
			params[0]=Parameters.getChild("defaultf").getChild("width").getValue();
			params[1]=Parameters.getChild("defaultf").getChild("height").getValue();
		}
		
		
		return params;
	}
	
	public static void fillEvents(List<String> eventNames, List<String> buttonNames, Element doc){
		//CONTROLLA che nel file dei parametri non manchino bottoni e se mancano li inserisce con la lista degli eventi
		Boolean flag;
		
		for(String event : eventNames){
			flag=false;
			for(String button : buttonNames){
				if(button.equals(event)){
					flag=true;
				}
			}
			
			if(!flag){
				Element newE = new Element("button");
				newE.setAttribute("id", event.toString());
				doc.getChild("buttons").addContent(newE);
			}
		}
	}
	
}
