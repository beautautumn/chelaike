package com.ct.erp.loan.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.PayOwnerHis;
@Repository
public class PayOwnerHisDao extends BaseDaoImpl<PayOwnerHis> {
	public List<PayOwnerHis> findListByFinancingId(Long financingId) throws Exception{
		String hql =" From PayOwnerHis p where p.financing.id= :financingId";
		Finder finder =  Finder.create(hql);
		finder.setParam("financingId", financingId);
		return this.find(finder);
	}	 
}
