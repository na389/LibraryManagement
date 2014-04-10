package idbproj;

import java.sql.Connection;
import java.sql.SQLException;

import oracle.jdbc.pool.OracleDataSource;

public class DBConnectionManager {
 
    private String dbURL;
    private Connection con;
     
    public DBConnectionManager(String url){
        this.dbURL=url;
        //create db connection now
        try {
			if (con == null) {
				// Create a OracleDataSource instance and set URL
				OracleDataSource ods = new OracleDataSource();
				ods.setURL(dbURL);
				con = ods.getConnection();
			}
        }catch (SQLException e) {
			e.printStackTrace();
		}

    }
     
    public Connection getConnection(){
        return this.con;
    }
     
    public void closeConnection(){
        //close DB connection here
    }
    
    
}
