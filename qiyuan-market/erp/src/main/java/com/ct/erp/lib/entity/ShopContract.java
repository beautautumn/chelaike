package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.ClearingReason;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * ShopContract entity. @author MyEclipse Persistence Tools
 */

public class ShopContract implements java.io.Serializable {

	// Fields

	private Long id;
	private ClearingReason clearingReason;
	private Staff staffByClearingStaff;
	private Staff staffByClearingStartStaff;
	private Agency agency;
	private Staff staffByCreateStaff;
	private String contractNum;
	private Date startDate;
	private Date endDate;
	private String recvCycle;
	private Integer everyRecvFee;
	private Integer depositFee;
	private Date signDate;
	private String marketSignName;
	private String agencySignName;
	private String remark;
	private Timestamp createTime;
	private Timestamp updateTime;
	private String state;
	private String backDesc;
	private Timestamp backTime;
	private Timestamp clearingStartDate;
	private Timestamp clearingEndDate;
	private String clearingDesc;
	private String endReason;
	private Integer backDepositFee;
	private String clearedDesc;
	private Set contractCollectionPlans = new HashSet(0);
	private Set contractCollectionRecords = new HashSet(0);
	private Set contractShops = new HashSet(0);

	// Constructors

	/** default constructor */
	public ShopContract() {
	}

	/** full constructor */
	public ShopContract(ClearingReason clearingReason,
                        Staff staffByClearingStaff, Staff staffByClearingStartStaff,
                        Agency agency, Staff staffByCreateStaff, String contractNum,
                        Date startDate, Date endDate, String recvCycle,
                        Integer everyRecvFee, Integer depositFee, Date signDate,
                        String marketSignName, String agencySignName, String remark,
                        Timestamp createTime, Timestamp updateTime, String state,
                        String backDesc, Timestamp backTime, Timestamp clearingStartDate,
                        Timestamp clearingEndDate, String clearingDesc, String endReason,
                        Integer backDepositFee, String clearedDesc,
                        Set contractCollectionPlans, Set contractCollectionRecords,
                        Set contractShops) {
		this.clearingReason = clearingReason;
		this.staffByClearingStaff = staffByClearingStaff;
		this.staffByClearingStartStaff = staffByClearingStartStaff;
		this.agency = agency;
		this.staffByCreateStaff = staffByCreateStaff;
		this.contractNum = contractNum;
		this.startDate = startDate;
		this.endDate = endDate;
		this.recvCycle = recvCycle;
		this.everyRecvFee = everyRecvFee;
		this.depositFee = depositFee;
		this.signDate = signDate;
		this.marketSignName = marketSignName;
		this.agencySignName = agencySignName;
		this.remark = remark;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.state = state;
		this.backDesc = backDesc;
		this.backTime = backTime;
		this.clearingStartDate = clearingStartDate;
		this.clearingEndDate = clearingEndDate;
		this.clearingDesc = clearingDesc;
		this.endReason = endReason;
		this.backDepositFee = backDepositFee;
		this.clearedDesc = clearedDesc;
		this.contractCollectionPlans = contractCollectionPlans;
		this.contractCollectionRecords = contractCollectionRecords;
		this.contractShops = contractShops;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ClearingReason getClearingReason() {
		return this.clearingReason;
	}

	public void setClearingReason(ClearingReason clearingReason) {
		this.clearingReason = clearingReason;
	}

	public Staff getStaffByClearingStaff() {
		return this.staffByClearingStaff;
	}

	public void setStaffByClearingStaff(Staff staffByClearingStaff) {
		this.staffByClearingStaff = staffByClearingStaff;
	}

	public Staff getStaffByClearingStartStaff() {
		return this.staffByClearingStartStaff;
	}

	public void setStaffByClearingStartStaff(Staff staffByClearingStartStaff) {
		this.staffByClearingStartStaff = staffByClearingStartStaff;
	}

	public Agency getAgency() {
		return this.agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public Staff getStaffByCreateStaff() {
		return this.staffByCreateStaff;
	}

	public void setStaffByCreateStaff(Staff staffByCreateStaff) {
		this.staffByCreateStaff = staffByCreateStaff;
	}

	public String getContractNum() {
		return this.contractNum;
	}

	public void setContractNum(String contractNum) {
		this.contractNum = contractNum;
	}

	public Date getStartDate() {
		return this.startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return this.endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public String getRecvCycle() {
		return this.recvCycle;
	}

	public void setRecvCycle(String recvCycle) {
		this.recvCycle = recvCycle;
	}

	public Integer getEveryRecvFee() {
		return this.everyRecvFee;
	}

	public void setEveryRecvFee(Integer everyRecvFee) {
		this.everyRecvFee = everyRecvFee;
	}

	public Integer getDepositFee() {
		return this.depositFee;
	}

	public void setDepositFee(Integer depositFee) {
		this.depositFee = depositFee;
	}

	public Date getSignDate() {
		return this.signDate;
	}

	public void setSignDate(Date signDate) {
		this.signDate = signDate;
	}

	public String getMarketSignName() {
		return this.marketSignName;
	}

	public void setMarketSignName(String marketSignName) {
		this.marketSignName = marketSignName;
	}

	public String getAgencySignName() {
		return this.agencySignName;
	}

	public void setAgencySignName(String agencySignName) {
		this.agencySignName = agencySignName;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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

	public String getBackDesc() {
		return this.backDesc;
	}

	public void setBackDesc(String backDesc) {
		this.backDesc = backDesc;
	}

	public Timestamp getBackTime() {
		return this.backTime;
	}

	public void setBackTime(Timestamp backTime) {
		this.backTime = backTime;
	}

	public Timestamp getClearingStartDate() {
		return this.clearingStartDate;
	}

	public void setClearingStartDate(Timestamp clearingStartDate) {
		this.clearingStartDate = clearingStartDate;
	}

	public Timestamp getClearingEndDate() {
		return this.clearingEndDate;
	}

	public void setClearingEndDate(Timestamp clearingEndDate) {
		this.clearingEndDate = clearingEndDate;
	}

	public String getClearingDesc() {
		return this.clearingDesc;
	}

	public void setClearingDesc(String clearingDesc) {
		this.clearingDesc = clearingDesc;
	}

	public String getEndReason() {
		return this.endReason;
	}

	public void setEndReason(String endReason) {
		this.endReason = endReason;
	}

	public Integer getBackDepositFee() {
		return this.backDepositFee;
	}

	public void setBackDepositFee(Integer backDepositFee) {
		this.backDepositFee = backDepositFee;
	}

	public String getClearedDesc() {
		return this.clearedDesc;
	}

	public void setClearedDesc(String clearedDesc) {
		this.clearedDesc = clearedDesc;
	}

	public Set getContractCollectionPlans() {
		return this.contractCollectionPlans;
	}

	public void setContractCollectionPlans(Set contractCollectionPlans) {
		this.contractCollectionPlans = contractCollectionPlans;
	}

	public Set getContractCollectionRecords() {
		return this.contractCollectionRecords;
	}

	public void setContractCollectionRecords(Set contractCollectionRecords) {
		this.contractCollectionRecords = contractCollectionRecords;
	}

	public Set getContractShops() {
		return this.contractShops;
	}

	public void setContractShops(Set contractShops) {
		this.contractShops = contractShops;
	}

}