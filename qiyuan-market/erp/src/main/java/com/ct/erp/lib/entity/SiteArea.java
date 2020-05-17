package com.ct.erp.lib.entity;

import java.util.HashSet;
import java.util.Set;

/**
 * SiteArea entity. @author MyEclipse Persistence Tools
 */

public class SiteArea implements java.io.Serializable {

	// Fields

	private Long id;
	private String areaName;
	private String rentType;
	private Double totalCount;
	private Integer monthRentFee;
	private String remark;
	private String status;
	private Double freeCount;
	private Set contractAreas = new HashSet(0);
	private Set agencyDetailBillses = new HashSet(0);
	private Market market;
	private Long marketId;
	// Constructors

	/** default constructor */
	public SiteArea() {
	}

	/** full constructor */
	public SiteArea(String areaName, String rentType, Double totalCount,
			Integer monthRentFee, String remark, String status,
			Double freeCount, Set contractAreas, Set agencyDetailBillses) {
		this.areaName = areaName;
		this.rentType = rentType;
		this.totalCount = totalCount;
		this.monthRentFee = monthRentFee;
		this.remark = remark;
		this.status = status;
		this.freeCount = freeCount;
		this.contractAreas = contractAreas;
		this.agencyDetailBillses = agencyDetailBillses;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getAreaName() {
		return this.areaName;
	}

	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}

	public String getRentType() {
		return this.rentType;
	}

	public void setRentType(String rentType) {
		this.rentType = rentType;
	}

	public Double getTotalCount() {
		return this.totalCount;
	}

	public void setTotalCount(Double totalCount) {
		this.totalCount = totalCount;
	}

	public Integer getMonthRentFee() {
		return this.monthRentFee;
	}

	public void setMonthRentFee(Integer monthRentFee) {
		this.monthRentFee = monthRentFee;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Double getFreeCount() {
		return this.freeCount;
	}

	public void setFreeCount(Double freeCount) {
		this.freeCount = freeCount;
	}

	public Set getContractAreas() {
		return this.contractAreas;
	}

	public void setContractAreas(Set contractAreas) {
		this.contractAreas = contractAreas;
	}

	public Set getAgencyDetailBillses() {
		return this.agencyDetailBillses;
	}

	public void setAgencyDetailBillses(Set agencyDetailBillses) {
		this.agencyDetailBillses = agencyDetailBillses;
	}

	public Market getMarket() {
		return market;
	}

	public Long getMarketId() {
		return marketId;
	}

	public void setMarketId(Long marketId) {
		this.marketId = marketId;
	}

	public void setMarket(Market market) {
		this.market = market;
	}
}