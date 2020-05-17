package com.ct.erp.list.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.lib.entity.ViewParam;
import com.ct.erp.list.dao.ViewParamDao;
import com.ct.erp.list.service.ViewParamService;

@Service
public class ViewParamServiceImpl implements ViewParamService{

	@Autowired
	private ViewParamDao dao;
	@Override
	public List<ViewParam> getViewParamByCode(String code) {
		// TODO Auto-generated method stub
		return dao.findListByCodes(code);
	}
}
