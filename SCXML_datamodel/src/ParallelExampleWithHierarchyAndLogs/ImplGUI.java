/*
 * @generated
 */
package ParallelExampleWithHierarchyAndLogs;

import java.awt.Color;
import java.awt.FlowLayout;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.ScrollPaneConstants;
import javax.swing.JTextArea;
import core.AbstractGUI;
public class ImplGUI extends AbstractGUI {

	public ImplGUI(String pSCName) {

		JFrame myFrame = new JFrame();
		myFrame.setTitle(pSCName);
		myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		myFrame.setSize(500, 800);
		myFrame.setLayout(new FlowLayout());

		String[] eventList = { "start", "onetwo_three", "onetwo_threefour", "two_four", "three_one", "three_four", "four_three", "threefour_onetwo" };
		for (String event : eventList) {
			JButton aButton = new JButton("LAUNCH " + event);
			aButton.setActionCommand(event);
			aButton.addActionListener(this);
			myFrame.getContentPane().add(aButton);
			eventButtons.put(event, aButton);
		}

		String[] variableList = { "initialstate$value", "onetwo$value", "one$value", "two$value", "three$value", "four$value" };
		for (String variable : variableList) {
			JPanel panel = new JPanel();
			panel.setBackground(Color.LIGHT_GRAY);
			panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
			panel.add(new JLabel(variable));
			JTextField textField = new JTextField("", 5);
			textField.setActionCommand(variable);
			textField.addActionListener(this);
			panel.add(textField);
			myFrame.getContentPane().add(panel);
			variableFields.put(variable, textField);
		}
		statechartTrace = new JTextArea(40,40);
		statechartTrace.setLineWrap(false);
		JScrollPane aScroller = new JScrollPane(statechartTrace);
		aScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
		aScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		myFrame.getContentPane().add(aScroller);

		myFrame.setVisible(true);
	}

	}
