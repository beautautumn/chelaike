package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * AgencyBills entity. @author MyEclipse Persistence Tools
 */

public class AgencyBills implements java.io.Serializable {

	// Fields

	private Long id;
	private Agency agency;
	private Staff staff;
	private Integer feeValue;
	private Integer shareTotalFee;
	private Integer independentTotalFee;
	private Timestamp recvTime;
	private Integer recvFee;
	private String recvDesc;
	private String state;
	private Set agencyDetailBillses = new HashSet(0);

	// Constructors

	/** default constructor */
	public AgencyBills() {
	}

	/** minimal constructor */
	public AgencyBills(Agency agency, Integer feeValue, String state) {
		this.agency = agency;
		this.feeValue = feeValue;
		this.state = state;
	}

	/** full constructor */
	public AgencyBills(Agency agency, Staff staff, Integer feeValue,
                       Integer shareTotalFee, Integer independentTotalFee,
                       Timestamp recvTime, Integer recvFee, String recvDesc, String state,
                       Set agencyDetailBillses) {
		this.agency = agency;
		this.staff = staff;
		this.feeValue = feeValue;
		this.shareTotalFee = shareTotalFee;
		this.independentTotalFee = independentTotalFee;
		this.recvTime = recvTime;
		this.recvFee = recvFee;
		this.recvDesc = recvDesc;
		this.state = state;
		this.agencyDetailBillses = agencyDetailBillses;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Agency getAgency() {
		return this.agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public Integer getFeeValue() {
		return this.feeValue;
	}

	public void setFeeValue(Integer feeValue) {
		this.feeValue = feeValue;
	}

	public Integer getShareTotalFee() {
		return this.shareTotalFee;
	}

	public void setShareTotalFee(Integer shareTotalFee) {
		this.shareTotalFee = shareTotalFee;
	}

	public Integer getIndependentTotalFee() {
		return this.independentTotalFee;
	}

	public void setIndependentTotalFee(Integer independentTotalFee) {
		this.independentTotalFee = independentTotalFee;
	}

	public Timestamp getRecvTime() {
		return this.recvTime;
	}

	public void setRecvTime(Timestamp recvTime) {
		this.recvTime = recvTime;
	}

	public Integer getRecvFee() {
		return this.recvFee;
	}

	public void setRecvFee(Integer recvFee) {
		this.recvFee = recvFee;
	}

	public String getRecvDesc() {
		return this.recvDesc;
	}

	public void setRecvDesc(String recvDesc) {
		this.recvDesc = recvDesc;
	}

	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Set getAgencyDetailBillses() {
		return this.agencyDetailBillses;
	}

	public void setAgencyDetailBillses(Set agencyDetailBillses) {
		this.agencyDetailBillses = agencyDetailBillses;
	}

}