package com.ct.erp.core.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.model.Pagination;
import com.ct.erp.core.model.ComboboxDataBean;
import com.ct.erp.core.service.StaffService;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.sys.dao.StaffDao;

@Service("core.staffService")
public class StaffServiceImpl implements StaffService{
	@Autowired
	private StaffDao dao;
	
	@Override
	public List<ComboboxDataBean> findParamCombobox(
			Map<String, Object> conditionMap,String code) throws ServiceException {
		List<Staff> list=this.findListByCondition(conditionMap);
		if(list==null)return null;
		List<ComboboxDataBean> result=new ArrayList<ComboboxDataBean>();
		ComboboxDataBean topBean=new ComboboxDataBean("","==请选择==");
		result.add(topBean);
		for(Staff info:list){
			ComboboxDataBean bean=null;
			if(info.getId().toString().equals(code)){
				bean=new ComboboxDataBean(info.getId().toString(),info.getName(),true);
			}else bean=new ComboboxDataBean(info.getId().toString(),info.getName());
			result.add(bean);
		}
		return result;
	}
	
	public List<ComboboxDataBean> findStaffList(
			Map<String, Object> conditionMap,String code,boolean headTag) throws ServiceException {
		List<Staff> list=this.findListByCondition(conditionMap);
		if(list==null)return null;
		List<ComboboxDataBean> result=new ArrayList<ComboboxDataBean>();
		for(Staff info:list){
			ComboboxDataBean bean=null;
			if(info.getId().toString().equals(code)){
				bean=new ComboboxDataBean(info.getId().toString(),info.getName(),true);
			}else bean=new ComboboxDataBean(info.getId().toString(),info.getName());
			result.add(bean);
		}
		return result;
	}

	@Override
	public List<Staff> findListByCondition(
			Map<String, Object> conditionMap) throws ServiceException {
		return dao.findListByCondition(conditionMap);
	}

	@Override
	public Staff findByStaffId(Long staffId)
			throws ServiceException {
		// TODO Auto-generated method stub
		return dao.get(staffId);
	}

	public Pagination findByPager(int pageNo, int pageSize)
			throws ServiceException {
		return dao.findByPager(pageNo, pageSize);
	}
	
	
}

