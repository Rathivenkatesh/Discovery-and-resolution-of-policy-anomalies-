package com.logics;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Map;
import javax.servlet.ServletContext;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.SessionAware;
import com.opensymphony.xwork2.ActionSupport;

public class Clientlogin extends ActionSupport implements SessionAware {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	String username,password;
	SessionMap<String, Object> sessionMap;
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public void validate(){
		if(username.length()<1){
			addFieldError("Error", "Please Enter the Username!!!");
		}
		else if(password.length()<1){
			addFieldError("Error", "Please Enter the Password!!!");
		}
		
	}
	public String execute(){
		ServletContext sc=ServletActionContext.getServletContext();
		try{
			Statement st=(Statement)(sc.getAttribute("connection"));
			ResultSet rs=st.executeQuery("select * from xacml_register where username='"+username+"' and password='"+password+"'");
			if(!rs.next())
			{
				addActionError("Invalid username and Password!!!!");
				return ERROR;
			}	
			else
			{
				String status=rs.getString("status");
				if(!status.equalsIgnoreCase("allow"))
				{
					addActionError("Your Details Were Under Verification!!!!");
					return ERROR;
				}
				else
				{
					sessionMap.put("username", rs.getString("username"));
					sessionMap.put("designation", rs.getString("designation"));		
					
				}		
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
