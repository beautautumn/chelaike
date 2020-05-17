package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;

/**
 * CarOperHis entity. @author MyEclipse Persistence Tools
 */

public class CarOperHis implements java.io.Serializable {

	// Fields

	private Long id;
	private Staff staff;
	private Agency agency;
	private Timestamp operTime;
	private String operTag;
	private Integer beforCount;
	private Integer afterCount;
	private String operDesc;

	// Constructors

	/** default constructor */
	public CarOperHis() {
	}

	/** full constructor */
	public CarOperHis(Staff staff, Agency agency, Timestamp operTime,
                      String operTag, Integer beforCount, Integer afterCount,
                      String operDesc) {
		this.staff = staff;
		this.agency = agency;
		this.operTime = operTime;
		this.operTag = operTag;
		this.beforCount = beforCount;
		this.afterCount = afterCount;
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

	public Agency getAgency() {
		return this.agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public Timestamp getOperTime() {
		return this.operTime;
	}

	public void setOperTime(Timestamp operTime) {
		this.operTime = operTime;
	}

	public String getOperTag() {
		return this.operTag;
	}

	public void setOperTag(String operTag) {
		this.operTag = operTag;
	}

	public Integer getBeforCount() {
		return this.beforCount;
	}

	public void setBeforCount(Integer beforCount) {
		this.beforCount = beforCount;
	}

	public Integer getAfterCount() {
		return this.afterCount;
	}

	public void setAfterCount(Integer afterCount) {
		this.afterCount = afterCount;
	}

	public String getOperDesc() {
		return this.operDesc;
	}

	public void setOperDesc(String operDesc) {
		this.operDesc = operDesc;
	}

}