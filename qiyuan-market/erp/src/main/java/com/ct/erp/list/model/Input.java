package com.ct.erp.list.model;

public class Input extends AbsElement{
	
	private String style;
	private String name;
	private String value;
	private String pattern;
	private String inputClass="over-input";
	private String onclick;
	private String optionRel;
	private String width;
	private String defultValue;
	private String columnFormat;
	private String inputNumber;
	private String text;
	private String positionName;
	private String dateDiff;
	private String monthDiff;
	private String type;
	private Boolean newLine = false;
	private String labelClass="over-label";
	private String placeHolder="";
	
	public Integer getShowOrder() {
		return showOrder;
	}

	public void setShowOrder(Integer showOrder) {
		this.showOrder = showOrder;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getInputNumber() {
		return inputNumber;
	}

	public void setInputNumber(String inputNumber) {
		this.inputNumber = inputNumber;
	}

	public String getColumnFormat() {
		return columnFormat;
	}

	public void setColumnFormat(String columnFormat) {
		this.columnFormat = columnFormat;
	}

	public String getWidth() {
		return width;
	}

	public void setWidth(String width) {
		this.width = width;
	}

	public String getDefultValue() {
		return defultValue;
	}

	public void setDefultValue(String defultValue) {
		this.defultValue = defultValue;
	}

	public String getOptionRel() {
		return optionRel;
	}

	public void setOptionRel(String optionRel) {
		this.optionRel = optionRel;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getPattern() {
		return pattern;
	}

	public void setPattern(String pattern) {
		this.pattern = pattern;
	}

	public String getInputClass() {
		return inputClass;
	}

	public void setInputClass(String inputClass) {
		this.inputClass = inputClass;
	}

	public String getOnclick() {
		return onclick;
	}

	public void setOnclick(String onclick) {
		this.onclick = onclick;
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public String getPositionName() {
		return positionName;
	}

	public void setPositionName(String positionName) {
		this.positionName = positionName;
	}

	public String getDateDiff() {
		return dateDiff;
	}

	public void setDateDiff(String dateDiff) {
		this.dateDiff = dateDiff;
	}

	public String getMonthDiff() {
		return monthDiff;
	}

	public void setMonthDiff(String monthDiff) {
		this.monthDiff = monthDiff;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Boolean getNewLine() {
		return newLine;
	}

	public void setNewLine(Boolean newLine) {
		this.newLine = newLine;
	}

	public String getLabelClass() {
		return labelClass;
	}

	public void setLabelClass(String labelClass) {
		this.labelClass = labelClass;
	}

	public String getPlaceHolder() {
		return placeHolder;
	}

	public void setPlaceHolder(String placeHolder) {
		this.placeHolder = placeHolder;
	}
}
