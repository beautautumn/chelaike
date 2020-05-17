package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Sysright;

/**
 * StaffRight entity. @author MyEclipse Persistence Tools
 */

public class StaffRight implements java.io.Serializable {

	// Fields

	private Long id;
	private Sysright sysright;
	private Staff staff;

	// Constructors

	/** default constructor */
	public StaffRight() {
	}

	/** full constructor */
	public StaffRight(Sysright sysright, Staff staff) {
		this.sysright = sysright;
		this.staff = staff;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Sysright getSysright() {
		return this.sysright;
	}

	public void setSysright(Sysright sysright) {
		this.sysright = sysright;
	}

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

}