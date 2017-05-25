/*_
 * UNICOM(R) Multichannel Bank Transformation Toolkit Source Materials 
 * Copyright(C) 2011 - 2017 UNICOM Systems, Inc. - All Rights Reserved 
 * Highly Confidential Material - All Rights Reserved 
 * THE INFORMATION CONTAINED HEREIN CONSTITUTES AN UNPUBLISHED 
 * WORK OF UNICOM SYSTEMS, INC. ALL RIGHTS RESERVED. 
 * NO MATERIAL FROM THIS WORK MAY BE REPRINTED, 
 * COPIED, OR EXTRACTED WITHOUT WRITTEN PERMISSION OF 
 * UNICOM SYSTEMS, INC. 818-838-0606 
 */
package com.ibm.btt.cs.ajax;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.io.StringWriter;
import java.util.Enumeration;
import java.util.Locale;
import java.util.Set;

import com.ibm.btt.base.BTTLog;
import com.ibm.btt.base.BTTLogFactory;
import com.ibm.btt.base.Constants;
import com.ibm.btt.base.Context;
import com.ibm.btt.base.DSEInvalidArgumentException;
import com.ibm.btt.base.DSEObjectNotFoundException;
import com.ibm.btt.base.DataElement;
import com.ibm.btt.base.DataField;
import com.ibm.btt.base.Hashtable;
import com.ibm.btt.base.IndexedCollection;
import com.ibm.btt.base.KeyedCollection;
import com.ibm.btt.base.types.AbstractPropertyDescriptor;
import com.ibm.btt.element.simple.SimpleElementManager;
import com.ibm.btt.sm.CSSessionHandler;
import com.ibm.json.java.JSONArray;
import com.ibm.json.java.JSONObject;
import com.ibm.json.java.OrderedJSONObject;
import com.ibm.xml.crypto.util.Base64;

/**
 * 
 * @copyright(c) Copyright IBM Corporation 2010.
 */
public class ICBCAjaxUtils {
	@SuppressWarnings("unused")
	public static final java.lang.String COPYRIGHT = 
    "UNICOM(R) Multichannel Bank Transformation Toolkit Source Materials "
	+ "Copyright(C) 2010 - 2017 UNICOM Systems, Inc. - All Rights Reserved "
	+ "Highly Confidential Material - All Rights Reserved "
	+ "THE INFORMATION CONTAINED HEREIN CONSTITUTES AN UNPUBLISHED "
	+ "WORK OF UNICOM SYSTEMS, INC. ALL RIGHTS RESERVED. "
	+ "NO MATERIAL FROM THIS WORK MAY BE REPRINTED, "
	+ "COPIED, OR EXTRACTED WITHOUT WRITTEN PERMISSION OF "
	+ "UNICOM SYSTEMS, INC. 818-838-0606 ";


	private static BTTLog logger = BTTLogFactory.getLog(AjaxUtils.class.getName());

	// while rewriting mode is enabled, enable the icoll/kcoll structure (ICBC PMR 55938)
	private final static boolean KEEP_ICOLL_STRUCTURE = CSSessionHandler.isBTTRewritingEnabled();
	private final static String OBJECT_CACHE= "OBJECT_CACHE_";
	
	/**
	 * Convert the BTT context object to JSON String
	 * 
	 * @param ctx
	 *            the BTT context object
	 * @param loc locale info of the user
	 * @return the converted JSON String
	 */
	public static String convertToJson(Context ctx, Locale loc, String convType) {
		return AjaxUtils.convertToJson(ctx, loc, convType, false);
	}
	
	public static String convertToJson(Context ctx, Locale loc, String convType, boolean raw) {
		try {
			JSONObject result = convertToJson(ctx.getKeyedCollection(), loc, convType, raw);
			//APRISMA PMR 02444
			//return result.toString();
			return JsonConversionUtils.convertJSONObjectToString(result);
		} catch (Exception e) {
			throw new IllegalArgumentException(e);
		}
	}

	/**
	 * * Convert the keyed collection to JSONObject
	 * 
	 * @param kc
	 *            the keyed collection
	 * @param loc locale info of the user
	 * @return the converted JSON object
	 */
	public static JSONObject convertToJson(KeyedCollection kc,Locale loc, String convType) {
		return AjaxUtils.convertToJson(kc, loc, convType, false);
	}
	
