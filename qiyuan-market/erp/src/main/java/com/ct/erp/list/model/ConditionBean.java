package com.ct.erp.list.model;

import java.util.List;

public class ConditionBean {
	
	private String selectStyle;
	public String getSelectStyle() {
		return selectStyle;
	}
	public void setSelectStyle(String selectStyle) {
		this.selectStyle = selectStyle;
	}
	private List<ConditionInfo> conditionInfos;

	public List<ConditionInfo> getConditionInfos() {
		return conditionInfos;
	}

	public void setConditionInfos(List<ConditionInfo> conditionInfos) {
		this.conditionInfos = conditionInfos;
	}
	
	
}
