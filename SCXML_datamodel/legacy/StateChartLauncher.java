package legacy;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

import org.jdom.JDOMException;


public class StateChartLauncher {

	static private String SCName = "contatore";
	
	public static void main(String[] args) {
		StateChartAPPL aStateChart = new StateChartAPPL();
		try {
			aStateChart.startSC(SCName);
		} catch (InstantiationException e) {e.printStackTrace();
		} catch (IllegalAccessException e) {e.printStackTrace();
		} catch (ClassNotFoundException e) {e.printStackTrace();
		} catch (JDOMException e) {e.printStackTrace();
		} catch (IOException e) {e.printStackTrace();
		} catch (InterruptedException e) {e.printStackTrace();
		} catch (SecurityException e) {e.printStackTrace();
		} catch (NoSuchMethodException e) {e.printStackTrace();
		} catch (IllegalArgumentException e) {e.printStackTrace();
		} catch (InvocationTargetException e) {e.printStackTrace();
		}
	}
}
