package com.ct.erp.rent.model;

import java.text.SimpleDateFormat;

import com.ct.erp.lib.entity.AgencyDetailBills;
import com.ct.erp.util.UcmsWebUtils;

public class AgencyDetailBillsBean {
	private AgencyDetailBills agencyDetailBills;
	private String feeValue;
	private String contractDate;
	
	public AgencyDetailBillsBean(AgencyDetailBills agencyDetailBills){
		this.agencyDetailBills = agencyDetailBills;
		this.feeValue = UcmsWebUtils.fenToYuan(agencyDetailBills.getFeeValue());
		this.contractDate = new SimpleDateFormat("yyyy-MM-dd").format(agencyDetailBills.getContractArea().getContract().getStartDate())+"至"+new SimpleDateFormat("yyyy-MM-dd").format(agencyDetailBills.getContractArea().getContract().getEndDate());
	}
	
	public AgencyDetailBills getAgencyDetailBills() {
		return agencyDetailBills;
	}
	public void setAgencyDetailBills(AgencyDetailBills agencyDetailBills) {
		this.agencyDetailBills = agencyDetailBills;
	}
	public String getFeeValue() {
		return feeValue;
	}
	public void setFeeValue(String feeValue) {
		this.feeValue = feeValue;
	}

	public String getContractDate() {
		return contractDate;
	}

	public void setContractDate(String contractDate) {
		this.contractDate = contractDate;
	}
	
}
