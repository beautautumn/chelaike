package com.tianche.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.tianche.dao.SystemRightDao;
import com.tianche.domain.SystemRight;
import com.tianche.service.SystemRightService;

@Service
public class SystemRightServiceImpl implements SystemRightService {
	
	@Resource
	private SystemRightDao systemRightDao;

	@Override
	public List<SystemRight> findByStaffId(Long id) {
		return systemRightDao.findByStaffId(id);
	}

}
