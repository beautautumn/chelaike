package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Financing;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;

/**
 * RefundAgencyHis entity. @author MyEclipse Persistence Tools
 */

public class RefundAgencyHis implements java.io.Serializable {

	// Fields

	private Long id;
	private Financing financing;
	private Staff staff;
	private Integer refundFee;
	private Timestamp refundDate;
	private String refundDesc;

	// Constructors

	/** default constructor */
	public RefundAgencyHis() {
	}

	/** full constructor */
	public RefundAgencyHis(Financing financing, Staff staff, Integer refundFee,
                           Timestamp refundDate, String refundDesc) {
		this.financing = financing;
		this.staff = staff;
		this.refundFee = refundFee;
		this.refundDate = refundDate;
		this.refundDesc = refundDesc;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Financing getFinancing() {
		return this.financing;
	}

	public void setFinancing(Financing financing) {
		this.financing = financing;
	}

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public Integer getRefundFee() {
		return this.refundFee;
	}

	public void setRefundFee(Integer refundFee) {
		this.refundFee = refundFee;
	}

	public Timestamp getRefundDate() {
		return this.refundDate;
	}

	public void setRefundDate(Timestamp refundDate) {
		this.refundDate = refundDate;
	}

	public String getRefundDesc() {
		return this.refundDesc;
	}

	public void setRefundDesc(String refundDesc) {
		this.refundDesc = refundDesc;
	}

}