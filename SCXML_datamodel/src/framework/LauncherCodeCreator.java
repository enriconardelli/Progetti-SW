package framework;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import org.jdom.JDOMException;

public class LauncherCodeCreator {
	private LauncherCodeCreator() {
		// with a private constructor instances of this class cannot be created,
		// which is what we want since the actual generation of code is made
		// through a class method
	}

	public static void create(String pSCName) throws JDOMException, IOException {
		File file = new File(Conf.source_dir + Conf.filesep + pSCName + Conf.filesep + "Launcher.java");
		if (!file.exists()) {
			String classContent = writePreambleAndClass(pSCName);
			// a BufferedWriter is not needed since the class content is written all at once
			// use a FileOutputStream so as to force the explicit synchronization with file system
			FileOutputStream fos = new FileOutputStream (Conf.source_dir + Conf.filesep + pSCName + Conf.filesep + "Launcher.java");
			FileWriter out = new FileWriter(fos.getFD());
			out.write(classContent);
			fos.getFD().sync();
			out.close();
			fos.close();
		}
	}

	public static String writePreambleAndClass(String pSCName) throws IOException {
		String result = "";
		result += "/*" + Conf.linesep;
		result += " * @generated" + Conf.linesep;
		result += " */" + Conf.linesep;
		result += "package " + pSCName + ";" + Conf.linesep + Conf.linesep;
		result += "public class Launcher {" + Conf.linesep;
		result += "\tpublic static void main(String[] args) throws Exception {" + Conf.linesep;
		result += "\t\tImplGUI gui = new ImplGUI(\"" + pSCName + "\");" + Conf.linesep;
		result += "\t\tImplASM asm = new ImplASM(\"" + pSCName + "\");" + Conf.linesep;
		result += "\t\tgui.initialize(asm);" + Conf.linesep;
		result += "\t\tasm.initialize(gui);" + Conf.linesep;
		result += "\t}" + Conf.linesep;
		result += "}" + Conf.linesep;
		return result;
	}
}
