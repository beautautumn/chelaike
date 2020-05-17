package com.ct.erp.rent.model;

public class DepositBean {
	private String backDepositFee;
	private String settlementDate;
	private Long settlementStaffId;

	public String getBackDepositFee() {
		return backDepositFee;
	}

	public void setBackDepositFee(String backDepositFee) {
		this.backDepositFee = backDepositFee;
	}

	public String getSettlementDate() {
		return settlementDate;
	}

	public void setSettlementDate(String settlementDate) {
		this.settlementDate = settlementDate;
	}

	public Long getSettlementStaffId() {
		return settlementStaffId;
	}

	public void setSettlementStaffId(Long settlementStaffId) {
		this.settlementStaffId = settlementStaffId;
	}
	
	
}
