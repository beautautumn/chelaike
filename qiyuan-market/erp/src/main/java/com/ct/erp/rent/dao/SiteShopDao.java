package com.ct.erp.rent.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.SiteShop;

@Repository
public class SiteShopDao extends BaseDaoImpl<SiteShop>{

	@SuppressWarnings("unchecked")
	public List<SiteShop> findByCondition(List<String> current) {
		String hql = "from SiteShop s where s.validTag=1 and s.freeCount!= '0'";
		if((current!=null)&&(current.size()>0)){
			for(int i=0;i<current.size();i++){
				hql+=" and s.id <> "+current.get(i);
			}
		}
		List<SiteShop> list=this.getSession().createQuery(hql).list();
		return list;
	}

}
