package com.ct.erp.rent.model;


import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.ct.erp.lib.entity.RecvFee;
import com.ct.erp.util.UcmsWebUtils;

public class RecvFeeBean {
	private RecvFee recvFeeb = new RecvFee();
	private Long staffId;
	private String asOfDate;
	private String recvFee;
	private String recvDepositFee;
	private String recvDate;
	private String remark;
	private Long cycleId;
	public RecvFee getRecvFeeb() throws Exception {
		SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd");
		if(this.asOfDate!=null&&this.asOfDate.length()>0){
			this.recvFeeb.setAsOfDate(new Timestamp(fm.parse(this.asOfDate).getTime()));
		}
		if(this.recvDate!=null&&this.recvDate.length()>0){
			this.recvFeeb.setRecvDate(new Timestamp(fm.parse(this.recvDate).getTime()));
		}else{
			this.recvFeeb.setRecvDate(new Timestamp(new Date().getTime()));
		}
		this.recvFeeb.setRecvFee(UcmsWebUtils.yuanTofen(this.recvFee));
		if(recvDepositFee!=null&&recvDepositFee.length()>0){
			this.recvFeeb.setRecvDepositFee(UcmsWebUtils.yuanTofen(recvDepositFee));
		}
		this.recvFeeb.setRemark(this.remark);
		return recvFeeb;
	}
	public void setRecvFeeb(RecvFee recvFeeb) {
		this.recvFeeb = recvFeeb;
	}
	public Long getStaffId() {
		return staffId;
	}
	public void setStaffId(Long staffId) {
		this.staffId = staffId;
	}
	public String getAsOfDate() {
		return asOfDate;
	}
	public void setAsOfDate(String asOfDate) {
		this.asOfDate = asOfDate;
	}
	public String getRecvFee() {
		return recvFee;
	}
	public void setRecvFee(String recvFee) {
		this.recvFee = recvFee;
	}
	public String getRecvDepositFee() {
		return recvDepositFee;
	}
	public void setRecvDepositFee(String recvDepositFee) {
		this.recvDepositFee = recvDepositFee;
	}
	public String getRecvDate() {
		return recvDate;
	}
	public void setRecvDate(String recvDate) {
		this.recvDate = recvDate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public Long getCycleId() {
		return cycleId;
	}
	public void setCycleId(Long cycleId) {
		this.cycleId = cycleId;
	}
	
}
