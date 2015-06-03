/*
 * @generated
 */
package core;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import org.apache.commons.scxml.env.jsp.ELContext;
import org.apache.commons.scxml.env.jsp.ELEvaluator;

public class Basic_EL_ExampleASM extends AbstractASM{

	private StateChartGUI myGUI;

	// static required since AbstractStateMachine will invoke the code for the initial state without initialization of dynamic variables
	static private boolean firstEnterInitialState = true;

	public Basic_EL_ExampleASM(String aSCName) throws MalformedURLException {
		super(new URL("file:data" + File.separator + aSCName + ".scxml"),
			new ELContext(),
			new ELEvaluator());
	}

	public void setMyGUI(StateChartGUI pGUI) {
		myGUI = pGUI;
	}

	private int inizio_value;
	private int middle1_value;
	private int custom_value;

	public void init() {
		this.init(3, 3, 3);
	}

	private void init(int Pinizio_value, int Pmiddle1_value, int Pcustom_value) {
		this.setinizio_value(Pinizio_value);
		this.setmiddle1_value(Pmiddle1_value);
		this.setcustom_value(Pcustom_value);
	}

	public int get_value(String pDataID){
		if (pDataID.equals("inizio_value")) return this.getinizio_value();
		if (pDataID.equals("middle1_value")) return this.getmiddle1_value();
		if (pDataID.equals("custom_value")) return this.getcustom_value();
		return -1;
	}

	public void set_value(String pDataID, int pValue){
		if (pDataID.equals("inizio_value")) this.setinizio_value(pValue);
		if (pDataID.equals("middle1_value")) this.setmiddle1_value(pValue);
		if (pDataID.equals("custom_value")) this.setcustom_value(pValue);
	}

	public void inizio() {
		if (firstEnterInitialState) {
			firstEnterInitialState = false;
		} else {
//			System.out.println(" --> ENTER inizio");
			myGUI.statechartTraceAppend(" --> ENTER inizio");
			myGUI.stateDisplayUpdate("inizio");
		}
	}

	public int getinizio_value(){
		return this.inizio_value;
	}

	public void setinizio_value(int pValue){
		inizio_value = pValue;
	}

	public void middle1() {
//		System.out.println(" --> ENTER middle1");
		myGUI.statechartTraceAppend(" --> ENTER middle1");
		myGUI.stateDisplayUpdate("middle1");
	}

	public int getmiddle1_value(){
		return this.middle1_value;
	}

	public void setmiddle1_value(int pValue){
		middle1_value = pValue;
	}

	public void custom() {
//		System.out.println(" --> ENTER custom");
		myGUI.statechartTraceAppend(" --> ENTER custom");
		myGUI.stateDisplayUpdate("custom");
	}

	public int getcustom_value(){
		return this.custom_value;
	}

	public void setcustom_value(int pValue){
		custom_value = pValue;
	}

}
