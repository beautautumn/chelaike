package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Brand;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Series entity. @author MyEclipse Persistence Tools
 */

public class Series implements java.io.Serializable {

	// Fields

	private Long id;
	private Brand brand;
	private String name;
	private String validTag;
	private Integer showOrder;
	private String vehicleType;
	private String vehicleAttribute;
	private Date createTime;
	private Set kinds = new HashSet(0);
	private Set vehicles = new HashSet(0);

	// Constructors

	/** default constructor */
	public Series() {
	}

	/** full constructor */
	public Series(Brand brand, String name, String validTag, Integer showOrder,
                  String vehicleType, String vehicleAttribute, Date createTime,
                  Set kinds, Set vehicles) {
		this.brand = brand;
		this.name = name;
		this.validTag = validTag;
		this.showOrder = showOrder;
		this.vehicleType = vehicleType;
		this.vehicleAttribute = vehicleAttribute;
		this.createTime = createTime;
		this.kinds = kinds;
		this.vehicles = vehicles;
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

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValidTag() {
		return this.validTag;
	}

	public void setValidTag(String validTag) {
		this.validTag = validTag;
	}

	public Integer getShowOrder() {
		return this.showOrder;
	}

	public void setShowOrder(Integer showOrder) {
		this.showOrder = showOrder;
	}

	public String getVehicleType() {
		return this.vehicleType;
	}

	public void setVehicleType(String vehicleType) {
		this.vehicleType = vehicleType;
	}

	public String getVehicleAttribute() {
		return this.vehicleAttribute;
	}

	public void setVehicleAttribute(String vehicleAttribute) {
		this.vehicleAttribute = vehicleAttribute;
	}

	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Set getKinds() {
		return this.kinds;
	}

	public void setKinds(Set kinds) {
		this.kinds = kinds;
	}

	public Set getVehicles() {
		return this.vehicles;
	}

	public void setVehicles(Set vehicles) {
		this.vehicles = vehicles;
	}

}