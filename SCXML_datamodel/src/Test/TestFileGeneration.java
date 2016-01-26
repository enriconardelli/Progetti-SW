package Test;

import static org.junit.Assert.*;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import framework.*;

@RunWith(Parameterized.class)
public class TestFileGeneration {

	public static String fileName;

	public TestFileGeneration(String fileToTest) {
		fileName = fileToTest;
	}

	@Before
	public void fileGeneration() {
		System.out.println("Testing file : \'" + fileName + Conf.scxml_extension + "\'");
		String[] arg = {fileName};
		try {
			Generator.main(arg);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
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

	@Parameterized.Parameters
	public static Collection<String[]> filesToTest() {
		File inputFile = new File(Conf.data_dir + Conf.filesep + "FilesToTest.txt");
		ArrayList<String[]> input = Common.read(inputFile);
		return input;
	}
}