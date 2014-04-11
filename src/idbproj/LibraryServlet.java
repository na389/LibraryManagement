package idbproj;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map.Entry;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class LibraryServlet
 */
public class LibraryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ResultSet rset;
	public static String libSelected = "value";
	private ServletContext ctx;
	private PrintWriter pw;
	private DBConnectionManager dbManager;
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LibraryServlet() {
		super();
		
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		ctx = getServletContext();
        dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
        pw = new PrintWriter(response.getOutputStream());
		Statement stmt;
		try {
			pw.println("<html><body background-color:#CCFF66; >");	
			if(dbManager == null){
				pw.println("<H1>Connection Issue<BR></H1>");
				return;
			}
			if(dbManager.getConnection()==null){
				pw.println("<H1>Connection Issue<BR></H1>");
				return;
			}
			stmt = dbManager.getConnection().createStatement();
			rset = stmt.executeQuery("Select name, location from Library");
					
			pw.println("<H1>Select library to move further<BR></H1>");
			pw.println("<BR>");
			while(!rset.next()){
				pw.println("Result not Found!!");
				
			}
			
			while (rset.next()) {							
				pw.println("<a href= \"list_employees.jsp?" +  libSelected + "="+rset.getString("Name")+ " \"> "+ rset.getString("name") +"</a> <BR>");
			}			
			

		} catch (SQLException e) {
			e.printStackTrace();
			pw.println("Error Occurred!!");
		}catch(Exception e){
			e.printStackTrace();
			pw.println("Error Occurred!!");
		}
		pw.println("</body></html>");
		pw.close();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}
	
}
