package com.ct.erp.lib.entity;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * Staff entity. @author MyEclipse Persistence Tools
 */

public class Staff implements java.io.Serializable {

	// Fields

	private Long id;
	private String loginName;
	private String loginPwd;
	private String name;
	private Integer sex;
	private String tel;
	private String remark;
	private String status;
	private String idNo;
	private Timestamp createTime;
	private Timestamp updateTime;
	private Market market;
	private Agency agency;
	private String needSmsNotice;
	private Set pics = new HashSet(0);
	private Set financingsForPrepareStaff = new HashSet(0);
	private Set financingsForValuationStaff = new HashSet(0);
	private Set contractCollectionRecords = new HashSet(0);
//	private Set approves = new HashSet(0);
	private Set operHises = new HashSet(0);
//	private Set payOwnerHises = new HashSet(0);
	private Set agencies = new HashSet(0);
//	private Set recvCustHises = new HashSet(0);
	private Set shopContractsForCreateStaff = new HashSet(0);
	private Set shopContractsForClearingStaff = new HashSet(0);
	private Set agencyDetailBillses = new HashSet(0);
	private Set shopContractsForClearingStartStaff = new HashSet(0);
	private Set todoLogsForNotifyStaff = new HashSet(0);
	private Set todoLogsForWaitStaff = new HashSet(0);
	private Set contractsForCreateStaff = new HashSet(0);
	private Set todoLogsForCreateStaff = new HashSet(0);
	private Set cycleRecvFeeRecords = new HashSet(0);
	private Set contractsForClearingStaff = new HashSet(0);
	private Set contractsForClearingStartStaff = new HashSet(0);
	private Set managerFeesForOperStaff = new HashSet(0);
//	private Set payAgencyHises = new HashSet(0);
	private Set managerFeesForCreateStaff = new HashSet(0);
	private Set agencyBillses = new HashSet(0);
	private Set recvDisposalHises = new HashSet(0);
	private Set carOperHises = new HashSet(0);
	private Set staffRights = new HashSet(0);
	private Set recvFees = new HashSet(0);
	private Set refundAgencyHises = new HashSet(0);
	private String userType;

	// Constructors

	/** default constructor */
	public Staff() {
	}

	/** minimal constructor */
	public Staff(String loginName, String loginPwd, String name, String status,
			Timestamp createTime, Timestamp updateTime) {
		this.loginName = loginName;
		this.loginPwd = loginPwd;
		this.name = name;
		this.status = status;
		this.createTime = createTime;
		this.updateTime = updateTime;
	}

	/** full constructor */
	public Staff(String loginName, String loginPwd, String name, Integer sex,
			String tel, String remark, String status, Timestamp createTime,
			Timestamp updateTime, Set pics, Set financingsForPrepareStaff,
			Set financingsForValuationStaff, Set contractCollectionRecords,
			Set approves, Set operHises, Set payOwnerHises, Set agencies,
			Set recvCustHises, Set shopContractsForCreateStaff,
			Set shopContractsForClearingStaff, Set agencyDetailBillses,
			Set shopContractsForClearingStartStaff, Set todoLogsForNotifyStaff,
			Set todoLogsForWaitStaff, Set contractsForCreateStaff,
			Set todoLogsForCreateStaff, Set cycleRecvFeeRecords,
			Set contractsForClearingStaff, Set contractsForClearingStartStaff,
			Set managerFeesForOperStaff, Set payAgencyHises,
			Set managerFeesForCreateStaff, Set agencyBillses,
			Set recvDisposalHises, Set carOperHises, Set staffRights,
			Set recvFees, Set refundAgencyHises) {
		this.loginName = loginName;
		this.loginPwd = loginPwd;
		this.name = name;
		this.sex = sex;
		this.tel = tel;
		this.remark = remark;
		this.status = status;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.pics = pics;
		this.financingsForPrepareStaff = financingsForPrepareStaff;
		this.financingsForValuationStaff = financingsForValuationStaff;
		this.contractCollectionRecords = contractCollectionRecords;
//		this.approves = approves;
		this.operHises = operHises;
//		this.payOwnerHises = payOwnerHises;
		this.agencies = agencies;
//		this.recvCustHises = recvCustHises;
		this.shopContractsForCreateStaff = shopContractsForCreateStaff;
		this.shopContractsForClearingStaff = shopContractsForClearingStaff;
		this.agencyDetailBillses = agencyDetailBillses;
		this.shopContractsForClearingStartStaff = shopContractsForClearingStartStaff;
		this.todoLogsForNotifyStaff = todoLogsForNotifyStaff;
		this.todoLogsForWaitStaff = todoLogsForWaitStaff;
		this.contractsForCreateStaff = contractsForCreateStaff;
		this.todoLogsForCreateStaff = todoLogsForCreateStaff;
		this.cycleRecvFeeRecords = cycleRecvFeeRecords;
		this.contractsForClearingStaff = contractsForClearingStaff;
		this.contractsForClearingStartStaff = contractsForClearingStartStaff;
		this.managerFeesForOperStaff = managerFeesForOperStaff;
//		this.payAgencyHises = payAgencyHises;
		this.managerFeesForCreateStaff = managerFeesForCreateStaff;
		this.agencyBillses = agencyBillses;
		this.recvDisposalHises = recvDisposalHises;
		this.carOperHises = carOperHises;
		this.staffRights = staffRights;
		this.recvFees = recvFees;
		this.refundAgencyHises = refundAgencyHises;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getLoginName() {
		return this.loginName;
	}

	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}

