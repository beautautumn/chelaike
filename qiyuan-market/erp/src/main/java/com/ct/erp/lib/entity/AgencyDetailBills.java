package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.AgencyBills;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.FeeItem;
import com.ct.erp.lib.entity.ManagerFee;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;

/**
 * AgencyDetailBills entity. @author MyEclipse Persistence Tools
 */

public class AgencyDetailBills implements java.io.Serializable {

	// Fields

	private Long id;
	private Staff staff;
	private SiteArea siteArea;
	private FeeItem feeItem;
	private ManagerFee managerFee;
	private Agency agency;
	private AgencyBills agencyBills;
	private ContractArea contractArea;
	private Integer feeValue;
	private String state;
	private String feeType;
	private Timestamp operTime;
	private String remark;

	// Constructors

	/** default constructor */
	public AgencyDetailBills() {
	}

	/** minimal constructor */
	public AgencyDetailBills(Staff staff, Integer feeValue, String state,
                             String feeType, Timestamp operTime) {
		this.staff = staff;
		this.feeValue = feeValue;
		this.state = state;
		this.feeType = feeType;
		this.operTime = operTime;
	}

	/** full constructor */
	public AgencyDetailBills(Staff staff, SiteArea siteArea, FeeItem feeItem,
                             ManagerFee managerFee, Agency agency, AgencyBills agencyBills,
                             ContractArea contractArea, Integer feeValue, String state,
                             String feeType, Timestamp operTime, String remark) {
		this.staff = staff;
		this.siteArea = siteArea;
		this.feeItem = feeItem;
		this.managerFee = managerFee;
		this.agency = agency;
		this.agencyBills = agencyBills;
		this.contractArea = contractArea;
		this.feeValue = feeValue;
		this.state = state;
		this.feeType = feeType;
		this.operTime = operTime;
		this.remark = remark;
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

	public SiteArea getSiteArea() {
		return this.siteArea;
	}

	public void setSiteArea(SiteArea siteArea) {
		this.siteArea = siteArea;
	}

	public FeeItem getFeeItem() {
		return this.feeItem;
	}

	public void setFeeItem(FeeItem feeItem) {
		this.feeItem = feeItem;
	}

	public ManagerFee getManagerFee() {
		return this.managerFee;
	}

	public void setManagerFee(ManagerFee managerFee) {
		this.managerFee = managerFee;
	}

	public Agency getAgency() {
		return this.agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public AgencyBills getAgencyBills() {
		return this.agencyBills;
	}

	public void setAgencyBills(AgencyBills agencyBills) {
		this.agencyBills = agencyBills;
	}

	public ContractArea getContractArea() {
		return this.contractArea;
	}

	public void setContractArea(ContractArea contractArea) {
		this.contractArea = contractArea;
	}

	public Integer getFeeValue() {
		return this.feeValue;
	}

	public void setFeeValue(Integer feeValue) {
		this.feeValue = feeValue;
	}

	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getFeeType() {
		return this.feeType;
	}

	public void setFeeType(String feeType) {
		this.feeType = feeType;
	}

	public Timestamp getOperTime() {
		return this.operTime;
	}

	public void setOperTime(Timestamp operTime) {
		this.operTime = operTime;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}