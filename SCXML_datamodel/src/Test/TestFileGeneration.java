package Test;

import static org.junit.Assert.*;
import org.junit.BeforeClass;
import org.junit.Test;

import contatore.ImplASM;

import java.io.File;
import java.lang.reflect.Method;
import java.util.ArrayList;

import framework.*;


public class TestFileGeneration {
	
	public static String fileName = "contatore";
	public static String[] ASMmethods = {"initial_state", "standby", "raddoppiato", "transient_state", "final_state"};
	
	@BeforeClass
	public static void fileGeneration() throws Exception {
		String[] arg = {fileName};
		Generator.main(arg);
	}
	
	/*
	 * Tests if the Generator created all the correct files.
	 */
	@Test
	public void testFileExistence() {
		File ASM = new File(Conf.source_dir + Conf.filesep + fileName + Conf.filesep + "ImplASM.java");
		assertTrue("Il file " + ASM.getName() + " non esiste!", ASM.exists());
		
		File GUI = new File(Conf.source_dir + Conf.filesep + fileName + Conf.filesep + "ImplGUI.java");
		assertTrue("Il file " + GUI.getName() + " non esiste!", GUI.exists());
		
		File launcher = new File(Conf.source_dir + Conf.filesep + fileName + Conf.filesep + "Launcher.java");
		assertTrue("Il file " + launcher.getName() + " non esiste!", launcher.exists());
		
		File model = new File(Conf.source_dir + Conf.filesep + fileName + Conf.filesep + "model" + Conf.scxml_extension);
		assertTrue("Il file " + model.getName() + " non esiste!", model.exists());
	}
	
	@Test
	public void testMethods() {
		Method[] methods = ImplASM.class.getMethods();
		ArrayList<String> methodNames = new ArrayList<String>(methods.length);
		for (int i=0; i<methods.length; i++){
			methodNames.add(methods[i].getName());
		}
		for (int i=0; i<ASMmethods.length; i++){
			assertTrue("Il metodo \"" + ASMmethods[i] + "\" non esiste!", methodNames.contains(ASMmethods[i]));
		}
	}

}
