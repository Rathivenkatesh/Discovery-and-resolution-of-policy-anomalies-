package com.logics;

import org.apache.struts2.ServletActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.services.XacmlserviceDelegate;
import com.services.XacmlserviceService;

public class Updateresource extends ActionSupport{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	String output;
	public String getOutput() {
		return output;
	}
	public void setOutput(String output) {
		this.output = output;
	}
	public String execute(){
		XacmlserviceService objservice=new XacmlserviceService();
		XacmlserviceDelegate objdelegate=objservice.getXacmlservicePort();
		String resource=ServletActionContext.getRequest().getParameter("resource").toString();	
		System.out.println("--------"+output+"-------"+resource);
		objdelegate.getFile(resource+"@@"+output);
		System.out.println("-------File Updated Successfully-------");
		addActionMessage("File Updated Successfully");
		return SUCCESS;
	}

}
