package com.ct.erp.core.model;

public class SysParamBean {

	private Long id;
	private Long corpId;
	private String corpName;
	private String name;
	private String validTag;
	private String remark;
	private Short sourceType;
	private Long parentId;
	private String fee;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	public Long getCorpId() {
		return corpId;
	}
	public void setCorpId(Long corpId) {
		this.corpId = corpId;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getValidTag() {
		return validTag;
	}
	public void setValidTag(String validTag) {
		this.validTag = validTag;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getCorpName() {
		return corpName;
	}
	public void setCorpName(String corpName) {
		this.corpName = corpName;
	}
	public Short getSourceType() {
		return sourceType;
	}
	public void setSourceType(Short sourceType) {
		this.sourceType = sourceType;
	}
	public void setParentId(Long parentId) {
		this.parentId = parentId;
	}
	public Long getParentId() {
		return parentId;
	}
	public void setFee(String fee) {
		this.fee = fee;
	}
	public String getFee() {
		return fee;
	}
}
