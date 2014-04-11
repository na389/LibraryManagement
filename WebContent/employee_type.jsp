<%@page import="idbproj.LibraryServlet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="idbproj.DBConnectionManager" %>
<%@ page import=" java.sql.ResultSet" %>
<%@ page import=" java.sql.Statement" %>
<%

ServletContext ctx = getServletContext();
DBConnectionManager dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
Statement stmt = dbManager.getConnection().createStatement();
String libSelected = request.getParameter(LibraryServlet.libSelected);
ResultSet rset = stmt.executeQuery("Select * from Employee where SSN IN (Select SSN from Works_at where Location IN (Select Location from Library where name = \'"+libSelected+"\') )");
%>
<html> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"> 
<title>Employee Table</title> 
</head> 
<body> 
 <H2>Employee Table</H2> 
 <TABLE> 
 <tr> 
 <td>First Name</td><td>Last Name</td> 
 </tr> 
 <tr> 
 <td><b>----------</b></td><td><b>----------</b></td>
 </tr> 
 <% 
 if(rset != null) { 
 while(rset.next()) { 
 out.print("<tr>"); 
 out.print("<td>" + rset.getString("First_name") + "</td><td>" + 
rset.getString("Last_name") + "</td>");  
 out.print("</tr>"); 
 } 
 } else { 
 out.print("Technical Error!!!"); 
 } 
 %> 
 </TABLE> 
</body> 
</html>
