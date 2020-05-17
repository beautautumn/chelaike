package com.ct.erp.rent.web;


import java.io.File;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import org.apache.commons.lang3.StringUtils;
import javax.servlet.http.HttpServletResponse;
import java.util.Random;

import com.ct.erp.lib.entity.Market;
import com.ct.erp.market.dao.MarketDao;
import com.ct.erp.rent.dao.AgencyDao;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.chelaike.service.CheLaiKeAPIService;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.model.Result;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.rent.service.PicService;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.util.log.LogUtil;
import com.ct.erp.util.DataSync;


@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.AgencyManageAction")
public class AgencyManageAction extends SimpleActionSupport {
	private String agencyName;
	private Agency agency;
	private Long agencyId;
	private Long oldPicId;
	private File fileObj;
	private String localFileName;
	private String storeLogoSmallSrc;
	private Long picId;
	private Pic pic;
	private List<Pic> listPic = new ArrayList<Pic>();
	private List<Long> picIdList = new ArrayList<Long>();
	private String account;
	private List<Staff> staffList = new ArrayList<Staff>();
	private String currDate;

	private String name;
	private String phone;
	
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private StaffService staffService;
	@Autowired
	private PicService picService;
	
	@Autowired
	private CheLaiKeAPIService cheLaiKeAPIService;

	@Autowired
	private MarketDao marketDao;

	@Autowired
	private AgencyDao agencyDao;
	@Autowired
	private DataSync dataSync;

	public void quickAdd() {
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		if (sessionInfo.getMarketId() == null) {
			Result result = new Result(Result.ERROR, "非市场员工不允许创建车商账号", null);
			Struts2Utils.renderJson(result);
			return;
		}
		List<Staff> staffs = staffService.findByLoginName(phone);
		if(staffs != null && staffs.size() > 0){
			Result result = new Result(Result.ERROR, "电话号码重复，不允许已此电话创建车商", null);
			Struts2Utils.renderJson(result);
			return;
		}
		Random random = new Random();
		String agencyName = name + String.valueOf(100000 + random.nextInt(899999));
		Timestamp current = Timestamp.valueOf(LocalDateTime.now());
		Market market = marketDao.load(sessionInfo.getMarketId());

		Agency agency = new Agency(agencyName, name, phone, "1", current, "1");
		agency.setMarket(market);
		agencyDao.save(agency);

		dataSync.publishToRuby("shop_sync", agency.getId().toString());

		Result result = new Result(Result.SUCCESS, "创建成功", null);
		Struts2Utils.renderJson(result);
	}
	public String view(){
		return null;
	}
	
	public String checkName(){
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		if(this.agencyName==null){
			return null;
		}else{
			try{
				out = response.getWriter();
				Agency checkAgency = this.agencyService.findByName(this.agencyName);
				if(checkAgency!=null && checkAgency.getId().longValue() != this.agencyId){
					out.print("fail");
					out.close();
				}else{
					out.print("ok");
					out.close();
				}
			}catch (Exception e) {
				e.printStackTrace();
				out.print("error");
			}
		}
		return null;
	}
	
	
	public void checkAccount(){
		HttpServletResponse response = ServletActionContext.getResponse();
		List<Agency> agency = this.agencyService.findByAccount(this.account);
		if(agency.size()==0){
			UcmsWebUtils.ajaxOutPut(response, "success");
		}else{
			UcmsWebUtils.ajaxOutPut(response, "false");
		}
	}
	
	public String delete(){
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		if(this.oldPicId==null){
			return null;
		}else{
			try{
				out = response.getWriter();
				this.picService.doDelUploadEntity(this.oldPicId);
				out.print("success");
				out.close();
			}catch (Exception e) {
				e.printStackTrace();
				out.print("error");
			}
		}
		return null;
	}
	
	public String chgPwd(){
		this.agency = this.agencyService.findById(this.agencyId);
		return "changePwd";
	}
	
