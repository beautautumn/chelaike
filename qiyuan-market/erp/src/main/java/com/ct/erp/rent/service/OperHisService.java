package com.ct.erp.rent.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.sys.dao.OperHisDao;

@Service
public class OperHisService {
	@Autowired
	private OperHisDao operHisDao;
	public void save(OperHis operHis){
		operHisDao.save(operHis);
	}
}
