package com.ct.erp.list.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.model.Pagination;
import com.ct.erp.common.orm.hibernate3.OrderBy;
import com.ct.erp.lib.entity.DynamicView;
import com.ct.erp.list.dao.DynamicViewDao;
import com.ct.erp.list.service.DynamicTableService;

@Service
public class DynamicTableServiceImpl implements DynamicTableService{

	@Autowired
	private DynamicViewDao dynamicViewDao;
	
	
	public DynamicView findByPk(Integer dynamicViewId) {		
		return dynamicViewDao.get(dynamicViewId);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public DynamicView saveOrUpdate(DynamicView entity) {	
		return (DynamicView)dynamicViewDao.saveOrUpdate(entity);
	}
	
	public Pagination findListByPage(int pageNo,int pageSize) {
		return dynamicViewDao.findAll(pageNo, pageSize, OrderBy.asc("dynamicViewId"));
		
	}

}
