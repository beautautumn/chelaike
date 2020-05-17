package com.ct.erp.lib.entity;

import java.sql.Timestamp;
import java.util.Date;

/**
 * Created by x on 2017/9/8.
 */
public class Cars implements java.io.Serializable {

    private Long id;
    private Long companyId;
    private Long shopId;
    private Long acquirerId;
    private Timestamp acquiredAt;
    private Long channelId;
    private String acquisitonType;
    private Long acquisitionPriceCents;
    private String stockNumber;
    private String vin;
    private String state;
    private String stateNote;
    private String brandName;
    private String manufacturerName;
    private String seriesName;
    private String styleName;
    private String carType;
    private Long doorCount;
    private Float displacement;
    private String fuelType;
    private Boolean isTurboCharger;
    private String transmission;
    private String exteriorColor;
    private String interiorColor;
    private Float mileage;
    private Float mileageInFact;
    private String emissionStandard;
    private String licenseInfo;
    private Date licenseAt;
    private Date manufacturedAt;
    private Long showPriceCents;
    private Long onlinePriceCents;
    private Long salesMinimunPriceCents;
    private Long managerPriceCents;
    private Long allianceMinimunPriceCents;
    private Long newCarGuidePriceCents;
    private Long newCarAdditionalPriceCents;
    private Float newCarDiscount;
    private Long newCarFinalPriceCents;
    private String interiorNote;
    private Long starRating;
    private Long warrantyId;
    private Long warrantyFeeCents;
    private Boolean isFixedPrice;
    private Boolean allowedMortgage;
    private String mortgageNote;
    private String sellingPoint;
    private Float maintainMileage;
    private Boolean hasMaintainHistory;
    private String newCarWarranty;
    private String standardEquipment;
    private String personalEquipment;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Long stockAgeDays;
    private Long age;
    private Boolean sellable;
    private String statesStatistic;
    private Timestamp stateChangedAt;
    private Long yellowStockWarningDays;
    private String imported;
    private Timestamp reservedAt;
    private String consignorName;
    private String consignorPhone;
    private Long consignorPriceCents;
    private Timestamp deletedAt;
    private Timestamp stockOutAt;
    private Long closingCostCents;
    private String manufacturerConfiguration;
    private Timestamp predictedRestockedAt;
    private Boolean reserved;
    private String configurationNote;
    private String name;
    private String namePinyin;
    private String attachments;
    private Long redStockWarningDays;
    private String level;
    private String currentPlateNumber;
    private String systemName;
    private Boolean isSpecialOffer;
    private Long estimatedGrossProfitCents;
    private Float estimatedGrossProfitRate;
    private String feeDetail;
    private Long CurrentPublishRecordsCount;
    private Long imagesCount;
    private Long sellerId;
    private String coverUrl;
    private String allianceCoverUrl;
    private Boolean isOnsale;
    private Long onsalePriceCents;
    private String onsaleDescription;
    private Boolean maintain4s;
    private Boolean transferFeeIncluded;
    private String contactPhone;
    private String ContactUser;
    private String recordAddress;
    private String moreNote;


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(Long companyId) {
        this.companyId = companyId;
    }

    public Long getShopId() {
        return shopId;
    }

    public void setShopId(Long shopId) {
        this.shopId = shopId;
    }

    public Long getAcquirerId() {
        return acquirerId;
    }

    public void setAcquirerId(Long acquirerId) {
        this.acquirerId = acquirerId;
    }

    public Timestamp getAcquiredAt() {
        return acquiredAt;
    }

    public void setAcquiredAt(Timestamp acquiredAt) {
        this.acquiredAt = acquiredAt;
    }

    public Long getChannelId() {
        return channelId;
    }

    public void setChannelId(Long channelId) {
        this.channelId = channelId;
    }

    public String getAcquisitonType() {
        return acquisitonType;
    }

    public void setAcquisitonType(String acquisitonType) {
        this.acquisitonType = acquisitonType;
    }

    public Long getAcquisitionPriceCents() {
        return acquisitionPriceCents;
    }

    public void setAcquisitionPriceCents(Long acquisitionPriceCents) {
        this.acquisitionPriceCents = acquisitionPriceCents;
    }

    public String getStockNumber() {
        return stockNumber;
    }

    public void setStockNumber(String stockNumber) {
        this.stockNumber = stockNumber;
    }

    public String getVin() {
        return vin;
    }

