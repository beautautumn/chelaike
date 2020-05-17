package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Vehicle;

import java.sql.Timestamp;

/**
 * PersionalAuction entity. @author MyEclipse Persistence Tools
 */

public class PersionalAuction implements java.io.Serializable {

	// Fields

	private Long id;
	private Vehicle vehicle;
	private String contractMan;
	private String contractNumber;
	private String basePrice;
	private Timestamp createTime;
	private Timestamp updateTime;

	// Constructors

	/** default constructor */
	public PersionalAuction() {
	}

	/** full constructor */
	public PersionalAuction(Vehicle vehicle, String contractMan,
                            String contractNumber, String basePrice, Timestamp createTime,
                            Timestamp updateTime) {
		this.vehicle = vehicle;
		this.contractMan = contractMan;
		this.contractNumber = contractNumber;
		this.basePrice = basePrice;
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

	public Vehicle getVehicle() {
		return this.vehicle;
	}

	public void setVehicle(Vehicle vehicle) {
		this.vehicle = vehicle;
	}

	public String getContractMan() {
		return this.contractMan;
	}

	public void setContractMan(String contractMan) {
		this.contractMan = contractMan;
	}

	public String getContractNumber() {
		return this.contractNumber;
	}

	public void setContractNumber(String contractNumber) {
		this.contractNumber = contractNumber;
	}

	public String getBasePrice() {
		return this.basePrice;
	}

	public void setBasePrice(String basePrice) {
		this.basePrice = basePrice;
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