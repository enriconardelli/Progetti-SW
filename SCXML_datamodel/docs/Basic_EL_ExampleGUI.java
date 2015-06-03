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

public class Basic_EL_ExampleGUI implements ActionListener, StateChartGUI {

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

	private JTextField inizioF;
	private void setinizioF(String pString) {
		this.inizioF.setText(pString);
	}

	private JTextField middle1F;
	private void setmiddle1F(String pString) {
		this.middle1F.setText(pString);
	}

	private JTextField customF;
	private void setcustomF(String pString) {
		this.customF.setText(pString);
	}

	@Override
	public void stateDisplayUpdate(String pState) {
		int value = myStateChartAPPL.getStateChartASM().get_value(pState + "_value");
		String fieldToUpdate= pState + "F";
		if (fieldToUpdate.equals("inizioF")) this.setinizioF(String.valueOf(value));
		if (fieldToUpdate.equals("middle1F")) this.setmiddle1F(String.valueOf(value));
		if (fieldToUpdate.equals("customF")) this.setcustomF(String.valueOf(value));
	}

	@Override
	public void stateValueUpdate(String pField) {
		String stateToUpdate= (String) pField.subSequence(0, pField.length()-1);
		String newValue = "";
		if (pField.equals("inizioF")) newValue=inizioF.getText();
		if (pField.equals("middle1F")) newValue=middle1F.getText();
		if (pField.equals("customF")) newValue=customF.getText();
		myStateChartAPPL.getStateChartASM().set_value(stateToUpdate + "_value", Integer.parseInt(newValue));
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

	public Basic_EL_ExampleGUI(String pSCName) {

		JFrame myFrame = new JFrame();
		myFrame.setTitle(pSCName);
		myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		myFrame.setSize(500, 700);
		myFrame.setLayout(new FlowLayout());

		JButton helloeventB = new JButton("LAUNCH helloevent");
		helloeventB.setActionCommand("helloevent");
		helloeventB.addActionListener(this);
		myFrame.getContentPane().add(helloeventB);

		JButton nullB = new JButton("LAUNCH null");
		nullB.setActionCommand("null");
		nullB.addActionListener(this);
		myFrame.getContentPane().add(nullB);

		JPanel inizioP = new JPanel();
		inizioP.setBackground(Color.LIGHT_GRAY);
		inizioP.setLayout(new BoxLayout(inizioP, BoxLayout.Y_AXIS));
		JLabel inizioL = new JLabel("inizio");
		inizioP.add(inizioL);
		inizioF = new JTextField("", 5);
		inizioP.add(inizioF);
		myFrame.getContentPane().add(inizioP);

		JPanel middle1P = new JPanel();
		middle1P.setBackground(Color.LIGHT_GRAY);
		middle1P.setLayout(new BoxLayout(middle1P, BoxLayout.Y_AXIS));
		JLabel middle1L = new JLabel("middle1");
		middle1P.add(middle1L);
		middle1F = new JTextField("", 5);
		middle1P.add(middle1F);
		myFrame.getContentPane().add(middle1P);

		JPanel customP = new JPanel();
		customP.setBackground(Color.LIGHT_GRAY);
		customP.setLayout(new BoxLayout(customP, BoxLayout.Y_AXIS));
		JLabel customL = new JLabel("custom");
		customP.add(customL);
		customF = new JTextField("", 5);
		customP.add(customF);
		myFrame.getContentPane().add(customP);

		statechartTrace = new JTextArea(40,40);
		statechartTrace.setLineWrap(false);
		JScrollPane aScroller = new JScrollPane(statechartTrace);
		aScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
		aScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		myFrame.getContentPane().add(aScroller);

		myFrame.setVisible(true);
	}

	}
