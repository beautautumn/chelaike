package com.ct.erp.loan.dao;

import java.util.List;
import org.springframework.stereotype.Repository;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.RefundAgencyHis;
@Repository
public class RefundAgencyHisDao extends BaseDaoImpl<RefundAgencyHis> {
	public List<RefundAgencyHis> findListByFinancingId(Long financingId) throws Exception{
		String hql =" from RefundAgencyHis p where p.financing.id= :financingId";
		Finder finder =  Finder.create(hql);
		finder.setParam("financingId", financingId);
		return this.find(finder);
	}	 
}
