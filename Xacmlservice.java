package com.webservices;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.StringTokenizer;

import com.accesspolicies.AccessPolicyDecisionPoint;

public class Xacmlservice 
{
	public String getRequest(String username,String requestfile,String policyfile)
	{
		System.out.println("-------Web Service Entered-------");
		byte b[] = null;
		AccessPolicyDecisionPoint objdecisionpoint=null;
		try
		{
			String args[]={requestfile,policyfile};
			objdecisionpoint=new AccessPolicyDecisionPoint();		
			objdecisionpoint.main(args,username);		    
			FileInputStream fis=new FileInputStream(username+"_Output.xacml");
			b=new byte[fis.available()];
			fis.read(b);
			fis.close();		
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return new String(b)+"@"+Integer.toString(objdecisionpoint.result.getDecision())+"@"+objdecisionpoint.result.getResource();
	}
	public String getFile(String resource)
	{
		byte b[]=null;
		if((resource.equals("Reports"))||(resource.equals("Codes")))
		{
			System.out.println("--File Request received in Web Service---");		
			try
			{
				FileInputStream fis=new FileInputStream("webapps/XacmlServices/Resources/"+resource+".java");
				b=new byte[fis.available()];
				fis.read(b);
				fis.close();
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}     
		}
		else
		{
			try
			{
				StringTokenizer stk=new StringTokenizer(resource,"@@");
				String filename=stk.nextToken();
				String file=stk.nextToken();			
				FileOutputStream fos=new FileOutputStream("webapps/XacmlServices/Resources/"+filename+".java");
				fos.write(file.getBytes());
				fos.close();
				return "Success";
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		return new String(b);
	}
}
