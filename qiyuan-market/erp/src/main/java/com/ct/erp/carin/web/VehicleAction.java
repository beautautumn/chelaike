package com.ct.erp.carin.web;

import java.io.File;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.carin.dao.ApproveDao;
import com.ct.erp.carin.dao.CheckOutDao;
import com.ct.erp.carin.service.TradeInfoService;
import com.ct.erp.common.exception.ActionException;
import com.ct.erp.common.utils.SysUtils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Approve;
import com.ct.erp.lib.entity.Brand;
import com.ct.erp.lib.entity.CarOperHis;
import com.ct.erp.lib.entity.Carport;
import com.ct.erp.lib.entity.CheckOut;
import com.ct.erp.lib.entity.Financing;
import com.ct.erp.lib.entity.Kind;
import com.ct.erp.lib.entity.MerchantAuth;
import com.ct.erp.lib.entity.Params;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.Series;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;
import com.ct.erp.lib.entity.VehicleEquip;
import com.ct.erp.lib.entity.VehiclePic;
import com.ct.erp.rent.dao.CarportDao;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.sys.dao.ParamsDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.MatrixToImageWriter;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.erp.wx.auth.service.MerchantAuthService;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Scope("prototype")
@Controller("carin.vehicleAction")
public class VehicleAction extends SimpleActionSupport {
	
  	private static final Logger log = LoggerFactory.getLogger(VehicleAction.class);
  	private static final long serialVersionUID = 3636934746937027213L;
  	private List<Staff> staffs=new ArrayList<Staff>();
  	private List<Agency> agencys=new ArrayList<Agency>();
  	private List<CarOperHis> carOperHises=new ArrayList<CarOperHis>();
  	private List<Trade> tradeList = new ArrayList<Trade>();
  	private File fileObj;
  	private String localFileName;
    private Trade trade;
    private CarOperHis carOperHis;
    private Vehicle vehicle;
    private Carport carport;
    private Long picId;
    private Long agencyId;
    private Long tradeId;
    private Long staffId;
    private Integer showOrder;
    private String pics;
    private Integer length;
    private String picIds;
    private String barCode;
    private Pic pic;
    private Agency agency;
    private String approveDesc;
    private String leaveType;
    private int leaveDays;
    private String leaveDate;
    private String shelfCode;
    private String transState;
    private String type;
    private String localhost;
    private List<VehiclePic> vehiclePic;
    private VehicleEquip vehicleEquip;
    private Long vehicleId;
    private CheckOut checkOut;
    private String pubTag;
    private String isFront;
    
    @Autowired
  	private AgencyService agencyService;   
  	@Autowired
  	private StaffService staffService;   
  	@Autowired
  	private TradeInfoService tradeInfoService;   
  	@Autowired
  	private MerchantAuthService merchantAuthService;   
  	@Autowired
  	private CarportDao carportDao;
  	@Autowired
  	private ApproveDao approveDao;
  	@Autowired
  	private ParamsDao paramsDao;
  	@Autowired
  	private CheckOutDao checkOutDao;
		
  	
  	//to商户车辆登记表单
  	public String toVehicleRegister() throws Exception{
  		try{
  		  setAgencys(this.agencyService.findValidAgencyList());
  		}
  		catch(Exception e)
  		{
            log.error("toVehicleRegister",e);			
  		}
  		return "toVehicleRegister";		
  	}
	
	  //保存商户车辆登记表单
    public void doVehicleRegister(){
    	HttpServletResponse response = ServletActionContext.getResponse();
  		try 
  		{
  			Vehicle vehicle = new Vehicle();
  			tradeInfoService.doVehicleRegister(trade,vehicle, picId);
  			UcmsWebUtils.ajaxOutPut(response, "success");
  		} catch (Exception e) 
  		{
  			log.error("doVehicleRegister",e);
  			UcmsWebUtils.ajaxOutPut(response, "error");
  		}

    }
    

    //to车辆信息录入表单
    public String toVehicleInput() throws Exception{
      try{
    	  this.agency = this.agencyService.findById(this.agencyId);
        setAgencys(agencyService.findValidAgencyList());      
       
      }
      catch(Exception e)
      {
         log.error("toVehicleInput",e);      
      }
      return "toVehicleInput";
    }    
    
    //保存车辆信息
    public void doVehicleInput(){
      HttpServletResponse response = ServletActionContext.getResponse();
      try 
      {
        tradeInfoService.saveVehicleInput(trade,vehicle, picId);
        UcmsWebUtils.ajaxOutPut(response, "success");
      } catch (Exception e) 
      {
        log.error("doVehicleInput",e);
        UcmsWebUtils.ajaxOutPut(response, "error");
      }
    }
       
    
    

