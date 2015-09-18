/*
 * @generated
 */
package stopwatch;

public class Launcher {
	public static void main(String[] args) throws Exception {
		ImplGUI gui = new ImplGUI("stopwatch");
		ImplASM asm = new ImplASM("stopwatch");
		gui.initialize(asm);
		asm.initialize(gui);
	}
}