    public void setVin(String vin) {
        this.vin = vin;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getStateNote() {
        return stateNote;
    }

    public void setStateNote(String stateNote) {
        this.stateNote = stateNote;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getManufacturerName() {
        return manufacturerName;
    }

    public void setManufacturerName(String manufacturerName) {
        this.manufacturerName = manufacturerName;
    }

    public String getSeriesName() {
        return seriesName;
    }

    public void setSeriesName(String seriesName) {
        this.seriesName = seriesName;
    }

    public String getStyleName() {
        return styleName;
    }

    public void setStyleName(String styleName) {
        this.styleName = styleName;
    }

    public String getCarType() {
        return carType;
    }

    public void setCarType(String carType) {
        this.carType = carType;
    }

    public Long getDoorCount() {
        return doorCount;
    }

    public void setDoorCount(Long doorCount) {
        this.doorCount = doorCount;
    }

    public Float getDisplacement() {
        return displacement;
    }

    public void setDisplacement(Float displacement) {
        this.displacement = displacement;
    }

    public String getFuelType() {
        return fuelType;
    }

    public void setFuelType(String fuelType) {
        this.fuelType = fuelType;
    }

    public Boolean getTurboCharger() {
        return isTurboCharger;
    }

    public void setTurboCharger(Boolean turboCharger) {
        isTurboCharger = turboCharger;
    }

    public String getTransmission() {
        return transmission;
    }

    public void setTransmission(String transmission) {
        this.transmission = transmission;
    }

    public String getExteriorColor() {
        return exteriorColor;
    }

    public void setExteriorColor(String exteriorColor) {
        this.exteriorColor = exteriorColor;
    }

    public String getInteriorColor() {
        return interiorColor;
    }

    public void setInteriorColor(String interiorColor) {
        this.interiorColor = interiorColor;
    }

    public Float getMileage() {
        return mileage;
    }

    public void setMileage(Float mileage) {
        this.mileage = mileage;
    }

    public Float getMileageInFact() {
        return mileageInFact;
    }

    public void setMileageInFact(Float mileageInFact) {
        this.mileageInFact = mileageInFact;
    }

    public String getEmissionStandard() {
        return emissionStandard;
    }

    public void setEmissionStandard(String emissionStandard) {
        this.emissionStandard = emissionStandard;
    }

    public String getLicenseInfo() {
        return licenseInfo;
    }

    public void setLicenseInfo(String licenseInfo) {
        this.licenseInfo = licenseInfo;
    }

    public Date getLicenseAt() {
        return licenseAt;
    }

    public void setLicenseAt(Date licenseAt) {
        this.licenseAt = licenseAt;
    }

    public Date getManufacturedAt() {
        return manufacturedAt;
    }

    public void setManufacturedAt(Date manufacturedAt) {
        this.manufacturedAt = manufacturedAt;
    }

    public Long getShowPriceCents() {
        return showPriceCents;
    }

    public void setShowPriceCents(Long showPriceCents) {
        this.showPriceCents = showPriceCents;
    }

    public Long getOnlinePriceCents() {
        return onlinePriceCents;
    }

    public void setOnlinePriceCents(Long onlinePriceCents) {
        this.onlinePriceCents = onlinePriceCents;
    }

    public Long getSalesMinimunPriceCents() {
        return salesMinimunPriceCents;
    }

    public void setSalesMinimunPriceCents(Long salesMinimunPriceCents) {
        this.salesMinimunPriceCents = salesMinimunPriceCents;
    }

    public Long getManagerPriceCents() {
        return managerPriceCents;
    }

    public void setManagerPriceCents(Long managerPriceCents) {
        this.managerPriceCents = managerPriceCents;
    }

    public Long getAllianceMinimunPriceCents() {
        return allianceMinimunPriceCents;
    }

    public void setAllianceMinimunPriceCents(Long allianceMinimunPriceCents) {
        this.allianceMinimunPriceCents = allianceMinimunPriceCents;
    }

    public Long getNewCarGuidePriceCents() {
        return newCarGuidePriceCents;
    }

    public void setNewCarGuidePriceCents(Long newCarGuidePriceCents) {
        this.newCarGuidePriceCents = newCarGuidePriceCents;
    }

    public Long getNewCarAdditionalPriceCents() {
        return newCarAdditionalPriceCents;
    }

    public void setNewCarAdditionalPriceCents(Long newCarAdditionalPriceCents) {
        this.newCarAdditionalPriceCents = newCarAdditionalPriceCents;
    }

    public Float getNewCarDiscount() {
        return newCarDiscount;
    }

    public void setNewCarDiscount(Float newCarDiscount) {
        this.newCarDiscount = newCarDiscount;
    }

    public Long getNewCarFinalPriceCents() {
        return newCarFinalPriceCents;
    }

    public void setNewCarFinalPriceCents(Long newCarFinalPriceCents) {
        this.newCarFinalPriceCents = newCarFinalPriceCents;
    }

    public String getInteriorNote() {
        return interiorNote;
    }

    public void setInteriorNote(String interiorNote) {
        this.interiorNote = interiorNote;
    }

    public Long getStarRating() {
        return starRating;
    }

    public void setStarRating(Long starRating) {
        this.starRating = starRating;
    }

    public Long getWarrantyId() {
        return warrantyId;
    }

    public void setWarrantyId(Long warrantyId) {
        this.warrantyId = warrantyId;
    }

    public Long getWarrantyFeeCents() {
        return warrantyFeeCents;
    }

    public void setWarrantyFeeCents(Long warrantyFeeCents) {
        this.warrantyFeeCents = warrantyFeeCents;
    }

    public Boolean getFixedPrice() {
        return isFixedPrice;
    }

    public void setFixedPrice(Boolean fixedPrice) {
        isFixedPrice = fixedPrice;
    }

    public Boolean getAllowedMortgage() {
        return allowedMortgage;
    }

    public void setAllowedMortgage(Boolean allowedMortgage) {
        this.allowedMortgage = allowedMortgage;
    }

    public String getMortgageNote() {
        return mortgageNote;
    }

    public void setMortgageNote(String mortgageNote) {
        this.mortgageNote = mortgageNote;
    }

    public String getSellingPoint() {
        return sellingPoint;
    }

    public void setSellingPoint(String sellingPoint) {
        this.sellingPoint = sellingPoint;
    }

    public Float getMaintainMileage() {
        return maintainMileage;
    }

    public void setMaintainMileage(Float maintainMileage) {
        this.maintainMileage = maintainMileage;
    }

    public Boolean getHasMaintainHistory() {
        return hasMaintainHistory;
    }

    public void setHasMaintainHistory(Boolean hasMaintainHistory) {
        this.hasMaintainHistory = hasMaintainHistory;
    }

    public String getNewCarWarranty() {
        return newCarWarranty;
    }

    public void setNewCarWarranty(String newCarWarranty) {
        this.newCarWarranty = newCarWarranty;
    }

    public String getStandardEquipment() {
        return standardEquipment;
    }

    public void setStandardEquipment(String standardEquipment) {
        this.standardEquipment = standardEquipment;
    }

    public String getPersonalEquipment() {
        return personalEquipment;
    }

    public void setPersonalEquipment(String personalEquipment) {
        this.personalEquipment = personalEquipment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Long getStockAgeDays() {
        return stockAgeDays;
    }

    public void setStockAgeDays(Long stockAgeDays) {
        this.stockAgeDays = stockAgeDays;
    }

    public Long getAge() {
        return age;
    }

    public void setAge(Long age) {
        this.age = age;
    }

    public Boolean getSellable() {
        return sellable;
    }

    public void setSellable(Boolean sellable) {
        this.sellable = sellable;
    }

    public String getStatesStatistic() {
        return statesStatistic;
    }

    public void setStatesStatistic(String statesStatistic) {
        this.statesStatistic = statesStatistic;
    }

    public Timestamp getStateChangedAt() {
        return stateChangedAt;
    }

    public void setStateChangedAt(Timestamp stateChangedAt) {
        this.stateChangedAt = stateChangedAt;
    }

    public Long getYellowStockWarningDays() {
        return yellowStockWarningDays;
    }

    public void setYellowStockWarningDays(Long yellowStockWarningDays) {
        this.yellowStockWarningDays = yellowStockWarningDays;
    }

    public String getImported() {
        return imported;
    }

    public void setImported(String imported) {
        this.imported = imported;
    }

    public Timestamp getReservedAt() {
        return reservedAt;
    }

    public void setReservedAt(Timestamp reservedAt) {
        this.reservedAt = reservedAt;
    }

    public String getConsignorName() {
        return consignorName;
    }

    public void setConsignorName(String consignorName) {
        this.consignorName = consignorName;
    }

    public String getConsignorPhone() {
        return consignorPhone;
    }

    public void setConsignorPhone(String consignorPhone) {
        this.consignorPhone = consignorPhone;
    }

    public Long getConsignorPriceCents() {
        return consignorPriceCents;
    }

    public void setConsignorPriceCents(Long consignorPriceCents) {
        this.consignorPriceCents = consignorPriceCents;
    }

    public Timestamp getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(Timestamp deletedAt) {
        this.deletedAt = deletedAt;
    }

    public Timestamp getStockOutAt() {
        return stockOutAt;
    }

    public void setStockOutAt(Timestamp stockOutAt) {
        this.stockOutAt = stockOutAt;
    }

    public Long getClosingCostCents() {
        return closingCostCents;
    }

    public void setClosingCostCents(Long closingCostCents) {
        this.closingCostCents = closingCostCents;
    }

    public String getManufacturerConfiguration() {
        return manufacturerConfiguration;
    }

    public void setManufacturerConfiguration(String manufacturerConfiguration) {
        this.manufacturerConfiguration = manufacturerConfiguration;
    }

    public Timestamp getPredictedRestockedAt() {
        return predictedRestockedAt;
    }

    public void setPredictedRestockedAt(Timestamp predictedRestockedAt) {
        this.predictedRestockedAt = predictedRestockedAt;
    }

    public Boolean getReserved() {
        return reserved;
    }

    public void setReserved(Boolean reserved) {
        this.reserved = reserved;
    }

    public String getConfigurationNote() {
        return configurationNote;
    }

    public void setConfigurationNote(String configurationNote) {
        this.configurationNote = configurationNote;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNamePinyin() {
        return namePinyin;
    }

    public void setNamePinyin(String namePinyin) {
        this.namePinyin = namePinyin;
    }

    public String getAttachments() {
        return attachments;
    }

    public void setAttachments(String attachments) {
        this.attachments = attachments;
    }

    public Long getRedStockWarningDays() {
        return redStockWarningDays;
    }

    public void setRedStockWarningDays(Long redStockWarningDays) {
        this.redStockWarningDays = redStockWarningDays;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getCurrentPlateNumber() {
        return currentPlateNumber;
    }

    public void setCurrentPlateNumber(String currentPlateNumber) {
        this.currentPlateNumber = currentPlateNumber;
    }

    public String getSystemName() {
        return systemName;
    }

    public void setSystemName(String systemName) {
        this.systemName = systemName;
    }

    public Boolean getSpecialOffer() {
        return isSpecialOffer;
    }

    public void setSpecialOffer(Boolean specialOffer) {
        isSpecialOffer = specialOffer;
    }

    public Long getEstimatedGrossProfitCents() {
        return estimatedGrossProfitCents;
    }

    public void setEstimatedGrossProfitCents(Long estimatedGrossProfitCents) {
        this.estimatedGrossProfitCents = estimatedGrossProfitCents;
    }

    public Float getEstimatedGrossProfitRate() {
        return estimatedGrossProfitRate;
    }

    public void setEstimatedGrossProfitRate(Float estimatedGrossProfitRate) {
        this.estimatedGrossProfitRate = estimatedGrossProfitRate;
    }

    public String getFeeDetail() {
        return feeDetail;
    }

    public void setFeeDetail(String feeDetail) {
        this.feeDetail = feeDetail;
    }

    public Long getCurrentPublishRecordsCount() {
        return CurrentPublishRecordsCount;
    }

    public void setCurrentPublishRecordsCount(Long currentPublishRecordsCount) {
        CurrentPublishRecordsCount = currentPublishRecordsCount;
    }

    public Long getImagesCount() {
        return imagesCount;
    }

    public void setImagesCount(Long imagesCount) {
        this.imagesCount = imagesCount;
    }

    public Long getSellerId() {
        return sellerId;
    }

    public void setSellerId(Long sellerId) {
        this.sellerId = sellerId;
    }

    public String getCoverUrl() {
        return coverUrl;
    }

    public void setCoverUrl(String coverUrl) {
        this.coverUrl = coverUrl;
    }

    public String getAllianceCoverUrl() {
        return allianceCoverUrl;
    }

    public void setAllianceCoverUrl(String allianceCoverUrl) {
        this.allianceCoverUrl = allianceCoverUrl;
    }

    public Boolean getOnsale() {
        return isOnsale;
    }

    public void setOnsale(Boolean onsale) {
        isOnsale = onsale;
    }

    public Long getOnsalePriceCents() {
        return onsalePriceCents;
    }

    public void setOnsalePriceCents(Long onsalePriceCents) {
        this.onsalePriceCents = onsalePriceCents;
    }

    public String getOnsaleDescription() {
        return onsaleDescription;
    }

    public void setOnsaleDescription(String onsaleDescription) {
        this.onsaleDescription = onsaleDescription;
    }

    public Boolean getMaintain4s() {
        return maintain4s;
    }

    public void setMaintain4s(Boolean maintain4s) {
        this.maintain4s = maintain4s;
    }

    public Boolean getTransferFeeIncluded() {
        return transferFeeIncluded;
    }

    public void setTransferFeeIncluded(Boolean transferFeeIncluded) {
        this.transferFeeIncluded = transferFeeIncluded;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getContactUser() {
        return ContactUser;
    }

    public void setContactUser(String contactUser) {
        ContactUser = contactUser;
    }

    public String getRecordAddress() {
        return recordAddress;
    }

    public void setRecordAddress(String recordAddress) {
        this.recordAddress = recordAddress;
    }

    public String getMoreNote() {
        return moreNote;
    }

    public void setMoreNote(String moreNote) {
        this.moreNote = moreNote;
    }
}
