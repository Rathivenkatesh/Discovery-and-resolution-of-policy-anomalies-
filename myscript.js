	var signature="";
	var count=0;
	var combindSignature="";
	var check=0;
	var isIE;
	var completeTable;
	var completeField;
	var autorow;
	var status=false;
	var xmlhttp = false;
	var date;

	function functionCall(signature) {
		count = count+1;	
			combindSignature += signature+"/";
			//check=1;
			alert("BOOKED TICKETS - "+combindSignature);
			document.getElementById("sign").value = combindSignature;
	}
	
	function GetXmlHttpObject()
	{
		if (window.XMLHttpRequest) {   
			xmlhttp = new XMLHttpRequest(); 
		}
		else if(window.ActiveXObject) {  
			try {     
				xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");  
			} catch (e) {   
				try {     
					xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");   
				} catch (e) { 
					xmlhttp = false;   
				} 
			}   
		} 
	return xmlhttp; 
	}
	
	function AJAXInteractiondate(url) {
		req=GetXmlHttpObject();
		req.onreadystatechange = processRequestdate;
		req.open("GET", url, true);
		req.send(null);
	}
	
	function processRequestdate () {
		if (req.readyState == 4) {
			if (req.status == 200) {
				postProcessdate(req.responseXML);
			}
			 else {
        			alert("Error during AJAX call. Please try again");
     		}
		}
	}
	
	function initRequest() {
		var url = "DisplayDate?";
		var ajax = new AJAXInteractiondate(url);
	}
	
	
	
	function postProcessdate(responseXML) {
		var employees = responseXML.getElementsByTagName("employees")[0];
		for (loop = 0; loop < employees.childNodes.length; loop++) {
			var employee = employees.childNodes[loop]
			date = employee.getElementsByTagName("date")[0];
			appendEmployeedate(date.childNodes[0].nodeValue); 
		}
	}
	
	function appendEmployeedate(date) {
		alert(date);		
		setTimeout("initRequest()",7000);
	}
	
	function callme(){
		setTimeout("refresh()",20000);
	}
	
	function refresh() {
		document.sampForm.action="imageLogin.jsp";
		document.sampForm.submit();
	}
	