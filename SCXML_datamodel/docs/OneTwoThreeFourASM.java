/*
 * @generated
 */
package core;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;

public class OneTwoThreeFourASM extends AbstractASM{

	private StateChartGUI myGUI;

	// static required since AbstractStateMachine will invoke the code for the initial state without initialization of dynamic variables
	static private boolean firstEnterInitialState = true;

	public OneTwoThreeFourASM(String aSCName) throws MalformedURLException {
		super(new URL("file:data" + File.separator + aSCName + ".scxml"));
	}

	public void setMyGUI(StateChartGUI pGUI) {
		myGUI = pGUI;
	}

	private int initialstate$value;
	private int onetwo$value;
	private int one$value;
	private int two$value;
	private int three$value;
	private int four$value;

	public void init() {
		this.init(0, 0, 0, 44, 0, 0);
	}

	private void init(int Pinitialstate$value, int Ponetwo$value, int Pone$value, int Ptwo$value, int Pthree$value, int Pfour$value) {
		this.setinitialstate$value(Pinitialstate$value);
		this.setonetwo$value(Ponetwo$value);
		this.setone$value(Pone$value);
		this.settwo$value(Ptwo$value);
		this.setthree$value(Pthree$value);
		this.setfour$value(Pfour$value);
	}

	public int get$value(String pDataID){
		if (pDataID.equals("initialstate$value")) return this.getinitialstate$value();
		if (pDataID.equals("onetwo$value")) return this.getonetwo$value();
		if (pDataID.equals("one$value")) return this.getone$value();
		if (pDataID.equals("two$value")) return this.gettwo$value();
		if (pDataID.equals("three$value")) return this.getthree$value();
		if (pDataID.equals("four$value")) return this.getfour$value();
		return -1;
	}

	public void set$value(String pDataID, int pValue){
		if (pDataID.equals("initialstate$value")) this.setinitialstate$value(pValue);
		if (pDataID.equals("onetwo$value")) this.setonetwo$value(pValue);
		if (pDataID.equals("one$value")) this.setone$value(pValue);
		if (pDataID.equals("two$value")) this.settwo$value(pValue);
		if (pDataID.equals("three$value")) this.setthree$value(pValue);
		if (pDataID.equals("four$value")) this.setfour$value(pValue);
	}

	public void initialstate() {
		if (firstEnterInitialState) {
			firstEnterInitialState = false;
		} else {
//			System.out.println(" --> ENTER initialstate");
			myGUI.statechartTraceAppend(" --> ENTER initialstate");
			myGUI.stateDisplayUpdate("initialstate");
		}
	}

	public int getinitialstate$value(){
		return this.initialstate$value;
	}

	public void setinitialstate$value(int pValue){
		initialstate$value = pValue;
	}

	public void onetwo() {
//		System.out.println(" --> ENTER onetwo");
		myGUI.statechartTraceAppend(" --> ENTER onetwo");
		myGUI.stateDisplayUpdate("onetwo");
	}

	public int getonetwo$value(){
		return this.onetwo$value;
	}

	public void setonetwo$value(int pValue){
		onetwo$value = pValue;
	}

	public void one() {
//		System.out.println(" --> ENTER one");
		myGUI.statechartTraceAppend(" --> ENTER one");
		myGUI.stateDisplayUpdate("one");
	}

	public int getone$value(){
		return this.one$value;
	}

	public void setone$value(int pValue){
		one$value = pValue;
	}

	public void two() {
//		System.out.println(" --> ENTER two");
		myGUI.statechartTraceAppend(" --> ENTER two");
		myGUI.stateDisplayUpdate("two");
	}

	public int gettwo$value(){
		return this.two$value;
	}

	public void settwo$value(int pValue){
		two$value = pValue;
	}

	public void three() {
//		System.out.println(" --> ENTER three");
		myGUI.statechartTraceAppend(" --> ENTER three");
		myGUI.stateDisplayUpdate("three");
	}

	public int getthree$value(){
		return this.three$value;
	}

	public void setthree$value(int pValue){
		three$value = pValue;
	}

	public void four() {
//		System.out.println(" --> ENTER four");
		myGUI.statechartTraceAppend(" --> ENTER four");
		myGUI.stateDisplayUpdate("four");
	}

	public int getfour$value(){
		return this.four$value;
	}

	public void setfour$value(int pValue){
		four$value = pValue;
	}

}
