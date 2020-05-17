package com.ct.erp.rent.web;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.AgencyDetailBills;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.ManagerFee;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.model.AgencyDetailBillsBean;
import com.ct.erp.rent.model.ManagerFeeBean;
import com.ct.erp.rent.service.AgencyBillsService;
import com.ct.erp.rent.service.AgencyDetailBillsService;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.rent.service.ContractAreaService;
import com.ct.erp.rent.service.ContractService;
import com.ct.erp.rent.service.ManagerFeeService;
import com.ct.erp.rent.service.SiteAreaService;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.msg.emay.KcbMessageService;
import com.ct.util.log.LogUtil;
@Scope("prototype")
@Controller("rent.agencyBillsAction")
public class AgencyBillsAction extends SimpleActionSupport {

	private static final long serialVersionUID = 5750425484366758255L;
	private List<Staff> staffs;
	private Staff staff;
	private Long managerFeeId;
	private Long contractId;
	private Long agencyId;
	private ManagerFee managerFee;
	private ManagerFeeBean managerFeeBean;
	private List<Agency> agencys;
	private String jsonStr;
	private List<SiteArea> siteAreas;
	private Long areaId;
	private List<AgencyDetailBillsBean> agencyDetailBillsBeans = new ArrayList<AgencyDetailBillsBean>();
	@Autowired
	private AgencyDetailBillsService agencyDetailBillsService;
	@Autowired
	private SiteAreaService siteAreaService;
	@Autowired
	private ManagerFeeService managerFeeService;
	@Autowired
	private StaffService staffService;
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private ContractService contractService;
	@Autowired
	private AgencyBillsService agencyBillsService;
	@Autowired
	private ContractAreaService contractAreaService;
	//	@Autowired
	//	private KcbMessageService msg;
	
	public String findContractByAreaId(){
		HttpServletResponse response = ServletActionContext.getResponse();
		String resStr = "";
		try {
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			List<ContractArea> contractAreas = contractAreaService.findContractAreaByAreaId(areaId);
			JSONArray jsonArr= new JSONArray();
			for(int i=0;i<contractAreas.size();i++){
				if(contractAreas.get(i).getContract().getAgency().getState().equals("103")&&contractAreas.get(i).getStatus().equals("1")){
					JSONObject obj = new JSONObject();
					obj.put("areaId", areaId);
					obj.put("agencyId", contractAreas.get(i).getContract().getAgency().getId());
					obj.put("agencyName", contractAreas.get(i).getContract().getAgency().getAgencyName());
					obj.put("contractAreaId", contractAreas.get(i).getId());
					obj.put("contractArea", contractAreas.get(i).getSiteArea().getAreaName()+"-"+contractAreas.get(i).getAreaNo());
					obj.put("date",format.format(contractAreas.get(i).getContract().getStartDate())+"至"+format.format(contractAreas.get(i).getContract().getEndDate()));
					obj.put("feeValue", "");
					obj.put("remark", "");
					jsonArr.add(obj);
				}
			}		
			resStr = jsonArr.toString();
		} catch (Exception ex) {
			UcmsWebUtils.ajaxOutPut(response, "error");
			LogUtil.logError(this.getClass(), "Error in findContractByAreaId method!", ex);
		}
		UcmsWebUtils.ajaxOutPut(response, resStr);
		return null;
	}
	public String toAgencyBillsPage(){
		if(managerFeeId == null){
			return null;
		}
		managerFee = managerFeeService.findById(managerFeeId);
		managerFeeBean = new ManagerFeeBean(managerFee);
		staffs = staffService.findAll();
		staff = staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId());
		return "toagencyBillsPage";
	}
	//转入添加物业分摊商户
	public String toAgencyBillsAdd(){
		agencys = agencyService.findByState("103");
		return "toAgencyBillsAdd";
	}
	//根据商户ID查询合同区域
	public String findContractArea(){
		HttpServletResponse response = ServletActionContext.getResponse();
		String resStr = "";
		try {
			//查询生效的合同
			List<Contract> contracts = contractService.findByAgencyId(agencyId,"102");
			JSONArray jsonArr = new JSONArray();
			Iterator<Contract> it = contracts.iterator();
			while(it.hasNext()){
				Set<ContractArea> contractAreas = it.next().getContractAreas();
				Iterator<ContractArea> it2 = contractAreas.iterator();
				while(it2.hasNext()){
					ContractArea contractArea = it2.next();
					JSONObject obj = new JSONObject();
					obj.put("contractAreaId", contractArea.getId());
					obj.put("contractAreaName", contractArea.getSiteArea().getAreaName()+"-"+contractArea.getAreaNo());
					obj.put("contractId", contractArea.getContract().getId());
					obj.put("startDate", new SimpleDateFormat("yyyy-MM-dd").format(contractArea.getContract().getStartDate()));
					obj.put("endDate", new SimpleDateFormat("yyyy-MM-dd").format(contractArea.getContract().getEndDate()));
					obj.put("areaId", contractArea.getSiteArea().getId());
					jsonArr.add(obj);
				}
			}
			resStr = jsonArr.toString(); 
		} catch (Exception ex) {
			UcmsWebUtils.ajaxOutPut(response, "error");
			LogUtil.logError(this.getClass(), "Error in findContractArea method!", ex);
		}
		UcmsWebUtils.ajaxOutPut(response, resStr);
		return null;
	}
	//批量添加
	public String toAgencyBillsBatchAdd(){
		siteAreas = siteAreaService.findAll();
		return "toAgencyBillsBatchAdd";
	}
	
	
