package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Log;

import java.sql.Timestamp;

/**
 * TempLog entity. @author MyEclipse Persistence Tools
 */

public class TempLog implements java.io.Serializable {

	// Fields

	private Long id;
	private Log log;
	private String entity;
	private String operObjMes;
	private Timestamp createTime;

	// Constructors

	/** default constructor */
	public TempLog() {
	}

	/** full constructor */
	public TempLog(Log log, String entity, String operObjMes,
                   Timestamp createTime) {
		this.log = log;
		this.entity = entity;
		this.operObjMes = operObjMes;
		this.createTime = createTime;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Log getLog() {
		return this.log;
	}

	public void setLog(Log log) {
		this.log = log;
	}

	public String getEntity() {
		return this.entity;
	}

	public void setEntity(String entity) {
		this.entity = entity;
	}

	public String getOperObjMes() {
		return this.operObjMes;
	}

	public void setOperObjMes(String operObjMes) {
		this.operObjMes = operObjMes;
	}

	public Timestamp getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

}