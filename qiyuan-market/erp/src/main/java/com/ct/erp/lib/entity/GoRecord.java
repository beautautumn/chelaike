package com.ct.erp.lib.entity;

import java.sql.Timestamp;

/**
 * GoRecord entity. @author MyEclipse Persistence Tools
 */

public class GoRecord implements java.io.Serializable {

	// Fields

	private Long id;
	private Long cardNo;
	private String oldLicenseCode;
	private String newLicenseCode;
	private String agencyName;
	private Timestamp secTransferTime;
	private Long agencyId;
	private String status;

	// Constructors

	/** default constructor */
	public GoRecord() {
	}

	/** full constructor */
	public GoRecord(Long cardNo, String oldLicenseCode, String newLicenseCode,
			String agencyName, Timestamp secTransferTime, Long agencyId,
			String status) {
		this.cardNo = cardNo;
		this.oldLicenseCode = oldLicenseCode;
		this.newLicenseCode = newLicenseCode;
		this.agencyName = agencyName;
		this.secTransferTime = secTransferTime;
		this.agencyId = agencyId;
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

	public String getOldLicenseCode() {
		return this.oldLicenseCode;
	}

	public void setOldLicenseCode(String oldLicenseCode) {
		this.oldLicenseCode = oldLicenseCode;
	}

	public String getNewLicenseCode() {
		return this.newLicenseCode;
	}

	public void setNewLicenseCode(String newLicenseCode) {
		this.newLicenseCode = newLicenseCode;
	}

	public String getAgencyName() {
		return this.agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public Timestamp getSecTransferTime() {
		return this.secTransferTime;
	}

	public void setSecTransferTime(Timestamp secTransferTime) {
		this.secTransferTime = secTransferTime;
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

}