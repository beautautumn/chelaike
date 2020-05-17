package com.ct.erp.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.ct.erp.task.service.AutoSendMessageService;

public class AutoSendMessageToDo {

	
	private static final Logger log = LoggerFactory.getLogger(AutoSendMessageToDo.class);
	@Autowired
	private AutoSendMessageService autoSendMessageService;
	
	public void autoSendMessage(){
		try{
			autoSendMessageService.autoTodoLogSend();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("error in AutoSendMessageToDo.autoSendMessage.method", e);
		}
	}
}
