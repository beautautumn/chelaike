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
import com.ct.erp.lib.entity.AgencySync;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.sys.dao.ParamsDao;
import com.ct.erp.task.AutoGetTransferInfoJob;
import com.ct.erp.task.dao.AgencySyncDao;
import com.ct.erp.util.HttpUtils;
import com.ct.erp.util.UcmsWebUtils;

@Service
@Transactional(propagation = Propagation.SUPPORTS)
public class AgencySyncService {
  private static final Logger log = LoggerFactory.getLogger(AutoGetTransferInfoJob.class);
 
  @Autowired
  private AgencySyncDao agencySyncDao;
  @Autowired
  private AgencyDao agencyDao;
  
    
  
  @Transactional(propagation=Propagation.NOT_SUPPORTED,readOnly=true)
  private List<AgencySync> getUnSyncAgency() throws Exception{
    return agencySyncDao.getUnSyncAgency();
  }
  
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
  public void doSyncAgencyInfo() throws Exception{
  
    List<AgencySync> list =getUnSyncAgency();
    if(list==null || list.size()==0) return;
    for(int i=0;i<list.size();i++)
    {
       AgencySync agencySync =list.get(i);
       doPostAgencyInfo(agencySync);
    }
    
  }
 
  
  /**
   * 获取过户信息
   * @throws Exception
   */
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
  private void doUpdateAgencySync(AgencySync agencySync,String jsonStr) throws Exception{
     JSONObject obj =JSONObject.fromObject(jsonStr);
     if(obj.getBoolean("success"))
     {
       
       Agency agency = agencySync.getAgency();
       agency.setOuterId(obj.getJSONObject("data").getJSONObject("result").getLong("locateId"));
       agency.setOuterUserId(obj.getJSONObject("data").getJSONObject("result").getLong("staffId"));
       agencyDao.update(agency);
       
       agencySync.setMsgInfo(null);
       agencySync.setDoTime(UcmsWebUtils.now());       
       agencySync.setState(Const.SYNC_STATE_SUCCESS);
       agencySyncDao.update(agencySync);       
       
     }
     else
     {
       agencySync.setMsgInfo(obj.getJSONObject("data").getString("message"));
       agencySync.setDoTime(UcmsWebUtils.now());       
       agencySync.setState(Const.SYNC_STATE_ERROR);
       agencySyncDao.update(agencySync);
     }
    
    
  }
  
  
  private void doPostAgencyInfo(AgencySync agencySync) throws Exception{
    try
    {
      
      String params ="corpId=@corpId&departName=@departName&userPhone=@userPhone&userAccount=@userAccount&userPwd=@userPwd&userName=@userName";
      params =params.replaceAll("@corpId", Const.SYNC_AGENCY_CORPID);
      params =params.replaceAll("@departName", agencySync.getAgency().getAgencyName());
      params =params.replaceAll("@userPhone", agencySync.getAgency().getUserPhone());
      params =params.replaceAll("@userAccount", agencySync.getAgency().getAccount());
      params =params.replaceAll("@userPwd", agencySync.getAgency().getPwd());
      params =params.replaceAll("@userName", agencySync.getAgency().getUserName());
      
      String resStr =HttpUtils.sendPost(Const.SYNC_AGENCY_URL,params,"utf8");
      doUpdateAgencySync(agencySync,resStr);
    }
    catch(Exception e)
    {
      log.error("doPostAgencyInfo",e);
    }
  }
  
}
