package com.ct.erp.list.model;


public class ListColumn {

	private String field;
	/**
	 * 列属性用于数据库查询
	 */
	private String fieldType;
	/**
	 * 列格式化，用于数据库查询格式化
	 */
	private String fieldFormat;
	/**
	 * 显示名称
	 */
	private String label;
	
	private String width;
	
	private String sortable;
	
	private String align;
	
	private String formatter;
	
	private Boolean frozen;
	
	private ListColumnLinkGroup links;
	
	private Integer orderNo;
	
	private Boolean hidden;
	
	private Boolean checkbox;
	
	private Integer rowspan;
	
	private Integer colspan;
	
	private String order;
	
	private String styler;
	
	private String rightCode;
			
	public ListColumnLinkGroup getLinks() {
		return links;
	}

	public void setLinks(ListColumnLinkGroup links) {
		this.links = links;
	}

	public Integer getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(Integer orderNo) {
		this.orderNo = orderNo;
	}	

	public String getField() {
		return field;
	}

	public void setField(String field) {
		this.field = field;
	}

	public String getFieldType() {
		return fieldType;
	}

	public void setFieldType(String fieldType) {
		this.fieldType = fieldType;
	}

	public String getFieldFormat() {
		return fieldFormat;
	}

	public void setFieldFormat(String fieldFormat) {
		this.fieldFormat = fieldFormat;
	}

	public String getWidth() {
		return width;
	}

	public void setWidth(String width) {
		this.width = width;
	}

	public String getSortable() {
		return sortable;
	}

	public void setSortable(String sortable) {
		this.sortable = sortable;
	}

	public String getAlign() {
		return align;
	}

	public void setAlign(String align) {
		this.align = align;
	}

	public String getFormatter() {
		return formatter;
	}

	public void setFormatter(String formatter) {
		this.formatter = formatter;
	}

	public Boolean getFrozen() {
		return frozen;
	}

	public void setFrozen(Boolean frozen) {
		this.frozen = frozen;
	}

	public Boolean getHidden() {
		return hidden;
	}

	public void setHidden(Boolean hidden) {
		this.hidden = hidden;
	}

	public Boolean getCheckbox() {
		return checkbox;
	}

	public void setCheckbox(Boolean checkbox) {
		this.checkbox = checkbox;
	}

	public Integer getRowspan() {
		return rowspan;
	}

	public void setRowspan(Integer rowspan) {
		this.rowspan = rowspan;
	}

	public Integer getColspan() {
		return colspan;
	}

	public void setColspan(Integer colspan) {
		this.colspan = colspan;
	}

	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	public String getStyler() {
		return styler;
	}

	public void setStyler(String styler) {
		this.styler = styler;
	}

	public String getRightCode() {
		return rightCode;
	}

	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	
	
}
