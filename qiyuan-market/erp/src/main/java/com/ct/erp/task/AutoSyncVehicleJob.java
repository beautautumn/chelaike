package com.ct.erp.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.ct.erp.task.service.SyncVehicleService;
import com.ct.erp.task.service.SyncVehicleServiceBack;

public class AutoSyncVehicleJob {
  private static final Logger log = LoggerFactory.getLogger(AutoSyncVehicleJob.class);
 
  @Autowired
  private SyncVehicleService syncVehicleService;
  @Autowired
  private SyncVehicleServiceBack syncVehicleServiceBack;
  
  public void autoSyncVehicleInfo() {
    try 
    {
      syncVehicleService.doSyncVehicleInfo();
    } catch (Exception e) {
      log.error("error in AutoSyncVehicleJob.autoSyncVehicleInfo.method", e);
    }
  }
  
  
  public void autoSyncVehicleBack() {
    try 
    {
    	syncVehicleServiceBack.doSyncVehicleInfoBack();
    } catch (Exception e) {
      log.error("error in AutoSyncVehicleJob.autoSyncVehicleBack.method", e);
    }
  }
  
  public void autoSyncAllVehicleBack() {
	  try{
		  syncVehicleServiceBack.doSyncAllVehicleBack();
	  }catch (Exception e){
		  log.error("error in AutoSyncVehicleJob.autoSyncAllVehicleBack.method", e);
	  }
  }
  
  
  
  
  
  public void autoSyncVehicleInfo(SyncVehicleService syncVehicleService) {
	    try 
	    {
	      syncVehicleService.doSyncVehicleInfo();
	    } catch (Exception e) {
	      log.error("error in AutoSyncAgencyJob.doSyncVehicleInfo.method", e);
	    }
	  }
  
  public void autoSyncVehicleBack(SyncVehicleServiceBack syncVehicleServiceBack) {
	    try 
	    {
	    	syncVehicleServiceBack.doSyncVehicleInfo();
	    } catch (Exception e) {
	      log.error("error in AutoSyncAgencyJob.doSyncVehicleInfo.method", e);
	    }
	  }
  
  public static void main(String args[]) throws Exception {
	  AutoSyncVehicleJob task = new AutoSyncVehicleJob();
		ApplicationContext context = new ClassPathXmlApplicationContext(
		        new String[] { "applicationContext.xml" });
		SyncVehicleServiceBack syncVehicleServiceBack = (SyncVehicleServiceBack) context
		        .getBean("syncVehicleServiceBack");
		try {
			task.autoSyncVehicleBack(syncVehicleServiceBack);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
  
  
  
}
