package com.webservices;

import java.io.FileInputStream;
import com.accesspolicies.AccessPolicyDecisionPoint;

@javax.jws.WebService(targetNamespace = "http://webservices.com/", serviceName = "XacmlserviceService", portName = "XacmlservicePort", wsdlLocation = "WEB-INF/wsdl/XacmlserviceService.wsdl")
public class XacmlserviceDelegate {

	com.webservices.Xacmlservice xacmlservice = new com.webservices.Xacmlservice();

	public String getRequest(String username, String requestfile,
			String policyfile) {
		return xacmlservice.getRequest(username, requestfile, policyfile);
	}

	public String getFile(String resource) {
		return xacmlservice.getFile(resource);
	}

}