  	//to车辆信息录入表单
  	public String toVehicleInfo() throws Exception{
  		try{
  		  setAgencys(agencyService.findValidAgencyList());
          trade =	tradeInfoService.getTradeById(tradeId);
  		  vehicle = trade.getVehicle();
  		  if(vehicle.getBrand()==null)
  			 vehicle.setBrand(new Brand());
  		  if(vehicle.getSeries()==null)
  			 vehicle.setSeries(new Series());
  		  if(vehicle.getKind()==null)
  			 vehicle.setKind(new Kind());
  		}
  		catch(Exception e)
  		{
         log.error("toVehicleInfo",e);			
  		}
  		return "toVehicleInfo";
  	}    
    
	  //保存车辆信息
    public void doVehicleInfo(){
    	HttpServletResponse response = ServletActionContext.getResponse();
  		try 
  		{
  			tradeInfoService.saveVehicleInfo(trade,vehicle, picId);
  			UcmsWebUtils.ajaxOutPut(response, "success");
  		} catch (Exception e) 
  		{
  			log.error("doVehicleInfo",e);
  			UcmsWebUtils.ajaxOutPut(response, "error");
  		}
    }
   
    //to车辆入场门禁表单
    public String toVehicleEntrance() throws Exception{
      try{
         setAgencys(this.agencyService.findValidAgencyList());
      }
      catch(Exception e)
      {
            log.error("toVehicleEntrance",e);      
      }
      return "toVehicleEntrance";    
    }
  
    //保存车辆入场登记表单
    public void doVehicleEntrance() throws Exception{
      HttpServletResponse response = ServletActionContext.getResponse();
      try
      {
        tradeInfoService.doVehicleEntrance(tradeId);
        UcmsWebUtils.ajaxOutPut(response, "success");
        doOpenTheGate(1,1,1);
      } catch (Exception e)
      {
        log.error("doVehicleEntrance",e);
        UcmsWebUtils.ajaxOutPut(response, "error");
        doOpenTheGate(1,1,1);
      }
    }
    

	/**
     * 收购过户
     */
    public String toFirstTransfer(){
      try
      {
        this.trade =tradeInfoService.getTradeById(tradeId);
      }
      catch(Exception e)
      {
        log.error("toFirstTransfer",e);
        return "error";
      }
      return "toFirstTransfer";      
    }
    //保存第一次车辆过户
    public void doFirstTransfer(){
      HttpServletResponse response = ServletActionContext.getResponse();
      try
      {
        tradeInfoService.doSaveFirstTranser(trade);
        
      }
      catch(Exception e)
      {
        log.error("doFirstTransfer",e);
        UcmsWebUtils.ajaxOutPut(response, "error");
      }
      UcmsWebUtils.ajaxOutPut(response, "success");
    }    
        
    /**
     * 收购过户
     */
    public String toSecondTransfer(){
      
      try
      {
        this.trade =tradeInfoService.getTradeById(tradeId);
      }
      catch(Exception e)
      {
        log.error("toSecondTransfer",e);
        return "error";
      }
      return "toSecondTransfer";     
    }
    
    //保存第二次车辆过户
    public void doSecondTransfer(){
      
      HttpServletResponse response = ServletActionContext.getResponse();     
      try
      {
        tradeInfoService.doSaveSecondTranser(trade);
      }
      catch(Exception e)
      {
        log.error("doSecondTransfer",e);
        UcmsWebUtils.ajaxOutPut(response, "error");
      }
      UcmsWebUtils.ajaxOutPut(response, "success");
    }
    
    
    //显示车位使用历史
    public String toCarPortHis(){
    	try
    	{
    	   carOperHises =tradeInfoService.getCarOperHis(agencyId);
    	}
    	catch(Exception e)
    	{
    		log.error("toCarPortHis",e);
    		return "error";
    	}
    	return "toCarPortHis";
    }
    
    
    //显示调整车位界面
    public String toChgCarPort(){
    	try
    	{
  		  setStaffs(staffService.findAllValid());
  		  SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        this.staffId=sessionInfo.getStaffId();
        carOperHis = new CarOperHis();
        carOperHis.setStaff(new Staff());
	      tradeList =tradeInfoService.getTradeListByAgencyId(agencyId);
    	}
    	catch(Exception e)
    	{
    		log.error("toChgCarPort",e);
    		return "error";
    	}
    	return "toChgCarPort";
    }
    
    //执行调整车位
    public void doChgCarPort(){
    	HttpServletResponse response = ServletActionContext.getResponse();
    	try
    	{
		  tradeInfoService.doChgCarPort(tradeId, carOperHis);
		  UcmsWebUtils.ajaxOutPut(response, "success");
    	}
    	catch(Exception e)
    	{
    		log.error("doChgCarPort",e);
    		UcmsWebUtils.ajaxOutPut(response, "error");
    	}    	
    }       
    
    //显示车辆转移界面
    public String toChgOwnerAgency(){
    	try
    	{
  		  setStaffs(staffService.findAllValid());
  		  this.agencys =agencyService.findValidAgenciesWithOutOne(agencyId);
  		  SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
          this.staffId=sessionInfo.getStaffId();
          carOperHis = new CarOperHis();
          carOperHis.setStaff(new Staff());
    	}
    	catch(Exception e)
    	{
    		log.error("toChgOwnerAgency",e);
    		return "error";
    	}
    	return "toChgOwnerAgency";
    }
    
