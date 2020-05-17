package com.ct.erp.list.model;

public abstract class AbsElement {

	protected Integer showOrder;
	
	protected String rightCode;
	
	protected Boolean display=false;
	
	protected boolean wrap; 

	public Integer getShowOrder() {
		return showOrder;
	}

	public void setShowOrder(Integer showOrder) {
		this.showOrder = showOrder;
	}

	public String getRightCode() {
		return rightCode;
	}

	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}

	public Boolean getDisplay() {
		return display;
	}

	public void setDisplay(Boolean display) {
		this.display = display;
	}

	public boolean isWrap() {
		return wrap;
	}

	public void setWrap(boolean wrap) {
		this.wrap = wrap;
	}

	
}
