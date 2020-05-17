package com.ct.erp.rent.dao;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.AgencyDetailBills;
import com.ct.erp.lib.entity.FeeItem;

@Repository
public class AgencyDetailBillsDao extends BaseDaoImpl<AgencyDetailBills>{
	@SuppressWarnings("unchecked")
	public List<AgencyDetailBills> findAgencyDetailBillsByAgencyBillsId(String AgencyBillsId,String feeType){
		String hql="from AgencyDetailBills a where a.agencyBills.id=:AgencyBillsId ";
		if(StringUtils.isNotEmpty(feeType)){
			hql+="and a.feeType=:feeType";
		}
		Query queryObject = getSession().createQuery(hql);
		if(StringUtils.isNotEmpty(feeType)){
			queryObject.setParameter("feeType",feeType);
		}
		queryObject.setParameter("AgencyBillsId",Long.parseLong(AgencyBillsId));
		List<AgencyDetailBills> result = queryObject.list();
		return result;
	}
	public List<AgencyDetailBills> findAgencyDetailBillsBymanagerFeeIdAndState(Long managerId,String state){
		String hql="from AgencyDetailBills a where a.managerFee.id=:managerId and a.state=:state";
		Query queryObject = getSession().createQuery(hql);
		queryObject.setParameter("managerId",managerId);
		queryObject.setParameter("state",state);
		List<AgencyDetailBills> result = queryObject.list();
		return result;
	}
	
	
	public void changeState(List<AgencyDetailBills> agencyDetailBills){
		 for(int i=0;i<agencyDetailBills.size();i++){
			 AgencyDetailBills agencyDetailBill = agencyDetailBills.get(i);
			 agencyDetailBill.setState("1");
			 update(agencyDetailBill);
		 }
	}
	
	/**
	 * 根据商户ID查找明细账单
	 * @param agencyId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<AgencyDetailBills> findAgencyDetailBillsByAgencyId(String agencyId){
		String hql="from AgencyDetailBills a where a.agency.id=:agencyId ";
		Query queryObject = getSession().createQuery(hql);
		queryObject.setParameter("agencyId",Long.parseLong(agencyId));
		List<AgencyDetailBills> result = queryObject.list();
		return result;
	}
	@SuppressWarnings("unchecked")
	public boolean checkItem(Long agencyBillId , FeeItem feeItem) {
		String sql = "select * from tf_c_agency_detail_bills bs left join tf_c_agency_bills b on b.id=bs.agency_bills_id "+
					" left join td_b_fee_item f on f.id = bs.fee_item_id "+
					" where bs.agency_bills_id = "+agencyBillId+" and f.item_group = '"+feeItem.getItemGroup()+"'";
		 Query query = super.getSession().createSQLQuery(sql)
			        .addEntity("t", AgencyDetailBills.class);
		 List<AgencyDetailBills> list = query.list();
		 if(list.size()>0){
			 return true;
		 }
		 return false;
		 
	}
}
