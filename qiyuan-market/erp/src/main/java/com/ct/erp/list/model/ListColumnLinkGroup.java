package com.ct.erp.list.model;

import java.util.List;

public class ListColumnLinkGroup {

	private List<ListColumnLink> cloumnLinkList;
	
	private String formatFunName;

	public List<ListColumnLink> getCloumnLinkList() {
		return cloumnLinkList;
	}

	public void setCloumnLinkList(List<ListColumnLink> cloumnLinkList) {
		this.cloumnLinkList = cloumnLinkList;
	}

	public String getFormatFunName() {
		return formatFunName;
	}

	public void setFormatFunName(String formatFunName) {
		this.formatFunName = formatFunName;
	}
	
	
}
