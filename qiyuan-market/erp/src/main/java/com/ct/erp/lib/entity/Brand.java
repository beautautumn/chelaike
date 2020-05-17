package com.ct.erp.lib.entity;

import java.util.HashSet;
import java.util.Set;

/**
 * Brand entity. @author MyEclipse Persistence Tools
 */

public class Brand implements java.io.Serializable {

	// Fields

	private Long id;
	private String name;
	private String pinyin;
	private Integer showOrder;
	private String firstLetter;
	private String validTag;
	private Set serieses = new HashSet(0);
	private Set vehicles = new HashSet(0);

	// Constructors

	/** default constructor */
	public Brand() {
	}

	/** full constructor */
	public Brand(String name, String pinyin, Integer showOrder,
			String firstLetter, String validTag, Set serieses, Set vehicles) {
		this.name = name;
		this.pinyin = pinyin;
		this.showOrder = showOrder;
		this.firstLetter = firstLetter;
		this.validTag = validTag;
		this.serieses = serieses;
		this.vehicles = vehicles;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPinyin() {
		return this.pinyin;
	}

	public void setPinyin(String pinyin) {
		this.pinyin = pinyin;
	}

	public Integer getShowOrder() {
		return this.showOrder;
	}

	public void setShowOrder(Integer showOrder) {
		this.showOrder = showOrder;
	}

	public String getFirstLetter() {
		return this.firstLetter;
	}

	public void setFirstLetter(String firstLetter) {
		this.firstLetter = firstLetter;
	}

	public String getValidTag() {
		return this.validTag;
	}

	public void setValidTag(String validTag) {
		this.validTag = validTag;
	}

	public Set getSerieses() {
		return this.serieses;
	}

	public void setSerieses(Set serieses) {
		this.serieses = serieses;
	}

	public Set getVehicles() {
		return this.vehicles;
	}

	public void setVehicles(Set vehicles) {
		this.vehicles = vehicles;
	}

}