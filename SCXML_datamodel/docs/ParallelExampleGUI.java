/*
 * @generated
 */
package core;

import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.ScrollPaneConstants;
import javax.swing.JTextArea;
import org.apache.commons.scxml.TriggerEvent;
import org.apache.commons.scxml.model.ModelException;

public class ParallelExampleGUI implements ActionListener, StateChartGUI {

	private static StateChartAPPL myStateChartAPPL;
	@Override
	public void setMyStateChartAPPL(StateChartAPPL pStateChartAPPL){
		myStateChartAPPL=pStateChartAPPL;
	}

	private JTextArea statechartTrace;
	@Override
	public void statechartTraceAppend(String pString) {
		statechartTrace.append(pString);
	}

	private JTextField initialstateF;
	private void setinitialstateF(String pString) {
		this.initialstateF.setText(pString);
	}

	private JTextField onetwoF;
	private void setonetwoF(String pString) {
		this.onetwoF.setText(pString);
	}

	private JTextField oneF;
	private void setoneF(String pString) {
		this.oneF.setText(pString);
	}

	private JTextField twoF;
	private void settwoF(String pString) {
		this.twoF.setText(pString);
	}

	private JTextField threeF;
	private void setthreeF(String pString) {
		this.threeF.setText(pString);
	}

	private JTextField fourF;
	private void setfourF(String pString) {
		this.fourF.setText(pString);
	}

	@Override
	public void stateDisplayUpdate(String pState) {
		int value = myStateChartAPPL.getStateChartASM().get$value(pState + "$value");
		String fieldToUpdate= pState + "F";
		if (fieldToUpdate.equals("initialstateF")) this.setinitialstateF(String.valueOf(value));
		if (fieldToUpdate.equals("onetwoF")) this.setonetwoF(String.valueOf(value));
		if (fieldToUpdate.equals("oneF")) this.setoneF(String.valueOf(value));
		if (fieldToUpdate.equals("twoF")) this.settwoF(String.valueOf(value));
		if (fieldToUpdate.equals("threeF")) this.setthreeF(String.valueOf(value));
		if (fieldToUpdate.equals("fourF")) this.setfourF(String.valueOf(value));
	}

	@Override
	public void stateValueUpdate(String pField) {
		String stateToUpdate= (String) pField.subSequence(0, pField.length()-1);
		String newValue = "";
		if (pField.equals("initialstateF")) newValue=initialstateF.getText();
		if (pField.equals("onetwoF")) newValue=onetwoF.getText();
		if (pField.equals("oneF")) newValue=oneF.getText();
		if (pField.equals("twoF")) newValue=twoF.getText();
		if (pField.equals("threeF")) newValue=threeF.getText();
		if (pField.equals("fourF")) newValue=fourF.getText();
		myStateChartAPPL.getStateChartASM().set$value(stateToUpdate + "$value", Integer.parseInt(newValue));
	}

	@Override
	public void actionPerformed(ActionEvent pActionEvent) {
		String anEvent = pActionEvent.getActionCommand();
		statechartTrace.append("\n" + anEvent.toString() + " LAUNCHed ");
		if (anEvent.endsWith("F")) stateValueUpdate(anEvent);
		TriggerEvent aTriggerEvent = new TriggerEvent(anEvent, TriggerEvent.SIGNAL_EVENT, myStateChartAPPL.getStateChartASM());
		try {
			myStateChartAPPL.getStateChartASM().getEngine().triggerEvent(aTriggerEvent);
		} catch (ModelException me) {
			System.out.println(me.getMessage());
		}
	}

