package com.ct.erp.rent.model;

import com.ct.erp.lib.entity.ClearingReason;
import com.ct.erp.lib.entity.ContractCollectionPlan;
import com.ct.erp.lib.entity.Staff;

public class ContractCollectionPlanBean {
	private ContractCollectionPlan contractCollectionPlan = new ContractCollectionPlan();
	private Long staffId;
	private String recvFee;
	private String recvDepositFee;
	private String recvDate;
	private String remark;
	private Long planId;
	private String backDesc;
	private String backTime;
	private ClearingReason clearingReason;
	private String clearingStartDate;
	private Staff staffByClearingStartStaff;
	private String clearingDesc;
	private String endReason;
	private int backDepositFee;

	public ContractCollectionPlan getContractCollectionPlan() {
		return contractCollectionPlan;
	}

	public void setContractCollectionPlan(
			ContractCollectionPlan contractCollectionPlan) {
		this.contractCollectionPlan = contractCollectionPlan;
	}

	public Long getStaffId() {
		return staffId;
	}

	public void setStaffId(Long staffId) {
		this.staffId = staffId;
	}

	public String getRecvFee() {
		return recvFee;
	}

	public void setRecvFee(String recvFee) {
		this.recvFee = recvFee;
	}

	public String getRecvDepositFee() {
		return recvDepositFee;
	}

	public void setRecvDepositFee(String recvDepositFee) {
		this.recvDepositFee = recvDepositFee;
	}

	public String getRecvDate() {
		return recvDate;
	}

	public void setRecvDate(String recvDate) {
		this.recvDate = recvDate;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Long getPlanId() {
		return planId;
	}

	public void setPlanId(Long planId) {
		this.planId = planId;
	}

	public String getBackDesc() {
		return backDesc;
	}

	public void setBackDesc(String backDesc) {
		this.backDesc = backDesc;
	}

	public String getBackTime() {
		return backTime;
	}

	public void setBackTime(String backTime) {
		this.backTime = backTime;
	}

	public ClearingReason getClearingReason() {
		return clearingReason;
	}

	public void setClearingReason(ClearingReason clearingReason) {
		this.clearingReason = clearingReason;
	}

	public String getClearingStartDate() {
		return clearingStartDate;
	}

	public void setClearingStartDate(String clearingStartDate) {
		this.clearingStartDate = clearingStartDate;
	}

	public Staff getStaffByClearingStartStaff() {
		return staffByClearingStartStaff;
	}

	public void setStaffByClearingStartStaff(Staff staffByClearingStartStaff) {
		this.staffByClearingStartStaff = staffByClearingStartStaff;
	}

	public String getClearingDesc() {
		return clearingDesc;
	}

	public void setClearingDesc(String clearingDesc) {
		this.clearingDesc = clearingDesc;
	}

	public String getEndReason() {
		return endReason;
	}

	public void setEndReason(String endReason) {
		this.endReason = endReason;
	}

	public int getBackDepositFee() {
		return backDepositFee;
	}

	public void setBackDepositFee(int backDepositFee) {
		this.backDepositFee = backDepositFee;
	}

}
