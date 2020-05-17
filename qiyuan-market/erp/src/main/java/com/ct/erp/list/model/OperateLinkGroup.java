package com.ct.erp.list.model;

import java.util.List;

public class OperateLinkGroup {

	private List<OperateLink> operateLinkList;
	
	private String formatFuncName;
	private Boolean vertical;
		

	public String getFormatFuncName() {
		return formatFuncName;
	}

	public void setFormatFuncName(String formatFuncName) {
		this.formatFuncName = formatFuncName;
	}

	public List<OperateLink> getOperateLinkList() {
		return operateLinkList;
	}

	public void setOperateLinkList(List<OperateLink> operateLinkList) {
		this.operateLinkList = operateLinkList;
	}

	public Boolean getVertical() {
		return vertical;
	}

	public void setVertical(Boolean vertical) {
		this.vertical = vertical;
	}
}
