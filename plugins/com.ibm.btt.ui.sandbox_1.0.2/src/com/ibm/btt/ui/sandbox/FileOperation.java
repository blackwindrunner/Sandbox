package com.ibm.btt.ui.sandbox;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.eclipse.core.runtime.FileLocator;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class FileOperation {
	
	private ArrayList<String> alExclusiveProjects;
	private ArrayList<String> alMultiLevelProjects;
	public FileOperation(){
		
		//Read config file
		URL url = Activator.getDefault().getBundle().getResource("conf/conf.xml");
		
		URL fileUrl = null;
		try {
			fileUrl = FileLocator.toFileURL(url);
		} catch (IOException e) {
			e.printStackTrace();
		}
			
		File file = new File(fileUrl.getPath());
		if(file.exists()){
			XMLReader xmlReader = new XMLReader(file);
			
			alExclusiveProjects = xmlReader.getExclusiveProjectList();
			alMultiLevelProjects = xmlReader.getMultiLevelProjectList();
		}
		
	}
	/**
	 * Read the config file line by line to seach dependence project
	 * @param fileName
	 *            config file name
	 * @param alProjects
	 *            arraylist for dependence projects
	 */
	public  void getDependenceProjects(String fileName,
			String searchConditon, ArrayList<String> alProjects) {
		File file = new File(fileName);
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new FileReader(file));
			String tempString = null;
			String str = null;
			// read one line each time until the mark---null
			while ((tempString = reader.readLine()) != null) {
				// seach dependence project
				int n = tempString.indexOf(searchConditon, 0);
				
				while (n != -1) {
					tempString = tempString.substring(n	+ searchConditon.length());
					str = tempString.substring(0, tempString.indexOf('/'));
					alProjects.add(str);
					n = tempString.indexOf(searchConditon, 0);
				}
			}
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e1) {
					System.out.println("get dependece Projects failed!!!");
					e1.printStackTrace();
				}
			}
		}
	}

	/**
	 * Read the config file line by line to seach dependence jars
	 * 
	 * @param fileName
	 *            config file name
	 * @param alJars
	 *            arraylist for dependence jars
	 */
	public  void getDependenceJars(String fileName,
			String searchConditon, ArrayList<String> alJars) {
		File file = new File(fileName);
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new FileReader(file));
			String tempString = null;
			//  read one line each time until the mark---null
			while ((tempString = reader.readLine()) != null) {
				// seach dependence jars
				int n = tempString.indexOf(searchConditon, 0);
				int nTemp;
				while (n != -1) {
					tempString = tempString.substring(n
							+ searchConditon.length());
					nTemp = tempString.indexOf(".jar", 0);
					alJars.add(tempString.substring(0, nTemp + 4));
					n = tempString.indexOf(searchConditon, 0);
				}
			}
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e1) {
					System.out.println("get dependece jars failed!!!");
					e1.printStackTrace();
				}
			}
			System.out.println("get dependece jars failed!!!");
		}
	}

	/**
	 * Read case.xml in the Fvt test case directory
	 * 
	 * @param fileName
	 *            the full path for case.xml 
	 * @param alJars
	 *            arraylist for dependence jars
	 */
	public  void getCaseXmlJars(String fileName, ArrayList<String> alJars, String[] strEar) {
		
		File file = new File(fileName);
		try{
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.parse(file);
			//Document doc = builder.parse(new File("e://conf.xml"));
			
			NodeList list = doc.getElementsByTagName("TestCase");
			if(list.getLength() > 0){
				Element element = (Element)list.item(0);
				
				String[] strJars = element.getAttribute("jars").split(" ");
				for(int i = 0; i < strJars.length; ++i){
					alJars.add(strJars[i]);
				}
				strEar[0] = element.getAttribute("ear");
				strEar[1] = element.getAttribute("clientear");	
			}else{
				list = doc.getElementsByTagName("TestUnitCase");
				Element element = (Element)list.item(0);
				
				String[] strJars = element.getAttribute("jars").split(" ");
				for(int i = 0; i < strJars.length; ++i){
					alJars.add(strJars[i]);
				}
				strEar[0] = element.getAttribute("id");
				strEar[1] = "";
			}
		}
		catch(Exception e){
			System.out.println("can not find the case.xml file");
			e.printStackTrace();			
		}
	}
	
	
	/**
	 * copy file
	 * 
	 * @param in
	 *            destination file
	 * @param out
	 *            source file
	 */
	public  void copyFile(File in, File out) throws Exception {
		FileInputStream fis = new FileInputStream(in);
		FileOutputStream fos = new FileOutputStream(out);
		byte[] buf = new byte[1024];

		int i = 0;
		while ((i = fis.read(buf)) != -1) {
			fos.write(buf, 0, i);
		}
		fis.close();
		fos.close();
	}

	/**
	 * create a new file
	 * 
	 * @param filePathAndName
	 *            the path for new file eg: c:/fqf.txt
	 * @param fileContent
	 *            the content to write
	 * @return boolean
	 */
	public  boolean newFile(String filePathAndName, String fileContent) {

		try {
			String filePath = filePathAndName;
			filePath = filePath.toString();
			File myFilePath = new File(filePath);
			if (!myFilePath.exists()) {
				myFilePath.createNewFile();
			}
			FileWriter resultFile = new FileWriter(myFilePath);
			PrintWriter myFile = new PrintWriter(resultFile);
			String strContent = fileContent;
			myFile.println(strContent);
			resultFile.close();
			return true;
		} catch (Exception e) {
			System.out.println("create new file error!!!");
			e.printStackTrace();
			return false;
		}

	}

	/**
	 * delete file
	 * 
	 * @param filePathAndName
	 *             the path for new file eg: c:/fqf.txt
	 *
	 */
	public  void delFile(String filePathAndName) {
		try {
			String filePath = filePathAndName;
			filePath = filePath.toString();
			File delFile = new File(filePath);
			
			if (delFile.exists() && delFile.isFile())
				delFile.delete();
		} catch (Exception e) {
			System.out.println("delete file error");
			e.printStackTrace();

		}
	}

	
	/**
	 * create new project info file eg: .classpath .project
	 * firtly decide wether there are  build.xml,component.properties or not, if not, do recusive directly 
	 * if yes��create .project and .classpath, stop recusive 
	 * @param file
	 *            the directory need to creat project info
	 * need to resolve supporting of the multi OS  
	 */
	public  void createNewProjectInfo(File directory) {

		//support multi OS
		String strURIPath = directory.getPath().replace('\\', '/');
		// Decide this directory is a project dirctory		
	    File file1 = new File(strURIPath + "/build.xml");
	    File file2 = new File(strURIPath + "/component.properties");
	    
//	    //handle multilevel
//	    if(isMultiLevelProject(directory.getName())){
//	    	File[] files = directory.listFiles();
//			for (int j = 0; j < files.length; ++j) {
//				File file = (File) files[j];
//				if (file.isDirectory()) {
//					createNewProjectInfo(file);
//				}
//			}	
//		//common state
//	    }else if(file1.exists() && file2.exists()){
	    if(file1.exists() && file2.exists() && !isMultiLevelProject(directory.getName())){
	    	//has found��create .project and .classpath
		    // Create new .project
			createProjectInfo(strURIPath , "/.project");
	    	createClassPath(strURIPath ,"","/.classpath",true);
	    //recusive 
	    }else{
	    	File[] files = directory.listFiles();
	    	
	    	//handle multilevel
	    	String[] strBuildXmlPath = new String[1];
	    	strBuildXmlPath[0] = strURIPath;
	    	if(isMultiLevelProjectPath(strBuildXmlPath)){
	    		for (int j = 0; j < files.length; ++j) {
    				File file = (File) files[j];
    				
    				if(file.isDirectory() && file.getName().equals("src")){
    					// Create new .project
    					createProjectInfo(strURIPath , "/.project");
    					//find the path of build.xml and component.properties
    			    	createClassPath(strURIPath,strBuildXmlPath[0],"/.classpath",true);
    					return;
    				}
    	    	}	    			
	    	}   	
	    	
	    	//handle resively
			for (int k = 0; k < files.length; ++k) {
				File file = (File) files[k];
				
				if (file.isDirectory()) {
					createNewProjectInfo(file);
				}
			}	    	
	    } 	
	}
	/**
	 * Create  .project
	 * 
	 */
	public  void createProjectInfo(String filePath,String fileName){
		//define some variables related with document
		Document document;
		Element root = null;
		DocumentBuilderFactory factory = null;
		DocumentBuilder builder = null;
		
		//parse "component.properties" 
		//String strTemp = filePath + "/component.properties";
			
		try{
			factory = DocumentBuilderFactory.newInstance();
			builder = factory.newDocumentBuilder();
			document = builder.newDocument();
			root =  document.createElement("projectDescription");
			
			//name
			Element name = document.createElement("name");
			String strTemp = filePath.substring(filePath.lastIndexOf('/')+1);
			name.appendChild(document.createTextNode(strTemp));
			root.appendChild(name);
			
			//comment
			Element comment = document.createElement("comment");
			root.appendChild(comment);
			
			//projects
			Element projects = document.createElement("projects");
			root.appendChild(projects);
			
			//buildSpec
			{
				Element buildSpec = document.createElement("buildSpec");
				Element buildCommand = document.createElement("buildCommand");
				name = document.createElement("name");
				name.appendChild(document.createTextNode("org.eclipse.jdt.core.javabuilder"));
				Element arguments = document.createElement("arguments");
				buildCommand.appendChild(name);
				buildCommand.appendChild(arguments);
				buildSpec.appendChild(buildCommand);
				
				buildCommand = document.createElement("buildCommand");
				name = document.createElement("name");
				name.appendChild(document.createTextNode("com.ibm.etools.common.migration.MigrationBuilder"));
				arguments = document.createElement("arguments");
				buildCommand.appendChild(name);
				buildCommand.appendChild(arguments);
				buildSpec.appendChild(buildCommand);
				
				buildCommand = document.createElement("buildCommand");
				name = document.createElement("name");
				name.appendChild(document.createTextNode("org.eclipse.pde.SchemaBuilder"));
				arguments = document.createElement("arguments");
				buildCommand.appendChild(name);
				buildCommand.appendChild(arguments);
				buildSpec.appendChild(buildCommand);
				
				buildCommand = document.createElement("buildCommand");
				name = document.createElement("name");
				name.appendChild(document.createTextNode("org.eclipse.wst.common.project.facet.core.builder"));
				arguments = document.createElement("arguments");
				buildCommand.appendChild(name);
				buildCommand.appendChild(arguments);
				buildSpec.appendChild(buildCommand);
				
				buildCommand = document.createElement("buildCommand");
				name = document.createElement("name");
				name.appendChild(document.createTextNode("org.eclipse.wst.validation.validationbuilder"));
				arguments = document.createElement("arguments");
				buildCommand.appendChild(name);
				buildCommand.appendChild(arguments);
				buildSpec.appendChild(buildCommand);
				root.appendChild(buildSpec);
				
			}			
			
			//natures
			{
				Element natures = document.createElement("natures");
				Element nature = document.createElement("nature");
				nature.appendChild(document.createTextNode("org.eclipse.jdt.core.javanature"));
				natures.appendChild(nature);
				
				nature = document.createElement("nature");
				nature.appendChild(document.createTextNode("org.eclipse.pde.PluginNature"));
				natures.appendChild(nature);
				root.appendChild(natures);				
			}
			
			
			document.appendChild(root);

			TransformerFactory tf = TransformerFactory.newInstance();
			DOMSource dom = new DOMSource(document);
			//tf.setAttribute("indent-number", new Integer(2));

			//StreamResult sr = new StreamResult(response.getOutputStream());
			
			Transformer trans = tf.newTransformer();
			trans.setOutputProperty("encoding", "UTF-8");
			trans.setOutputProperty(OutputKeys.INDENT,   "yes");  
			trans.transform(dom, new StreamResult(new File(filePath + "/" +fileName)));
			//trans.transform(dom, new StreamResult(new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File(filePath + "/" +fileName))))));

			//StreamResult sr=new StreamResult(sw);
			//t.transform(dom, sw);

		}
		catch(Exception e){
			e.printStackTrace();
		}
	}	
	
	/**
	 * Create  .classPath
	 * filePath--the path of .classPath
	 * strBuildXmlPath--when multi level directory��it is the path of build.xml
	 * fileName--file name
	 * isProject--project or jar package
	 */
	public  void createClassPath(String filePath,String strBuildXmlPath,String fileName,boolean isProject){
		//define some variables related with document
		Document document;
		Element root = null;
		DocumentBuilderFactory factory = null;
		DocumentBuilder builder = null;
		
		//parse "component.properties" 
		String strTemp;
		if(strBuildXmlPath.length() > 0)
			strTemp = strBuildXmlPath + "/component.properties";
		else
			strTemp = filePath + "/component.properties";
		
		ArrayList<String> alJars = new ArrayList<String>();
		
		try{
			factory = DocumentBuilderFactory.newInstance();
			builder = factory.newDocumentBuilder();
			document = builder.newDocument();
			root =  document.createElement("classpath");
			Element entry;
			
			//src decode Build.xml and read <javac srcdir = "src:rcp">...
			Hashtable<String,String> hTable = new Hashtable<String,String>();
			if(strBuildXmlPath.length() > 0)
				getSrcNames(strBuildXmlPath+"/build.xml", hTable);
			else
				getSrcNames(filePath+"/build.xml", hTable);
			
			for(Iterator k  = hTable.values().iterator(); k.hasNext();){   
				entry = document.createElement("classpathentry");
				entry.setAttribute("kind", "src");
				String str = k.next().toString();
//				if(strBuildXmlPath.length() > 0)
//					entry.setAttribute("path", str.substring(str.lastIndexOf("/")+1));
//				else
					entry.setAttribute("path", str);
				root.appendChild(entry);
						
			}  
//			for(int i = 0; i < alJars.size(); ++i){
//				
//				entry = document.createElement("classpathentry");
//				entry.setAttribute("kind", "src");
//				String str = alJars.get(i);
//				if(strBuildXmlPath.length() > 0)
//					entry.setAttribute("path", str.substring(str.lastIndexOf("/")+1));
//				else
//					entry.setAttribute("path", str);
//				root.appendChild(entry);
//			}
			
			//JRE
			entry = document.createElement("classpathentry");
			entry.setAttribute("kind", "con");
			entry.setAttribute("path", "org.eclipse.jdt.launching.JRE_CONTAINER");
			root.appendChild(entry);
			
			//ENG_WORK_SPACE 
			alJars.clear();
			if(isProject){
				getDependenceProjects(strTemp, "${ENG_WORK_SPACE}/", alJars);
				
				Hashtable<String,String> selTemp = new Hashtable<String,String>();
				for(int i = 0; i < alJars.size(); ++i){
					
					String str = alJars.get(i);
					if(selTemp.containsKey(str)) continue;
					
					selTemp.put(str,str);
									
					//decide wether contains the charactor of "SandBox"
					if(str.indexOf("SandBox") != -1){
						//entry.setAttribute("kind", "var");
						//entry.setAttribute("path", "WAS_HOME/" + alJars.get(i));
						continue;
					}
					entry = document.createElement("classpathentry");
				
					entry.setAttribute("combineaccessrules", "false");
					entry.setAttribute("kind", "src");					
					entry.setAttribute("path", "/" + str);
											
					root.appendChild(entry);
				}				
			}else{
				getDependenceJars(strTemp, "${ENG_WORK_SPACE}/", alJars);
				
				for(int i = 0; i < alJars.size(); ++i){
					
					String str = alJars.get(i);
					
					entry = document.createElement("classpathentry");
				
					entry.setAttribute("kind", "lib");					
					entry.setAttribute("path",  str.substring(str.lastIndexOf("/")+1));
											
					root.appendChild(entry);
				}								
			}
				
			
			//WAS_HOME 
			//var import
			alJars.clear();
			getDependenceJars(strTemp, "${WAS_HOME}/", alJars);
			for(int i = 0; i < alJars.size(); ++i){
			
				entry = document.createElement("classpathentry");
				entry.setAttribute("kind", "var");
				entry.setAttribute("path", "WAS_HOME/" + alJars.get(i));
				root.appendChild(entry);
			}
			
			//PDE
			alJars.clear();
			getDependenceJars(strTemp, "${RAD_SHARED_HOME}/plugins", alJars);
			if(alJars.size() > 0){
				entry = document.createElement("classpathentry");
				entry.setAttribute("kind", "con");
				entry.setAttribute("path", "org.eclipse.pde.core.requiredPlugins");
				root.appendChild(entry);
			}
			
			//output
			entry = document.createElement("classpathentry");
			entry.setAttribute("kind", "output");
			entry.setAttribute("path", "bin");
			root.appendChild(entry);
										
			document.appendChild(root);

			TransformerFactory tf = TransformerFactory.newInstance();
			//tf.setAttribute("indent-number", new Integer(2));
			DOMSource dom = new DOMSource(document);
			//StreamResult sr = new StreamResult(response.getOutputStream());
			
			Transformer trans = tf.newTransformer();
			trans.setOutputProperty("encoding", "UTF-8");
			trans.setOutputProperty(OutputKeys.INDENT,   "yes");
			trans.transform(dom, new StreamResult(new File(filePath + "/" +fileName)));
			//StreamResult sr=new StreamResult(sw);
			//t.transform(dom, sw);

		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * Acquire the src name from build.xml
	 * 
	 */
	public  void getSrcNames(String fileName, Hashtable<String,String> alSrcs) {
		
		File file = new File(fileName);
		try{
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.parse(file);
			//Document doc = builder.parse(new File("e://conf.xml"));
			
			NodeList list = doc.getElementsByTagName("javac");
			for(int i = 0; i < list.getLength(); ++i)
			{
				Element element = (Element)list.item(i);
				
				String[] strSrcs = element.getAttribute("srcdir").split(":");
				String strTemp;
				for(int j = 0; j < strSrcs.length; ++j){
					strTemp = strSrcs[j];
					strTemp = strTemp.substring(strTemp.lastIndexOf("/")+1);
					alSrcs.put(strTemp, strTemp);
				}				
			}
		}
		catch(Exception e){
			System.out.println("can not find the case.xml file");
			e.printStackTrace();			
		}	
	}
	
	/**
	 * Decide the project is or not ExclusiveProjects--ExclusiveProjects List
	 * 
	 */
	public  boolean isExclusiveProject(String fileName) {
		
		return alExclusiveProjects.contains(fileName);
	}
	
	/**
	 * Decide the project is or not multilevelproject--MultiLevelProjects List
	 * 
	 */
	public  boolean isMultiLevelProject(String fileName) {
		
		return alMultiLevelProjects.contains(fileName);
	}
	
	/**
	 * Decide the project is or not multilevelproject--MultiLevelProjects List
	 * and return the parent directory
	 */
	public  boolean isMultiLevelProjectPath(String[] strPath) {
		//handle multi directory
    	for (int i = 0; i < alMultiLevelProjects.size();++i){
    		int nTemp = strPath[0].lastIndexOf(alMultiLevelProjects.get(i));
    		if(nTemp >0) {
    			strPath[0] = strPath[0].substring(0,nTemp + alMultiLevelProjects.get(i).length());
    			return true;
    		}
    	}		
    	return false;
	}
}
