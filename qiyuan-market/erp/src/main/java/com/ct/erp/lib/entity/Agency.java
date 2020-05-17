package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.AgencyOrder;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * Agency entity. @author MyEclipse Persistence Tools
 */

public class Agency implements java.io.Serializable {

	// Fields

	private Long id;
	private Staff staff;
	private AgencyOrder agencyOrder;
	private Long outerId;
	private Long clkId;
	private String clkToken;
	private String bidPriceTag;
	private String agencyName;
	private String userName;
	private String userPhone;
	private Long outerUserId;
	private String account;
	private String pwd;
	private String remark;
	private String status;
	private Timestamp createTime;
	private Timestamp updateTime;
	private String state;
	private Timestamp leaveDate;
	private String leaveDesc;
	private String leaveType;
	private String userIdCard;
	private String legalPersonName;
	private String legalPersonPhone;
	private String breachDesc;
	private Market market;
	private Set carOperHises = new HashSet(0);
//	private Set publishInfos = new HashSet(0);
	private Set carports = new HashSet(0);
//	private Set auctionSlaves = new HashSet(0);
	private Set trades = new HashSet(0);
//	private Set commentses = new HashSet(0);
	private Set agents = new HashSet(0);
	private Set shopContracts = new HashSet(0);
	private Set contracts = new HashSet(0);
//	private Set agencySyncs = new HashSet(0);
	private Set agencyBillses = new HashSet(0);
	private Set agencyDetailBillses = new HashSet(0);

	// Constructors

	/** default constructor */
	public Agency() {
	}

	/** minimal constructor */
	public Agency(String agencyName, String userName, String userPhone,
			String status, Timestamp createTime, String state) {
		this.agencyName = agencyName;
		this.userName = userName;
		this.userPhone = userPhone;
		this.status = status;
		this.createTime = createTime;
		this.state = state;
	}