    //执行车辆转移
    public void doChgOwnerAgency(){
    	HttpServletResponse response = ServletActionContext.getResponse();
    	try
    	{
		  tradeInfoService.doChgOwnerAgency(tradeId,agencyId,carOperHis);
		  UcmsWebUtils.ajaxOutPut(response, "success");
    	}
    	catch(Exception e)
    	{
    		log.error("doChgOwnerAgency",e);
    		UcmsWebUtils.ajaxOutPut(response, "error");
    	}    	
    }       
        
    
    //获取指定商家的车位情况
  	public void getAgencyCarport(){
  		HttpServletResponse response = ServletActionContext.getResponse();
  		String str="{}";
  		try {
  		    Carport carport = tradeInfoService.getcarport(agencyId);
  		    JSONObject jobj =new JSONObject();
  		    jobj.accumulate("totalNum", carport.getTotalNum());
  		    jobj.accumulate("unusedNum", carport.getUnusedNum());
  		    str= jobj.toString();		   
  	   }catch(Exception e){
            log.error(e.getMessage());		   
  	   }
  	   UcmsWebUtils.ajaxOutPut(response, str);
  	}   
  	
    //获取指定商家的车位情况
    public void getInfoByBarCode(){
      HttpServletResponse response = ServletActionContext.getResponse();
      String str="";
      try {
          Trade trade =tradeInfoService.getTradeByBCode(barCode);
          if(trade!=null)
          {
        	  Approve approve = trade.getApproveId() == null ? null : this.approveDao.get(trade.getApproveId());
        	  Carport carport = tradeInfoService.getcarport(trade.getAgency().getId());
        	  JSONObject jobj =new JSONObject();
        	  jobj.accumulate("tradeId", trade.getId());
        	  jobj.accumulate("agencyName", trade.getAgency().getAgencyName());
        	  jobj.accumulate("totalNum", carport.getTotalNum());
        	  jobj.accumulate("unusedNum", carport.getUnusedNum());
        	  jobj.accumulate("state", trade.getState());
        	  jobj.accumulate("leaveState", approve == null ? "" : approve.getLeaveState());
        	  str= jobj.toString();
          }
       }catch(Exception e){
            log.error(e.getMessage());   
       }
       UcmsWebUtils.ajaxOutPut(response, str);
    }  
    
    
  //根据车架号获取指定商家的车位情况
    public void getInfoByShelfCode(){
      HttpServletResponse response = ServletActionContext.getResponse();
      String str="";
      try {
          /*Trade trade =tradeInfoService.getTradeBySCode(shelfCode);*/
    	  Trade trade =tradeInfoService.getTradeByShelfCode(shelfCode);
          if(trade!=null)
          {
        	  //Approve approve = trade.getApproveId() == null ? null : this.approveDao.get(trade.getApproveId());
        	  Carport carport = tradeInfoService.getcarport(trade.getAgency().getId());
        	  JSONObject jobj =new JSONObject();
        	  jobj.accumulate("tradeId", trade.getId());
        	  jobj.accumulate("agencyName", trade.getAgency().getAgencyName());
        	  jobj.accumulate("totalNum", carport.getTotalNum());
        	  jobj.accumulate("unusedNum", carport.getUnusedNum());
        	  jobj.accumulate("state", trade.getState());
        	  /*jobj.accumulate("leaveState", approve == null ? "" : approve.getLeaveState());*/
        	  str= jobj.toString();
          }
       }catch(Exception e){
            log.error(e.getMessage());   
       }
       UcmsWebUtils.ajaxOutPut(response, str);
    }
    
    //上传登记证书
  	public void upload() throws Exception {
  		HttpServletResponse response = ServletActionContext.getResponse();
  		String resStr = "";
  		try {
  			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
  			Long staffId = sessionInfo.getStaffId();
  			Staff staff = staffService.findById(staffId);
  			resStr=this.agencyService.upload(2L,staff, fileObj, this.localFileName);
  		} catch (Exception ex) {
  			log.error("upload",ex);
  			resStr = "0";
  		}
  		UcmsWebUtils.ajaxOutPut(response, resStr);
  	}

