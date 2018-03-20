package com.accesspolicies;

/*
 * Created on Sep 16, 2004
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */


import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import com.sun.xacml.PDP;
import com.sun.xacml.PDPConfig;
import com.sun.xacml.ctx.RequestCtx;
import com.sun.xacml.ctx.ResponseCtx;
import com.sun.xacml.ctx.Result;
import com.sun.xacml.finder.PolicyFinder;
import com.sun.xacml.finder.impl.FilePolicyModule;

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class AccessPolicyDecisionPoint {
	public Result result;
	/**
		* Evaluates the given request and returns the Response that the PDP
		* will hand back to the PEP.
		*
		* @param requestFile the name of a file that contains a Request
		*
		* @return the result of the evaluation
		*
		* @throws IOException if there is a problem accessing the file
		* @throws ParsingException if the Request is invalid
		*/
	public  void main(String[] args,final String username) throws Exception {
		// Step 1: Get the request and policy file from the command line
		String requestFile = null;

		requestFile = args[0];
		String[] policyFiles = new String[args.length - 1];

		for (int i = 1; i < args.length; i++)
			policyFiles[i - 1] = args[i];
		// Create a PolicyFinderModule and initialize it
		// Use the sample FilePolicyModule which
		// is configured using the policies given from the command line

		FilePolicyModule filePolicyModule = new FilePolicyModule();
		for (int i = 0; i < policyFiles.length; i++)
			filePolicyModule.addPolicy(policyFiles[i]);

		// Step 2: Setup the PolicyFinder that this PDP will use
		//
		PolicyFinder policyFinder = new PolicyFinder();
		Set policyModules = new HashSet();
		policyModules.add(filePolicyModule);
		policyFinder.setModules(policyModules);

		// create the PDP
		PDP pdp = new PDP(new PDPConfig(null, policyFinder, null));

		RequestCtx request =
			RequestCtx.getInstance(new FileInputStream(requestFile));

		// evaluate the request
		ResponseCtx response = pdp.evaluate(request);	
		
		// for this sample program, we'll just print out the response
		final FileOutputStream out=new FileOutputStream(username+"_Output.xacml");	
		response.encode(new OutputStream() {				
			@Override
			public void write(int b) throws IOException {
				// TODO Auto-generated method stub
				out.write(b);
			}
		});	
		out.close();
		
		Collection myCollection = new HashSet();
        myCollection = response.getResults();
        result=(Result)myCollection.toArray()[0];    
	}
	
}
