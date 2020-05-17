package com.ct.erp.list.model;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Select {

	private static final Logger log = LoggerFactory.getLogger(Select.class);
	

	
	
	private String defPageSize;
	
	private String style;
	
	private String name;
	
	private List<Option> options;
	
	private String onClick;
	
	private String optionRel;
	
	private String selectClass;
	
	private SelectSqlBean selectSql;
	
	private String positionName;
	

	public SelectSqlBean getSelectSql() {
		return selectSql;
	}

	public void setSelectSql(SelectSqlBean selectSql) {
		this.selectSql = selectSql;
	}

	public String getSelectClass() {
		return selectClass;
	}

	public void setSelectClass(String selectClass) {
		this.selectClass = selectClass;
	}

	public String getOptionRel() {
		return optionRel;
	}

	public void setOptionRel(String optionRel) {
		this.optionRel = optionRel;
	}

	public String getOnClick() {
		return onClick;
	}

	public void setOnClick(String onClick) {
		this.onClick = onClick;
	}

	public List<Option> getOptions(){
		return options;
	}

	public void setOptions(List<Option> options) {
		this.options = options;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDefPageSize() {
		return defPageSize;
	}

	public void setDefPageSize(String defPageSize) {
		this.defPageSize = defPageSize;
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public String getPositionName() {
		return positionName;
	}

	public void setPositionName(String positionName) {
		this.positionName = positionName;
	}
	
	
	
}
