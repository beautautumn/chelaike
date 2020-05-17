package com.ct.erp.publish.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.carin.dao.TradeDao;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.PublishInfo;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.publish.dao.PublishInfoDao;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.util.UcmsWebUtils;


@Service
public class PublishService {
 
  @Autowired
  private PublishInfoDao publishDao;
  @Autowired
  private OperHisDao operHisDao;
  @Autowired
  private TradeDao tradeDao;
  
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
  public void doPublish(PublishInfo pInfo,String tradeIds) throws Exception{
    
    String[] arr=tradeIds.split(",");
    for(int i=0;i<arr.length;i++)
    {
      Trade trade = tradeDao.get(Long.parseLong(arr[i]));
      PublishInfo publish = this.publishDao.findUniqueByProperty("trade.id", trade.getId());
      if(publish == null){
    	  PublishInfo p = new PublishInfo();
    	  p.setCertifyTag(pInfo.getCertifyTag());
	      p.setTrade(trade);
	      //p.setCertifyTag("1");//大公认证
	      p.setVehicle(trade.getVehicle());
	      p.setAgency(trade.getAgency());
	      p.setCreateTime(UcmsWebUtils.now());
	      p.setUpdateTime(UcmsWebUtils.now());
	      p.setPublishTime(UcmsWebUtils.now());
	      p.setState("0");
	      publish=publishDao.save(p);
      }else{
    	  publish.setState("0");
    	  publishDao.update(publish);
      }
      //操作历史
      OperHis operHis=new OperHis();
      Staff staff = new Staff();
      staff.setId(SecurityUtils.getCurrentSessionInfo().getStaffId());
      operHis.setStaff(staff);
      operHis.setOperTag("2");
      operHis.setOperTime(UcmsWebUtils.now());
      operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 发布了新车辆");
      operHis.setOperObj(publish.getId());
      this.operHisDao.save(operHis);
    }
  }
  
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
  public void doDown(String ids) throws Exception{
    
    String[] arr=ids.split(",");
    for(int i=0;i<arr.length;i++)
    {
      PublishInfo p= publishDao.get(Long.parseLong(arr[i]));
      p.setState("1");//下架
      publishDao.update(p);
      //操作历史
      OperHis operHis=new OperHis();   
      Staff staff = new Staff();
      staff.setId(SecurityUtils.getCurrentSessionInfo().getStaffId());
      operHis.setStaff(staff);
      operHis.setOperTag("2");
      operHis.setOperTime(UcmsWebUtils.now());
      operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 下架了一辆车。");
      operHis.setOperObj(p.getId());
      this.operHisDao.save(operHis);
    }
  }  
}
