<%@page import="idbproj.LibraryServlet"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map.Entry"%>
<%@ page import="idbproj.DBConnectionManager" %>
<%@ page import=" java.sql.ResultSet" %>
<%@ page import=" java.sql.Statement" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript">
	function activateTab(pageId) {
		var tabCtrl = document.getElementById('tabCtrl');
		var pageToActivate = document.getElementById(pageId);
		for (var i = 0; i < tabCtrl.childNodes.length; i++) {
			var node = tabCtrl.childNodes[i];
			if (node.nodeType == 1) { /* Element */
				node.style.display = (node == pageToActivate) ? 'block'
						: 'none';
			}
		}
	}
	
	function validateForm()
	{
	var x=document.forms["insert"]["firstName"].value;
	if (x==null || x=="")
	  {
	  alert("First name must be filled out");
	  return false;
	  }
	var y=document.forms["insert"]["lastName"].value;
	if (y==null || y=="")
	  {
	  alert("Last name must be filled out");
	  return false;
	  }
	var z=document.forms["insert"]["empSSN"].value;
	if (z==null || z=="")
	  {
	  alert("SSN must be filled out");
	  return false;
	  }
	var p=document.forms["insert"]["insetLocation"].value;
	if (p==null || p=="")
	  {
	  alert("Wokring Location must be filled out");
	  return false;
	  }
	var r=document.forms["insert"]["insertSince"].value;
	if (r==null || r=="")
	  {
	  alert("Start working date mandatory");
	  return false;
	  }
	var q=document.forms["update"]["updateempSSN"].value;
	if (q==null || q=="")
	  {
	  alert("SSN mandatory for update");
	  return false;
	  }	
	
	}
	
	
	//Code to retrieve Location for a library
	function showLocationInsert(value){
		if(document.getElementById("libNameSelected").value!="-1")
        {
 			xmlHttp=GetXmlHttpObject();
			if (xmlHttp==null)
 			{
 				alert ("Browser does not support HTTP Request");
				return;
 			}
			
			var url="get_lib_loc.jsp";
			url=url+"?updatelibSel="+value;
			
			xmlHttp.onreadystatechange=stateChangedInsert; 
			xmlHttp.open("GET",url,true);
			xmlHttp.send(null);
        }
        else
        {
                 alert("Please Select Library");
        }
	}
	function showLocation(name_value)
	{ 
		
        if(document.getElementById("updatelibSel").value!="-1")
        {
 			xmlHttp=GetXmlHttpObject();
			if (xmlHttp==null)
 			{
 				alert ("Browser does not support HTTP Request");
				return;
 			}
			
			var url="get_lib_loc.jsp";
			url=url+"?updatelibSel="+name_value;
			
			xmlHttp.onreadystatechange=stateChanged; 
			xmlHttp.open("GET",url,true);
			xmlHttp.send(null);
        }
        else
        {
                 alert("Please Select Library");
        }
	}

function stateChanged() 
{ 
		document.getElementById("libLocSelected").value ="";
        document.getElementById("location").value ="";        
		if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete")
 		{ 
			
  			var showdata = xmlHttp.responseText;   			
    		var strar = showdata.split(":");
    		//alert(strar[2]);
         	if(showdata==null)
         	{
                document.getElementById("location").focus();
                alert("Please Select Library");                
        		document.getElementById("location").value =" ";
         	}
         	else
         	{        		
        		document.getElementById("location").value= strar[2];        		
         	}
        
 } else{
	 //alert("I've been called");
 }
		
}

function stateChangedInsert() 
{ 
		document.getElementById("libLocSelected").value ="";
		if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete")
 		{ 
			
  			var showdata = xmlHttp.responseText;   			
    		var strar = showdata.split(":");
    		//alert(strar[2]);
         	if(showdata==null)
         	{
                document.getElementById("libLocSelected").focus();
                alert("Please Select Library");                
        		document.getElementById("libLocSelected").value =" ";
         	}
         	else
         	{        		
        		document.getElementById("libLocSelected").value= strar[2];        		
         	}
        
 } else{
	 //alert("I've been called");
 }
		
}

