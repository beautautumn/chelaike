package com.ct.erp.rent.dao;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.RecvFee;
@Repository
public class RecvFeeDao extends BaseDaoImpl<RecvFee> {

	@SuppressWarnings("unchecked")
	public List<RecvFee> findByAsOfDate(Long contractId, Timestamp asOfDate) {
		List<RecvFee> list = this.getSession().
					createQuery("from RecvFee rv where rv.contract.id =:contractId and rv.asOfDate <= asOfDate ").
					setParameter("contractId", contractId).list();
		return list;
	}
	@SuppressWarnings("unchecked")
	public List<RecvFee> findBycontractIdandrecvType(Long contractId,String recvType){
		List<RecvFee> list = this.getSession()
								.createQuery("from RecvFee rv where rv.contract.id =:contractId and rv.recvType=:recvType")
								.setParameter("recvType", recvType)
								.setParameter("contractId", contractId).list();
		return list;
	}
}
