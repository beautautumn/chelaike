package com.ct.erp.list.model;

import java.util.Map;

import com.ct.erp.common.model.GridPageInfo;

public class GridTableBean {
	private GridPageInfo pageInfo;
	private Map<String,String> columnMap;
	public GridPageInfo getPageInfo() {
		return pageInfo;
	}
	public void setPageInfo(GridPageInfo pageInfo) {
		this.pageInfo = pageInfo;
	}
	public Map<String, String> getColumnMap() {
		return columnMap;
	}
	public void setColumnMap(Map<String, String> columnMap) {
		this.columnMap = columnMap;
	}
	
	
}
