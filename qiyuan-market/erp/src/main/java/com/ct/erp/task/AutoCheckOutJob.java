package com.ct.erp.task;

import org.springframework.beans.factory.annotation.Autowired;

import com.ct.erp.task.service.AutoCheckOutService;

public class AutoCheckOutJob {
	@Autowired
	private AutoCheckOutService autoCheckOutService;
	
	public void autoCheckOut(){
		try{
			this.autoCheckOutService.autoCheckOut();
		}catch(Exception e){
			
		}
	}

}
