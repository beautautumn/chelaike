package com.ct.erp.common.model;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.builder.ToStringBuilder;

import com.google.common.collect.Lists;

/**
 * easyui分页组件datagrid、combogrid数据模型.
 * 
 * @author 尔演&Eryan eryanwcp@gmail.com
 * @date 2012-10-16 上午9:57:59
 */
@SuppressWarnings("serial")
public class Datagrid<T> implements Serializable {
	/**
	 * 总记录数
	 */
	private long total;
	/**
	 * 动态列
	 */
	private List<Column> columns = Lists.newArrayList();
	/**
	 * 列表行
	 */
	private List<T> rows;
	/**
	 * 脚列表
	 */
	private List<Map<String, Object>> footer;
	
	public Datagrid() {
		super();
	}

	/**
	 * 
	 * @param total
	 *            总记录数
	 * @param rows
	 *            列表行
	 */
	public Datagrid(long total, List<T> rows) {
		this(total, null, rows, null);
	}

	/**
	 * 
	 * @param total
	 *            总记录数
	 * @param columns
	 *            动态列
	 * @param rows
	 *            列表行
	 * @param footer
	 *            脚列表
	 */
	public Datagrid(long total, List<Column> columns, List<T> rows,
			List<Map<String, Object>> footer) {
		super();
		this.total = total;
		this.columns = columns;
		this.rows = rows;
		this.footer = footer;
	}

	/**
	 * 总记录数
	 */
	public long getTotal() {
		return total;
	}

	/**
	 * 设置总记录数
	 * 
	 * @param total
	 *            总记录数
	 */
	public void setTotal(long total) {
		this.total = total;
	}

	/**
	 * 列表行
	 */
	public List<T> getRows() {
		return rows;
	}

	/**
	 * 设置列表行
	 * 
	 * @param rows
	 *            列表行
	 */
	public void setRows(List<T> rows) {
		this.rows = rows;
	}

	/**
	 * 脚列表
	 */
	public List<Map<String, Object>> getFooter() {
		return footer;
	}

	/**
	 * 设置脚列表
	 * 
	 * @param footer
	 *            脚列表
	 */
	public void setFooter(List<Map<String, Object>> footer) {
		this.footer = footer;
	}

	/**
	 * 动态列
	 */
	public List<Column> getColumns() {
		return columns;
	}

	/**
	 * 设置动态列
	 * 
	 * @param columns
	 *            动态列
	 */
	public void setColumns(List<Column> columns) {
		this.columns = columns;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}
