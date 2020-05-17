package com.ct.erp.rent.web;

import java.io.File;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.ClearingReason;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.model.ContractBean;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.rent.service.ContractAreaService;
import com.ct.erp.rent.service.ContractListService;
import com.ct.erp.rent.service.ContractService;
import com.ct.erp.rent.service.PicService;
import com.ct.erp.rent.service.SiteAreaService;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.util.log.LogUtil;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.contractListAction")
public class ContractListAction extends SimpleActionSupport {
	private static final Logger log = LoggerFactory.getLogger(ContractListAction.class);

	private String agencyState;
	private String agencyname;
	private Long agencyId;
	private String flag;
	private String startBeginDate;
	private String startEndDate;
	private String endBeginDate;
	private String endFinalDate;
	private Long contractId;
	private Long clearingReasonId;
	private String clearingStartDate;
	private Long contractAreaId;
	private Long staffByClearingStartStaffId;
	private String normalContinueStartDate;
	private Long currentStaffId;
	private String currentSiteAreas;
	private Timestamp continueEndDate;
	private Contract contract;
	private List<Agency> agencys=new ArrayList<Agency>();
	private ContractBean contractBean = new ContractBean();
	private List<SiteArea> siteAreas=new ArrayList<SiteArea>();
	private List<Contract> contracts=new ArrayList<Contract>();
	private List<ContractArea> contractAreas = new ArrayList<ContractArea>();
	private List<Staff> staffs=new ArrayList<Staff>();
	private List<ClearingReason> reasons=new ArrayList<ClearingReason>();
	private List<OperHis> opers=new ArrayList<OperHis>();
	private String areaNoAll;
	private List<String> areaNos=new ArrayList<String>();
	
	private File fileObj;
	private String localFileName;
	private Long picId;
	private Pic pic;
	
	/**
	 * 视图类别： ADD 新增, EDIT 修改, CONTINUE 续签, SIGN 签订
	 */
	private String contractView;
	
	@Autowired
	private ContractService contractService;
	@Autowired
	private ContractAreaService contractAreaService;
	@Autowired
	private SiteAreaService siteAreaService;
	@Autowired
	private ContractListService contractListService;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private StaffService staffService;
	@Autowired
	private PicService picService;
	
	/*
	 * 合同信息列表-合同信息table
	 */
	@SuppressWarnings("unchecked")
	public String getContractInfo() throws Exception {
		HttpServletResponse response = null;
		PrintWriter out = null;
		try {
			if (agencyname == null) {
				return "{}";
			}
			response = ServletActionContext.getResponse();
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();

			this.contracts = contractService.findByAgencyname(agencyname,agencyState);
			this.contracts = contractService.findByAgencyname(agencyname,agencyState);
			String jsonStr = "";
			JSONArray jsonArr = new JSONArray();
			for(Contract con: contracts){
				JSONObject obj = new JSONObject();
				obj.put("contractId", con.getId());
				obj.put("state",con.getState());
				obj.put("start_date",new SimpleDateFormat("yyyy/MM/dd").format(con.getStartDate()));
				obj.put("end_date", new SimpleDateFormat("yyyy/MM/dd").format(con.getEndDate()));
				obj.put("deposit_fee", con.getPayedDepositFee());
				Set<ContractArea> contractAreas = con.getContractAreas();
				obj.put("area_size", contractAreas.size());
				JSONArray jsonArea = new JSONArray();
				JSONObject area = new JSONObject();
				Iterator<ContractArea> it = contractAreas.iterator();
				while (it.hasNext()) {
					ContractArea contractArea = it.next();
						area.put("area_name", contractArea.getSiteArea().getAreaName());
						area.put("area_no", contractArea.getAreaNo());
						area.put("rent_type", contractArea.getSiteArea().getRentType());
						area.put("lease_count", contractArea.getLeaseCount());
						area.put("month_total_fee", contractArea.getMonthTotalFee());
						jsonArea.add(area);
				}
				obj.put("areas", jsonArea);
				jsonArr.add(obj);
				
			}
			jsonStr = jsonArr.toString();
			out.print(jsonStr);
			out.flush();
			out.close();
			return null;
		} catch (Exception e) {
			throw e;
		}
	}
	

