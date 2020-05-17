package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Customer;
import com.ct.erp.lib.entity.Financing;
import com.ct.erp.lib.entity.Vehicle;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Trade entity. @author MyEclipse Persistence Tools
 */

public class Trade implements java.io.Serializable {

	// Fields

	private Long id;
	private Vehicle vehicle;
	private Customer customerBySellCustId;
	private Agency agency;
	private Financing financing;
	private Customer customerByBuyCustId;
	private Long outerId;
	private String barCode;
	private String oldLicenseCode;
	private String newLicenseCode;
	private Long acquPrice;
	private Long showPrice;
	private Long salePrice;
	private String drivingLicenseUrl;
	private String financingTag;
	private String certifyTag;
	private String firstTransferTag;
	private String saleTransferTag;
	private Date comeDate;
	private Date goDate;
	private Date acquTransferDate;
	private Date saleTransferDate;
	private String state;
	private Timestamp createTime;
	private Timestamp updateTime;
	private String approveTag;
	private Long approveId;
	private Long checkId;
	private String consignTag;
	private Long valuationFee;
	private String clkId;
	private Integer carId;
	private Date acquDate;
	private String transferCount;
	private String befOutState;
	private String detectTag;
	private Set checkOuts = new HashSet(0);
	private Set vehiclePics = new HashSet(0);
//	private Set publishInfos = new HashSet(0);
	private Set vehicleSyncs = new HashSet(0);
//	private Set approves = new HashSet(0);

	// Constructors

	/** default constructor */
	public Trade() {
	}

	/** full constructor */
	public Trade(Long id, Vehicle vehicle, Customer customerBySellCustId, Agency agency, Financing financing,
                 Customer customerByBuyCustId, Long outerId, String barCode, String oldLicenseCode, String newLicenseCode,
                 Long acquPrice, Long showPrice, Long salePrice, String drivingLicenseUrl, String financingTag,
                 String certifyTag, String firstTransferTag, String saleTransferTag, Date comeDate, Date goDate,
                 Date acquTransferDate, Date saleTransferDate, String state, Timestamp createTime, Timestamp updateTime,
                 String approveTag, Long approveId, Long checkId, String consignTag, Long valuationFee, String clkId,
                 Integer carId, Date acquDate, String transferCount, String befOutState, String detectTag, Set checkOuts,
                 Set vehiclePics, Set publishInfos, Set vehicleSyncs, Set approves) {
		super();
		this.id = id;
		this.vehicle = vehicle;
		this.customerBySellCustId = customerBySellCustId;
		this.agency = agency;
		this.financing = financing;
		this.customerByBuyCustId = customerByBuyCustId;
		this.outerId = outerId;
		this.barCode = barCode;
		this.oldLicenseCode = oldLicenseCode;
		this.newLicenseCode = newLicenseCode;
		this.acquPrice = acquPrice;
		this.showPrice = showPrice;
		this.salePrice = salePrice;
		this.drivingLicenseUrl = drivingLicenseUrl;
		this.financingTag = financingTag;
		this.certifyTag = certifyTag;
		this.firstTransferTag = firstTransferTag;
		this.saleTransferTag = saleTransferTag;
		this.comeDate = comeDate;
		this.goDate = goDate;
		this.acquTransferDate = acquTransferDate;
		this.saleTransferDate = saleTransferDate;
		this.state = state;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.approveTag = approveTag;
		this.approveId = approveId;
		this.checkId = checkId;
		this.consignTag = consignTag;
		this.valuationFee = valuationFee;
		this.clkId = clkId;
		this.carId = carId;
		this.acquDate = acquDate;
		this.transferCount = transferCount;
		this.befOutState = befOutState;
		this.detectTag = detectTag;
		this.checkOuts = checkOuts;
		this.vehiclePics = vehiclePics;
//		this.publishInfos = publishInfos;
		this.vehicleSyncs = vehicleSyncs;
//		this.approves = approves;
	}

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

	public Customer getCustomerBySellCustId() {
		return this.customerBySellCustId;
	}

	public void setCustomerBySellCustId(Customer customerBySellCustId) {
		this.customerBySellCustId = customerBySellCustId;
	}

