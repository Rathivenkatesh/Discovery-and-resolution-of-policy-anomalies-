package com.logics;

import org.apache.struts2.ServletActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.services.XacmlserviceDelegate;
import com.services.XacmlserviceService;

public class Outputview extends ActionSupport{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	String status,resource,action,output;	
	XacmlserviceService objservice=new XacmlserviceService();
	XacmlserviceDelegate objdelegate=objservice.getXacmlservicePort();
	public String getOutput() {
		return output;
	}
	public String getResource() {
		return resource;
	}
	public String getAction() {
		return action;
	}
	public String getStatus() {
		return status;
	}

	public String execute()
	{
		 status=ServletActionContext.getRequest().getParameter("status").toString();		
		 System.out.println("-----STATUS---------------------------------"+status);
		 resource=ServletActionContext.getRequest().getParameter("resource").toString();
		 action=ServletActionContext.getRequest().getParameter("action").toString();
		 if(status.contains("Permit"))
		 {
			 output=objdelegate.getFile(resource);		
			 System.out.println("--------"+output);
		 }		 
		 else if(status.contains("Not Applicable"))
		 {
			 addActionMessage("Your "+action+" Action is Not Applicable to this Resource "+resource+"!!!!");
		 }		
		 else
		 {
			 addActionMessage("Your "+action+" Action is Denied to this Resource "+resource+"!!!!");
		 }
		return SUCCESS;
	}

}
