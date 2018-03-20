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
  
<!--  $(document).ready(function(){-->
<!--  			-->
<!--  		});-->
  
  <script>
  
  $(document).ready(function(){
  		$("#divhide").hide();
  		});
  function repfunc(rep)
  {
  
  $(document).ready(function(){
  		$("#tablehide").fadeOut();
  		$("#divhide").fadeIn(2000);
  		});
  
  	var newlabel=document.createElement("Label");
  	newlabel.setAttribute("style","float:left;");
  	newlabel.innerHTML="&nbsp;&nbsp;&nbsp;"+rep;
  
  	
  	
  	var readhref=document.createElement("a");
  	readhref.setAttribute("href","resources?status="+rep+"&action=Read")
  	readhref.innerHTML="Read";
  	
  	var changehref=document.createElement("a");
  	changehref.setAttribute("href","resources?status="+rep+"&action=Change")
  	changehref.innerHTML="Change"; 	
  	
  	var divid=document.getElementById("divhide");
  	divid.appendChild(newlabel);
  	divid.appendChild(document.createElement("br"));
  	divid.appendChild(document.createElement("br"));
  	divid.appendChild(readhref);
  	divid.appendChild(document.createElement("br"));
  	divid.appendChild(document.createElement("br"));
  	divid.appendChild(changehref);
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

			<div id="menu">&nbsp; 
			  	<br><ul>
					<li><a href="chome">Home</a></li>
					<li><a href="#">Update Profile</a></li>
      				<li><a href="policyset">Policy Set</a></li>
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
				<h3  style="font-size: 18px; color: Black">&nbsp;&nbsp;&nbsp;Designation:&nbsp;&nbsp;<s:property value="#session.designation"/></h3>
				<h3  style="font-size: 16px; color: Black">&nbsp;&nbsp;&nbsp;Resources Available:</h3>
			
				<table align="center" id="tablehide">				
					<tr><td><label class="lab1" style="color:blue;" onclick="repfunc('Reports')">Reports</label></td></tr>
									<tr><td><br></td></tr>
					<tr><td><label class="lab1" style="color:blue;" onclick="repfunc('Codes')">Codes</label></td></tr>	
								<tr><td><br></td></tr>	
					<tr><td><s:actionmessage/></td></tr>					
				</table>
				<br/>
				<center>
					<div style="height:160px;width:200px;color:Blue;font-size:18px;float:left;" id="divhide">
						
					</div>	
				</center>
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

