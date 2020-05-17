package com.ct.erp.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.ct.erp.task.service.AgencySyncService;

public class AutoSyncAgencyJob {
  private static final Logger log = LoggerFactory.getLogger(AutoSyncAgencyJob.class);
 
  @Autowired
  private AgencySyncService agencyService;
  
  public void autoSyncAgencyInfo() {
    try 
    {
      agencyService.doSyncAgencyInfo();
    } catch (Exception e) {
      log.error("error in AutoSyncAgencyJob.doSyncAgencyInfo.method", e);
    }
  }  
  
  
  
  
  
  
  public void autoSyncAgencyInfo(AgencySyncService agencyService) {
	    try 
	    {
	      agencyService.doSyncAgencyInfo();
	    } catch (Exception e) {
	      log.error("error in AutoSyncAgencyJob.doSyncAgencyInfo.method", e);
	    }
	  }  
  
  public static void main(String args[]) throws Exception {
	  AutoSyncAgencyJob task = new AutoSyncAgencyJob();
		ApplicationContext context = new ClassPathXmlApplicationContext(
		        new String[] { "applicationContext.xml" });
		AgencySyncService agencyService = (AgencySyncService) context
		        .getBean("agencySyncService");
		try {
			task.autoSyncAgencyInfo(agencyService);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
