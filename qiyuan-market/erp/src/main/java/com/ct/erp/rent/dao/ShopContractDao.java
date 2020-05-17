package com.ct.erp.rent.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.ShopContract;
@Repository
public class ShopContractDao extends BaseDaoImpl<ShopContract>{

	@SuppressWarnings("unchecked")
	public ShopContract findById(Long id) {
		List<ShopContract> list = this.getSession()//
				.createQuery("from ShopContract where id=:id")//
				.setParameter("id", id)//
				.list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}
	

}
