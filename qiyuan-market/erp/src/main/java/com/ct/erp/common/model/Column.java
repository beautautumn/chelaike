package com.ct.erp.common.model;

import org.apache.commons.lang3.builder.ToStringBuilder;

/**
 * easyui动态列column模型.
 * 
 * @author 尔演&Eryan eryanwcp@gmail.com
 * @date 2012-11-23 下午2:11:50
 */
public class Column {
	/**
	 * 字段名称
	 */
	private String field;
	/**
	 * 显示标题
	 */
	private String title;
	/**
	 * 宽度
	 */
	private Integer width;
	/**
	 * 跨行数
	 */
	private Integer rowspan;
	/**
	 * 跨列数
	 */
	private Integer colspan;
	/**
	 * 是否选checkbox
	 */
	private Boolean checkbox;

	/**
	 * 索引
	 */
	private Integer index;
	/**
	 * 对齐方式(默认：'left',可选值：'left'，'right'，'center' 默认左对齐)
	 */
	private String align = "left";

	public Column(Integer index, String field, String title, Integer width,
			String align) {
		super();
		this.index = index;
		this.field = field;
		this.title = title;
		this.width = width;
		this.align = align;
	}

	/**
	 * 字段名称
	 */
	public String getField() {
		return field;
	}

	public void setField(String field) {
		this.field = field;
	}

	/**
	 * 显示标题
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * 设置显示标题
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * 宽度
	 */
	public Integer getWidth() {
		return width;
	}

	/**
	 * 设置宽度
	 */
	public void setWidth(Integer width) {
		this.width = width;
	}

	/**
	 * 跨行数
	 */
	public Integer getRowspan() {
		return rowspan;
	}

	/**
	 * 设置跨行数
	 */
	public void setRowspan(Integer rowspan) {
		this.rowspan = rowspan;
	}

	/**
	 * 跨列数
	 */
	public Integer getColspan() {
		return colspan;
	}

	/**
	 * 设置跨列数
	 */
	public void setColspan(Integer colspan) {
		this.colspan = colspan;
	}

	/**
	 * 是否选中checkbox
	 */
	public boolean isCheckbox() {
		return checkbox;
	}

	/**
	 * 设置是否选中
	 */
	public void setCheckbox(boolean checkbox) {
		this.checkbox = checkbox;
	}

	/**
	 * 对齐方式(默认：'left',可选值：'left'，'right'，'center' 默认左对齐)
	 */
	public String getAlign() {
		return align;
	}

	/**
	 * 设置对齐方式(可选值：'left'，'right'，'center' 默认左对齐)
	 */
	public void setAlign(String align) {
		this.align = align;
	}

	/**
	 * 索引值
	 */
	public Integer getIndex() {
		return index;
	}

	/**
	 * 设置索引值
	 * 
	 * @param index
	 */
	public void setIndex(Integer index) {
		this.index = index;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}