	public void doChgPwd(){
		HttpServletResponse response = ServletActionContext.getResponse();
		Agency agency = this.agencyService.findById(this.agencyId);
		agency.setPwd(this.agency.getPwd());
		try{
			this.agencyService.update(agency);
			UcmsWebUtils.ajaxOutPut(response, "success");
		}catch(Exception e){
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
		
	}
	
	public String toAdd(){
		return "agency_add";
	}
	
	public String add(){
		HttpServletResponse response = ServletActionContext.getResponse();
    try{
    	Agency agency = this.agencyService.findByName(this.agency.getAgencyName());
    	if(agency==null){
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			Long marketId = sessionInfo.getMarketId();
			Market market = marketDao.get(marketId);
			this.agency.setMarket(market);
	        this.agencyService.save(this.agency,this.picIdList);
//	        this.cheLaiKeAPIService.registUser(this.agency);
	        UcmsWebUtils.ajaxOutPut(response, "success");
    	}else{
    		UcmsWebUtils.ajaxOutPut(response, "overlap");
    	}
    }catch (RuntimeException e) {
        e.printStackTrace();
        UcmsWebUtils.ajaxOutPut(response, e.getMessage());
    }catch (Exception e) {
      UcmsWebUtils.ajaxOutPut(response, "error");
    }
		return null;
	}
	
	public String toUpdate(){
	  this.agency = this.agencyService.findById(this.agencyId);
    this.listPic = this.picService.findPicByObjId(this.agency.getId());
    return "agency_update";
	}
	
	public void update(){
		HttpServletResponse response = ServletActionContext.getResponse();
	  try{
      this.agencyService.update(this.agencyId,this.picIdList,this.agency);
      UcmsWebUtils.ajaxOutPut(response, "success");
    }catch (Exception e) {
      e.printStackTrace();
      UcmsWebUtils.ajaxOutPut(response, "error");
    }
	}
	
	public void upload() throws Exception {
		HttpServletResponse response = ServletActionContext.getResponse();
		String resStr = "";
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			Long staffId = sessionInfo.getStaffId();
			Staff staff = staffService.findById(staffId);
			resStr=this.agencyService.upload(0L,staff, fileObj, this.localFileName);
		} catch (Exception ex) {
			LogUtil.logError(this.getClass(), "Error in upload method!", ex);
			resStr = "0";
		}
		UcmsWebUtils.ajaxOutPut(response, resStr);
	}
	
	
	public void deleteAgen(){
		Result result  =null;
		try{
			this.agencyService.deleteAgen(this.agencyId);
			result = new Result(Result.SUCCESS, "操作成功!", null);
			Struts2Utils.renderJson(result);
		}catch(Exception e){
			result = new Result(Result.ERROR, "操作失败!", null);
			Struts2Utils.renderJson(result);
		}
	}
	
	public String toOutAgency(){
		this.agency = this.agencyService.findById(this.agencyId);
		this.staffList = staffService.findAll();
		Date dt = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		this.currDate = sdf.format(dt);
		return "outAgency";
	}
	
	/**
	 * 商户离场
	 */
	public void doOutAgency(){
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			this.agencyService.outAgency(this.agency);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			if(!(e instanceof ServiceException)){
				LogUtil.logError(this.getClass(), "Error in upload method!", e);
				UcmsWebUtils.ajaxOutPut(response, "error");
			}else{
				UcmsWebUtils.ajaxOutPut(response, e.getMessage());
			}
		}
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

	public AgencyService getAgencyService() {
		return agencyService;
	}

	public void setAgencyService(AgencyService agencyService) {
		this.agencyService = agencyService;
	}

	public StaffService getStaffService() {
		return staffService;
	}

	public void setStaffService(StaffService staffService) {
		this.staffService = staffService;
	}

	public String getStoreLogoSmallSrc() {
		return storeLogoSmallSrc;
	}

	public void setStoreLogoSmallSrc(String storeLogoSmallSrc) {
		this.storeLogoSmallSrc = storeLogoSmallSrc;
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

	public PicService getPicService() {
		return picService;
	}

	public void setPicService(PicService picService) {
		this.picService = picService;
	}

	public Long getOldPicId() {
		return oldPicId;
	}

	public void setOldPicId(Long oldPicId) {
		this.oldPicId = oldPicId;
	}

	public List<Pic> getListPic() {
		return listPic;
	}

	public void setListPic(List<Pic> listPic) {
		this.listPic = listPic;
	}

	public List<Long> getPicIdList() {
		return picIdList;
	}

	public void setPicIdList(List<Long> picIdList) {
		this.picIdList = picIdList;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public List<Staff> getStaffList() {
		return staffList;
	}

	public void setStaffList(List<Staff> staffList) {
		this.staffList = staffList;
	}

	public String getCurrDate() {
		return currDate;
	}

	public void setCurrDate(String currDate) {
		this.currDate = currDate;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
}