package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * Financing entity. @author MyEclipse Persistence Tools
 */

public class Financing implements java.io.Serializable {

	// Fields

	private Long id;
	private Staff staffByPrepareStaff;
	private Staff staffByValuationStaff;
	private String acquType;
	private Integer valuationFee;
	private Timestamp valuationDate;
	private String valuationDesc;
	private Integer financingMax;
	private Integer financingFee;
	private Double loanRate;
	private Integer prepareFee;
	private Timestamp prepareDate;
	private String prepareDesc;
	private Integer payedOwnerFee;
	private Integer remainingFee;
	private String payOverTag;
	private Integer recvSaleFee;
	private String recvOverTag;
	private Integer payAgencyTotalFee;
	private Integer payedAgencyFee;
	private Integer usedDays;
	private String payAgencyOverTag;
	private Integer repayBaseFee;
	private Integer repayInterest;
	private Integer transferFee;
	private Integer disposalPrice;
	private Integer recvDisposalFee;
	private String recvDisposalOverTag;
	private Integer refundFee;
	private Integer refundedFee;
	private Integer recvInterest;
	private String refundOverTag;
	private Timestamp firstPayDate;
	private Timestamp firstGatheringDate;
	private Timestamp createTime;
	private Timestamp updateTime;
//	private Set payAgencyHises = new HashSet(0);
	private Set trades = new HashSet(0);
	private Set recvDisposalHises = new HashSet(0);
//	private Set recvCustHises = new HashSet(0);
	private Set refundAgencyHises = new HashSet(0);
//	private Set payOwnerHises = new HashSet(0);

	// Constructors

	/** default constructor */
	public Financing() {
	}

	/** full constructor */
	public Financing(Staff staffByPrepareStaff, Staff staffByValuationStaff,
                     String acquType, Integer valuationFee, Timestamp valuationDate,
                     String valuationDesc, Integer financingMax, Integer financingFee,
                     Double loanRate, Integer prepareFee, Timestamp prepareDate,
                     String prepareDesc, Integer payedOwnerFee, Integer remainingFee,
                     String payOverTag, Integer recvSaleFee, String recvOverTag,
                     Integer payAgencyTotalFee, Integer payedAgencyFee,
                     Integer usedDays, String payAgencyOverTag, Integer repayBaseFee,
                     Integer repayInterest, Integer transferFee, Integer disposalPrice,
                     Integer recvDisposalFee, String recvDisposalOverTag,
                     Integer refundFee, Integer refundedFee, Integer recvInterest,
                     String refundOverTag, Timestamp firstPayDate,
                     Timestamp firstGatheringDate, Timestamp createTime,
                     Timestamp updateTime, Set payAgencyHises, Set trades,
                     Set recvDisposalHises, Set recvCustHises, Set refundAgencyHises,
                     Set payOwnerHises) {
		this.staffByPrepareStaff = staffByPrepareStaff;
		this.staffByValuationStaff = staffByValuationStaff;
		this.acquType = acquType;
		this.valuationFee = valuationFee;
		this.valuationDate = valuationDate;
		this.valuationDesc = valuationDesc;
		this.financingMax = financingMax;
		this.financingFee = financingFee;
		this.loanRate = loanRate;
		this.prepareFee = prepareFee;
		this.prepareDate = prepareDate;
		this.prepareDesc = prepareDesc;
		this.payedOwnerFee = payedOwnerFee;
		this.remainingFee = remainingFee;
		this.payOverTag = payOverTag;
		this.recvSaleFee = recvSaleFee;
		this.recvOverTag = recvOverTag;
		this.payAgencyTotalFee = payAgencyTotalFee;
		this.payedAgencyFee = payedAgencyFee;
		this.usedDays = usedDays;
		this.payAgencyOverTag = payAgencyOverTag;
		this.repayBaseFee = repayBaseFee;
		this.repayInterest = repayInterest;
		this.transferFee = transferFee;
		this.disposalPrice = disposalPrice;
		this.recvDisposalFee = recvDisposalFee;
		this.recvDisposalOverTag = recvDisposalOverTag;
		this.refundFee = refundFee;
		this.refundedFee = refundedFee;
		this.recvInterest = recvInterest;
		this.refundOverTag = refundOverTag;
		this.firstPayDate = firstPayDate;
		this.firstGatheringDate = firstGatheringDate;
		this.createTime = createTime;
		this.updateTime = updateTime;
//		this.payAgencyHises = payAgencyHises;
		this.trades = trades;
		this.recvDisposalHises = recvDisposalHises;
//		this.recvCustHises = recvCustHises;
		this.refundAgencyHises = refundAgencyHises;
//		this.payOwnerHises = payOwnerHises;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Staff getStaffByPrepareStaff() {
		return this.staffByPrepareStaff;
	}

