package com.ct.erp.aop.dao;


import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.LogParam;

@Repository
public class LogParamAspectDao extends BaseDaoImpl<LogParam>{

	public LogParam findlogParamById(String methodName) {
		String hql = "from LogParam s where s.method=:methodName";
		Finder finder = Finder.create(hql);
		finder.setParam("methodName", methodName);
		List<LogParam> list = this.find(finder);
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}
}
