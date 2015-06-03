/*
 * @generated
 */
package ParallelExampleWithHierarchyAndLogs;

public class Launcher {
	public static void main(String[] args) throws Exception {
		ImplGUI gui = new ImplGUI("ParallelExampleWithHierarchyAndLogs");
		ImplASM asm = new ImplASM("ParallelExampleWithHierarchyAndLogs");
		gui.initialize(asm);
		asm.initialize(gui);
	}
}
