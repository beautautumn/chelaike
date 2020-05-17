package com.ct.erp.sys.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.lib.entity.TodoLog;
import com.ct.erp.sys.dao.TodoLogDao;
@Service
public class TodoLogService {

	@Autowired
	private TodoLogDao todoLogDao;
	
	public List<TodoLog> findBystaffIdAndState(Long staffId,int pageNo,int pageSize) {
		return todoLogDao.findBystaffIdAndState(staffId,pageNo,pageSize);
	}
	
}
