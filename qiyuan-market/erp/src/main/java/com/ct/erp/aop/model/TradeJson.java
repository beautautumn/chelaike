package com.ct.erp.aop.model;


/**
 * @author shiqingwen
 */

public class TradeJson {

	// Fields

	private Long id;
	private Long vehicleId;
	private Long agencyId;
	private Long financingId;
	private String barCode;
	private String oldLicenseCode;
	private String newLicenseCode;
	private Long acquPrice;
	private Long showPrice;
	private Long salePrice;
	private String financingTag;
	private String certifyTag;
	private String firstTransferTag;
	private String saleTransferTag;
	private String state;
	private String approveTag;
	private Long approveId;
	private String consignTag;
	private Long valuationFee;
	private String transferCount;
	private String befOutState;
	
	public TradeJson(com.ct.erp.lib.entity.Trade tradeJson){
		if(tradeJson != null){
			this.id = tradeJson.getId();
			if(tradeJson.getVehicle() != null){
				this.vehicleId = tradeJson.getVehicle().getId();
			}
			if(tradeJson.getAgency() != null){
				this.agencyId = tradeJson.getAgency().getId();
			}
			if(tradeJson.getFinancing() != null){
				this.financingId = tradeJson.getFinancing().getId();
			}
			this.barCode = tradeJson.getBarCode();
			this.oldLicenseCode = tradeJson.getOldLicenseCode();
			this.newLicenseCode = tradeJson.getNewLicenseCode();
			this.acquPrice = tradeJson.getAcquPrice();
			this.showPrice = tradeJson.getShowPrice();
			this.salePrice = tradeJson.getSalePrice();
			this.financingTag = tradeJson.getFinancingTag();
			this.certifyTag = tradeJson.getCertifyTag();
			this.firstTransferTag = tradeJson.getFirstTransferTag();
			this.saleTransferTag = tradeJson.getSaleTransferTag();
			this.state = tradeJson.getState();
			this.approveTag = tradeJson.getApproveTag();
			this.approveId = tradeJson.getApproveId();
			this.consignTag = tradeJson.getConsignTag();
			this.valuationFee = tradeJson.getValuationFee();
			this.transferCount = tradeJson.getTransferCount();
			this.befOutState = tradeJson.getBefOutState();
		}
	}
	
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
	public Long getAgencyId() {
		return agencyId;
	}
	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}
	public Long getFinancingId() {
		return financingId;
	}
	public void setFinancingId(Long financingId) {
		this.financingId = financingId;
	}
	public String getBarCode() {
		return barCode;
	}
	public void setBarCode(String barCode) {
		this.barCode = barCode;
	}
	public String getOldLicenseCode() {
		return oldLicenseCode;
	}
	public void setOldLicenseCode(String oldLicenseCode) {
		this.oldLicenseCode = oldLicenseCode;
	}
	public String getNewLicenseCode() {
		return newLicenseCode;
	}
	public void setNewLicenseCode(String newLicenseCode) {
		this.newLicenseCode = newLicenseCode;
	}
	public Long getAcquPrice() {
		return acquPrice;
	}
	public void setAcquPrice(Long acquPrice) {
		this.acquPrice = acquPrice;
	}
	public Long getShowPrice() {
		return showPrice;
	}
	public void setShowPrice(Long showPrice) {
		this.showPrice = showPrice;
	}
	public Long getSalePrice() {
		return salePrice;
	}
	public void setSalePrice(Long salePrice) {
		this.salePrice = salePrice;
	}
	public String getFinancingTag() {
		return financingTag;
	}
	public void setFinancingTag(String financingTag) {
		this.financingTag = financingTag;
	}
	public String getCertifyTag() {
		return certifyTag;
	}
	public void setCertifyTag(String certifyTag) {
		this.certifyTag = certifyTag;
	}
	public String getFirstTransferTag() {
		return firstTransferTag;
	}
	public void setFirstTransferTag(String firstTransferTag) {
		this.firstTransferTag = firstTransferTag;
	}
	public String getSaleTransferTag() {
		return saleTransferTag;
	}
	public void setSaleTransferTag(String saleTransferTag) {
		this.saleTransferTag = saleTransferTag;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getApproveTag() {
		return approveTag;
	}
	public void setApproveTag(String approveTag) {
		this.approveTag = approveTag;
	}
	public Long getApproveId() {
		return approveId;
	}
	public void setApproveId(Long approveId) {
		this.approveId = approveId;
	}
	public String getConsignTag() {
		return consignTag;
	}
	public void setConsignTag(String consignTag) {
		this.consignTag = consignTag;
	}
	public Long getValuationFee() {
		return valuationFee;
	}
	public void setValuationFee(Long valuationFee) {
		this.valuationFee = valuationFee;
	}
	public String getTransferCount() {
		return transferCount;
	}
	public void setTransferCount(String transferCount) {
		this.transferCount = transferCount;
	}
	public String getBefOutState() {
		return befOutState;
	}
	public void setBefOutState(String befOutState) {
		this.befOutState = befOutState;
	}
	
	


}