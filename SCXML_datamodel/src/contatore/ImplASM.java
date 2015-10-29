/*
 * @generated
 */
package contatore;

import java.net.MalformedURLException;
import java.net.URL;
import core.AbstractASM;
import framework.Conf;
public class ImplASM extends AbstractASM{

	public ImplASM(String aSCName) throws MalformedURLException {
		super(new URL(Conf.protocol + Conf.source_dir + Conf.filesep + aSCName + Conf.filesep + Conf.model_name + Conf.scxml_extension));
	}

	public void initial_state() {
	// here can be added code to specialize the behavior of this method
	// but CANNOT be added any code interacting with the GUI - delete manually this comment when changing the initial state!
	}

	public void standby() {
	// here can be added code to specialize the behavior of this method
	}

	public void raddoppiato() {
	// here can be added code to specialize the behavior of this method
	}

	public void transient_state() {
	// here can be added code to specialize the behavior of this method
	}

	public void final_state() {
	// here can be added code to specialize the behavior of this method
	}

// everything above this comment will be kept if this code is updated by ASMCodeCreator
}
