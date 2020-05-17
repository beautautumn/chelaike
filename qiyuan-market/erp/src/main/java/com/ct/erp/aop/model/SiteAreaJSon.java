package com.ct.erp.aop.model;


/**
 * @author shiqingwen
 */

public class SiteAreaJSon {

	// Fields

	private Long id;
	private String areaName;
	private String rentType;
	private Double totalCount;
	private Integer monthRentFee;
	private String remark;
	private String status;
	private Double freeCount;
	
	public SiteAreaJSon(com.ct.erp.lib.entity.SiteArea siteArea){
		if(siteArea != null){
			this.id = siteArea.getId();
			this.areaName = siteArea.getAreaName();
			this.rentType = siteArea.getRentType();
			this.totalCount = siteArea.getTotalCount();
			this.monthRentFee = siteArea.getMonthRentFee();
			this.remark = siteArea.getRemark();
			this.status = siteArea.getStatus();
			this.freeCount = siteArea.getFreeCount();
		}
	}
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getAreaName() {
		return areaName;
	}
	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}
	public String getRentType() {
		return rentType;
	}
	public void setRentType(String rentType) {
		this.rentType = rentType;
	}
	public Double getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(Double totalCount) {
		this.totalCount = totalCount;
	}
	public Integer getMonthRentFee() {
		return monthRentFee;
	}
	public void setMonthRentFee(Integer monthRentFee) {
		this.monthRentFee = monthRentFee;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Double getFreeCount() {
		return freeCount;
	}
	public void setFreeCount(Double freeCount) {
		this.freeCount = freeCount;
	}
	
	


}