	public void setStaffByPrepareStaff(Staff staffByPrepareStaff) {
		this.staffByPrepareStaff = staffByPrepareStaff;
	}

	public Staff getStaffByValuationStaff() {
		return this.staffByValuationStaff;
	}

	public void setStaffByValuationStaff(Staff staffByValuationStaff) {
		this.staffByValuationStaff = staffByValuationStaff;
	}

	public String getAcquType() {
		return this.acquType;
	}

	public void setAcquType(String acquType) {
		this.acquType = acquType;
	}

	public Integer getValuationFee() {
		return this.valuationFee;
	}

	public void setValuationFee(Integer valuationFee) {
		this.valuationFee = valuationFee;
	}

	public Timestamp getValuationDate() {
		return this.valuationDate;
	}

	public void setValuationDate(Timestamp valuationDate) {
		this.valuationDate = valuationDate;
	}

	public String getValuationDesc() {
		return this.valuationDesc;
	}

	public void setValuationDesc(String valuationDesc) {
		this.valuationDesc = valuationDesc;
	}

	public Integer getFinancingMax() {
		return this.financingMax;
	}

	public void setFinancingMax(Integer financingMax) {
		this.financingMax = financingMax;
	}

	public Integer getFinancingFee() {
		return this.financingFee;
	}

	public void setFinancingFee(Integer financingFee) {
		this.financingFee = financingFee;
	}

	public Double getLoanRate() {
		return this.loanRate;
	}

	public void setLoanRate(Double loanRate) {
		this.loanRate = loanRate;
	}

	public Integer getPrepareFee() {
		return this.prepareFee;
	}

	public void setPrepareFee(Integer prepareFee) {
		this.prepareFee = prepareFee;
	}

	public Timestamp getPrepareDate() {
		return this.prepareDate;
	}

	public void setPrepareDate(Timestamp prepareDate) {
		this.prepareDate = prepareDate;
	}

	public String getPrepareDesc() {
		return this.prepareDesc;
	}

	public void setPrepareDesc(String prepareDesc) {
		this.prepareDesc = prepareDesc;
	}

	public Integer getPayedOwnerFee() {
		return this.payedOwnerFee;
	}

	public void setPayedOwnerFee(Integer payedOwnerFee) {
		this.payedOwnerFee = payedOwnerFee;
	}

	public Integer getRemainingFee() {
		return this.remainingFee;
	}

	public void setRemainingFee(Integer remainingFee) {
		this.remainingFee = remainingFee;
	}

	public String getPayOverTag() {
		return this.payOverTag;
	}

	public void setPayOverTag(String payOverTag) {
		this.payOverTag = payOverTag;
	}

	public Integer getRecvSaleFee() {
		return this.recvSaleFee;
	}

	public void setRecvSaleFee(Integer recvSaleFee) {
		this.recvSaleFee = recvSaleFee;
	}

	public String getRecvOverTag() {
		return this.recvOverTag;
	}

	public void setRecvOverTag(String recvOverTag) {
		this.recvOverTag = recvOverTag;
	}

	public Integer getPayAgencyTotalFee() {
		return this.payAgencyTotalFee;
	}

	public void setPayAgencyTotalFee(Integer payAgencyTotalFee) {
		this.payAgencyTotalFee = payAgencyTotalFee;
	}

	public Integer getPayedAgencyFee() {
		return this.payedAgencyFee;
	}

