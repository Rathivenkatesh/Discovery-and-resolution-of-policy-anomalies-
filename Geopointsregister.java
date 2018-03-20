package com.logics;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Map;
import java.util.StringTokenizer;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;

public class Geopointsregister extends ActionSupport implements SessionAware{
	
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
		System.out.println("---"+coordinates+"----"+zoomlevel);
		try{
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
			
			Statement statement=(Statement)(ServletActionContext.getServletContext().getAttribute("connection"));			
			int result=statement.executeUpdate("update xacml_admin set geopoint1='"+val1+"',geopoint2='"+val2+"',geopoint3='"+val3+"',geopoint4='"+val4+"',zoomlevel='"+zoomlevel+"' where username='"+Sessionmap.get("username").toString()+"'");
			System.out.println("--Updated Successfully---");
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return SUCCESS;
	}
	public float Round(double final12, int Rpl) {
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
