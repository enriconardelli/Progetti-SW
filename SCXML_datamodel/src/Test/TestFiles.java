package Test;

import static org.junit.Assert.*;

import org.jdom.Element;
import org.jdom.JDOMException;
import org.junit.*;
import contatore.ImplASM;
import contatore.ImplGUI;

import java.awt.Color;
import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import framework.*;


public class TestFiles {

	public static String fileName = "contatore";
	public static String[] fontArrays = {Conf.button_font_key, Conf.panel_font_key, Conf.field_font_key};
	public static List<String> states;
	public static List<String> events;
	public static List<String> variables;


	@BeforeClass
	public static void importArrays(){
		File inputFile = new File(Conf.data_dir + Conf.filesep + fileName + Conf.scxml_extension);
		Element documentRoot = Common.getDocumentRoot(inputFile);
		try {
			states = Common.getStateNames(documentRoot);
			events = Common.getEventNames(documentRoot);
			variables = Common.getVariableNames(documentRoot);
		} catch (JDOMException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * Checks if the generated ASM file contains the methods corresponding to the states.
	 **/
	@Test
	public void testASMmethods() {

		ArrayList<Method> methodList = new ArrayList<Method>(Arrays.asList(ImplASM.class.getDeclaredMethods()));
		ArrayList<String> methodNames = new ArrayList<String>(methodList.size());
		for (Method m : methodList){
			methodNames.add(m.getName());
		}
		for (String s : states){
			assertTrue("Il metodo \"" + s + "\" non esiste!", methodNames.contains(s));
		}
	}


	/**
	 * Checks if the generated GUI file contains all the right arrays.
	 **/
	@Test
	public void testGUIarrays() {
		ImplGUI gui = new ImplGUI("test");
		ArrayList<Field> fieldList = new ArrayList<Field>(Arrays.asList(ImplGUI.class.getDeclaredFields()));
		ArrayList<String> fieldNames = new ArrayList<String>(fieldList.size());
		for (Field f : fieldList){
			fieldNames.add(f.getName());
		}

		//Checks existence of the fonts arrays
		for (int i=0; i<fontArrays.length; i++){
			assertTrue("Il vettore \"" + fontArrays[i] + "\" non esiste!", fieldNames.contains(fontArrays[i]));
		}

		/*Checks if "eventList" contains all the events*/
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
		
		/*Checks if "panelList" contains all the variables*/
		List<String> panelList = null;
		List<Color> panelColor = null;
		List<String> panelTT = null;
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

			}
		}
		assertTrue("L'array \"panelList\" non ha le variabili corrette!", compareLists(panelList, variables));
		assertTrue("Gli array \"panelList\" e \"panelColor\" non hanno lo stesso numero di elementi!", panelList.size() == panelColor.size());
		assertTrue("Gli array \"panelList\" e \"panelTT\" non hanno lo stesso numero di elementi!", panelList.size() == panelTT.size());
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