	public void setPayedAgencyFee(Integer payedAgencyFee) {
		this.payedAgencyFee = payedAgencyFee;
	}

	public Integer getUsedDays() {
		return this.usedDays;
	}

	public void setUsedDays(Integer usedDays) {
		this.usedDays = usedDays;
	}

	public String getPayAgencyOverTag() {
		return this.payAgencyOverTag;
	}

	public void setPayAgencyOverTag(String payAgencyOverTag) {
		this.payAgencyOverTag = payAgencyOverTag;
	}

	public Integer getRepayBaseFee() {
		return this.repayBaseFee;
	}

	public void setRepayBaseFee(Integer repayBaseFee) {
		this.repayBaseFee = repayBaseFee;
	}

	public Integer getRepayInterest() {
		return this.repayInterest;
	}

	public void setRepayInterest(Integer repayInterest) {
		this.repayInterest = repayInterest;
	}

	public Integer getTransferFee() {
		return this.transferFee;
	}

	public void setTransferFee(Integer transferFee) {
		this.transferFee = transferFee;
	}

	public Integer getDisposalPrice() {
		return this.disposalPrice;
	}

	public void setDisposalPrice(Integer disposalPrice) {
		this.disposalPrice = disposalPrice;
	}

	public Integer getRecvDisposalFee() {
		return this.recvDisposalFee;
	}

	public void setRecvDisposalFee(Integer recvDisposalFee) {
		this.recvDisposalFee = recvDisposalFee;
	}

	public String getRecvDisposalOverTag() {
		return this.recvDisposalOverTag;
	}

	public void setRecvDisposalOverTag(String recvDisposalOverTag) {
		this.recvDisposalOverTag = recvDisposalOverTag;
	}

	public Integer getRefundFee() {
		return this.refundFee;
	}

	public void setRefundFee(Integer refundFee) {
		this.refundFee = refundFee;
	}

	public Integer getRefundedFee() {
		return this.refundedFee;
	}

	public void setRefundedFee(Integer refundedFee) {
		this.refundedFee = refundedFee;
	}

	public Integer getRecvInterest() {
		return this.recvInterest;
	}

	public void setRecvInterest(Integer recvInterest) {
		this.recvInterest = recvInterest;
	}

	public String getRefundOverTag() {
		return this.refundOverTag;
	}

	public void setRefundOverTag(String refundOverTag) {
		this.refundOverTag = refundOverTag;
	}

	public Timestamp getFirstPayDate() {
		return this.firstPayDate;
	}

	public void setFirstPayDate(Timestamp firstPayDate) {
		this.firstPayDate = firstPayDate;
	}

	public Timestamp getFirstGatheringDate() {
		return this.firstGatheringDate;
	}

	public void setFirstGatheringDate(Timestamp firstGatheringDate) {
		this.firstGatheringDate = firstGatheringDate;
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

//	public Set getPayAgencyHises() {
//		return this.payAgencyHises;
//	}

//	public void setPayAgencyHises(Set payAgencyHises) {
//		this.payAgencyHises = payAgencyHises;
//	}

	public Set getTrades() {
		return this.trades;
	}

	public void setTrades(Set trades) {
		this.trades = trades;
	}

	public Set getRecvDisposalHises() {
		return this.recvDisposalHises;
	}

	public void setRecvDisposalHises(Set recvDisposalHises) {
		this.recvDisposalHises = recvDisposalHises;
	}

//	public Set getRecvCustHises() {
//		return this.recvCustHises;
//	}

//	public void setRecvCustHises(Set recvCustHises) {
//		this.recvCustHises = recvCustHises;
//	}

	public Set getRefundAgencyHises() {
		return this.refundAgencyHises;
	}

	public void setRefundAgencyHises(Set refundAgencyHises) {
		this.refundAgencyHises = refundAgencyHises;
	}

//	public Set getPayOwnerHises() {
//		return this.payOwnerHises;
//	}

//	public void setPayOwnerHises(Set payOwnerHises) {
//		this.payOwnerHises = payOwnerHises;
//	}

}