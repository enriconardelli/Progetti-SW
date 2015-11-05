package framework;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import org.jdom.Element;
import org.jdom.filter.ElementFilter;

public class SC_Element extends Element {

		public SC_Element(String file_name){
		super(file_name);
	}
	
		public void addFile(){
		
		//Legge il file dei parametri se esiste altrimenti crea un element vuoto di nome parameters
		//Poi controlla che ci sia effettivamente il figlio chiamato parameters
		//in tal caso lo aggiunge come figlio dell'oggetto che viene creato
		String file_name = getName();
		File inputFile = new File(Conf.data_dir + Conf.filesep + file_name + Conf.xml_conf_extension);
		Element documentRoot;
		if(inputFile.exists())
			 documentRoot = Common.getDocumentRoot(inputFile);
			else{
				 documentRoot = new Element("parameters");
			}
		//Controlla che ci sia parameters, il resto può anche mancare
		checkParameters(documentRoot);
		documentRoot.detach();
		addContent(documentRoot);  //NON POSSO AGGIUNGERLO A NULLA PERCHé NULLA ANCORA ESISTE!!!!!!!!!!!!
	}
	
	//RIEMPIMENTO DI TUTTO SE SERVE
		public void checkAll(List<String> eventNames, List<String> variableNames){
		//Riempi eventuale mancanza dei figli diretti di parameters, esclusi i default
		fillBigChild();
		
		//Riempi eventuale mancanza di default col default in conf
		fillDefaults();

		//Riempie eventuali bottoni mancanti e figli
		fillEvents(eventNames, getEventNames());
		fillButtonChild();
		//inserisce eventuali panel mancanti e figli
		fillPanels(variableNames, getPanelNames());
		fillPanelChild();
		
		//inserisce i figli mancanti dei panel riferiti ai text_field
		fillTextFieldChild();
		
		//riempio i font e i loro figli se serve 
		fillFonts();
		fillChildFont();
	}
	
	
	//ESISTENZA DI PARAMETERS****************************************************************************************
		public static void checkParameters(Element doc) {
		if (!doc.getName().equals("parameters")) {
			System.err.println("The xml configuration file does not contain the root parameters."
							+ " Check it! Parsing will be interrupted");
		}
	}

	//FIGLI DIRETTI DI PARAMETERS************************************************************************************
		public void fillBigChild(){
			//se manca o non è figlio diretto di parameters aggiungilo!
			Iterator<Element> buttons = getDescendants(new ElementFilter("buttons"));
			if(!buttons.hasNext() || !buttons.next().getParent().equals(getChild("parameters"))){
				getChild("parameters").addContent(new Element("buttons"));
			}
			Iterator<Element> panels = getDescendants(new ElementFilter("panels"));
			if(!panels.hasNext() || !panels.next().getParent().equals(getChild("parameters"))){
				getChild("parameters").addContent(new Element("panels"));
			}
			Iterator<Element> fields = getDescendants(new ElementFilter("fields"));
			if(!fields.hasNext() || !fields.next().getParent().equals(getChild("parameters"))){
				getChild("parameters").addContent(new Element("fields"));
			}
			Iterator<Element> fonts = getDescendants(new ElementFilter("fonts"));
			if(!fonts.hasNext() || !fonts.next().getParent().equals(getChild("parameters"))){
				getChild("parameters").addContent(new Element("fonts"));
			}
			Iterator<Element> frame = getDescendants(new ElementFilter("frame"));
			if(!frame.hasNext() || !frame.next().getParent().equals(getChild("parameters"))){
				getChild("parameters").addContent(new Element("frame"));
			}		
		}
		
