/*

 * Created on Sep 15, 2004
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.accesspolicy;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

import org.apache.struts2.jasper.tagplugins.jstl.core.Out;

import com.sun.xacml.Policy;
import com.sun.xacml.PolicySet;
import com.sun.xacml.Rule;
import com.sun.xacml.Target;
import com.sun.xacml.TargetMatch;
import com.sun.xacml.attr.AnyURIAttribute;
import com.sun.xacml.attr.AttributeDesignator;
import com.sun.xacml.attr.AttributeValue;
import com.sun.xacml.attr.StringAttribute;
import com.sun.xacml.combine.CombiningAlgFactory;
import com.sun.xacml.combine.DenyOverridesRuleAlg;
import com.sun.xacml.combine.FirstApplicablePolicyAlg;
import com.sun.xacml.combine.PermitOverridesRuleAlg;
import com.sun.xacml.combine.PolicyCombiningAlgorithm;
import com.sun.xacml.combine.RuleCombiningAlgorithm;
import com.sun.xacml.cond.Apply;
import com.sun.xacml.cond.Function;
import com.sun.xacml.cond.FunctionFactory;
import com.sun.xacml.ctx.Result;
import com.sun.xml.rpc.processor.modeler.j2ee.xml.string;

/**
 * @author Administrator
 * 
 *         To change the template for this generated type comment go to
 *         Window>Preferences>Java>Code Generation>Code and Comments
 */
public class AccessPolicy {

	public static TargetMatch createTargetMatch(int type, String functionId,
			AttributeDesignator designator, AttributeValue value) {
		try {
			// get the factory that handles Target functions and get an
			// instance of the right function
			FunctionFactory factory = FunctionFactory.getTargetInstance();
			Function function = factory.createFunction(functionId);

			// create the TargetMatch
			return new TargetMatch(type, function, designator, value);
		} catch (Exception e) {
			return null;
		}
	}

	public static Target createPolicyTarget() throws URISyntaxException {
		List subjects = new ArrayList();
		List resources = new ArrayList();

		// create the Subject section
		List subject = new ArrayList();

		String subjectMatchId = "urn:oasis:names:tc:xacml:1.0:function:rfc822Name-match";

		URI subjectDesignatorType = new URI(
				"urn:oasis:names:tc:xacml:1.0:data-type:rfc822Name");
		URI subjectDesignatorId = new URI(
				"urn:oasis:names:tc:xacml:1.0:subject:subject-id");
		// new URI("subject-id");
		AttributeDesignator subjectDesignator = new AttributeDesignator(
				AttributeDesignator.SUBJECT_TARGET, subjectDesignatorType,
				subjectDesignatorId, false);

		StringAttribute subjectValue = new StringAttribute("secf.com");

		subject.add(createTargetMatch(TargetMatch.SUBJECT, subjectMatchId,
				subjectDesignator, subjectValue));

		// create the Resource section
		List resource = new ArrayList();

		String resourceMatchId = "urn:oasis:names:tc:xacml:1.0:function:anyURI-equal";

		URI resourceDesignatorType = new URI(
				"http://www.w3.org/2001/XMLSchema#anyURI");
		URI resourceDesignatorId = new URI(
				"urn:oasis:names:tc:xacml:1.0:resource:resource-id");
		AttributeDesignator resourceDesignator = new AttributeDesignator(
				AttributeDesignator.RESOURCE_TARGET, resourceDesignatorType,
				resourceDesignatorId, false);

		AnyURIAttribute resourceValue = new AnyURIAttribute(new URI(
				"http://localhost:9999"));

		resource.add(createTargetMatch(TargetMatch.RESOURCE, resourceMatchId,
				resourceDesignator, resourceValue));

		// put the Subject and Resource sections into their lists
		subjects.add(subject);
		resources.add(resource);

		// create & return the new Target
		return new Target(null, null, null);
	}

