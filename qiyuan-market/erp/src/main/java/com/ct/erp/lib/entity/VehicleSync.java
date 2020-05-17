package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Trade;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * VehicleSync entity. @author MyEclipse Persistence Tools
 */

public class VehicleSync implements java.io.Serializable {

	// Fields

	private Long id;
	private Trade trade;
	private String state;
	private Timestamp doTime;
	private String msgInfo;
	private Timestamp createTime;
	private String status;
	private String errorInfo;
	private Integer syncNum;
	private Set vehicleSyncHises = new HashSet(0);

	// Constructors

	/** default constructor */
	public VehicleSync() {
	}

	/** full constructor */
	public VehicleSync(Trade trade, String state, Timestamp doTime,
                       String msgInfo, Timestamp createTime, String status,
                       String errorInfo, Integer syncNum, Set vehicleSyncHises) {
		this.trade = trade;
		this.state = state;
		this.doTime = doTime;
		this.msgInfo = msgInfo;
		this.createTime = createTime;
		this.status = status;
		this.errorInfo = errorInfo;
		this.syncNum = syncNum;
		this.vehicleSyncHises = vehicleSyncHises;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Trade getTrade() {
		return this.trade;
	}

	public void setTrade(Trade trade) {
		this.trade = trade;
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

	public Set getVehicleSyncHises() {
		return this.vehicleSyncHises;
	}

	public void setVehicleSyncHises(Set vehicleSyncHises) {
		this.vehicleSyncHises = vehicleSyncHises;
	}

}