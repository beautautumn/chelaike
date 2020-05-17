package com.ct.erp.task;

import org.springframework.beans.factory.annotation.Autowired;

import com.ct.erp.task.service.AutoAddToDoService;

public class AutoAddToDo {
	@Autowired
	private AutoAddToDoService autoAddToDoService;
	public void addToDo(){
		try {
			autoAddToDoService.scanfContracts();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
