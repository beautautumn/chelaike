package com.ct.erp.list.model;

import java.util.List;
import java.util.Map;

public class OperateLink {

	private String target;
	
	private String url;
	
	private String title;
	
	private Map<String,String> paramMap;
	
	private String text;
	
	private String openType;
	
	private String dialogId;
	
	private Integer width;
	
	private Integer height;
	
	private Boolean lock=true;
	
	private Integer orderNo;
	
	private String express;
	
	private String jsFunctionName;
	
	private String rightCode;
	
	private String style;
	private String cssClass="over-small";
	private Boolean newLine = false;
	private Boolean outLink = false;
	private Boolean reload = false;
	private String passText;
	private String rejectText;
	private String menuId;
	

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public String getExpress() {
		return express;
	}

	public void setExpress(String express) {
		this.express = express;
	}

	public String getTarget() {
		return target;
	}

	public void setTarget(String target) {
		this.target = target;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	

	public Map<String, String> getParamMap() {
		return paramMap;
	}

	public void setParamMap(Map<String, String> paramMap) {
		this.paramMap = paramMap;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getOpenType() {
		return openType;
	}

	public void setOpenType(String openType) {
		this.openType = openType;
	}

	public String getDialogId() {
		return dialogId;
	}

	public void setDialogId(String dialogId) {
		this.dialogId = dialogId;
	}

	public Integer getWidth() {
		return width;
	}

	public void setWidth(Integer width) {
		this.width = width;
	}

	public Integer getHeight() {
		return height;
	}

	public void setHeight(Integer height) {
		this.height = height;
	}

	public Boolean getLock() {
		return lock;
	}

	public void setLock(Boolean lock) {
		this.lock = lock;
	}

	public Integer getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(Integer orderNo) {
		this.orderNo = orderNo;
	}

	public String getJsFunctionName() {
		return jsFunctionName;
	}

	public void setJsFunctionName(String jsFunctionName) {
		this.jsFunctionName = jsFunctionName;
	}

	public String getRightCode() {
		return rightCode;
	}

	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}

	public String getCssClass() {
		return cssClass;
	}

	public void setCssClass(String cssClass) {
		this.cssClass = cssClass;
	}

	public Boolean getNewLine() {
		return newLine;
	}

	public void setNewLine(Boolean newLine) {
		this.newLine = newLine;
	}

	public Boolean getOutLink() {
		return outLink;
	}

	public void setOutLink(Boolean outLink) {
		this.outLink = outLink;
	}

	public String getPassText() {
		return passText;
	}

	public void setPassText(String passText) {
		this.passText = passText;
	}

	public String getRejectText() {
		return rejectText;
	}

	public void setRejectText(String rejectText) {
		this.rejectText = rejectText;
	}

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public Boolean getReload() {
		return reload;
	}

	public void setReload(Boolean reload) {
		this.reload = reload;
	}
}
