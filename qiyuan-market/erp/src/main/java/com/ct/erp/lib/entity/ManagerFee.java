package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.FeeItem;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * ManagerFee entity. @author MyEclipse Persistence Tools
 */

public class ManagerFee implements java.io.Serializable {

	// Fields

	private Long id;
	private Staff staffByOperStaff;
	private FeeItem feeItem;
	private Staff staffByCreateStaff;
	private Timestamp beginDate;
	private Timestamp endDate;
	private Integer totalFee;
	private String remark;
	private String state;
	private Timestamp operTime;
	private Timestamp createTime;
	private Timestamp updateTime;
	private Set agencyDetailBillses = new HashSet(0);

	// Constructors

	/** default constructor */
	public ManagerFee() {
	}

	/** minimal constructor */
	public ManagerFee(FeeItem feeItem, Integer totalFee, String state) {
		this.feeItem = feeItem;
		this.totalFee = totalFee;
		this.state = state;
	}

	/** full constructor */
	public ManagerFee(Staff staffByOperStaff, FeeItem feeItem,
                      Staff staffByCreateStaff, Timestamp beginDate, Timestamp endDate,
                      Integer totalFee, String remark, String state, Timestamp operTime,
                      Timestamp createTime, Timestamp updateTime, Set agencyDetailBillses) {
		this.staffByOperStaff = staffByOperStaff;
		this.feeItem = feeItem;
		this.staffByCreateStaff = staffByCreateStaff;
		this.beginDate = beginDate;
		this.endDate = endDate;
		this.totalFee = totalFee;
		this.remark = remark;
		this.state = state;
		this.operTime = operTime;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.agencyDetailBillses = agencyDetailBillses;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Staff getStaffByOperStaff() {
		return this.staffByOperStaff;
	}

	public void setStaffByOperStaff(Staff staffByOperStaff) {
		this.staffByOperStaff = staffByOperStaff;
	}

	public FeeItem getFeeItem() {
		return this.feeItem;
	}

	public void setFeeItem(FeeItem feeItem) {
		this.feeItem = feeItem;
	}

	public Staff getStaffByCreateStaff() {
		return this.staffByCreateStaff;
	}

	public void setStaffByCreateStaff(Staff staffByCreateStaff) {
		this.staffByCreateStaff = staffByCreateStaff;
	}

	public Timestamp getBeginDate() {
		return this.beginDate;
	}

	public void setBeginDate(Timestamp beginDate) {
		this.beginDate = beginDate;
	}

	public Timestamp getEndDate() {
		return this.endDate;
	}

	public void setEndDate(Timestamp endDate) {
		this.endDate = endDate;
	}

	public Integer getTotalFee() {
		return this.totalFee;
	}

	public void setTotalFee(Integer totalFee) {
		this.totalFee = totalFee;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Timestamp getOperTime() {
		return this.operTime;
	}

	public void setOperTime(Timestamp operTime) {
		this.operTime = operTime;
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

	public Set getAgencyDetailBillses() {
		return this.agencyDetailBillses;
	}

	public void setAgencyDetailBillses(Set agencyDetailBillses) {
		this.agencyDetailBillses = agencyDetailBillses;
	}

}