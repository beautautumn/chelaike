package com.ct.erp.lib.entity;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * AuctionMain entity. @author MyEclipse Persistence Tools
 */

public class AuctionMain implements java.io.Serializable {

	// Fields

	private Long id;
	private String auctionNo;
	private Integer increaseRange;
	private String auctionTitle;
	private String content;
	private String auctionAddr;
	private Long outerId;
	private String auctionSource;
	private Date auctionDate;
	private Integer startPrice;
	private Integer basePrice;
	private Integer dealPrice;
	private Integer state;
	private Timestamp endTime;
	private Set auctionSlaves = new HashSet(0);
	private Set auctionResults = new HashSet(0);

	// Constructors

	/** default constructor */
	public AuctionMain() {
	}

	/** full constructor */
	public AuctionMain(String auctionNo, Integer increaseRange,
			String auctionTitle, String content, String auctionAddr,
			Long outerId, String auctionSource, Date auctionDate,
			Integer startPrice, Integer basePrice, Integer dealPrice,
			Integer state, Timestamp endTime, Set auctionSlaves,
			Set auctionResults) {
		this.auctionNo = auctionNo;
		this.increaseRange = increaseRange;
		this.auctionTitle = auctionTitle;
		this.content = content;
		this.auctionAddr = auctionAddr;
		this.outerId = outerId;
		this.auctionSource = auctionSource;
		this.auctionDate = auctionDate;
		this.startPrice = startPrice;
		this.basePrice = basePrice;
		this.dealPrice = dealPrice;
		this.state = state;
		this.endTime = endTime;
		this.auctionSlaves = auctionSlaves;
		this.auctionResults = auctionResults;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getAuctionNo() {
		return this.auctionNo;
	}

	public void setAuctionNo(String auctionNo) {
		this.auctionNo = auctionNo;
	}

	public Integer getIncreaseRange() {
		return this.increaseRange;
	}

	public void setIncreaseRange(Integer increaseRange) {
		this.increaseRange = increaseRange;
	}

	public String getAuctionTitle() {
		return this.auctionTitle;
	}

	public void setAuctionTitle(String auctionTitle) {
		this.auctionTitle = auctionTitle;
	}

	public String getContent() {
		return this.content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getAuctionAddr() {
		return this.auctionAddr;
	}

	public void setAuctionAddr(String auctionAddr) {
		this.auctionAddr = auctionAddr;
	}

	public Long getOuterId() {
		return this.outerId;
	}

	public void setOuterId(Long outerId) {
		this.outerId = outerId;
	}

	public String getAuctionSource() {
		return this.auctionSource;
	}

	public void setAuctionSource(String auctionSource) {
		this.auctionSource = auctionSource;
	}

	public Date getAuctionDate() {
		return this.auctionDate;
	}

	public void setAuctionDate(Date auctionDate) {
		this.auctionDate = auctionDate;
	}

	public Integer getStartPrice() {
		return this.startPrice;
	}

	public void setStartPrice(Integer startPrice) {
		this.startPrice = startPrice;
	}

	public Integer getBasePrice() {
		return this.basePrice;
	}

	public void setBasePrice(Integer basePrice) {
		this.basePrice = basePrice;
	}

	public Integer getDealPrice() {
		return this.dealPrice;
	}

	public void setDealPrice(Integer dealPrice) {
		this.dealPrice = dealPrice;
	}

	public Integer getState() {
		return this.state;
	}

	public void setState(Integer state) {
		this.state = state;
	}

	public Timestamp getEndTime() {
		return this.endTime;
	}

	public void setEndTime(Timestamp endTime) {
		this.endTime = endTime;
	}

	public Set getAuctionSlaves() {
		return this.auctionSlaves;
	}

	public void setAuctionSlaves(Set auctionSlaves) {
		this.auctionSlaves = auctionSlaves;
	}

	public Set getAuctionResults() {
		return this.auctionResults;
	}

	public void setAuctionResults(Set auctionResults) {
		this.auctionResults = auctionResults;
	}

}