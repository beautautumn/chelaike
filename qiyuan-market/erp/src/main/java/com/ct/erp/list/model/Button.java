package com.ct.erp.list.model;

public class Button {

	private String style;
	
	private String value;
	
	private String onclick;
	
	private String condStr;
	
	private String btnName;

	private String btnNo;
	
	
	

	public String getBtnNo() {
		return btnNo;
	}

	public void setBtnNo(String btnNo) {
		this.btnNo = btnNo;
	}

	public String getBtnName() {
		return btnName;
	}

	public void setBtnName(String btnName) {
		this.btnName = btnName;
	}

	public String getCondStr() {
		return condStr;
	}

	public void setCondStr(String condStr) {
		this.condStr = condStr;
	}

	public String getOnclick() {
		return onclick;
	}

	public void setOnclick(String onclick) {
		this.onclick = onclick;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}
	
	
}
