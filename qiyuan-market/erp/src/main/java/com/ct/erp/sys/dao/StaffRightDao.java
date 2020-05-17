package com.ct.erp.sys.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.exception.DaoException;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.StaffRight;

@Repository
public class StaffRightDao extends BaseDaoImpl<StaffRight>{
	
	public List<StaffRight> findStaffRightListByStaffId(Long staffId)throws DaoException{
		return super.findByProperty("staff.id",staffId);
	}
	
	public List<StaffRight> findByStaffAndRightCode(String rightCode,Long id) {
		String hql = "select s from StaffRight s where s.sysright.rightCode=:rightCode and s.staff.id=:id";
		Finder finder = Finder.create(hql);
		finder.setParam("rightCode", rightCode);
		finder.setParam("id", id);
		return  this.find(finder);
	}
}
