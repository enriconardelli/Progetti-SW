package framework;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import org.jdom.Element;

public class SC_Model_Element extends Element implements Runnable {
	public SC_Model_Element() {
		super();
	}

	public SC_Model_Element(String model_name) {
		super(model_name);
	}

	private File inputFile;

	public File get_inputFile() {
		return inputFile;
	}

	private Element documentRoot;

	public Element get_documentRoot() {
		return documentRoot;
	}

	public void set_documentRoot() throws InterruptedException {
		inputFile = new File(Conf.data_dir + Conf.filesep + name + Conf.scxml_extension);
		if (!inputFile.exists()) {
			Thread.sleep(100); // to avoid mixing printouts
			System.err.println("ERROR: the file " + inputFile.getAbsolutePath() + " for the model " + name + " does not exist.");
			System.err.println("Generation for the model " + name + " is interrupted.");
			return;
		} else { // working on file for current model
			System.out.println("--START-- generation of StateChart source code for model '" + name + "' specified in the file "
					+ inputFile.getAbsolutePath());
			if (!new File(Conf.source_dir + Conf.filesep + name).exists()) {
				System.out.println("First time for this StateChart, the package is created");
				if (!new File(Conf.source_dir + Conf.filesep + name).mkdir()) {
					Thread.sleep(100); // to avoid mixing printouts
					System.err.println("Directory '" + Conf.source_dir + Conf.filesep + name + "' can NOT be created!");
					System.err.println("The Generator is halted.");
					System.exit(0);
				} else
					System.out.println("Directory '" + Conf.source_dir + Conf.filesep + name
							+ "' created. Program will continue generating the StateChart code ");
			} else
				System.out.println("Modifying the existing package of the StateChart for model '" + name + "'");
			documentRoot = Common.getDocumentRoot(inputFile);
		}
	}

	public void run() {
		startSC();
	}

	public synchronized void startSC() {
		System.out.println("Invoking the Launcher for the model specified in file '" + Conf.data_dir 
				+ Conf.filesep + name + Conf.scxml_extension + "'");
		try {
			Class<?> classe = Class.forName(name + Conf.packagesep + "Launcher");
			// System.out.println("classe.getName() = " + classe.getName());
			Object istanza_classe = classe.newInstance();
			// System.out.println("istanza_classe.getName() = " + istanza_classe.toString());
			Method metodo = classe.getMethod("main", String[].class);
			// System.out.println("metodo.getName() = " + metodo.getName());
			Object args = new String[0]; // args deve essere Object e questo main non ha parametri di ingresso
			// System.out.println("args = " + args.toString());
			metodo.invoke(istanza_classe, args);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