	public static JSONObject convertToJson(KeyedCollection kc,Locale loc, String convType, boolean raw) {
		JSONObject result = new JSONObject();
		try {
			for (int i = 0; i < kc.size(); i++) {
				DataElement de = kc.getElementAt(i);
				if (de instanceof DataField) {
					DataField df = (DataField) de;
					Object dv = de.getValue();
					AbstractPropertyDescriptor descriptor = (AbstractPropertyDescriptor) df.getDescriptor();
					if (descriptor != null && loc!=null && dv!=null && !(dv instanceof Boolean) && !(raw && (dv instanceof Number))) {
						StringWriter sw = new StringWriter();
						descriptor.formatToWriter(de.getValue(), convType, sw,	loc, df.getParameters());
						dv = sw.toString();
					}
					/*
					if (dv instanceof String[]) {
						String[] strArray = (String[])dv;
						JSONArray ja2 = new JSONArray(strArray.length);
						for (String str : strArray){
//							if (str!=null ) {  BP36339
//								  if ( str.indexOf("'")>=0){
//									  str= str.replace('\'','\"');
//									 
//								  }
//									
//							}
							ja2.add(str);
						}
							
						dv = ja2;
					} */
					if(dv != null && !(dv instanceof Number) && !(dv instanceof Boolean) &&!(dv instanceof String)) {
//						dv = dv.toString();
						if (dv instanceof Serializable) {
							dv= object2String(dv);
						} else {
							throw new UnsupportedOperationException("Non-serializable object is not supported! name: " + de.getName() + " value:" + de.getValue().toString() + " class: " + de.getValue().getClass());
						}
					} 
//					if (dv!=null && dv instanceof String) {  BP36339
//						  if ( ((String)dv).indexOf("'")>=0){
//							  if ( ! ( ((String) dv).indexOf("javascript")>0 && df.getName().equals("page")) )
//								  dv= ((String)dv).replace('\'','\"');
//							 
//						  }
//						    
//					}
					if (dv != null && (dv instanceof Number || dv instanceof Boolean)) {
						dv = "[" + dv.getClass().getName() + "]" + dv.toString();
					}
					result.put(de.getName(), dv);
	
				} else if (de instanceof IndexedCollection) {
					result.put(de.getName(),convertToArray((IndexedCollection) de, loc, convType, raw));
				} else if (de instanceof KeyedCollection) {
					result.put(de.getName(),
							convertToJson((KeyedCollection) de, loc, convType, raw));
				}
			}
		} catch (Exception e) {
			throw new IllegalArgumentException(e);
		} 

		return result;
	}
	
	
	/**
	 * * Convert the keyed collection to JSONObject and keep the order of the attributes in JOSN the same as the elements in KeyedCollection
	 * 
	 * @param kc
	 *            the keyed collection
	 * @param loc locale info of the user
	 * @return the converted JSON object
	 */	
	public static JSONObject convertToOrderedJson(KeyedCollection kc,Locale loc, String convType) {
		JSONObject result = new OrderedJSONObject();
		try {
			for (int i = 0; i < kc.size(); i++) {
				DataElement de = (DataElement)kc.getElementAt(i);
				if (de instanceof DataField) {
					DataField df = (DataField) de;
					Object dv = de.getValue();
					AbstractPropertyDescriptor descriptor = (AbstractPropertyDescriptor) df.getDescriptor();
					if (descriptor != null && loc!=null && dv!=null && !(dv instanceof Boolean)) {
						StringWriter sw = new StringWriter();
						descriptor.formatToWriter(de.getValue(), convType, sw,	loc, df.getParameters());
						dv = sw.toString();
					}
					if (dv instanceof String[]) {
						String[] strArray = (String[])dv;
						JSONArray ja2 = new JSONArray(strArray.length);
						for (String str : strArray){
//							if (str!=null ) {  BP36339
//								  if ( str.indexOf("'")>=0){
//									  str= str.replace('\'','\"');
//									 
//								  }
//									
//							}
							ja2.add(str);
						}
							
						dv = ja2;
					} 
					if(dv != null && !(dv instanceof Number) && !(dv instanceof Boolean) &&!(dv instanceof String)) {
						dv = dv.toString();
					} 
//					if (dv!=null && dv instanceof String) { BP36339
//						  if ( ((String)dv).indexOf("'")>=0){
//							  if ( ! ( ((String) dv).indexOf("javascript")>0 && df.getName().equals("page")) )
//								  dv= ((String)dv).replace('\'','\"');
//							 
//						  }
//					}
					result.put(de.getName(), dv);
				} else if (de instanceof IndexedCollection) {
					result.put(de.getName(),convertToOrderedArray((IndexedCollection) de, loc, convType));
				} else if (de instanceof KeyedCollection) {
					result.put(de.getName(),
							convertToOrderedJson((KeyedCollection) de, loc, convType));
				}
			}
		} catch (Exception e) {
			throw new IllegalArgumentException(e);
		} 

		return result;
	}	
	
