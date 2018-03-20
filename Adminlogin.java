package com.logics;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.SessionAware;

import sampljweb.FrameWork;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class Adminlogin extends ActionSupport implements SessionAware{
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
	
	public String execute()
	{
		try
		{
			HttpServletRequest request = (HttpServletRequest) ActionContext.getContext().get(ServletActionContext.HTTP_REQUEST);
			FrameWork fr=new FrameWork();
			if(fr.getVal(request))
			{
			Statement st=(Statement)(ServletActionContext.getServletContext().getAttribute("connection"));
			ResultSet rs=st.executeQuery("select * from xacml_admin where username='"+username+"' and password='"+password+"'");
			if(rs.next()){
				sessionMap.put("username", username);
				String geopoint=rs.getString("geopoint1");
				if(geopoint==null){
					System.out.println("---Register the Points---");
					return "registerpoints";
				}
				
			}
			else{
				addActionError("Invalid Username and Password!!!");
				return ERROR;
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
