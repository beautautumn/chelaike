package com.ct.erp.aop.model;

import java.sql.Timestamp;

/**
 * @author shiqingwen
 */

public class AgencyJson {

	// Fields

	private Long id;
	private String agencyName;
	private String userName;
	private String userPhone;
	private String account;
	private String pwd;
	private String state;
	private Timestamp leaveDate;
	private String leaveDesc;
	private String leaveType;
	
	public AgencyJson(com.ct.erp.lib.entity.Agency agency){
		if(agency != null){
			this.id = agency.getId();
			this.agencyName = agency.getAgencyName();
			this.userName = agency.getUserName();
			this.userPhone = agency.getUserPhone();
			this.account = agency.getAccount();
			this.pwd = agency.getPwd();
			this.state = agency.getState();
			this.leaveDate = agency.getLeaveDate();
			this.leaveDesc = agency.getLeaveDesc();
			this.leaveType = agency.getLeaveType();
		}
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPhone() {
		return userPhone;
	}

	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Timestamp getLeaveDate() {
		return leaveDate;
	}

	public void setLeaveDate(Timestamp leaveDate) {
		this.leaveDate = leaveDate;
	}

	public String getLeaveDesc() {
		return leaveDesc;
	}

	public void setLeaveDesc(String leaveDesc) {
		this.leaveDesc = leaveDesc;
	}

	public String getLeaveType() {
		return leaveType;
	}

	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}

}