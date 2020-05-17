package com.ct.erp.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.ct.erp.task.service.TransferService;

public class AutoGetTransferInfoJob {
  private static final Logger log = LoggerFactory.getLogger(AutoGetTransferInfoJob.class);
  @Autowired
  private TransferService transferService;
  
  public void autoGetTransferInfo() {
    try 
    {
      transferService.doSetTransferTag();
    } catch (Exception e) {
      log.error("error in AutoGetTransferInfoJob.autoGetTransferInfo.method", e);
    }
  }  
}
