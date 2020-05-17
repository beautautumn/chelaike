package com.ct.erp.sys.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.lib.entity.StaffRight;
import com.ct.erp.sys.dao.StaffRightDao;

@Service
public class StaffRightService {
	@Autowired
	private StaffRightDao staffRightDao;
	
	public List<StaffRight> findByStaffAndRightCode(String rightCode,Long id){
		return staffRightDao.findByStaffAndRightCode(rightCode, id);
	}
}
