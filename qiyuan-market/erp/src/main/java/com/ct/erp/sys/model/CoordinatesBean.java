package com.ct.erp.sys.model;


public class CoordinatesBean {
	
	 private String x;
	 private String y;
	 private String addr;
	 
	 
	public CoordinatesBean(String x, String y,String addr) {
		super();
		this.x = x;
		this.y = y;
		this.setAddr(addr);
	}
	public String getX() {
		return x;
	}
	public void setX(String x) {
		this.x = x;
	}
	public String getY() {
		return y;
	}
	public void setY(String y) {
		this.y = y;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getAddr() {
		return addr;
	}
	
	

}
