package com.ibm.btt.ui.sandbox;

import java.io.File;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


public class XMLReader {

	private File file;
	private ArrayList<String> alExclusiveProjects;
	private ArrayList<String> alMultiLevelProjects;
	
	public  XMLReader(){}
	
	public XMLReader(File file) {
		this.file = file;
		alExclusiveProjects = new ArrayList<String>();
		alMultiLevelProjects = new ArrayList<String>();
	}

	/**
	 * Parse configuration file
	 * decode conf/conf.xml and acquire the filted directory
	 */
	public ArrayList<String> getExclusiveProjectList(){
	
		try{
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.parse(file);
			Node rootNode = document.getFirstChild(); 
	       // System.out.println(rootNode.toString());
	        NodeList projectList = rootNode.getChildNodes();
	        
	        for(int i = 1; i < projectList.getLength(); i+=2){
	        	Node curNode = projectList.item(i); 
	             System.out.println("Projects" + i + " : " + curNode.toString()); 
	             
	             NamedNodeMap map = curNode.getAttributes(); 
	             if(map.item(0).getNodeValue().equals("ExclusiveProjects")){
	            	 NodeList projects = curNode.getChildNodes();
		             for (int j = 1; j < projects.getLength(); j += 2) { 
		            	 Node item = projects.item(j);
						 if(item instanceof Element)
							 alExclusiveProjects.add(item.getTextContent()); 
		            	 
		             } 
	             }             
	        }
		}
		catch(Exception e){
			System.out.println("can not find the case.xml file");
			e.printStackTrace();			
		}	
		
		return alExclusiveProjects;
	}
	
	/**
	 * Parse configuration file
	 * decode conf/conf.xml and acquire the multilevel directory
	 */
	public ArrayList<String> getMultiLevelProjectList(){
		
		try{
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.parse(file);
			Node rootNode = document.getFirstChild(); 
	        //System.out.println(rootNode.toString());
	        NodeList projectList = rootNode.getChildNodes();
	        
	        for(int i = 1; i < projectList.getLength(); i+=2){
	        	Node curNode = projectList.item(i); 
	             System.out.println("Projects" + i + " : " + curNode.toString()); 
	             
	             NamedNodeMap map = curNode.getAttributes(); 
	             if(map.item(0).getNodeValue().equals("MultiLevelProjects")){
	            	 NodeList projects = curNode.getChildNodes();
		             for (int j = 1; j < projects.getLength(); j += 2) { 
		            	 Node item = projects.item(j);
						 if(item instanceof Element)
							 alMultiLevelProjects.add(item.getTextContent()); 
		            	 
		             } 
	             }             
	        }
		}
		catch(Exception e){
			System.out.println("can not find the case.xml file");
			e.printStackTrace();			
		}	
		
		return alMultiLevelProjects;
	}
}
	


