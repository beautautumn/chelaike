package com.ct.erp.rent.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.ManagerFee;
@Repository
public class ManagerFeeDao extends BaseDaoImpl<ManagerFee>{

	public ManagerFee findById(Long managerFeeId) {
		List<ManagerFee> list = this.getSession()//
									.createQuery("select s from ManagerFee s where s.id=:id")//
									.setParameter("id",managerFeeId )//
									.list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}

}
