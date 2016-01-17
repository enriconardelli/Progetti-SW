package Test;

import static org.junit.Assert.*;

import java.awt.Color;
import java.io.File;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import org.jdom.Element;
import org.jdom.JDOMException;
import org.junit.BeforeClass;
import org.junit.Test;

import contatore.ImplGUI;
import framework.Common;
import framework.Conf;

public class TestGUICreation {

	public static String fileName = "contatore";
	public static String[] fontArrays = {Conf.button_font_key, Conf.panel_font_key, Conf.field_font_key};
	public static List<String> events;
	public static List<String> variables;
	public static ArrayList<Field> fieldList;
	public static ArrayList<String> fieldNames;
	public static ImplGUI gui;


	@BeforeClass
	public static void importArrays(){
		File inputFile = new File(Conf.data_dir + Conf.filesep + fileName + Conf.scxml_extension);
		Element documentRoot = Common.getDocumentRoot(inputFile);
		try {
			events = Common.getEventNames(documentRoot);
			variables = Common.getVariableNames(documentRoot);
		} catch (JDOMException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		gui = new ImplGUI("test");
		fieldList = new ArrayList<Field>(Arrays.asList(ImplGUI.class.getDeclaredFields()));
		fieldNames = new ArrayList<String>(fieldList.size());
		for (Field f : fieldList){
			fieldNames.add(f.getName());
		}
	}

	/**
	 * Checks existence of the fonts arrays
	 */
	@Test
	public void testFontArrays() {
		for (int i=0; i<fontArrays.length; i++){
			assertTrue("Il vettore \"" + fontArrays[i] + "\" non esiste!", fieldNames.contains(fontArrays[i]));
		}
	}
	
	/**
	 * Checks if "eventList" contains all the events
	 */
	@Test
	public void testEventArrays() {
		List<String> eventList = null;
		List<Color> eventColor = null;
		List<String> eventTT = null;
		for(Field f : fieldList){
			if(f.getName() == "eventList"){
				f.setAccessible(true);
				try {
					eventList = new LinkedList<String>(Arrays.asList((String[]) f.get(gui)));
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			} else if(f.getName() == "eventColorValue"){
				f.setAccessible(true);
				try {
					eventColor = new LinkedList<Color>(Arrays.asList((Color[]) f.get(gui)));
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			} else if(f.getName() == "eventTTValue"){
				f.setAccessible(true);
				try {
					eventTT = new LinkedList<String>(Arrays.asList((String[]) f.get(gui)));
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			}
		}
		assertTrue("L'array \"eventList\" non ha gli eventi corretti!", compareLists(eventList, events));
		assertTrue("Gli array \"eventList\" e \"eventColor\" non hanno lo stesso numero di elementi!", eventList.size() == eventColor.size());
		assertTrue("Gli array \"eventList\" e \"eventTT\" non hanno lo stesso numero di elementi!", eventList.size() == eventTT.size());
	}
	
	/**
	 * Checks if "panelList" contains all the variables
	 */
	@Test
	public void testPanelArrays() {
		List<String> panelList = null;
		List<Color> panelColor = null;
		List<String> panelTT = null;
		List<Color> tFieldColor = null;
		List<String> tFieldTT = null;
		for(Field f : fieldList){
			if(f.getName() != null && f.getName() == "panelList"){
				f.setAccessible(true);

				try {
					panelList = Arrays.asList((String[]) f.get(gui));
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			} else if(f.getName() == "panelColorValue"){
				f.setAccessible(true);

				try {
					panelColor = new LinkedList<Color>(Arrays.asList((Color[]) f.get(gui)));
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			} else if(f.getName() == "panelTTValue"){
				f.setAccessible(true);

				try {
					panelTT = new LinkedList<String>(Arrays.asList((String[]) f.get(gui)));
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			} else if(f.getName() == "tFieldColorValue"){
				f.setAccessible(true);

				try {
					tFieldColor = new LinkedList<Color>(Arrays.asList((Color[]) f.get(gui)));
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			} else if(f.getName() == "tFieldTTValue"){
				f.setAccessible(true);

				try {
					tFieldTT = new LinkedList<String>(Arrays.asList((String[]) f.get(gui)));
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			}
		}
		assertTrue("L'array \"panelList\" non ha le variabili corrette!", compareLists(panelList, variables));
		assertTrue("Gli array \"panelList\" e \"panelColor\" non hanno lo stesso numero di elementi!", panelList.size() == panelColor.size());
		assertTrue("Gli array \"panelList\" e \"panelTT\" non hanno lo stesso numero di elementi!", panelList.size() == panelTT.size());
		assertTrue("Gli array \"panelList\" e \"tFieldColor\" non hanno lo stesso numero di elementi!", panelList.size() == tFieldColor.size());
		assertTrue("Gli array \"panelList\" e \"tFieldTT\" non hanno lo stesso numero di elementi!", panelList.size() == tFieldTT.size());
	}
	
	
	/**
	 * Compare two lists and check if they contains the same elements
	 * @param a
	 * @param b
	 * @return true if the lists contain the same elements
	 */
	public static boolean compareLists (List<?> a, List<?> b) {
		List list1 = new ArrayList(a);
		List list2 = new ArrayList(b);
		list1.removeAll(b);
		list2.removeAll(a);
		if (list1.isEmpty() && list2.isEmpty()){
			return true;
		}
		return false;
	}
}
