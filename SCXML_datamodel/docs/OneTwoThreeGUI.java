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

public class OneTwoThreeGUI implements ActionListener, StateChartGUI {

	private static StateChartAPPL myStateChartAPPL;
	public void setMyStateChartAPPL(StateChartAPPL pStateChartAPPL){
		myStateChartAPPL=pStateChartAPPL;
	}

	private JTextArea statechartTrace;
	public void statechartTraceAppend(String pString) {
		statechartTrace.append(pString);
	}
	
	private JTextField oneF;
	private void setOneF(String pString) {
		oneF.setText(pString);
	}

	private JTextField twoF;
	private void setTwoF(String pString) {
		twoF.setText(pString);
	}

	private JTextField threeF;
	private void setThreeF(String pString) {
		threeF.setText(pString);
	}

	private JTextField fourF;
	private void setFourF(String pString) {
		fourF.setText(pString);
	}

	public void stateDisplayUpdate(String pState) {
		int value = myStateChartAPPL.getInstanceOfRunTimeSCObjectInterface().get$value(pState + "$value");
		String fieldToUpdate= pState + "F";
//		System.out.println("  fieldToUpdate = " + fieldToUpdate + " with value = " + value);
		if (fieldToUpdate.equals("oneF")) setOneF(String.valueOf(value));
		if (fieldToUpdate.equals("twoF")) setTwoF(String.valueOf(value));
		if (fieldToUpdate.equals("threeF")) setThreeF(String.valueOf(value));
		if (fieldToUpdate.equals("fourF")) setFourF(String.valueOf(value));
	}

	public OneTwoThreeGUI(String pSCName) {
		
		JFrame myFrame = new JFrame();
		myFrame.setTitle(pSCName);
		myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		myFrame.setSize(380, 700);
		myFrame.setLayout(new FlowLayout());

		JButton alfaB = new JButton("LAUNCH alfa");
		alfaB.setActionCommand("alfa");
		alfaB.addActionListener(this);
		myFrame.getContentPane().add(alfaB);

		JButton betaB = new JButton("LAUNCH beta");
		betaB.setActionCommand("beta");
		betaB.addActionListener(this);
		myFrame.getContentPane().add(betaB);

		JButton gammaB = new JButton("LAUNCH gamma");
		gammaB.setActionCommand("gamma");
		gammaB.addActionListener(this);
		myFrame.getContentPane().add(gammaB);

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

		statechartTrace = new JTextArea(30,30);
		statechartTrace.setLineWrap(false);
		JScrollPane aScroller = new JScrollPane(statechartTrace);
		aScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
		aScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		myFrame.getContentPane().add(aScroller);
		
		myFrame.setVisible(true);
	}

		public void actionPerformed(ActionEvent pActionEvent) {
			String anEvent = pActionEvent.getActionCommand();
//			System.out.println("\n" + anEvent.toString() + " LAUNCHed");
			statechartTrace.append("\n" + anEvent.toString() + " LAUNCHed ");
			TriggerEvent aTriggerEvent = new TriggerEvent(anEvent, TriggerEvent.SIGNAL_EVENT, myStateChartAPPL.getInstanceOfRunTimeSCObjectInterface());
			try {
				myStateChartAPPL.getStateChartASM().getEngine().triggerEvent(aTriggerEvent);
			} catch (ModelException me) {
				System.out.println(me.getMessage());
			}
		}
	}
