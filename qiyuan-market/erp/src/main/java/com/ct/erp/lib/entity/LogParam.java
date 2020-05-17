package com.ct.erp.lib.entity;

/**
 * TfCLogParam entity. @author MyEclipse Persistence Tools
 */

public class LogParam  implements java.io.Serializable {

	// Fields

	private String method;
	private String description;

	// Constructors
	public LogParam() {
		super();
		// TODO Auto-generated constructor stub
	}
	

	public LogParam(String method, String description) {
		super();
		this.method = method;
		this.description = description;
	}



	// Property accessors

	public String getMethod() {
		return this.method;
	}


	public void setMethod(String method) {
		this.method = method;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

}