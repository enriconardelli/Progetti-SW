package Test;

import static org.junit.Assert.*;

import org.junit.Test;

import framework.SC_Model_Element;

import framework.Conf;



public class SCModelElementTest {

	@SuppressWarnings("deprecation")
	@Test
	public void testSet_Model() {
		SC_Model_Element element = new SC_Model_Element();
		element.set_Model("pippo" + Conf.filesep + "pluto");
		assertTrue("Error: set_Model sets a wrong name",element.getName().equals("pluto") );
	}
	
	@Test
	public void testSet_Model2() {
		SC_Model_Element element = new SC_Model_Element();
		element.set_Model("pippo" + Conf.filesep + "pluto" + Conf.filesep + "topo");
		assertTrue("Error: set_Model sets a wrong name",element.getName().equals("topo") );
	}

}
