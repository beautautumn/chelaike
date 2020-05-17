package com.tianche.domain;

import java.io.Serializable;

public class SystemMenu  implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private long id;
	private String rightCode;
	private long parentId;
	private String menuText;
	private String url;
	private short orderNo;
	private String iconCls;
	private String icon;
	private String markUrl;
	private String status;
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getRightCode() {
		return rightCode;
	}
	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}
	public long getParentId() {
		return parentId;
	}
	public void setParentId(long parentId) {
		this.parentId = parentId;
	}
	public String getMenuText() {
		return menuText;
	}
	public void setMenuText(String menuText) {
		this.menuText = menuText;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public short getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(short orderNo) {
		this.orderNo = orderNo;
	}
	public String getIconCls() {
		return iconCls;
	}
	public void setIconCls(String iconCls) {
		this.iconCls = iconCls;
	}
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
	public String getMarkUrl() {
		return markUrl;
	}
	public void setMarkUrl(String markUrl) {
		this.markUrl = markUrl;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

}
