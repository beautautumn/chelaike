package com.ct.erp.carin.service;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.aliyun.oss.OSSClient;
import com.aliyun.oss.model.ObjectMetadata;
import com.ct.erp.carin.dao.ApproveDao;
import com.ct.erp.carin.dao.CarOperHisDao;
import com.ct.erp.carin.dao.CheckOutDao;
import com.ct.erp.carin.dao.TradeDao;
import com.ct.erp.carin.dao.VehicleEquipDao;
import com.ct.erp.che3bao.dao.VehiclePicDao;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.service.CommonService;
import com.ct.erp.common.utils.SysUtils;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Approve;
import com.ct.erp.lib.entity.CarOperHis;
import com.ct.erp.lib.entity.Carport;
import com.ct.erp.lib.entity.CheckOut;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.PublishInfo;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;
import com.ct.erp.lib.entity.VehicleEquip;
import com.ct.erp.lib.entity.VehiclePic;
import com.ct.erp.loan.dao.VehicleDao;
import com.ct.erp.publish.dao.PublishInfoDao;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.CarportDao;
import com.ct.erp.rent.dao.PicDao;
import com.ct.erp.rent.service.PicService;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.task.dao.VehicleSyncDao;
import com.ct.erp.util.CommUtils;
import com.ct.erp.util.UcmsWebUtils;
import com.tianche.common.AliUpload;

import net.sf.json.JSONObject;
import sun.misc.BASE64Decoder;


