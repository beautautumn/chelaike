package com.ct.erp.lib.entity;

import java.util.HashSet;
import java.util.Set;

/**
 * AgencyOrder entity. @author MyEclipse Persistence Tools
 */

public class AgencyOrder implements java.io.Serializable {

	// Fields

	private Long id;
	private String showName;
	private Integer showOrder;
	private Set agencies = new HashSet(0);

	// Constructors

	/** default constructor */
	public AgencyOrder() {
	}

	/** full constructor */
	public AgencyOrder(String showName, Integer showOrder, Set agencies) {
		this.showName = showName;
		this.showOrder = showOrder;
		this.agencies = agencies;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getShowName() {
		return this.showName;
	}

	public void setShowName(String showName) {
		this.showName = showName;
	}

	public Integer getShowOrder() {
		return this.showOrder;
	}

	public void setShowOrder(Integer showOrder) {
		this.showOrder = showOrder;
	}

	public Set getAgencies() {
		return this.agencies;
	}

	public void setAgencies(Set agencies) {
		this.agencies = agencies;
	}

}