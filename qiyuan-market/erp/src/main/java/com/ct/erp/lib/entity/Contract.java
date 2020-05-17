package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.ClearingReason;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * Contract entity. @author MyEclipse Persistence Tools
 */

public class Contract implements java.io.Serializable {

	// Fields

	private Long id;
	private ClearingReason clearingReason;
	private Staff staffByClearingStaff;
	private Staff staffByClearingStartStaff;
	private Agency agency;
	private Staff staffByCreateStaff;
	private Timestamp startDate;
	private Timestamp endDate;
	private String recvCycle;
	private Integer everyRecvFee;
	private Integer depositFee;
	private Integer payedDepositFee;
	private Timestamp signDate;
	private String marketSignName;
	private String agencySignName;
	private String remark;
	private Timestamp createTime;
	private Timestamp updateTime;
	private String status;
	private String state;
	private String defaultDesc;
	private String backDesc;
	private Timestamp backTime;
	private Timestamp clearingStartDate;
	private Timestamp clearingEndDate;
	private String clearingDesc;
	private Integer otherRecvFee;
	private String otherFeeDesc;
	private String endReason;
	private Integer backDepositFee;
	private String clearedDesc;
	private String workingTag;
	private Set cycleRecvFeeRecords = new HashSet(0);
	private Set contractAreas = new HashSet(0);
	private Set recvFees = new HashSet(0);
	private Set cycleRecvFees = new HashSet(0);

	// Constructors

	/** default constructor */
	public Contract() {
	}

	/** full constructor */
	public Contract(ClearingReason clearingReason, Staff staffByClearingStaff,
                    Staff staffByClearingStartStaff, Agency agency,
                    Staff staffByCreateStaff, Timestamp startDate, Timestamp endDate,
                    String recvCycle, Integer everyRecvFee, Integer depositFee,
                    Integer payedDepositFee, Timestamp signDate, String marketSignName,
                    String agencySignName, String remark, Timestamp createTime,
                    Timestamp updateTime, String status, String state,
                    String defaultDesc, String backDesc, Timestamp backTime,
                    Timestamp clearingStartDate, Timestamp clearingEndDate,
                    String clearingDesc, Integer otherRecvFee, String otherFeeDesc,
                    String endReason, Integer backDepositFee, String clearedDesc,
                    String workingTag, Set cycleRecvFeeRecords, Set contractAreas,
                    Set recvFees, Set cycleRecvFees) {
		this.clearingReason = clearingReason;
		this.staffByClearingStaff = staffByClearingStaff;
		this.staffByClearingStartStaff = staffByClearingStartStaff;
		this.agency = agency;
		this.staffByCreateStaff = staffByCreateStaff;
		this.startDate = startDate;
		this.endDate = endDate;
		this.recvCycle = recvCycle;
		this.everyRecvFee = everyRecvFee;
		this.depositFee = depositFee;
		this.payedDepositFee = payedDepositFee;
		this.signDate = signDate;
		this.marketSignName = marketSignName;
		this.agencySignName = agencySignName;
		this.remark = remark;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.status = status;
		this.state = state;
		this.defaultDesc = defaultDesc;
		this.backDesc = backDesc;
		this.backTime = backTime;
		this.clearingStartDate = clearingStartDate;
		this.clearingEndDate = clearingEndDate;
		this.clearingDesc = clearingDesc;
		this.otherRecvFee = otherRecvFee;
		this.otherFeeDesc = otherFeeDesc;
		this.endReason = endReason;
		this.backDepositFee = backDepositFee;
		this.clearedDesc = clearedDesc;
		this.workingTag = workingTag;
		this.cycleRecvFeeRecords = cycleRecvFeeRecords;
		this.contractAreas = contractAreas;
		this.recvFees = recvFees;
		this.cycleRecvFees = cycleRecvFees;
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

	public Integer getPayedDepositFee() {
		return this.payedDepositFee;
	}

	public void setPayedDepositFee(Integer payedDepositFee) {
		this.payedDepositFee = payedDepositFee;
	}

	public Timestamp getSignDate() {
		return this.signDate;
	}

	public void setSignDate(Timestamp signDate) {
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

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getDefaultDesc() {
		return this.defaultDesc;
	}

	public void setDefaultDesc(String defaultDesc) {
		this.defaultDesc = defaultDesc;
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

	public Integer getOtherRecvFee() {
		return this.otherRecvFee;
	}

	public void setOtherRecvFee(Integer otherRecvFee) {
		this.otherRecvFee = otherRecvFee;
	}

	public String getOtherFeeDesc() {
		return this.otherFeeDesc;
	}

	public void setOtherFeeDesc(String otherFeeDesc) {
		this.otherFeeDesc = otherFeeDesc;
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

	public String getWorkingTag() {
		return this.workingTag;
	}

	public void setWorkingTag(String workingTag) {
		this.workingTag = workingTag;
	}

	public Set getCycleRecvFeeRecords() {
		return this.cycleRecvFeeRecords;
	}

	public void setCycleRecvFeeRecords(Set cycleRecvFeeRecords) {
		this.cycleRecvFeeRecords = cycleRecvFeeRecords;
	}

	public Set getContractAreas() {
		return this.contractAreas;
	}

	public void setContractAreas(Set contractAreas) {
		this.contractAreas = contractAreas;
	}

	public Set getRecvFees() {
		return this.recvFees;
	}

	public void setRecvFees(Set recvFees) {
		this.recvFees = recvFees;
	}

	public Set getCycleRecvFees() {
		return this.cycleRecvFees;
	}

	public void setCycleRecvFees(Set cycleRecvFees) {
		this.cycleRecvFees = cycleRecvFees;
	}

}