package com.ct.erp.api.model;

public class TradeBean {
	private Long id;
	private Long vehicleId;
	private Long acquPrice;
	private String oldLicenseCode;
	private String agencyName;
	private String barCode;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getVehicleId() {
		return vehicleId;
	}
	public void setVehicleId(Long vehicleId) {
		this.vehicleId = vehicleId;
	}
	public Long getAcquPrice() {
		return acquPrice;
	}
	public void setAcquPrice(Long acquPrice) {
		this.acquPrice = acquPrice;
	}
	public String getOldLicenseCode() {
		return oldLicenseCode;
	}
	public void setOldLicenseCode(String oldLicenseCode) {
		this.oldLicenseCode = oldLicenseCode;
	}
	public String getAgencyName() {
		return agencyName;
	}
	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}
	public String getBarCode() {
		return barCode;
	}
	public void setBarCode(String barCode) {
		this.barCode = barCode;
	}

}
