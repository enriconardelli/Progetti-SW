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

	public static Element readConfFile(String file_name, List<String> eventNames, List<String> variableNames){
		//Legge il file dei parametri e lo salva in Parameters, una variabile della classe
		File inputFile = new File(Conf.data_dir + Conf.filesep + file_name + Conf.xml_conf_extension);
		Element documentRoot = Common.getDocumentRoot(inputFile);
		
		
		//GESTISCO I BOTTONI***************************
		//Riempie eventuali bottoni mancanti e figli
		ParamReader.fillEvents(eventNames, ParamReader.getEventNames(documentRoot), documentRoot);
		ParamReader.buttonChildFill(documentRoot);
		
		//GESTISCO I PANEL***********************
		//inserisce eventuali panel mancanti e figli
		ParamReader.fillPanels(variableNames, ParamReader.getPanelNames(documentRoot), documentRoot);
		ParamReader.panelChildFill(documentRoot);
		
		//GESTISCO I TFIELD (LI DEVO ORDINARE COME I PANEL!!!)
		ParamReader.tFieldChildFill(documentRoot);
		
		//GESTICO I FONT 
		ParamReader.fillFonts(documentRoot);
		ParamReader.fillChildFont(documentRoot);
		
		return documentRoot;	
		}

//FRAME E BOTTONI**************************************************************************************************
	
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
		Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("bcolor"));
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
		Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("btooltip"));
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
	
	public static void buttonChildFill(Element doc){
		//Riempie figli dei bottoni
				List<Element> lista = new CopyOnWriteArrayList<Element>(doc.getChild("buttons").getChildren("button"));
				Iterator<Element> anElement = lista.iterator();
				
				while(anElement.hasNext()){
					Element currentElement = anElement.next();
					
					Iterator<Element> bla = currentElement.getDescendants(new ElementFilter("bcolor"));
					
					if(!bla.hasNext()){
						Element newC = new Element("bcolor");
						newC.setAttribute("expr", "");
						currentElement.addContent(newC);
						}
				
					
					Iterator<Element> blo = currentElement.getDescendants(new ElementFilter("btooltip"));
					if(!blo.hasNext()){
						Element newT = new Element("btooltip");
						newT.setAttribute("expr", "");
						currentElement.addContent(newT);
						}
					
					}
	}
	
