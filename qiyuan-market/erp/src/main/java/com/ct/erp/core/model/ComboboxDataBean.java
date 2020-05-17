package com.ct.erp.core.model;

public class ComboboxDataBean {

	private String id;
	private String name;
	private boolean selected = false;
	private Short tag;// 页面显示使用（0:option,1:optgroup）
	private String fetter;

	public ComboboxDataBean(String id, String name) {
		this.name = name;
		this.id = id;
	}

	public ComboboxDataBean(String id, String name, Short tag) {
		this.name = name;
		this.id = id;
		this.tag = tag;
	}

	public ComboboxDataBean(String id, String name, Short tag, String fetter) {
		this.name = name;
		this.id = id;
		this.tag = tag;
		this.fetter = fetter;
	}

	public ComboboxDataBean(String id, String name, boolean selected) {
		this.name = name;
		this.id = id;
		this.selected = selected;
	}

	public String getId() {
		return this.id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isSelected() {
		return this.selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}

	public Short getTag() {
		return this.tag;
	}

	public void setTag(Short tag) {
		this.tag = tag;
	}

	public String getFetter() {
		return this.fetter;
	}

	public void setFetter(String fetter) {
		this.fetter = fetter;
	}

}
