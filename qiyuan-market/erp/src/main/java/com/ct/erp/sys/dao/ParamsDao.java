package com.ct.erp.sys.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.Params;
@Repository
public class ParamsDao extends BaseDaoImpl<Params> {

	@SuppressWarnings("unchecked")
	public Params findById(Long paramId) {
		List<Params> list=this.getSession().
				createQuery("from Params  where id =:paramId and status = 1").
				setParameter("paramId", paramId).list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public Params findByParamName(String paramName) {
		List<Params> list=this.getSession().
				createQuery("from Params  where paramName =:paramName and status = 1").
				setParameter("paramName", paramName).list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}


	
}
