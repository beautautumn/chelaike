package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;

/**
 * VehiclePic entity. @author MyEclipse Persistence Tools
 */

public class VehiclePic implements java.io.Serializable {

	// Fields

	private Long id;
	private Vehicle vehicle;
	private Trade trade;
	private String smallPicUrl;
	private String picUrl;
	private Integer showOrder;
	private String status;
	private String publishTag;
	private String isFront;
	private String source;

	// Constructors

	/** default constructor */
	public VehiclePic() {
	}

	/** full constructor */
	public VehiclePic(Vehicle vehicle, Trade trade, String smallPicUrl,
                      String picUrl, Integer showOrder, String status, String publishTag,
                      String isFront, String source) {
		this.vehicle = vehicle;
		this.trade = trade;
		this.smallPicUrl = smallPicUrl;
		this.picUrl = picUrl;
		this.showOrder = showOrder;
		this.status = status;
		this.publishTag = publishTag;
		this.isFront = isFront;
		this.source = source;
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

	public Trade getTrade() {
		return this.trade;
	}

	public void setTrade(Trade trade) {
		this.trade = trade;
	}

	public String getSmallPicUrl() {
		return this.smallPicUrl;
	}

	public void setSmallPicUrl(String smallPicUrl) {
		this.smallPicUrl = smallPicUrl;
	}

	public String getPicUrl() {
		return this.picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}

	public Integer getShowOrder() {
		return this.showOrder;
	}

	public void setShowOrder(Integer showOrder) {
		this.showOrder = showOrder;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPublishTag() {
		return this.publishTag;
	}

	public void setPublishTag(String publishTag) {
		this.publishTag = publishTag;
	}

	public String getIsFront() {
		return this.isFront;
	}

	public void setIsFront(String isFront) {
		this.isFront = isFront;
	}

	public String getSource() {
		return this.source;
	}

	public void setSource(String source) {
		this.source = source;
	}

}