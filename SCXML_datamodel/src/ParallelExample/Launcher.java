/*
 * @generated
 */
package ParallelExample;

public class Launcher {
	public static void main(String[] args) throws Exception {
		ImplGUI gui = new ImplGUI("ParallelExample");
		ImplASM asm = new ImplASM("ParallelExample");
		gui.initialize(asm);
		asm.initialize(gui);
	}
}
