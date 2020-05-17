package com.ct.erp.list.model;

import java.util.List;

public class SearchInputCondtion {
	
	private String searchInputName;
	
	private String positionName;
	
	private List<ConditionSql> conditonSqlList;

	public String getSearchInputName() {
		return searchInputName;
	}

	public void setSearchInputName(String searchInputName) {
		this.searchInputName = searchInputName;
	}

	public List<ConditionSql> getConditonSqlList() {
		return conditonSqlList;
	}

	public void setConditonSqlList(List<ConditionSql> conditonSqlList) {
		this.conditonSqlList = conditonSqlList;
	}

	public String getPositionName() {
		return positionName;
	}

	public void setPositionName(String positionName) {
		this.positionName = positionName;
	}
	
	
	
	
}
