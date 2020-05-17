package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;

/**
 * OperHis entity. @author MyEclipse Persistence Tools
 */

public class OperHis implements java.io.Serializable {

	// Fields

	private Long id;
	private Staff staff;
	private String operTag;
	private Long operObj;
	private Timestamp operTime;
	private String operDesc;

	// Constructors

	/** default constructor */
	public OperHis() {
	}

	/** minimal constructor */
	public OperHis(Timestamp operTime) {
		this.operTime = operTime;
	}

	/** full constructor */
	public OperHis(Staff staff, String operTag, Long operObj,
                   Timestamp operTime, String operDesc) {
		this.staff = staff;
		this.operTag = operTag;
		this.operObj = operObj;
		this.operTime = operTime;
		this.operDesc = operDesc;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public String getOperTag() {
		return this.operTag;
	}

	public void setOperTag(String operTag) {
		this.operTag = operTag;
	}

	public Long getOperObj() {
		return this.operObj;
	}

	public void setOperObj(Long operObj) {
		this.operObj = operObj;
	}

	public Timestamp getOperTime() {
		return this.operTime;
	}

	public void setOperTime(Timestamp operTime) {
		this.operTime = operTime;
	}

	public String getOperDesc() {
		return this.operDesc;
	}

	public void setOperDesc(String operDesc) {
		this.operDesc = operDesc;
	}

}