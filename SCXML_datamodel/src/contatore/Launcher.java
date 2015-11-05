/*
 * @generated
 */
package contatore;

public class Launcher {
	public static void main(String[] args) throws Exception {
		ImplGUI gui = new ImplGUI("contatore");
		ImplASM asm = new ImplASM("contatore");
		gui.initialize(asm);
		asm.initialize(gui);
	}
}