	public static Target createRuleTarget(String subject, String resource,String action)
			throws URISyntaxException {
		
		List subjects = new ArrayList();
		List resources = new ArrayList();
		List actions = new ArrayList();

		String sub[] = subject.split(",");
		for (int i = 0; i < sub.length; i++) {
			// create the Subject section
			List subjectlist = new ArrayList();

			String subjectMatchId = "urn:oasis:names:tc:xacml:1.0:function:rfc822Name-match";

			URI subjectDesignatorType = new URI(
					"urn:oasis:names:tc:xacml:1.0:data-type:rfc822Name");
			URI subjectDesignatorId = new URI(
					"urn:oasis:names:tc:xacml:1.0:subject:subject-id");
			// new URI("subject-id");
			AttributeDesignator subjectDesignator = new AttributeDesignator(
					AttributeDesignator.SUBJECT_TARGET, subjectDesignatorType,
					subjectDesignatorId, false);

			StringAttribute subjectValue = new StringAttribute(sub[i]);

			subjectlist.add(createTargetMatch(TargetMatch.SUBJECT,
					subjectMatchId, subjectDesignator, subjectValue));
			subjects.add(subjectlist);
		}
		String res[] = resource.split(",");
		for (int i = 0; i < res.length; i++) {

			// create the Resource section
			List resourcelist = new ArrayList();

			String resourceMatchId = "urn:oasis:names:tc:xacml:1.0:function:anyURI-equal";

			URI resourceDesignatorType = new URI(
					"http://www.w3.org/2001/XMLSchema#anyURI");
			URI resourceDesignatorId = new URI(
					"urn:oasis:names:tc:xacml:1.0:resource:resource-id");
			AttributeDesignator resourceDesignator = new AttributeDesignator(
					AttributeDesignator.RESOURCE_TARGET,
					resourceDesignatorType, resourceDesignatorId, false);

			AnyURIAttribute resourceValue = new AnyURIAttribute(new URI(
					res[i]));

			resourcelist.add(createTargetMatch(TargetMatch.RESOURCE,
					resourceMatchId, resourceDesignator, resourceValue));

			// put the Subject and Resource sections into their lists
			resources.add(resourcelist);
		}

		
		String act[]=action.split(",");
		for(int i=0;i<act.length;i++)
		{
			// create the Action section
			List actionlist = new ArrayList();
	
			String actionMatchId = "urn:oasis:names:tc:xacml:1.0:function:string-equal";
	
			URI actionDesignatorType = new URI(
					"http://www.w3.org/2001/XMLSchema#string");
			URI actionDesignatorId = new URI(
					"urn:oasis:names:tc:xacml:1.0:action:action-id");
			AttributeDesignator actionDesignator = new AttributeDesignator(
					AttributeDesignator.ACTION_TARGET, actionDesignatorType,
					actionDesignatorId, false);
	
			StringAttribute actionValue = new StringAttribute(act[i]);
	
			actionlist.add(createTargetMatch(TargetMatch.ACTION, actionMatchId,
					actionDesignator, actionValue));
	
			// put the Action section in the Actions list
			actions.add(actionlist);
		}

		// create & return the new Target
		return new Target(subjects, resources, actions);
	}

	public static Apply createRuleCondition(String rule) throws URISyntaxException 
	{
		List conditionArgs = new ArrayList();

		// get the function that the condition uses
		FunctionFactory factory = FunctionFactory.getConditionInstance();
		Function conditionFunction = null;
		try 
		{
			conditionFunction = factory
					.createFunction("urn:oasis:names:tc:xacml:1.0:function:"
							+ "string-equal");
		}
		catch (Exception e) 
		{
			// see comment in createTargetMatch()
			return null;
		}

		// now create the apply section that gets the designator value
		List applyArgs = new ArrayList();

		factory = FunctionFactory.getGeneralInstance();
		Function applyFunction = null;
		try 
		{
			applyFunction = factory
					.createFunction("urn:oasis:names:tc:xacml:1.0:function:"
							+ "string-one-and-only");
		}
		catch (Exception e)
		{
			// see comment in createTargetMatch()
			return null;
		}

		URI designatorType = new URI("http://www.w3.org/2001/XMLSchema#string");
		URI designatorId = new URI("group");
		AttributeDesignator designator = new AttributeDesignator(
				AttributeDesignator.SUBJECT_TARGET, designatorType,
				designatorId, false, null);
		applyArgs.add(designator);

		Apply apply = new Apply(applyFunction, applyArgs, false);

		// add the new apply element to the list of inputs to the condition
		conditionArgs.add(apply);
		
		
		// create an AttributeValue and add it to the input list
		StringAttribute value = new StringAttribute(rule);
		conditionArgs.add(value);

		// finally, create & return our Condition
		return new Apply(conditionFunction, conditionArgs, true);
	}