	public Agency getAgency() {
		return this.agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public Financing getFinancing() {
		return this.financing;
	}

	public void setFinancing(Financing financing) {
		this.financing = financing;
	}

	public Customer getCustomerByBuyCustId() {
		return this.customerByBuyCustId;
	}

	public void setCustomerByBuyCustId(Customer customerByBuyCustId) {
		this.customerByBuyCustId = customerByBuyCustId;
	}

	public Long getOuterId() {
		return this.outerId;
	}

	public void setOuterId(Long outerId) {
		this.outerId = outerId;
	}

	public String getBarCode() {
		return this.barCode;
	}

	public void setBarCode(String barCode) {
		this.barCode = barCode;
	}

	public String getOldLicenseCode() {
		return this.oldLicenseCode;
	}

	public void setOldLicenseCode(String oldLicenseCode) {
		this.oldLicenseCode = oldLicenseCode;
	}

	public String getNewLicenseCode() {
		return this.newLicenseCode;
	}

	public void setNewLicenseCode(String newLicenseCode) {
		this.newLicenseCode = newLicenseCode;
	}

	public Long getAcquPrice() {
		return this.acquPrice;
	}

	public void setAcquPrice(Long acquPrice) {
		this.acquPrice = acquPrice;
	}

	public Long getShowPrice() {
		return this.showPrice;
	}

	public void setShowPrice(Long showPrice) {
		this.showPrice = showPrice;
	}

	public Long getSalePrice() {
		return this.salePrice;
	}

	public void setSalePrice(Long salePrice) {
		this.salePrice = salePrice;
	}

	public String getDrivingLicenseUrl() {
		return this.drivingLicenseUrl;
	}

	public void setDrivingLicenseUrl(String drivingLicenseUrl) {
		this.drivingLicenseUrl = drivingLicenseUrl;
	}

	public String getFinancingTag() {
		return this.financingTag;
	}

	public void setFinancingTag(String financingTag) {
		this.financingTag = financingTag;
	}

	public String getCertifyTag() {
		return this.certifyTag;
	}

	public void setCertifyTag(String certifyTag) {
		this.certifyTag = certifyTag;
	}

	public String getFirstTransferTag() {
		return this.firstTransferTag;
	}

	public void setFirstTransferTag(String firstTransferTag) {
		this.firstTransferTag = firstTransferTag;
	}

	public String getSaleTransferTag() {
		return this.saleTransferTag;
	}

	public void setSaleTransferTag(String saleTransferTag) {
		this.saleTransferTag = saleTransferTag;
	}

	public Date getComeDate() {
		return this.comeDate;
	}

	public void setComeDate(Date comeDate) {
		this.comeDate = comeDate;
	}

	public Date getGoDate() {
		return this.goDate;
	}

	public void setGoDate(Date goDate) {
		this.goDate = goDate;
	}

	public Date getAcquTransferDate() {
		return this.acquTransferDate;
	}

	public void setAcquTransferDate(Date acquTransferDate) {
		this.acquTransferDate = acquTransferDate;
	}

	public Date getSaleTransferDate() {
		return this.saleTransferDate;
	}

	public void setSaleTransferDate(Date saleTransferDate) {
		this.saleTransferDate = saleTransferDate;
	}

	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
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

	public String getApproveTag() {
		return this.approveTag;
	}

	public void setApproveTag(String approveTag) {
		this.approveTag = approveTag;
	}

	public Long getApproveId() {
		return this.approveId;
	}

	public void setApproveId(Long approveId) {
		this.approveId = approveId;
	}

	public Long getCheckId() {
		return this.checkId;
	}

	public void setCheckId(Long checkId) {
		this.checkId = checkId;
	}

	public String getConsignTag() {
		return this.consignTag;
	}

	public void setConsignTag(String consignTag) {
		this.consignTag = consignTag;
	}

	public Long getValuationFee() {
		return this.valuationFee;
	}

	public void setValuationFee(Long valuationFee) {
		this.valuationFee = valuationFee;
	}

	public String getClkId() {
		return this.clkId;
	}

	public void setClkId(String clkId) {
		this.clkId = clkId;
	}

	public Integer getCarId() {
		return this.carId;
	}

	public void setCarId(Integer carId) {
		this.carId = carId;
	}

	public Date getAcquDate() {
		return this.acquDate;
	}

	public void setAcquDate(Date acquDate) {
		this.acquDate = acquDate;
	}

	public String getTransferCount() {
		return this.transferCount;
	}

	public void setTransferCount(String transferCount) {
		this.transferCount = transferCount;
	}

	public String getBefOutState() {
		return this.befOutState;
	}

	public void setBefOutState(String befOutState) {
		this.befOutState = befOutState;
	}

	public Set getCheckOuts() {
		return this.checkOuts;
	}

	public void setCheckOuts(Set checkOuts) {
		this.checkOuts = checkOuts;
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

	public Set getVehicleSyncs() {
		return this.vehicleSyncs;
	}

	public void setVehicleSyncs(Set vehicleSyncs) {
		this.vehicleSyncs = vehicleSyncs;
	}

//	public Set getApproves() {
//		return this.approves;
//	}

//	public void setApproves(Set approves) {
//		this.approves = approves;
//	}

	public String getDetectTag() {
		return detectTag;
	}

	public void setDetectTag(String detectTag) {
		this.detectTag = detectTag;
	}
	
	

}