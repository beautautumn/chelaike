package com.ct.erp.lib.entity;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * SiteShop entity. @author MyEclipse Persistence Tools
 */

public class SiteShop implements java.io.Serializable {

	// Fields

	private Long id;
	private String areaName;
	private Integer totalCount;
	private Integer monthRentFee;
	private String remark;
	private String validTag;
	private Integer freeCount;
	private Timestamp createTime;
	private Timestamp updateTime;
	private Set contractShops = new HashSet(0);

	// Constructors

	/** default constructor */
	public SiteShop() {
	}

	/** full constructor */
	public SiteShop(String areaName, Integer totalCount, Integer monthRentFee,
			String remark, String validTag, Integer freeCount,
			Timestamp createTime, Timestamp updateTime, Set contractShops) {
		this.areaName = areaName;
		this.totalCount = totalCount;
		this.monthRentFee = monthRentFee;
		this.remark = remark;
		this.validTag = validTag;
		this.freeCount = freeCount;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.contractShops = contractShops;
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

	public Integer getTotalCount() {
		return this.totalCount;
	}

	public void setTotalCount(Integer totalCount) {
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

	public String getValidTag() {
		return this.validTag;
	}

	public void setValidTag(String validTag) {
		this.validTag = validTag;
	}

	public Integer getFreeCount() {
		return this.freeCount;
	}

	public void setFreeCount(Integer freeCount) {
		this.freeCount = freeCount;
	}

	public Timestamp getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

	public Timestamp getUpdateTime() {
		return this.updateTime;
	}

	public void setUpdateTime(Timestamp updateTime) {
		this.updateTime = updateTime;
	}

	public Set getContractShops() {
		return this.contractShops;
	}

	public void setContractShops(Set contractShops) {
		this.contractShops = contractShops;
	}

}