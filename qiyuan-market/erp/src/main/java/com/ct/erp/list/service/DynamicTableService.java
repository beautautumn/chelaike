package com.ct.erp.list.service;

import com.ct.erp.common.model.Pagination;
import com.ct.erp.lib.entity.DynamicView;

public interface DynamicTableService {

	public DynamicView saveOrUpdate(DynamicView entity);
	
	public DynamicView findByPk(Integer dynamicViewId);
	
	public Pagination findListByPage(int pageNo,int pageSize);
	
}
