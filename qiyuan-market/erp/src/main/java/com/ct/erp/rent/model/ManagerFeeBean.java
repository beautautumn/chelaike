package com.ct.erp.rent.model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;

import com.ct.erp.lib.entity.ManagerFee;
import com.ct.erp.rent.service.FeeItemService;
import com.ct.erp.util.UcmsWebUtils;

public class ManagerFeeBean {
	private ManagerFee managerFee = new ManagerFee();
	private String beginDate;
	private String endDate;
	private String totalFee;
	private String operTime;
	private String createTime;
	private String updateTime;
	private Long feeItemId;
	private String remark;
	@Autowired
	private FeeItemService feeItemService;
	
	public ManagerFeeBean(){
		
	}
	public ManagerFeeBean(ManagerFee managerFee){
		SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd");
		this.beginDate = fm.format(managerFee.getBeginDate());
		this.endDate = fm.format(managerFee.getEndDate());
		this.totalFee = UcmsWebUtils.fenToYuan(managerFee.getTotalFee());
		this.feeItemId = managerFee.getFeeItem().getId();
		this.remark = managerFee.getRemark();
		if(managerFee.getOperTime()!=null){
			this.operTime = fm.format(managerFee.getOperTime());
		}else{
			this.operTime = fm.format(new Date());
		}
		this.managerFee = managerFee;
	}
	
	public ManagerFee getManagerFee() throws Exception {
			SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd");
			if(beginDate!=null&&beginDate.length()>0){
				this.managerFee.setBeginDate(new Timestamp(fm.parse(this.beginDate).getTime()));
			}
			if(endDate!=null&&endDate.length()>0){
				this.managerFee.setEndDate(new Timestamp(fm.parse(this.endDate).getTime()));
			}
			if(operTime!=null&&operTime.length()>0){
				this.managerFee.setOperTime(new Timestamp(fm.parse(this.operTime).getTime()));
			}
			if(createTime!=null&&createTime.length()>0){
				this.managerFee.setCreateTime(new Timestamp(fm.parse(this.createTime).getTime()));
			}
			if(updateTime!=null&&updateTime.length()>0){
				this.managerFee.setUpdateTime(new Timestamp(fm.parse(this.updateTime).getTime()));
			}
			if(totalFee!=null){
				this.managerFee.setTotalFee(UcmsWebUtils.yuanTofen(this.totalFee));
			}
			if(feeItemId!=null){
				this.managerFee.setFeeItem(feeItemService.findById(feeItemId));
			}
			this.managerFee.setRemark(remark);
			return managerFee;
	
	}
	public void setManagerFee(ManagerFee managerFee) {
		this.managerFee = managerFee;
	}
	public String getBeginDate() {
		return beginDate;
	}
	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getTotalFee() {
		return totalFee;
	}
	public void setTotalFee(String totalFee) {
		this.totalFee = totalFee;
	}
	public String getOperTime() {
		return operTime;
	}
	public void setOperTime(String operTime) {
		this.operTime = operTime;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}
	public Long getFeeItemId() {
		return feeItemId;
	}
	public void setFeeItemId(Long feeItemId) {
		this.feeItemId = feeItemId;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}