	/*
	 * 合同收款列表-合同区域table
	 */
	@SuppressWarnings("unchecked")
	public String getAreaTable() throws Exception {
		HttpServletResponse response = null;
		PrintWriter out = null;
		try {
			if (contractId == null) {
				return "{}";
			}
			response = ServletActionContext.getResponse();
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			Contract contract = contractService.findById(contractId);
			Set<ContractArea> contractAreas = contract.getContractAreas();
			Iterator<ContractArea> it = contractAreas.iterator();
			JSONArray jsonArr = new JSONArray();
			String jsonStr = "";
			while (it.hasNext()) {
				ContractArea contractArea = it.next();
				JSONObject obj = new JSONObject();
				obj.put("area_name", contractArea.getSiteArea().getAreaName());
				obj.put("rent_type", contractArea.getSiteArea().getRentType());
				obj.put("lease_count", contractArea.getLeaseCount());
				obj.put("area_no", contractArea.getAreaNo());
				obj.put("car_count", contractArea.getCarCount());
				jsonArr.add(obj);
			}
			jsonStr = jsonArr.toString();
			out.print(jsonStr);
			out.flush();
			out.close();
			return null;
		} catch (Exception e) {
			throw e;
		}
	}
	/*
	 * 合同查询列表-合同区域table
	 */
	@SuppressWarnings("unchecked")
	public String getListAreaTable() throws Exception {
		HttpServletResponse response = null;
		PrintWriter out = null;
		try {
			if (contractId == null) {
				return "{}";
			}
			response = ServletActionContext.getResponse();
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			Contract contract = contractService.findById(contractId);
			Set<ContractArea> contractAreas = contract.getContractAreas();
			Iterator<ContractArea> it = contractAreas.iterator();
			JSONArray jsonArr = new JSONArray();
			String jsonStr = "";
			while (it.hasNext()) {
				ContractArea contractArea = it.next();
				JSONObject obj = new JSONObject();
				obj.put("area_name", contractArea.getSiteArea().getAreaName());
				obj.put("rent_type", contractArea.getSiteArea().getRentType());
				obj.put("lease_count", contractArea.getLeaseCount());
				obj.put("area_no", contractArea.getAreaNo());
				obj.put("car_count", contractArea.getCarCount());
				jsonArr.add(obj);
			}
			jsonStr = jsonArr.toString();
			out.print(jsonStr);
			out.flush();
			out.close();
			return null;
		} catch (Exception e) {
			throw e;
		}
	}
	//合同列表
	public String toList(){
		try {
			contracts=this.contractService.findByCondition(agencyname,contractAreaId,startBeginDate,startEndDate,endBeginDate,endFinalDate);
			agencys=this.agencyService.findAll();
			contractAreas=this.contractAreaService.findAll();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "toListContract";
	}
	

	
	
	/**
	 * 合同续签
	 * @return
	 */
	public String toContinueContractPage(){
		this.contractView = "CONTINUE";
		// agencys=this.agencyService.findValidAgencyList();
		Contract cont =this.contractListService.findById(contractId);
		agencys.add(cont.getAgency());
		contract = new Contract();
		contract.setAgency(cont.getAgency());
		contractAreas=new ArrayList<ContractArea>(cont.getContractAreas());
//		normalContinueStartDate=this.contractListService.getContinueStartDate(contract);
		Date endDate=new Date(cont.getEndDate().getTime());
		Calendar cal = Calendar.getInstance();
		cal.setTime(endDate);
		cal.add(Calendar.YEAR, 1);
		contract.setEndDate(new Timestamp(cal.getTimeInMillis()));
		cal.setTime(endDate);
		cal.add(Calendar.DATE, 1);
		contract.setStartDate(new Timestamp(cal.getTimeInMillis()));
//		return "toContinueContractPage";
		return "toAddContract";
	}
	
	@Deprecated
	public String continueContract(){
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			
			this.contractListService.contractContinue(contractId,contractBean,contractAreas,picId);
				
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			e.printStackTrace();
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
		return null;
	}
	
	@Deprecated
	public String toContinueSelectSiteArea(){
		siteAreas=this.contractListService.getSiteArea(currentSiteAreas);
		areaNos=this.contractAreaService.findCurrentAreas();
		String areaNosString="";
		for(String areaNo:areaNos){
			areaNosString += areaNo+",";
		}
		if(areaNoAll==null||areaNoAll.trim().length()==0){
			areaNoAll = areaNosString;
		}else{
			areaNoAll += areaNosString;
		}
		return "toContinueSelectSiteArea";
	}
	//合同发起清算
	public String toCountContractPage(){
		staffs=this.contractListService.findStaffAll();
		reasons=this.contractListService.findAgencyReason();

		currentStaffId=SecurityUtils.getCurrentSessionInfo().getStaffId();
		return "toCountContractPage";
	}
	
	
	/**
	 * 合同清算
	 * @return
	 */
	public String countContract(){
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			this.contractListService.contractCount(contractId,contractBean);
				
			UcmsWebUtils.ajaxOutPut(response, "success");
			} catch (Exception e) {
				if(!(e instanceof ServiceException)){
					UcmsWebUtils.ajaxOutPut(response, "error");
				}else{
					UcmsWebUtils.ajaxOutPut(response, e.getMessage());
				}
			}
		return null;
	}
	
