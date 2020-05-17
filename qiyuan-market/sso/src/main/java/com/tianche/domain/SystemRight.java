package com.tianche.domain;

import java.io.Serializable;

public class SystemRight  implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String rightCode;
	private String parentRightCode;
	private String rightName;
	private Short rightType;
	private String rightDesc;
	private Short showOrder;
	
	public String getRightCode() {
		return rightCode;
	}
	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}
	public String getParentRightCode() {
		return parentRightCode;
	}
	public void setParentRightCode(String parentRightCode) {
		this.parentRightCode = parentRightCode;
	}
	public String getRightName() {
		return rightName;
	}
	public void setRightName(String rightName) {
		this.rightName = rightName;
	}
	public Short getRightType() {
		return rightType;
	}
	public void setRightType(Short rightType) {
		this.rightType = rightType;
	}
	public String getRightDesc() {
		return rightDesc;
	}
	public void setRightDesc(String rightDesc) {
		this.rightDesc = rightDesc;
	}
	public Short getShowOrder() {
		return showOrder;
	}
	public void setShowOrder(Short showOrder) {
		this.showOrder = showOrder;
	}

}
