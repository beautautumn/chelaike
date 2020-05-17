package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.AuctionMain;
import com.ct.erp.lib.entity.AuctionSlave;

import java.sql.Timestamp;

/**
 * AuctionResult entity. @author MyEclipse Persistence Tools
 */

public class AuctionResult implements java.io.Serializable {

	// Fields

	private Long id;
	private AuctionSlave auctionSlave;
	private AuctionMain auctionMain;
	private Timestamp createTime;
	private Timestamp updateTime;

	// Constructors

	/** default constructor */
	public AuctionResult() {
	}

	/** full constructor */
	public AuctionResult(AuctionSlave auctionSlave, AuctionMain auctionMain,
                         Timestamp createTime, Timestamp updateTime) {
		this.auctionSlave = auctionSlave;
		this.auctionMain = auctionMain;
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

	public AuctionSlave getAuctionSlave() {
		return this.auctionSlave;
	}

	public void setAuctionSlave(AuctionSlave auctionSlave) {
		this.auctionSlave = auctionSlave;
	}

	public AuctionMain getAuctionMain() {
		return this.auctionMain;
	}

	public void setAuctionMain(AuctionMain auctionMain) {
		this.auctionMain = auctionMain;
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