package com.ct.erp.loan.dao;

import java.util.List;
import org.springframework.stereotype.Repository;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.PayAgencyHis;
@Repository
public class PayAgencyHisDao extends BaseDaoImpl<PayAgencyHis> {
	public List<PayAgencyHis> findListByFinancingId(Long financingId) throws Exception{
		String hql =" from PayAgencyHis p where p.financing.id= :financingId";
		Finder finder =  Finder.create(hql);
		finder.setParam("financingId", financingId);
		return this.find(finder);
	}	 
}
