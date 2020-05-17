package com.ct.erp.lib.entity;

import java.sql.Timestamp;

/**
 * InSyncHis entity. @author MyEclipse Persistence Tools
 */

public class InSyncHis implements java.io.Serializable {

	// Fields

	private Long id;
	private Long cardNo;
	private String licenseCode;
	private String outerId;
	private Timestamp createTime;
	private Timestamp comeTime;

	// Constructors

	/** default constructor */
	public InSyncHis() {
	}

	/** full constructor */
	public InSyncHis(Long cardNo, String licenseCode, String outerId,
			Timestamp createTime, Timestamp comeTime) {
		this.cardNo = cardNo;
		this.licenseCode = licenseCode;
		this.outerId = outerId;
		this.createTime = createTime;
		this.comeTime = comeTime;
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

	public Timestamp getComeTime() {
		return this.comeTime;
	}

	public void setComeTime(Timestamp comeTime) {
		this.comeTime = comeTime;
	}

}