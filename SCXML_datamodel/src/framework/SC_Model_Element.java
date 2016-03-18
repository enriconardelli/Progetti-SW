package framework;

import java.io.File;
import org.jdom.Element;

public class SC_Model_Element extends Element {
	public SC_Model_Element(String file_name) {
		super(file_name);
	}

	private File inputFile;
	public File get_inputFile() {
		return inputFile;
	}

	private Element documentRoot;
	public Element get_documentRoot() {
		return documentRoot;
	}

	public void set_documentRoot() {
		inputFile = new File(Conf.data_dir + Conf.filesep + name + Conf.scxml_extension);
		// System.out.println("inputFile absolutePath: " + inputFile.getAbsolutePath());
		if (!inputFile.exists()) {
			System.err.println("ERROR: the file " + inputFile.getAbsolutePath() + " for the model " + name + " does not exist.");
			System.err.println("Generation for the model " + name + " is interrupted.");
			return;
		} else { // working on file
			System.out.println("Start generation of StateChart for model '" + name + "' specified in the file " + inputFile.getAbsolutePath());
			if (new File(Conf.source_dir + Conf.filesep + name).mkdir())
				System.out.println("First time for this StateChart, the package is created");
			else
				System.out.println("Modifying the existing package of the StateChart for model '" + name + "'");
			documentRoot = Common.getDocumentRoot(inputFile);
		}
	}

	public boolean syntax_OK() {
		return true;
	}
}