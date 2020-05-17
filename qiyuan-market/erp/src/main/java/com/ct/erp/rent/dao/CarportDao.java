package com.ct.erp.rent.dao;

import java.util.List;
import org.springframework.stereotype.Repository;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Carport;

@Repository
public class CarportDao extends BaseDaoImpl<Carport> {
	public Carport findById(Long id){
		String hql = "select s from Carport s where s.id=:id";
		Finder finder = Finder.create(hql);
		finder.setParam("id", id);
		List<Carport> list = this.find(finder);
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}
	 
	public Carport findByAgencyId(Long agencyId){
		String hql = "select s from Carport s where s.agency.id=:agencyId";
		Finder finder = Finder.create(hql);
		finder.setParam("agencyId", agencyId);
		List<Carport> list = this.find(finder);
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}
	 	
	
}
