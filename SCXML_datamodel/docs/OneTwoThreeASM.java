/*
 * @generated
 */
package core;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;

public class OneTwoThreeASM extends AbstractASM{

	private StateChartGUI myGUI;
	// static required since AbstractStateMachine will invoke the code for the initial state without initialization of dynamic variables
	static private boolean firstEnterInitialState = true;


	public OneTwoThreeASM(String aSCName) throws MalformedURLException {
		super(new URL("file:support" + File.separator + aSCName + ".scxml"));
	}

	public void setMyGUI(StateChartGUI pGUI) {
		myGUI = pGUI;
	}

	public void one() {
		if (firstEnterInitialState) {
			firstEnterInitialState = false;
		} else {
//			System.out.println(" --> ENTER one");
			myGUI.statechartTraceAppend(" --> ENTER one");
			myGUI.stateDisplayUpdate("one");
		}

	}

	public void two() {
//		System.out.println(" --> ENTER two");
		myGUI.statechartTraceAppend(" --> ENTER two");
		myGUI.stateDisplayUpdate("two");
	}

	public void three() {
//		System.out.println(" --> ENTER three");
		myGUI.statechartTraceAppend(" --> ENTER three");
		myGUI.stateDisplayUpdate("three");
	}

	public void four() {
//		System.out.println(" --> ENTER four");
		myGUI.statechartTraceAppend(" --> ENTER four");
		myGUI.stateDisplayUpdate("four");
	}

}
