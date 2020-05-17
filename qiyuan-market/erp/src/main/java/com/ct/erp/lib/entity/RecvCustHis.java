package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Financing;
import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;

/**
 * RecvCustHis entity. @author MyEclipse Persistence Tools
 */

public class RecvCustHis implements java.io.Serializable {

	// Fields

	private Long id;
	private Financing financing;
	private Staff staff;
	private Integer recvFee;
	private Timestamp recvDate;
	private String recvDesc;

	// Constructors

	/** default constructor */
	public RecvCustHis() {
	}

	/** full constructor */
	public RecvCustHis(Financing financing, Staff staff, Integer recvFee,
                       Timestamp recvDate, String recvDesc) {
		this.financing = financing;
		this.staff = staff;
		this.recvFee = recvFee;
		this.recvDate = recvDate;
		this.recvDesc = recvDesc;
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

	public Integer getRecvFee() {
		return this.recvFee;
	}

	public void setRecvFee(Integer recvFee) {
		this.recvFee = recvFee;
	}

	public Timestamp getRecvDate() {
		return this.recvDate;
	}

	public void setRecvDate(Timestamp recvDate) {
		this.recvDate = recvDate;
	}

	public String getRecvDesc() {
		return this.recvDesc;
	}

	public void setRecvDesc(String recvDesc) {
		this.recvDesc = recvDesc;
	}

}