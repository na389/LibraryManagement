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
<title>Insert title here</title>
</head>
<body>
<%try{
	String  data ="";
	DBConnectionManager dbManager = (DBConnectionManager) getServletContext().getAttribute("DBManager");
	if(dbManager== null){
		%>
		<script type="text/javascript">
		alert("Connection Time Out!!");
		</script>
		<%
		return;
	}
	if(dbManager.getConnection() == null){
		
		%>
		<script type="text/javascript">
		alert("Connection Time Out!!");
		</script>
		<%
		return;
	}
	Statement stmt = dbManager.getConnection().createStatement();
	ResultSet rset= null;

	if(request.getParameter("empType") == null || request.getParameter("empType").isEmpty()){
		%>
		<script type="text/javascript">
		alert("Parameter Not passed!!");
		</script>
		<%
	return;
	}
	if(request.getParameter("empType").equals("1")){
		rset = stmt.executeQuery("Select * from Perm_Emp where name = '"+request.getParameter("empType").toString()+"'");
		System.out.println(">>>>>>>>>>>>>>>>>>>"+request.getParameter("empType"));	
		while(rset.next()){
			data = ":"+rset.getString("salary")+":";			
		}	
	}else if(request.getParameter("empType").equals("2")){
		rset = stmt.executeQuery("Select * from Temp_Emp where name = '"+request.getParameter("empType").toString()+"'");
		System.out.println("><<<<<<<<<<<"+request.getParameter("empType"));	
		while(rset.next()){
			data = ":"+rset.getString("wage")+":";			
		}	
	} 
	 
	System.out.println("data");
	out.println(data);
}catch (SQLException e) {
	e.printStackTrace();
%>
<script type="text/javascript">
alert("Error Occurred!!");
</script>
<%
}catch (Exception e) {
	e.printStackTrace();	
}
 %><script type="text/javascript">
alert("Error Occurred!!");
</script>
</body>
</html>