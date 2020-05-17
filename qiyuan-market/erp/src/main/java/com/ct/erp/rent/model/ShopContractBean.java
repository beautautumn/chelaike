package com.ct.erp.rent.model;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import com.ct.erp.lib.entity.ClearingReason;
import com.ct.erp.lib.entity.ContractShop;
import com.ct.erp.lib.entity.ShopContract;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.util.UcmsWebUtils;

public class ShopContractBean {
	private Long id;
	private String agencyId;
	private ShopContract shopContract = new ShopContract();
	private String everyRecvFee;
	private String depositFee;
	private String backDesc;
	private String backTime;
	private String startDate;
	private String endDate;
	private List<ContractShop> contractAreas=new ArrayList<ContractShop>();
	private String recvCycle;
	private String signDate;
	private String marketSignName;
	private String agencySignName;
	private String remark;
	
	private ClearingReason clearingReason;
	private String clearingStartDate;
	private Staff staffByClearingStartStaff;
	private String clearingDesc;
	private String endReason;
	private int backDepositFee;
	private String monthTotalFeeAll;
	
	public ShopContractBean(ShopContract shopContract){
		if(shopContract != null){
			SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd");
			this.shopContract = shopContract;
			if(shopContract.getEveryRecvFee()!=null){
				this.everyRecvFee = UcmsWebUtils.fenToYuan(shopContract.getEveryRecvFee());
			}else{
				this.everyRecvFee = "0";
				this.shopContract.setEveryRecvFee(0);
			}
			if(shopContract.getDepositFee()!=null){
				this.depositFee = UcmsWebUtils.fenToYuan(shopContract.getDepositFee());
			}else{
				this.depositFee = "0";
				this.shopContract.setDepositFee(0);
			}
			this.startDate = fm.format(shopContract.getStartDate());
			this.endDate = fm.format(shopContract.getEndDate());
		}
	}

	public ShopContract getShopContract() {
		return shopContract;
	}

	public void setShopContract(ShopContract shopContract) {
		this.shopContract = shopContract;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getAgencyId() {
		return agencyId;
	}

	public void setAgencyId(String agencyId) {
		this.agencyId = agencyId;
	}

	public ShopContract getContract() {
		return shopContract;
	}

	public void setContract(ShopContract shopContract) {
		this.shopContract = shopContract;
	}

	public String getEveryRecvFee() {
		return everyRecvFee;
	}

	public void setEveryRecvFee(String everyRecvFee) {
		this.everyRecvFee = everyRecvFee;
	}

	public String getDepositFee() {
		return depositFee;
	}

	public void setDepositFee(String depositFee) {
		this.depositFee = depositFee;
	}

	public String getBackDesc() {
		return backDesc;
	}

	public void setBackDesc(String backDesc) {
		this.backDesc = backDesc;
	}

	public String getBackTime() {
		return backTime;
	}

	public void setBackTime(String backTime) {
		this.backTime = backTime;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public List<ContractShop> getContractAreas() {
		return contractAreas;
	}

	public void setContractAreas(List<ContractShop> contractAreas) {
		this.contractAreas = contractAreas;
	}

	public String getRecvCycle() {
		return recvCycle;
	}

	public void setRecvCycle(String recvCycle) {
		this.recvCycle = recvCycle;
	}

	public String getSignDate() {
		return signDate;
	}

	public void setSignDate(String signDate) {
		this.signDate = signDate;
	}

	public String getMarketSignName() {
		return marketSignName;
	}

	public void setMarketSignName(String marketSignName) {
		this.marketSignName = marketSignName;
	}

	public String getAgencySignName() {
		return agencySignName;
	}

	public void setAgencySignName(String agencySignName) {
		this.agencySignName = agencySignName;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public ClearingReason getClearingReason() {
		return clearingReason;
	}

	public void setClearingReason(ClearingReason clearingReason) {
		this.clearingReason = clearingReason;
	}

	public String getClearingStartDate() {
		return clearingStartDate;
	}

	public void setClearingStartDate(String clearingStartDate) {
		this.clearingStartDate = clearingStartDate;
	}

	public Staff getStaffByClearingStartStaff() {
		return staffByClearingStartStaff;
	}

	public void setStaffByClearingStartStaff(Staff staffByClearingStartStaff) {
		this.staffByClearingStartStaff = staffByClearingStartStaff;
	}

	public String getClearingDesc() {
		return clearingDesc;
	}

	public void setClearingDesc(String clearingDesc) {
		this.clearingDesc = clearingDesc;
	}

	public String getEndReason() {
		return endReason;
	}

	public void setEndReason(String endReason) {
		this.endReason = endReason;
	}

	public int getBackDepositFee() {
		return backDepositFee;
	}

	public void setBackDepositFee(int backDepositFee) {
		this.backDepositFee = backDepositFee;
	}

	public String getMonthTotalFeeAll() {
		return monthTotalFeeAll;
	}

	public void setMonthTotalFeeAll(String monthTotalFeeAll) {
		this.monthTotalFeeAll = monthTotalFeeAll;
	}

}
