package com.ct.erp.publish.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.PublishInfo;
@Repository
public class PublishInfoDao extends BaseDaoImpl<PublishInfo> {

	public PublishInfo findByTradeInfo(Long tradeId) {
		String hql = "select p from PublishInfo p where p.trade.id=:tradeId";
		Finder finder = Finder.create(hql);
		finder.setParam("tradeId", tradeId);
		List<PublishInfo> list = this.find(finder);
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}
  
}
