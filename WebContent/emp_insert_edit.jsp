<%@page import="idbproj.LibraryServlet"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map.Entry"%>
<%@ page import="idbproj.DBConnectionManager"%>
<%@ page import=" java.sql.ResultSet"%>
<%@ page import=" java.sql.Statement"%>
<%@ page import=" java.sql.SQLException" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="calendar.css" type="text/css" rel="stylesheet" />
<script src="calendar.js" type="text/javascript"></script>
<script type="text/javascript">
	function init() {
		calendar.set("insertSince");
		calendar.set("updateSince");
	}

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

	function validateUpdate() {
		//

		var q = document.forms["update"]["updateempSSN"].value;
		if (q == null || q == "") {
			alert("SSN mandatory for update");
			return false;
		} else {
			if (isNaN(q)) {
				alert("SSN should be a number");
				return false;
			}
			if (q.length != 9) {
				alert("SSN should be of length 9");
				return false;
			}
		}
		
		var c = document.forms["update"]["updateSince"].value;

		if (c == null || c == "") {
			//alert("Start working date mandatory");
			//return false;
		} else {

			var validformat = /^\d{4}\-\d{2}\-\d{2}$/;

			if (!validformat.test(c)) {
				alert("Invalid Date Format. Please correct and submit again.");
				document.forms["update"]["updateSince"].focus();
				return false;
			} else {

				var yearfield = c.split("-")[0];
				var monthfield = c.split("-")[1];
				var dayfield = c.split("-")[2];

				var dateToCompare = new Date(yearfield, monthfield - 1,
						dayfield);
				var currentDate = new Date();
				//alert(">>>>>>>>>"+dayobj.getMonth()+">>"+dayobj.getDate()+">>"+dayobj.getFullYear());
				if (dateToCompare > currentDate) {
					alert("Date Entered is greater than Current Date ");
					return false;
				} 

			}
		}
		

	}

	function validateForm() {
		//var a=document.getElementById("empType").value;

		var x = document.forms["insert"]["firstName"].value;
		if (x == null || x == "") {
			alert("First name must be filled out");
			return false;
		}
		var y = document.forms["insert"]["lastName"].value;
		if (y == null || y == "") {
			alert("Last name must be filled out");
			return false;
		}
		var z = document.forms["insert"]["empSSN"].value;
		if (z == null || z == "") {
			alert("SSN must be filled out");
			return false;
		} else {
			if (z.length != 9) {
				alert("SSN should be of length 9");
				return false;
			}
			if (isNaN(z)) {
				alert("SSN should be a number");
				return false;
			}

		}

		

				
		var r = document.forms["insert"]["insertSince"].value;

		if (r == null || r == "") {
			alert("Start working date mandatory");
			return false;
		} else {

			var validformat = /^\d{4}\-\d{2}\-\d{2}$/;

			if (!validformat.test(r)) {
				alert("Invalid Date Format. Please correct and submit again.");
				document.forms["insert"]["insertSince"].focus();
				return false;
			} else {

				var yearfield = r.split("-")[0];
				var monthfield = r.split("-")[1];
				var dayfield = r.split("-")[2];

				var dateToCompare = new Date(yearfield, monthfield - 1,
						dayfield);
				var currentDate = new Date();
				//alert(">>>>>>>>>"+dayobj.getMonth()+">>"+dayobj.getDate()+">>"+dayobj.getFullYear());
				if (dateToCompare > currentDate) {
					alert("Date Entered is greater than Current Date ");
					return false;
				} 

			}
		}

		
		var e = document.getElementById("empType");
		var a = e[e.selectedIndex].value;
		if (a == "-1") {
		    alert("Select Employee Type");
			return false;
		}else{
			if (a == "1") {
				
			    if (document.getElementById("insertEmpSalary").value == null || document.getElementById("insertEmpSalary").value == "") {
		            alert("Enter Salary!!");
		            return false;
		        }
		    }else if(a == "2"){
		    	var g = document.getElementById("insertEmpWage");
		        if (g[g.selectedIndex].value == null || g[g.selectedIndex].value.value == "-1") {
		            alert("Enter Wage!!");
		            return false;
		        }
		    }
		}

		
	}

	//Code to retrieve Location for a library
	function showLocationInsert(value) {

		//alert("Here");
		if (document.getElementById("libNameSelected").value != "-1") {
			xmlHttp = GetXmlHttpObject();
			if (xmlHttp == null) {
				alert("Browser does not support HTTP Request");
				return;
			}

			var url = "get_lib_loc.jsp";
			url = url + "?updatelibSel=" + value;

			xmlHttp.onreadystatechange = stateChangedInsert;
			xmlHttp.open("GET", url, true);
			xmlHttp.send(null);
		} else {
			alert("Please Select Library");
		}
	}
	function showLocation(name_value) {

		if (document.getElementById("updatelibSel").value != "-1") {
			xmlHttp = GetXmlHttpObject();
			if (xmlHttp == null) {
				alert("Browser does not support HTTP Request");
				return;
			}

			var url = "get_lib_loc.jsp";
			url = url + "?updatelibSel=" + name_value;

			xmlHttp.onreadystatechange = stateChanged;
			xmlHttp.open("GET", url, true);
			xmlHttp.send(null);
		} else {
			alert("Please Select Library");
		}
	}

	function stateChanged() {
		document.getElementById("libLocSelected").value = "";
		document.getElementById("location").value = "";
		if (xmlHttp.readyState == 4 || xmlHttp.readyState == "complete") {

			var showdata = xmlHttp.responseText;
			var strar = showdata.split(":");
			//alert(strar[2]);
			if (showdata == null) {
				document.getElementById("location").focus();
				alert("Please Select Library");
				document.getElementById("location").value = " ";
			} else {
				document.getElementById("location").value = strar[2];
			}

		} else {
			//alert("I've been called");
		}

	}

	function stateChangedInsert() {
		document.getElementById("libLocSelected").value = "";
		if (xmlHttp.readyState == 4 || xmlHttp.readyState == "complete") {

			var showdata = xmlHttp.responseText;
			var strar = showdata.split(":");
			//alert(strar[2]);
			if (showdata == null) {
				document.getElementById("libLocSelected").focus();
				alert("Please Select Library");
				document.getElementById("libLocSelected").value = " ";
			} else {
				document.getElementById("libLocSelected").value = strar[2];
			}

		} else {
			//alert("I've been called");
		}

	}

	function GetXmlHttpObject() {
		var xmlHttp = null;
		try {
			// Firefox, Opera 8.0+, Safari
			xmlHttp = new XMLHttpRequest();
		} catch (e) {
			//Internet Explorer
			try {
				xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
		}
		return xmlHttp;
	}

	function alertError(value) {
		alert(value);
	}
</script>

<style type="text/css">

html {
	text-align: center;
}
body{
background-color:#CCFF66;
}
</style>

</head>
<body onload="init()">
	
<img border="0" src="images/lib-mng.jpg" alt="Welcome Image" width="1500" height="228"><br/>
<h1>Employee Management Portal</h1>
	<ul>
		<li><a href="javascript:activateTab('page1')">Insert Employee</a></li>
		<li><a href="javascript:activateTab('page2')">Update Employee</a></li>
		<li><a href="javascript:activateTab('page3')">Delete Employee</a></li>
	</ul>	
	<div id="tabCtrl">

		<div id="page1" style="display: block;">
			<%
			try{
				ServletContext ctx = getServletContext();
					DBConnectionManager dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
					if(dbManager!=null && dbManager.getConnection()!=null){
					Statement stmt = dbManager.getConnection().createStatement();
					ResultSet rset = stmt.executeQuery("Select name, location from Library");
					HashMap<String, String> libList = new HashMap<String,String>();
					if(rset!=null){
						while(rset.next()){
							libList.put(rset.getString("name"), rset.getString("location"));
						}
					}
			%>


			<form name="insert" method="post"
				action="EmployeeServlet?operation=insert"
				onsubmit="return validateForm()" style="margin: auto;">
				Select Library: <select name="libNameSelected" id="libNameSelected"
					onchange="showLocationInsert(this.value);">
					<option value="-1">Select Library Name</option>
					<%
						for(Entry<String,String> entry : libList.entrySet()){
					%>
					<option value="<%=entry.getKey()%>"><%=entry.getKey()%></option>
					<%
						}
					%>
				</select> <br /> Select Employee Type: <select name="empType" id="empType">
					<option value="-1">Select Employee Type</option>
					<option value="1">Permanent Employee</option>
					<option value="2">Temporary Employee</option>
				</select> <br />
				<table style="margin: auto;">
					<tr>
						<td>Location:</td>
						<td><input type="text" name="libLocSelected"
							id="libLocSelected" value="" readonly="readonly"/></td>
					</tr>
					<tr>
						<td>First Name:</td>
						<td><input type="text" name="firstName" /><br /></td>
					</tr>
					<tr>
						<td>Last Name:</td>
						<td><input type="text" name="lastName" /><br /></td>
					</tr>
					<tr>
						<td>SSN:</td>
						<td><input type="text" name="empSSN" /><br /></td>
					</tr>
					<tr>
						<td>Working Since (YYYY-MM-DD):</td>
						<td><input type="text" name="insertSince" id="insertSince" /><br /></td>
					</tr>
					<!-- <tr><td>Working Location:</td><td> <input type="text" name="insetLocation"/><br/></td></tr>-->
					<tr>
						
						<td>Wage:						
						<select name="insertEmpWage" id="insertEmpWage">
							<option value="-1">Select Wage</option>
							<option value="40">40</option>
							<option value="60">60</option>
						</select></td>
					</tr>
					<tr>
						<td>Salary:</td>
						<td><input type="text" name="insertEmpSalary"
							id="insertEmpSalary" /><br /></td>
					</tr>
					<tr>
						<td><input type="submit" value="Submit"></td>
					</tr>
				</table>

			</form>

		</div>
		<div id="page2" style="display: none;">

			<form name="update" method="post"
				action="EmployeeServlet?operation=update" style="margin: auto;"
				onsubmit="return validateUpdate()">
				Choose Library: <select name="updatelibSel" id="updatelibSel"
					onchange="showLocation(this.value);">
					<option value="-1">Select Library Name</option>
					<%
						for(Entry<String,String> entry : libList.entrySet()){
					%>
					<option value="<%=entry.getKey()%>"><%=entry.getKey()%></option>

					<%
						}
					%>

				</select> <br /> <br />
				<table style="margin: auto;">
					<tr>
						<td>Location:</td>
						<td>						   
						<input type="text" name="location" id="location"  value="" readonly="readonly"/></td>
					</tr>
					<tr>
						<td>First Name:</td>
						<td><input type="text" name="updatefirstName" /><br /></td>
					</tr>
					<tr>
						<td>Last Name:</td>
						<td><input type="text" name="updatelastName" /><br /></td>
					</tr>
					<tr>
						<td>SSN:</td>
						<td><input type="text" name="updateempSSN" /><br /></td>
					</tr>
					<tr>
						<td>Working Since (YYYY-MM-DD):</td>
						<td><input type="text" name="updateSince" id="updateSince" /><br /></td>
					</tr>
					<tr>
						<td><input type="submit" value="Submit"></td>
					</tr>
				</table>

			</form>



		</div>
		<div id="page3" style="display: none;">
			<form name="delete" method="post"
				action="EmployeeServlet?operation=delete" style="margin: auto;">
				<table style="margin: auto;">
					<tr>
						<td>Enter SSN for deletion:</td>
						<td><input type="text" name="deleteEmpSSN" /><br /></td>
					</tr>
					<tr>
						<td><input type="submit" value="Submit"></td>
					</tr>
				</table>
			</form>
		</div>
		
		<%
			}else{	
					
		    				System.out.println("Connection Time Out");
		%>
		<script>
			alertError("Connection Time Out");
		</script>
		<%
			}
			}catch(SQLException e){
				%>
				<script>
					alertError("DB Broke!!");
				</script>
				<%	
			}
			catch(Exception e){
				%>
				<script>
					alertError("Needs Server Restart");
				</script>
				<%	
			}
		%>
	</div>
</body>
</html>