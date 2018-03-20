package com.logics;

import java.io.FileInputStream;
import com.opensymphony.xwork2.ActionSupport;

public class Policyset extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	String policyname;
	
	public String getPolicyname() {
		return "Policy Set";
	}

	public String execute(){
		try{
		FileInputStream fis=new FileInputStream("PolicySet.xml");
		byte b[]=new byte[fis.available()];
		fis.read(b);
		fis.close();
		addActionMessage(new String(b));
		}
		catch(Exception e){
			e.printStackTrace();
		}		
		return SUCCESS;
	}
}
