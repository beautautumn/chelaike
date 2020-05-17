package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Trade;

import java.sql.Timestamp;
import java.util.Date;

/**
 * Approve entity. @author MyEclipse Persistence Tools
 */

public class Approve implements java.io.Serializable {

	// Fields

	private Long id;
	private Staff staff;
	private Trade trade;
	private Timestamp approveTime;
	private String approveDesc;
	private Date leaveDate;
	private String leaveType;
	private Integer leaveDays;
	private String leaveState;

	// Constructors

	/** default constructor */
	public Approve() {
	}

	/** full constructor */
	public Approve(Staff staff, Trade trade, Timestamp approveTime,
                   String approveDesc, Date leaveDate, String leaveType,
                   Integer leaveDays, String leaveState) {
		this.staff = staff;
		this.trade = trade;
		this.approveTime = approveTime;
		this.approveDesc = approveDesc;
		this.leaveDate = leaveDate;
		this.leaveType = leaveType;
		this.leaveDays = leaveDays;
		this.leaveState = leaveState;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public Trade getTrade() {
		return this.trade;
	}

	public void setTrade(Trade trade) {
		this.trade = trade;
	}

	public Timestamp getApproveTime() {
		return this.approveTime;
	}

	public void setApproveTime(Timestamp approveTime) {
		this.approveTime = approveTime;
	}

	public String getApproveDesc() {
		return this.approveDesc;
	}

	public void setApproveDesc(String approveDesc) {
		this.approveDesc = approveDesc;
	}

	public Date getLeaveDate() {
		return this.leaveDate;
	}

	public void setLeaveDate(Date leaveDate) {
		this.leaveDate = leaveDate;
	}

	public String getLeaveType() {
		return this.leaveType;
	}

	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}

	public Integer getLeaveDays() {
		return this.leaveDays;
	}

	public void setLeaveDays(Integer leaveDays) {
		this.leaveDays = leaveDays;
	}

	public String getLeaveState() {
		return this.leaveState;
	}

	public void setLeaveState(String leaveState) {
		this.leaveState = leaveState;
	}

}