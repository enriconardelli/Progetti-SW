package core;

import java.net.MalformedURLException;
import java.net.URL;

import org.apache.commons.scxml.env.AbstractStateMachine;
import org.apache.commons.scxml.env.jsp.ELContext;
import org.apache.commons.scxml.env.jsp.ELEvaluator;

public abstract class AbstractASM extends AbstractStateMachine {
	protected AbstractGUI myGUI;

	public AbstractASM(URL pURL, ELContext pELContext, ELEvaluator pELEvaluator) throws MalformedURLException {
		super(pURL, pELContext, pELEvaluator);
	}

	public AbstractASM(URL pURL) {
		super(pURL, new ELContext(), new ELEvaluator());
	}

	public void initialize(AbstractGUI pMyGUI) {
		myGUI = pMyGUI;
	}
	
	public Object get_value(String pDataID) {
		return getEngine().getRootContext().get(pDataID);
	}

	public void set_value(String pDataID, int pValue) {
		getEngine().getRootContext().set(pDataID, pValue);
	}
}
