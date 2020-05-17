package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.ContractCollectionPlan;
import com.ct.erp.lib.entity.ShopContract;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;
import java.util.Date;

/**
 * ContractCollectionRecord entity. @author MyEclipse Persistence Tools
 */

public class ContractCollectionRecord implements java.io.Serializable {

	// Fields

	private Long id;
	private ContractCollectionPlan contractCollectionPlan;
	private Staff staff;
	private ShopContract shopContract;
	private Integer recvFee;
	private Integer recvDeposit;
	private Date collectionDate;
	private String remark;
	private Timestamp createTime;
	private Timestamp updateTime;

	// Constructors

	/** default constructor */
	public ContractCollectionRecord() {
	}

	/** full constructor */
	public ContractCollectionRecord(
            ContractCollectionPlan contractCollectionPlan, Staff staff,
            ShopContract shopContract, Integer recvFee, Integer recvDeposit,
            Date collectionDate, String remark, Timestamp createTime,
            Timestamp updateTime) {
		this.contractCollectionPlan = contractCollectionPlan;
		this.staff = staff;
		this.shopContract = shopContract;
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

	public ContractCollectionPlan getContractCollectionPlan() {
		return this.contractCollectionPlan;
	}

	public void setContractCollectionPlan(
			ContractCollectionPlan contractCollectionPlan) {
		this.contractCollectionPlan = contractCollectionPlan;
	}

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public ShopContract getShopContract() {
		return this.shopContract;
	}

	public void setShopContract(ShopContract shopContract) {
		this.shopContract = shopContract;
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