	public static List createRules(String status) throws URISyntaxException {
		// define the identifier for the rule
		List ruleList = new ArrayList();
		if(status.equals("Deny-Overrides"))
		{
			//Rule 1
			URI ruleId1 = new URI("r1");
			// define the effect for the Rule
			int effect1 = Result.DECISION_DENY;
						
			String subject = "Designer,Tester";
			String resource = "Reports,Codes";
			String action="Change";

			// get the Target for the rule
			Target target1 = createRuleTarget(subject,resource,action);

			// get the Condition for the rule
			Apply condition1 = createRuleCondition("12:00Time13:00");

			Rule openRule1 = new Rule(ruleId1, effect1, null, target1, condition1);
			ruleList.add(openRule1);
			//Rule 2			
			URI ruleId2 = new URI("r2");
			// define the effect for the Rule
			int effect2 = Result.DECISION_DENY;
						
			subject = "Tester";
			resource = "Reports,Codes";
			action="Change";

			// get the Target for the rule
			Target target2 = createRuleTarget(subject,resource,action);

			// get the Condition for the rule
			Apply condition2 = createRuleCondition("12:00Time13:00");

			Rule openRule2 = new Rule(ruleId2, effect2, null, target2, condition2);
			ruleList.add(openRule2);
			
		}
		
		else if(status.equals("Permit-Overrides"))
		{
			
		// Rule 1 permit-overrides		
			URI ruleId1 = new URI("r1");
			// define the effect for the Rule
			int effect1 = Result.DECISION_PERMIT;
						
			String subject = "Tester,Developer,Designer,Manager";
			String resource = "Reports,Codes";
			String action="Change,Read";

			// get the Target for the rule
			Target target1 = createRuleTarget(subject,resource,action);

			// get the Condition for the rule
			Apply condition1 = createRuleCondition("8:00Time17:00");

			Rule openRule1 = new Rule(ruleId1, effect1, null, target1, condition1);
			ruleList.add(openRule1);
		
		
			//Rule 2			
			URI ruleId2 = new URI("r2");
			// define the effect for the Rule
			int effect2 = Result.DECISION_PERMIT;
						
			subject = "Developer,Manager";
			resource = "Reports,Codes";
			action="Change,Read";

			// get the Target for the rule
			Target target2 = createRuleTarget(subject,resource,action);

			// get the Condition for the rule
			Apply condition2 = createRuleCondition("12:00Time13:00");

			Rule openRule2 = new Rule(ruleId2, effect2, null, target2, condition2);
			ruleList.add(openRule2);
			
			//Rule 3			
			URI ruleId3 = new URI("r3");
			// define the effect for the Rule
			int effect3 = Result.DECISION_PERMIT;
						
			subject = "Designer";
			resource = "Reports,Codes";
			action="Read";

			// get the Target for the rule
			Target target3 = createRuleTarget(subject,resource,action);

			// get the Condition for the rule
			Apply condition3 = createRuleCondition("12:00Time13:00");

			Rule openRule3 = new Rule(ruleId3, effect3, null, target3, condition3);
			ruleList.add(openRule3);
		}
		// create a list for the rules and add the rule to it
		return ruleList;
	} 

