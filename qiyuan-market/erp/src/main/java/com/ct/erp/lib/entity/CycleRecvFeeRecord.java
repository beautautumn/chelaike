package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.CycleRecvFee;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;
import java.util.Date;

/**
 * CycleRecvFeeRecord entity. @author MyEclipse Persistence Tools
 */

public class CycleRecvFeeRecord implements java.io.Serializable {

	// Fields

	private Long id;
	private CycleRecvFee cycleRecvFee;
	private Staff staff;
	private Contract contract;
	private Integer recvFee;
	private Integer recvDeposit;
	private Date collectionDate;
	private String remark;
	private Timestamp createTime;
	private Timestamp updateTime;

	// Constructors

	/** default constructor */
	public CycleRecvFeeRecord() {
	}

	/** full constructor */
	public CycleRecvFeeRecord(CycleRecvFee cycleRecvFee, Staff staff,
                              Contract contract, Integer recvFee, Integer recvDeposit,
                              Date collectionDate, String remark, Timestamp createTime,
                              Timestamp updateTime) {
		this.cycleRecvFee = cycleRecvFee;
		this.staff = staff;
		this.contract = contract;
		this.recvFee = recvFee;
		this.recvDeposit = recvDeposit;
		this.collectionDate = collectionDate;
		this.remark = remark;
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

	public CycleRecvFee getCycleRecvFee() {
		return this.cycleRecvFee;
	}

	public void setCycleRecvFee(CycleRecvFee cycleRecvFee) {
		this.cycleRecvFee = cycleRecvFee;
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

	public Integer getRecvFee() {
		return this.recvFee;
	}

	public void setRecvFee(Integer recvFee) {
		this.recvFee = recvFee;
	}

	public Integer getRecvDeposit() {
		return this.recvDeposit;
	}

	public void setRecvDeposit(Integer recvDeposit) {
		this.recvDeposit = recvDeposit;
	}

	public Date getCollectionDate() {
		return this.collectionDate;
	}

	public void setCollectionDate(Date collectionDate) {
		this.collectionDate = collectionDate;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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