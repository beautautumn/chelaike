package com.ct.erp.lib.entity;

import java.sql.Timestamp;

/**
 * ParkRecord entity. @author MyEclipse Persistence Tools
 */

public class ParkRecord implements java.io.Serializable {

	// Fields

	private Long id;
	private Long objId;
	private String barCode;
	private String operType;
	private Timestamp operTime;
	private String operDeviceId;
	private Timestamp createTime;
	private Timestamp updateTime;

	// Constructors

	/** default constructor */
	public ParkRecord() {
	}

	/** minimal constructor */
	public ParkRecord(String operDeviceId) {
		this.operDeviceId = operDeviceId;
	}

	/** full constructor */
	public ParkRecord(Long objId, String barCode, String operType,
			Timestamp operTime, String operDeviceId, Timestamp createTime,
			Timestamp updateTime) {
		this.objId = objId;
		this.barCode = barCode;
		this.operType = operType;
		this.operTime = operTime;
		this.operDeviceId = operDeviceId;
		this.createTime = createTime;
		this.updateTime = updateTime;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getObjId() {
		return this.objId;
	}

	public void setObjId(Long objId) {
		this.objId = objId;
	}

	public String getBarCode() {
		return this.barCode;
	}

	public void setBarCode(String barCode) {
		this.barCode = barCode;
	}

	public String getOperType() {
		return this.operType;
	}

	public void setOperType(String operType) {
		this.operType = operType;
	}

	public Timestamp getOperTime() {
		return this.operTime;
	}

	public void setOperTime(Timestamp operTime) {
		this.operTime = operTime;
	}

	public String getOperDeviceId() {
		return this.operDeviceId;
	}

	public void setOperDeviceId(String operDeviceId) {
		this.operDeviceId = operDeviceId;
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

}