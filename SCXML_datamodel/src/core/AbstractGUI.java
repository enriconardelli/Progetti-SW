package core;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;
import java.util.Set;
import javax.swing.JButton;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import org.apache.commons.scxml.SCXMLListener;
import org.apache.commons.scxml.TriggerEvent;
import org.apache.commons.scxml.model.Action;
import org.apache.commons.scxml.model.Assign;
import org.apache.commons.scxml.model.ModelException;
import org.apache.commons.scxml.model.Transition;
import org.apache.commons.scxml.model.TransitionTarget;
import org.jdom.filter.ElementFilter;

public abstract class AbstractGUI implements ActionListener, SCXMLListener {
	protected AbstractASM myASM;
	protected JTextArea statechartTrace;
	/* variableFields stores the correspondence between variables in the datamodel
	 * and JTextFields in the GUI used to show variables' values
	 * Entries in variableFields, that is which JTextField is associated to which variable, are written during GUI instantiation */
	protected HashMap<String, JTextField> variableFields = new HashMap<String, JTextField>();
	/* eventButtons stores the correspondence between events in the statechart
	 * and JButtons in the GUI used to launch events
	 * Entries in eventButtons, that is which JButton launches which event, are written during GUI instantiation */
	protected HashMap<String, JButton> eventButtons = new HashMap<String, JButton>();

	private void disableAllJButtons() {
		for (Entry<String, JButton> entry : eventButtons.entrySet())
			entry.getValue().setEnabled(false);
	}

	private void enableButtonsForTransitionsOf(TransitionTarget pState) {
		/* enable only buttons existing in eventButtons for a transition
		 * TODO: implement checking the cast from List to List<Transition> */
		for (Transition aTransition : (List<Transition>) pState.getTransitionsList()) {
			JButton buttonForTransitionEvent = eventButtons.get(aTransition.getEvent());
			if (buttonForTransitionEvent != null) buttonForTransitionEvent.setEnabled(true);
			/* test needed since a transition without an event has no associated button */
		}
	}

	public void initialize(AbstractASM pMyASM) {
		myASM = pMyASM;
		myASM.getEngine().addListener(myASM.getEngine().getStateMachine(), this);
		/* Here we assign to each JTextField the value, held in the datamodel, of the corresponding variable */
		for (Entry<String, JTextField> entry : variableFields.entrySet()) {
			String currentVariableName = entry.getKey();
			String currentVariableValue = (String) myASM.getEngine().getRootContext().get(currentVariableName);
			JTextField currentField = entry.getValue();
			currentField.setText(currentVariableValue);
		}
		disableAllJButtons();
		/* write the initial state(s) in the trace textfield and enable the JButtons of their transitions
		 * TODO: implement checking the cast from Set to Set<TransitionTarget> */
		for (TransitionTarget state : (Set<TransitionTarget>) myASM.getEngine().getCurrentStatus().getAllStates()) {
			statechartTraceAppend("Initial state: " + state.getId() + "\n");
			enableButtonsForTransitionsOf(state);
		}
	}

	public void statechartTraceAppend(String pString) {
		statechartTrace.append(pString);
	}
	
	@Override
	public void actionPerformed(ActionEvent pActionEvent) {
		String returnedValue = pActionEvent.getActionCommand();
		/* if returnedValue is a key in variableFields then the field returnedValue of the GUI has been updated */
		if (variableFields.containsKey(returnedValue)) {
		/*int flag = 0;	
		while(flag == 0){
			flag=1;
			System.out.println("hai sbagliato?");
			try {
				myASM.set_value(returnedValue, Integer.parseInt(variableFields.get(returnedValue).getText()));
				System.out.println("hai sbagliato??");
			} catch (NumberFormatException me) {
				System.out.println("hai sbagliato");
				flag=0;
			}
		}*/
			if(variableFields.get(returnedValue).getText().equals("")){
				myASM.set_value(returnedValue, 0);
			}else{
				myASM.set_value(returnedValue, Integer.parseInt(variableFields.get(returnedValue).getText()));
			}
			statechartTraceAppend("\nField: " + returnedValue + " UPDATED\n");
			returnedValue = "fictitious_event_passed_to_the_engine_to_re-evaluate_conditions";
			/* the only way to have the engine check again conditions - which may be changed as a result
			 * of updating the field - is to send it an event */
		} else {
			statechartTraceAppend("\nEvent: " + returnedValue + " LAUNCHED\n");
		}
		TriggerEvent aTriggerEvent = new TriggerEvent(returnedValue, TriggerEvent.SIGNAL_EVENT, myASM);
		try {
			myASM.getEngine().triggerEvent(aTriggerEvent);
		} catch (ModelException me) {
			System.out.println(me.getMessage());
		}
	}

	@Override
	public void onTransition(final TransitionTarget fromState, final TransitionTarget toState, final Transition aTransition) {
		/* update each JTextField in the GUI with the value, held in the datamodel, of the corresponding variable
		 * TODO: implement explicit cast from List to List<TransitionTarget> */
		
		List<Action> actionList = aTransition.getActions();
		ArrayList<Assign> assignList = new ArrayList<Assign>();
		for (Action a : actionList){
			if(a.getClass().toString().equals("class org.apache.commons.scxml.model.Assign")){
				assignList.add((Assign)a);
			}
		}
		for (Assign anAssign : assignList) {
			String aVariableName = anAssign.getName();
			// at run time the value returned from the engine is a Long (which cannot be cast to String)
			// but at compile time it is just an Object, hence the need of declaring a cast to Long and using conversion
			String aVariableValue;
			if(myASM.getEngine().getRootContext().get(aVariableName).getClass().toString().equals("class java.lang.String")){
				aVariableValue = (String)myASM.getEngine().getRootContext().get(aVariableName);
			}else{
				aVariableValue = Long.toString((Long)myASM.getEngine().getRootContext().get(aVariableName));
			}
			variableFields.get(aVariableName).setText(aVariableValue);
		}
		statechartTraceAppend("Transition from state: " + fromState.getId() + " to state: " + toState.getId() + "\n");
		/* enable JButtons for all transitions in those states in the current configuration without the fromStates and plus the toStates
		 * TODO: implement explicit cast from Set to Set<TransitionTarget>
		Set<TransitionTarget> relevantStates = myASM.getEngine().getCurrentStatus().getAllStates();
		relevantStates.remove(fromState);
		relevantStates.add(toState);
		for (TransitionTarget aState : relevantStates) {
			enableButtonsForTransitionsOf(aState);
		} */
	}

	@Override
	public void onEntry(TransitionTarget enteredState) {
		// questa modifica non funziona per niente. però mi pare di ricordare che anche questa versione
		// che funziona con la semplice abilitazione di tutte le transizioni aveva un problema con
		// qualche esempio del parallelo. era il problema rimasto aperto con Gabbuti-Monti
//		Set<TransitionTarget> relevantStates = myASM.getEngine().getCurrentStatus().getAllStates();
////		relevantStates.remove(fromState);
////		relevantStates.add(toState);
//		for (TransitionTarget aState : relevantStates) {
//			System.out.println(aState.getId());
//			enableButtonsForTransitionsOf(aState);
//		}
		enableButtonsForTransitionsOf(enteredState);
	}

	@Override
	public void onExit(TransitionTarget exitedState) {
		disableAllJButtons();
	}
}
