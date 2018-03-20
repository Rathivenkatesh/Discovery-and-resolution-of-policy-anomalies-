package com.logics;

import java.io.FileInputStream;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.SessionAware;
import com.accesspolicy.AccessPolicyEnforcementPoint;
import com.opensymphony.xwork2.ActionSupport;

public class Resources extends ActionSupport implements SessionAware{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	String resource,action,subject,condition;
	
	SessionMap<String, Object> sessionmap;
	
	public void setResource(String resource) {
		this.resource = resource;
	}
	public void setAction(String action) {
		this.action = action;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getResource(){
		return resource;
	}
	public String getAction(){
		return action;
	}
	public String getSubject(){
		return subject;
	}	
	public String getPolicyname(){
		return "Policy Enforcement Point Input File:";
	}
	public String getCondition() {
		return condition;
	}
	public void setCondition(String condition) {
		this.condition = condition;
	}
	public String getDefaultvalue(){
		return "8:00<=Time<=17:00";
	}
	
	public String getValues(){
		 resource=ServletActionContext.getRequest().getParameter("status").toString();
	     action=ServletActionContext.getRequest().getParameter("action").toString();
	     subject=sessionmap.get("username").toString()+"@"+sessionmap.get("designation").toString();
	     return SUCCESS;		
	}
	
	public String execute(){
		try{
			
			Calendar cal = Calendar.getInstance();
	    	cal.getTime();
	    	SimpleDateFormat a = new SimpleDateFormat("HH:mm:ss");
	    	int currenttime=totalsec(a.format(cal.getTime()).toString());
	    	int condition1a=totalsec("8:00:00");

	    	int condition1b=totalsec("17:00:00");

	    	int condition2a=totalsec("12:00:00");

	    	int condition2b=totalsec("13:00:00");
	    	
	    	if((condition2a<=currenttime)&&(condition2b>=currenttime))
	    	{
	    		condition="12:00<=Time<=13:00";
//	    		System.out.println("----------------deny-----------------");
	    	}
	    	else
	    		if((condition1a<=currenttime)&&(condition1b>=currenttime))
	    		{
	    			condition="8:00<=Time<=17:00";
//		    		System.out.println("----------------allow-----------------");
	    		}
	    	System.out.println("time sending issssssssss------------------>"+condition);
	    	
			AccessPolicyEnforcementPoint objPEP=new AccessPolicyEnforcementPoint();
			objPEP.main(sessionmap.get("username").toString(),subject, resource, action,condition.replace("<=", ""));
			FileInputStream fis=new FileInputStream(sessionmap.get("username").toString()+"_Request.xacml");
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
	int totalsec(String a)
	{
		String currenttime=a;
    	StringTokenizer str=new StringTokenizer(currenttime,":");
    	int hr=Integer.parseInt(str.nextToken());
    	int min=Integer.parseInt(str.nextToken());
    	int sec=Integer.parseInt(str.nextToken());
    	int curtiminsec=sec+(min*60)+(hr*60*60);
    	return curtiminsec;
	}
	public void setSession(Map<String, Object> map) {
		// TODO Auto-generated method stub
		sessionmap=(SessionMap<String, Object>) map;
	}

}
