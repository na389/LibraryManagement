<%@page import="idbproj.LibraryServlet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="idbproj.DBConnectionManager" %>
<%@ page import=" java.sql.ResultSet" %>
<%@ page import=" java.sql.Statement" %>
<%@ page import=" java.sql.SQLException" %>
<html> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"> 
<style type="text/css">
html{
text-align: center;

}
body{
text-align: center;
}
</style>
<title>Employee Table</title> 
</head> 
<body> 
<%
try{
ServletContext ctx = getServletContext();
DBConnectionManager dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
if(dbManager==null ){
	%>
	<script type="text/javascript">
	alert("Connection Time out!!");</script>
	<% 
	return;
}
if(dbManager.getConnection() == null){
	%>
	<script type="text/javascript">
	alert("Connection Time out!!");</script>
	<% 
	return;
}
Statement stmt = dbManager.getConnection().createStatement();
String libSelected = request.getParameter(LibraryServlet.libSelected);
ResultSet rset2 = stmt.executeQuery("select * from Library where name = '"+libSelected+"'");
%>

<h2>Details of the library</h2>
<table style="margin: auto;" border="1">
<%while(rset2.next()){ %>
<tr><td>Name</td><td><%=rset2.getString("name") %></td></tr>
<tr><td>Employee Count</td><td><%=rset2.getString("emp_count") %></td></tr>
<tr><td>Book Count</td><td><%=rset2.getString("book_count") %></td></tr>
<%} %>
</table>
 <H2>Employee Table</H2> 
 <TABLE style="margin: auto;" border="1"> 
 <tr> 
 <td>First Name</td><td>Last Name</td> 
 </tr> 
 <tr> 
 <td><b>----------</b></td><td><b>----------</b></td>
 </tr> 
 <% 
 ResultSet rset = stmt.executeQuery("Select * from Employee where SSN IN (Select SSN from Works_at where Location IN (Select Location from Library where name = \'"+libSelected+"\') )");
 while(rset.next()) { 
 out.print("<tr>"); 
 out.print("<td>" + rset.getString("First_name") + "</td><td>" + 
rset.getString("Last_name") + "</td>");  
 out.print("</tr>"); 
 } 
}catch (SQLException e) {
	e.printStackTrace();			
%>
 </TABLE> 
<script>
alert("Error Occurred!!")
</script>
<%	
}catch (Exception e) {
	e.printStackTrace();
	%>
	<script>
	alert("Error Occurred!!")
	</script>
	<%		
}
 %> 

</body> 
</html>
