package Test;

import static org.junit.Assert.*;


import org.junit.Test;

import framework.Conf;
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
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "targeterrati");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: qui i target sono errati", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}

	@Test
	public void testData( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "dataerrati");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: qui i data sono errati", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	

	@Test
	public void testVersion( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "versioneSbagliata");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: qui la versione è errata", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	
	

	@Test
	public void  TestEventCondTarget( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "eventcondtarget");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: qui manca il target, l'evento e condizione a una transizione  ", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}

	@Test
	public void  TestStatiStessoNome( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "statistessonome");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: esistono più stati con lo stesso nome  ", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	
	@Test
	public void  TestassignName( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "assignlocation");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: c'è assign non seguito da name  ", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	
	@Test
	public void  TestDataModel( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "datamodelinitial");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: ci sono 2 datamodel  ", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	
	@Test
	public void  TestXmlnsLink( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "xmlnsinitial");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: link xmlsbagliato ", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	
	@Test
	public void  TestInitialSbagliato( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "initialsbagliato");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: Initial è uno stato inesistente", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	
	@Test
	public void  TestInitialAssente( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "initialassente");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: Manca initial", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	
	@Test
	public void testDatadoppione( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "datadoppio");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: un data id è doppio", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
	
	@Test
	public void testFinalStateParallel( ) {
		SC_Model_Element SCXMLDocument = new SC_Model_Element();
		SCXMLDocument.set_Model("SCxml_sbagliati" + Conf.filesep + "mancastatoparallelfinal");
		SCXMLDocument.set_documentRoot();
		assertTrue("SyntaxOk non funziona: non c'è ne uno stato ne un parallel ne un final ( manca anche initial)", !SCXMLDocument.SCXMLDocumentSyntaxOK());
	}
}
