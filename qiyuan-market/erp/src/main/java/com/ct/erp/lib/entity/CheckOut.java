package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Trade;

import java.sql.Timestamp;

/**
 * CheckOut entity. @author MyEclipse Persistence Tools
 */

public class CheckOut implements java.io.Serializable {

	// Fields

	private Long id;
	private Trade trade;
	private String leaveReason;
	private String checkResult;
	private String resultDesc;
	private Timestamp createTime;
	private Timestamp updateTime;

	// Constructors

	/** default constructor */
	public CheckOut() {
	}

	/** full constructor */
	public CheckOut(Trade trade, String leaveReason, String checkResult,
                    String resultDesc, Timestamp createTime, Timestamp updateTime) {
		this.trade = trade;
		this.leaveReason = leaveReason;
		this.checkResult = checkResult;
		this.resultDesc = resultDesc;
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

	public Trade getTrade() {
		return this.trade;
	}

	public void setTrade(Trade trade) {
		this.trade = trade;
	}

	public String getLeaveReason() {
		return this.leaveReason;
	}

	public void setLeaveReason(String leaveReason) {
		this.leaveReason = leaveReason;
	}

	public String getCheckResult() {
		return this.checkResult;
	}

	public void setCheckResult(String checkResult) {
		this.checkResult = checkResult;
	}

	public String getResultDesc() {
		return this.resultDesc;
	}

	public void setResultDesc(String resultDesc) {
		this.resultDesc = resultDesc;
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