	//DEFAULT TUTTI CHE RIEMPIO CON CONF*****************************************************************************
		public void fillDefaults(){
			//Controllo la presenza di default e che siano figli diretti di parameters
			//Se mancano, non sono completi o non sono figli diretti li creo o riempio io
			Iterator<Element> dbutton = getChild("parameters").getDescendants(new ElementFilter("button_default"));
			if(!dbutton.hasNext() || !dbutton.next().getParent().equals(getChild("parameters"))){
				Element button_default = new Element("button_default");
				Element dcolor = new Element("dcolor");
				dcolor.setAttribute("expr", Conf.default_button_color);
				Element dtooltip = new Element("dtooltip");
				dtooltip.setAttribute("expr", Conf.default_button_tooltip);
				button_default.addContent(dcolor);
				button_default.addContent(dtooltip);
				getChild("parameters").addContent(button_default);
			}
			else{
				Element default_button = getChild("parameters").getChild("button_default");
				Iterator<Element> dcolor = default_button.getDescendants(new ElementFilter("dcolor"));
				if(!dcolor.hasNext()){
					Element def_color = new Element("dcolor");
					def_color.setAttribute("expr", Conf.default_button_color);
					default_button.addContent(def_color);
				}
				Iterator<Element> dtooltip = default_button.getDescendants(new ElementFilter("dtooltip"));
				if(!dtooltip.hasNext()){
					Element def_tooltip = new Element("dtooltip");
					def_tooltip.setAttribute("expr", Conf.default_button_tooltip);
					default_button.addContent(def_tooltip);
				}
			}
			
			Iterator<Element> dpanel = getChild("parameters").getDescendants(new ElementFilter("panel_default"));
			if(!dpanel.hasNext() || !dpanel.next().getParent().equals(getChild("parameters"))){
				Element panel_default = new Element("panel_default");
				Element dcolor = new Element("dcolor");
				dcolor.setAttribute("expr", Conf.default_panel_color);
				Element dtooltip = new Element("dtooltip");
				dtooltip.setAttribute("expr", Conf.default_panel_tooltip);
				Element dtext_field_color = new Element("dtext_field_color");
				dtext_field_color.setAttribute("expr", Conf.default_text_field_color);
				Element dtext_field_tooltip = new Element("dtext_field_tooltip");
				dtext_field_tooltip.setAttribute("expr", Conf.default_text_field_tooltip);
				panel_default.addContent(dcolor);
				panel_default.addContent(dtooltip);
				panel_default.addContent(dtext_field_color);
				panel_default.addContent(dtext_field_tooltip);
				getChild("parameters").addContent(panel_default);
			}
			else{
				Element default_panel = getChild("parameters").getChild("panel_default");
				Iterator<Element> dcolor = default_panel.getDescendants(new ElementFilter("dcolor"));
				if(!dcolor.hasNext()){
					Element def_color = new Element("dcolor");
					def_color.setAttribute("expr", Conf.default_panel_color);
					default_panel.addContent(def_color);
				}
				Iterator<Element> dtooltip = default_panel.getDescendants(new ElementFilter("dtooltip"));
				if(!dtooltip.hasNext()){
					Element def_tooltip = new Element("dtooltip");
					def_tooltip.setAttribute("expr", Conf.default_panel_tooltip);
					default_panel.addContent(def_tooltip);
				}
				Iterator<Element> dtcolor = default_panel.getDescendants(new ElementFilter("dtext_field_color"));
				if(!dtcolor.hasNext()){
					Element def_tcolor = new Element("dtext_field_color");
					def_tcolor.setAttribute("expr", Conf.default_text_field_color);
					default_panel.addContent(def_tcolor);
				}
				Iterator<Element> dttooltip = default_panel.getDescendants(new ElementFilter("dtext_field_tooltip"));
				if(!dttooltip.hasNext()){
					Element def_ttooltip = new Element("dtext_field_tooltip");
					def_ttooltip.setAttribute("expr", Conf.default_text_field_tooltip);
					default_panel.addContent(def_ttooltip);
				}
			}
			
			Iterator<Element> dfont = getChild("parameters").getDescendants(new ElementFilter("font_default"));
			if(!dfont.hasNext() || !dfont.next().getParent().equals(getChild("parameters"))){
				Element font_default = new Element("font_default");
				Element dtype = new Element("dtype");
				dtype.setAttribute("expr", Conf.default_font_type);
				Element dmode = new Element("dmode");
				dmode.setAttribute("expr", Conf.default_font_mode);
				Element ddimension = new Element("ddimension");
				ddimension.setAttribute("expr",Conf.default_font_dimension);
				font_default.addContent(dtype);
				font_default.addContent(dmode);
				font_default.addContent(ddimension);
				getChild("parameters").addContent(font_default);
			}
			else{
				Element default_font = getChild("parameters").getChild("font_default");;
				Iterator<Element> dtype = default_font.getDescendants(new ElementFilter("dtype"));
				if(!dtype.hasNext()){
					Element def_type = new Element("dtype");
					def_type.setAttribute("expr", Conf.default_font_type);
					default_font.addContent(def_type);
				}
				Iterator<Element> dmode = default_font.getDescendants(new ElementFilter("dmode"));
				if(!dmode.hasNext()){
					Element def_mode = new Element("dmode");
					def_mode.setAttribute("expr", Conf.default_font_mode);
					default_font.addContent(def_mode);
				}
				Iterator<Element> ddimension = default_font.getDescendants(new ElementFilter("ddimension"));
				if(!ddimension.hasNext()){
					Element def_dim = new Element("ddimension");
					def_dim.setAttribute("expr", Conf.default_button_color);
					default_font.addContent(def_dim);
				}			
			}
			
			Iterator<Element> dframe = getChild("parameters").getDescendants(new ElementFilter("frame_default"));
			if(!dframe.hasNext() || !dframe.next().getParent().equals(getChild("parameters"))){
				Element frame_default = new Element("frame_default");
				Element width = new Element("width");
				width.setText(Conf.default_frame_width);
				Element height = new Element("height");
				height.setText( Conf.default_frame_height);
				frame_default.addContent(width);
				frame_default.addContent(height);
				getChild("parameters").addContent(frame_default);
			}
			else{
				Element default_frame = getChild("parameters").getChild("frame_default");;
				Iterator<Element> width = default_frame.getDescendants(new ElementFilter("width"));
				if(!width.hasNext()){
					Element def_width = new Element("width");
					def_width.setText(Conf.default_frame_width);
					default_frame.addContent(def_width);
				}
				Iterator<Element> height = default_frame.getDescendants(new ElementFilter("height"));
				if(!height.hasNext()){
					Element def_height = new Element("height");
					def_height.setText(Conf.default_frame_height);
					default_frame.addContent(def_height);
				}
			}
		}

