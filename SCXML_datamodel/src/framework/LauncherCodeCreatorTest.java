package framework;

import static org.junit.Assert.*;

import java.io.IOException;

import org.junit.Test;

public class LauncherCodeCreatorTest {

	@Test
	public void writePreambleAndClassTest() {
		
		String MethodOutput="";
		String toBeMatched="";
		try {
			MethodOutput = LauncherCodeCreator.writePreambleAndClass("aTestString");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(MethodOutput);
		
		toBeMatched= ".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep+".*"+Conf.linesep;
		
		
		assertTrue(MethodOutput.matches(toBeMatched)); 
	}

}
