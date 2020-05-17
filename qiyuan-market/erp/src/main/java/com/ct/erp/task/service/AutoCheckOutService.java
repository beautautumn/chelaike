package com.ct.erp.task.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.carin.dao.ApproveDao;
import com.ct.erp.carin.dao.TradeDao;
import com.ct.erp.lib.entity.Approve;
import com.ct.erp.lib.entity.Trade;

@Service
public class AutoCheckOutService {
	@Autowired
	private TradeDao tradeDao;
	@Autowired
	private ApproveDao approveDao;
	
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor = Exception.class)
	public void autoCheckOut() {
		List<Trade> list = this.tradeDao.findByProperty("approveTag", "1");
		for(Trade trade : list){
			Approve approve = this.approveDao.get(trade.getApproveId());
			Date date = new Date();
			Date leaveDate = approve.getLeaveDate();
			Calendar cal = Calendar.getInstance();
			cal.setTime(leaveDate);
			cal.add(Calendar.HOUR, approve.getLeaveDays()*24);
			Date returnDate = cal.getTime();
			if(returnDate.before(date)){
				trade.setApproveTag("0");
				this.tradeDao.update(trade);
				approve.setLeaveState("4");
				this.approveDao.update(approve);
			}
			
		}
		
	}

}
