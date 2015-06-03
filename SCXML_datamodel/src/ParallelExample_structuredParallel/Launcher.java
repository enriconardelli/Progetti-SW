/*
 * @generated
 */
package ParallelExample_structuredParallel;

public class Launcher {
	public static void main(String[] args) throws Exception {
		ImplGUI gui = new ImplGUI("ParallelExample_structuredParallel");
		ImplASM asm = new ImplASM("ParallelExample_structuredParallel");
		gui.initialize(asm);
		asm.initialize(gui);
	}
}
