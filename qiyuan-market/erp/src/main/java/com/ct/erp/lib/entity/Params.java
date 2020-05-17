package com.ct.erp.lib.entity;

import java.sql.Timestamp;

/**
 * Params entity. @author MyEclipse Persistence Tools
 */

public class Params implements java.io.Serializable {

	// Fields

	private Long id;
	private String paramName;
	private String paramGroup;
	private Integer intValue;
	private String strValue;
	private String strSecondValue;
	private Timestamp dateValue;
	private String paramDesc;
	private String paramType;
	private Integer displayOrder;
	private String status;

	// Constructors

	/** default constructor */
	public Params() {
	}

	/** minimal constructor */
	public Params(String paramName) {
		this.paramName = paramName;
	}

	/** full constructor */
	public Params(String paramName, String paramGroup, Integer intValue,
			String strValue, String strSecondValue, Timestamp dateValue,
			String paramDesc, String paramType, Integer displayOrder,
			String status) {
		this.paramName = paramName;
		this.paramGroup = paramGroup;
		this.intValue = intValue;
		this.strValue = strValue;
		this.strSecondValue = strSecondValue;
		this.dateValue = dateValue;
		this.paramDesc = paramDesc;
		this.paramType = paramType;
		this.displayOrder = displayOrder;
		this.status = status;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getParamName() {
		return this.paramName;
	}

	public void setParamName(String paramName) {
		this.paramName = paramName;
	}

	public String getParamGroup() {
		return this.paramGroup;
	}

	public void setParamGroup(String paramGroup) {
		this.paramGroup = paramGroup;
	}

	public Integer getIntValue() {
		return this.intValue;
	}

	public void setIntValue(Integer intValue) {
		this.intValue = intValue;
	}

	public String getStrValue() {
		return this.strValue;
	}

	public void setStrValue(String strValue) {
		this.strValue = strValue;
	}

	public String getStrSecondValue() {
		return this.strSecondValue;
	}

	public void setStrSecondValue(String strSecondValue) {
		this.strSecondValue = strSecondValue;
	}

	public Timestamp getDateValue() {
		return this.dateValue;
	}

	public void setDateValue(Timestamp dateValue) {
		this.dateValue = dateValue;
	}

	public String getParamDesc() {
		return this.paramDesc;
	}

	public void setParamDesc(String paramDesc) {
		this.paramDesc = paramDesc;
	}

	public String getParamType() {
		return this.paramType;
	}

	public void setParamType(String paramType) {
		this.paramType = paramType;
	}

	public Integer getDisplayOrder() {
		return this.displayOrder;
	}

	public void setDisplayOrder(Integer displayOrder) {
		this.displayOrder = displayOrder;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}