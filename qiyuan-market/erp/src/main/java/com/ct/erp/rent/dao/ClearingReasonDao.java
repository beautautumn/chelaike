package com.ct.erp.rent.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.ClearingReason;

@Repository
public class ClearingReasonDao extends BaseDaoImpl<ClearingReason> {

	@SuppressWarnings("unchecked")
	public List<ClearingReason> findAgencyReason() {
		return this.getSession().createQuery("from ClearingReason cr where cr.clearingType = '0' and cr.status = '1' ").list();
	}

	
}
