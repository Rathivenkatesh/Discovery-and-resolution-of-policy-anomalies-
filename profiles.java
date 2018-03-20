package com.logics;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.SessionAware;



import com.opensymphony.xwork2.ActionSupport;
import com.sun.xml.rpc.processor.modeler.j2ee.xml.string;

public class profiles extends ActionSupport implements SessionAware
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	SessionMap<String, Object> sessionMap;
	ArrayList<Object> all=new ArrayList<Object>();
	String username,designation,email,mobile;
	

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}


	public String getDesignation() {
		return designation;
	}


	public void setDesignation(String designation) {
		this.designation = designation;
	}


	public String getEmail() {
		return email;
	}


	public void setEmail(String email) {
		this.email = email;
	}


	public String getMobile() {
		return mobile;
	}


	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public ArrayList<Object> getAll() {
		return all;
	}


	public void setAll(ArrayList<Object> all) {
		this.all = all;
	}

	public String execute()
	{
//		System.out.println("----------eeeeeeeeeee----"+id);
		try
		{
			Statement st=(Statement)(ServletActionContext.getServletContext().getAttribute("connection"));
			ResultSet rs=st.executeQuery("select * from XACML_REGISTER where status='allow'");
			while(rs.next())
			{
				profiles emrq=new profiles();
				emrq.setUsername(rs.getString("USERNAME"));
				emrq.setDesignation(rs.getString("DESIGNATION"));
				emrq.setEmail(rs.getString("EMAIL"));
				emrq.setMobile(rs.getString("MOBILE"));
				all.add(emrq);
				
			}
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return SUCCESS;
	}
	
	

	public void setSession(Map<String, Object> map) {
		// TODO Auto-generated method stub
		sessionMap=(SessionMap<String, Object>) map;		
	}
}
