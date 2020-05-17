package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;

import java.sql.Timestamp;

/**
 * AgencySync entity. @author MyEclipse Persistence Tools
 */

public class AgencySync implements java.io.Serializable {

	// Fields

	private Long id;
	private Agency agency;
	private String state;
	private Timestamp doTime;
	private String msgInfo;
	private Timestamp createTime;
	private String status;
	private String errorInfo;
	private Integer syncNum;

	// Constructors

	/** default constructor */
	public AgencySync() {
	}

	/** full constructor */
	public AgencySync(Agency agency, String state, Timestamp doTime,
                      String msgInfo, Timestamp createTime, String status,
                      String errorInfo, Integer syncNum) {
		this.agency = agency;
		this.state = state;
		this.doTime = doTime;
		this.msgInfo = msgInfo;
		this.createTime = createTime;
		this.status = status;
		this.errorInfo = errorInfo;
		this.syncNum = syncNum;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Agency getAgency() {
		return this.agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Timestamp getDoTime() {
		return this.doTime;
	}

	public void setDoTime(Timestamp doTime) {
		this.doTime = doTime;
	}

	public String getMsgInfo() {
		return this.msgInfo;
	}

	public void setMsgInfo(String msgInfo) {
		this.msgInfo = msgInfo;
	}

	public Timestamp getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
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

}