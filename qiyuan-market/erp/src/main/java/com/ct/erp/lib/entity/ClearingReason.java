package com.ct.erp.lib.entity;

import java.util.HashSet;
import java.util.Set;

/**
 * ClearingReason entity. @author MyEclipse Persistence Tools
 */

public class ClearingReason implements java.io.Serializable {

	// Fields

	private Long id;
	private String name;
	private String clearingDesc;
	private String status;
	private String clearingType;
	private Set shopContracts = new HashSet(0);
	private Set contracts = new HashSet(0);

	// Constructors

	/** default constructor */
	public ClearingReason() {
	}

	/** minimal constructor */
	public ClearingReason(String name, String status) {
		this.name = name;
		this.status = status;
	}

	/** full constructor */
	public ClearingReason(String name, String clearingDesc, String status,
			String clearingType, Set shopContracts, Set contracts) {
		this.name = name;
		this.clearingDesc = clearingDesc;
		this.status = status;
		this.clearingType = clearingType;
		this.shopContracts = shopContracts;
		this.contracts = contracts;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getClearingDesc() {
		return this.clearingDesc;
	}

	public void setClearingDesc(String clearingDesc) {
		this.clearingDesc = clearingDesc;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getClearingType() {
		return this.clearingType;
	}

	public void setClearingType(String clearingType) {
		this.clearingType = clearingType;
	}

	public Set getShopContracts() {
		return this.shopContracts;
	}

	public void setShopContracts(Set shopContracts) {
		this.shopContracts = shopContracts;
	}

	public Set getContracts() {
		return this.contracts;
	}

	public void setContracts(Set contracts) {
		this.contracts = contracts;
	}

}