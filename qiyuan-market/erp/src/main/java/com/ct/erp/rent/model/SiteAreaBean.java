package com.ct.erp.rent.model;

public class SiteAreaBean {
	
	
	private String monthRentFee;
	private Double unitTotalCount;
	private String unitMonthRentFee;
	private Double totalCount;
	
	
	public Double getUnitTotalCount() {
		return unitTotalCount;
	}

	public void setUnitTotalCount(Double unitTotalCount) {
		this.unitTotalCount = unitTotalCount;
	}

	public Double getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(Double totalCount) {
		this.totalCount = totalCount;
	}

	public String getMonthRentFee() {
		return monthRentFee;
	}

	public void setMonthRentFee(String monthRentFee) {
		this.monthRentFee = monthRentFee;
	}

	public String getUnitMonthRentFee() {
		return unitMonthRentFee;
	}

	public void setUnitMonthRentFee(String unitMonthRentFee) {
		this.unitMonthRentFee = unitMonthRentFee;
	}
	
	
}
