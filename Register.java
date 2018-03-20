package com.logics;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import sampljweb.FrameWork;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class Register extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	ArrayList<String> designationList;
	String username,password,cpassword,email,mobile,designation;
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
	public String getCpassword() {
		return cpassword;
	}
	public void setCpassword(String cpassword) {
		this.cpassword = cpassword;
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
	public String getDesignation() {
		return designation;
	}
	public void setDesignation(String designation) {
		this.designation = designation;
	}
	public ArrayList<String> getDesignationList() {
		return designationList;
	}
	public String getDefaultvalue() {
		return "Designer";
	}
	
	public Register(){
		designationList=new ArrayList<String>();
		designationList.add("Developer");
		designationList.add("Tester");
		designationList.add("Designer");
		designationList.add("Manager");		
	}
	public String display()
	{
		return NONE;
	}
	public void validate(){
		if(username.length()<1){
			addFieldError("Error", "Please Enter the Username!!!");			
		}
		else if(password.length()<1){
			addFieldError("Error", "Please Enter the Password!!!");
		}
		else if(cpassword.length()<1){
			addFieldError("Error", "Please Enter the Confrom Password!!!");
		}
		else if(email.length()<1){
			addFieldError("Error", "Please Enter the Email-ID!!!");
		}
		else if(mobile.length()<1){
			addFieldError("Error", "Please Enter the MobileNO!!!");
		}		
		else if(!password.equals(cpassword)){
			addFieldError("Error", "Password Mismatches!!!");
		}
		else if(!email.contains("@")){
			addFieldError("Error", "Mail Id Is Not Valid");
		}
		else if(mobile.length()<10){
			addFieldError("Error", "Mobile No Is Not Valid");
		}
		else if(mobile.length()>10){
			addFieldError("Error", "Mobile No Is Not Valid");
		}
		else if(!password.equals(cpassword))
		{
			addFieldError("Error", "Password Mismatch!!");
		}
		else if(username.matches(".*\\d.*"))
		{
			addFieldError("Error", "Please Enter the Valid Username!!!");
		}
		
	}
	public String execute()
	{		
		ServletContext sc=ServletActionContext.getServletContext();
		Statement st=(Statement)(sc.getAttribute("connection"));
		try
		{
			HttpServletRequest request = (HttpServletRequest) ActionContext.getContext().get(ServletActionContext.HTTP_REQUEST);
			FrameWork fr=new FrameWork();
			if(fr.getVal(request))
			{
			ResultSet rs=st.executeQuery("select * from xacml_register where username='"+username+"'");
			if(rs.next())
			{
				addFieldError("Error", "User Name Allready Exists!!");
			}
			else
			{
				st.execute("insert into xacml_register values('"+username+"','"+password+"','"+designation+"','"+email+"','"+mobile+"','requested')");					
				addActionMessage("Registered Successfully!!!");
			}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
				
		return SUCCESS;
	}

}