@Service
public class TradeInfoService{

	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private PicDao picDao;
	@Autowired
	private VehiclePicDao vehiclePicDao;
	@Autowired	
	private TradeDao tradeDao;
	@Autowired
	private AgencyDao agencyDao;
	@Autowired	
	private VehicleDao vehicleDao;
	@Autowired	
	private CarportDao carportDao;
	@Autowired
	private CarOperHisDao carOperHisDao;
  @Autowired
  private StaffService staffService;
	@Autowired
	private PicService picService;
	@Autowired
	private VehicleSyncDao vehicleSyncDao;
	@Autowired
	private ApproveDao approveDao;
	@Autowired
	private CommonService commonService;
	@Autowired
	private PublishInfoDao publishInfoDao;
	@Autowired
	private CheckOutDao checkOutDao;
	@Autowired
	private VehicleEquipDao vehicleEquipDao;
    
    
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doVehicleRegister(Trade trade,Vehicle vehicle,Long picId)throws Exception {
	   //保存车辆信息
	   vehicle.setUpdateTime(UcmsWebUtils.now());
     vehicle.setCreateTime(UcmsWebUtils.now());
	   Vehicle nVehicle = vehicleDao.save(vehicle);
	   //保存交易主表信息
	   trade.setState(Const.NEW_CAR_STR);
	   trade.setVehicle(nVehicle);
	   trade.setComeDate(UcmsWebUtils.now());
	   trade.setUpdateTime(UcmsWebUtils.now());
	   trade.setCreateTime(UcmsWebUtils.now());
  	 Trade nTrade = tradeDao.save(trade);
	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 商户 "+nTrade.getAgency().getAgencyName()+" 新登记了1辆车。");
	   operHis.setOperObj(nTrade.getId());
	   this.operHisDao.save(operHis);
	   
	   //如果上传了行驶证照片
	   if(picId!=null){
			  Pic pic=this.picDao.get(picId);
			  pic.setPicType("2");
			  pic.setObjId(nTrade.getId());
			  this.picDao.update(pic);
	   }
	}

	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doChgCarPort(Long tradeId,CarOperHis carOperHis1)throws Exception {
      
	   //保存交易主表信息
	   Trade trade =tradeDao.get(tradeId);
	   trade.setState(Const.DELETED_STR);
	   trade.setUpdateTime(UcmsWebUtils.now());
       tradeDao.update(trade);
   
	   //保存车位记录数信息
	   Carport carPort =carportDao.findByAgencyId(trade.getAgency().getId());
	   carPort.setUnusedNum(carPort.getUnusedNum()+1);
	   carPort.setUsedNum(carPort.getUsedNum()-1);
	   carportDao.update(carPort);
	   
	   
	   //保存车位历史表
	   CarOperHis carOperHis = new CarOperHis();
	   carOperHis.setAgency(trade.getAgency());
	   carOperHis.setStaff(carOperHis1.getStaff());
	   carOperHis.setOperTag("2");//0-入场;1-离场;2-手工调整
	   carOperHis.setBeforCount(carPort.getUnusedNum());
	   carOperHis.setAfterCount(carPort.getUnusedNum()+1);
	   carOperHis.setOperDesc(carOperHis1.getOperDesc());
	   carOperHis.setOperTime(carOperHis1.getOperTime());
	   carOperHisDao.save(carOperHis);
	   
	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(UcmsWebUtils.now());
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 手工调整了商户 "+trade.getAgency().getAgencyName()+"的库存，产生了一个空车位。");
	   operHis.setOperObj(trade.getId());
	   this.operHisDao.save(operHis);
	}	
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doChgOwnerAgency(Long tradeId,Long agencyId,CarOperHis his)throws Exception {
      
	   //保存交易主表信息
	   Trade trade =tradeDao.get(tradeId);
	   Agency agency =agencyDao.get(agencyId);
	   Agency oAgency=trade.getAgency();
	   trade.setAgency(agency);
	   trade.setUpdateTime(UcmsWebUtils.now());	   
     tradeDao.update(trade);
   
	   //保存车位记录数信息
     //转移前的商户的已用车位数-1
	   Carport carPort =carportDao.findByAgencyId(oAgency.getId());
	   carPort.setUnusedNum(carPort.getUnusedNum()+1);
	   carPort.setUsedNum(carPort.getUsedNum()-1);
	   carportDao.update(carPort);
	   
	   //保存车位历史表
	   CarOperHis carOperHis = new CarOperHis();
	   carOperHis.setAgency(oAgency);
	   carOperHis.setStaff(his.getStaff());
	   carOperHis.setOperTag("2");//0-入场;1-离场;2-手工调整
	   carOperHis.setBeforCount(carPort.getUnusedNum());
	   carOperHis.setAfterCount(carPort.getUnusedNum()-1);
	   carOperHis.setOperDesc(his.getOperDesc());
	   carOperHis.setOperTime(his.getOperTime());
	   carOperHisDao.save(carOperHis);
	   
	   //转移后的商户已用车位数+1
	   Carport nCarPort =carportDao.findByAgencyId(agency.getId());
	   nCarPort.setUnusedNum(nCarPort.getUnusedNum()-1);
	   nCarPort.setUsedNum(nCarPort.getUsedNum()+1);
	   carportDao.update(nCarPort);
	   
	   CarOperHis carOperHisN = new CarOperHis();
	   carOperHisN.setAgency(agency);
	   carOperHisN.setStaff(his.getStaff());
	   carOperHisN.setOperTag("2");//0-入场;1-离场;2-手工调整
	   carOperHisN.setBeforCount(nCarPort.getUnusedNum()+1);
	   carOperHisN.setAfterCount(nCarPort.getUnusedNum());
	   carOperHisN.setOperDesc(his.getOperDesc());
	   carOperHisN.setOperTime(his.getOperTime());
	   carOperHisDao.save(carOperHisN);	   
	   
	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(UcmsWebUtils.now());
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 手工从商户 "+oAgency.getAgencyName()+"调整了一辆车到商户"+agency.getAgencyName());
	   operHis.setOperObj(trade.getId());
	   this.operHisDao.save(operHis);
	}	

  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
  public void saveVehicleInput(Trade trade,Vehicle vehicle,Long picId)throws Exception {
    //保存车辆信息
    vehicle.setUpdateTime(UcmsWebUtils.now());
    vehicle.setCreateTime(UcmsWebUtils.now());
    if(vehicle.getBrand().getId()==null)
    	vehicle.setBrand(null);
    if(vehicle.getSeries().getId()==null)
    	vehicle.setSeries(null);
    if(vehicle.getKind().getId()==null)
    	vehicle.setKind(null);
    vehicle.setLicenseCode(trade.getOldLicenseCode());
    Vehicle nVehicle = vehicleDao.save(vehicle);
    //保存交易主表信息
    trade.setState(Const.WAITFOR_IN_STR);
    trade.setVehicle(nVehicle);
    trade.setComeDate(UcmsWebUtils.now());
    trade.setUpdateTime(UcmsWebUtils.now());
    trade.setCreateTime(UcmsWebUtils.now());
    Trade nTrade = tradeDao.save(trade);
    String barCode = SysUtils.createBarCode(nTrade.getId().toString());
    nTrade.setBarCode(barCode);
    this.tradeDao.update(nTrade);
    //操作历史
    OperHis operHis=new OperHis();    
    operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
    operHis.setOperTag("1");
    operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
    operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 商户 "+nTrade.getAgency().getAgencyName()+" 新登记了1辆车。");
    operHis.setOperObj(nTrade.getId());
    this.operHisDao.save(operHis);
    /*VehicleSync vSync = new VehicleSync();
    vSync.setTrade(trade);
    vSync.setState(Const.SYNC_STATE_UNSYNC);
    vSync.setCreateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
    this.vehicleSyncDao.save(vSync);*/
    this.commonService.barcodePic(barCode);
  } 

  
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void saveVehicleInfo(Trade trade,Vehicle vehicle,Long picId)throws Exception {
	   //保存车辆信息
     Vehicle v = vehicleDao.get(vehicle.getId());
     CommUtils.copyBean(vehicle, v);
     if(vehicle.getBrand().getId()!=null)
    	 v.setBrand(vehicle.getBrand());
     if(vehicle.getSeries().getId()!=null)
    	 v.setSeries(vehicle.getSeries());
     if(vehicle.getKind().getId()!=null)
    	 v.setKind(vehicle.getKind());
	   v.setUpdateTime(UcmsWebUtils.now());
	   v.setLicenseCode(trade.getOldLicenseCode());
     vehicleDao.save(v); 
	   //保存交易主表信息
     Trade t = tradeDao.get(trade.getId());
       t.setBarCode(trade.getBarCode());
	   t.setAcquPrice(trade.getAcquPrice());
	   t.setOldLicenseCode(trade.getOldLicenseCode());
	   t.setShowPrice(trade.getShowPrice());
	   t.setConsignTag(trade.getConsignTag());
	   t.setUpdateTime(UcmsWebUtils.now());
  	 Trade nTrade = tradeDao.save(t);
	   
	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(UcmsWebUtils.now());
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 为商户 "+trade.getAgency().getAgencyName()+" 更新了车辆");
	   operHis.setOperObj(trade.getId());
	   this.operHisDao.save(operHis);
		   
	   
	   //如果上传了行驶证照片
	   if(picId!=null){
			Pic pic=this.picDao.get(picId);
			pic.setObjId(nTrade.getId());
			this.picDao.update(pic);
	   }
	   /*VehicleSync vSync = this.vehicleSyncDao.findByTradeId(nTrade.getId());
	   if(vSync==null && nTrade.getState()==Const.WAITFOR_IN){
		   vSync = new VehicleSync();
		   vSync.setTrade(nTrade);
		   vSync.setState(Const.SYNC_STATE_UNSYNC);
		   vSync.setStatus(Const.SYNC_STATE_CAN);
		   vSync.setSyncNum(Const.SYNC_NUM);
		   vSync.setCreateTime(UcmsWebUtils.now());
		   this.vehicleSyncDao.save(vSync);
	   }*/
	}

  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
  public void doVehicleEntrance(Long tradeId)throws Exception {
     
    
     Trade nTrade = tradeDao.get(tradeId);
     /*Approve approve = nTrade.getApproveId() == null ? null : this.approveDao.get(nTrade.getApproveId());
     if(approve==null){*/
     	 if(nTrade.getBefOutState() != null && Const.VEHICLE_STOCK_STATE.contains(nTrade.getBefOutState())){
     		 nTrade.setState(nTrade.getBefOutState());
     	 }else{
     		 nTrade.setState(Const.NEW_CAR_STR);
     	 }
	     nTrade.setUpdateTime(UcmsWebUtils.now());
	     //nTrade.setApproveTag("0");
	     tradeDao.update(nTrade);
	     //保存车位记录数信息
	     Carport carPort =carportDao.findByAgencyId(nTrade.getAgency().getId());
	     carPort.setUnusedNum(carPort.getUnusedNum()-1);
	     carPort.setUsedNum(carPort.getUsedNum()+1);
	     carportDao.update(carPort);
	     
	     //保存车位历史表
	     CarOperHis carOperHis = new CarOperHis();
	     carOperHis.setAgency(nTrade.getAgency());
	     carOperHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	     carOperHis.setOperTag("0");//0-入场;1-离场;2-手工调整
	     carOperHis.setBeforCount(carPort.getUnusedNum());
	     carOperHis.setAfterCount(carPort.getUnusedNum()-1);
	     carOperHis.setOperDesc("");
	     carOperHis.setOperTime(UcmsWebUtils.now());
	     carOperHisDao.save(carOperHis);
     
	     //操作历史
	     OperHis operHis=new OperHis();    
	     operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	     operHis.setOperTag("1");
	     operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
	     operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 为商户 "+nTrade.getAgency().getAgencyName()+" 新入场了1辆车。");
	     operHis.setOperObj(nTrade.getId());
	     this.operHisDao.save(operHis);
     /*}else{
    	 nTrade.setApproveTag("0");
    	 approve.setLeaveState("2");
    	 this.tradeDao.update(nTrade);
    	 this.approveDao.update(approve);
     }*/
    
  }

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)	
	public String uploadVehiclePic(VehiclePic vehiclePic,File fileObj,String localFileName)throws Exception{
		OSSClient client = AliUpload.getOSSClient(Const.endpoint, Const.accessKeyId, Const.accessKeySecret);
		String newFileName = AliUpload.easyPutObj(localFileName,Const.vehicleBucket,fileObj,client);
		/*String results[] = picService.doUploadFileStream(fileObj,localFileName, Const.IMAGE_TYPE_VEHICLE_PIC);		
		vehiclePic.setPicUrl(results[1]);
		vehiclePic.setSmallPicUrl(results[2]);*/
		vehiclePic.setStatus("1");
		vehiclePic.setPublishTag("1");
		vehiclePic.setPicUrl("http://"+Const.vehicleBucket+Const.img_url+newFileName);
		vehiclePic.setSmallPicUrl("http://"+Const.vehicleBucket+Const.img_url+newFileName+Const.img_vehicle_size);
		VehiclePic nPic=vehiclePicDao.save(vehiclePic);
		JSONObject json = new JSONObject();
		json.put("picId", nPic.getId());
		json.put("smallPicAddr", nPic.getPicUrl());
		json.put("showOrder", nPic.getShowOrder());
		return json.toString();
		
	}
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)	
	public void delVehiclePics(String picIds)throws Exception{
		String ids[] = picIds.split(",");
		for (String id : ids) {
			VehiclePic pic = this.vehiclePicDao.get(Long.parseLong(id));
			pic.setStatus("0");
			this.vehicleDao.update(pic);//标记删除
		    //vehiclePicDao.deleteById(Long.parseLong(id));
		}	
	}
	
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)  
  public void doSaveFirstTranser(Trade trade)throws Exception{
    Trade nTrade=tradeDao.get(trade.getId());
    nTrade.setUpdateTime(UcmsWebUtils.now());
    nTrade.setState(Const.ACQU_TRANSFERED_STR);
    tradeDao.update(nTrade);
  }	
	
	
  
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)  
  public void doSaveSecondTranser(Trade trade)throws Exception{
    Trade nTrade=tradeDao.get(trade.getId());
    nTrade.setSaleTransferTag("1");
    nTrade.setUpdateTime(UcmsWebUtils.now());
    nTrade.setState(Const.SALE_TRANSFERED_STR);
    tradeDao.update(nTrade);
 
  } 
  
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
  public CheckOut doCheckOut(CheckOut checkOut,Trade t)throws Exception{
	 checkOut.setCreateTime(UcmsWebUtils.now());
     CheckOut co = checkOutDao.save(checkOut);
     t.setCheckId(co.getId());
     this.tradeDao.update(t);
     return co;
 
  }
  	
	
	
	public List<CarOperHis> getCarOperHis(Long agencyId) throws Exception{
		return carOperHisDao.getCarOperHisByAgencyId(agencyId);
	}
	
	public List<Trade> getTradeListByAgencyId(Long agencyId) throws Exception{
		return tradeDao.getTradeListByAgencyId(agencyId);
	}
	
	public List<VehiclePic> getPicListByTradeId(Long tradeId) throws Exception{
		return vehiclePicDao.getListByTradeId(tradeId);
	}
		
	public Trade getTradeById(Long tradeId) throws Exception{
		return tradeDao.get(tradeId);
	}
	
	public Carport getcarport(Long agencyId) throws Exception{
		return carportDao.findByAgencyId(agencyId);
	}	
	
	public Trade getTradeByBarCode(String barCode) throws Exception{
    return tradeDao.getTradeByBarCode(barCode);
  }

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doVehicleOutStock(Carport carport, Trade trade/*, Approve approve*/) {
		this.tradeDao.update(trade);
		this.carportDao.update(carport);
		//this.approveDao.update(approve);
	}


	public Trade getTradeByBCode(String barCode) {
		return tradeDao.getTradeByBCode(barCode);
	}
	public Trade getTradeBySCode(String shelfCode) {
		return tradeDao.getTradeBySCode(shelfCode);
	}
	public Trade getTradeByShelfCode(String shelfCode) {
		return tradeDao.getTradeByShelfCode(shelfCode);
	}


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void chgState(Long tradeId) throws Exception {
		Trade trade = getTradeById(tradeId);
		trade.setState(Const.NEW_CAR_STR);
		this.tradeDao.update(trade);
	}


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doUpDrive(Long tradeId, Long picId) {
		//如果上传了行驶证照片
		if(picId!=null){
			Pic pic=this.picDao.get(picId);
			pic.setObjId(tradeId);
			pic.setPicType(Const.DRIVE_PIC);
			this.picDao.update(pic);
		}
	}


	public Pic getPicByTradeId(Long tradeId) {
		return this.picDao.findPicByTradeId(tradeId);
	}


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void delVehicle(Long tradeId) {
		Trade trade = this.tradeDao.get(tradeId);
		Agency agency = trade.getAgency();
		Carport carport = this.carportDao.findByAgencyId(agency.getId());
		if(trade.getState()!= null && !trade.getState().equals("111") && !trade.getState().equals("112") && !trade.getState().equals("113")){
			carport.setUnusedNum(carport.getUnusedNum()+1);
			carport.setUsedNum(carport.getUsedNum()-1);
			this.carportDao.update(carport);
		}
		trade.setState("113");
		this.tradeDao.update(trade);
	}


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void auditVehicle(Trade trade,Staff staff,String approveDesc,int leaveDays,String leaveType,String leaveDate) throws ParseException {
		
		Approve approve = new Approve();
		approve.setTrade(trade);
		approve.setLeaveType(leaveType);
		approve.setLeaveDays(leaveDays);
		approve.setApproveTime(UcmsWebUtils.now());
		approve.setApproveDesc(approveDesc);
		approve.setLeaveDate(leaveDate == "" || leaveDate == null ? null : new SimpleDateFormat("yyyy-MM-dd").parse(leaveDate));
		approve.setStaff(staff);
		approve.setLeaveState("0");//待离场
		approve = this.approveDao.save(approve);
		trade.setApproveTag("1");//审核通过
		trade.setApproveId(approve.getId());
		this.tradeDao.update(trade);
	}


	public Trade getTradeByVehicleId(Long vehicleId) {
		return this.tradeDao.getTradeByVehicleId(vehicleId);
	}


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doVehicleTest(Long tradeId) {
		Trade trade = this.tradeDao.get(tradeId);
		trade.setDetectTag(Const.DETECT_YES);//已检测
		this.tradeDao.update(trade);
	}


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void chgTransfer(String shelfCode,String state) {
		Trade trade = this.tradeDao.getTradeBySCode(shelfCode);
		PublishInfo info = this.publishInfoDao.findByTradeInfo(trade.getId());
		if(info != null){
			info.setState("1");
			this.publishInfoDao.update(info);
		}
		trade.setSaleTransferTag(state);
		this.tradeDao.update(trade);
	}



	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void updateTrade(Trade trade) {
		this.tradeDao.update(trade);
	}


	/**
	 * 在库车辆的交易列表
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, readOnly=true, rollbackFor = ServiceException.class)
	public List<Trade> listTrade() {
		return this.tradeDao.listTrade();
	}


	public Long getSumFee(Long agencyId) {
		return Long.parseLong(this.tradeDao.getSumFee(agencyId));
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doVehicleConfiguration(VehicleEquip ve){
		
		vehicleEquipDao.save(ve);
	}
	
	public Vehicle findVehicleByTradeId(Long id) throws Exception {
		
		return vehicleDao.findVehicleId(id);
	}
	    
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void updateVehicle(Vehicle v){
		
		vehicleDao.update(v);
	}

	public VehicleEquip getEquipByVehicleId(Long id) {
		return this.vehicleEquipDao.findByVehicleId(id);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)	
	public void pubVehiclePics(String id,String pubTag)throws Exception{
		VehiclePic pic = this.vehiclePicDao.get(Long.parseLong(id));
		pic.setPublishTag(pubTag);
		this.vehicleDao.update(pic);//标记删除
	}


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doSetFront(Long picId, String isFront) {
		VehiclePic pic = this.vehiclePicDao.findFront();
		if(pic!=null){
			pic.setIsFront("0");
			this.vehiclePicDao.update(pic);
		}
		VehiclePic frontPic = this.vehiclePicDao.get(picId);
		frontPic.setIsFront(isFront);
		this.vehiclePicDao.update(frontPic);
	}


	/**
	 * 车商维护车辆信息的临时新增车辆接口
	 * @param trade
	 * @param vehicle
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void saveVehicleInputPhone(Trade trade, Vehicle vehicle, String pics) {
	    //保存车辆信息
	    vehicle.setUpdateTime(UcmsWebUtils.now());
	    vehicle.setCreateTime(UcmsWebUtils.now());
	    if(vehicle.getBrand().getId()==null)
	    	vehicle.setBrand(null);
	    if(vehicle.getSeries().getId()==null)
	    	vehicle.setSeries(null);
	    if(vehicle.getKind().getId()==null)
	    	vehicle.setKind(null);
	    
	    if(!StringUtils.isBlank(vehicle.getShelfCode())){
			vehicle.setShelfCode(vehicle.getShelfCode().toUpperCase());
		}
	    if(!StringUtils.isBlank(trade.getOldLicenseCode())){
	    	vehicle.setLicenseCode(trade.getOldLicenseCode().toUpperCase());
	    }
	    if(!StringUtils.isBlank(vehicle.getMileageCount())){
	    	vehicle.setMileageCount(UcmsWebUtils.wanToLi(vehicle.getMileageCount()) + "");
	    }
	    if(!StringUtils.isBlank(vehicle.getNewcarPrice())){
	    	vehicle.setNewcarPrice(UcmsWebUtils.wanToyuan(vehicle.getNewcarPrice()) + "");
	    }
	    if(StringUtils.isBlank(vehicle.getOutputVolumeU()) || "false".equals(vehicle.getOutputVolumeU())){
	    	vehicle.setOutputVolumeU("0");
	    }else{
	    	vehicle.setOutputVolumeU("1");
	    }

	    Vehicle nVehicle = vehicleDao.save(vehicle);
	    //保存交易主表信息
	    trade.setState(Const.WAITFOR_IN_STR);
	    trade.setVehicle(nVehicle);
	    trade.setComeDate(UcmsWebUtils.now());
	    trade.setUpdateTime(UcmsWebUtils.now());
	    trade.setCreateTime(UcmsWebUtils.now());
	    if(!StringUtils.isBlank(trade.getOldLicenseCode())){
	    	trade.setOldLicenseCode(trade.getOldLicenseCode().toUpperCase());
	    }
	    if(trade.getAcquPrice() != null){
	    	trade.setAcquPrice(NumberUtils.toLong("" + UcmsWebUtils.wanToyuan(trade.getAcquPrice() + "")));
	    }
	    if(trade.getShowPrice() != null){
	    	trade.setShowPrice(NumberUtils.toLong("" + UcmsWebUtils.wanToyuan(trade.getShowPrice() + "")));
	    }
	    Trade nTrade = tradeDao.save(trade);
	    String barCode = SysUtils.createBarCode(nTrade.getId().toString());
	    nTrade.setBarCode(barCode);
	    this.tradeDao.update(nTrade);
	    //操作历史
	    OperHis operHis=new OperHis();    
	    operHis.setStaff(null);
	    operHis.setOperTag("1");
	    operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
	    operHis.setOperDesc(" 商户 "+nTrade.getAgency().getAgencyName()+" 新登记了1辆车。");
	    operHis.setOperObj(nTrade.getId());
	    this.operHisDao.save(operHis);
	  }
	
	/**
	 * 上传阿里云
	 * @param pics
	 * @return
	 * @throws Exception
	 */
	private List<String> uploadAliyun(String pics) throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		List<String> newFileNameList = new ArrayList<String>();
		String[] datas = pics.split("##");
		for (String datasString : datas) {
			BASE64Decoder decoder = new BASE64Decoder();
//			String[] data = datasString.split(",");
			datasString = datasString.replace("data:image/png;base64,", "");
			// 去除开头不合理的数据 data:image/png;base64,
			byte[] image = decoder.decodeBuffer(datasString);
			// 文件名加入随机数，以防高并发情况下文件重名。
			Random random1 = new Random((int) (Math.random() * 1000));
			String fileName = System.currentTimeMillis() + random1.nextInt() + ".png";
			InputStream bais = new ByteArrayInputStream(image);
			String imgPath = request.getSession().getServletContext().getRealPath("") + "\\doc\\";
			File filedir = new File(imgPath);
			if(!filedir.exists()){
				filedir.mkdirs();
			}
			File file = new File(imgPath, fileName);// 可以是任何图片格式.jpg,.png等
			
			FileOutputStream fos = new FileOutputStream(file);
			byte[] b = new byte[1024];
			int nRead = 0;
			while ((nRead = bais.read(b)) != -1) {
				fos.write(b, 0, nRead);
			}
			fos.flush();
			fos.close();
			bais.close();
			OSSClient client = AliUpload.getOSSClient(Const.endpoint, Const.accessKeyId, Const.accessKeySecret);
			String newFileName = AliUpload.easyPutObj(fileName, Const.vehicleBucket, file, client);
			newFileNameList.add("http://lishuoxunphh.oss-cn-hangzhou.aliyuncs.com/" + newFileName);
		}
    	return newFileNameList;
	}


	/**
	 * 上传车辆图片
	 * @param trade
	 * @param vehicle
	 * @param pics
	 */
	public VehiclePic doUploadVehicleImage(Trade trade, Vehicle vehicle, String pics) {
		if(StringUtils.isBlank(pics)){
	    	return null;
	    }
	    List<String> images = null;
	    try {
	    	images = this.uploadAliyun(pics);
		} catch (Exception e) {
			e.printStackTrace();
		}
	    if(images == null ){
	    	return null;
	    }
    	String img = images.get(0);
    	String isFront = "1";
    	VehiclePic pic = new VehiclePic(vehicle, trade, img, img, 1, "1", "1", isFront, "app");
    	this.vehiclePicDao.save(pic);
	    return pic;
		
	}

}
