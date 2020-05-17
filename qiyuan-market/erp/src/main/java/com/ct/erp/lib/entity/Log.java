package com.ct.erp.lib.entity;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * Log entity. @author MyEclipse Persistence Tools
 */

public class Log implements java.io.Serializable {

	// Fields

	private Long id;
	private Long userId;
	private String logDescription;
	private Timestamp createTime;
	private String operObjMes;
	private Set tempLogs = new HashSet(0);

	// Constructors

	/** default constructor */
	public Log() {
	}

	/** full constructor */
	public Log(Long userId, String logDescription, Timestamp createTime,
			String operObjMes, Set tempLogs) {
		this.userId = userId;
		this.logDescription = logDescription;
		this.createTime = createTime;
		this.operObjMes = operObjMes;
		this.tempLogs = tempLogs;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getUserId() {
		return this.userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public String getLogDescription() {
		return this.logDescription;
	}

	public void setLogDescription(String logDescription) {
		this.logDescription = logDescription;
	}

	public Timestamp getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

	public String getOperObjMes() {
		return this.operObjMes;
	}

	public void setOperObjMes(String operObjMes) {
		this.operObjMes = operObjMes;
	}

	public Set getTempLogs() {
		return this.tempLogs;
	}

	public void setTempLogs(Set tempLogs) {
		this.tempLogs = tempLogs;
	}

}