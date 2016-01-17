/*
 * @generated
 */
package OneTwoThree;

import java.util.HashMap;
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
import java.awt.Font;

public class ImplGUI extends AbstractGUI {

	private String[] eventList = { "two", "three", "one" };
	private Color[] eventColorValue = { Color.WHITE, Color.WHITE, Color.WHITE };
	private String[] eventTTValue = { "Event", "Event", "Event" };

	private String[] panelList = { "onevalue", "twovalue", "threevalue" };
	private Color[] panelColorValue = { Color.WHITE, Color.WHITE, Color.WHITE };
	private String[] panelTTValue = { "Variable", "Variable", "Variable" };

	private Color[] tFieldColorValue = { Color.WHITE, Color.WHITE, Color.WHITE };
	private String[] tFieldTTValue = { "Numeric Variable", "Numeric Variable", "Numeric Variable" };

	private Font button_font = new Font( "TimesRoman", Font.PLAIN, 16);
	private Font panel_font = new Font( "TimesRoman", Font.PLAIN, 16);
	private Font field_font = new Font( "TimesRoman", Font.PLAIN, 16);

	public ImplGUI(String pSCName) {

		HashMap<String,Integer> frameParameters = new HashMap<String,Integer>();
		String[] paramList = {"width", "height"};
		Integer[] valueList = {500, 800};
		for (int i=0; i<paramList.length; i++) {
			 frameParameters.put(paramList[i], valueList[i]);
		}

		JFrame myFrame = new JFrame();
		myFrame.setTitle(pSCName);
		myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		myFrame.setSize(frameParameters.get("width"), frameParameters.get("height"));
		myFrame.setLayout(new FlowLayout());


		for (int i=0 ; i<eventList.length ; i++) {
			JButton aButton = new JButton("LAUNCH " + eventList[i]);
			aButton.setActionCommand(eventList[i]);
			aButton.setBackground(eventColorValue[i]);
			aButton.setToolTipText(eventTTValue[i]);
			aButton.setFont(button_font);
			aButton.addActionListener(this);
			myFrame.getContentPane().add(aButton);
			eventButtons.put(eventList[i], aButton);
		}

		for (int i=0 ; i<panelList.length ; i++) {
			JPanel panel = new JPanel();
			panel.setBackground(panelColorValue[i]);
			panel.setToolTipText(panelTTValue[i]);
			panel.setFont(panel_font);
			panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
			panel.add(new JLabel(panelList[i]));
			JTextField textField = new JTextField("", 5);
			textField.setActionCommand(panelList[i]);
			textField.setBackground(tFieldColorValue[i]);
			textField.setToolTipText(tFieldTTValue[i]);
			textField.setFont(field_font);
			textField.addActionListener(this);
			panel.add(textField);
			myFrame.getContentPane().add(panel);
			variableFields.put(panelList[i], textField);
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
