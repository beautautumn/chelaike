package com.ct.erp.list.model;

import java.util.LinkedHashMap;
import java.util.Map;

public class DynamicDataBean {

	private ConditionBean conditionBean;

	private StateQueryBtnBean stateQueryBtnBean;

	private Map<String, PageTableColInfo> colFieldMap;

	private MainSqlInfo mainSqlBean;

	private PageTableColBean tableColbean;

	private PageConfigBean pageConfigBean;
	
	private DialogBean dialogBean;
	
	private Integer viewId;
	
	private PageTableInfo pageTableInfo;
	
	private String mainQueryTable;
	
	

	public String getMainQueryTable() {
		return mainQueryTable;
	}

	public void setMainQueryTable(String mainQueryTable) {
		this.mainQueryTable = mainQueryTable;
	}

	public PageTableInfo getPageTableInfo() {
		return pageTableInfo;
	}

	public void setPageTableInfo(PageTableInfo pageTableInfo) {
		this.pageTableInfo = pageTableInfo;
	}

	public Integer getViewId() {
		return viewId;
	}

	public void setViewId(Integer viewId) {
		this.viewId = viewId;
	}

	public DialogBean getDialogBean() {
		return dialogBean;
	}

	public void setDialogBean(DialogBean dialogBean) {
		this.dialogBean = dialogBean;
	}

	public ConditionBean getConditionBean() {
		return conditionBean;
	}

	public void setConditionBean(ConditionBean conditionBean) {
		this.conditionBean = conditionBean;
	}

	public StateQueryBtnBean getStateQueryBtnBean() {
		return stateQueryBtnBean;
	}

	public void setStateQueryBtnBean(StateQueryBtnBean stateQueryBtnBean) {
		this.stateQueryBtnBean = stateQueryBtnBean;
	}

	public Map<String, PageTableColInfo> getColFieldMap() {
		try {
			colFieldMap=new LinkedHashMap<String,PageTableColInfo>();
			for(PageTableColInfo col:this.tableColbean.getColInfos()){
//				if(!col.getHidden()){
//					colFieldMap.put(col.getColField(), col);
//				}		
				colFieldMap.put(col.getColField(), col);
			}
			return colFieldMap;
		} catch (Exception e) {
		}
		return colFieldMap;
	}
	
	

	public void setColFieldMap(Map<String, PageTableColInfo> colFieldMap) {
		this.colFieldMap = colFieldMap;
	}

	public MainSqlInfo getMainSqlBean() {
		return mainSqlBean;
	}

	public void setMainSqlBean(MainSqlInfo mainSqlBean) {
		this.mainSqlBean = mainSqlBean;
	}

	public PageTableColBean getTableColbean() {
		return tableColbean;
	}

	public void setTableColbean(PageTableColBean tableColbean) {
		this.tableColbean = tableColbean;
	}

	public PageConfigBean getPageConfigBean() {
		return pageConfigBean;
	}

	public void setPageConfigBean(PageConfigBean pageConfigBean) {
		this.pageConfigBean = pageConfigBean;
	}
	
	

}
