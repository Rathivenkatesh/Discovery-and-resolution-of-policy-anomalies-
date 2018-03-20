package com.database;

import java.sql.Connection;
import java.sql.DriverManager;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class Database implements ServletContextListener{
	Connection conn;

	public void contextDestroyed(ServletContextEvent sce) {
		// TODO Auto-generated method stub
		
	}

	public void contextInitialized(ServletContextEvent sce) {
		// TODO Auto-generated method stub
		ServletContext sc=sce.getServletContext();
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn=DriverManager.getConnection("jdbc:oracle:thin:@"+sc.getInitParameter("system"),sc.getInitParameter("username"),sc.getInitParameter("password"));
			sc.setAttribute("connection", conn.createStatement());
			System.out.println("-----Database Connection Initialized----");
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}

}
