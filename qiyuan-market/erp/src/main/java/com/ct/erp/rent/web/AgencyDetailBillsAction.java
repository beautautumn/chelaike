package com.ct.erp.rent.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.AgencyBills;
import com.ct.erp.lib.entity.AgencyDetailBills;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.service.AgencyBillsService;
import com.ct.erp.rent.service.AgencyDetailBillsService;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.rent.service.ContractAreaService;
import com.ct.erp.rent.service.ManagerFeeService;
import com.ct.erp.rent.service.SiteAreaService;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.agencyDetailBillsAction")
public class AgencyDetailBillsAction {
	/*private String deduction;*/
	private String AgencyBillsId;
	private String feeType;
	private Integer totalFees;
	private String staffId;
	private List<AgencyDetailBills> agencyDetailBills = new ArrayList<AgencyDetailBills>();
	private String date;
	private List<Staff> staffs = new ArrayList<Staff>();
	private Agency agency;
	private String recvFee;
	private String recvTime;
	private String remark;
	private Integer totalDepositFee;
	@Autowired
	private AgencyDetailBillsService agencyDetialService;
	@Autowired
	private AgencyBillsService agencyBillsService;
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private SiteAreaService siteAreaService;
	@Autowired
	private ContractAreaService contractAreaService;
	@Autowired
	private ManagerFeeService managerFeeService;
	@Autowired
	private StaffService staffService;	
	
	/**
	 * 查看独立计费和分摊计费
	 * @param AgencyBillsId
	 * @param feeType
	 * @return
	 */
	public String findAgencyDetailBillsByAgencyBillsId(){
		agencyDetailBills=agencyDetialService.findAgencyDetailBillsByAgencyBillsId(AgencyBillsId,feeType);
		return "toAgencyDetailBills";
	}
	/**
	 * 收取物业费更改总账单、明细账单、分摊总账单
	 * @return
	 * @throws Exception
	 */
	public String CollectFees() throws Exception{
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			//修改总账单表
			agencyDetialService.collectFees(AgencyBillsId, recvFee, recvTime, staffId, remark/*,deduction*/);
			//修改费用类型为独立计费的明细账单
			List<AgencyDetailBills>  indenpence= agencyDetialService.findAgencyDetailBillsByAgencyBillsId(AgencyBillsId,"1");
			agencyDetialService.changeAgencyDetailBillsState(indenpence);
			//修改费用类型为分摊计费的明细账单
			List<AgencyDetailBills>  avg= agencyDetialService.findAgencyDetailBillsByAgencyBillsId(AgencyBillsId,"0");
			agencyDetialService.changeAgencyDetailBillsState(avg);
			for(int i=0;i<avg.size();i++){
				Long managerId = avg.get(i).getManagerFee().getId();
				int x = agencyDetialService.findAgencyDetailBillsBymanagerFeeIdAndState(managerId,"0").size();
				if(x==0){
					//x等于0说明分摊费用已经收完，修改为“3”
					managerFeeService.changeManagerFeeState(managerId, "3");
				}if(x>0){
					//x大于0说明分摊费用还为收完，修改为“2”
					managerFeeService.changeManagerFeeState(managerId, "2");
				}
			}
			/*if(deduction.equals("true")){
				AgencyBills agencyBill = agencyBillsService.findById(Long.parseLong(AgencyBillsId));
				//应缴账单费用费用
				Integer feeValue = agencyBill.getFeeValue();
				Agency agency = agencyBill.getAgency();
				Integer totalDepositFee = agency.getTotalDepositFee();
				agencyBillsService.deductionFees(agency,feeValue,totalDepositFee);
			}*/
			UcmsWebUtils.ajaxOutPut(response,"success");
		} catch (Exception e) {
//			e.printStackTrace();
			UcmsWebUtils.ajaxOutPut(response,"error");
		}
		return null;
	}
	public List<AgencyDetailBills> getAgencyDetailBills() {
		return agencyDetailBills;
	}
	public void setAgencyDetailBills(List<AgencyDetailBills> agencyDetailBills) {
		this.agencyDetailBills = agencyDetailBills;
	}
	public AgencyDetailBillsService getAgencyDetialService() {
		return agencyDetialService;
	}

	public void setAgencyDetialService(AgencyDetailBillsService agencyDetialService) {
		this.agencyDetialService = agencyDetialService;
	}

	public String getAgencyBillsId() {
		return AgencyBillsId;
	}

	public void setAgencyBillsId(String agencyBillsId) {
		AgencyBillsId = agencyBillsId;
	}

	public String getFeeType() {
		return feeType;
	}

	public void setFeeType(String feeType) {
		this.feeType = feeType;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public List<Staff> getStaffs() {
		return staffs;
	}
	public void setStaffs(List<Staff> staffs) {
		this.staffs = staffs;
	}
	public Agency getAgency() {
		return agency;
	}
	public void setAgency(Agency agency) {
		this.agency = agency;
	}
	public AgencyService getAgencyService() {
		return agencyService;
	}
	public void setAgencyService(AgencyService agencyService) {
		this.agencyService = agencyService;
	}
	public SiteAreaService getSiteAreaService() {
		return siteAreaService;
	}
	public void setSiteAreaService(SiteAreaService siteAreaService) {
		this.siteAreaService = siteAreaService;
	}
	public ContractAreaService getContractAreaService() {
		return contractAreaService;
	}
	public void setContractAreaService(ContractAreaService contractAreaService) {
		this.contractAreaService = contractAreaService;
	}
	public ManagerFeeService getManagerFeeService() {
		return managerFeeService;
	}
	public void setManagerFeeService(ManagerFeeService managerFeeService) {
		this.managerFeeService = managerFeeService;
	}
	public Integer getTotalFees() {
		return totalFees;
	}
	public void setTotalFees(Integer totalFees) {
		this.totalFees = totalFees;
	}
	public String getStaffId() {
		return staffId;
	}
	public void setStaffId(String staffId) {
		this.staffId = staffId;
	}
	public StaffService getStaffService() {
		return staffService;
	}
	public void setStaffService(StaffService staffService) {
		this.staffService = staffService;
	}
	public String getRecvFee() {
		return recvFee;
	}
	public void setRecvFee(String recvFee) {
		this.recvFee = recvFee;
	}
	public String getRecvTime() {
		return recvTime;
	}
	public void setRecvTime(String recvTime) {
		this.recvTime = recvTime;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public AgencyBillsService getAgencyBillsService() {
		return agencyBillsService;
	}
	/*public String getDeduction() {
		return deduction;
	}
	public void setDeduction(String deduction) {
		this.deduction = deduction;
	}*/
	public void setAgencyBillsService(AgencyBillsService agencyBillsService) {
		this.agencyBillsService = agencyBillsService;
	}
	public Integer getTotalDepositFee() {
		return totalDepositFee;
	}
	public void setTotalDepositFee(Integer totalDepositFee) {
		this.totalDepositFee = totalDepositFee;
	}
}
