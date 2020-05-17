package com.ct.erp.task.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.lib.entity.TodoLog;
import com.ct.erp.rent.dao.ContractDao;
import com.ct.erp.sys.dao.TodoLogDao;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.msg.emay.KcbMessageService;


@Service
@Transactional(propagation = Propagation.SUPPORTS)
public class AutoSendMessageService {
	@Autowired
	KcbMessageService msg;
	@Autowired
	private TodoLogDao todoLogDao;
	@Autowired
	private ContractDao contractDao;
	
	public void autoTodoLogSend() throws Exception {
		// 获取所有待发送信息
		List<TodoLog> todoLogs = this.todoLogDao.findAllWaitSend();
		if ((todoLogs == null) || (todoLogs.size() < 1)) {
			return;
		}

		for (int i = 0; i < todoLogs.size(); i++) {
			TodoLog todoLog = todoLogs.get(i);
			long minute = UcmsWebUtils.minuteToNow(todoLog.getCreateTime());// 获取信息时间距离当前时间的分钟差,
			if (minute >= 10) {
				continue; // 如果相差超過10分钟,就不處理
			}

			// 发送短信
			int result = this.msg
			.sendSMS(new String[] { contractDao.findById(todoLog.getId()).getAgency().getUserPhone() }, todoLog.getTodoTitle(), "", 5);
			if (result == 0) {
				// 发送成功
				todoLog.setTodoState("1");
				this.todoLogDao.update(todoLog);
			}

		}
	}
}
		
		
		
		
		
	