//	public String findContractDate(){
//		if(agencyId==null){
//			return null;
//		}
//		HttpServletResponse response = ServletActionContext.getResponse();
//		PrintWriter out = null;
//		response.setContentType("text/html;charset=utf-8");
//		try {
//			out = response.getWriter();
//			ContractBean contractBean = new ContractBean(contractService.findByAgencyId(agencyId));
//			String backStr = contractBean.getStartDate()+","+contractBean.getEndDate()+","+contractBean.getContract().getId();
//			out.print(backStr);
//			out.close();
//		} catch (Exception e) {
//			e.printStackTrace();
//			out.print("error");
//		}
//		return null;
//	}
	
	public String doAgencyBills(){
		if(jsonStr==null){
			return null;
		}
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try {
			out = response.getWriter();
			agencyBillsService.save(jsonStr); 
			out.print("success");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		return null;
	}
	public String sameItemAdd(){
		HttpServletResponse response = ServletActionContext.getResponse();
		try{
			jsonStr = agencyBillsService.sameItemAdd(managerFeeId);
		} catch (Exception ex) {
			UcmsWebUtils.ajaxOutPut(response, "error");
			LogUtil.logError(this.getClass(), "Error in sameItemAdd method!", ex);
		}
		UcmsWebUtils.ajaxOutPut(response, jsonStr);
		return null;
	}
	
	//分摊记录
	public String toPropertyApportFeeDetail(){
		List<AgencyDetailBills> list = agencyDetailBillsService.findByManagerFeeId(managerFeeId);
		for(AgencyDetailBills adbs:list){
			agencyDetailBillsBeans.add(new AgencyDetailBillsBean(adbs));
		}
		return "propertyApportFeeDetail";
	}
	public List<Staff> getStaffs() {
		return staffs;
	}
	public void setStaffs(List<Staff> staffs) {
		this.staffs = staffs;
	}
	public Long getManagerFeeId() {
		return managerFeeId;
	}
	public void setManagerFeeId(Long managerFeeId) {
		this.managerFeeId = managerFeeId;
	}
	public ManagerFee getManagerFee() {
		return managerFee;
	}
	public void setManagerFee(ManagerFee managerFee) {
		this.managerFee = managerFee;
	}
	public ManagerFeeBean getManagerFeeBean() {
		return managerFeeBean;
	}
	public void setManagerFeeBean(ManagerFeeBean managerFeeBean) {
		this.managerFeeBean = managerFeeBean;
	}
	public List<Agency> getAgencys() {
		return agencys;
	}
	public void setAgencys(List<Agency> agencys) {
		this.agencys = agencys;
	}
	public Long getContractId() {
		return contractId;
	}
	public void setContractId(Long contractId) {
		this.contractId = contractId;
	}
	public String getJsonStr() {
		return jsonStr;
	}
	public void setJsonStr(String jsonStr) {
		this.jsonStr = jsonStr;
	}
	public Staff getStaff() {
		return staff;
	}
	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public List<SiteArea> getSiteAreas() {
		return siteAreas;
	}

	public void setSiteAreas(List<SiteArea> siteAreas) {
		this.siteAreas = siteAreas;
	}
	public Long getAgencyId() {
		return agencyId;
	}
	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}
	public Long getAreaId() {
		return areaId;
	}
	public void setAreaId(Long areaId) {
		this.areaId = areaId;
	}
	public List<AgencyDetailBillsBean> getAgencyDetailBillsBeans() {
		return agencyDetailBillsBeans;
	}
	public void setAgencyDetailBillsBean(
			List<AgencyDetailBillsBean> agencyDetailBillsBeans) {
		this.agencyDetailBillsBeans = agencyDetailBillsBeans;
	}


}
