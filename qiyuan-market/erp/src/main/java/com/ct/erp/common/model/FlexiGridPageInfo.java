package com.ct.erp.common.model;

import java.util.List;

public class FlexiGridPageInfo {
	/*
	 * 获得当前页数
	 */
	private int page=0;
	/*
	 * 获得每页数据最大量
	 */
	private int rp=10;
	/**
	 * 显示的分页条数
	 */
	private int nde=5;
	/*
	 * 当前总记录数
	 */
	private long total;
	/*
	 * 页面显示的数据
	 */
	private List rows = null;

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

	public int getNde() {
		return nde;
	}

	public void setNde(int nde) {
		this.nde = nde;
	}
	
	

}
