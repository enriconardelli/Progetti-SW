/*
 * @generated
 */
package ParallelExampleWithLogs;

public class Launcher {
	public static void main(String[] args) throws Exception {
		ImplGUI gui = new ImplGUI("ParallelExampleWithLogs");
		ImplASM asm = new ImplASM("ParallelExampleWithLogs");
		gui.initialize(asm);
		asm.initialize(gui);
	}
}
