package com.ct.erp.list.model;

public class DialogInfo {

	private String btnText;
	private String dialogNumber;
	private String dialogWidth;
	private String dialogHeight;
	private String dialogTitle;
	private String dialogUrl;
	private String style;
	private String openMode;
	private String dialogId;
	
	private boolean lock=true;
	private boolean collapsible;
	private boolean maximizable;
	private boolean model;
	private String dialogShowNo;
	private String rightCode;
	private String href;
	private String iconCls;
	
	private String openType;
	
	private String target;
	
	private String functionName;
	private Boolean outLink = false;
	
	
	
	public String getFunctionName() {
		return functionName;
	}
	public void setFunctionName(String functionName) {
		this.functionName = functionName;
	}
	public String getDialogShowNo() {
		return dialogShowNo;
	}
	public void setDialogShowNo(String dialogShowNo) {
		this.dialogShowNo = dialogShowNo;
	}
	public boolean isCollapsible() {
		return collapsible;
	}
	public void setCollapsible(boolean collapsible) {
		this.collapsible = collapsible;
	}
	public boolean isMaximizable() {
		return maximizable;
	}
	public void setMaximizable(boolean maximizable) {
		this.maximizable = maximizable;
	}
	public boolean isModel() {
		return model;
	}
	public void setModel(boolean model) {
		this.model = model;
	}
	public String getOpenMode() {
		return openMode;
	}
	public void setOpenMode(String openMode) {
		this.openMode = openMode;
	}
	public String getStyle() {
		return style;
	}
	public void setStyle(String style) {
		this.style = style;
	}
	public String getDialogNumber() {
		return dialogNumber;
	}
	public void setDialogNumber(String dialogNumber) {
		this.dialogNumber = dialogNumber;
	}
	public String getDialogWidth() {
		return dialogWidth;
	}
	public void setDialogWidth(String dialogWidth) {
		this.dialogWidth = dialogWidth;
	}
	public String getDialogHeight() {
		return dialogHeight;
	}
	public void setDialogHeight(String dialogHeight) {
		this.dialogHeight = dialogHeight;
	}
	public String getDialogTitle() {
		return dialogTitle;
	}
	public void setDialogTitle(String dialogTitle) {
		this.dialogTitle = dialogTitle;
	}
	public String getDialogUrl() {
		return dialogUrl;
	}
	public void setDialogUrl(String dialogUrl) {
		this.dialogUrl = dialogUrl;
	}
	public String getRightCode() {
		return rightCode;
	}
	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}
	public String getHref() {
		return href;
	}
	public void setHref(String href) {
		this.href = href;
	}
	public String getDialogId() {
		return dialogId;
	}
	public void setDialogId(String dialogId) {
		this.dialogId = dialogId;
	}
	public boolean isLock() {
		return lock;
	}
	public void setLock(boolean lock) {
		this.lock = lock;
	}
	public String getIconCls() {
		return iconCls;
	}
	public void setIconCls(String iconCls) {
		this.iconCls = iconCls;
	}
	public String getOpenType() {
		return openType;
	}
	public void setOpenType(String openType) {
		this.openType = openType;
	}
	public String getTarget() {
		return target;
	}
	public void setTarget(String target) {
		this.target = target;
	}

	public String getBtnText() {
		return btnText==null?this.dialogTitle:btnText;
	}

	public void setBtnText(String btnText) {
		this.btnText = btnText;
	}

	public Boolean getOutLink() {
		return outLink;
	}

	public void setOutLink(Boolean outLink) {
		this.outLink = outLink;
	}
}
