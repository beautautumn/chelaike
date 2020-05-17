package com.ct.erp.aop.model;

import java.util.Date;

/**
 * @author shiqingwen
 */

public class VehicleJson {

	// Fields

	private Long id;
	private Long brandId;
	private Long seriesId;
	private Long kindId;
	private String brandName;
	private String seriesName;
	private String kindName;
	private String shelfCode;
	private String licenseCode;
	private String registMonth;
	private String outputVolume;
	private String outputVolumeU;
	private String gearType;
	private String carColor;
	private String upholsteryColor;
	private String vehicleType;
	private String usedType;
	private String engineNumber;
	private String importTag;
	private String oilType;
	private Date factoryDate;
	private String newcarPrice;
	private String issurValidDate;
	private String commIssurValidDate;
	private String checkValidMonth;
	private String envLevel;
	private String condDesc;
	private String mileageCount;
	private String allowedPassengersCount;
	
	public VehicleJson(com.ct.erp.lib.entity.Vehicle vehicle){
		if(vehicle != null){
			this.id = vehicle.getId();
			if(vehicle.getBrand() != null){
				this.brandId = vehicle.getBrand().getId();
			}
			if(vehicle.getSeries() != null){
				this.seriesId = vehicle.getSeries().getId();
			}
			if(vehicle.getKind() != null){
				this.kindId = vehicle.getKind().getId();
			}
			this.brandName = vehicle.getBrandName();
			this.seriesName = vehicle.getSeriesName();
			this.kindName = vehicle.getKindName();
			this.shelfCode = vehicle.getShelfCode();
			this.licenseCode = vehicle.getLicenseCode();
			this.registMonth = vehicle.getRegistMonth();
			this.outputVolume = vehicle.getOutputVolume();
			this.outputVolumeU = vehicle.getOutputVolumeU();
			this.gearType = vehicle.getGearType();
			this.carColor = vehicle.getCarColor();
			this.upholsteryColor = vehicle.getUpholsteryColor();
			this.vehicleType = vehicle.getVehicleType();
			this.usedType = vehicle.getUsedType();
			this.engineNumber = vehicle.getEngineNumber();
			this.importTag = vehicle.getImportTag();
			this.oilType = vehicle.getOilType();
			this.factoryDate = vehicle.getFactoryDate();
			this.newcarPrice = vehicle.getNewcarPrice();
			this.issurValidDate = vehicle.getIssurValidDate();
			this.commIssurValidDate = vehicle.getCommIssurValidDate();
			this.checkValidMonth = vehicle.getCheckValidMonth();
			this.envLevel = vehicle.getEnvLevel();
			this.condDesc = vehicle.getCondDesc();
			this.mileageCount = vehicle.getMileageCount();
			this.allowedPassengersCount = vehicle.getAllowedPassengersCount();
		}
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getBrandId() {
		return brandId;
	}

	public void setBrandId(Long brandId) {
		this.brandId = brandId;
	}

	public Long getSeriesId() {
		return seriesId;
	}

	public void setSeriesId(Long seriesId) {
		this.seriesId = seriesId;
	}

	public Long getKindId() {
		return kindId;
	}

	public void setKindId(Long kindId) {
		this.kindId = kindId;
	}

	public String getBrandName() {
		return brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public String getSeriesName() {
		return seriesName;
	}

	public void setSeriesName(String seriesName) {
		this.seriesName = seriesName;
	}

	public String getKindName() {
		return kindName;
	}

	public void setKindName(String kindName) {
		this.kindName = kindName;
	}

	public String getShelfCode() {
		return shelfCode;
	}

	public void setShelfCode(String shelfCode) {
		this.shelfCode = shelfCode;
	}

	public String getLicenseCode() {
		return licenseCode;
	}

	public void setLicenseCode(String licenseCode) {
		this.licenseCode = licenseCode;
	}

	public String getRegistMonth() {
		return registMonth;
	}

	public void setRegistMonth(String registMonth) {
		this.registMonth = registMonth;
	}

	public String getOutputVolume() {
		return outputVolume;
	}

	public void setOutputVolume(String outputVolume) {
		this.outputVolume = outputVolume;
	}

	public String getOutputVolumeU() {
		return outputVolumeU;
	}

	public void setOutputVolumeU(String outputVolumeU) {
		this.outputVolumeU = outputVolumeU;
	}

	public String getGearType() {
		return gearType;
	}

	public void setGearType(String gearType) {
		this.gearType = gearType;
	}

	public String getCarColor() {
		return carColor;
	}

	public void setCarColor(String carColor) {
		this.carColor = carColor;
	}

	public String getUpholsteryColor() {
		return upholsteryColor;
	}

	public void setUpholsteryColor(String upholsteryColor) {
		this.upholsteryColor = upholsteryColor;
	}

	public String getVehicleType() {
		return vehicleType;
	}

	public void setVehicleType(String vehicleType) {
		this.vehicleType = vehicleType;
	}

	public String getUsedType() {
		return usedType;
	}

	public void setUsedType(String usedType) {
		this.usedType = usedType;
	}

	public String getEngineNumber() {
		return engineNumber;
	}

	public void setEngineNumber(String engineNumber) {
		this.engineNumber = engineNumber;
	}

	public String getImportTag() {
		return importTag;
	}

	public void setImportTag(String importTag) {
		this.importTag = importTag;
	}

	public String getOilType() {
		return oilType;
	}

	public void setOilType(String oilType) {
		this.oilType = oilType;
	}

	public Date getFactoryDate() {
		return factoryDate;
	}

	public void setFactoryDate(Date factoryDate) {
		this.factoryDate = factoryDate;
	}

	public String getNewcarPrice() {
		return newcarPrice;
	}

	public void setNewcarPrice(String newcarPrice) {
		this.newcarPrice = newcarPrice;
	}

	public String getIssurValidDate() {
		return issurValidDate;
	}

	public void setIssurValidDate(String issurValidDate) {
		this.issurValidDate = issurValidDate;
	}

	public String getCommIssurValidDate() {
		return commIssurValidDate;
	}

	public void setCommIssurValidDate(String commIssurValidDate) {
		this.commIssurValidDate = commIssurValidDate;
	}

	public String getCheckValidMonth() {
		return checkValidMonth;
	}

	public void setCheckValidMonth(String checkValidMonth) {
		this.checkValidMonth = checkValidMonth;
	}

	public String getEnvLevel() {
		return envLevel;
	}

	public void setEnvLevel(String envLevel) {
		this.envLevel = envLevel;
	}

	public String getCondDesc() {
		return condDesc;
	}

	public void setCondDesc(String condDesc) {
		this.condDesc = condDesc;
	}

	public String getMileageCount() {
		return mileageCount;
	}

	public void setMileageCount(String mileageCount) {
		this.mileageCount = mileageCount;
	}

	public String getAllowedPassengersCount() {
		return allowedPassengersCount;
	}

	public void setAllowedPassengersCount(String allowedPassengersCount) {
		this.allowedPassengersCount = allowedPassengersCount;
	}
	
	
	
}