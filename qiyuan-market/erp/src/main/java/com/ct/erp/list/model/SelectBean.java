package com.ct.erp.list.model;

import java.util.List;

public class SelectBean extends AbsElement{

	private String name;
	private String label;
	private String optionRel;
	private String sql;
	private List<Option> options;
	private String headValue;
	private String headName;	
	private String optionValue;
	private String optionName;
	private String style;
	private String id;
	private String onchange;
	private String cascadeSelectId;
	private Integer showOrder;
	private String defaultValue="";
	private String cssClass="over-select";
	private Boolean newLine=false;
		
	public Integer getShowOrder() {
		return showOrder;
	}
	public void setShowOrder(Integer showOrder) {
		this.showOrder = showOrder;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public String getOptionRel() {
		return optionRel;
	}
	public void setOptionRel(String optionRel) {
		this.optionRel = optionRel;
	}
	public String getSql() {
		return sql;
	}
	public void setSql(String sql) {
		this.sql = sql;
	}
	public List<Option> getOptions() {
		return options;
	}
	public void setOptions(List<Option> options) {
		this.options = options;
	}
	public String getStyle() {
		return style;
	}
	public void setStyle(String style) {
		this.style = style;
	}
	public String getHeadValue() {
		return headValue;
	}
	public void setHeadValue(String headValue) {
		this.headValue = headValue;
	}
	public String getHeadName() {
		return headName;
	}
	public void setHeadName(String headName) {
		this.headName = headName;
	}
	public String getOptionValue() {
		return optionValue;
	}
	public void setOptionValue(String optionValue) {
		this.optionValue = optionValue;
	}
	public String getOptionName() {
		return optionName;
	}
	public void setOptionName(String optionName) {
		this.optionName = optionName;
	}
	public String getOnchange() {
		return onchange;
	}
	public void setOnchange(String onchange) {
		this.onchange = onchange;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCascadeSelectId() {
		return cascadeSelectId;
	}
	public void setCascadeSelectId(String cascadeSelectId) {
		this.cascadeSelectId = cascadeSelectId;
	}
	public String getDefaultValue() {
		return defaultValue;
	}
	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}

	public String getCssClass() {
		return cssClass;
	}

	public void setCssClass(String cssClass) {
		this.cssClass = cssClass;
	}

	public Boolean getNewLine() {
		return newLine;
	}

	public void setNewLine(Boolean newLine) {
		this.newLine = newLine;
	}
}
