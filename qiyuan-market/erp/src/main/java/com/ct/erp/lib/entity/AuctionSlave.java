package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.AuctionMain;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * AuctionSlave entity. @author MyEclipse Persistence Tools
 */

public class AuctionSlave implements java.io.Serializable {

	// Fields

	private Long id;
	private AuctionMain auctionMain;
	private Agency agency;
	private Integer bidPrice;
	private Timestamp createTime;
	private Timestamp updateTime;
	private Set auctionResults = new HashSet(0);

	// Constructors

	/** default constructor */
	public AuctionSlave() {
	}

	/** full constructor */
	public AuctionSlave(AuctionMain auctionMain, Agency agency,
                        Integer bidPrice, Timestamp createTime, Timestamp updateTime,
                        Set auctionResults) {
		this.auctionMain = auctionMain;
		this.agency = agency;
		this.bidPrice = bidPrice;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.auctionResults = auctionResults;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public AuctionMain getAuctionMain() {
		return this.auctionMain;
	}

	public void setAuctionMain(AuctionMain auctionMain) {
		this.auctionMain = auctionMain;
	}

	public Agency getAgency() {
		return this.agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public Integer getBidPrice() {
		return this.bidPrice;
	}

	public void setBidPrice(Integer bidPrice) {
		this.bidPrice = bidPrice;
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

	public Set getAuctionResults() {
		return this.auctionResults;
	}

	public void setAuctionResults(Set auctionResults) {
		this.auctionResults = auctionResults;
	}

}