	 /**
	  * 车辆图片
	  * @return
	  * @throws Exception
	  */
	 public String toUploadVehiclePic() throws Exception{
	   try{
          trade =tradeInfoService.getTradeById(tradeId);
	        List<VehiclePic>  picList=tradeInfoService.getPicListByTradeId(tradeId);
    			if ((picList == null) || (picList.size() == 0)) {
    				this.pics = "{}";
    				this.length = picList.size();
    			} else {
    				JSONArray jArr = new JSONArray();
    				VehiclePic vehiclePic = null;
    				for (int i = 0; i < picList.size(); i++) {
    					vehiclePic = picList.get(i);
    					String picDisplayName = "";
    					JSONObject json = new JSONObject();
    					json.put("picId", vehiclePic.getId());
    					json.put("picAddr", vehiclePic.getPicUrl());
    					json.put("showOrder", vehiclePic.getShowOrder());
    					json.put("displayName", picDisplayName);
    					json.put("publishTag", vehiclePic.getPublishTag());
    					json.put("isFront", vehiclePic.getIsFront());
    					jArr.add(json);
    				}
    				this.pics = jArr.toString();
    			}

  	   }catch(Exception ex)
  	   {
  		   ex.printStackTrace();
  		 log.error("toUploadVehiclePic",ex);
  		 return "error";
  	   }
  	   return "toUploadVehiclePic";
  	}
  	/**
  	 * 上传车辆图片
  	 * @throws Exception
  	 */
  	public void doUploadVehiclePic() throws Exception {
  		HttpServletResponse response = ServletActionContext.getResponse();
  		String resStr = "";
  		try {
  			  VehiclePic pic = new VehiclePic();
  			  trade = tradeInfoService.getTradeById(tradeId);
  			  Vehicle v=trade.getVehicle();
  			  pic.setTrade(trade);
  			  pic.setVehicle(v);
  			  pic.setShowOrder(showOrder);
  			  resStr= tradeInfoService.uploadVehiclePic(pic, fileObj, localFileName);
  		} catch (Exception ex) {
  			  log.error("Error in doUploadVehiclePic method!", ex);
  			  resStr = "0";
  		}
  		UcmsWebUtils.ajaxOutPut(response, resStr);  
  	}
  	
  	/**
  	 * 删除车辆图片
  	 * @throws Exception
  	*/
  	public void doDelVehiclePic() throws Exception {
  		HttpServletResponse response = ServletActionContext.getResponse();
  		String resStr = "success";
  		try {
  			 tradeInfoService.delVehiclePics(picIds);
  		} catch (Exception ex) {
  			 log.error("Error in doDelVehiclePic method!", ex);
  			 resStr = "error";
  		}
  		UcmsWebUtils.ajaxOutPut(response, resStr);	
  
  	}	
  	  	
  	//to车辆离场
  	public String toVehicleOut() throws Exception{
  		this.trade = this.tradeInfoService.getTradeById(this.tradeId);
  		this.carport = this.tradeInfoService.getcarport(trade.getAgency().getId());
  		return "vehicleOut";
  	}
  	
  	//do车辆离场
  	public void doVehicleOutStock() throws Exception{
  		HttpServletResponse response = ServletActionContext.getResponse();
  		this.trade = this.tradeInfoService.getTradeById(this.tradeId);
  		this.carport = this.tradeInfoService.getcarport(this.trade.getAgency().getId());
  		if(trade.getCheckId()!=null){
  			this.checkOut = this.checkOutDao.get(this.trade.getCheckId());
  		}
  		Financing f = this.trade.getFinancing();
  		if(f!=null && (("0").equals(f.getRecvOverTag()) || f.getRecvOverTag() == null) && (("0").equals(f.getRecvDisposalOverTag()) || f.getRecvDisposalOverTag() == null)){
  			//判断是否是已审核车辆，如果是则离场
  			if(this.checkOut != null){
  				/*this.carport = this.tradeInfoService.getcarport(this.trade.getAgency().getId());*/
			  	int usedNum = this.carport.getUsedNum()-1;
			  	int unusedNum = this.carport.getUnusedNum()+1;
			  	this.carport.setUsedNum(usedNum);
			  	this.carport.setUnusedNum(unusedNum);
			  	this.trade.setBefOutState(this.trade.getState());
			  	if(this.trade.getSaleTransferTag() != null && this.trade.getSaleTransferTag().equals("1")){
			  		this.trade.setState(Const.OUT_STOCK_STR);
			  	}else{
			  		this.trade.setState(Const.WAITFOR_IN_STR);
			  	}
			  	this.trade.setCheckId(null);
			  	try{
			  		this.tradeInfoService.doVehicleOutStock(this.carport,this.trade);
			  		UcmsWebUtils.ajaxOutPut(response, "success");
			  		doOpenTheGate(1,1,1);
			  	}catch (Exception e){
			  		log.error("Error in doVehicleOutStock method!", e);
			  		UcmsWebUtils.ajaxOutPut(response, "error");
			  		doOpenTheGate(1,1,1);
			  	}
			  	return;
  			}else{
		  		Long sumFee = this.tradeInfoService.getSumFee(this.trade.getAgency().getId());
		  		Params param = this.paramsDao.findByParamName("evaluate_persent");
		  		/*if(sumFee-2*this.trade.getValuationFee()>0){*/
		  		if(this.trade.getValuationFee()<(sumFee-this.trade.getValuationFee())*(1+param.getIntValue()/100)){
			  		/*this.carport = this.tradeInfoService.getcarport(this.trade.getAgency().getId());*/
				  	int usedNum = this.carport.getUsedNum()-1;
				  	int unusedNum = this.carport.getUnusedNum()+1;
				  	this.carport.setUsedNum(usedNum);
				  	this.carport.setUnusedNum(unusedNum);
				  	this.trade.setBefOutState(this.trade.getState());
				  	if(this.trade.getSaleTransferTag() != null && this.trade.getSaleTransferTag().equals("1")){
				  		this.trade.setState(Const.OUT_STOCK_STR);
				  	}else{
				  		this.trade.setState(Const.WAITFOR_IN_STR);
				  	}
				  	try{
				  		this.tradeInfoService.doVehicleOutStock(this.carport,this.trade);
				  		UcmsWebUtils.ajaxOutPut(response, "success");
				  		doOpenTheGate(1,1,1);
				  	}catch (Exception e){
				  		log.error("Error in doVehicleOutStock method!", e);
				  		UcmsWebUtils.ajaxOutPut(response, "error");
				  		doOpenTheGate(1,1,1);
				  	}
		  		}else{
		  			UcmsWebUtils.ajaxOutPut(response, "unable");
		  			doOpenTheGate(1,1,1);
		  		}
  			}
  		}else{
  			int usedNum = this.carport.getUsedNum()-1;
		  	int unusedNum = this.carport.getUnusedNum()+1;
		  	this.carport.setUsedNum(usedNum);
		  	this.carport.setUnusedNum(unusedNum);
		  	this.trade.setBefOutState(this.trade.getState());
		  	if(this.trade.getSaleTransferTag() != null && this.trade.getSaleTransferTag().equals("1")){
		  		this.trade.setState(Const.OUT_STOCK_STR);
		  	}else{
		  		this.trade.setState(Const.WAITFOR_IN_STR);
		  	}
  			try{
		  		this.tradeInfoService.doVehicleOutStock(this.carport,this.trade);
		  		UcmsWebUtils.ajaxOutPut(response, "success");
		  		doOpenTheGate(1,1,1);
		  	}catch (Exception e){
		  		log.error("Error in doVehicleOutStock method!", e);
		  		UcmsWebUtils.ajaxOutPut(response, "error");
		  		doOpenTheGate(1,1,1);
		  	}
  		}
  	}
  	
