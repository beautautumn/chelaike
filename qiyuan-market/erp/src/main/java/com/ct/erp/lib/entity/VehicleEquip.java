package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Vehicle;

/**
 * VehicleEquip entity. @author MyEclipse Persistence Tools
 */

public class VehicleEquip implements java.io.Serializable {

	// Fields

	private Long id;
	private Vehicle vehicle;
	private String channelId;
	private String coverUrl;
	private String manufacturerName;
	private String doorCount;
	private String mileageInFact;
	private String licenseInfo;
	private String starRating;
	private String warrantyId;
	private String warrantyFeeYuan;
	private String isFixedPrice;
	private String allowedMortgage;
	private String mortgageNote;
	private String sellingPoint;
	private String maintainMileage;
	private String hasMaintainHistory;
	private String newCarWarranty;
	private String manufacturerConfiguration;
	private String configurationNote;

	// Constructors

	/** default constructor */
	public VehicleEquip() {
	}

	/** full constructor */
	public VehicleEquip(Vehicle vehicle, String channelId, String coverUrl,
                        String manufacturerName, String doorCount, String mileageInFact,
                        String licenseInfo, String starRating, String warrantyId,
                        String warrantyFeeYuan, String isFixedPrice,
                        String allowedMortgage, String mortgageNote, String sellingPoint,
                        String maintainMileage, String hasMaintainHistory,
                        String newCarWarranty, String manufacturerConfiguration,
                        String configurationNote) {
		this.vehicle = vehicle;
		this.channelId = channelId;
		this.coverUrl = coverUrl;
		this.manufacturerName = manufacturerName;
		this.doorCount = doorCount;
		this.mileageInFact = mileageInFact;
		this.licenseInfo = licenseInfo;
		this.starRating = starRating;
		this.warrantyId = warrantyId;
		this.warrantyFeeYuan = warrantyFeeYuan;
		this.isFixedPrice = isFixedPrice;
		this.allowedMortgage = allowedMortgage;
		this.mortgageNote = mortgageNote;
		this.sellingPoint = sellingPoint;
		this.maintainMileage = maintainMileage;
		this.hasMaintainHistory = hasMaintainHistory;
		this.newCarWarranty = newCarWarranty;
		this.manufacturerConfiguration = manufacturerConfiguration;
		this.configurationNote = configurationNote;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Vehicle getVehicle() {
		return this.vehicle;
	}

	public void setVehicle(Vehicle vehicle) {
		this.vehicle = vehicle;
	}

	public String getChannelId() {
		return this.channelId;
	}

	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}

	public String getCoverUrl() {
		return this.coverUrl;
	}

	public void setCoverUrl(String coverUrl) {
		this.coverUrl = coverUrl;
	}

	public String getManufacturerName() {
		return this.manufacturerName;
	}

	public void setManufacturerName(String manufacturerName) {
		this.manufacturerName = manufacturerName;
	}

	public String getDoorCount() {
		return this.doorCount;
	}

	public void setDoorCount(String doorCount) {
		this.doorCount = doorCount;
	}

	public String getMileageInFact() {
		return this.mileageInFact;
	}

	public void setMileageInFact(String mileageInFact) {
		this.mileageInFact = mileageInFact;
	}

	public String getLicenseInfo() {
		return this.licenseInfo;
	}

	public void setLicenseInfo(String licenseInfo) {
		this.licenseInfo = licenseInfo;
	}

	public String getStarRating() {
		return this.starRating;
	}

	public void setStarRating(String starRating) {
		this.starRating = starRating;
	}

	public String getWarrantyId() {
		return this.warrantyId;
	}

	public void setWarrantyId(String warrantyId) {
		this.warrantyId = warrantyId;
	}

	public String getWarrantyFeeYuan() {
		return this.warrantyFeeYuan;
	}

	public void setWarrantyFeeYuan(String warrantyFeeYuan) {
		this.warrantyFeeYuan = warrantyFeeYuan;
	}

	public String getIsFixedPrice() {
		return this.isFixedPrice;
	}

	public void setIsFixedPrice(String isFixedPrice) {
		this.isFixedPrice = isFixedPrice;
	}

	public String getAllowedMortgage() {
		return this.allowedMortgage;
	}

	public void setAllowedMortgage(String allowedMortgage) {
		this.allowedMortgage = allowedMortgage;
	}

	public String getMortgageNote() {
		return this.mortgageNote;
	}

	public void setMortgageNote(String mortgageNote) {
		this.mortgageNote = mortgageNote;
	}

	public String getSellingPoint() {
		return this.sellingPoint;
	}

	public void setSellingPoint(String sellingPoint) {
		this.sellingPoint = sellingPoint;
	}

	public String getMaintainMileage() {
		return this.maintainMileage;
	}

	public void setMaintainMileage(String maintainMileage) {
		this.maintainMileage = maintainMileage;
	}

	public String getHasMaintainHistory() {
		return this.hasMaintainHistory;
	}

	public void setHasMaintainHistory(String hasMaintainHistory) {
		this.hasMaintainHistory = hasMaintainHistory;
	}

	public String getNewCarWarranty() {
		return this.newCarWarranty;
	}

	public void setNewCarWarranty(String newCarWarranty) {
		this.newCarWarranty = newCarWarranty;
	}

	public String getManufacturerConfiguration() {
		return this.manufacturerConfiguration;
	}

	public void setManufacturerConfiguration(String manufacturerConfiguration) {
		this.manufacturerConfiguration = manufacturerConfiguration;
	}

	public String getConfigurationNote() {
		return this.configurationNote;
	}

	public void setConfigurationNote(String configurationNote) {
		this.configurationNote = configurationNote;
	}

}