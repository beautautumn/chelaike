package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.SiteArea;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * ContractArea entity. @author MyEclipse Persistence Tools
 */

public class ContractArea implements java.io.Serializable {

	// Fields

	private Long id;
	private SiteArea siteArea;
	private Contract contract;
	private Integer monthRentFee;
	private Double leaseCount;
	private Integer monthTotalFee;
	private String areaNo;
	private Integer carCount;
	private Timestamp startDate;
	private Timestamp endDate;
	private Timestamp createTime;
	private Timestamp updateTime;
	private String status;
	private Set agencyDetailBillses = new HashSet(0);

	// Constructors

	/** default constructor */
	public ContractArea() {
	}

	/** minimal constructor */
	public ContractArea(SiteArea siteArea, Contract contract,
                        Integer monthRentFee, Double leaseCount, Integer monthTotalFee,
                        String areaNo, Integer carCount) {
		this.siteArea = siteArea;
		this.contract = contract;
		this.monthRentFee = monthRentFee;
		this.leaseCount = leaseCount;
		this.monthTotalFee = monthTotalFee;
		this.areaNo = areaNo;
		this.carCount = carCount;
	}

	/** full constructor */
	public ContractArea(SiteArea siteArea, Contract contract,
                        Integer monthRentFee, Double leaseCount, Integer monthTotalFee,
                        String areaNo, Integer carCount, Timestamp startDate,
                        Timestamp endDate, Timestamp createTime, Timestamp updateTime,
                        String status, Set agencyDetailBillses) {
		this.siteArea = siteArea;
		this.contract = contract;
		this.monthRentFee = monthRentFee;
		this.leaseCount = leaseCount;
		this.monthTotalFee = monthTotalFee;
		this.areaNo = areaNo;
		this.carCount = carCount;
		this.startDate = startDate;
		this.endDate = endDate;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.status = status;
		this.agencyDetailBillses = agencyDetailBillses;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public SiteArea getSiteArea() {
		return this.siteArea;
	}

	public void setSiteArea(SiteArea siteArea) {
		this.siteArea = siteArea;
	}

	public Contract getContract() {
		return this.contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}

	public Integer getMonthRentFee() {
		return this.monthRentFee;
	}

	public void setMonthRentFee(Integer monthRentFee) {
		this.monthRentFee = monthRentFee;
	}

	public Double getLeaseCount() {
		return this.leaseCount;
	}

	public void setLeaseCount(Double leaseCount) {
		this.leaseCount = leaseCount;
	}

	public Integer getMonthTotalFee() {
		return this.monthTotalFee;
	}

	public void setMonthTotalFee(Integer monthTotalFee) {
		this.monthTotalFee = monthTotalFee;
	}

	public String getAreaNo() {
		return this.areaNo;
	}

	public void setAreaNo(String areaNo) {
		this.areaNo = areaNo;
	}

	public Integer getCarCount() {
		return this.carCount;
	}

	public void setCarCount(Integer carCount) {
		this.carCount = carCount;
	}

	public Timestamp getStartDate() {
		return this.startDate;
	}

	public void setStartDate(Timestamp startDate) {
		this.startDate = startDate;
	}

	public Timestamp getEndDate() {
		return this.endDate;
	}

	public void setEndDate(Timestamp endDate) {
		this.endDate = endDate;
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

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Set getAgencyDetailBillses() {
		return this.agencyDetailBillses;
	}

	public void setAgencyDetailBillses(Set agencyDetailBillses) {
		this.agencyDetailBillses = agencyDetailBillses;
	}

}