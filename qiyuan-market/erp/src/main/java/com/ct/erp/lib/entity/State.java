package com.ct.erp.lib.entity;

/**
 * State entity. @author MyEclipse Persistence Tools
 */

public class State implements java.io.Serializable {

	// Fields

	private Long id;
	private String stateType;
	private String stateCode;
	private String stateName;

	// Constructors

	/** default constructor */
	public State() {
	}

	/** full constructor */
	public State(String stateType, String stateCode, String stateName) {
		this.stateType = stateType;
		this.stateCode = stateCode;
		this.stateName = stateName;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getStateType() {
		return this.stateType;
	}

	public void setStateType(String stateType) {
		this.stateType = stateType;
	}

	public String getStateCode() {
		return this.stateCode;
	}

	public void setStateCode(String stateCode) {
		this.stateCode = stateCode;
	}

	public String getStateName() {
		return this.stateName;
	}

	public void setStateName(String stateName) {
		this.stateName = stateName;
	}

}