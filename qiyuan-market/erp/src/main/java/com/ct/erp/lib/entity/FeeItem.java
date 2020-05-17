package com.ct.erp.lib.entity;

import java.util.HashSet;
import java.util.Set;

/**
 * FeeItem entity. @author MyEclipse Persistence Tools
 */

public class FeeItem implements java.io.Serializable {

	// Fields

	private Long id;
	private String itemName;
	private String itemDesc;
	private String status;
	private String itemGroup;
	private Set managerFees = new HashSet(0);
	private Set agencyDetailBillses = new HashSet(0);

	// Constructors

	/** default constructor */
	public FeeItem() {
	}

	/** minimal constructor */
	public FeeItem(String itemName, String status) {
		this.itemName = itemName;
		this.status = status;
	}

	/** full constructor */
	public FeeItem(String itemName, String itemDesc, String status,
			String itemGroup, Set managerFees, Set agencyDetailBillses) {
		this.itemName = itemName;
		this.itemDesc = itemDesc;
		this.status = status;
		this.itemGroup = itemGroup;
		this.managerFees = managerFees;
		this.agencyDetailBillses = agencyDetailBillses;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getItemName() {
		return this.itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getItemDesc() {
		return this.itemDesc;
	}

	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getItemGroup() {
		return this.itemGroup;
	}

	public void setItemGroup(String itemGroup) {
		this.itemGroup = itemGroup;
	}

	public Set getManagerFees() {
		return this.managerFees;
	}

	public void setManagerFees(Set managerFees) {
		this.managerFees = managerFees;
	}

	public Set getAgencyDetailBillses() {
		return this.agencyDetailBillses;
	}

	public void setAgencyDetailBillses(Set agencyDetailBillses) {
		this.agencyDetailBillses = agencyDetailBillses;
	}

}