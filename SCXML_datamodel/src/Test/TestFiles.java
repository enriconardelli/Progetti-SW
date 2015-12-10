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
	public static List<String> states;
	public static String[] fontArrays = {"buttfont", "panelfont", "fieldfont"};
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
	
	/*
	 * Checks if the generated ASM file contains the methods that reflects the events.
	 */
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
	
	/*
	 * Checks if the generated GUI file contains all the right arrays.
	 */
	@Test
	public void testGUIarrays() {
		List<String> v = null;
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
		for(Field f : fieldList){
		        if(f.getName() != null && f.getName() == "eventList"){
		        	f.setAccessible(true);
		        	try {
						v = new LinkedList<String>(Arrays.asList((String[]) f.get(gui)));
					} catch (IllegalArgumentException | IllegalAccessException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
		        	break;
		        }
		 }
		 assertTrue("L'array \"eventColorValue\" non ha gli eventi corretti!", compareLists(v, events));
		 
		 v.clear();
		 
		 /*Checks if "panelList" contains all the variables*/
		 for(Field f : fieldList){
		        if(f.getName() != null && f.getName() == "panelList"){
		        	f.setAccessible(true);
		        	try {
						v = Arrays.asList((String[]) f.get(gui));
					} catch (IllegalArgumentException | IllegalAccessException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
		        	break;
		        }
		 }
		 assertTrue("L'array \"panelList\" non ha le variabili corrette!", compareLists(v, variables));
	}
	
	/**
	 * Compare two lists and check if they contains the same elements
	 * @param a
	 * @param b
	 * @return true if the lists are equal
	 */
	public boolean compareLists (List<?> a, List<?> b) {
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
