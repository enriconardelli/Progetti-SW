package framework;

public class Conf {
	public static final String filesep = System.getProperty("file.separator");
	public static final String linesep = System.getProperty("line.separator");
	public static final String protocol = "file:";
	public static final String source_dir = "src";
	public static final String data_dir = "data";
	//public static final String param_dir = "xml_conf";
	public static final String model_name = "model";
	public static final String scxml_extension = ".scxml";
	public static final String xml_conf_extension=".conf.xml";
	public static final String placeholder_for_code = "// here can be added code to specialize the behavior of this method";
	public static final String warning_for_initial_state = "// but CANNOT be added any code interacting with the GUI - delete manually this comment when changing the initial state!";
	public static final String endASMcurrentMethods = "// everything above this comment will be kept if this code is updated by ASMCodeCreator";
}
