package com.ct.erp.common.model;

import java.util.List;

public class GridPageInfo {
	/*
	 * 获得当前页数
	 */
	private int page = 1;

	/*
	 * 获得每页数据最大量
	 */
	private int rp = 20;

	/*
	 * 当前总记录数
	 */
	private long total=0;
	
	/**
	 * 总页数
	 */
	private int pageCount;;

	/*
	 * 页面显示的数据
	 */
	private List rows = null;

	/*
	 * 导出时使用的sql
	 */
	private String querySql;

	/*
	 * 导出时使用的参数
	 */
	private Object[] queryParam;
	
	private String columns;
	

	public String getColumns() {
		return columns;
	}

	public void setColumns(String columns) {
		this.columns = columns;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getRp() {
		return rp;
	}

	public void setRp(int rp) {
		this.rp = rp;
	}

	public long getTotal() {
		return total;
	}

	public void setTotal(long total) {
		this.total = total;
	}

	public List getRows() {
		return rows;
	}

	public void setRows(List rows) {
		this.rows = rows;
	}

	public Object[] getQueryParam() {
		return queryParam;
	}

	public void setQueryParam(Object[] queryParam) {
		this.queryParam = queryParam;
	}

	public String getQuerySql() {
		return querySql;
	}

	public void setQuerySql(String querySql) {
		this.querySql = querySql;
	}

	public int getPageCount() {
		return pageCount;
	}

	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}
	
	public int getDefPageCount(){
		return (int)  Math.ceil((double) total / rp);
	}

}
