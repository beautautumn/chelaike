package com.ct.erp.loan.dao;

import java.util.List;
import org.springframework.stereotype.Repository;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.RecvDisposalHis;
@Repository
public class RecvDisposalHisDao extends BaseDaoImpl<RecvDisposalHis> {
	
	public List<RecvDisposalHis> findListByFinancingId(Long financingId) throws Exception{
		String hql ="select p  from RecvDisposalHis p where p.financing.id = :financingId";
		Finder finder =  Finder.create(hql);
		finder.setParam("financingId", financingId);
		return this.find(finder);
	}	 
}
