package com.ct.erp.lib.entity;

import java.sql.Timestamp;

/**
 * CarSync entity. @author MyEclipse Persistence Tools
 */

public class CarSync implements java.io.Serializable {

	// Fields

	private Long id;
	private Long clkId;
	private Long agencyId;
	private String status;
	private String errorInfo;
	private Integer syncNum;
	private Timestamp createTime;

	// Constructors

	/** default constructor */
	public CarSync() {
	}

	/** full constructor */
	public CarSync(Long clkId, Long agencyId, String status, String errorInfo,
			Integer syncNum, Timestamp createTime) {
		this.clkId = clkId;
		this.agencyId = agencyId;
		this.status = status;
		this.errorInfo = errorInfo;
		this.syncNum = syncNum;
		this.createTime = createTime;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getClkId() {
		return this.clkId;
	}

	public void setClkId(Long clkId) {
		this.clkId = clkId;
	}

	public Long getAgencyId() {
		return this.agencyId;
	}

	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getErrorInfo() {
		return this.errorInfo;
	}

	public void setErrorInfo(String errorInfo) {
		this.errorInfo = errorInfo;
	}

	public Integer getSyncNum() {
		return this.syncNum;
	}

	public void setSyncNum(Integer syncNum) {
		this.syncNum = syncNum;
	}

	public Timestamp getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

}