function GetXmlHttpObject()
{
var xmlHttp=null;
try
 {
 // Firefox, Opera 8.0+, Safari
 xmlHttp=new XMLHttpRequest();
 }
catch (e)
 {
 //Internet Explorer
 try
  {
  xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
  }
 catch (e)
  {
  xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
 }
return xmlHttp;
}
	
</script>

<style type="text/css">
select{
	font-size: 20px;
}
</style>

</head>
<body>
	<h1>Employee Management Portal</h1>
	<ul>
		<li><a href="javascript:activateTab('page1')">Insert Employee</a></li>
		<li><a href="javascript:activateTab('page2')">Update Employee</a></li>
	</ul>
	<div id="tabCtrl">
	
		<div id="page1" style="display: block;">
		<% 
				
				ServletContext ctx = getServletContext();
				DBConnectionManager dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
				if(dbManager.getConnection()!=null){
				Statement stmt = dbManager.getConnection().createStatement();
				ResultSet rset = stmt.executeQuery("Select name, location from Library");
				HashMap<String, String> libList = new HashMap<String,String>();
				if(rset!=null){
					while(rset.next()){
						libList.put(rset.getString("name"), rset.getString("location"));
					}
				}
			%>
			
						
		<form name = "insert" method = "post" action="EmployeeServlet?operation=insert" onsubmit="return validateForm()">
			Select Library:
			<select name="libNameSelected"  id="libNameSelected" onchange="showLocationInsert(this.value);">
				<option value="-1">Select Library Name</option>
   			 	<%for(Entry<String,String> entry : libList.entrySet()){%>   			 		
        			<option value="<%=entry.getKey()%>"><%=entry.getKey()%></option>
    			<%} %>
			</select>
			<br/>		
			<table>
			<tr><td>Location:</td><td><input type="text" name="libLocSelected" id="libLocSelected" value=""/></td></tr>
			<tr><td>First Name:</td><td> <input type="text" name="firstName"/><br/></td></tr>
			<tr><td>Last Name:</td> <td><input type="text" name="lastName"/><br/></td></tr>
			<tr><td>SSN: </td><td><input type="text" name="empSSN"/><br/></td></tr>
			
			<!-- <tr><td>Working Location:</td><td> <input type="text" name="insetLocation"/><br/></td></tr> -->			
			<tr><td>Working Since (YYYY-MM-DD): </td><td><input type="text" name="insertSince"/><br/></td></tr>
			<tr><td><input type="submit" value="Submit"></td></tr>
			</table>
			
		</form>			
		
		</div>
		<div id="page2" style="display: none;">
		
		<form name = "update" method = "post" action="EmployeeServlet?operation=update">
			Choose Library:
			<select  name = "updatelibSel" id="updatelibSel" onchange="showLocation(this.value);">
				<option value="-1">Select Library Name</option>
   			 	<%for(Entry<String,String> entry : libList.entrySet()){ %>   			 		
        			<option value="<%=entry.getKey()%>"><%=entry.getKey()%></option>
        			
    			<%} 
    				
    			%>
    			
			</select>
			<br/>
			<table>
			<tr><td>Location:</td><td><input type="text" name="location" id="location" value=""/></td></tr>
			<tr><td>First Name:</td><td> <input type="text" name="updatefirstName"/><br/></td></tr>
			<tr><td>Last Name:</td> <td><input type="text" name="updatelastName"/><br/></td></tr>
			<tr><td>SSN: </td><td><input type="text" name="updateempSSN"/><br/></td></tr>
			<tr><td>Working Since (YYYY-MM-DD): </td><td><input type="text" name="updateSince"/><br/></td></tr>
			<tr><td><input type="submit" value="Submit"></td></tr>
			</table>
			
		</form>
			<%}else{
    				System.out.println("Connection Time Out");	
    			} %>	
		
			
		</div>
	</div>
</body>
</html>