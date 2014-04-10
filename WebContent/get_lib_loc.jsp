<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="idbproj.DBConnectionManager" %>
<%@ page import=" java.sql.ResultSet" %>
<%@ page import=" java.sql.Statement" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	String  data ="";
	DBConnectionManager dbManager = (DBConnectionManager) getServletContext().getAttribute("DBManager");
	Statement stmt = dbManager.getConnection().createStatement();
	ResultSet rset= null;
	
	 rset = stmt.executeQuery("Select * from Library where name = '"+request.getParameter("updatelibSel").toString()+"'");
		System.out.println(">>>>>>>>>>>>>>>>>>>");
	
		while(rset.next()){
			data = ":"+rset.getString("location")+":";			
		}
	
	out.println(data);
 %>
</body>
</html>