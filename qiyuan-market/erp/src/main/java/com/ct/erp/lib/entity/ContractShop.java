package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.ShopContract;
import com.ct.erp.lib.entity.SiteShop;

import java.sql.Timestamp;

/**
 * ContractShop entity. @author MyEclipse Persistence Tools
 */

public class ContractShop implements java.io.Serializable {

	// Fields

	private Long id;
	private ShopContract shopContract;
	private SiteShop siteShop;
	private Integer monthRentFee;
	private Integer leaseCount;
	private Integer monthTotalFee;
	private String areaNo;
	private Timestamp createTime;
	private Timestamp updateTime;
	private String status;

	// Constructors

	/** default constructor */
	public ContractShop() {
	}

	/** minimal constructor */
	public ContractShop(ShopContract shopContract, SiteShop siteShop,
                        Integer monthRentFee, Integer leaseCount, Integer monthTotalFee,
                        String areaNo) {
		this.shopContract = shopContract;
		this.siteShop = siteShop;
		this.monthRentFee = monthRentFee;
		this.leaseCount = leaseCount;
		this.monthTotalFee = monthTotalFee;
		this.areaNo = areaNo;
	}

	/** full constructor */
	public ContractShop(ShopContract shopContract, SiteShop siteShop,
                        Integer monthRentFee, Integer leaseCount, Integer monthTotalFee,
                        String areaNo, Timestamp createTime, Timestamp updateTime,
                        String status) {
		this.shopContract = shopContract;
		this.siteShop = siteShop;
		this.monthRentFee = monthRentFee;
		this.leaseCount = leaseCount;
		this.monthTotalFee = monthTotalFee;
		this.areaNo = areaNo;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.status = status;
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

	public SiteShop getSiteShop() {
		return this.siteShop;
	}

	public void setSiteShop(SiteShop siteShop) {
		this.siteShop = siteShop;
	}

	public Integer getMonthRentFee() {
		return this.monthRentFee;
	}

	public void setMonthRentFee(Integer monthRentFee) {
		this.monthRentFee = monthRentFee;
	}

	public Integer getLeaseCount() {
		return this.leaseCount;
	}

	public void setLeaseCount(Integer leaseCount) {
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

}