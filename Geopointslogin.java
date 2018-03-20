package com.logics;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Map;
import java.util.StringTokenizer;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.SessionAware;
import com.opensymphony.xwork2.ActionSupport;

public class Geopointslogin extends ActionSupport implements SessionAware{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	String coordinates,zoomlevel;
	String geopoint1="",geopoint2="",geopoint3="",geopoint4="";
	String g11="",g12="",g13="",g21="",g22="",g23="",g31="",g32="",g33="",g41="",g42="",g43="";
	String val1="",val2="",val3="",val4="";
	SessionMap<String, Object> Sessionmap;
	public String getCoordinates() {
		return coordinates;
	}

	public void setCoordinates(String coordinates) {
		this.coordinates = coordinates;
	}

	public String getZoomlevel() {
		return zoomlevel;
	}

	public void setZoomlevel(String zoomlevel) {
		this.zoomlevel = zoomlevel;
	}
	public String execute(){
		try
			{
			System.out.println("Entered into login");
			System.out.println("---"+coordinates+"----"+zoomlevel);
		StringTokenizer st=new StringTokenizer(coordinates,"\n");
		while(st.hasMoreTokens()){
			geopoint1 = st.nextToken();
			geopoint2 = st.nextToken();
			geopoint3 = st.nextToken();
			geopoint4 = st.nextToken();
			StringTokenizer g1=new StringTokenizer(geopoint1,",");
			while(g1.hasMoreTokens()){
				g11=g1.nextToken();
				g12=g1.nextToken();
				g13=g1.nextToken();
			}
			StringTokenizer g2=new StringTokenizer(geopoint2,",");
			while(g2.hasMoreTokens()){
				g21=g2.nextToken();
				g22=g2.nextToken();
				g23=g2.nextToken();
			}
			StringTokenizer g3=new StringTokenizer(geopoint3,",");
			while(g3.hasMoreTokens()){
				g31=g3.nextToken();
				g32=g3.nextToken();
				g33=g3.nextToken();
			}
			StringTokenizer g4=new StringTokenizer(geopoint4,",");
			while(g4.hasMoreTokens()){
				g41=g4.nextToken();
				g42=g4.nextToken();
				g43=g4.nextToken();
			}
		}
		float point11 = Round(Double.valueOf(g11),3);
		float point12 = Round(Double.valueOf(g12),3);
		float point21 = Round(Double.valueOf(g21),3);
		float point22 = Round(Double.valueOf(g22),3);
		float point31 = Round(Double.valueOf(g31),3);
		float point32 = Round(Double.valueOf(g32),3);
		float point41 = Round(Double.valueOf(g41),3);
		float point42 = Round(Double.valueOf(g42),3);
		
		val1=String.valueOf(point11)+"/"+String.valueOf(point12)+"/"+g13;
		val2=String.valueOf(point21)+"/"+String.valueOf(point22)+"/"+g23;
		val3=String.valueOf(point31)+"/"+String.valueOf(point32)+"/"+g33;
		val4=String.valueOf(point41)+"/"+String.valueOf(point42)+"/"+g43;
		System.out.println("val1--------"+val1);
		System.out.println("val2--------"+val2);
		System.out.println("val3--------"+val3);
		System.out.println("val4--------"+val4);
		
		String dbv1="",dbv2="",dbv3="",dbv4="",dbv5="";
		Statement statement=(Statement)(ServletActionContext.getServletContext().getAttribute("connection"));	
		ResultSet rs = statement.executeQuery("select * from xacml_admin where username='"+Sessionmap.get("username").toString()+"'");    
        	
		if(rs.next()) {	
        		dbv1=rs.getString("GEOPOINT1");
        		dbv2=rs.getString("GEOPOINT2");
        		dbv3=rs.getString("GEOPOINT3");
        		dbv4=rs.getString("GEOPOINT4");
        		dbv5=rs.getString("ZOOMLEVEL");
        	}
		
		
		System.out.println();
		System.out.println("val1--------"+val1);
		System.out.println("val2--------"+val2);
		System.out.println("val3--------"+val3);
		System.out.println("val4--------"+val4);
		
//        	System.out.println(dbv1+"***"+dbv2+"***"+dbv3+"***"+dbv4);
        	
        	if(val1.equals(dbv1) && val2.equals(dbv2) && val3.equals(dbv3) && val4.equals(dbv4) && zoomlevel.equals(dbv5)) {
        		System.out.println(" User Authenticated");
        		return SUCCESS;
        	}
        	else{
        		System.out.println("-------Entered into else part------");
        		Sessionmap.clear();
        	}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return ERROR;
	}
	public static float Round(double final12, int Rpl) {
	  	  float p = (float)Math.pow(10,Rpl);
	  	  final12 = final12 * p;
	  	  float tmp = Math.round(final12);
	  	  return (float)tmp/p;
	  	  }

	public void setSession(Map<String, Object> map) {
		// TODO Auto-generated method stub
		Sessionmap=(SessionMap<String, Object>) map;
	}

}
