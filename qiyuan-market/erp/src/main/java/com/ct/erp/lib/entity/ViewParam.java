package com.ct.erp.lib.entity;

/**
 * ViewParam entity. @author MyEclipse Persistence Tools
 */

public class ViewParam implements java.io.Serializable {

	// Fields

	private Integer paramCode;
	private Short paramType;
	private String paramName;
	private String paramValue;
	private String reamk;

	// Constructors

	/** default constructor */
	public ViewParam() {
	}

	/** full constructor */
	public ViewParam(Short paramType, String paramName, String paramValue,
			String reamk) {
		this.paramType = paramType;
		this.paramName = paramName;
		this.paramValue = paramValue;
		this.reamk = reamk;
	}

	// Property accessors

	public Integer getParamCode() {
		return this.paramCode;
	}

	public void setParamCode(Integer paramCode) {
		this.paramCode = paramCode;
	}

	public Short getParamType() {
		return this.paramType;
	}

	public void setParamType(Short paramType) {
		this.paramType = paramType;
	}

	public String getParamName() {
		return this.paramName;
	}

	public void setParamName(String paramName) {
		this.paramName = paramName;
	}

	public String getParamValue() {
		return this.paramValue;
	}

	public void setParamValue(String paramValue) {
		this.paramValue = paramValue;
	}

	public String getReamk() {
		return this.reamk;
	}

	public void setReamk(String reamk) {
		this.reamk = reamk;
	}

}