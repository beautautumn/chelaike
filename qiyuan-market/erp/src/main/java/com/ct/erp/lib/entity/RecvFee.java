package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;

/**
 * RecvFee entity. @author MyEclipse Persistence Tools
 */

public class RecvFee implements java.io.Serializable {

	// Fields

	private Long id;
	private Staff staff;
	private Contract contract;
	private Timestamp asOfDate;
	private Integer recvFee;
	private Integer recvDepositFee;
	private Timestamp recvDate;
	private String remark;
	private String recvType;
	private Timestamp createTime;
	private Timestamp updateTime;

	// Constructors

	/** default constructor */
	public RecvFee() {
	}

	/** minimal constructor */
	public RecvFee(Integer recvFee, Timestamp recvDate, String recvType) {
		this.recvFee = recvFee;
		this.recvDate = recvDate;
		this.recvType = recvType;
	}

	/** full constructor */
	public RecvFee(Staff staff, Contract contract, Timestamp asOfDate,
                   Integer recvFee, Integer recvDepositFee, Timestamp recvDate,
                   String remark, String recvType, Timestamp createTime,
                   Timestamp updateTime) {
		this.staff = staff;
		this.contract = contract;
		this.asOfDate = asOfDate;
		this.recvFee = recvFee;
		this.recvDepositFee = recvDepositFee;
		this.recvDate = recvDate;
		this.remark = remark;
		this.recvType = recvType;
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

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public Contract getContract() {
		return this.contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}

	public Timestamp getAsOfDate() {
		return this.asOfDate;
	}

	public void setAsOfDate(Timestamp asOfDate) {
		this.asOfDate = asOfDate;
	}

	public Integer getRecvFee() {
		return this.recvFee;
	}

	public void setRecvFee(Integer recvFee) {
		this.recvFee = recvFee;
	}

	public Integer getRecvDepositFee() {
		return this.recvDepositFee;
	}

	public void setRecvDepositFee(Integer recvDepositFee) {
		this.recvDepositFee = recvDepositFee;
	}

	public Timestamp getRecvDate() {
		return this.recvDate;
	}

	public void setRecvDate(Timestamp recvDate) {
		this.recvDate = recvDate;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getRecvType() {
		return this.recvType;
	}

	public void setRecvType(String recvType) {
		this.recvType = recvType;
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