  	private void doOpenTheGate(int deviceId, int no, int commond) throws Exception{
  		String address;
		//Jar.deviceOperate(deviceId,no,commond,address);
	}

	//check barCode
  	public void checkBarCode() throws Exception{
  		HttpServletResponse response = ServletActionContext.getResponse();
  		try{
  			this.trade = this.tradeInfoService.getTradeByBCode(this.barCode);
  		}catch (Exception e){
  			log.error("checkBarCode",e);
  		}
  		if(this.trade != null){
  			UcmsWebUtils.ajaxOutPut(response, true);
  		}else{
  			UcmsWebUtils.ajaxOutPut(response, false);
  		}
  	}
  	
	//check shelfCode
  	public void checkShelfCode() throws Exception{
  		HttpServletResponse response = ServletActionContext.getResponse();
  		try{
  			this.trade = this.tradeInfoService.getTradeBySCode(this.shelfCode);
  		}catch (Exception e){
  			log.error("checkBarCode",e);
  		}
  		if(this.trade != null && Integer.parseInt(this.trade.getState())<=111 &&
  				(this.tradeId == null || this.trade.getId().longValue() != this.tradeId.longValue())){
  			UcmsWebUtils.ajaxOutPut(response, true);
  		}else{
  			UcmsWebUtils.ajaxOutPut(response, false);
  		}
  	}
  	
  	//to行驶证上传
  	public String toUpDrive() {
  		this.pic = this.tradeInfoService.getPicByTradeId(this.tradeId);
  		return "vehicleDrive";
  	}
  	
  	//do行驶证上传
  	public void doUpDrive(){
  		HttpServletResponse response = ServletActionContext.getResponse();
  		try
  		{
  			tradeInfoService.doUpDrive(this.tradeId, picId);
  			UcmsWebUtils.ajaxOutPut(response, "success");
  		} catch (Exception e) 
  		{
  			log.error("doVehicleRegister",e);
  			UcmsWebUtils.ajaxOutPut(response, "error");
  		}
  	}
  	
  	//获取唯一条形码
  	public void getBarcode(){
  		HttpServletResponse response = ServletActionContext.getResponse();
  		Trade trade = new Trade();
  		String barCode = "";
  		try{
	  		do {
	  			barCode = SysUtils.getRandomCharAndNum();
	  			trade = this.tradeInfoService.getTradeByBarCode(barCode);
			} while (trade!=null);
	  		UcmsWebUtils.ajaxOutPut(response, barCode);
  		}catch (Exception e) {
  			log.error("getBarcode",e);
  			UcmsWebUtils.ajaxOutPut(response, "error");
		}
  	}
  	
  	
  	//根据id获取商户未使用车位数
  	public void getUnusedPort(){
  		HttpServletResponse response = ServletActionContext.getResponse();
  		try{
  			Carport port = this.carportDao.findByAgencyId(this.agencyId);
  			UcmsWebUtils.ajaxOutPut(response, port.getUnusedNum());
  		}catch (Exception e){
  			log.error("getUnusedPort",e);
  			UcmsWebUtils.ajaxOutPut(response, "error");
  		}
  	}
  	
