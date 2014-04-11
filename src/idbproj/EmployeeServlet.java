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
        	insertEmployee(request, response, request.getParameter("firstName"), request.getParameter("lastName"), request.getParameter("empSSN"),
        			request.getParameter("libNameSelected"), request.getParameter("libLocSelected"), request.getParameter("insertSince"),  
        			request.getParameter("insertEmpWage"),  request.getParameter("insertEmpSalary"), request.getParameter("empType") );
        }else if(operationType.equalsIgnoreCase("update")){
        	System.out.println("Update");
        	updateEmployee(request, response, request.getParameter("updatefirstName"), request.getParameter("updatelastName"),
        			request.getParameter("updateempSSN"), request.getParameter("updatelibSel"), request.getParameter("location"), request.getParameter("updateSince") );
        }else if(operationType.equalsIgnoreCase("delete")){ 
        	deleteEmployee(request, response, request.getParameter("deleteEmpSSN"));
        }
		

	}
	
	private void deleteEmployee(HttpServletRequest request,
			HttpServletResponse response, String empSSN) {
		PreparedStatement prpstmt = null;
		try {
			DBConnectionManager dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
			if(dbManager == null){
				request.setAttribute("error", "Connection Time Out!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			if(dbManager.getConnection()==null){
				request.setAttribute("error", "Connection Time Out!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			
			dbManager.getConnection().setAutoCommit(false);

			Statement stmt = dbManager.getConnection().createStatement();
			ResultSet rset = stmt.executeQuery("Select * from Employee where ssn = '"+empSSN+"'");
			while(!rset.next()){
				request.setAttribute("error", "Employee does not exist!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			
			prpstmt = dbManager.getConnection().prepareStatement("delete from employee where SSN = ?");
			prpstmt.setInt(1, Integer.parseInt(empSSN));
			int op1 = prpstmt.executeUpdate(); 
			if(op1>0){
				request.setAttribute("error", "Employee deleted successfully!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				dbManager.getConnection().commit();
			}else{
				request.setAttribute("error", "Error!!!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
			}
			
		}catch(SQLException e){
			e.printStackTrace();
			errorOccurred(request,response, "DB Broke!!");
		}catch(IOException e){
			e.printStackTrace();
			errorOccurred(request,response, "DB Broke!!");
		} catch (ServletException e) {
			e.printStackTrace();
			errorOccurred(request,response, "DB Broke!!");
		}catch (Exception e) {
			e.printStackTrace();
			errorOccurred(request,response, "DB Broke!!");
		}
	}

	private void updateEmployee(HttpServletRequest request, HttpServletResponse response, String firstName,
			String lastName, String empSSN, String name, String location,
			String since) {
		int op1 = -1, op2 = -1, op3 = -1, op4 = -1;
		PreparedStatement prpstmt = null;
		DBConnectionManager dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
		try {
			
			if(dbManager == null){
				request.setAttribute("error", "Connection Time Out!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			if(dbManager.getConnection()==null){
				request.setAttribute("error", "Connection Time Out!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			
			dbManager.getConnection().setAutoCommit(false);
			
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
					op1 = prpstmt.executeUpdate(); 
					if(op1<0){
						request.setAttribute("error", "DB Broke!!");
						request.getRequestDispatcher("error.jsp").forward(request, response);
						return;
					}else{
						//request.setAttribute("error", "Update Successful!!");
						//request.getRequestDispatcher("error.jsp").forward(request, response);
						dbManager.getConnection().commit();
					}
				}
				if(lastName!=null && !lastName.isEmpty()){
					prpstmt = dbManager.getConnection().prepareStatement("update Employee Set last_name = ? where SSN = ?  ");					
					prpstmt.setString(1, lastName);
					prpstmt.setInt(2, Integer.parseInt(empSSN));
					op2 = prpstmt.executeUpdate(); 
					if(op2<0){
						request.setAttribute("error", "DB Broke!!");
						request.getRequestDispatcher("error.jsp").forward(request, response);
						return;
					}else{
						//request.setAttribute("error", "Update Successful!!");
						//request.getRequestDispatcher("error.jsp").forward(request, response);
						dbManager.getConnection().commit();
					}
				}
				if(location!=null && !location.isEmpty()){
					prpstmt = dbManager.getConnection().prepareStatement("update Works_at Set location = ?, name = ? where SSN = ?  ");
					
					prpstmt.setString(1, location);
					prpstmt.setInt(3, Integer.parseInt(empSSN));
					prpstmt.setString(2, name);
					op3 = prpstmt.executeUpdate(); 
					if(op3<0){
						request.setAttribute("error", "DB Broke!!");
						request.getRequestDispatcher("error.jsp").forward(request, response);
						return;
					}else{
						//request.setAttribute("error", "Update Successful!!");
						//request.getRequestDispatcher("error.jsp").forward(request, response);
						dbManager.getConnection().commit();
					}
				}
				
				if(since!=null && !since.isEmpty()){
					prpstmt = dbManager.getConnection().prepareStatement("update Works_at Set since = to_date(?, 'yyyy-mm-dd') where SSN = ?  ");
					
					prpstmt.setDate(1, java.sql.Date.valueOf(since));
					prpstmt.setInt(2, Integer.parseInt(empSSN));
					op4 = prpstmt.executeUpdate(); 
					if(op4<0){
						request.setAttribute("error", "DB Broke!!");
						request.getRequestDispatcher("error.jsp").forward(request, response);
						return;
					}else{
						//request.setAttribute("error", "Update Successful!!");
						//request.getRequestDispatcher("error.jsp").forward(request, response);
						dbManager.getConnection().commit();
					}
				}
								
				
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
			
			request.setAttribute("error", "Update Successful!!");
			try {
				dbManager.getConnection().rollback();
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			} catch (ServletException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}catch (Exception e3) {
			e3.printStackTrace();
			errorOccurred(request,response, "DB Broke!!");
		}finally{
		//pw.close();
		}
	
	}

	private void insertEmployee(HttpServletRequest request, HttpServletResponse response, String firstName,
			String lastName, String empSSN, String name, String location,
			String since, String wage, String salary, String empType) {
		PreparedStatement prpstmt;
		int op1,op2, op3 = -1;
		try {
			//pw = new PrintWriter(response.getOutputStream());
			DBConnectionManager dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
			if(dbManager == null){
				request.setAttribute("error", "Connection Time Out!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			if(dbManager.getConnection()==null){
				request.setAttribute("error", "Connection Time Out!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			
			dbManager.getConnection().setAutoCommit(false);

			Statement stmt = dbManager.getConnection().createStatement();
			ResultSet rset = stmt.executeQuery("Select * from Employee where ssn = "+empSSN);
			while(rset.next()){
				request.setAttribute("error", "Employee Already Exists!!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			
			prpstmt = dbManager.getConnection().prepareStatement("insert into Employee values(?,?,?)");
			prpstmt.setString(1, firstName);
			prpstmt.setString(2, lastName);
			prpstmt.setInt(3, Integer.parseInt(empSSN));
			op1 = prpstmt.executeUpdate(); 
			if(op1>0){	
				
				prpstmt = dbManager.getConnection().prepareStatement("insert into Works_at values(?,?,?,?)");
				prpstmt.setInt(1, Integer.parseInt(empSSN));				
				prpstmt.setString(2, location);
				prpstmt.setString(3, name);				
				prpstmt.setDate(4, java.sql.Date.valueOf(since));		
			}else{
				request.setAttribute("error", "Oops let me see !!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			op2 = prpstmt.executeUpdate(); 
			if(empType!=null && !empType.isEmpty() ){
				if(empType.equals("-1")){
					request.setAttribute("error", "Wrong Type !!");
					request.getRequestDispatcher("error.jsp").forward(request, response);
					return;
				}
				if(empType.equals("1")){
						if(salary!=null && !salary.isEmpty() ){
							prpstmt = dbManager.getConnection().prepareStatement("insert into temp_emp values(?,?)");
							prpstmt.setInt(1, Integer.parseInt(empSSN));					 					
							prpstmt.setString(2, wage);
							op3 = prpstmt.executeUpdate();
						
						}else{
							request.setAttribute("error", "Salary Missing !!");
							request.getRequestDispatcher("error.jsp").forward(request, response);
							return;
						}
				}
									
				if(empType.equals("2")){
					if(wage!=null && !wage.isEmpty() ){
					prpstmt = dbManager.getConnection().prepareStatement("insert into temp_emp values(?,?)");
					prpstmt.setInt(1, Integer.parseInt(empSSN));					 					
					prpstmt.setDouble(2, Double.valueOf(wage));
					op3 = prpstmt.executeUpdate();
				
				}else{
					request.setAttribute("error", "Wage Missing !!");
					request.getRequestDispatcher("error.jsp").forward(request, response);
					return;
				}
				
			}else{
				request.setAttribute("error", "Emp type Missing !!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
			}
			
			
			if(op1 > 0){
				if(op2>0){
					if(op3>0){
						request.setAttribute("error", "Employee inserted Successfully!!");
						request.getRequestDispatcher("error.jsp").forward(request, response);
						dbManager.getConnection().commit();
						return;
					}else{
						dbManager.getConnection().rollback();
						request.setAttribute("error", "Oops let me see !!");
						request.getRequestDispatcher("error.jsp").forward(request, response);
						return;
					}
				}
				else{
					dbManager.getConnection().rollback();
					request.setAttribute("error", "Oops let me see !!");
					request.getRequestDispatcher("error.jsp").forward(request, response);
					return;
				}
			}else{
				request.setAttribute("error", "Oops let me see !!");
				request.getRequestDispatcher("error.jsp").forward(request, response);
				return;
			}
			
			}
		} catch (SQLException e) {
			e.printStackTrace();
			errorOccurred(request,response, "DB Broke!!");
			
		}catch(IllegalArgumentException e){
			e.printStackTrace();
			errorOccurred(request,response, "DB Broke!!");
		}catch (Exception e) {
			e.printStackTrace();
			errorOccurred(request,response, "DB Broke!!");
		}finally{
		}
	}
	
	private void  errorOccurred(HttpServletRequest request, HttpServletResponse response, String error){
		request.setAttribute("error", error);
		try {
			request.getRequestDispatcher("error.jsp").forward(request, response);
			return;	
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
}
