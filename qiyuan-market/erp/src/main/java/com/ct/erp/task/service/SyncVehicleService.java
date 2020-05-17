package com.ct.erp.task.service;

import java.util.List;

 
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.carin.dao.TradeDao;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;
import com.ct.erp.lib.entity.VehicleSync;
import com.ct.erp.task.dao.VehicleSyncDao;
import com.ct.erp.util.HttpUtils;
import com.ct.erp.util.UcmsWebUtils;

@Service
@Transactional(propagation = Propagation.SUPPORTS)
public class SyncVehicleService {
  private static final Logger log = LoggerFactory.getLogger(SyncVehicleService.class);
 
  @Autowired
  private VehicleSyncDao vehicleSyncDao;
  @Autowired
  private TradeDao tradeDao;
    
  @Transactional(propagation=Propagation.NOT_SUPPORTED,readOnly=true)
  private List<VehicleSync> getUnSyncVehicle() throws Exception{
    return vehicleSyncDao.getUnSyncVehicle();
  }
  
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
  public void doSyncVehicleInfo() throws Exception{
  
    List<VehicleSync> list =getUnSyncVehicle();
    if(list==null || list.size()==0) return;
    for(int i=0;i<list.size();i++)
    {
      VehicleSync vehicleSync =list.get(i);
       doPostVehicleInfo(vehicleSync);
    }
    
  }
 
  /**
   * 获取过户信息
   * @throws Exception
   */
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
  private void doUpdateVehicleSync(VehicleSync vehicleSync,String jsonStr,Trade trade) throws Exception{
     JSONObject obj =JSONObject.fromObject(jsonStr);
     if(obj.getBoolean("success"))
     {
       vehicleSync.setMsgInfo(null);
       vehicleSync.setDoTime(UcmsWebUtils.now());       
       vehicleSync.setState(Const.SYNC_STATE_SUCCESS);
       vehicleSyncDao.update(vehicleSync);  
       trade.setOuterId(obj.getJSONObject("data").getJSONObject("result").getLong("stockId"));
       this.tradeDao.update(trade);
       
     }
     else
     {
       vehicleSync.setMsgInfo(obj.getJSONObject("data").getString("message"));
       vehicleSync.setDoTime(UcmsWebUtils.now());       
       vehicleSync.setState(Const.SYNC_STATE_ERROR);
       vehicleSyncDao.update(vehicleSync);
     }
    
    
  }
  
  
  private void doPostVehicleInfo(VehicleSync vehicleSync) throws Exception{
    try
    {
      Trade trade = vehicleSync.getTrade();
      Vehicle v = trade.getVehicle();
      Agency agency =trade.getAgency();
      
      String params ="corpId=@corpId&locateId=@locateId&buyStaff=@buyStaff&brandId=@brandId&seriesId=@seriesId";
      params+="&modelId=@modelId&gearsTypeTag=@gearsTypeTag&buyDate=@buyDate&registMonth=@registMonth&barCode=@barCode"
      		+ "&shelfCode=@shelfCode&buyPrice=@buyPrice&showPrice=@showPrice&mileageCount=@mileageCount"
      		+ "&outputVolume=@outputVolume";
      params =params.replaceAll("@corpId", Const.SYNC_AGENCY_CORPID);
      params =params.replaceAll("@locateId", agency.getOuterId().toString());
      params =params.replaceAll("@buyStaff", agency.getOuterUserId().toString());
      params =params.replaceAll("@brandId",v.getBrand().getId().toString());
      params =params.replaceAll("@seriesId",v.getSeries().getId().toString());
      params =params.replaceAll("@modelId", v.getKind().getId().toString());
      
      String gearType =v.getGearType();//0-手动;1-自动;2-手自一体;3-其他
      gearType =gearType==null?"其他":gearType;
      String iGearType="3";
      if(gearType.equals("手动")){
        iGearType ="0";
      }else if(gearType.equals("自动")){
        iGearType ="1";          
      }else if(gearType.equals("手自一体")){
        iGearType ="2";        
      }else{
        iGearType ="3";        
      }
      params =params.replaceAll("@gearsTypeTag",iGearType);
      params =params.replaceAll("@buyDate",UcmsWebUtils.dateTOStr(trade.getAcquTransferDate()));
      params =params.replaceAll("@registMonth", v.getRegistMonth());
      params =params.replaceAll("@barCode", Const.BARCODE_URL+trade.getBarCode()+".png");
      params =params.replaceAll("@showPrice", trade.getShowPrice().toString());
      params =params.replaceAll("@shelfCode", v.getShelfCode());
      params =params.replaceAll("@buyPrice", trade.getAcquPrice().toString());
      params =params.replaceAll("@mileageCount", v.getMileageCount());
      params =params.replaceAll("@outputVolume", v.getOutputVolume());
      String resStr =HttpUtils.sendPost(Const.SYNC_VEHICLE_URL,params,"utf8");
      doUpdateVehicleSync(vehicleSync,resStr,trade);
    }
    catch(Exception e)
    {
      log.error("doPostVehicleInfo",e);
    }
  }
  
  public static void main(String args[])throws Exception{
	  String params = "corpId=32&buyStaff=5826&brandId=9&seriesId=1994&modelId=4301&gearsTypeTag=3&buyDate=&registMonth=2015-06";
	  String resStr =HttpUtils.sendPost("http://localhost:8081/che3bao_dg/addVehicle?",params,"utf8");
  }
  
}
