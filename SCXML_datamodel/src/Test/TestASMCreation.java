package Test;

import static org.junit.Assert.*;

import java.io.File;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.jdom.Element;
import org.jdom.JDOMException;
import org.junit.BeforeClass;
import org.junit.Test;

import contatore.ImplASM;
import framework.Common;
import framework.Conf;

public class TestASMCreation {
	
	public static String fileName = "contatore";
	public static List<String> states;
	
	@BeforeClass
	public static void importArrays(){
		File inputFile = new File(Conf.data_dir + Conf.filesep + fileName + Conf.scxml_extension);
		Element documentRoot = Common.getDocumentRoot(inputFile);
		try {
			states = Common.getStateNames(documentRoot);
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

}