	/** full constructor */
	public Agency(Staff staff, AgencyOrder agencyOrder, Long outerId,
                  Long clkId, String clkToken, String bidPriceTag, String agencyName,
                  String userName, String userPhone, Long outerUserId,
                  String account, String pwd, String remark, String status,
                  Timestamp createTime, Timestamp updateTime, String state,
                  Timestamp leaveDate, String leaveDesc, String leaveType,
                  String breachDesc, Set carOperHises, Set publishInfos,
                  Set carports, Set auctionSlaves, Set trades, Set commentses,
                  Set agents, Set shopContracts, Set contracts, Set agencySyncs,
                  Set agencyBillses, Set agencyDetailBillses) {
		this.staff = staff;
		this.agencyOrder = agencyOrder;
		this.outerId = outerId;
		this.clkId = clkId;
		this.clkToken = clkToken;
		this.bidPriceTag = bidPriceTag;
		this.agencyName = agencyName;
		this.userName = userName;
		this.userPhone = userPhone;
		this.outerUserId = outerUserId;
		this.account = account;
		this.pwd = pwd;
		this.remark = remark;
		this.status = status;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.state = state;
		this.leaveDate = leaveDate;
		this.leaveDesc = leaveDesc;
		this.leaveType = leaveType;
		this.breachDesc = breachDesc;
		this.carOperHises = carOperHises;
//		this.publishInfos = publishInfos;
		this.carports = carports;
//		this.auctionSlaves = auctionSlaves;
		this.trades = trades;
//		this.commentses = commentses;
		this.agents = agents;
		this.shopContracts = shopContracts;
		this.contracts = contracts;
//		this.agencySyncs = agencySyncs;
		this.agencyBillses = agencyBillses;
		this.agencyDetailBillses = agencyDetailBillses;
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

	public AgencyOrder getAgencyOrder() {
		return this.agencyOrder;
	}

	public void setAgencyOrder(AgencyOrder agencyOrder) {
		this.agencyOrder = agencyOrder;
	}

	public Long getOuterId() {
		return this.outerId;
	}

	public void setOuterId(Long outerId) {
		this.outerId = outerId;
	}

	public Long getClkId() {
		return this.clkId;
	}

	public void setClkId(Long clkId) {
		this.clkId = clkId;
	}

	public String getClkToken() {
		return this.clkToken;
	}

	public void setClkToken(String clkToken) {
		this.clkToken = clkToken;
	}

	public String getBidPriceTag() {
		return this.bidPriceTag;
	}

	public void setBidPriceTag(String bidPriceTag) {
		this.bidPriceTag = bidPriceTag;
	}

	public String getAgencyName() {
		return this.agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPhone() {
		return this.userPhone;
	}

	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}

	public Long getOuterUserId() {
		return this.outerUserId;
	}

	public void setOuterUserId(Long outerUserId) {
		this.outerUserId = outerUserId;
	}

	public String getAccount() {
		return this.account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public String getPwd() {
		return this.pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Timestamp getLeaveDate() {
		return this.leaveDate;
	}

	public void setLeaveDate(Timestamp leaveDate) {
		this.leaveDate = leaveDate;
	}

	public String getLeaveDesc() {
		return this.leaveDesc;
	}

	public void setLeaveDesc(String leaveDesc) {
		this.leaveDesc = leaveDesc;
	}

	public String getLeaveType() {
		return this.leaveType;
	}

	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}

	public String getBreachDesc() {
		return this.breachDesc;
	}

	public void setBreachDesc(String breachDesc) {
		this.breachDesc = breachDesc;
	}

	public Set getCarOperHises() {
		return this.carOperHises;
	}

	public String getUserIdCard() {
		return userIdCard;
	}

	public void setUserIdCard(String userIdCard) {
		this.userIdCard = userIdCard;
	}

	public String getLegalPersonName() {
		return legalPersonName;
	}

	public void setLegalPersonName(String legalPersonName) {
		this.legalPersonName = legalPersonName;
	}

	public String getLegalPersonPhone() {
		return legalPersonPhone;
	}

	public void setLegalPersonPhone(String legalPersonPhone) {
		this.legalPersonPhone = legalPersonPhone;
	}

	public void setCarOperHises(Set carOperHises) {
		this.carOperHises = carOperHises;
	}

//	public Set getPublishInfos() {
//		return this.publishInfos;
//	}

//	public void setPublishInfos(Set publishInfos) {
//		this.publishInfos = publishInfos;
//	}

	public Set getCarports() {
		return this.carports;
	}

	public void setCarports(Set carports) {
		this.carports = carports;
	}

//	public Set getAuctionSlaves() {
//		return this.auctionSlaves;
//	}

//	public void setAuctionSlaves(Set auctionSlaves) {
//		this.auctionSlaves = auctionSlaves;
//	}

	public Set getTrades() {
		return this.trades;
	}

	public void setTrades(Set trades) {
		this.trades = trades;
	}

//	public Set getCommentses() {
//		return this.commentses;
//	}

//	public void setCommentses(Set commentses) {
//		this.commentses = commentses;
//	}

	public Set getAgents() {
		return this.agents;
	}

	public void setAgents(Set agents) {
		this.agents = agents;
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

//	public Set getAgencySyncs() {
//		return this.agencySyncs;
//	}

//	public void setAgencySyncs(Set agencySyncs) {
//		this.agencySyncs = agencySyncs;
//	}

	public Set getAgencyBillses() {
		return this.agencyBillses;
	}

	public void setAgencyBillses(Set agencyBillses) {
		this.agencyBillses = agencyBillses;
	}

	public Set getAgencyDetailBillses() {
		return this.agencyDetailBillses;
	}

	public void setAgencyDetailBillses(Set agencyDetailBillses) {
		this.agencyDetailBillses = agencyDetailBillses;
	}

	public Market getMarket() {
		return market;
	}

	public void setMarket(Market market) {
		this.market = market;
	}
}