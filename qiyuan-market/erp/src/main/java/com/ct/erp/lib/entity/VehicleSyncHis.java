package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.VehicleSync;

import java.sql.Timestamp;

/**
 * VehicleSyncHis entity. @author MyEclipse Persistence Tools
 */

public class VehicleSyncHis implements java.io.Serializable {

	// Fields

	private Long id;
	private VehicleSync vehicleSync;
	private String state;
	private Timestamp createTime;

	// Constructors

	/** default constructor */
	public VehicleSyncHis() {
	}

	/** full constructor */
	public VehicleSyncHis(VehicleSync vehicleSync, String state,
                          Timestamp createTime) {
		this.vehicleSync = vehicleSync;
		this.state = state;
		this.createTime = createTime;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public VehicleSync getVehicleSync() {
		return this.vehicleSync;
	}

	public void setVehicleSync(VehicleSync vehicleSync) {
		this.vehicleSync = vehicleSync;
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

}