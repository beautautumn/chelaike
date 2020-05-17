package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Series;

import java.util.HashSet;
import java.util.Set;

/**
 * Kind entity. @author MyEclipse Persistence Tools
 */

public class Kind implements java.io.Serializable {

	// Fields

	private Long id;
	private Series series;
	private String name;
	private String validTag;
	private Integer showOrder;
	private Set vehicles = new HashSet(0);

	// Constructors

	/** default constructor */
	public Kind() {
	}

	/** full constructor */
	public Kind(Series series, String name, String validTag, Integer showOrder,
                Set vehicles) {
		this.series = series;
		this.name = name;
		this.validTag = validTag;
		this.showOrder = showOrder;
		this.vehicles = vehicles;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Series getSeries() {
		return this.series;
	}

	public void setSeries(Series series) {
		this.series = series;
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

	public Set getVehicles() {
		return this.vehicles;
	}

	public void setVehicles(Set vehicles) {
		this.vehicles = vehicles;
	}

}