	//FRAME E BOTTONI************************************************************************************************
		public ArrayList<String> getEventNames(){
			//Trova i nomi degli eventi
			ArrayList<String> eventListNames= new ArrayList<String>();
			Iterator<Element> anElement = getChild("parameters").getDescendants(new ElementFilter("button"));
			while (anElement.hasNext()) {
				Element currentElement = anElement.next();
				eventListNames.add(currentElement.getAttributeValue("id"));
			}
			return eventListNames;
		}
		
		public ArrayList<String> getButtonColors(){
			//Trova la lista dei colori completando col default quando mancanti
			String dcolor = getDefaultButton().get("color");
			ArrayList<String> colorsList= new ArrayList<String>();
			Iterator<Element> anElement = getChild("parameters").getChild("buttons").getDescendants(new ElementFilter("color"));
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
		
		public  ArrayList<String> getButtonToolTipList(){
			//Trova la lista dei tooltip completando col default quando mancanti
			String dtooltip = getDefaultButton().get("tooltip");
			ArrayList<String> TTList= new ArrayList<String>();
			Iterator<Element> anElement =getChild("parameters").getChild("buttons").getDescendants(new ElementFilter("tooltip"));
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
		
		public HashMap<String,String> getDefaultButton(){
			//Trova i parametri di default dei button
			Element Default = getChild("parameters").getChild("button_default");
			Iterator<Element> col = Default.getDescendants(new ElementFilter("dcolor") );
			Element Col = col.next();
			String dcolor=Col.getAttributeValue("expr");
			
			Iterator<Element> tol =Default.getDescendants(new ElementFilter("dtooltip") );
			Element Tol = tol.next();
			String dtooltip = Tol.getAttributeValue("expr");

			HashMap<String,String> Res = new HashMap<String,String>();
			Res.put("color", dcolor);
			Res.put("tooltip", dtooltip);
			return Res;		
		}
		
		public  String writeButtonList(List<String> eventNames) {
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
		
		public  String writeButtonColorList(List<String> colorNames) {
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
			
		public String writeButtonToolTipList(List<String> toolTips) {
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
		
		public HashMap<String,String> getFrameParam(){
			//Controlla il frame e riempie dove serve col default
			String[] params = new String[2];
			
			Iterator<Element> frame = getDescendants(new ElementFilter("frame"));
			if(frame.hasNext()){
				Element frameElement = frame.next();
				Iterator<Element> frameElement_width = frameElement.getDescendants(new ElementFilter("width"));
				if(frameElement_width.hasNext())
					params[0]=getChild("parameters").getChild("frame").getChild("width").getValue();
				else{
					params[0]=getChild("parameters").getChild("frame_default").getChild("width").getValue();}
				Iterator<Element> FrameElement_height = frameElement.getDescendants(new ElementFilter("height"));
				if(FrameElement_height.hasNext())
					params[1]=getChild("parameters").getChild("frame").getChild("height").getValue();
				else
					params[1]=getChild("parameters").getChild("frame_default").getChild("height").getValue();
			}else{
				params[0]=getChild("parameters").getChild("frame_default").getChild("width").getValue();
				params[1]=getChild("parameters").getChild("frame_default").getChild("height").getValue();
			}
			HashMap<String,String> ris = new HashMap<String,String>();
			ris.put("width", params[0]);
			ris.put("height", params[1]);
			return ris;
		}
		
		public void fillEvents(List<String> eventNames, List<String> buttonNames){
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
					getChild("parameters").getChild("buttons").addContent(newE);
				}
			}
		}
		
		public void fillButtonChild() {
			// Riempie figli dei bottoni
			List<Element> lista = new CopyOnWriteArrayList<Element>(getChild("parameters").getChild("buttons").getChildren("button"));
			Iterator<Element> anElement = lista.iterator();
			while (anElement.hasNext()) {
				Element currentElement = anElement.next();
				Iterator<Element> button_iterator_color = currentElement.getDescendants(new ElementFilter("color"));
				if (!button_iterator_color.hasNext()) {
					Element newC = new Element("color");
					newC.setAttribute("expr", "");
					currentElement.addContent(newC);
				}
				Iterator<Element> button_iterator_tooltip = currentElement.getDescendants(new ElementFilter("tooltip"));
				if (!button_iterator_tooltip.hasNext()) {
					Element newT = new Element("tooltip");
					newT.setAttribute("expr", "");
					currentElement.addContent(newT);
				}
			}
		}
		
	//DA QUI PARTONO I PANEL*****************************************************************************************
		
		public ArrayList<String> getPanelColor(){
			//Trova la lista dei colori completando col default quando mancanti (DEI PANELS)
			String dcolor = getDefaultPanel().get("color");
					ArrayList<String> colorsList= new ArrayList<String>();
					Iterator<Element> anElement = getChild("parameters").getChild("panels").getDescendants(new ElementFilter("color"));
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
		
		
		public HashMap<String,String> getDefaultPanel(){
			//Trova i parametri di default dei button
			Element Default = getChild("parameters").getChild("panel_default");
			Iterator<Element> col = Default.getDescendants(new ElementFilter("dcolor") );
			Element Col = col.next();
			String dcolor=Col.getAttributeValue("expr");
			
			Iterator<Element> tol =Default.getDescendants(new ElementFilter("dtooltip") );
			Element Tol = tol.next();
			String dtooltip = Tol.getAttributeValue("expr");
			
			HashMap<String,String> Ris = new HashMap<String,String>();
			Ris.put("color", dcolor);
			Ris.put("tooltip", dtooltip);
			return Ris;
			
		}
		
		public ArrayList<String> getPanelToolTipList(){
			//Trova la lista dei tooltip dei panel completando col default quando mancanti
			String dtooltip = getDefaultPanel().get("tooltip");
			ArrayList<String> TTList= new ArrayList<String>();
			Iterator<Element> anElement = getChild("parameters").getChild("panels").getDescendants(new ElementFilter("tooltip"));
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
		
		public ArrayList<String> getPanelNames(){
			//Trova i nomi degli eventi, mi servirà per il caso in cui manca tutto il button nei parametri
			ArrayList<String> panelListNames= new ArrayList<String>();
			Iterator<Element> anElement = getDescendants(new ElementFilter("panel"));
			while (anElement.hasNext()) {
				Element currentElement = anElement.next();
				panelListNames.add(currentElement.getAttributeValue("id"));
			}
			return panelListNames;
		}
			
		public String writePanelList(List<String> panelNames) {
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
		
		public String writePanelColorList(List<String> colorPNames) {
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
			
		public String writePanelToolTipList(List<String> toolPTips) {
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
		
		public void fillPanels(List<String> variableNames, List<String> panelNames){
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
					getChild("parameters").getChild("panels").addContent(newP);
				}
			}
		}
		
		public void fillPanelChild() {
			// Riempie figli dei panel
			List<Element> lista = new CopyOnWriteArrayList<Element>(getChild("parameters").getChild("panels").getChildren("panel"));
			Iterator<Element> anElement = lista.iterator();
			while (anElement.hasNext()) {
				Element currentElement = anElement.next();
				Iterator<Element> panel_iterator_color = currentElement.getDescendants(new ElementFilter("color"));
				if (!panel_iterator_color.hasNext()) {
					Element newC = new Element("color");
					newC.setAttribute("expr", "");
					currentElement.addContent(newC);
				}
				Iterator<Element> panel_iterator_tooltip = currentElement.getDescendants(new ElementFilter("tooltip"));
				if (!panel_iterator_tooltip.hasNext()) {
					Element newT = new Element("tooltip");
					newT.setAttribute("expr", "");
					currentElement.addContent(newT);
				}
			}
		}
		
	//DA QUI I TEXTFIELD*********************************************************************************************
		
		public ArrayList<String> getTextFieldColor() {
			// Trova la lista dei colori completando col default quando mancanti
			// (DEI PANELS)
			String dcolor = getDefaultTextField().get("color");
			ArrayList<String> colorsList = new ArrayList<String>();
			Iterator<Element> anElement = getChild("parameters").getChild("panels").getDescendants(new ElementFilter("text_field_color"));
			while (anElement.hasNext()) {
				Element currentElement = anElement.next();
				if (!currentElement.getAttributeValue("expr").isEmpty()) {
					colorsList.add(currentElement.getAttributeValue("expr")
							.toUpperCase());
				} else {
					colorsList.add(dcolor.toUpperCase());
				}
			}
			return colorsList;
		}
			
		public HashMap<String,String> getDefaultTextField(){
			//Trova i parametri di default dei button
			Element Default = getChild("parameters").getChild("panel_default");
			Iterator<Element> col = Default.getDescendants(new ElementFilter("dtext_field_color") );
			Element Col = col.next();
			String dcolor=Col.getAttributeValue("expr");
			
			Iterator<Element> tol =Default.getDescendants(new ElementFilter("dtext_field_tooltip") );
			Element Tol = tol.next();
			String dtooltip = Tol.getAttributeValue("expr");
			
			HashMap<String,String> Ris = new HashMap<String,String>();
			Ris.put("color", dcolor);
			Ris.put("tooltip", dtooltip);
			return Ris;		
		}
		
		public ArrayList<String> getToolTipTextFieldList(){
			//Trova la lista dei tooltip dei panel completando col default quando mancanti
			String dtooltip = getDefaultTextField().get("tooltip");
			ArrayList<String> TTList= new ArrayList<String>();
			Iterator<Element> anElement = getChild("parameters").getChild("panels").getDescendants(new ElementFilter("text_field_tooltip"));
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

		
		public  String writeTextFieldColorList(List<String> colorTFNames) {
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
		
		public String writeTextFieldToolTipList(List<String> toolTFTips) {
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
		
		public void fillTextFieldChild() {
			// Riempie figli dei panel
			List<Element> lista = new CopyOnWriteArrayList<Element>(getChild("parameters").getChild("panels").getChildren("panel"));
			Iterator<Element> anElement = lista.iterator();
			while (anElement.hasNext()) {
				Element currentElement = anElement.next();
				Iterator<Element> text_field_color = currentElement.getDescendants(new ElementFilter("text_field_color"));
				if (!text_field_color.hasNext()) {
					Element newC = new Element("text_field_color");
					newC.setAttribute("expr", "");
					currentElement.addContent(newC);
				}
				Iterator<Element> text_field_tooltip = currentElement.getDescendants(new ElementFilter("text_field_tooltip"));
				if (!text_field_tooltip.hasNext()) {
					Element newT = new Element("text_field_tooltip");
					newT.setAttribute("expr", "");
					currentElement.addContent(newT);
				}
			}
		}
		
	//QUI TRATTO I FONT**********************************************************************************************
		
		public HashMap<String,HashMap<String,String>> getFont(){
			//METTE I FONT ORDINATI E RIEMPIENDO COL DEFAULT
			HashMap<String,String> Default = getDefaultFont();
			
			List<Element> fonts = getChild("parameters").getChild("fonts").getChildren("font");
			HashMap<String,HashMap<String,String>> Res = new HashMap<String,HashMap<String,String>>();
			for(Element font : fonts){
				if(font.getAttributeValue("id").equals("buttons")){
					HashMap<String,String> phont = new HashMap<String,String>();
					if (!font.getChild("type").getAttributeValue("expr").isEmpty()){
						phont.put("type",font.getChild("type").getAttributeValue("expr"));
					}else{
						phont.put("type",Default.get("type"));
					}
					if (!font.getChild("mode").getAttributeValue("expr").isEmpty()){
						phont.put("mode", font.getChild("mode").getAttributeValue("expr"));
					}else{
						phont.put("mode",Default.get("mode"));
					}
					if (!font.getChild("dimension").getAttributeValue("expr").isEmpty()){
						phont.put("dimension",font.getChild("dimension").getAttributeValue("expr"));
					}else{
						phont.put("dimension",Default.get("dimension"));
					}
					Res.put("buttons",phont);	
				}
			}
			for(Element font : fonts){
				if(font.getAttributeValue("id").equals("panels")){
					HashMap<String,String> phont = new HashMap<String,String>();
					if (!font.getChild("type").getAttributeValue("expr").isEmpty()){
						phont.put("type",font.getChild("type").getAttributeValue("expr"));
					}else{
						phont.put("type",Default.get("type"));
					}
					if (!font.getChild("mode").getAttributeValue("expr").isEmpty()){
						phont.put("mode", font.getChild("mode").getAttributeValue("expr"));
					}else{
						phont.put("mode",Default.get("mode"));
					}
					if (!font.getChild("dimension").getAttributeValue("expr").isEmpty()){
						phont.put("dimension",font.getChild("dimension").getAttributeValue("expr"));
					}else{
						phont.put("dimension",Default.get("dimension"));
					}
					Res.put("panels",phont);
				}
			}
			for(Element font : fonts){
				if(font.getAttributeValue("id").equals("fields")){
					HashMap<String,String> phont = new HashMap<String,String>();
					if (!font.getChild("type").getAttributeValue("expr").isEmpty()){
						phont.put("type",font.getChild("type").getAttributeValue("expr"));
					}else{
						phont.put("type",Default.get("type"));
					}
					if (!font.getChild("mode").getAttributeValue("expr").isEmpty()){
						phont.put("mode", font.getChild("mode").getAttributeValue("expr"));
					}else{
						phont.put("mode",Default.get("mode"));
					}
					if (!font.getChild("dimension").getAttributeValue("expr").isEmpty()){
						phont.put("dimension",font.getChild("dimension").getAttributeValue("expr"));
					}else{
						phont.put("dimension",Default.get("dimension"));
					}
					Res.put("fields",phont);
				}
			}	
			return Res;
		}
		
		public HashMap<String,String> getDefaultFont(){
			String[] deff = new String[3]; //TYPE MODE DIM
			//Trova i parametri di default dei font
			Element Default = getChild("parameters").getChild("font_default");
			Iterator<Element> col = Default.getDescendants(new ElementFilter("dtype") );
			Element Col = col.next();
			String dtype=Col.getAttributeValue("expr");
					
			Iterator<Element> tol =Default.getDescendants(new ElementFilter("dmode") );
			Element Tol = tol.next();
			String dmode = Tol.getAttributeValue("expr");
					
			Iterator<Element> dim =Default.getDescendants(new ElementFilter("ddimension") );
			Element Dim = dim.next();
			String ddim = Dim.getAttributeValue("expr");
					
			HashMap<String,String> Ris = new HashMap<String,String>();
			Ris.put("type", dtype);
			Ris.put("mode", dmode);
			Ris.put("dimension", ddim);
			return Ris;
		}
		
		public void fillChildFont(){
			//Riempie figli dei font
			List<Element> lista = new CopyOnWriteArrayList<Element>(getChild("parameters").getChild("fonts").getChildren("font"));
			Iterator<Element> anElement = lista.iterator();
			while(anElement.hasNext()){
				Element currentElement = anElement.next();
				Iterator<Element> font_type_iterator = currentElement.getDescendants(new ElementFilter("type"));		
				if(!font_type_iterator.hasNext()){
					Element newT = new Element("type");
					newT.setAttribute("expr", "");
					currentElement.addContent(newT);
					}
				Iterator<Element> font_mode_iterator = currentElement.getDescendants(new ElementFilter("mode"));
				if(!font_mode_iterator.hasNext()){
					Element newM = new Element("mode");
					newM.setAttribute("expr", "");
					currentElement.addContent(newM);
					}
			Iterator<Element> font_dim_iterator = currentElement.getDescendants(new ElementFilter("dimension"));
			if(!font_dim_iterator.hasNext()){
				Element newD = new Element("dimension");
				newD.setAttribute("expr", "");
				currentElement.addContent(newD);
				}	
			}
		}
		
		public void fillFonts(){
			//CONTROLLA che nel file dei parametri non manchino Fonts e se mancano li inserisce 
			//I font devono essere 3 alla fine, uno per buttons uno per panels e uno per fields
			Boolean flagb,flagp,flagf;
			flagb=false;
			flagp=false;
			flagf=false;
			
			List<Element> fonts = getChild("parameters").getChild("fonts").getChildren("font");
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
				getChild("parameters").getChild("fonts").addContent(newF);
			}
			if(!flagp){
				Element newF = new Element("font");
				newF.setAttribute("id", "panels");
				getChild("parameters").getChild("fonts").addContent(newF);
			}
			if(!flagf){
				Element newF = new Element("font");
				newF.setAttribute("id", "fields");
				getChild("parameters").getChild("fonts").addContent(newF);
			}
		}
		
		public String writeFont(){
			HashMap<String,HashMap<String,String>> font = getFont();
			
			String result = "";
			result += "\tprivate Font buttfont = new Font( \"" + font.get("buttons").get("type") +
					"\", Font." + font.get("buttons").get("mode").toUpperCase() +
					", " + font.get("buttons").get("dimension") + ");";
			result += Conf.linesep;
			result += "\tprivate Font panelfont = new Font( \"" + font.get("panels").get("type") +
					"\", Font." + font.get("panels").get("mode").toUpperCase() +
					", " + font.get("panels").get("dimension") + ");";
			result += Conf.linesep;
			result += "\tprivate Font fieldfont = new Font( \"" + font.get("fields").get("type") +
					"\", Font." + font.get("fields").get("mode").toUpperCase() +
					", " + font.get("fields").get("dimension") + ");";
			result += Conf.linesep;
			return result;
		}
}



