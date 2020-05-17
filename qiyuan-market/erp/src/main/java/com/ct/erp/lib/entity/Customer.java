package com.ct.erp.lib.entity;

import java.util.HashSet;
import java.util.Set;

/**
 * Customer entity. @author MyEclipse Persistence Tools
 */

public class Customer implements java.io.Serializable {

	// Fields

	private Long id;
	private String custName;
	private String phoneNumber;
	private String idCard;
	private String custAddr;
	private Set tradesForSellCustId = new HashSet(0);
	private Set tradesForBuyCustId = new HashSet(0);

	// Constructors

	/** default constructor */
	public Customer() {
	}

	/** full constructor */
	public Customer(String custName, String phoneNumber, String idCard,
			String custAddr, Set tradesForSellCustId, Set tradesForBuyCustId) {
		this.custName = custName;
		this.phoneNumber = phoneNumber;
		this.idCard = idCard;
		this.custAddr = custAddr;
		this.tradesForSellCustId = tradesForSellCustId;
		this.tradesForBuyCustId = tradesForBuyCustId;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCustName() {
		return this.custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getPhoneNumber() {
		return this.phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getIdCard() {
		return this.idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}

	public String getCustAddr() {
		return this.custAddr;
	}

	public void setCustAddr(String custAddr) {
		this.custAddr = custAddr;
	}

	public Set getTradesForSellCustId() {
		return this.tradesForSellCustId;
	}

	public void setTradesForSellCustId(Set tradesForSellCustId) {
		this.tradesForSellCustId = tradesForSellCustId;
	}

	public Set getTradesForBuyCustId() {
		return this.tradesForBuyCustId;
	}

	public void setTradesForBuyCustId(Set tradesForBuyCustId) {
		this.tradesForBuyCustId = tradesForBuyCustId;
	}

}