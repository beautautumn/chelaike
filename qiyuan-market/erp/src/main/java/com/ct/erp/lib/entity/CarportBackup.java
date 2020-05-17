package com.ct.erp.lib.entity;

/**
 * CarportBackup entity. @author MyEclipse Persistence Tools
 */

public class CarportBackup implements java.io.Serializable {

	// Fields

	private Long id;
	private Long agencyId;
	private Integer totalNum;

	// Constructors

	/** default constructor */
	public CarportBackup() {
	}

	/** full constructor */
	public CarportBackup(Long agencyId, Integer totalNum) {
		this.agencyId = agencyId;
		this.totalNum = totalNum;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getAgencyId() {
		return this.agencyId;
	}

	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}

	public Integer getTotalNum() {
		return this.totalNum;
	}

	public void setTotalNum(Integer totalNum) {
		this.totalNum = totalNum;
	}

}