	public ParallelExampleGUI(String pSCName) {

		JFrame myFrame = new JFrame();
		myFrame.setTitle(pSCName);
		myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		myFrame.setSize(500, 700);
		myFrame.setLayout(new FlowLayout());

		JButton startB = new JButton("LAUNCH start");
		startB.setActionCommand("start");
		startB.addActionListener(this);
		myFrame.getContentPane().add(startB);

		JButton onetwo_threeB = new JButton("LAUNCH onetwo_three");
		onetwo_threeB.setActionCommand("onetwo_three");
		onetwo_threeB.addActionListener(this);
		myFrame.getContentPane().add(onetwo_threeB);

		JButton two_fourB = new JButton("LAUNCH two_four");
		two_fourB.setActionCommand("two_four");
		two_fourB.addActionListener(this);
		myFrame.getContentPane().add(two_fourB);

		JButton three_oneB = new JButton("LAUNCH three_one");
		three_oneB.setActionCommand("three_one");
		three_oneB.addActionListener(this);
		myFrame.getContentPane().add(three_oneB);

		JButton three_fourB = new JButton("LAUNCH three_four");
		three_fourB.setActionCommand("three_four");
		three_fourB.addActionListener(this);
		myFrame.getContentPane().add(three_fourB);

		JButton four_onetwoB = new JButton("LAUNCH four_onetwo");
		four_onetwoB.setActionCommand("four_onetwo");
		four_onetwoB.addActionListener(this);
		myFrame.getContentPane().add(four_onetwoB);

		JButton four_threeB = new JButton("LAUNCH four_three");
		four_threeB.setActionCommand("four_three");
		four_threeB.addActionListener(this);
		myFrame.getContentPane().add(four_threeB);

		JPanel initialstateP = new JPanel();
		initialstateP.setBackground(Color.LIGHT_GRAY);
		initialstateP.setLayout(new BoxLayout(initialstateP, BoxLayout.Y_AXIS));
		JLabel initialstateL = new JLabel("initialstate");
		initialstateP.add(initialstateL);
		initialstateF = new JTextField("", 5);
		initialstateP.add(initialstateF);
		myFrame.getContentPane().add(initialstateP);

		JPanel onetwoP = new JPanel();
		onetwoP.setBackground(Color.LIGHT_GRAY);
		onetwoP.setLayout(new BoxLayout(onetwoP, BoxLayout.Y_AXIS));
		JLabel onetwoL = new JLabel("onetwo");
		onetwoP.add(onetwoL);
		onetwoF = new JTextField("", 5);
		onetwoP.add(onetwoF);
		myFrame.getContentPane().add(onetwoP);

		JPanel oneP = new JPanel();
		oneP.setBackground(Color.LIGHT_GRAY);
		oneP.setLayout(new BoxLayout(oneP, BoxLayout.Y_AXIS));
		JLabel oneL = new JLabel("one");
		oneP.add(oneL);
		oneF = new JTextField("", 5);
		oneP.add(oneF);
		myFrame.getContentPane().add(oneP);

		JPanel twoP = new JPanel();
		twoP.setBackground(Color.LIGHT_GRAY);
		twoP.setLayout(new BoxLayout(twoP, BoxLayout.Y_AXIS));
		JLabel twoL = new JLabel("two");
		twoP.add(twoL);
		twoF = new JTextField("", 5);
		twoP.add(twoF);
		myFrame.getContentPane().add(twoP);

		JPanel threeP = new JPanel();
		threeP.setBackground(Color.LIGHT_GRAY);
		threeP.setLayout(new BoxLayout(threeP, BoxLayout.Y_AXIS));
		JLabel threeL = new JLabel("three");
		threeP.add(threeL);
		threeF = new JTextField("", 5);
		threeP.add(threeF);
		myFrame.getContentPane().add(threeP);

		JPanel fourP = new JPanel();
		fourP.setBackground(Color.LIGHT_GRAY);
		fourP.setLayout(new BoxLayout(fourP, BoxLayout.Y_AXIS));
		JLabel fourL = new JLabel("four");
		fourP.add(fourL);
		fourF = new JTextField("", 5);
		fourP.add(fourF);
		myFrame.getContentPane().add(fourP);

		statechartTrace = new JTextArea(40,40);
		statechartTrace.setLineWrap(false);
		JScrollPane aScroller = new JScrollPane(statechartTrace);
		aScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
		aScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		myFrame.getContentPane().add(aScroller);

		myFrame.setVisible(true);
	}

	}
