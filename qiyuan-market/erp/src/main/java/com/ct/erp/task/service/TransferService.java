package com.ct.erp.task.service;

import java.util.List;

 
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.carin.dao.TradeDao;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.lib.entity.Params;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.sys.dao.ParamsDao;
import com.ct.erp.task.AutoGetTransferInfoJob;
import com.ct.erp.util.HttpUtils;
import com.ct.erp.util.UcmsWebUtils;

@Service
@Transactional(propagation = Propagation.SUPPORTS)
public class TransferService {
  private static final Logger log = LoggerFactory.getLogger(AutoGetTransferInfoJob.class);

  @Autowired
  private TradeDao tradeDao;
  @Autowired
  private ParamsDao paramsDao;
  
  @Transactional(propagation=Propagation.NOT_SUPPORTED,readOnly=true)
  List<Trade> getUnTransferTrade() throws Exception{
    return tradeDao.getFinancingTrade();
  }
  
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
  public void doSetTransferTag() throws Exception{
    Params p =paramsDao.findByParamName(Const.VALID_IDS);
    if(p==null) return;
    String ids =p.getStrValue();
    List<Trade> list =getUnTransferTrade();
    if(list==null || list.size()==0) return;
    for(int i=0;i<list.size();i++)
    {
       Trade trade =list.get(i);
       doGetTransferInfo(trade,ids);
    }
    
  }
 
  
  /**
   * 获取过户信息
   * @throws Exception
   */
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
  void doSaveTransferInfo(Trade trade) throws Exception{
    trade.setFirstTransferTag("1");
    trade.setState(Const.ACQU_TRANSFERED_STR);
    tradeDao.save(trade);
  }
  
  
  private void doGetTransferInfo(Trade trade,String ids) throws Exception{
    try
    {
      String params ="vinCode=@vinCode&ids=@ids";
      params =params.replaceAll("@vincode", trade.getVehicle().getShelfCode());
      params =params.replaceAll("@ids", ids);
      String resStr =HttpUtils.sendPost(Const.TRANSFER_FINACING_ACQU_URL,params,"utf8");
      if(resStr.equals("1"))
      {
         doSaveTransferInfo(trade);
      }
    }
    catch(Exception e)
    {
      log.error("doGetTransferInfo",e);
    }
  }
  
}
