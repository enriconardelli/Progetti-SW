package Test;

import static org.junit.Assert.*;

import org.junit.Test;

import framework.SC_Model_Element;



public class SCModelElementTest {

	@SuppressWarnings("deprecation")
	@Test
	public void testSet_Model() {
		
		
		SC_Model_Element element = new SC_Model_Element();
		
		element.set_Model("pippo/pluto");

		assertTrue("Error: set_Model sets a null name",element.getName().equals("pluto") );
		
		
	}

}
