package com.ct.erp.list.model;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.ct.erp.common.model.GridPageInfo;
import com.ct.util.lang.StrUtils;

public class ComposeQueryBean {

	private Map<String,PageTableColInfo> colPageTableColInfoMap=new HashMap<String,PageTableColInfo>();
	
	private Map<String,String> sqlMap;
	private GridPageInfo pageInfo;
	private Map<String,ConditionValueBean> conditionMap;
	private String sort;
	private String order;
	private Map<String, String> colFieldMap;
	
	
	public Map<String, String> getSqlMap() {
		return sqlMap;
	}
	public void setSqlMap(Map<String, String> sqlMap) {
		this.sqlMap = sqlMap;
	}
	public GridPageInfo getPageInfo() {
		return pageInfo;
	}
	public void setPageInfo(GridPageInfo pageInfo) {
		this.pageInfo = pageInfo;
	}

	
	public Map<String, ConditionValueBean> getConditionMap() {
		return conditionMap;
	}
	public void setConditionMap(Map<String, ConditionValueBean> conditionMap) {
		this.conditionMap = conditionMap;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}
	public String getOrder() {
		return order;
	}
	public void setOrder(String order) {
		this.order = order;
	}
	public Map<String, PageTableColInfo> getColPageTableColInfoMap() {
		return colPageTableColInfoMap;
	}
	public void setColPageTableColInfoMap(
			Map<String, PageTableColInfo> colPageTableColInfoMap) {
		this.colPageTableColInfoMap = colPageTableColInfoMap;
	}
	public Map<String, String> getColFieldMap() {
		return colFieldMap;
	}
	public void setColFieldMap(Map<String, String> colFieldMap) {
		this.colFieldMap = colFieldMap;
	}
	
	private boolean isColumnShow(boolean hiddenColShow,PageTableColInfo info){
		return !(!hiddenColShow&&info.getHidden())&&!StrUtils.contains(info.getColName(),"图");
	}
	
	
	public String getSelectCol(boolean hiddenColShow) {
		Iterator<Map.Entry<String, PageTableColInfo>> it = colPageTableColInfoMap.entrySet()
				.iterator();
		StringBuilder sql = new StringBuilder();
		while (it.hasNext()) {
			Map.Entry<String, PageTableColInfo> entry = it.next();
			if(isColumnShow(hiddenColShow, entry.getValue())){
				sql.append(entry.getKey());
				sql.append(",");
			}
		}
		if (sql.length() > 0)
			sql = sql.deleteCharAt(sql.length() - 1);
		return sql.toString();
	}
	
	
	public String getColumnName(boolean hiddenColShow) {
		Iterator<Map.Entry<String, PageTableColInfo>> it = colPageTableColInfoMap.entrySet()
				.iterator();
		StringBuilder sql = new StringBuilder();
		while (it.hasNext()) {
			Map.Entry<String, PageTableColInfo> entry = it.next();
			//if(!(!hiddenColShow&&entry.getValue().getHidden())){
			if(isColumnShow(hiddenColShow, entry.getValue())){
				if(!"操作".equals(entry.getValue().getColName())){
					sql.append(entry.getValue().getColName());
					sql.append(",");
				}
			}			
		}
		if (sql.length() > 0)
			sql = sql.deleteCharAt(sql.length() - 1);
		return sql.toString();
	}
	
	public String getColumnField(boolean hiddenColShow) {
		Iterator<Map.Entry<String, PageTableColInfo>> it = colPageTableColInfoMap.entrySet()
				.iterator();
		StringBuilder sql = new StringBuilder();
		while (it.hasNext()) {
			Map.Entry<String, PageTableColInfo> entry = it.next();
			//if(!(!hiddenColShow&&entry.getValue().getHidden())){
			if(isColumnShow(hiddenColShow, entry.getValue())){
				if(!"show_button".equals(entry.getValue().getColField())){
					sql.append(entry.getValue().getColField());
					sql.append(",");
				}
			}
		}
		if (sql.length() > 0)
			sql = sql.deleteCharAt(sql.length() - 1);
		return sql.toString();
	}
	
	
	public String getColumnWidth(boolean hiddenColShow) {
		Iterator<Map.Entry<String, PageTableColInfo>> it = colPageTableColInfoMap.entrySet()
				.iterator();
		StringBuilder sql = new StringBuilder();
		while (it.hasNext()) {
			
			Map.Entry<String, PageTableColInfo> entry = it.next();
			//if(!(!hiddenColShow&&entry.getValue().getHidden())){
			if(isColumnShow(hiddenColShow, entry.getValue())){
				sql.append(entry.getValue().getColWidth().replaceAll("px",""));
				sql.append(",");
			}
		}
		if (sql.length() > 0)
			sql = sql.deleteCharAt(sql.length() - 1);
		return sql.toString();
	}
	
	public String getColumnMetaType(boolean hiddenColShow) {
		Iterator<Map.Entry<String, PageTableColInfo>> it = colPageTableColInfoMap.entrySet()
				.iterator();
		StringBuilder sql = new StringBuilder();
		while (it.hasNext()) {
			Map.Entry<String, PageTableColInfo> entry = it.next();
			//if(!(!hiddenColShow&&entry.getValue().getHidden())){
			if(isColumnShow(hiddenColShow, entry.getValue())){
				sql.append(entry.getValue().getFieldType());
				sql.append(",");
			}
		}
		if (sql.length() > 0)
			sql = sql.deleteCharAt(sql.length() - 1);
		return sql.toString();
	}
	
}
