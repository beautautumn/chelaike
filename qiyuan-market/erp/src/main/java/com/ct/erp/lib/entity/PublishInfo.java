package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;

import java.sql.Timestamp;

/**
 * PublishInfo entity. @author MyEclipse Persistence Tools
 */

public class PublishInfo implements java.io.Serializable {

	// Fields

	private Long id;
	private Vehicle vehicle;
	private Agency agency;
	private Trade trade;
	private String state;
	private Timestamp publishTime;
	private Timestamp downTime;
	private Timestamp createTime;
	private Timestamp updateTime;
	private String certifyTag;

	// Constructors

	/** default constructor */
	public PublishInfo() {
	}

	/** full constructor */
	public PublishInfo(Vehicle vehicle, Agency agency, Trade trade,
                       String state, Timestamp publishTime, Timestamp downTime,
                       Timestamp createTime, Timestamp updateTime, String certifyTag) {
		this.vehicle = vehicle;
		this.agency = agency;
		this.trade = trade;
		this.state = state;
		this.publishTime = publishTime;
		this.downTime = downTime;
		this.createTime = createTime;
		this.updateTime = updateTime;
		this.certifyTag = certifyTag;
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

	public Agency getAgency() {
		return this.agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public Trade getTrade() {
		return this.trade;
	}

	public void setTrade(Trade trade) {
		this.trade = trade;
	}

	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Timestamp getPublishTime() {
		return this.publishTime;
	}

	public void setPublishTime(Timestamp publishTime) {
		this.publishTime = publishTime;
	}

	public Timestamp getDownTime() {
		return this.downTime;
	}

	public void setDownTime(Timestamp downTime) {
		this.downTime = downTime;
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

	public String getCertifyTag() {
		return this.certifyTag;
	}

	public void setCertifyTag(String certifyTag) {
		this.certifyTag = certifyTag;
	}

}