package com.ct.erp.lib.entity;

import java.sql.Timestamp;

/**
 * CwVSync entity. @author MyEclipse Persistence Tools
 */

public class CwVSync implements java.io.Serializable {

	// Fields

	private Long id;
	private Long cardNo;
	private String licenseCode;
	private String agencyName;
	private String statue;
	private Timestamp addTime;
	private Timestamp createTime;

	// Constructors

	/** default constructor */
	public CwVSync() {
	}

	/** full constructor */
	public CwVSync(Long cardNo, String licenseCode, String agencyName,
			String statue, Timestamp addTime, Timestamp createTime) {
		this.cardNo = cardNo;
		this.licenseCode = licenseCode;
		this.agencyName = agencyName;
		this.statue = statue;
		this.addTime = addTime;
		this.createTime = createTime;
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

	public String getAgencyName() {
		return this.agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public String getStatue() {
		return this.statue;
	}

	public void setStatue(String statue) {
		this.statue = statue;
	}

	public Timestamp getAddTime() {
		return this.addTime;
	}

	public void setAddTime(Timestamp addTime) {
		this.addTime = addTime;
	}

	public Timestamp getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

}