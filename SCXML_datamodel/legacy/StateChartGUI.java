package legacy;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JTextArea;

import org.apache.commons.scxml.TriggerEvent;
import org.apache.commons.scxml.model.ModelException;

import core.AbstractASM;

public abstract class StateChartGUI implements ActionListener {
	
	protected AbstractASM myASM;
	
	public void setMyASM(AbstractASM pMyASM){
		myASM=pMyASM;
	}
	
	protected JTextArea statechartTrace;

	public void statechartTraceAppend(String pString) {
		statechartTrace.append(pString);
	}
	
	@Override
	public void actionPerformed(ActionEvent pActionEvent) {
		String anEvent = pActionEvent.getActionCommand();
		statechartTrace.append("\n" + anEvent.toString() + " LAUNCHed ");
		TriggerEvent aTriggerEvent = new TriggerEvent(anEvent, TriggerEvent.SIGNAL_EVENT, myASM);
		try {
			myASM.getEngine().triggerEvent(aTriggerEvent);
		} catch (ModelException me) {
			System.out.println(me.getMessage());
		}
	}
	
	public abstract void variablesDisplayUpdate();

}
