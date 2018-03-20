package com.logics;

import java.io.FileInputStream;
import org.apache.struts2.ServletActionContext;
import com.accesspolicy.AccessPolicy;
import com.opensymphony.xwork2.ActionSupport;

public class Policy extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;	
	String policyname;
	
	public String getPolicyname() {
		return policyname;
	}

	public String execute(){
		try	
		{
			String policy=ServletActionContext.getRequest().getParameter("policy").toString();
			System.out.println("-----policy.java-------"+policy);
			if(policy.equals("PolicySet"))
			{
				policyname=policy;	
				AccessPolicy.policy(policy);
				FileInputStream fis=new FileInputStream(policy+".xacml");
				byte b[]=new byte[fis.available()];
				fis.read(b);
				fis.close();
				policyname=policy;
				addActionMessage(new String(b));
			}
			else
			{
				AccessPolicy.policy(policy);
				FileInputStream fis=new FileInputStream(policy+".xacml");
				byte b[]=new byte[fis.available()];
				fis.read(b);
				fis.close();
				policyname=policy;
				addActionMessage(new String(b));
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}		
		return SUCCESS;
	}
}
