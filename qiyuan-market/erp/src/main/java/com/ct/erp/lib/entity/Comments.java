package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;

import java.sql.Timestamp;

/**
 * Comments entity. @author MyEclipse Persistence Tools
 */

public class Comments implements java.io.Serializable {

	// Fields

	private Long id;
	private Agency agency;
	private String comments;
	private Timestamp createTime;

	// Constructors

	/** default constructor */
	public Comments() {
	}

	/** full constructor */
	public Comments(Agency agency, String comments, Timestamp createTime) {
		this.agency = agency;
		this.comments = comments;
		this.createTime = createTime;
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

	public String getComments() {
		return this.comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public Timestamp getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

}