package com.ct.erp.lib.entity;

import java.sql.Timestamp;

/**
 * GoSync entity. @author MyEclipse Persistence Tools
 */

public class GoSync implements java.io.Serializable {

	// Fields

	private Long id;
	private Long cardNo;
	private String licenseCode;
	private String outerId;
	private Timestamp createTime;
	private Timestamp goTime;
	private String status;

	// Constructors

	/** default constructor */
	public GoSync() {
	}

	/** full constructor */
	public GoSync(Long cardNo, String licenseCode, String outerId,
			Timestamp createTime, Timestamp goTime, String status) {
		this.cardNo = cardNo;
		this.licenseCode = licenseCode;
		this.outerId = outerId;
		this.createTime = createTime;
		this.goTime = goTime;
		this.status = status;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getCardNo() {
		return this.cardNo;
	}

	public void setCardNo(Long cardNo) {
		this.cardNo = cardNo;
	}

	public String getLicenseCode() {
		return this.licenseCode;
	}

	public void setLicenseCode(String licenseCode) {
		this.licenseCode = licenseCode;
	}

	public String getOuterId() {
		return this.outerId;
	}

	public void setOuterId(String outerId) {
		this.outerId = outerId;
	}

	public Timestamp getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

	public Timestamp getGoTime() {
		return this.goTime;
	}

	public void setGoTime(Timestamp goTime) {
		this.goTime = goTime;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}