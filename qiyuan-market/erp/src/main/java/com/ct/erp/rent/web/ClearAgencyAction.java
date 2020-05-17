package com.ct.erp.rent.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.AgencyBills;
import com.ct.erp.lib.entity.AgencyDetailBills;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.service.AgencyBillsService;
import com.ct.erp.rent.service.AgencyDetailBillsService;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.rent.service.ContractService;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.util.log.LogUtil;
@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.clearAgencyAction")
public class ClearAgencyAction extends SimpleActionSupport {
	private Contract contract;
	private String contractId;
	private String date;
	private String clearStartDate;
	private List<Staff> staffs;
	private String agencyId;
	private String staffId;
	private String endDate;
	private String clearingDesc;
	private String leaveDate;
	private String leaveDesc;
	private List<AgencyBills> agencyBills; 
	private List<AgencyDetailBills> agencyDetailBills;
	@Autowired
	private ContractService contractService;
	@Autowired
	private StaffService staffService;
	@Autowired
	private AgencyBillsService agencyBillsService;
	@Autowired 
	private AgencyDetailBillsService agencyDetailBillsService;
	@Autowired
	private AgencyService agencyService;
	/*public String toClear(){
		date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		clearStartDate = new SimpleDateFormat("yyyy-MM-dd").
			format(agencyService.findById(Long.parseLong(agencyId)).getClearingStartDate()); 
		staffs=staffService.findAll();
		return "toClear";
	}*/
	/*public String clearAgency() throws Exception{
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			agencyService.clearAgency(agencyId,staffId,endDate,clearingDesc);
			UcmsWebUtils.ajaxOutPut(response,"success");
		} catch (Exception e) {
			UcmsWebUtils.ajaxOutPut(response,"error");
			e.printStackTrace();
			LogUtil.logError(this.getClass(),"Error in findContractByAreaId method!", e);
		}
		return null;
	}*/
	public String getClearAgencyFeeDetial(){
		agencyDetailBills = agencyDetailBillsService.findAgencyDetailBillsByAgencyId(agencyId);
		return "getClearAgencyFeeDetialSuccess";
	}
	public String toLeaveAgency(){
		date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		staffs=staffService.findAll();
		return "toLeave";
	}
	/**
	 * 商户确认离场
	 * @return
	 */
	/*public String leaveAgency(){
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			agencyService.leaveAgency(agencyId, leaveDate, staffId, leaveDesc);
			UcmsWebUtils.ajaxOutPut(response,"success");
		} catch (Exception e) {
			UcmsWebUtils.ajaxOutPut(response,"error");
			e.printStackTrace();
			LogUtil.logError(this.getClass(),"Error in findContractByAreaId method!", e);
		}
			return null;
	}*/
	
	
	public String getContractId() {
		return contractId;
	}
	public void setContractId(String contractId) {
		this.contractId = contractId;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public ContractService getContractService() {
		return contractService;
	}
	public void setContractService(ContractService contractService) {
		this.contractService = contractService;
	}
	public Contract getContract() {
		return contract;
	}
	public void setContract(Contract contract) {
		this.contract = contract;
	}
	public List<Staff> getStaffs() {
		return staffs;
	}
	public void setStaffs(List<Staff> staffs) {
		this.staffs = staffs;
	}
	public StaffService getStaffService() {
		return staffService;
	}
	public void setStaffService(StaffService staffService) {
		this.staffService = staffService;
	}
	public String getAgencyId() {
		return agencyId;
	}
	public void setAgencyId(String agencyId) {
		this.agencyId = agencyId;
	}
	public String getStaffId() {
		return staffId;
	}
	public void setStaffId(String staffId) {
		this.staffId = staffId;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getClearingDesc() {
		return clearingDesc;
	}
	public void setClearingDesc(String clearingDesc) {
		this.clearingDesc = clearingDesc;
	}
	public List<AgencyBills> getAgencyBills() {
		return agencyBills;
	}
	public void setAgencyBills(List<AgencyBills> agencyBills) {
		this.agencyBills = agencyBills;
	}
	public AgencyBillsService getAgencyBillsService() {
		return agencyBillsService;
	}
	public void setAgencyBillsService(AgencyBillsService agencyBillsService) {
		this.agencyBillsService = agencyBillsService;
	}
	public AgencyDetailBillsService getAgencyDetailBillsService() {
		return agencyDetailBillsService;
	}
	public void setAgencyDetailBillsService(
			AgencyDetailBillsService agencyDetailBillsService) {
		this.agencyDetailBillsService = agencyDetailBillsService;
	}
	public List<AgencyDetailBills> getAgencyDetailBills() {
		return agencyDetailBills;
	}
	public void setAgencyDetailBills(List<AgencyDetailBills> agencyDetailBills) {
		this.agencyDetailBills = agencyDetailBills;
	}
	public AgencyService getAgencyService() {
		return agencyService;
	}
	public String getClearStartDate() {
		return clearStartDate;
	}
	public void setClearStartDate(String clearStartDate) {
		this.clearStartDate = clearStartDate;
	}
	public String getLeaveDate() {
		return leaveDate;
	}
	public void setLeaveDate(String leaveDate) {
		this.leaveDate = leaveDate;
	}
	public String getLeaveDesc() {
		return leaveDesc;
	}
	public void setLeaveDesc(String leaveDesc) {
		this.leaveDesc = leaveDesc;
	}
	public void setAgencyService(AgencyService agencyService) {
		this.agencyService = agencyService;
	}
	
	
}
