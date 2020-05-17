package com.ct.erp.list.model;

public class Option {

	private String value;
	private String text;
	private String columnField;
	private boolean defaultSelect;
	
	
	
	public boolean isDefaultSelect() {
		return defaultSelect;
	}
	public void setDefaultSelect(boolean defaultSelect) {
		this.defaultSelect = defaultSelect;
	}
	public String getColumnField() {
		return columnField;
	}
	public void setColumnField(String columnField) {
		this.columnField = columnField;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	
}
