package idbproj;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class AppContextListener implements ServletContextListener {
	 
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        ServletContext ctx = servletContextEvent.getServletContext();         
        String url = ctx.getInitParameter("DBURL");         
        //create database connection from init parameters and set it to context
        DBConnectionManager dbManager = new DBConnectionManager(url);
        ctx.setAttribute("DBManager", dbManager);
        System.out.println("Database connection initialized for Application.");
    }
 
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        ServletContext ctx = servletContextEvent.getServletContext();
        DBConnectionManager dbManager = (DBConnectionManager) ctx.getAttribute("DBManager");
        dbManager.closeConnection();
        System.out.println("Database connection closed for Application.");
         
    }
     
}