  	//删除车辆
  	public void delVehicle(){
  		HttpServletResponse response = ServletActionContext.getResponse();
  		try{
  			this.tradeInfoService.delVehicle(this.tradeId);
  			UcmsWebUtils.ajaxOutPut(response, "success");
  		}catch (Exception e){
  			log.error("delVehicle",e);
  			UcmsWebUtils.ajaxOutPut(response, "error");
  		}
  	}
  	
  	//to审核离场
  	public String toAuditVehicle(){
  		return "toAuditVehicle";
  	}
  	
  	//do审核离场
  	public void doAuditVehicle() throws Exception{
  		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
  		Staff staff = this.staffService.findById(sessionInfo.getStaffId());
  		this.trade = this.tradeInfoService.getTradeById(this.tradeId);
  		HttpServletResponse response = ServletActionContext.getResponse();
  		try{
  			this.tradeInfoService.auditVehicle(this.trade,staff,this.approveDesc,this.leaveDays,this.leaveType,this.leaveDate);
  			UcmsWebUtils.ajaxOutPut(response, "success");
  		}catch (Exception e){
  			log.error("doAuditVehicle",e);
  			UcmsWebUtils.ajaxOutPut(response, "error");
  		}
  	}
  	
  	//检查carport
  	public void checkCarport(){
  		HttpServletResponse response = ServletActionContext.getResponse();
  		try {
			this.carport = this.tradeInfoService.getcarport(this.agencyId);
			if(this.carport.getUnusedNum()>0){
				UcmsWebUtils.ajaxOutPut(response, "success");
			}else{
				UcmsWebUtils.ajaxOutPut(response, "false");
			}
		} catch (Exception e) {
			log.error("checkCarport",e);
		}
  		
  	}
  	
  	//to车辆检测
  	public String toVehicleTest(){
  		return "vehicleTest";
  	}
  	
  	//do车辆检测
  	public void doVehicleTest(){
  		HttpServletResponse response = ServletActionContext.getResponse();
  		try{
  			this.tradeInfoService.doVehicleTest(this.tradeId);
  			UcmsWebUtils.ajaxOutPut(response, "success");
  		}catch (Exception e){
  			UcmsWebUtils.ajaxOutPut(response, "false");
  			log.error("doVehicleTest",e);
  		}
  	}
  	
  	//to打印价签
  	public String toPrintPriceLabel() throws Exception{
  		this.trade = this.tradeInfoService.getTradeById(this.tradeId);
  		this.vehicle = this.trade.getVehicle();
  		this.agency = this.trade.getAgency();
  		this.localhost = Const.ERP_IP;
  		return "priceLabel";
  	}
  	
  	//车辆交易过户状态接口
  	public void chgTransferApi(){
  		HttpServletResponse response = ServletActionContext.getResponse();
  		try{
  			this.tradeInfoService.chgTransfer(this.shelfCode,this.transState);
  			UcmsWebUtils.ajaxOutPut(response, "success");
  		}catch(Exception e){
  			UcmsWebUtils.ajaxOutPut(response, "false");
  		}
  	}
  	
  	/**
  	 * 打印车架号二维码界面
  	 * @return
  	 * @throws Exception
  	 */
  	public String toPrintChelfCode() throws Exception{
  		HttpServletRequest request = ServletActionContext.getRequest();
  		try{
  			String qrCode = request.getParameter("qrCode");
  			String width = request.getParameter("width");
  			String height = request.getParameter("height");
  			String param = qrCode+"&width="+width+"&height="+height;
  			request.setAttribute("qrCode", param);
  		}
  		catch(Exception e)
  		{
            log.error("toPrintChelfCode",e);			
  		}
  		return "toPrintChelfCode";		
  	}
  	
  	/**
	 * 生成二维码
	 * 
	 * @return
	 */
	public String qrCode() {
		try {
			HttpServletResponse response = ServletActionContext.getResponse();
			HttpServletRequest request = ServletActionContext.getRequest();
			response.setContentType("image/jpeg");
			String qrCode = request.getParameter("qrCode");
			String widthStr = request.getParameter("width");
			String heightStr = request.getParameter("height");
			int width = !StringUtils.isBlank(widthStr)? Integer.valueOf(widthStr) : 300;
			int height = !StringUtils.isBlank(heightStr)? Integer.valueOf(widthStr) : 300;
			// 二维码的图片格式
			String format = "jpeg";
			Hashtable hints = new Hashtable();
			// 内容所使用编码
			hints.put(EncodeHintType.CHARACTER_SET, "utf-8");
			hints.put(EncodeHintType.MARGIN,0);
			BitMatrix bitMatrix = new MultiFormatWriter().encode(qrCode, BarcodeFormat.QR_CODE, width, height, hints);
			// 生成二维码
			OutputStream os = response.getOutputStream();
			MatrixToImageWriter.writeToStream(bitMatrix, format, os);

		} catch (Exception e) {
			log.error("error in VehicleAction.qrCode method", e);
			e.printStackTrace();
		}
		return null;
	}
	
