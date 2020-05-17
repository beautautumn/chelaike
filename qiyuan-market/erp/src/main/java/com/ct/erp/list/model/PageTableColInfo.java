package com.ct.erp.list.model;

import java.util.List;
import java.util.Map;

public class PageTableColInfo {

	private String colName;
	private String colField;
	private String colFormat;
	private String colWidth;
	private String colNumber;
	private String colClass;
	private String fieldType;
	private DialogInfo dialogInfo;
	private String formatter;
	private String fmtTag;
	private Map<String,String> paramsOptions;
	private String colStyle;
	private String colAlign;
	private String sortable;
	private String dataOptions;
	private Boolean hidden=false;
	private boolean xsum;
	private boolean ysum;
	private boolean columnShow;
	
	private OperateLinkGroup operateLinkGroup;
	
	
	public String getDataOptions() {
		return dataOptions;
	}
	public void setDataOptions(String dataOptions) {
		this.dataOptions = dataOptions;
	}
	public String getColAlign() {
		return colAlign;
	}
	public void setColAlign(String colAlign) {
		this.colAlign = colAlign;
	}
	public String getColStyle() {
		return colStyle;
	}
	public void setColStyle(String colStyle) {
		this.colStyle = colStyle;
	}
	public Map<String, String> getParamsOptions() {
		return paramsOptions;
	}
	public void setParamsOptions(Map<String, String> paramsOptions) {
		this.paramsOptions = paramsOptions;
	}
	public String getFmtTag() {
		return fmtTag;
	}
	public void setFmtTag(String fmtTag) {
		this.fmtTag = fmtTag;
	}
	public String getFormatter() {
		return formatter;
	}
	public void setFormatter(String formatter) {
		this.formatter = formatter;
	}
	public DialogInfo getDialogInfo() {
		return dialogInfo;
	}
	public void setDialogInfo(DialogInfo dialogInfo) {
		this.dialogInfo = dialogInfo;
	}
	private Map<String,String> colOptions;
	
	
	public String getFieldType() {
		return fieldType;
	}
	public void setFieldType(String fieldType) {
		this.fieldType = fieldType;
	}
	public String getColClass() {
		return colClass;
	}
	public void setColClass(String colClass) {
		this.colClass = colClass;
	}
	public String getColNumber() {
		return colNumber;
	}
	public void setColNumber(String colNumber) {
		this.colNumber = colNumber;
	}
	public Map<String, String> getColOptions() {
		return colOptions;
	}
	public void setColOptions(Map<String, String> colOptions) {
		this.colOptions = colOptions;
	}
	public String getColName() {
		return colName;
	}
	public void setColName(String colName) {
		this.colName = colName;
	}
	public String getColField() {
		return colField;
	}
	public void setColField(String colField) {
		this.colField = colField;
	}
	public String getColFormat() {
		return colFormat;
	}
	public void setColFormat(String colFormat) {
		this.colFormat = colFormat;
	}
	public String getColWidth() {
		return colWidth;
	}
	public void setColWidth(String colWidth) {
		this.colWidth = colWidth;
	}
	public void setSortable(String sortable) {
		this.sortable = sortable;
	}
	public String getSortable() {
		return sortable;
	}
	public OperateLinkGroup getOperateLinkGroup() {
		return operateLinkGroup;
	}
	public void setOperateLinkGroup(OperateLinkGroup operateLinkGroup) {
		this.operateLinkGroup = operateLinkGroup;
	}
	public Boolean getHidden() {
		return hidden;
	}
	public void setHidden(Boolean hidden) {
		this.hidden = hidden;
	}
	public boolean isXsum() {
		return xsum;
	}
	public void setXsum(boolean xsum) {
		this.xsum = xsum;
	}
	public boolean isYsum() {
		return ysum;
	}
	public void setYsum(boolean ysum) {
		this.ysum = ysum;
	}

	public boolean getColumnShow() {
		return columnShow;
	}

	public void setColumnShow(boolean columnShow) {
		this.columnShow = columnShow;
	}
}
