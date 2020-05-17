package com.ct.erp.lib.entity;

import java.sql.Timestamp;

/**
 * GoRecordHis entity. @author MyEclipse Persistence Tools
 */

public class GoRecordHis implements java.io.Serializable {

	// Fields

	private Long id;
	private Long cardNo;
	private String oldLicenseCode;
	private String newLicenseCode;
	private String agencyName;
	private Timestamp secTransferTime;
	private Long agencyId;

	// Constructors

	/** default constructor */
	public GoRecordHis() {
	}

	/** full constructor */
	public GoRecordHis(Long cardNo, String oldLicenseCode,
			String newLicenseCode, String agencyName,
			Timestamp secTransferTime, Long agencyId) {
		this.cardNo = cardNo;
		this.oldLicenseCode = oldLicenseCode;
		this.newLicenseCode = newLicenseCode;
		this.agencyName = agencyName;
		this.secTransferTime = secTransferTime;
		this.agencyId = agencyId;
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

}