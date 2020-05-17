package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.ShopContract;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * ContractCollectionPlan entity. @author MyEclipse Persistence Tools
 */

public class ContractCollectionPlan implements java.io.Serializable {

	// Fields

	private Long id;
	private ShopContract shopContract;
	private Date planCollectionDate;
	private Integer planCollectionFee;
	private Integer planCollectionDeposit;
	private Integer recvFee;
	private Integer recvDeposit;
	private Timestamp createTime;
	private Timestamp updateTime;
	private String state;
	private Set contractCollectionRecords = new HashSet(0);

	// Constructors

	/** default constructor */
	public ContractCollectionPlan() {
	}

	/** full constructor */
	public ContractCollectionPlan(ShopContract shopContract,
			Date planCollectionDate, Integer planCollectionFee,
			Integer planCollectionDeposit, Integer recvFee,
			Integer recvDeposit, Timestamp createTime, Timestamp updateTime,
			String state, Set contractCollectionRecords) {
		this.shopContract = shopContract;
		this.planCollectionDate = planCollectionDate;
		this.planCollectionFee = planCollectionFee;
		this.planCollectionDeposit = planCollectionDeposit;
		this.recvFee = recvFee;
		this.recvDeposit = recvDeposit;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.state = state;
		this.contractCollectionRecords = contractCollectionRecords;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ShopContract getShopContract() {
		return this.shopContract;
	}

	public void setShopContract(ShopContract shopContract) {
		this.shopContract = shopContract;
	}

	public Date getPlanCollectionDate() {
		return this.planCollectionDate;
	}

	public void setPlanCollectionDate(Date planCollectionDate) {
		this.planCollectionDate = planCollectionDate;
	}

	public Integer getPlanCollectionFee() {
		return this.planCollectionFee;
	}

	public void setPlanCollectionFee(Integer planCollectionFee) {
		this.planCollectionFee = planCollectionFee;
	}

	public Integer getPlanCollectionDeposit() {
		return this.planCollectionDeposit;
	}

	public void setPlanCollectionDeposit(Integer planCollectionDeposit) {
		this.planCollectionDeposit = planCollectionDeposit;
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

	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Set getContractCollectionRecords() {
		return this.contractCollectionRecords;
	}

	public void setContractCollectionRecords(Set contractCollectionRecords) {
		this.contractCollectionRecords = contractCollectionRecords;
	}

}