//DA QUI PARTONO I PANEL********************************************************************************************
	
	
	public static ArrayList<String> getPanelColor(String dcolor){
		//Trova la lista dei colori completando col default quando mancanti (DEI PANELS)
				ArrayList<String> colorsList= new ArrayList<String>();
				Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("pcolor"));
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
	
	
	public static String[] getDefaultPanel(){
		//Trova i parametri di default dei button
		Element Default = Parameters.getChild("defaultp");
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
	
	public static ArrayList<String> getTTPList(String dtooltip){
		//Trova la lista dei tooltip dei panel completando col default quando mancanti
		ArrayList<String> TTList= new ArrayList<String>();
		Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("ptooltip"));
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
	
	public static ArrayList<String> getPanelNames(Element doc){
		//Trova i nomi degli eventi, mi servirà per il caso in cui manca tutto il button nei parametri
		ArrayList<String> panelListNames= new ArrayList<String>();
		Iterator<Element> anElement = doc.getDescendants(new ElementFilter("panel"));
		while (anElement.hasNext()) {
			Element currentElement = anElement.next();
			panelListNames.add(currentElement.getAttributeValue("id"));
		}
		return panelListNames;
	}
	
	
	public static String writePanelList(List<String> panelNames) {
		//Stampa sul file la lista dei bottoni
		String result = "";
		// writing the list of all buttons' names 
		result += "\tprivate String[] panelList = { ";
		for (int j = 0; j < panelNames.size(); j++) {
			result += "\"" + panelNames.get(j) + "\"";
			if (j != panelNames.size() - 1)
				result += ", ";
		}
		result += " };" + Conf.linesep;
		return result;
	}
	
	public static String writeColorPList(List<String> colorPNames) {
		String result = "";
		// writing the list of all colors names  
		result += "\tprivate Color[] panelColorValue = { ";
		for (int j = 0; j < colorPNames.size(); j++) {
			result +="Color." + colorPNames.get(j);
			if (j != colorPNames.size() - 1)
				result += ", ";
		}
		result += " };" + Conf.linesep;
		return result;
	}
	
	
	public static String writeTTPList(List<String> toolPTips) {
		String result = "";
		// writing the list of all tooltips 
		result += "\tprivate String[] panelTTValue = { ";
		for (int j = 0; j < toolPTips.size(); j++) {
			result += "\"" + toolPTips.get(j) + "\"";
			if (j != toolPTips.size() - 1)
				result += ", ";
		}
		result += " };" + Conf.linesep;
		return result;
	}
	

	public static void fillPanels(List<String> variableNames, List<String> panelNames, Element doc){
		//CONTROLLA che nel file dei parametri non manchino Panel e se mancano li inserisce con la lista delle variabili
		Boolean flag;
		
		for(String var : variableNames){
			flag=false;
			for(String panel : panelNames){
				if(panel.equals(var)){
					flag=true;
				}
			}
			
			if(!flag){
				Element newP = new Element("panel");
				newP.setAttribute("id", var.toString());
				doc.getChild("panels").addContent(newP);
			}
		}
	}
	
	public static void panelChildFill(Element doc){
		//Riempie figli dei panel
				List<Element> lista = new CopyOnWriteArrayList<Element>(doc.getChild("panels").getChildren("panel"));
				Iterator<Element> anElement = lista.iterator();
				
				while(anElement.hasNext()){
					Element currentElement = anElement.next();
					
					Iterator<Element> bla = currentElement.getDescendants(new ElementFilter("pcolor"));
					
					if(!bla.hasNext()){
						Element newC = new Element("pcolor");
						newC.setAttribute("expr", "");
						currentElement.addContent(newC);
						}
				
					
					Iterator<Element> blo = currentElement.getDescendants(new ElementFilter("ptooltip"));
					if(!blo.hasNext()){
						Element newT = new Element("ptooltip");
						newT.setAttribute("expr", "");
						currentElement.addContent(newT);
						}
					
					}
	}
	
//DA QUI I TEXTFIELD*****************************************************************************************************
	
	public static ArrayList<String> getTFieldColor(String dcolor){
		//Trova la lista dei colori completando col default quando mancanti (DEI PANELS)
				ArrayList<String> colorsList= new ArrayList<String>();
				Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("tfcolor"));
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
	
	
	public static String[] getDefaultTField(){
		//Trova i parametri di default dei button
		Element Default = Parameters.getChild("defaultp");
		Iterator<Element> col = Default.getDescendants(new ElementFilter("dtfcolor") );
		Element Col = col.next();
		String dcolor=Col.getAttributeValue("expr");
		
		Iterator<Element> tol =Default.getDescendants(new ElementFilter("dtftooltip") );
		Element Tol = tol.next();
		String dtooltip = Tol.getAttributeValue("expr");
		
		String[] Ris = new String[2];
		Ris[0]=dcolor;
		Ris[1]=dtooltip;
		return Ris;
		
	}
	
	public static ArrayList<String> getTTTFList(String dtooltip){
		//Trova la lista dei tooltip dei panel completando col default quando mancanti
		ArrayList<String> TTList= new ArrayList<String>();
		Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("tftooltip"));
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

	
	public static String writeColorTFList(List<String> colorTFNames) {
		String result = "";
		// writing the list of all colors names  
		result += "\tprivate Color[] tFieldColorValue = { ";
		for (int j = 0; j < colorTFNames.size(); j++) {
			result +="Color." + colorTFNames.get(j);
			if (j != colorTFNames.size() - 1)
				result += ", ";
		}
		result += " };" + Conf.linesep;
		return result;
	}
	
	
	public static String writeTTTFList(List<String> toolTFTips) {
		String result = "";
		// writing the list of all tooltips 
		result += "\tprivate String[] tFieldTTValue = { ";
		for (int j = 0; j < toolTFTips.size(); j++) {
			result += "\"" + toolTFTips.get(j) + "\"";
			if (j != toolTFTips.size() - 1)
				result += ", ";
		}
		result += " };" + Conf.linesep;
		return result;
	}
	
	public static void tFieldChildFill(Element doc){
		//Riempie figli dei panel
				List<Element> lista = new CopyOnWriteArrayList<Element>(doc.getChild("panels").getChildren("panel"));
				Iterator<Element> anElement = lista.iterator();
				
				while(anElement.hasNext()){
					Element currentElement = anElement.next();
					
					Iterator<Element> bla = currentElement.getDescendants(new ElementFilter("tfcolor"));
					
					if(!bla.hasNext()){
						Element newC = new Element("tfcolor");
						newC.setAttribute("expr", "");
						currentElement.addContent(newC);
						}
				
					
					Iterator<Element> blo = currentElement.getDescendants(new ElementFilter("tftooltip"));
					if(!blo.hasNext()){
						Element newT = new Element("tftooltip");
						newT.setAttribute("expr", "");
						currentElement.addContent(newT);
						}
					
					}
	}
	
//QUI TRATTO I FONT*************************
	
	
	public static ArrayList<String[]> getFont(Element doc, String[] Default){
		//METTE I FONT ORDINATI E RIEMPIENDO COL DEFAULT
		
		ArrayList<String[]> Ris = new ArrayList<String[]>();
		
		List<Element> fonts = doc.getChild("fonts").getChildren("font");
		
		
		for(Element font : fonts){
			if(font.getAttributeValue("id").equals("buttons")){
				String[] ris = new String[3];
				if (!font.getChild("type").getAttributeValue("expr").isEmpty()){
					ris[0]=font.getChild("type").getAttributeValue("expr");
				}else{
					ris[0]=Default[0];
				}
				if (!font.getChild("mode").getAttributeValue("expr").isEmpty()){
					ris[1]=font.getChild("mode").getAttributeValue("expr");
				}else{
					ris[1]=Default[1];
				}
				if (!font.getChild("dimension").getAttributeValue("expr").isEmpty()){
					ris[2]=font.getChild("dimension").getAttributeValue("expr");
				}else{
					ris[2]=Default[2];
				}
				Ris.add(ris);
			}
		}
		for(Element font : fonts){
			if(font.getAttributeValue("id").equals("panels")){
				String[] ris = new String[3];
				if (!font.getChild("type").getAttributeValue("expr").isEmpty()){
					ris[0]=font.getChild("type").getAttributeValue("expr");
				}else{
					ris[0]=Default[0];
				}
				if (!font.getChild("mode").getAttributeValue("expr").isEmpty()){
					ris[1]=font.getChild("mode").getAttributeValue("expr");
				}else{
					ris[1]=Default[1];
				}
				if (!font.getChild("dimension").getAttributeValue("expr").isEmpty()){
					ris[2]=font.getChild("dimension").getAttributeValue("expr");
				}else{
					ris[2]=Default[2];
				}
				Ris.add(ris);
			}
		}
		for(Element font : fonts){
			if(font.getAttributeValue("id").equals("fields")){
				String[] ris = new String[3];
				if (!font.getChild("type").getAttributeValue("expr").isEmpty()){
					ris[0]=font.getChild("type").getAttributeValue("expr");
				}else{
					ris[0]=Default[0];
				}
				if (!font.getChild("mode").getAttributeValue("expr").isEmpty()){
					ris[1]=font.getChild("mode").getAttributeValue("expr");
				}else{
					ris[1]=Default[1];
				}
				if (!font.getChild("dimension").getAttributeValue("expr").isEmpty()){
					ris[2]=font.getChild("dimension").getAttributeValue("expr");
				}else{
					ris[2]=Default[2];
				}
				Ris.add(ris);
			}
		}
		
		return Ris;
	}
	
	public static String[] getDefaultFont(Element doc){
		String[] deff = new String[3]; //TYPE MODE DIM
		//Trova i parametri di default dei font
		Element Default = Parameters.getChild("defaultcar");
		Iterator<Element> col = Default.getDescendants(new ElementFilter("dtype") );
		Element Col = col.next();
		String dtype=Col.getAttributeValue("expr");
				
		Iterator<Element> tol =Default.getDescendants(new ElementFilter("dmode") );
		Element Tol = tol.next();
		String dmode = Tol.getAttributeValue("expr");
				
		Iterator<Element> dim =Default.getDescendants(new ElementFilter("ddimension") );
		Element Dim = dim.next();
		String ddim = Dim.getAttributeValue("expr");
				
		deff[0]=dtype;
		deff[1]=dmode;
		deff[2]=ddim;
		return deff;
	}
	
	public static void fillChildFont(Element doc){
		//Riempie figli dei font
		List<Element> lista = new CopyOnWriteArrayList<Element>(doc.getChild("fonts").getChildren("font"));
		Iterator<Element> anElement = lista.iterator();
		
		while(anElement.hasNext()){
			Element currentElement = anElement.next();
			
			Iterator<Element> bla = currentElement.getDescendants(new ElementFilter("type"));
			
			if(!bla.hasNext()){
				Element newT = new Element("type");
				newT.setAttribute("expr", "");
				currentElement.addContent(newT);
				}
		
			
			Iterator<Element> blo = currentElement.getDescendants(new ElementFilter("mode"));
			if(!blo.hasNext()){
				Element newM = new Element("mode");
				newM.setAttribute("expr", "");
				currentElement.addContent(newM);
				}
			
		
		Iterator<Element> ble = currentElement.getDescendants(new ElementFilter("dimension"));
		if(!ble.hasNext()){
			Element newD = new Element("dimension");
			newD.setAttribute("expr", "");
			currentElement.addContent(newD);
			}
		
		}
	}
	
	public static void fillFonts(Element doc){
		//CONTROLLA che nel file dei parametri non manchino Fonts e se mancano li inserisce 
		//I font devono essere 3 alla fine, uno per buttons uno per panels e uno per fields
		Boolean flagb,flagp,flagf;
		flagb=false;
		flagp=false;
		flagf=false;
		
		List<Element> fonts = doc.getChild("fonts").getChildren("font");
		for(Element font : fonts){
			if(font.getAttributeValue("id").equals("buttons")){
				flagb = true;
			}else if(font.getAttributeValue("id").equals("panels")){
				flagp = true;
			}else if(font.getAttributeValue("id").equals("fields")){
				flagf = true;
			}
		}
		if(!flagb){
			Element newF = new Element("font");
			newF.setAttribute("id", "buttons");
			doc.getChild("fonts").addContent(newF);
		}
		
		if(!flagp){
			Element newF = new Element("font");
			newF.setAttribute("id", "panels");
			doc.getChild("fonts").addContent(newF);
		}
		
		if(!flagf){
			Element newF = new Element("font");
			newF.setAttribute("id", "fields");
			doc.getChild("fonts").addContent(newF);
		}
	}
	
	public static String writeFont(ArrayList<String[]> font){
		String result = "";
		result += "\tprivate Font buttfont = new Font( \"" + font.get(0)[0] + "\", Font." + font.get(0)[1].toUpperCase() + ", " + font.get(0)[2] + ");";
		result += Conf.linesep;
		result += "\tprivate Font panelfont = new Font( \"" + font.get(1)[0] + "\", Font." + font.get(1)[1].toUpperCase() + ", " + font.get(1)[2] + ");";
		result += Conf.linesep;
		result += "\tprivate Font fieldfont = new Font( \"" + font.get(2)[0] + "\", Font." + font.get(2)[1].toUpperCase() + ", " + font.get(2)[2] + ");";
		result += Conf.linesep;
		return result;
	}
}