	public static void policy(String status) throws Exception {
		// define the identifier for the AccessPolicy
		
		if(status.equals("PolicySet")){
			String process="Deny-Overrides,Permit-Overrides";
			String p[]=process.split(",");
			URI policysetId = new URI("PS1");
			URI combiningAlgIdSet= new URI(FirstApplicablePolicyAlg.algId);
			CombiningAlgFactory factoryset = CombiningAlgFactory.getInstance();
			PolicyCombiningAlgorithm combiningAlgset = (PolicyCombiningAlgorithm) (factoryset
					.createAlgorithm(combiningAlgIdSet));
			String descriptionset = "This AccessPolicy set applies to the designer,developer and all IT peoples"
				+ "accessing Resources like Codes,Reports and all";
			
			List policies=new ArrayList();
			for(int i=0;i<p.length;i++){
				//System.out.println("---------"+i);
				URI policyId = new URI("p"+Integer.toString(i+1));				
				// get the combining algorithm for the AccessPolicy
				URI combiningAlgId = null;
				if(p[i].equals("Deny-Overrides")){
					combiningAlgId= new URI(DenyOverridesRuleAlg.algId);
				}
				else{
					combiningAlgId= new URI(PermitOverridesRuleAlg.algId);
				}
				CombiningAlgFactory factory = CombiningAlgFactory.getInstance();
				RuleCombiningAlgorithm combiningAlg = (RuleCombiningAlgorithm) (factory
						.createAlgorithm(combiningAlgId));
	
				// add a description for the AccessPolicy
				String description = "This AccessPolicy set applies to the designer,developer and all IT peoples"
						+ "accessing file:http://localhost:9999";
	
				// create the target for the AccessPolicy
				Target policyTarget = createPolicyTarget();
	
				// create rules
				List ruleList = createRules(p[i]);
	
				// create the AccessPolicy
				Policy policy = new Policy(policyId, combiningAlg, description,
						policyTarget, ruleList);
				
				// finally, encode the AccessPolicy and print it to standard out
				//policy.encode(System.out, new Indenter());
				policies.add(policy);

	     	}
			//System.out.println("---------entered policyset-----");
			Target policyTarget = createPolicyTarget();
			PolicySet policyset=new PolicySet(policysetId, combiningAlgset,descriptionset,policyTarget, policies);
			final File f=new File("PolicySet.xacml");
			final FileOutputStream out=new FileOutputStream(f);	
			policyset.encode(new java.io.OutputStream() {					
				@Override
				public void write(int b) throws IOException {
					// TODO Auto-generated method stub
					out.write(b);			
				}
			});	
			out.close();			
		}
		else
		{
	
		URI policyId = new URI("p1");
		
		// get the combining algorithm for the AccessPolicy
		URI combiningAlgId = null;
		if(status.equals("Deny-Overrides"))
		{
			combiningAlgId= new URI(DenyOverridesRuleAlg.algId);
			
		}
		else
		{
			combiningAlgId= new URI(PermitOverridesRuleAlg.algId);
		}
		System.out.println("----accesspolicy.java-----combiningalid----------"+combiningAlgId); 
		CombiningAlgFactory factory = CombiningAlgFactory.getInstance();
		RuleCombiningAlgorithm combiningAlg = (RuleCombiningAlgorithm) (factory
				.createAlgorithm(combiningAlgId));

		// add a description for the AccessPolicy
		String description = "This AccessPolicy applies to any account at secf.com "
				+ "accessing file:http://localhost:9999";

		// create the target for the AccessPolicy
		Target policyTarget = createPolicyTarget();

		// create rules
		List ruleList = createRules(status);

		// create the AccessPolicy
		Policy policy = new Policy(policyId, combiningAlg, description,
				policyTarget, ruleList);
		
		// finally, encode the AccessPolicy and print it to standard out
		//policy.encode(System.out, new Indenter());
		final String file=status+".xacml";
		final FileOutputStream out=new FileOutputStream(file);		
		policy.encode(new java.io.OutputStream() {
			@Override
			public void write(int b) throws IOException {
				// TODO Auto-generated method stub
				out.write(b);			
			}
		});		
		out.close();

	 }
	}

}
