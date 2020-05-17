package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Brand;
import com.ct.erp.lib.entity.Kind;
import com.ct.erp.lib.entity.Series;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Vehicle entity. @author MyEclipse Persistence Tools
 */

public class Vehicle implements java.io.Serializable {

	// Fields

	private Long id;
	private Brand brand;
	private Series series;
	private Kind kind;
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
	private Timestamp createTime;
	private Timestamp updateTime;
	private String allowedPassengersCount;
	private Set trades = new HashSet(0);
	private Set vehiclePics = new HashSet(0);
//	private Set publishInfos = new HashSet(0);
	private Set vehicleEquips = new HashSet(0);
	private Set persionalAuctions = new HashSet(0);

	// Constructors

	/** default constructor */
	public Vehicle() {
	}

	/** full constructor */
	public Vehicle(Brand brand, Series series, Kind kind, String brandName,
                   String seriesName, String kindName, String shelfCode,
                   String licenseCode, String registMonth, String outputVolume,
                   String outputVolumeU, String gearType, String carColor,
                   String upholsteryColor, String vehicleType, String usedType,
                   String engineNumber, String importTag, String oilType,
                   Date factoryDate, String newcarPrice, String issurValidDate,
                   String commIssurValidDate, String checkValidMonth, String envLevel,
                   String condDesc, String mileageCount, Timestamp createTime,
                   Timestamp updateTime, String allowedPassengersCount, Set trades,
                   Set vehiclePics, Set publishInfos, Set vehicleEquips,
                   Set persionalAuctions) {
		this.brand = brand;
		this.series = series;
		this.kind = kind;
		this.brandName = brandName;
		this.seriesName = seriesName;
		this.kindName = kindName;
		this.shelfCode = shelfCode;
		this.licenseCode = licenseCode;
		this.registMonth = registMonth;
		this.outputVolume = outputVolume;
		this.outputVolumeU = outputVolumeU;
		this.gearType = gearType;
		this.carColor = carColor;
		this.upholsteryColor = upholsteryColor;
		this.vehicleType = vehicleType;
		this.usedType = usedType;
		this.engineNumber = engineNumber;
		this.importTag = importTag;
		this.oilType = oilType;
		this.factoryDate = factoryDate;
		this.newcarPrice = newcarPrice;
		this.issurValidDate = issurValidDate;
		this.commIssurValidDate = commIssurValidDate;
		this.checkValidMonth = checkValidMonth;
		this.envLevel = envLevel;
		this.condDesc = condDesc;
		this.mileageCount = mileageCount;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.allowedPassengersCount = allowedPassengersCount;
		this.trades = trades;
		this.vehiclePics = vehiclePics;
//		this.publishInfos = publishInfos;
		this.vehicleEquips = vehicleEquips;
		this.persionalAuctions = persionalAuctions;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Brand getBrand() {
		return this.brand;
	}

	public void setBrand(Brand brand) {
		this.brand = brand;
	}

	public Series getSeries() {
		return this.series;
	}

	public void setSeries(Series series) {
		this.series = series;
	}

	public Kind getKind() {
		return this.kind;
	}

	public void setKind(Kind kind) {
		this.kind = kind;
	}

	public String getBrandName() {
		return this.brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public String getSeriesName() {
		return this.seriesName;
	}

	public void setSeriesName(String seriesName) {
		this.seriesName = seriesName;
	}

	public String getKindName() {
		return this.kindName;
	}

	public void setKindName(String kindName) {
		this.kindName = kindName;
	}

	public String getShelfCode() {
		return this.shelfCode;
	}

	public void setShelfCode(String shelfCode) {
		this.shelfCode = shelfCode;
	}

	public String getLicenseCode() {
		return this.licenseCode;
	}

	public void setLicenseCode(String licenseCode) {
		this.licenseCode = licenseCode;
	}

	public String getRegistMonth() {
		return this.registMonth;
	}

	public void setRegistMonth(String registMonth) {
		this.registMonth = registMonth;
	}

	public String getOutputVolume() {
		return this.outputVolume;
	}

	public void setOutputVolume(String outputVolume) {
		this.outputVolume = outputVolume;
	}

	public String getOutputVolumeU() {
		return this.outputVolumeU;
	}

	public void setOutputVolumeU(String outputVolumeU) {
		this.outputVolumeU = outputVolumeU;
	}

	public String getGearType() {
		return this.gearType;
	}

	public void setGearType(String gearType) {
		this.gearType = gearType;
	}

	public String getCarColor() {
		return this.carColor;
	}

	public void setCarColor(String carColor) {
		this.carColor = carColor;
	}

	public String getUpholsteryColor() {
		return this.upholsteryColor;
	}

	public void setUpholsteryColor(String upholsteryColor) {
		this.upholsteryColor = upholsteryColor;
	}

	public String getVehicleType() {
		return this.vehicleType;
	}

	public void setVehicleType(String vehicleType) {
		this.vehicleType = vehicleType;
	}

	public String getUsedType() {
		return this.usedType;
	}

	public void setUsedType(String usedType) {
		this.usedType = usedType;
	}

	public String getEngineNumber() {
		return this.engineNumber;
	}

	public void setEngineNumber(String engineNumber) {
		this.engineNumber = engineNumber;
	}

	public String getImportTag() {
		return this.importTag;
	}

	public void setImportTag(String importTag) {
		this.importTag = importTag;
	}

	public String getOilType() {
		return this.oilType;
	}

	public void setOilType(String oilType) {
		this.oilType = oilType;
	}

	public Date getFactoryDate() {
		return this.factoryDate;
	}

	public void setFactoryDate(Date factoryDate) {
		this.factoryDate = factoryDate;
	}

	public String getNewcarPrice() {
		return this.newcarPrice;
	}

	public void setNewcarPrice(String newcarPrice) {
		this.newcarPrice = newcarPrice;
	}

	public String getIssurValidDate() {
		return this.issurValidDate;
	}

	public void setIssurValidDate(String issurValidDate) {
		this.issurValidDate = issurValidDate;
	}

	public String getCommIssurValidDate() {
		return this.commIssurValidDate;
	}

	public void setCommIssurValidDate(String commIssurValidDate) {
		this.commIssurValidDate = commIssurValidDate;
	}

	public String getCheckValidMonth() {
		return this.checkValidMonth;
	}

	public void setCheckValidMonth(String checkValidMonth) {
		this.checkValidMonth = checkValidMonth;
	}

	public String getEnvLevel() {
		return this.envLevel;
	}

	public void setEnvLevel(String envLevel) {
		this.envLevel = envLevel;
	}

	public String getCondDesc() {
		return this.condDesc;
	}

	public void setCondDesc(String condDesc) {
		this.condDesc = condDesc;
	}

	public String getMileageCount() {
		return this.mileageCount;
	}

	public void setMileageCount(String mileageCount) {
		this.mileageCount = mileageCount;
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

	public String getAllowedPassengersCount() {
		return this.allowedPassengersCount;
	}

	public void setAllowedPassengersCount(String allowedPassengersCount) {
		this.allowedPassengersCount = allowedPassengersCount;
	}

	public Set getTrades() {
		return this.trades;
	}

	public void setTrades(Set trades) {
		this.trades = trades;
	}

	public Set getVehiclePics() {
		return this.vehiclePics;
	}

	public void setVehiclePics(Set vehiclePics) {
		this.vehiclePics = vehiclePics;
	}

//	public Set getPublishInfos() {
//		return this.publishInfos;
//	}

//	public void setPublishInfos(Set publishInfos) {
//		this.publishInfos = publishInfos;
//	}

	public Set getVehicleEquips() {
		return this.vehicleEquips;
	}

	public void setVehicleEquips(Set vehicleEquips) {
		this.vehicleEquips = vehicleEquips;
	}

	public Set getPersionalAuctions() {
		return this.persionalAuctions;
	}

	public void setPersionalAuctions(Set persionalAuctions) {
		this.persionalAuctions = persionalAuctions;
	}

}