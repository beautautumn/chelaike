package com.ct.erp.rent.dao;


import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.FeeItem;


@Repository
public class FeeItemDao extends BaseDaoImpl<FeeItem>{
	/**
	 * 根据id查找FeeItem对象
	 * @param id
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public FeeItem findById(Long id){
		List<FeeItem> list = this.getSession()//
								 .createQuery("select s from FeeItem s where id=:id")//
								 .setParameter("id", id)//
								 .list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}
	public List<FeeItem> findByStatus(String status){
		return this.getSession()//
		 .createQuery("select s from FeeItem s where status=:status")//
		 .setParameter("status", status)//
		 .list();
	}
}
