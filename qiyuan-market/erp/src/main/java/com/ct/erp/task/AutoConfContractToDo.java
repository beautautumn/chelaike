package com.ct.erp.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.ct.erp.task.service.AutoConfigContractService;

public class AutoConfContractToDo {
	private static final Logger log = LoggerFactory.getLogger(AutoConfContractToDo.class);
	
	@Autowired
	private AutoConfigContractService autoConfigContractService;
	
	public void autoConfContract(){
		try{
			autoConfigContractService.config();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("error in AutoConfContractToDo.autoConfContract.method", e);
		}
		
		
	}
	
	

}