	//扫描二维码获取车辆详情
  	public String toVehicleDetail() throws Exception{
  		this.trade = this.tradeInfoService.getTradeById(this.tradeId);
  		this.vehicle = this.trade.getVehicle();
  		this.vehiclePic = this.tradeInfoService.getPicListByTradeId(this.tradeId);
  		this.agency = this.trade.getAgency();
  		return "vehicleDetail";
  	}
  	
  	
  	//to车辆配置
  	public String toVehicleConfiguration() throws Exception{
  		trade =	tradeInfoService.getTradeById(tradeId);
		vehicle = trade.getVehicle();
		
		vehicleEquip = this.tradeInfoService.getEquipByVehicleId(vehicle.getId());
		
  		return "toVehicleConfiguration";
  	} 
  	
    //do车辆配置
  	public void doVehicleConfiguration() throws Exception{
  		HttpServletResponse response = ServletActionContext.getResponse();
  		try {
  			Vehicle v = tradeInfoService.findVehicleByTradeId(vehicleId);
  			vehicleEquip.setVehicle(v);
  			tradeInfoService.doVehicleConfiguration(vehicleEquip);
  			tradeInfoService.updateVehicle(v);
  			UcmsWebUtils.ajaxOutPut(response, "success");
  		} catch (Exception e) 
  		{
  			e.printStackTrace();
  			log.error("vehicleEquip",e);
  			UcmsWebUtils.ajaxOutPut(response, "error");
  		}
  	}
  	
  	/**
  	 * do选择官网图片
  	 * @return
  	 */
  	public void doPublishPic() throws Exception{
  		HttpServletResponse response = ServletActionContext.getResponse();
  		String resStr = "success";
  		try {
  			 tradeInfoService.pubVehiclePics(picIds,pubTag);
  		} catch (Exception ex) {
  			 log.error("Error in doPublishPic method!", ex);
  			 resStr = "error";
  		}
  		UcmsWebUtils.ajaxOutPut(response, resStr);
  	}
  	
  	/**
  	 * 设置首图
  	 * @return
  	 */
  	public void doSetFront() throws Exception{
  		HttpServletResponse response = ServletActionContext.getResponse();
  		String resStr = "success";
  		try {
  			 tradeInfoService.doSetFront(picId,isFront);
  		} catch (Exception ex) {
  			 log.error("Error in doSetFront method!", ex);
  			 resStr = "error";
  		}
  		UcmsWebUtils.ajaxOutPut(response, resStr);
  	}
  	
  
  	/**
  	 * 调整手机端录入车辆界面
  	 * @return
  	 * @throws Exception
  	 */
  	public String toVehicleInputPhone() throws Exception{
  		
  		HttpServletRequest request = ServletActionContext.getRequest();
  		MerchantAuth merchantAuth = (MerchantAuth) request.getSession().getAttribute(Const.WX_SESSION_AGENCY_USERINFO);
  		if(merchantAuth == null){
  			throw new ActionException("你的没有获取授权或者你的授权信息已经失效，请重新获取授权！！");
  		}
  		this.agency = this.agencyService.findById(merchantAuth.getAgencyId());
//  		this.agency = this.agencyService.findById(99L);
  		return "vehicleInputPhone";
  	}
  	