	/**
	 * Convert the indexed collection to JSONArray
	 * 
	 * @param ic
	 *            the indexed collection
	 * @param loc locale info of the user
	 * @return the JSONArray
	 */
	public static JSONArray convertToArray(IndexedCollection ic,Locale loc, String convType) {
		return AjaxUtils.convertToArray(ic, loc, convType, false);
	}
	public static JSONArray convertToArray(IndexedCollection ic,Locale loc, String convType, boolean raw) {
		JSONArray ja = new JSONArray(ic.size());
		try {
			for (int i = 0; i < ic.size(); i++) {
				DataElement de = ic.getElementAt(i);
				if (de instanceof DataField) {					
					DataField df = (DataField) de;
					Object dv = de.getValue();
					AbstractPropertyDescriptor descriptor = (AbstractPropertyDescriptor) df.getDescriptor();
					if (descriptor != null && loc!=null && dv!=null  && !(dv instanceof Boolean)) {
						StringWriter sw = new StringWriter();
						descriptor.formatToWriter(de.getValue(), convType, sw,	loc, df.getParameters());
						dv = sw.toString();
					} 
					if (dv instanceof String[]) {
						String[] strArray = (String[])dv;
						JSONArray ja2 = new JSONArray(strArray.length);
						for (String str : strArray)
							ja2.add(str);
						dv = ja2;
					} 
					if(dv != null && !(dv instanceof Number) && !(dv instanceof Boolean) &&!(dv instanceof String)) {
						dv = dv.toString();
					}			
					ja.add(dv);
					

				} else if (de instanceof IndexedCollection) {
					ja.add(convertToArray((IndexedCollection) de, loc, convType, raw));
				} else if (de instanceof KeyedCollection) {
					// ICBC 55938 BEGIN
					if(ICBCAjaxUtils.KEEP_ICOLL_STRUCTURE){
						JSONObject arrayEle = new JSONObject();
						arrayEle.put(de.getName(), convertToJson((KeyedCollection) de, loc, convType, raw));
						ja.add(arrayEle);
					// ICBC 55938 END
					}else{
						ja.add(convertToJson((KeyedCollection) de, loc, convType, raw));
					}
				}
			}
		} catch (Exception e) {
			throw new IllegalArgumentException(e);
		}
		return ja;
	}
	
	
	/**
	 * Convert the indexed collection to JSONArray and keep the order of the attributes in JOSN the same as the elements in KeyedCollection
	 * 
	 * @param ic
	 *            the indexed collection
	 * @param loc locale info of the user
	 * @return the JSONArray
	 */
	public static JSONArray convertToOrderedArray(IndexedCollection ic,Locale loc, String convType) {
		JSONArray ja = new JSONArray(ic.size());
		try {
			for (int i = 0; i < ic.size(); i++) {
				DataElement de = ic.getElementAt(i);
				if (de instanceof DataField) {					
					DataField df = (DataField) de;
					Object dv = de.getValue();
					AbstractPropertyDescriptor descriptor = (AbstractPropertyDescriptor) df.getDescriptor();
					if (descriptor != null && loc!=null && dv!=null && !(dv instanceof Boolean)) {
						StringWriter sw = new StringWriter();
						descriptor.formatToWriter(de.getValue(), convType, sw,	loc, df.getParameters());
						dv = sw.toString();
					} 
					if (dv instanceof String[]) {
						String[] strArray = (String[])dv;
						JSONArray ja2 = new JSONArray(strArray.length);
						for (String str : strArray)
							ja2.add(str);
						dv = ja2;
					} 
					if(dv != null && !(dv instanceof Number) && !(dv instanceof Boolean) &&!(dv instanceof String)) {
						dv = dv.toString();
					}					
					ja.add(dv);
				} else if (de instanceof IndexedCollection) {
					ja.add(convertToOrderedArray((IndexedCollection) de, loc, convType));
				} else if (de instanceof KeyedCollection) {
					ja.add(convertToOrderedJson((KeyedCollection) de, loc, convType));
				}
			}
		} catch (Exception e) {
			throw new IllegalArgumentException(e);
		}
		return ja;
	}	