	//合同修改
//	@SuppressWarnings("unchecked")
//	public String toChangeContractPage(){
//		contract=this.contractListService.findById(contractId);
//		contractAreas=new ArrayList<ContractArea>(contract.getContractAreas());
//		return "toChangeContractPage";
//	}
	
//	public String changeContract(){
//		HttpServletResponse response = ServletActionContext.getResponse();
//		try {
//			this.contractListService.contractChange(contractId,contractBean,contractAreas);
//				
//			UcmsWebUtils.ajaxOutPut(response, "success");
//			} catch (Exception e) {
//				e.printStackTrace();
//				UcmsWebUtils.ajaxOutPut(response, "error");
//			}
//			return null;
//	}
//	public String toChangeSelectSiteArea(){
//		
//		siteAreas=this.siteAreaService.findAll();
//		
//		areaNos=this.contractAreaService.findCurrentAreas();
//		
//		/*contracts=this.contractService.findContractBeforeContinueEndDate(continueEndDate);
//		
//		for(Contract contract:contracts){
//			contractAreas=new ArrayList<ContractArea>(contract.getContractAreas());
//			for(ContractArea contractArea:contractAreas){
//				areaNos.add(contractArea.getAreaNo());
//			}
//		}*/
//		
//		String areaNosString="";
//		for(String areaNo:areaNos){
//			areaNosString += areaNo+",";
//		}
//		if(areaNoAll==null||areaNoAll.trim().length()==0){
//			areaNoAll = areaNosString;
//		}else{
//			areaNoAll += areaNosString;
//		}
//		return "toChangeSelectSiteArea";
//	}
	//合同详情
	public String toDetailContractPage(){
		contract=this.contractListService.findById(contractId);
		if(contract.getBackTime()==null){
			flag="0";
		}else{
			flag="1";
		}
		pic=this.picService.findByContractId(contractId);
		contractAreas=this.contractAreaService.findContractAreasByContractId(contract.getId());
		opers=operHisDao.findHisListByObjIdAndTag(contractId,"0");
		return "toDetailContractPage";
	}
	public String toCancelContractPage(){
		return "toCancelContractPage";
	}
	public void doCancelContract(){
        this.contract = this.contractService.findById(this.contractId);
        contract.setStatus("0");
        this.contractService.update(contract, "合同中止", "1");
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }
//	//重新签订
//	@SuppressWarnings("unchecked")
//	public String toResignContractPage(){
//		contract=this.contractListService.findById(contractId);
//		contractAreas=new ArrayList<ContractArea>(contract.getContractAreas());
//		normalContinueStartDate=this.contractListService.getContinueStartDate(contract);
//		return "toResignContractPage";
//	}
//	
//	public String resignContract(){
//		HttpServletResponse response = ServletActionContext.getResponse();
//		try {
//			
//			this.contractListService.contractResign(contractId,contractBean,contractAreas);
//				
//			UcmsWebUtils.ajaxOutPut(response, "success");
//		} catch (Exception e) {
//			e.printStackTrace();
//			UcmsWebUtils.ajaxOutPut(response, "error");
//		}
//		return null;
//	}
//	
//	public String toResignSelectSiteArea(){
//		
//		siteAreas=this.siteAreaService.findAll();
//		
//		areaNos=this.contractAreaService.findCurrentAreas();
//		
//		/*contracts=this.contractService.findContractBeforeContinueEndDate(continueEndDate);
//		
//		for(Contract contract:contracts){
//			contractAreas=new ArrayList<ContractArea>(contract.getContractAreas());
//			for(ContractArea contractArea:contractAreas){
//				areaNos.add(contractArea.getAreaNo());
//			}
//		}*/
//		
//		String areaNosString="";
//		for(String areaNo:areaNos){
//			areaNosString += areaNo+",";
//		}
//		if(areaNoAll==null||areaNoAll.trim().length()==0){
//			areaNoAll = areaNosString;
//		}else{
//			areaNoAll += areaNosString;
//		}
//		return "toResignSelectSiteArea";
//	}
	
