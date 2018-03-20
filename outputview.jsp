<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Xacml</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="description" content="Your Website Description" />
<meta name="keywords" content="keywords, go, here" />
<link href="style.css" rel="stylesheet" type="text/css" media="screen" />
 <script src="jquery/jquery-1.9.1.js"></script>
  <script src="jquery/jquery-ui.js"></script>
  <script>
  	  $(document).ready(function(){
  		  if("<s:property value="status"/>"=="Permit!!!"){
  		  
  		  if("<s:property value="action"/>"=="Read")
	  		{
  			  $("#editid").hide();
  			  $("#updateid").hide();
  			  $("#cancelid").hide()
		  }
  		  else
  			  {
  			  	$("#editid").show();
  			  	$("#updateid").hide();
  		    	$("#cancelid").hide()
  			  }  		 
  		  }
  		  else{
  				$("#editid").hide();
  			  	$("#textidd").hide();
  			  	$("#updateid").hide();
  			    $("#cancelid").hide()
  		  }
  		  });
  	  
  	  
  	  function call()
  	  {
  		  document.getElementById("textidd").removeAttribute('disabled');   		  
  		  $("#textidd").focus();
  		  $("#updateid").show();
  		  $("#cancelid").show()
  		   
  	  }
  	  
  	  function onsub()
  	  {  		 
  		  document.f.action="update?resource=<s:property value="resource"/>";
  		  document.f.submit();
  	  }
  	  
  </script>
<SCRIPT type="text/javascript">
    window.history.forward();
    function noBack() { window.history.forward(); }
</SCRIPT>
</head>

<body onload="noBack()">
	<div class="content">
		<div id="top">
			<div class="topright">
			 	<a href="#"><img src="images/sitemap.png" alt="Sitemap" /></a> ^
			 	<a href="#"><img src="images/rss.png" alt="RSS" /></a>
			</div>
		</div>
		<div id="header">
			<div class="headings">
				<h1>Discovery of Anomalies </h1>
				<h2>Using XACML Authorization</h2>
			</div>
		</div>
			<div id="menu">
			  	<ul>
					<li><a href="chome">Client Home</a></li>
					<li><a href="#">Update Profile</a></li>					
      				<li><a href="#">Register</a></li>
      				<li><a href="#">Contact Us</a></li>
      			</ul>
			</div>
		<div id="main">
			<div class="right">
				<div class="nav">
				<h2><a href="logout">LogOut</a></h2>
				<div class="text">
			You could use this space to display the latest news, a calendar, random photos, the choice is yours, its here if you need it.
				</div>
				<h2>More Links?</h2>
					<ul>
						<li><a href="http://www.openwebdesign.org">OWD</a></li>
						<li><a href="http://www.designcreek.com">DesignCreek</a></li>
						<li><a href="#">Link.three</a></li>
						<li><a href="#">Link.four</a></li>
					</ul>
				</div>
			</div>
			<div class="left">
				<h2>Welcome <s:property value="#session.username"/></h2>
				
			<div class="img_left"><img src="images/img.jpg" alt="" /></div>			
			<br/>
			<br/>
			<s:form name="f">
				<h3  style="font-size: 18px; color: Black">&nbsp;&nbsp;&nbsp;Resources:&nbsp;<s:property value="resource"/>&nbsp;&nbsp;&nbsp;Action:&nbsp;<s:property value="action"/>&nbsp;&nbsp;&nbsp;<a onclick="call()" style="cursor:pointer" id="editid">Edit Online</a></h3>
				<s:textarea id="textidd" rows="25" cols="50" name="output" disabled="true"/><br/><br/>	
				<center><LABEL style="font-size: 18px; color:Red" ><s:actionmessage/></LABEL></center>		
				<center><a onclick="onsub()" style="font-size: 18px; color:Red; cursor:pointer" id="updateid">Update</a>&nbsp;&nbsp;&nbsp;<a style="font-size: 18px; color:Red; cursor:pointer" id="cancelid" onclick="window.location.reload()"">Cancel</a></center>
				</s:form>
				<br/>			
			</div>
		</div>

		<div id="footer">
			<div class="info">
				<br />
				Site Design - <a href="http://www.designcreek.com">DesignCreek</a>
			</div>
		</div>
	</div>
</body>
</html>

