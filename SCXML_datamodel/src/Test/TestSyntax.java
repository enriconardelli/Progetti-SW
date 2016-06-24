package Test;

import static org.junit.Assert.*;


import org.junit.Test;

import framework.SC_Model_Element;

public class TestSyntax {
	
	@Test
	public void testSCXMLDocumentSyntaxOK( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("contatore");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: il file è scritto correttamente",SCXMLDocument.SCXMLDocumentSyntaxOK());
	}

	@Test
	public void testTarget( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("targeterrati");
		SCXMLDocument.set_documentRoot2();
		assertTrue("SyntaxOk non funziona: qui i target sono errati", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}

	@Test
	public void testData( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("dataerrati");
		SCXMLDocument.set_documentRoot2();
		assertTrue("SyntaxOk non funziona: qui i data sono errati", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	

	@Test
	public void testVersion( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("versioneSbagliata");
		SCXMLDocument.set_documentRoot2();
		assertTrue("SyntaxOk non funziona: qui la versione è errata", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	

	@Test
	public void  TestEventCondTarget( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("eventcondtarget");
		SCXMLDocument.set_documentRoot2();
		assertTrue("SyntaxOk non funziona: qui manca il target, l'evento e condizione a una transizione  ", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}

	
	
	
	
	
	
	
	
}