	/**
	 * 跳转新增合同界面
	 * @return
	 */
	public String toAddContract(){
		this.contractView = "ADD";
		agencys=this.agencyService.findValidAgencyList();
		return "toAddContract";
	}
	
	/**
	 * 新增合同功能
	 * @return
	 * @return
	 */
	public String addContract(){
		HttpServletResponse response = ServletActionContext.getResponse();
		String result = "保存失败";
		try {
				result = contractListService.addContract(contractBean,contractAreas,picId);
				UcmsWebUtils.ajaxOutPut(response, result);
			} catch (Exception e) {
				e.printStackTrace();
				UcmsWebUtils.ajaxOutPut(response, "保存失败");
			}
			return null;
	}
	
	/**
	 * 调整区域配置界面
	 * @return
	 */
	public String toAddSiteArea(){
		siteAreas=this.contractListService.getSiteArea(currentSiteAreas);
		areaNos=this.contractAreaService.findCurrentAreas();
		String areaNosString="";
		for(String areaNo:areaNos){
			areaNosString += areaNo+",";
		}
		if(areaNoAll==null||areaNoAll.trim().length()==0){
			areaNoAll = areaNosString;
		}else{
			areaNoAll += areaNosString;
		}
		return "toAddSiteArea";
	}
	
	
	public void upload() throws Exception {
		
		HttpServletResponse response = ServletActionContext.getResponse();
		String resStr = "";
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			Long staffId = sessionInfo.getStaffId();
			Staff staff = staffService.findById(staffId);
			resStr=this.contractService.upload(0L,staff, fileObj, this.localFileName);
		} catch (Exception ex) {
			LogUtil.logError(this.getClass(), "Error in upload method!", ex);
			resStr = "0";
		}
		UcmsWebUtils.ajaxOutPut(response, resStr);
	}
	
	/**
	 * 修改合同
	 * @return
	 */
	public String toeditContract(){
		this.contractView = "EDIT";
		// agencys=this.agencyService.findValidAgencyList();
		contract=this.contractListService.findById(contractId);
		agencys.add(contract.getAgency());
		if(contract.getBackTime()==null){
			flag="0";
		}else{
			flag="1";
		}
		pic=this.picService.findByContractId(contractId);
		contractAreas=this.contractAreaService.findContractAreasByContractId(contract.getId());
		return "toAddContract";
	}
	
	/**
	 * 跳转合同签订
	 * @return
	 */
	public String toContractSignReg(){
		this.contractView = "SIGN";
		Agency agency = this.agencyService.findById(agencyId);
		if(contract == null){
			contract = new Contract();
		}
		contract.setAgency(agency);
		agencys.add(contract.getAgency());
//		agencys=this.agencyService.findValidAgencyList();
		return "toAddContract";
	}
	
	/**
	 * 审核合同页面
	 * @return
	 */
	public String toPassWorkingPage(){
		return "passWorkingPage";
	}
	
	/**
	 * 通过审核
	 * @return
	 */
	public void doPassWorking() throws Exception{
		HttpServletResponse response = ServletActionContext.getResponse();
		this.contract = this.contractService.findById(this.contractId);
		this.contract.setWorkingTag("1");
		this.contract.setUpdateTime(UcmsWebUtils.now());
		try{
			this.contractService.passWorking(contract);
			UcmsWebUtils.ajaxOutPut(response, "success");
		}catch (Exception e){
			log.error("contractListAction.doPassWorking",e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}


	public String getAgencyState() {
		return agencyState;
	}


	public void setAgencyState(String agencyState) {
		this.agencyState = agencyState;
	}


	public String getAgencyname() {
		return agencyname;
	}


	public void setAgencyname(String agencyname) {
		this.agencyname = agencyname;
	}


	public String getFlag() {
		return flag;
	}


	public void setFlag(String flag) {
		this.flag = flag;
	}


	public String getStartBeginDate() {
		return startBeginDate;
	}


	public void setStartBeginDate(String startBeginDate) {
		this.startBeginDate = startBeginDate;
	}


	public String getStartEndDate() {
		return startEndDate;
	}


	public void setStartEndDate(String startEndDate) {
		this.startEndDate = startEndDate;
	}


	public String getEndBeginDate() {
		return endBeginDate;
	}


	public void setEndBeginDate(String endBeginDate) {
		this.endBeginDate = endBeginDate;
	}


	public String getEndFinalDate() {
		return endFinalDate;
	}


	public void setEndFinalDate(String endFinalDate) {
		this.endFinalDate = endFinalDate;
	}


	public Long getContractId() {
		return contractId;
	}


	public void setContractId(Long contractId) {
		this.contractId = contractId;
	}


	public Long getClearingReasonId() {
		return clearingReasonId;
	}


	public void setClearingReasonId(Long clearingReasonId) {
		this.clearingReasonId = clearingReasonId;
	}


	public String getClearingStartDate() {
		return clearingStartDate;
	}


	public void setClearingStartDate(String clearingStartDate) {
		this.clearingStartDate = clearingStartDate;
	}


	public Long getContractAreaId() {
		return contractAreaId;
	}


	public void setContractAreaId(Long contractAreaId) {
		this.contractAreaId = contractAreaId;
	}


	public Long getStaffByClearingStartStaffId() {
		return staffByClearingStartStaffId;
	}


	public void setStaffByClearingStartStaffId(Long staffByClearingStartStaffId) {
		this.staffByClearingStartStaffId = staffByClearingStartStaffId;
	}


	public Long getCurrentStaffId() {
		return currentStaffId;
	}


	public void setCurrentStaffId(Long currentStaffId) {
		this.currentStaffId = currentStaffId;
	}


	public String getCurrentSiteAreas() {
		return currentSiteAreas;
	}


	public void setCurrentSiteAreas(String currentSiteAreas) {
		this.currentSiteAreas = currentSiteAreas;
	}


	public Timestamp getContinueEndDate() {
		return continueEndDate;
	}


	public void setContinueEndDate(Timestamp continueEndDate) {
		this.continueEndDate = continueEndDate;
	}


	public Contract getContract() {
		return contract;
	}


	public void setContract(Contract contract) {
		this.contract = contract;
	}


	public List<Agency> getAgencys() {
		return agencys;
	}


	public void setAgencys(List<Agency> agencys) {
		this.agencys = agencys;
	}


	public ContractBean getContractBean() {
		return contractBean;
	}


	public void setContractBean(ContractBean contractBean) {
		this.contractBean = contractBean;
	}


	public List<SiteArea> getSiteAreas() {
		return siteAreas;
	}


	public void setSiteAreas(List<SiteArea> siteAreas) {
		this.siteAreas = siteAreas;
	}


	public List<Contract> getContracts() {
		return contracts;
	}


	public void setContracts(List<Contract> contracts) {
		this.contracts = contracts;
	}


	public List<ContractArea> getContractAreas() {
		return contractAreas;
	}


	public void setContractAreas(List<ContractArea> contractAreas) {
		this.contractAreas = contractAreas;
	}


	public List<Staff> getStaffs() {
		return staffs;
	}


	public void setStaffs(List<Staff> staffs) {
		this.staffs = staffs;
	}


	public List<ClearingReason> getReasons() {
		return reasons;
	}


	public void setReasons(List<ClearingReason> reasons) {
		this.reasons = reasons;
	}


	public List<OperHis> getOpers() {
		return opers;
	}


	public void setOpers(List<OperHis> opers) {
		this.opers = opers;
	}


	public String getAreaNoAll() {
		return areaNoAll;
	}


	public void setAreaNoAll(String areaNoAll) {
		this.areaNoAll = areaNoAll;
	}


	public List<String> getAreaNos() {
		return areaNos;
	}


	public void setAreaNos(List<String> areaNos) {
		this.areaNos = areaNos;
	}


	public ContractService getContractService() {
		return contractService;
	}


	public void setContractService(ContractService contractService) {
		this.contractService = contractService;
	}


	public SiteAreaService getSiteAreaService() {
		return siteAreaService;
	}


	public void setSiteAreaService(SiteAreaService siteAreaService) {
		this.siteAreaService = siteAreaService;
	}


	public String getNormalContinueStartDate() {
		return normalContinueStartDate;
	}


	public void setNormalContinueStartDate(String normalContinueStartDate) {
		this.normalContinueStartDate = normalContinueStartDate;
	}


	public File getFileObj() {
		return fileObj;
	}


	public void setFileObj(File fileObj) {
		this.fileObj = fileObj;
	}


	public String getLocalFileName() {
		return localFileName;
	}


	public void setLocalFileName(String localFileName) {
		this.localFileName = localFileName;
	}


	public Long getPicId() {
		return picId;
	}


	public void setPicId(Long picId) {
		this.picId = picId;
	}


	public Pic getPic() {
		return pic;
	}


	public void setPic(Pic pic) {
		this.pic = pic;
	}


	public String getContractView() {
		return contractView;
	}


	public void setContractView(String contractView) {
		this.contractView = contractView;
	}


	public Long getAgencyId() {
		return agencyId;
	}


	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}
}