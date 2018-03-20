package com.services;

import java.util.Map;
import java.util.StringTokenizer;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.SessionAware;
import com.opensymphony.xwork2.ActionSupport;

public class Webservice extends ActionSupport implements SessionAware{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	SessionMap<String, Object> sessionmap;
	String status,resource,action;
	public String getPolicyname(){
		return "Policy Decision Point Output File:";
	}
	public String getStatus(){
		return status;
	}
	public String getResource(){
		return resource;
	}
	public String getAction(){
		return action;
	}
	
	public String execute()
	{
		action=ServletActionContext.getRequest().getParameter("action").toString();
		String username=sessionmap.get("username").toString();
		XacmlserviceService objservice=new XacmlserviceService();
		XacmlserviceDelegate objdelegate=objservice.getXacmlservicePort();
		String result=objdelegate.getRequest(username,username+"_Request.xacml" , "PolicySet.xacml");
		StringTokenizer stk=new StringTokenizer(result,"@");		
		addActionMessage(stk.nextToken());
		int check=Integer.parseInt(stk.nextToken());
		if(check==0){
			status="Permit!!!";			
		}
		else if(check==1){
			status="Deny!!!";
		}
		else if(check==3){
			status="Not Applicable!!!";
		}
		resource=stk.nextToken();
		
		return SUCCESS;
	}
	public void setSession(Map<String, Object> map) {
		// TODO Auto-generated method stub
		sessionmap=(SessionMap<String, Object>) map;		
	}
}
