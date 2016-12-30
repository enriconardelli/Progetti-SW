package Test;

import static org.junit.Assert.*;

import java.io.File;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.jdom.Element;
import org.jdom.JDOMException;
import org.junit.Before;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import framework.Common;
import framework.Conf;

@RunWith(Parameterized.class)
public class TestASMCreation {
	// for each model(s) whose name(s) are in Conf.input_file_for_testing
	//   assumes that ImplASM.java exists in the proper package
	//   checks that it has a method for each state declared in model.scxml

	public static String fileName;
	public static List<String> states;
	public static Class<?> ASM;

	public TestASMCreation(String fileToTest) {
		fileName = fileToTest;
	}

	@Before
	public void importArrays(){
		try {
			ASM = Class.forName(fileName + ".ImplASM");
		} catch (ClassNotFoundException e1) {
			System.err.println("ERRORE: non esiste la classe compilata ImplASM per il model " + fileName);
			System.out.println("\n  è necessario eseguire il Generatore oppure lanciare il test 'TestFileGeneration' su questo model");
			System.exit(1);
			// TODO Auto-generated catch block
//			e1.printStackTrace();
		}
		//System.out.println("Testing: " + ASM.getPath());
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
		ArrayList<Method> methodList = new ArrayList<Method>(Arrays.asList(ASM.getDeclaredMethods()));
		ArrayList<String> methodNames = new ArrayList<String>(methodList.size());
		for (Method m : methodList){
			methodNames.add(m.getName());
		}
		for (String s : states){
			assertTrue("Il metodo \"" + s + "\" per \'" + fileName + "\' non esiste!", methodNames.contains(s));
		}
	}

	@Parameterized.Parameters
	public static Collection<String> filesToTest() {
		File inputFile = new File(Conf.data_dir + Conf.filesep + Conf.input_file_for_testing);
		ArrayList<String> input = Common.read(inputFile);
		return input;
	}
}
