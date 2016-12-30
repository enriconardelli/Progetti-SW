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
	// checks that for the model(s) whose name(s) are in Conf.input_file_for_testing
	// the Generator is able to create the files ImplASM.java, ImplGUI.java, Launcher.java,
	// model.scxml in the proper package

	public static String fileName;

	public TestFileGeneration(String fileToTest) {
		fileName = fileToTest;
	}


	/*
	 * Comment @Before if Generator has been already invoked and files have been created
	 * Use @Before to launch Generator to create the files before the test.
	 */
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
	public static Collection<String> filesToTest() {
		File inputFile = new File(Conf.data_dir + Conf.filesep + Conf.input_file_for_testing);
		ArrayList<String> input = Common.read(inputFile);
		return input;
	}
}