	public String getLoginPwd() {
		return this.loginPwd;
	}

	public void setLoginPwd(String loginPwd) {
		this.loginPwd = loginPwd;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getSex() {
		return this.sex;
	}

	public void setSex(Integer sex) {
		this.sex = sex;
	}

	public String getTel() {
		return this.tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
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

	public Set getPics() {
		return this.pics;
	}

	public void setPics(Set pics) {
		this.pics = pics;
	}

	public Set getFinancingsForPrepareStaff() {
		return this.financingsForPrepareStaff;
	}

	public void setFinancingsForPrepareStaff(Set financingsForPrepareStaff) {
		this.financingsForPrepareStaff = financingsForPrepareStaff;
	}

	public Set getFinancingsForValuationStaff() {
		return this.financingsForValuationStaff;
	}

	public void setFinancingsForValuationStaff(Set financingsForValuationStaff) {
		this.financingsForValuationStaff = financingsForValuationStaff;
	}

	public Set getContractCollectionRecords() {
		return this.contractCollectionRecords;
	}

	public void setContractCollectionRecords(Set contractCollectionRecords) {
		this.contractCollectionRecords = contractCollectionRecords;
	}

//	public Set getApproves() {
//		return this.approves;
//	}

//	public void setApproves(Set approves) {
//		this.approves = approves;
//	}

	public Set getOperHises() {
		return this.operHises;
	}

	public void setOperHises(Set operHises) {
		this.operHises = operHises;
	}

//	public Set getPayOwnerHises() {
//		return this.payOwnerHises;
//	}

//	public void setPayOwnerHises(Set payOwnerHises) {
//		this.payOwnerHises = payOwnerHises;
//	}

	public Set getAgencies() {
		return this.agencies;
	}

	public void setAgencies(Set agencies) {
		this.agencies = agencies;
	}

//	public Set getRecvCustHises() {
//		return this.recvCustHises;
//	}

//	public void setRecvCustHises(Set recvCustHises) {
//		this.recvCustHises = recvCustHises;
//	}

	public Set getShopContractsForCreateStaff() {
		return this.shopContractsForCreateStaff;
	}

	public void setShopContractsForCreateStaff(Set shopContractsForCreateStaff) {
		this.shopContractsForCreateStaff = shopContractsForCreateStaff;
	}

	public Set getShopContractsForClearingStaff() {
		return this.shopContractsForClearingStaff;
	}

	public void setShopContractsForClearingStaff(
			Set shopContractsForClearingStaff) {
		this.shopContractsForClearingStaff = shopContractsForClearingStaff;
	}

	public Set getAgencyDetailBillses() {
		return this.agencyDetailBillses;
	}

	public void setAgencyDetailBillses(Set agencyDetailBillses) {
		this.agencyDetailBillses = agencyDetailBillses;
	}

	public Set getShopContractsForClearingStartStaff() {
		return this.shopContractsForClearingStartStaff;
	}

	public void setShopContractsForClearingStartStaff(
			Set shopContractsForClearingStartStaff) {
		this.shopContractsForClearingStartStaff = shopContractsForClearingStartStaff;
	}

	public Set getTodoLogsForNotifyStaff() {
		return this.todoLogsForNotifyStaff;
	}

	public void setTodoLogsForNotifyStaff(Set todoLogsForNotifyStaff) {
		this.todoLogsForNotifyStaff = todoLogsForNotifyStaff;
	}

	public Set getTodoLogsForWaitStaff() {
		return this.todoLogsForWaitStaff;
	}

	public void setTodoLogsForWaitStaff(Set todoLogsForWaitStaff) {
		this.todoLogsForWaitStaff = todoLogsForWaitStaff;
	}

	public Set getContractsForCreateStaff() {
		return this.contractsForCreateStaff;
	}

	public void setContractsForCreateStaff(Set contractsForCreateStaff) {
		this.contractsForCreateStaff = contractsForCreateStaff;
	}

	public Set getTodoLogsForCreateStaff() {
		return this.todoLogsForCreateStaff;
	}

	public void setTodoLogsForCreateStaff(Set todoLogsForCreateStaff) {
		this.todoLogsForCreateStaff = todoLogsForCreateStaff;
	}

	public Set getCycleRecvFeeRecords() {
		return this.cycleRecvFeeRecords;
	}

	public void setCycleRecvFeeRecords(Set cycleRecvFeeRecords) {
		this.cycleRecvFeeRecords = cycleRecvFeeRecords;
	}

	public Set getContractsForClearingStaff() {
		return this.contractsForClearingStaff;
	}

	public void setContractsForClearingStaff(Set contractsForClearingStaff) {
		this.contractsForClearingStaff = contractsForClearingStaff;
	}

	public Set getContractsForClearingStartStaff() {
		return this.contractsForClearingStartStaff;
	}

	public void setContractsForClearingStartStaff(
			Set contractsForClearingStartStaff) {
		this.contractsForClearingStartStaff = contractsForClearingStartStaff;
	}

	public Set getManagerFeesForOperStaff() {
		return this.managerFeesForOperStaff;
	}

	public void setManagerFeesForOperStaff(Set managerFeesForOperStaff) {
		this.managerFeesForOperStaff = managerFeesForOperStaff;
	}

//	public Set getPayAgencyHises() {
//		return this.payAgencyHises;
//	}

//	public void setPayAgencyHises(Set payAgencyHises) {
//		this.payAgencyHises = payAgencyHises;
//	}

	public Set getManagerFeesForCreateStaff() {
		return this.managerFeesForCreateStaff;
	}

	public void setManagerFeesForCreateStaff(Set managerFeesForCreateStaff) {
		this.managerFeesForCreateStaff = managerFeesForCreateStaff;
	}

	public Set getAgencyBillses() {
		return this.agencyBillses;
	}

	public void setAgencyBillses(Set agencyBillses) {
		this.agencyBillses = agencyBillses;
	}

	public Set getRecvDisposalHises() {
		return this.recvDisposalHises;
	}

	public void setRecvDisposalHises(Set recvDisposalHises) {
		this.recvDisposalHises = recvDisposalHises;
	}

	public Set getCarOperHises() {
		return this.carOperHises;
	}

	public void setCarOperHises(Set carOperHises) {
		this.carOperHises = carOperHises;
	}

	public Set getStaffRights() {
		return this.staffRights;
	}

	public void setStaffRights(Set staffRights) {
		this.staffRights = staffRights;
	}

	public Set getRecvFees() {
		return this.recvFees;
	}

	public void setRecvFees(Set recvFees) {
		this.recvFees = recvFees;
	}

	public Set getRefundAgencyHises() {
		return this.refundAgencyHises;
	}

	public void setRefundAgencyHises(Set refundAgencyHises) {
		this.refundAgencyHises = refundAgencyHises;
	}

	public Market getMarket() {
		return market;
	}

	public void setMarket(Market market) {
		this.market = market;
	}

	public Agency getAgency() {
		return agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
  }

	public String getIdNo() {
		return idNo;
	}

	public void setIdNo(String idNo) {
		this.idNo = idNo;
	}

	public String getNeedSmsNotice() { return needSmsNotice; }
	public void setNeedSmsNotice(String need) { this.needSmsNotice = need; }


	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}
}