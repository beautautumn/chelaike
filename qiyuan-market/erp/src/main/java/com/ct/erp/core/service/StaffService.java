package com.ct.erp.core.service;

import java.util.List;
import java.util.Map;

import javax.xml.rpc.ServiceException;

import com.ct.erp.common.model.Pagination;
import com.ct.erp.core.model.ComboboxDataBean;
import com.ct.erp.lib.entity.Staff;


public interface StaffService extends ParamCoreService{

	public List<Staff> findListByCondition(Map<String,Object> conditionMap)throws ServiceException;
	
	public List<ComboboxDataBean> findStaffList(
			Map<String, Object> conditionMap,String code,boolean headTag) throws ServiceException;

	public Staff findByStaffId(Long staffId) throws ServiceException;
	
	public Pagination findByPager(int pageNo, int pageSize);
}