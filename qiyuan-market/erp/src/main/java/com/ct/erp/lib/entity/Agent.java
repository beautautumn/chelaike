package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;

import java.sql.Timestamp;

/**
 * Agent entity. @author MyEclipse Persistence Tools
 */

public class Agent implements java.io.Serializable {

	// Fields

	private Long id;
	private Agency agency;
	private String name;
	private String idCard;
	private String status;
	private Timestamp createTime;
	private Timestamp updateTime;

	// Constructors

	/** default constructor */
	public Agent() {
	}

	/** minimal constructor */
	public Agent(Agency agency, String name, String idCard, String status) {
		this.agency = agency;
		this.name = name;
		this.idCard = idCard;
		this.status = status;
	}

	/** full constructor */
	public Agent(Agency agency, String name, String idCard, String status,
                 Timestamp createTime, Timestamp updateTime) {
		this.agency = agency;
		this.name = name;
		this.idCard = idCard;
		this.status = status;
		this.createTime = createTime;
		this.updateTime = updateTime;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Agency getAgency() {
		return this.agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getIdCard() {
		return this.idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
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

}