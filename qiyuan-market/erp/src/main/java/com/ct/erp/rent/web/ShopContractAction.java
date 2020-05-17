package com.ct.erp.rent.web;

import java.io.File;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.ClearingReason;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.ContractCollectionPlan;
import com.ct.erp.lib.entity.ContractShop;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.ShopContract;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.dao.ContractCollectionPlanDao;
import com.ct.erp.rent.model.ContractBean;
import com.ct.erp.rent.model.ContractCollectionPlanBean;
import com.ct.erp.rent.model.DepositBean;
import com.ct.erp.rent.model.ShopContractBean;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.rent.service.ContractCollectionplanService;
import com.ct.erp.rent.service.ContractListService;
import com.ct.erp.rent.service.ContractShopService;
import com.ct.erp.rent.service.PicService;
import com.ct.erp.rent.service.ShopContractService;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.util.log.LogUtil;

/**
 * @author Administrator
 *
 */
@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.shopContractAction")
public class ShopContractAction {
	private List<Agency> agencys = new ArrayList<Agency>();
	private ContractBean contractBean = new ContractBean();
	private List<ContractShop> contractShops = new ArrayList<ContractShop>();
	private Long picId;
	private Long shopContractId;
	private ShopContract shopContract = new ShopContract();
	private Pic pic;
	private File fileObj;
	private String localFileName;
	private String flag;
	private List<OperHis> opers=new ArrayList<OperHis>();
	private List<Staff> staffs = new ArrayList<Staff>();
	private Long staffId;
	private String recvDate;
	private String recvEnddate;
	private ContractCollectionPlan collectionPlan = new ContractCollectionPlan();
	private Long planId;
	private ShopContractBean shopContractBean;
	private ContractCollectionPlanBean contractCollectionPlanBean;
	private int payedDepositFee;
	private int shellDepositFee;
	private List<ClearingReason> reasons = new ArrayList<ClearingReason>();
	private Long currentStaffId;
	private String currDate;
	private Staff staff = new Staff();
	private int depositFee;
	private Double actualFee;
	private Agency agency = new Agency();
	private Long agencyId;
	private DepositBean depositBean;
	private String contractView;
	
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private ShopContractService shopContractService;
	@Autowired
	private ContractShopService contractShopService;
	@Autowired
	private PicService picService;
	@Autowired
	private StaffService staffService;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private ContractCollectionPlanDao contractCollectionPlanDao;
	@Autowired
	private ContractCollectionplanService contractCollectionplanService;
	@Autowired
	private ContractListService contractListService;

	/**
	 * to新增合同
	 * 
	 * @return
	 */
	public String toAddContract() {
		agencys = this.agencyService.findValidAgencyList();
		return "toAddContract";
	}

	/**
	 * 新增合同
	 * 
	 * @return
	 */
	public String addContract() {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			shopContractService.addContract(contractBean, contractShops, picId);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			LogUtil.logError(this.getClass(), "Error in addContract method!", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
		return null;
	}

	/**
	 * to修改合同
	 * 
	 * @return
	 */
	public String toeditContract() {
		try {
			agencys = this.agencyService.findValidAgencyList();
			shopContract = this.shopContractService.findById(shopContractId);
			pic = this.picService.findByShopContractId(shopContractId);
			contractShops = this.contractShopService
					.findContractShopsByContractId(shopContract.getId());
		} catch (Exception e) {
			LogUtil.logError(this.getClass(), "Error in toeditContract method!", e);
		}
		return "toAddContract";
	}

	/**
	 * 上传商户合同图片
	 * 
	 * @throws Exception
	 */
	public void upload() throws Exception {

		HttpServletResponse response = ServletActionContext.getResponse();
		String resStr = "";
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			Long staffId = sessionInfo.getStaffId();
			Staff staff = staffService.findById(staffId);
			resStr = this.shopContractService.upload(0L, staff, fileObj,
					this.localFileName);
		} catch (Exception ex) {
			LogUtil.logError(this.getClass(), "Error in upload method!", ex);
			resStr = "0";
		}
		UcmsWebUtils.ajaxOutPut(response, resStr);
	}

	/**
	 *  合同详情
	 * @return
	 */
	public String toDetailContractPage() {
		shopContract = this.shopContractService.findById(shopContractId);
		pic = this.picService.findByShopContractId(shopContractId);
		contractShops = this.contractShopService
				.findContractShopsByContractId(shopContract.getId());
		opers = operHisDao.findHisListByObjIdAndTag(shopContractId, Const.SHOP_CONTRACT);
		return "toDetailContractPage";
	}
	
