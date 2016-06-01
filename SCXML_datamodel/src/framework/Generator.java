package framework;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
import javax.tools.ToolProvider;
import javax.tools.JavaCompiler;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.filter.ElementFilter;

public class Generator {
	
	// To pass arguments in Eclipse: "Run Configurations...", "Arguments", "Program Arguments"
	public static void main(String[] args) throws Exception {
		// the current document must be created dynamically
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		// checking input file name(s)
		if (args.length <= 0) {
			System.err.println("No args! Give the NAME(s) of the file(s) NAME.scxml containing the StateChart specification(s)");
			return;
		}
		// checking existence of directory where generated source code of StateChart model(s) is stored
		if (!new File(Conf.source_dir).exists()) {
			System.out.println("Directory '" + Conf.source_dir + "' doesn't exist! It will be created.");
			if (!new File(Conf.source_dir).mkdir()) {
				Thread.sleep(100); // to avoid mixing printouts
				System.err.println("Directory '" + Conf.source_dir + "' can NOT be created!");
				System.err.println("The Generator is halted.");
				return;
			} else {
				System.out.println("Directory '" + Conf.source_dir + "' created.");
				System.out.println("The Generator will now continue reading SC model(s).\n");
			}
		}
		// generate and execute code for StateChart model(s), one at a time
		Scanner console = new Scanner (System.in);
		String read="";
		for (String SCXMLModel : args) {
			System.out.println("--BEGIN-- processing StateChart for model specified in file '" + Conf.data_dir + Conf.filesep + SCXMLModel
					+ Conf.scxml_extension + "'");
			SCXMLDocument.set_Model(SCXMLModel);
			SCXMLDocument.set_documentRoot();
			if (!(SCXMLDocument.SCXMLDocumentSyntaxOK())) {
				Thread.sleep(100); // to avoid mixing printouts
				System.err.println("Syntax error(s) in file " + SCXMLDocument.get_inputFile().getAbsolutePath());
				System.err.println("--ERROR-- The generation of this StateChart is interrupted.\n");
			} else {
				SCXMLDocument.stateChartGeneration(SCXMLModel);
				System.out.println("--FINISH-- generation of StateChart source code for model specified in file '" + Conf.data_dir + Conf.filesep
						+ SCXMLModel + Conf.scxml_extension + "'\n");
				System.out.println("PRESS <S> + <<Return>> to compile and execute NOW this StateChart, others to skip");
				if (console.hasNextLine())
					read = console.next();
				if (read.equals("S")) {
					compileSCfile(SCXMLModel, "ImplASM");
					compileSCfile(SCXMLModel, "ImplGUI");
					compileSCfile(SCXMLModel, "Launcher");
					SCXMLDocument.startSC();
				}
				// vorrei evitare che la nuova SC vada in esecuzione prima che finisca la precedente
				// in altre parole vorrei sospendere questo thread fino a che quello lanciato con .startSC() non sia terminato
				// ma questa soluzione non funziona
//				Thread startSC_thread = new Thread(SCXMLDocument);
//				startSC_thread.start();
//				startSC_thread.join();
			}
			Thread.sleep(100); // to avoid mixing printouts
			System.out.println("-- END -- processing StateChart for model specified in file '" + Conf.data_dir + Conf.filesep + SCXMLModel
					+ Conf.scxml_extension + "'\n");
			System.out.println("PRESS <C> + <<Return>> to continue with next SC, others to finish");
			if (console.hasNextLine())
				read = console.next();
			if (!read.equals("C"))
				break;
		}
		System.out.println("-- Generator has terminated --");
	
	}

	
	private static void compileSCfile(String pSCXMLModel, String pModelFileName) {
		String cmd = "C:\\Program Files\\Java\\jdk1.8.0_60\\bin\\javac";
		String cmd_EN = "javac";
		String cpSeparator = "";
		if (System.getProperty("os.name").startsWith("Mac OS") || System.getProperty("os.name").startsWith("Linux")) {
			cpSeparator = ":";
		} else
			if (System.getProperty("os.name").startsWith("Windows")) {
				cpSeparator = ";";
			} else {
				System.out.println(System.getProperty("os.name"));
				System.out.println("This Operating System is not managed\n");
				System.exit(1);
			}
		try {
			System.out.println("BEGIN compile " + pModelFileName + ".java to obtain " + pModelFileName + ".class for model '" + pSCXMLModel + "'");
			String destination = Conf.class_code_dir;
			String library = destination + cpSeparator + "External Libraries" + Conf.filesep + "commons-scxml-0.9" + Conf.filesep
					+ "commons-scxml-0.9.jar";
			String source = Conf.source_dir + Conf.filesep + pSCXMLModel + Conf.filesep + pModelFileName + ".java";
			// the following "Command Line" cannot be executed from command line as it is due to the space between "External" and "Libraries"
			// but using quoted "External Libraries" as argument to the compiler produces exit code 2 (EXIT_CMDERR = Bad command-line arguments)
			// System.out.println("Command Line ==> " + cmd + " -d " + destination + " -cp " + library + " " + source);
			// TODO: use JavaCompiler to run the compiler
			// JavaCompiler javac = ToolProvider.getSystemJavaCompiler();
			// int compilation_exit_code = javac.run (null, null, null, " -d " + destination + " -cp " + library + " " + source);
			Process aProcess = (new ProcessBuilder(cmd, "-d", destination, "-cp", library, source)).start();
			int exit_code = aProcess.waitFor();
			if (exit_code == 0)
				System.out.println("END compile ");
			else {
				Thread.sleep(100); // to avoid mixing printouts
				System.err.println("---ERROR--- compilation process returns exit code ==> " + exit_code);
				System.err.println("EXIT_ERROR = 1,     // Completed but reported errors.");
				System.err.println("EXIT_CMDERR = 2,    // Bad command-line arguments");
				System.err.println("EXIT_SYSERR = 3,    // System error or resource exhaustion.");
				System.err.println("EXIT_ABNORMAL = 4;  // Compiler terminated abnormally");
				System.err.println("The Generator is halted.");
				return;
			}
			// wait until the file system record the presence of the compiled class in bin
			File testFile = new File(destination + Conf.filesep + pSCXMLModel + Conf.filesep + pModelFileName + ".class");
			while (!testFile.exists()) {
				Thread.sleep(100); // waiting for file
			}
			// System.out.println("  found file " + testFile.getAbsolutePath());
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/*
	 * lasciato qua per comodità per le sperimentazioni relative alla sincronizzazione che non funziona
	 */
	private static void startSC(String pSCXMLModel) {
		try {
			System.out.println("Invoking the Launcher for the model specified in file '" + Conf.data_dir + Conf.filesep + pSCXMLModel
					+ Conf.scxml_extension + "'");
			Class<?> classe = Class.forName(pSCXMLModel + Conf.packagesep + "Launcher");
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