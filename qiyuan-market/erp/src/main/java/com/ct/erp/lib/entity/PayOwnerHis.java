package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Financing;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;

/**
 * PayOwnerHis entity. @author MyEclipse Persistence Tools
 */

public class PayOwnerHis implements java.io.Serializable {

	// Fields

	private Long id;
	private Staff staff;
	private Financing financing;
	private Integer payFee;
	private Timestamp payDate;
	private String payDesc;

	// Constructors

	/** default constructor */
	public PayOwnerHis() {
	}

	/** full constructor */
	public PayOwnerHis(Staff staff, Financing financing, Integer payFee,
                       Timestamp payDate, String payDesc) {
		this.staff = staff;
		this.financing = financing;
		this.payFee = payFee;
		this.payDate = payDate;
		this.payDesc = payDesc;
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

	public Financing getFinancing() {
		return this.financing;
	}

	public void setFinancing(Financing financing) {
		this.financing = financing;
	}

	public Integer getPayFee() {
		return this.payFee;
	}

	public void setPayFee(Integer payFee) {
		this.payFee = payFee;
	}

	public Timestamp getPayDate() {
		return this.payDate;
	}

	public void setPayDate(Timestamp payDate) {
		this.payDate = payDate;
	}

	public String getPayDesc() {
		return this.payDesc;
	}

	public void setPayDesc(String payDesc) {
		this.payDesc = payDesc;
	}

}