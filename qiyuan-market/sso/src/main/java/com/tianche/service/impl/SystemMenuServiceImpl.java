package com.tianche.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.tianche.dao.SystemMenuDao;
import com.tianche.domain.SystemMenu;
import com.tianche.service.SystemMenuService;

@Service
public class SystemMenuServiceImpl implements SystemMenuService {
	@Resource
	private SystemMenuDao systemMenuDao;

	@Override
	public List<SystemMenu> findByStaffId(Long id) {
		return systemMenuDao.findByStaffId(id);
	}


}
