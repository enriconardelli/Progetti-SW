package legacy;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

import org.jdom.JDOMException;

import core.AbstractASM;

public class StateChartAPPL {

//	static private AbstractASM theStateChartASM;

//	// the value is needed in the GUI
//	public AbstractASM getStateChartASM() {
//		return aStateChartASM;
//	}

	public StateChartAPPL() {}

	public void startSC(String SCName) throws InstantiationException, IllegalAccessException, ClassNotFoundException,
			JDOMException, IOException, InterruptedException, SecurityException, NoSuchMethodException, IllegalArgumentException,
			InvocationTargetException {

		// TODO capire se si puo' fare a meno per Windows di cambiare la variabile PATH dell'ambiente oppure di fornire il
		// path assoluto della directory che contiene il compilatore java
		String cmd = "";
		String cpSeparator = "";
		if (System.getProperty("os.name").startsWith("Mac OS") || System.getProperty("os.name").startsWith("Linux")) {
			cmd = "javac";
			cpSeparator = ":";
		} else
			if (System.getProperty("os.name").startsWith("Windows")) {
				cmd = "D:\\Java\\jdk1.6.0_27\\bin\\javac";
				cpSeparator = ";";
			} else {
				System.out.println(System.getProperty("os.name"));
				System.out.println("This Operating System is not managed\n");
				System.exit(1);
			}
		String destination = "";
		String library = "";
		String source = "";
		ProcessBuilder aProcessBuilder = null;

		// ////////////////////////////////////////////////////////////////////////////////
		//
		System.out.println("START generate " + SCName + "ASM.java from " + SCName + ".scxml");
		RunTimeASMCustomClassCodeCreator.create(SCName);
		// System.out.println("END generate " + SCName + "ASM.java from " + SCName + ".scxml\n");

		//
		// System.out.println("START compile " + SCName + "ASM.java to obtain " + SCName + "ASM.class");
		destination = "bin";
		library = destination + cpSeparator + "External Libraries" + File.separator + "commons-scxml-0.9" + File.separator
				+ "commons-scxml-0.9.jar" + cpSeparator + "StateChartLauncher.jar";
		source = "support" + File.separator + SCName + "ASM.java";
		aProcessBuilder = new ProcessBuilder(cmd, "-d", destination, "-cp", library, source);
		Process process = aProcessBuilder.start();
		process.waitFor();
		// System.out.println("END compile " + SCName + "ASM.java to obtain " + SCName + "ASM.class\n");

		Class<?> theASMclassName = Class.forName("core." + SCName + "ASM");
		Class<?>[] theASMConstructorArgument = { String.class };
		Constructor<?> theASMclassStringConstructor = theASMclassName.getDeclaredConstructor(theASMConstructorArgument);
		AbstractASM theStateChartASM = (AbstractASM) theASMclassStringConstructor.newInstance(SCName);
		// System.out.println("  created the instance of " + theStateChartASM.getClass().getName());
		//((AbstractASM) theStateChartASM).init();
		// System.out.println("  initialized the instance");
		System.out.println("END create the AbstractStateMachine instance of " + SCName + "\n");

		// ////////////////////////////////////////////////////////////////////////////////
		//
		System.out.println("START generate " + SCName + "GUI.java from " + SCName + ".scxml");
		RunTimeGUIClassCodeCreator.create(SCName);
		// System.out.println("END generate " + SCName + "GUI.java from " + SCName + ".scxml\n");

		//
		// System.out.println("START compile " + SCName + "GUI.java to obtain " + SCName + "GUI.class");
		destination = "bin";
		library = destination + cpSeparator + "External Libraries" + File.separator + "commons-scxml-0.9" + File.separator
				+ "commons-scxml-0.9.jar" + cpSeparator + "StateChartLauncher.jar";
		source = "support" + File.separator + SCName + "GUI.java";
		aProcessBuilder = new ProcessBuilder(cmd, "-d", destination, "-cp", library, source);
		process = aProcessBuilder.start();
		process.waitFor();
		// System.out.println("END compile " + SCName + "GUI.java to obtain " + SCName + "GUI.class\n");

		//
//		System.out.println("START starts the GUI for " + SCName	+ " application, and the GUI will access the AbstractStateMachine instance");
		// wait until the file system record the presence of the compiled class in bin
//		while (!(new File("bin" + File.separator + "core" + File.separator + SCName + "GUI.class")).exists()) {
//			Thread.sleep(100);
//		}
		// System.out.println("  found  bin" + File.separator + "core" + File.separator + SCName + "GUI.class");
		Class<?> theGUIclassName = Class.forName("core." + SCName + "GUI");
		Class<?>[] theGUIConstructorArgument = { String.class };
		Constructor<?> theGUIclassStringConstructor = theGUIclassName.getDeclaredConstructor(theGUIConstructorArgument);
		StateChartGUI theGUI = (StateChartGUI) theGUIclassStringConstructor.newInstance(SCName);
		// System.out.println("  created the instance of " + theGUI.getClass().getName());
//		myGUI.setMyStateChartAPPL(this);
		System.out.println("END starts the GUI for " + SCName + " application\n");

		//
//		System.out.println("INJECTS the GUI dependency into the ASM and viceversa");
		theGUI.setMyASM(theStateChartASM);
		theStateChartASM.setMyGUI(theGUI);
//		System.out.println("INJECTED the GUI dependency into the ASM and viceversa");

		//
		System.out.println("START remove " + SCName + "ASM.java and " + SCName + "ASM.class and " + SCName + "GUI.java and "
				+ SCName + "GUI.class");
		System.out.println("PRESS <E> + <<return>> to terminate without removing files");
		char read = (char) System.in.read();
		if (read == 'E') {
			System.exit(0);
		}
		File aFile = new File("");
		aFile = new File("support" + File.separator + SCName + "ASM.java");
		if (aFile.exists()) {
			aFile.delete();
			System.out.println("File " + aFile.getAbsolutePath() + " deleted");
		}
		aFile = new File("bin" + File.separator + "core" + File.separator + SCName + "ASM.class");
		if (aFile.exists()) {
			aFile.delete();
			System.out.println("File " + aFile.getAbsolutePath() + " deleted");
		}
		aFile = new File("support" + File.separator + SCName + "GUI.java");
		if (aFile.exists()) {
			aFile.delete();
			System.out.println("File " + aFile.getAbsolutePath() + " deleted");
		}
		aFile = new File("bin" + File.separator + "core" + File.separator + SCName + "GUI.class");
		if (aFile.exists()) {
			aFile.delete();
			System.out.println("File " + aFile.getAbsolutePath() + " deleted");
		}
		System.out.println("END remove " + SCName + "ASM.java and " + SCName + "ASM.class and " + SCName + "GUI.java and "
				+ SCName + "GUI.class");

	}
}