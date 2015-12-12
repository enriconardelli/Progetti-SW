package Test;

import static org.junit.Assert.*;

import java.io.File;

import org.junit.BeforeClass;
import org.junit.Test;

import framework.*;


public class TestFileGeneration {

	public static String fileName = "contatore";

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
}