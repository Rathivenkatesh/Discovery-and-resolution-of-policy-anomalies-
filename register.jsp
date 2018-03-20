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
					<li><a href="home">Home</a></li>
					<li><a href="admin">Admin_Login</a></li>
					<li><a href="client">Client_Login</a></li>
      				<li><a href="register">New_Client</a></li>
      			</ul>
			</div>


		<div id="main">
			<div class="right">


				<div class="nav">
				<h2>Right Column</h2>
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
				<h2><a href="#">Registration:</a></h2>
				
			<div class="img_left"><img src="images/img.jpg" alt="" /></div>
			<table align="center">
						<s:form method="post" action="Register" >
						<tr><td><s:textfield name="username" label="User Name"/></td></tr>
									<tr><td><br></td></tr>
						<tr><td><s:password name="password" label="Password"/></td></tr>	
								<tr><td><br></td></tr>	
						<tr><td><s:password name="cpassword" label="Conform Password"/></td></tr>	
								<tr><td><br></td></tr>	
						<tr><td><s:radio list="designationList" name="designation" value="defaultvalue" label="Designation"/></td></tr>	
								<tr><td><br></td></tr>		
						<tr><td><s:textfield name="email" label="Email-Id"/></td></tr>	
								<tr><td><br></td></tr>	
						<tr><td><s:textfield name="mobile" label="Mobile"/></td></tr>	
								<tr><td><br></td></tr>					
						<tr><td></td><td><FONT color="red"><s:fielderror name="Error"/><s:actionerror/><s:actionmessage/></FONT></td></tr>					
															
						<tr><td>      </td><td><input type="submit" value="LogIn"></td></tr>
						</s:form>	
						</table> 
			</div>

		</div>

		<div id="footer">
			<div class="info">
				&copy; 2006 Your Site<br />
				Site Design - <a href="http://www.designcreek.com">DesignCreek</a>
			</div>
		</div>
	</div>
</body>
</html>

