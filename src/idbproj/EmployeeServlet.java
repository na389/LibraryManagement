package idbproj;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.ws.Response;

import oracle.jdbc.pool.OracleDataSource;
import sun.reflect.ReflectionFactory.GetReflectionFactoryAction;

/**
 * Servlet implementation class EmployeeServlet
 */

public class EmployeeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ServletContext ctx;


	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public EmployeeServlet() {
		super();
		
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		ctx = getServletContext();
       		
        String operationType = request.getParameter("operation");
        System.out.println(operationType);
        if(operationType.equalsIgnoreCase("insert")){     
        	System.out.println(request.getParameter("firstName"));
        	System.out.println("Insert");
        	insertEmployee(request, response, request.getParameter("firstName"), request.getParameter("lastName"), request.getParameter("empSSN"), request.getParameter("libNameSelected"), request.getParameter("libLocSelected"), request.getParameter("insertSince") );
        }else if(operationType.equalsIgnoreCase("update")){
        	System.out.println("Update");
        	updateEmployee(request, response, request.getParameter("updatefirstName"), request.getParameter("updatelastName"), request.getParameter("updateempSSN"), request.getParameter("updatelibSel"), request.getParameter("location"), request.getParameter("updateSince") );
        }
		

	}
	
	private void updateEmployee(HttpServletRequest request, HttpServletResponse response, String firstName,
			String lastName, String empSSN, String name, String location,
			String since) {

		PreparedStatement prpstmt = null;
		PrintWriter pw = null;
		try {
			//pw = new PrintWriter(response.getOutputStream());
			DBConnectionManager dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
			Statement stmt = dbManager.getConnection().createStatement();
			ResultSet rset = stmt.executeQuery("Select * from Employee where ssn = '"+empSSN+"'");
			while(!rset.next()){
				request.setAttribute("error", "Employee does not exist!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			if(empSSN!=null && !empSSN.isEmpty()){
				if((firstName!=null && !firstName.isEmpty())){
					prpstmt = dbManager.getConnection().prepareStatement("update Employee Set first_name = ?  where SSN = ?  ");
					prpstmt.setString(1, firstName);
					prpstmt.setInt(2, Integer.parseInt(empSSN));
					prpstmt.executeUpdate();
				}
				if(lastName!=null && !lastName.isEmpty()){
					prpstmt = dbManager.getConnection().prepareStatement("update Employee Set last_name = ? where SSN = ?  ");					
					prpstmt.setString(1, lastName);
					prpstmt.setInt(2, Integer.parseInt(empSSN));
					prpstmt.executeUpdate();
				}
				if(location!=null && !location.isEmpty()){
					prpstmt = dbManager.getConnection().prepareStatement("update Works_at Set location = ?, name = ? where SSN = ?  ");
					
					prpstmt.setString(1, location);
					prpstmt.setInt(3, Integer.parseInt(empSSN));
					prpstmt.setString(2, name);
					prpstmt.executeUpdate();
				}
				
				if(since!=null && !since.isEmpty()){
					prpstmt = dbManager.getConnection().prepareStatement("update Works_at Set since = to_date(?, 'yyyy-mm-dd') where SSN = ?  ");
					
					prpstmt.setDate(1, java.sql.Date.valueOf(since));
					prpstmt.setInt(2, Integer.parseInt(empSSN));
					//prpstmt.executeUpdate();
				}
				
				if(prpstmt.executeUpdate()>0){
					request.setAttribute("error", "Update Successful!!");
					request.getRequestDispatcher("error.jsp").forward(request, response);
				}else{
					request.setAttribute("error", "DB Broke!!");
					request.getRequestDispatcher("error.jsp").forward(request, response);
				}
				
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();			
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
		//pw.close();
		}
	
	}

	private void insertEmployee(HttpServletRequest request, HttpServletResponse response, String firstName,
			String lastName, String empSSN, String name, String location,
			String since) {
		PreparedStatement prpstmt;
		PrintWriter pw = null ;
		try {
			//pw = new PrintWriter(response.getOutputStream());
			DBConnectionManager dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
			Statement stmt = dbManager.getConnection().createStatement();
			ResultSet rset = stmt.executeQuery("Select * from Employee where ssn = "+empSSN);
			if(rset.next()){
				request.setAttribute("error", "Employee Already Exists!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			
			prpstmt = dbManager.getConnection().prepareStatement("insert into Employee values(?,?,?)");
			prpstmt.setString(1, firstName);
			prpstmt.setString(2, lastName);
			prpstmt.setString(3, empSSN);
			if(prpstmt.executeUpdate()>0){				
				prpstmt = dbManager.getConnection().prepareStatement("insert into Works_at values(?,?,?,?)");
				prpstmt.setString(1, empSSN);				
				prpstmt.setString(2, location);
				prpstmt.setString(3, name);
				prpstmt.setDate(4, java.sql.Date.valueOf(since));		
			}
			
			if(prpstmt.executeUpdate()>0){	
				request.setAttribute("error", "Employee inserted Successfully!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
			}else{
				request.setAttribute("error", "Oops let me see !!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			//pw.close();
		}
	}
	
}
