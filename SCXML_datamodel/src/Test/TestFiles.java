package Test;

import static org.junit.Assert.*;
import org.junit.Test;
import contatore.ImplASM;
import contatore.ImplGUI;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import framework.*;


public class TestFiles {
	
	public static String fileName = "contatore";
	public static String[] ASMmethods = {"initial_state", "standby", "raddoppiato", "transient_state", "final_state"};
	public static String[] GUIarrays = {"eventList", "eventColorValue", "eventTTValue", "panelList", "panelColorValue", "panelTTValue", "tFieldColorValue", "tFieldTTValue"};
	
	/*
	 * Checks if the generated ASM file contains the methods that reflects the events.
	 */
	@Test
	public void testASMmethods() {
		Method[] methods = ImplASM.class.getDeclaredMethods();
		ArrayList<String> methodNames = new ArrayList<String>(methods.length);
		for (int i=0; i<methods.length; i++){
			methodNames.add(methods[i].getName());
		}
		for (int i=0; i<ASMmethods.length; i++){
			assertTrue("Il metodo \"" + ASMmethods[i] + "\" non esiste!", methodNames.contains(ASMmethods[i]));
		}
	}
	
	/*
	 * Checks if the generated GUI file contains all the right arrays.
	 */
	@Test
	public void testGUIarrays() {
		Field[] fields = ImplGUI.class.getDeclaredFields();
		ArrayList<String> fieldNames = new ArrayList<String>(fields.length);
		for (int i=0; i<fields.length; i++){
			fieldNames.add(fields[i].getName());
		}
		for (int i=0; i<ASMmethods.length; i++){
			assertTrue("Il vettore \"" + GUIarrays[i] + "\" non esiste!", fieldNames.contains(GUIarrays[i]));
		}
	}

}
