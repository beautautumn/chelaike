package com.ct.erp.sys.model;


public class ParamsBean {
	private Long id;
	private String paramName;
	private String intValue;
	private String paramDesc;
	
	public String getParamName() {
		return paramName;
	}
	public void setParamName(String paramName) {
		this.paramName = paramName;
	}
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getParamDesc() {
		return paramDesc;
	}
	public void setParamDesc(String paramDesc) {
		this.paramDesc = paramDesc;
	}
	public String getIntValue() {
		return intValue;
	}
	public void setIntValue(String intValue) {
		this.intValue = intValue;
	}

	
	
	

}
