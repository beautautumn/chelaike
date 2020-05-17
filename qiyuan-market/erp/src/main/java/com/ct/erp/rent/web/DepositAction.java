package com.ct.erp.rent.web;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.model.DepositBean;
import com.ct.erp.rent.service.AgencyBillsService;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.rent.service.ContractService;
import com.ct.erp.sys.service.base.StaffService;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.DepositAction")
public class DepositAction extends SimpleActionSupport {
	private String agencyState;
	private int depositFee;
	private Agency agency;
	private Long agencyId;
	private String agencyName;
	private Staff staff;
	private String currDate;
	private DepositBean depositBean;
	private List<Staff> staffList = new ArrayList<Staff>();
	private List<Contract> contractList = new ArrayList<Contract>();
	private Contract contract = new Contract();
	private Long contractId;
	@Autowired
	private ContractService contractService;
	@Autowired
	private StaffService staffService;
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private AgencyBillsService agencyBillsService;
	private Double actualFee;

	public String toClear() {
		Long staffId = SecurityUtils.getCurrentSessionInfo().getStaffId();
		Date dt = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		this.currDate = sdf.format(dt);
		this.staff = staffService.findById(staffId);
		this.contract = this.contractService.findById(this.contractId);
		this.depositFee = this.contract.getDepositFee();
		this.staffList = staffService.findAll();
		this.actualFee = (double) this.depositFee;
		this.agency = agencyService.findById(this.agencyId);
		/*if (this.contract.getDepositFee() == null) {
			this.actualFee = 0 - this.agencyBillsService
					.findAgencyTotalFeeByAgencyId(this.agencyId);
		} else {
			this.actualFee = this.contract.getDepositFee()
					- this.agencyBillsService
							.findAgencyTotalFeeByAgencyId(this.agencyId);
		}*/
		return "deposit_toclear";
	}

	public String update() {
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try {
			out = response.getWriter();
			this.agencyService.update(this.agency, this.depositBean,this.contract);
			out.print("success");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		return null;
	}

	public ContractService getContractService() {
		return contractService;
	}

	public void setContractService(ContractService contractService) {
		this.contractService = contractService;
	}

	public StaffService getStaffService() {
		return staffService;
	}

	public void setStaffService(StaffService staffService) {
		this.staffService = staffService;
	}

	public List<Staff> getStaffList() {
		return staffList;
	}

	public void setStaffList(List<Staff> staffList) {
		this.staffList = staffList;
	}

	public Staff getStaff() {
		return staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public String getCurrDate() {
		return currDate;
	}

	public void setCurrDate(String currDate) {
		this.currDate = currDate;
	}

	public DepositBean getDepositBean() {
		return depositBean;
	}

	public void setDepositBean(DepositBean depositBean) {
		this.depositBean = depositBean;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public List<Contract> getContractList() {
		return contractList;
	}

	public void setContractList(List<Contract> contractList) {
		this.contractList = contractList;
	}

	public int getDepositFee() {
		return depositFee;
	}

	public void setDepositFee(int depositFee) {
		this.depositFee = depositFee;
	}

	public Agency getAgency() {
		return agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public Long getAgencyId() {
		return agencyId;
	}

	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}

	public AgencyService getAgencyService() {
		return agencyService;
	}

	public void setAgencyService(AgencyService agencyService) {
		this.agencyService = agencyService;
	}

	public String getAgencyState() {
		return agencyState;
	}

	public void setAgencyState(String agencyState) {
		this.agencyState = agencyState;
	}

	public AgencyBillsService getAgencyBillsService() {
		return agencyBillsService;
	}

	public void setAgencyBillsService(AgencyBillsService agencyBillsService) {
		this.agencyBillsService = agencyBillsService;
	}

	public Double getActualFee() {
		return actualFee;
	}

	public void setActualFee(Double actualFee) {
		this.actualFee = actualFee;
	}

	public Contract getContract() {
		return contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}

	public Long getContractId() {
		return contractId;
	}

	public void setContractId(Long contractId) {
		this.contractId = contractId;
	}

	

}