package com.ct.erp.lib.entity;

/**
 * DynamicView entity. @author MyEclipse Persistence Tools
 */

public class DynamicView implements java.io.Serializable {

	// Fields

	private Integer dynamicViewId;
	private Integer pageId;
	private String tablePropertyDef;
	private String tableColDef;
	private String queryDef;
	private String stateQueryBtnDef;
	private String optBtnDef;
	private String mainQueryTable;
	private String pageConfigDef;

	// Constructors

	/** default constructor */
	public DynamicView() {
	}

	/** full constructor */
	public DynamicView(Integer pageId, String tablePropertyDef,
			String tableColDef, String queryDef, String stateQueryBtnDef,
			String optBtnDef, String mainQueryTable, String pageConfigDef) {
		this.pageId = pageId;
		this.tablePropertyDef = tablePropertyDef;
		this.tableColDef = tableColDef;
		this.queryDef = queryDef;
		this.stateQueryBtnDef = stateQueryBtnDef;
		this.optBtnDef = optBtnDef;
		this.mainQueryTable = mainQueryTable;
		this.pageConfigDef = pageConfigDef;
	}

	// Property accessors

	public Integer getDynamicViewId() {
		return this.dynamicViewId;
	}

	public void setDynamicViewId(Integer dynamicViewId) {
		this.dynamicViewId = dynamicViewId;
	}

	public Integer getPageId() {
		return this.pageId;
	}

	public void setPageId(Integer pageId) {
		this.pageId = pageId;
	}

	public String getTablePropertyDef() {
		return this.tablePropertyDef;
	}

	public void setTablePropertyDef(String tablePropertyDef) {
		this.tablePropertyDef = tablePropertyDef;
	}

	public String getTableColDef() {
		return this.tableColDef;
	}

	public void setTableColDef(String tableColDef) {
		this.tableColDef = tableColDef;
	}

	public String getQueryDef() {
		return this.queryDef;
	}

	public void setQueryDef(String queryDef) {
		this.queryDef = queryDef;
	}

	public String getStateQueryBtnDef() {
		return this.stateQueryBtnDef;
	}

	public void setStateQueryBtnDef(String stateQueryBtnDef) {
		this.stateQueryBtnDef = stateQueryBtnDef;
	}

	public String getOptBtnDef() {
		return this.optBtnDef;
	}

	public void setOptBtnDef(String optBtnDef) {
		this.optBtnDef = optBtnDef;
	}

	public String getMainQueryTable() {
		return this.mainQueryTable;
	}

	public void setMainQueryTable(String mainQueryTable) {
		this.mainQueryTable = mainQueryTable;
	}

	public String getPageConfigDef() {
		return this.pageConfigDef;
	}

	public void setPageConfigDef(String pageConfigDef) {
		this.pageConfigDef = pageConfigDef;
	}

}