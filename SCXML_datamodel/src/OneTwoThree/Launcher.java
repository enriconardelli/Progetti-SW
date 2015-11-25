/*
 * @generated
 */
package OneTwoThree;

public class Launcher {
	public static void main(String[] args) throws Exception {
		ImplGUI gui = new ImplGUI("OneTwoThree");
		ImplASM asm = new ImplASM("OneTwoThree");
		gui.initialize(asm);
		asm.initialize(gui);
	}
}
