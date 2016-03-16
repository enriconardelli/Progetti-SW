package framework;

import org.apache.commons.lang.ClassUtils;

public class Conf {
	public static final String filesep = System.getProperty("file.separator");
	public static final String linesep = System.getProperty("line.separator");
	public static final String classsep = System.getProperty ( "path.separator");
	public static final String packagesep = ClassUtils.PACKAGE_SEPARATOR;
	public static final String protocol = "file:";
	public static final String source_dir = "src";
	public static final String data_dir = "data";
	public static final String model_name = "model";
	public static final String scxml_extension = ".scxml";
	public static final String xml_conf_extension=".conf.xml";
	public static final String placeholder_for_code = "// here can be added code to specialize the behavior of this method";
	public static final String warning_for_initial_state = "// but CANNOT be added any code interacting with the GUI - delete manually this comment when changing the initial state!";
	public static final String endASMcurrentMethods = "// everything above this comment will be kept if this code is updated by ASMCodeCreator";

	public static final String button_font_key = "button_font";
	public static final String panel_font_key = "panel_font";
	public static final String field_font_key = "field_font";
				
	// configuration for default values of the User Interface
	public static final String default_frame_width = "500";
	public static final String default_frame_height = "800";
	public static final String default_button_color = "WHITE";
	public static final String default_panel_color = "WHITE";
	public static final String default_text_field_color = "WHITE";
	public static final String default_button_tooltip = "Event";
	public static final String default_panel_tooltip = "Variable";
	public static final String default_text_field_tooltip = "Numeric Variable";
	public static final String default_font_type = "TimesRoman";
	public static final String default_font_mode = "PLAIN";
	public static final String default_font_dimension = "16";
	
	// configuration for testing
	public static final String input_file_for_testing = "FilesToTest.txt";
	
}
