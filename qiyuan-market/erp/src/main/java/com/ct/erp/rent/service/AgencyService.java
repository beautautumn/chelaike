package com.ct.erp.rent.service;

import java.io.File;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.aliyun.oss.OSSClient;
import com.cloudtrend.erprocks.dao.StaffDAO;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.AgencyOrder;
import com.ct.erp.lib.entity.AgencySync;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.AgencyOrderDao;
import com.ct.erp.rent.dao.ContractDao;
import com.ct.erp.rent.model.DepositBean;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.task.dao.AgencySyncDao;
import com.ct.erp.util.UcmsWebUtils;
import com.tianche.common.AliUpload;

@Service
public class AgencyService  {
	@Autowired
	private AgencyDao agencyDao;

	@Autowired
	private PicService picService;
	
	@Autowired
	private StaffDao staffDao;
	
	@Autowired
	private StaffService staffService;
	
	@Autowired
	private OperHisDao operHisDao;
	
	@Autowired
	private AgencySyncDao agencySyncDao;

	@Autowired
  private AgencyOrderDao agencyOrderDao;
	
	@Autowired
	private ContractDao contractDao;

	
	public Agency findById(Long agencyId) {
		return agencyDao.get(agencyId);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void update(Agency agency) {
		agencyDao.update(agency);
	}

	public List<Agency> findAll(){
		return agencyDao.findAll();
	}
	public List<Agency> findExistAgency(){
		return agencyDao.findExistAgency();
	}
	/**
	 * 通过名字找启用的商户
	 * @return
	 */
	public Agency findByName(String agencyName){
		return agencyDao.findByName(agencyName);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void update(Agency agency,DepositBean depositBean,Contract contract) throws Exception{
		OperHis operHis=new OperHis();
		/*Agency ag = this.findById(agency.getId());
		ag.setLeaveType(agency.getLeaveType());
		if(agency.getBreachDesc()!=null){
			ag.setBreachDesc(agency.getBreachDesc());
		}*/
		/*ag.setUpdateTime(UcmsWebUtils.now());*/
		/*ag.setState("106");*/
		/*this.agencyDao.update(ag);*/
		Contract ct = this.contractDao.findById(contract.getId());
		ct.setBackDepositFee(UcmsWebUtils.yuanTofen(depositBean.getBackDepositFee()));
		ct.setClearingEndDate(UcmsWebUtils.striToTimestamp(depositBean.getSettlementDate()));
		ct.setStaffByClearingStaff(staffDao.findById(depositBean.getSettlementStaffId()));
		ct.setClearedDesc(contract.getClearedDesc());
		ct.setState(Const.TERMINATED);
		ct.setUpdateTime(UcmsWebUtils.now());
		this.contractDao.update(ct);
		
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("2");
		operHis.setOperTime(UcmsWebUtils.now());
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"清算了合同押金（合同编号："+contract.getId()+"）");
		operHis.setOperObj(ct.getId());
		this.operHisDao.save(operHis);
	}


	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void save(Agency agency,List<Long> picIdList) {
		if(agency==null){
			return ;
		}		
		OperHis operHis=new OperHis();
		agency.setStatus("1");
		agency.setState("101");
		agency.setBidPriceTag("1");
		agency.setAccount(agency.getUserPhone());
		agency.setPwd(agency.getUserPhone());
		agency.setCreateTime(UcmsWebUtils.now());
		agency.setUpdateTime(UcmsWebUtils.now());
		agency=agencyDao.save(agency);

    //网站排名
    AgencyOrder agencyOrder = new AgencyOrder();
    agencyOrder.setShowOrder(agency.getId().intValue());
    AgencyOrder ao = agencyOrderDao.save(agencyOrder);
		agency.setAgencyOrder(ao);
		agencyDao.update(agency);
		
		
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("2");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"新增了商户:"+agency.getAgencyName());
		operHis.setOperObj(agency.getId());
		this.operHisDao.save(operHis);
		/*AgencySync agencySync = new AgencySync();
		agencySync.setAgency(agency);
		agencySync.setState(Const.SYNC_STATE_UNSYNC);
		agencySync.setStatus(Const.SYNC_STATE_CAN);
		agencySync.setSyncNum(Const.SYNC_NUM);
		agencySync.setCreateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		this.agencySyncDao.save(agencySync);*/

		if(picIdList.size() == 0){
			return;
		}
		for(Long picId : picIdList){
			Pic pic = this.picService.findPicById(picId);
			pic.setObjId(agency.getId());
			pic.setPicType("0");
			pic.setShowTag("1");
			this.picService.update(pic);
		}
	}
	
	
	
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void update(Long agencyId,List<Long> picIdList,Agency agency) {
		if(agencyId==null){
			return ;
		}
		OperHis operHis=new OperHis();
		Agency agencyUp = this.findById(agencyId);
		agencyUp.setAgencyName(agency.getAgencyName());
		agencyUp.setRemark(agency.getRemark());
		agencyUp.setUserName(agency.getUserName());
		agencyUp.setUserPhone(agency.getUserPhone());
		agencyUp.setUpdateTime(UcmsWebUtils.now());
		this.update(agencyUp);
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("2");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"修改了商户:"+agency.getAgencyName());
		operHis.setOperObj(agencyUp.getId());
		this.operHisDao.save(operHis);
		if(picIdList.size() == 0){
			return;
		}
		for(Long picId : picIdList){
			Pic pic = this.picService.findPicById(picId);
			pic.setObjId(agencyId);
			pic.setPicType("0");
			pic.setShowTag("1");
			this.picService.update(pic);
		}
	}
	

	/*private String doUploadFile(String results[], Staff staff, Long objId)
			throws Exception {
		Pic Pic = picService.doSaveUploadEntity(results[0],
				staff, results[1], results[2], objId,
				Const.IMAGE_TYPE_STORE_PIC,"0");
		JSONObject json = new JSONObject();
		json.put("picId", Pic.getId());
		json.put("smallPicAddr", results[2]);
		return json.toString();
	}*/
	private String doUploadFile(String newFileName, Staff staff,String picUrl,String smallPicUrl, Long objId)
			throws Exception {
		Pic Pic = picService.doSaveUploadEntity(newFileName,
				staff, picUrl, smallPicUrl, objId,
				Const.IMAGE_TYPE_STORE_PIC,"0");
		JSONObject json = new JSONObject();
		json.put("picId", Pic.getId());
		json.put("smallPicAddr", smallPicUrl);
		return json.toString();
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String upload(Long objId, Staff staff, File fileObj,String localFileName) throws Exception {
		if (staff == null)
		{
			return "{}";
		}
		/*String results[] = this.picService.doUploadFileStream(fileObj,localFileName, Const.IMAGE_TYPE_STORE_PIC);
		if (results != null){
			return doUploadFile(results, staff, objId);
		}*/ 
		OSSClient client = AliUpload.getOSSClient(Const.endpoint, Const.accessKeyId, Const.accessKeySecret);
		String newFileName = AliUpload.easyPutObj(localFileName,Const.vehicleBucket,fileObj,client);
		String picUrl = "http://"+Const.vehicleBucket+Const.img_url+newFileName;
		String smallPicUrl = "http://"+Const.vehicleBucket+Const.img_url+newFileName+Const.img_agency_size;
		if (newFileName != null){
			return doUploadFile(newFileName, staff,picUrl,smallPicUrl, objId);
		}else{
			return "{}";
		}
	}
	/*@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void clearAgency (String agencyId,String staffId,
			String endDate,String clearingDesc)throws Exception{
		try {
			Agency agency = agencyDao.get(Long.parseLong(agencyId));
			agency.setClearingEndDate(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(endDate).getTime()));
			agency.setClearingDesc(clearingDesc);
			agency.setStaffByClearingStaff(staffDao.findById(Long.parseLong(staffId)));
			agency.setState("105");
			agencyDao.update(agency);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}*/
	/*@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void leaveAgency(String agencyId,String leaveDate,
			String staffId,String leaveDesc){
		 try {
			Agency agency = agencyDao.get(Long.parseLong(agencyId));
			agency.setLeaveDesc(leaveDesc);
			agency.setLeaveDate(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(leaveDate).getTime()));
			agency.setStaffByLeaveStaff(staffDao.findById(Long.parseLong(staffId)));
			agencyDao.update(agency);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}*/

	public AgencyDao getAgencyDao() {
		return agencyDao;
	}

	public void setAgencyDao(AgencyDao agencyDao) {
		this.agencyDao = agencyDao;
	}

	public PicService getPicService() {
		return picService;
	}

	public void setPicService(PicService picService) {
		this.picService = picService;
	}
	
	public List<Agency> findByState(String state){
		return agencyDao.findByState(state);
	}

	public List<Agency> findByConditionState1(String state1,String state2,String state3) {
		return this.agencyDao.findByConditionState(state1,state2,state3);
	}

	public List<Agency> findValidAgencyList(){
		return this.agencyDao.findValidAgencyList();
	}
	
	public List<Agency> findValidAgenciesWithOutOne(Long agencyId){
		return this.agencyDao.findValidAgenciesWithOutOne(agencyId);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void deleteAgen(Long agencyId) {
		Agency agency = this.agencyDao.findById(agencyId);
		agency.setStatus("0");
		this.agencyDao.update(agency);
	}

	public List<Agency> findByAccount(String account) {
		return this.agencyDao.findByProperty("account", account);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void outAgency(Agency agency) {
		OperHis operHis=new OperHis();
		Agency ag = this.findById(agency.getId());
		ag.setLeaveType(agency.getLeaveType());
		if(agency.getBreachDesc()!=null){
			ag.setBreachDesc(agency.getBreachDesc());
		}
		ag.setLeaveDate(agency.getLeaveDate());
		ag.setLeaveDesc(agency.getLeaveDesc());
		ag.setStaff(agency.getStaff());
		ag.setUpdateTime(UcmsWebUtils.now());
		ag.setState(Const.ALREADY_OUT);
		this.agencyDao.update(ag);
		List<Contract> contractList = this.contractDao.findByAgencyId(ag.getId());
		if(contractList.size()>0){
			throw new ServiceException("请先清算该商户合同");
		}
		
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("2");
		operHis.setOperTime(UcmsWebUtils.now());
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"操作了"+ag.getAgencyName()+"离场");
		operHis.setOperObj(ag.getId());
		this.operHisDao.save(operHis);
	}

	public List<Agency> findValidAgencyList(Long marketId) {
		return this.agencyDao.findValidAgencyList(marketId);
	}
}
