package com.ct.erp.list.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.ViewParam;

@Repository
public class ViewParamDao extends BaseDaoImpl<ViewParam> {
	
	public List<ViewParam> findListByCodes(String codes) {
		String hql = "from ViewParam t where t.paramCode in ("+codes+")";
		return this.find(hql);
	}
}