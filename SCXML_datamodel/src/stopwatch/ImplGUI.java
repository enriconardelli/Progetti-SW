/*
 * @generated
 */
package stopwatch;

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

	private String[] eventList = { "watch_start", "watch_split", "watch_unsplit", "watch_reset", "watch_stop" };
	private Color[] eventColorValue = { Color.RED, Color.LIGHT_GRAY, Color.WHITE, Color.LIGHT_GRAY, Color.LIGHT_GRAY };
	private String[] eventTTValue = { "start", "split", "This is an event", "reset", "This is an event" };

	private String[] panelList = { "running$value", "paused$value", "stopped$value", "reset$value" };
	private Color[] panelColorValue = { Color.RED, Color.LIGHT_GRAY, Color.YELLOW, Color.LIGHT_GRAY };
	private String[] panelTTValue = { "This is a variable", "paused value", "stopped value", "This is a variable" };

	private Color[] tFieldColorValue = { Color.GREEN, Color.GRAY, Color.WHITE, Color.WHITE };
	private String[] tFieldTTValue = { "running", "paused", "stopped", "variable" };

	private Font buttfont = new Font( "Helevetica", Font.BOLD, 18);
	private Font panelfont = new Font( "TimesRoman", Font.PLAIN, 14);
	private Font fieldfont = new Font( "TimesRoman", Font.PLAIN, 16);

	public ImplGUI(String pSCName) {

		HashMap<String,Integer> frameParameters = new HashMap<String,Integer>();
		String[] paramList = {"width", "height"};
		Integer[] valueList = { 500 ,  800 };
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
			aButton.setFont(buttfont);
			aButton.addActionListener(this);
			myFrame.getContentPane().add(aButton);
			eventButtons.put(eventList[i], aButton);
		}

		for (int i=0 ; i<panelList.length ; i++) {
			JPanel panel = new JPanel();
			panel.setBackground(panelColorValue[i]);
			panel.setToolTipText(panelTTValue[i]);
			panel.setFont(panelfont);
			panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
			panel.add(new JLabel(panelList[i]));
			JTextField textField = new JTextField("", 5);
			textField.setActionCommand(panelList[i]);
			textField.setBackground(tFieldColorValue[i]);
			textField.setToolTipText(tFieldTTValue[i]);
			textField.setFont(fieldfont);
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