	/**
	 * Convert the JSONObject to KeyedCollection 
	 * 
	 * @param jo
	 *            the JSONObject
	 * @return the converted JSON object
	 */
	public static KeyedCollection convertToKeyedCollection(JSONObject jo) {
		return convertToKeyedCollection(jo, null);
	}
	
	/**
	 * Convert the JSONObject to KeyedCollection in flat format
	 * @param jo
	 * @return
	 */
	public static KeyedCollection convertToFlatKeyedCollection(JSONObject jo) {
		return parseRequestDataToFlat(convertToKeyedCollection(jo));
	}
	
	/**
	 * Parse KeyedCollection in RequestData into flat format
	 * @param keyedData
	 * @return
	 */
	private static KeyedCollection parseRequestDataToFlat(KeyedCollection keyedData) {
		Hashtable ht = keyedData.calculeNestedQualifiedElements();
		KeyedCollection resultKColl = new KeyedCollection();
		for (Enumeration enu = ht.keys(); enu.hasMoreElements();){
			String qualifiedName = (String) enu.nextElement();
			
			try {
				DataElement de = (DataElement) keyedData.getElementAt(qualifiedName);
	
				if (de instanceof DataField){
					de.setName(qualifiedName);
					resultKColl.addElement(de);
				}
			} catch (DSEObjectNotFoundException e) {
				if (logger.doError())
					logger.error("Error when get element from request data:", e);
			}
		}
		return resultKColl;
	}

	/**
	 * * Convert the keyed collection to JSONObject
	 * 
	 * @param kc
	 *            the keyed collection
	 * @return the converted JSON object
	 */
	public static KeyedCollection convertToKeyedCollection(JSONObject jo, String name) {
		KeyedCollection kc = new KeyedCollection();
		kc.setName(name);

		Set joKeys = jo.keySet();
		for (Object key : joKeys) {
			Object obj = jo.get(key);
			if (obj instanceof JSONArray) {
				kc.addElement(convertToIndexedCollection((JSONArray) obj, (String) key));
			} else if (obj instanceof JSONObject) {
	  
					if(key.toString().indexOf(Constants.dot) < 0)
						kc.addElement(convertToKeyedCollection((JSONObject) obj, (String) key));
					else {
						Hashtable ht = convertToKeyedCollection((JSONObject) obj, (String) key).calculeNestedQualifiedElements();
						for (Enumeration enu = ht.keys(); enu.hasMoreElements();){
							String qualifiedName = (String) enu.nextElement();
							DataElement de = (DataElement)ht.get(qualifiedName);
							if (de instanceof DataField){ 
								de.setName(key + "." + qualifiedName);
								kc.addElement(de);
							}
						}
					}
				
			} else {
				DataField field = new DataField();
				field.setName((String) key);
				
				//TODO ICBC
				try {
					if (obj instanceof String) {
						if (((String) obj).startsWith(OBJECT_CACHE)) {
							obj= string2Object((String)obj);
						} else if (((String) obj).startsWith("[")) {
							String temp= (String)obj;
					
							obj= SimpleElementManager.getInstance().convert(temp.substring(temp.indexOf(']') + 1), 
									temp.substring(1, temp.indexOf(']')));
						}
					} 
					
					
				} catch (Exception e) {
					throw new IllegalArgumentException(e);
				}
				
				try {
					field.setValue(obj);
				} catch (DSEInvalidArgumentException e) {
					throw new IllegalArgumentException(e);
				}
				kc.addElement(field);
			}

		}

		return kc;
	}

	/**
	 * Convert the indexed collection to JSONArray
	 * 
	 * @param ic
	 *            the indexed collection
	 * @return the JSONArray
	 */
	public static IndexedCollection convertToIndexedCollection(JSONArray ja) {
		return convertToIndexedCollection(ja, null);
	}

	/**
	 * Convert the indexed collection to JSONArray
	 * 
	 * @param ic
	 *            the indexed collection
	 * @return the JSONArray
	 */
	public static IndexedCollection convertToIndexedCollection(JSONArray ja, String name) {
		IndexedCollection ic = new IndexedCollection();
		ic.setName(name);

		for (int i = 0; i < ja.size(); i++) {
			Object jo = ja.get(i);
			if (jo instanceof JSONObject) {
				// ICBC 55938 BEGIN
				if(ICBCAjaxUtils.KEEP_ICOLL_STRUCTURE){
					JSONObject jsobj = (JSONObject) jo;
					// ICOLL can only nest a field or a collection, never both
					String kcName = (String) jsobj.keySet().iterator().next();
					// get the nested object to check the instance
					Object obj = jsobj.get(kcName);
					if (obj instanceof JSONObject) {
						KeyedCollection rowEle = convertToKeyedCollection((JSONObject)obj, kcName);
						ic.addElement(rowEle);
					}else{
						convertNestedElements(ic, obj);
					}
				// ICBC 55938 END
				}else{
					ic.addElement(convertToKeyedCollection((JSONObject) jo));
				}
			} else {
				convertNestedElements(ic, jo);
			}
		}
		return ic;
	}

