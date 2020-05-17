package com.tianche.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tianche.dao.LogDao;
import com.tianche.domain.Log;
import com.tianche.service.LogService;
@Service
public class LogServiceImpl implements LogService {
	@Resource
	private LogDao logDao;

	@Override
	@Transactional(propagation = Propagation.REQUIRED)
	public void save(Log log) throws Exception {
		this.logDao.save(log);
	}

}