  	/**
  	 * 手机端新增车辆界面
  	 * @return
  	 */
	public void doVehicleInputPhone() throws Exception {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			HttpServletRequest request = ServletActionContext.getRequest();
			MerchantAuth merchantAuth = (MerchantAuth) request.getSession().getAttribute(Const.WX_SESSION_AGENCY_USERINFO);
	  		if(merchantAuth == null){
	  			throw new ActionException("你的没有获取授权或者你的授权信息已经失效，请重新获取授权！！");
	  		}
			this.tradeInfoService.saveVehicleInputPhone(trade, vehicle, pics);
			JSONObject jobj =new JSONObject();
			jobj.accumulate("success", "success");
			jobj.accumulate("tradeId", trade.getId());
			jobj.accumulate("vehicleId", vehicle.getId());
			UcmsWebUtils.ajaxOutPut(response, jobj.toString());
		} catch (Exception e) {
			log.error("doVehicleInput", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}
	/**
	 * 手机端上传车辆图片
	 * @return
	 */
	public void doUploadImage() throws Exception {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			HttpServletRequest request = ServletActionContext.getRequest();
			MerchantAuth merchantAuth = (MerchantAuth) request.getSession().getAttribute(Const.WX_SESSION_AGENCY_USERINFO);
	  		if(merchantAuth == null){
	  			throw new ActionException("你的没有获取授权或者你的授权信息已经失效，请重新获取授权！！");
	  		}
			VehiclePic pic = this.tradeInfoService.doUploadVehicleImage(trade, vehicle, pics);
			JSONObject jobj =new JSONObject();
			jobj.accumulate("success", "success");
			jobj.accumulate("picUrl", pic.getPicUrl());
			jobj.accumulate("picId", pic.getId());
			UcmsWebUtils.ajaxOutPut(response, jobj.toString());
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("doVehicleInput", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}
  	
  	public Long getAgencyId() {
  		return agencyId;
  	}
  	
  	public void setAgencyId(Long agencyId) {
  		this.agencyId = agencyId;
  	}
  
  
  
  	public Trade getTrade() {
  		return trade;
  	}
  
  
  
  	public void setTrade(Trade trade) {
  		this.trade = trade;
  	}
  
  
  
    public Long getPicId() {
    	return picId;
    }
  
  
  
  	public void setPicId(Long picId) {
  		this.picId = picId;
  	}
  	
  	public void setAgencys(List<Agency> agencys) {
  		this.agencys = agencys;
  	}
  
  	public List<Agency> getAgencys() {
  		return agencys;
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
  
  	public List<CarOperHis> getCarOperHises() {
  		return carOperHises;
  	}
  
  	public void setCarOperHises(List<CarOperHis> carOperHises) {
  		this.carOperHises = carOperHises;
  	}
  
  	public void setVehicle(Vehicle vehicle) {
  		this.vehicle = vehicle;
  	}
  
  	public Vehicle getVehicle() {
  		return vehicle;
  	}	
  	public Long getTradeId() {
  		return tradeId;
  	}
  
  	public void setTradeId(Long tradeId) {
  		this.tradeId = tradeId;
  	}
  
  	public void setTradeList(List<Trade> tradeList) {
  		this.tradeList = tradeList;
  	}
  
  	public List<Trade> getTradeList() {
  		return tradeList;
  	}
  
  	public void setStaffs(List<Staff> staffs) {
  		this.staffs = staffs;
  	}
  
  	public List<Staff> getStaffs() {
  		return staffs;
  	}
  
  	public void setStaffId(Long staffId) {
  		this.staffId = staffId;
  	}
  
  	public Long getStaffId() {
  		return staffId;
  	}
  
  	public void setCarOperHis(CarOperHis carOperHis) {
  		this.carOperHis = carOperHis;
  	}
  
  	public CarOperHis getCarOperHis() {
  		return carOperHis;
  	}
  	public void setShowOrder(Integer showOrder) {
  		this.showOrder = showOrder;
  	}
  
  	public Integer getShowOrder() {
  		return showOrder;
  	}
  
   
      public Integer getLength() {
  		return length;
  	}
  
  	public void setLength(Integer length) {
  		this.length = length;
  	}
  
  	public String getPics() {
  		return pics;
  	}
  
  	public void setPicIds(String picIds) {
  		this.picIds = picIds;
  	}
  
  	public String getPicIds() {
  		return picIds;
  	}
  
  	public void setPics(String pics) {
  		this.pics = pics;
  	}

    public void setCarport(Carport carport) {
      this.carport = carport;
    }

    public Carport getCarport() {
      return carport;
    } 
    
    public String getBarCode() {
      return barCode;
    }

    public void setBarCode(String barCode) {
      this.barCode = barCode;
    }

	public Pic getPic() {
		return pic;
	}

	public void setPic(Pic pic) {
		this.pic = pic;
	}

	public Agency getAgency() {
		return agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public String getApproveDesc() {
		return approveDesc;
	}

	public void setApproveDesc(String approveDesc) {
		this.approveDesc = approveDesc;
	}

	public String getLeaveType() {
		return leaveType;
	}

	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}

	public int getLeaveDays() {
		return leaveDays;
	}

	public void setLeaveDays(int leaveDays) {
		this.leaveDays = leaveDays;
	}

	public String getLeaveDate() {
		return leaveDate;
	}

	public void setLeaveDate(String leaveDate) {
		this.leaveDate = leaveDate;
	}

	public String getShelfCode() {
		return shelfCode;
	}

	public void setShelfCode(String shelfCode) {
		this.shelfCode = shelfCode;
	}

	public String getTransState() {
		return transState;
	}

	public void setTransState(String transState) {
		this.transState = transState;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public List<VehiclePic> getVehiclePic() {
		return vehiclePic;
	}

	public void setVehiclePic(List<VehiclePic> vehiclePic) {
		this.vehiclePic = vehiclePic;
	}

	public String getLocalhost() {
		return localhost;
	}

	public void setLocalhost(String localhost) {
		this.localhost = localhost;
	}

	public VehicleEquip getVehicleEquip() {
		return vehicleEquip;
	}

	public void setVehicleEquip(VehicleEquip vehicleEquip) {
		this.vehicleEquip = vehicleEquip;
	}

	public Long getVehicleId() {
		return vehicleId;
	}

	public void setVehicleId(Long vehicleId) {
		this.vehicleId = vehicleId;
	}

	public CheckOut getCheckOut() {
		return checkOut;
	}

	public void setCheckOut(CheckOut checkOut) {
		this.checkOut = checkOut;
	}

	public String getPubTag() {
		return pubTag;
	}

	public void setPubTag(String pubTag) {
		this.pubTag = pubTag;
	}

	public String getIsFront() {
		return isFront;
	}

	public void setIsFront(String isFront) {
		this.isFront = isFront;
	}
}
