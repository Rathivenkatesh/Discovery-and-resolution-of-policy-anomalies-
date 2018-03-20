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
					<li><a href="ahome">Home</a></li>
					<li><a href="profiles">Profiles</a></li>
      				<li><a href="requests">Requests</a></li>
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
				<h3  style="font-size: 18px; color: Black">&nbsp;&nbsp;&nbsp;XACML Policies:</h3><table align="center">							
					<tr><td><a href="policy?policy=Deny-Overrides">Deny-Overrides</a></td></tr>
									<tr><td><br></td></tr>
						<tr><td><a href="policy?policy=Permit-Overrides">Permit-Overrides</a></td></tr>	
								<tr><td><br></td></tr>	
						<tr><td><a href="policy?policy=PolicySet">Complete PolicySet</a></td></tr>	
								<tr><td><br></td></tr>	
					
				</table>			
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

