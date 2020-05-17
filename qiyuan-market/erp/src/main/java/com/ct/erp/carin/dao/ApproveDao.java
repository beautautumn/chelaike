package com.ct.erp.carin.dao;

import java.util.List;
import org.springframework.stereotype.Repository;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Approve;

@Repository
public class ApproveDao extends BaseDaoImpl<Approve>  {

	@SuppressWarnings("unchecked")
	public Approve findByTradeId(Long tradeId) {
		String hql = "select a from Approve a where a.trade.id=:tradeId";
		Finder finder = Finder.create(hql);
		finder.setParam("tradeId", tradeId);
		List<Approve> list = this.find(finder);
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}

}