	/**
	 * 合同收款界面
	 * @return
	 */
	public String toRectFeePage() {
		if(shopContractId==null){
			return null;
		}
		recvDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		shopContract = shopContractService.findById(shopContractId);
		shopContractBean = new ShopContractBean(shopContract);
		recvEnddate = shopContractService.getAsOfDate(shopContract);
		List<ContractCollectionPlan> plans = this.contractCollectionplanService.findByShopContractId(shopContractId);
		payedDepositFee = 0;
		for(ContractCollectionPlan plan : plans){
			payedDepositFee += plan.getRecvDeposit() == null ? 0 : plan.getRecvDeposit()/100;
		}
		shellDepositFee = shopContract.getDepositFee()/100-payedDepositFee;
		staffs = staffService.findAll();
		staffId = SecurityUtils.getCurrentSessionInfo().getStaffId();
		this.collectionPlan = this.contractCollectionPlanDao.get(this.planId);
		return "toRectFeePage";
	}
	
	/**
	 * 合同收款
	 * @return
	 */
	public String doRecvFee(){
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			contractCollectionplanService.collection(contractCollectionPlanBean,shopContractId);
			UcmsWebUtils.ajaxOutPut(response,"success");
		} catch (Exception e) {
			e.printStackTrace();
			UcmsWebUtils.ajaxOutPut(response, "error");
			LogUtil.logError(this.getClass(), "error in doRecvFee", e);
		}
		return null;
	}
	
	/**
	 * 合同作废界面
	 * @return
	 */
	public String toContractBackPage(){
		recvDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		return "toContractBackPage";
	}
	
	/**
	 * 合同作废
	 * @return
	 */
	public String doContractBack(){
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			shopContract = shopContractService.findById(shopContractId);
			//合同退回改变合同状态（作废106）
			shopContract.setState(Const.TERMINATED);
			shopContract.setBackDesc(contractBean.getBackDesc());
			shopContract.setBackTime(UcmsWebUtils.striToTimestamp(contractBean.getBackTime()));
			String operDesc = "合同退回,退回原因："+shopContract.getBackDesc();
			shopContract.setUpdateTime(UcmsWebUtils.now());
			shopContractService.contractBack(shopContract, operDesc,"1");
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			e.printStackTrace();
			if(!(e instanceof ServiceException)){
				UcmsWebUtils.ajaxOutPut(response, "error");
			}else{
				UcmsWebUtils.ajaxOutPut(response, e.getMessage());
			}
		}
		return null;
	}
	
	
	/**
	 * 合同清算界面
	 * @return
	 */
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
			this.shopContractService.contractCount(shopContractId,contractBean);
				
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
	
	/**
	 * 合同押金结算
	 * @return
	 */
	public String toClear() {
		Long staffId = SecurityUtils.getCurrentSessionInfo().getStaffId();
		Date dt = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		this.currDate = sdf.format(dt);
		this.staff = staffService.findById(staffId);
		this.shopContract = this.shopContractService.findById(this.shopContractId);
		this.depositFee = this.shopContract.getDepositFee();
		this.staffs = staffService.findAll();
		this.actualFee = (double) this.depositFee;
		this.agency = agencyService.findById(this.agencyId);
		return "deposit_toclear";
	}
	
	/**
	 * 合同押金结算
	 * @return
	 */
	public String clearContract() {
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try {
			out = response.getWriter();
			this.shopContractService.clearContract(this.depositBean,this.shopContract);
			out.print("success");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		return null;
	}
	
	
	/**
	 * 合同续签
	 * @return
	 */
	public String toContinueContractPage(){
		this.contractView = "CONTINUE";
		ShopContract cont =this.shopContractService.findById(shopContractId);
		agencys.add(cont.getAgency());
		shopContract = new ShopContract();
		shopContract.setAgency(cont.getAgency());
		Date endDate=new Date(cont.getEndDate().getTime());
		Calendar cal = Calendar.getInstance();
		cal.setTime(endDate);
		cal.add(Calendar.YEAR, 1);
		shopContract.setEndDate(new Timestamp(cal.getTimeInMillis()));
		shopContract.setAgency(cont.getAgency());
		cal.setTime(endDate);
		cal.add(Calendar.DATE, 1);
		shopContract.setStartDate(new Timestamp(cal.getTimeInMillis()));
		return "toAddContract";
	}
	
	/**
	 * 签订合同界面
	 * @return
	 */
	public String toContractSignReg(){
		Agency agency = this.agencyService.findById(this.agencyId);
		this.agencys = this.agencyService.findValidAgencyList();
		this.shopContract.setAgency(agency);
		return "toAddContract";
	}
	
	

	public ShopContractBean getShopContractBean() {
		return shopContractBean;
	}

	public void setShopContractBean(ShopContractBean shopContractBean) {
		this.shopContractBean = shopContractBean;
	}

	public ContractCollectionPlanBean getContractCollectionPlanBean() {
		return contractCollectionPlanBean;
	}

	public void setContractCollectionPlanBean(
			ContractCollectionPlanBean contractCollectionPlanBean) {
		this.contractCollectionPlanBean = contractCollectionPlanBean;
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

	public List<ContractShop> getContractShops() {
		return contractShops;
	}

	public void setContractShops(List<ContractShop> contractShops) {
		this.contractShops = contractShops;
	}

	public Long getPicId() {
		return picId;
	}

	public void setPicId(Long picId) {
		this.picId = picId;
	}

	public Long getShopContractId() {
		return shopContractId;
	}

	public void setShopContractId(Long shopContractId) {
		this.shopContractId = shopContractId;
	}

	public ShopContract getShopContract() {
		return shopContract;
	}

	public void setShopContract(ShopContract shopContract) {
		this.shopContract = shopContract;
	}

	public Pic getPic() {
		return pic;
	}

	public void setPic(Pic pic) {
		this.pic = pic;
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

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public List<OperHis> getOpers() {
		return opers;
	}

	public void setOpers(List<OperHis> opers) {
		this.opers = opers;
	}

	public List<Staff> getStaffs() {
		return staffs;
	}

	public void setStaffs(List<Staff> staffs) {
		this.staffs = staffs;
	}

	public Long getStaffId() {
		return staffId;
	}

	public void setStaffId(Long staffId) {
		this.staffId = staffId;
	}

	public String getRecvDate() {
		return recvDate;
	}

	public void setRecvDate(String recvDate) {
		this.recvDate = recvDate;
	}

	public String getRecvEnddate() {
		return recvEnddate;
	}

	public void setRecvEnddate(String recvEnddate) {
		this.recvEnddate = recvEnddate;
	}

	public ContractCollectionPlan getCollectionPlan() {
		return collectionPlan;
	}

	public void setCollectionPlan(ContractCollectionPlan collectionPlan) {
		this.collectionPlan = collectionPlan;
	}

	public Long getPlanId() {
		return planId;
	}

	public void setPlanId(Long planId) {
		this.planId = planId;
	}

	public int getPayedDepositFee() {
		return payedDepositFee;
	}

	public void setPayedDepositFee(int payedDepositFee) {
		this.payedDepositFee = payedDepositFee;
	}

	public int getShellDepositFee() {
		return shellDepositFee;
	}

	public void setShellDepositFee(int shellDepositFee) {
		this.shellDepositFee = shellDepositFee;
	}

	public List<ClearingReason> getReasons() {
		return reasons;
	}

	public void setReasons(List<ClearingReason> reasons) {
		this.reasons = reasons;
	}

	public Long getCurrentStaffId() {
		return currentStaffId;
	}

	public void setCurrentStaffId(Long currentStaffId) {
		this.currentStaffId = currentStaffId;
	}

	public String getCurrDate() {
		return currDate;
	}

	public void setCurrDate(String currDate) {
		this.currDate = currDate;
	}

	public Staff getStaff() {
		return staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public int getDepositFee() {
		return depositFee;
	}

	public void setDepositFee(int depositFee) {
		this.depositFee = depositFee;
	}

	public Double getActualFee() {
		return actualFee;
	}

	public void setActualFee(Double actualFee) {
		this.actualFee = actualFee;
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

	public DepositBean getDepositBean() {
		return depositBean;
	}

	public void setDepositBean(DepositBean depositBean) {
		this.depositBean = depositBean;
	}

	public String getContractView() {
		return contractView;
	}

	public void setContractView(String contractView) {
		this.contractView = contractView;
	}

}