	private static void convertNestedElements(IndexedCollection ic, Object jo) {
		if (jo instanceof JSONArray) {
			ic.addElement(convertToIndexedCollection((JSONArray) jo));
		} else {
			DataField field = new DataField();
			try {
				field.setValue(jo);
			} catch (DSEInvalidArgumentException e) {
				throw new IllegalArgumentException(e);
			}
			ic.addElement(field);
		}
	}
	
	//Specially for G021
	public static KeyedCollection convertToKeyedCollection2(JSONObject jo, String name) {
		KeyedCollection kc = new KeyedCollection();
		kc.setName(name);

		Set joKeys = jo.keySet();
		for (Object key : joKeys) {
			Object obj = jo.get(key);
			if (obj instanceof JSONArray) {
				kc.addElement(convertToIndexedCollection((JSONArray) obj, (String) key));
			} else if (obj instanceof JSONObject) {
				//check if it is special jsonStr like  myList:{"0":{"c1":"aaaaa"},"1":{"c1":"aaaaa"}}  which should be treated as iColl
				boolean iColflag=true;
				Set objKeys=((JSONObject)obj).keySet();
				for (Object objKey: objKeys){
					try {
					 if (objKey!=null)  //objKey are numbers for special json 
						 Integer.parseInt(objKey.toString());
					}catch (Exception e){
						iColflag=false;
						break;
					}
				}
				
				if (iColflag){
					IndexedCollection ic = new IndexedCollection();
					ic.setName(key.toString());
					 
					for (Object objKey: objKeys){ //objKey are numbers
						Object listItemJson = ((JSONObject)obj).get(objKey);
						KeyedCollection  listKc=convertToKeyedCollection2((JSONObject) listItemJson, objKey.toString());
						ic.addElement(listKc);
					}
					kc.addElement(ic);
				}else {  
					if(key.toString().indexOf(Constants.dot) < 0)
						kc.addElement(convertToKeyedCollection2((JSONObject) obj, (String) key));
					else {
						Hashtable ht = convertToKeyedCollection2((JSONObject) obj, (String) key).calculeNestedQualifiedElements();
						for (Enumeration enu = ht.keys(); enu.hasMoreElements();){
							String qualifiedName = (String) enu.nextElement();
							DataElement de = (DataElement)ht.get(qualifiedName);
							if (de instanceof DataField){ 
								de.setName(key + "." + qualifiedName);
								kc.addElement(de);
							}
						}
					}
				}
			} else {
				DataField field = new DataField();
				field.setName((String) key);
				try {
					field.setValue(obj);
				} catch (DSEInvalidArgumentException e) {
					throw new IllegalArgumentException(e);
				}
				kc.addElement(field);
			}

		}

		return kc;
	}
	
	protected static String object2String(Object o) throws IOException {
		if (null == o) {
			return "";
		}
		return OBJECT_CACHE + Base64.encode(object2ByteArray(o));
	}

	protected static Object string2Object(String s) throws IOException,
			ClassNotFoundException {
		if (null == s || s.isEmpty()) {
			return null;
		}
		
		return ByteArray2Object(Base64.decode(s.substring(OBJECT_CACHE.length())));
	}

	protected static byte[] object2ByteArray(Object o) throws IOException {
		ByteArrayOutputStream baos = null;
		ObjectOutputStream oos = null;
		try {
			baos = new ByteArrayOutputStream();
			oos = new ObjectOutputStream(baos);
			oos.writeObject(o);
			oos.flush();
			return baos.toByteArray();
		} finally {
			oos.close();
			baos.close();
		}
	}

	protected static Object ByteArray2Object(byte[] byteArray)
			throws IOException, ClassNotFoundException {
		ByteArrayInputStream bais = null;
		ObjectInputStream ois = null;
		try {
			bais = new ByteArrayInputStream(byteArray);
			ois = new ObjectInputStream(bais);
			return ois.readObject();
		} finally {
			bais.close();
			ois.close();
		}
	}

}