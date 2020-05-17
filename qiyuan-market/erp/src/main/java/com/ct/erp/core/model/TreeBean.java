package com.ct.erp.core.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TreeBean {

	private String id;
	private String text;
	private Map<String,String> attributes=new HashMap<String,String>();
	private List<TreeBean> children;
	private Boolean checked;
	private String state="";

	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public Map<String, String> getAttributes() {
		return attributes;
	}
	public void setAttributes(Map<String, String> attributes) {
		this.attributes = attributes;
	}
	public List<TreeBean> getChildren() {
		return children;
	}
	public void setChildren(List<TreeBean> children) {
		this.children = children;
	}
	public Boolean getChecked() {
		return checked;
	}
	public void setChecked(Boolean checked) {
		this.checked = checked;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	
	
}
