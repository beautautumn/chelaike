package com.ct.erp.rent.dao;



import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.AgencyBills;
@Repository
public class AgencyBillsDao extends BaseDaoImpl<AgencyBills>{
	@SuppressWarnings("unchecked")
	public List<AgencyBills> findByIdAndState(Long agencyId,String state) {
		List<AgencyBills> list = this.getSession()//
				.createQuery("from AgencyBills a where a.agency.id=:agencyId and a.feeType=:state")//
				.setParameter("agencyId",agencyId)//
				.setParameter("state",state)//
				.list();
		return list;
	}
	
	
	public Integer findTotalFeeByAgencyIdAndState(Long agencyId){
		Integer sumFees =Integer.parseInt(((this.getSession()//
				.createQuery("select sum(a.feeValue) from  AgencyBills a where a.agency.id=:agencyId and a.state=0")//
				.setParameter("agencyId",agencyId)//
				.iterate().next().toString())));   
		return sumFees;
	}
	
	
	public Double findAgencyTotalFeeByAgencyId(Long agencyId){
		Double sumFees = Double.parseDouble(this.getSession()
				.createQuery("select IFNULL(feeValue,0)-IFNULL(recvFee,0) from  AgencyBills a where a.agency.id=:agencyId")//
				.setParameter("agencyId",agencyId).iterate().next().toString());//
		  if (sumFees == null || sumFees==0d) {   
	            return 0d;   
	        } else {       
	            return sumFees;   
	        }   		   
	}
	
	
	@SuppressWarnings("unchecked")//修改后
	public AgencyBills findByAgencyId(Long agencyId,String state) {
		String hql = "from AgencyBills a where a.agency.id=:agencyId ";
		if(state!=null&&state.length()>0){
			hql+="and state='"+state+"'";
		}
		List<AgencyBills> list = this.getSession()//
									.createQuery(hql)//
									.setParameter("agencyId",agencyId)//
									.list();
		if(list!=null&&list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	
	
	public List<AgencyBills> getCollectFees(String agencyId,Long managerFeeId,String state,String feeType){
		String hql="from AgencyBills a where 1=1 and a.state=:state and a.feeType=:feeType ";
		if(StringUtils.isNotEmpty(agencyId)){
			hql+="and a.agency.id=:agencyId ";
		}
		if(managerFeeId!=null){
			hql+="and a.managerFee.id=:managerFeeId";
		}
		Query queryObject = getSession().createQuery(hql);
		queryObject.setParameter("state",state);
		queryObject.setParameter("feeType",feeType);
		if(StringUtils.isNotEmpty(agencyId)){
			queryObject.setParameter("agencyId",Long.parseLong(agencyId));
		}
		if(managerFeeId!=null){
			queryObject.setParameter("managerFeeId",managerFeeId);
		}
		List<AgencyBills> result = queryObject.list();
		return result;
	}
	public List<AgencyBills>  getTotalFeeByAgencyIdAndStateAndrecvTime(String agencyid,
			String state,String recvTime,String feeType) throws Exception{
		String hql="from AgencyBills a where 1=1 and a.state=:state and a.feeType=:feeType ";
		if(StringUtils.isNotEmpty(agencyid)){
			hql+="and a.agency.id=:agencyid";
		}
		if(StringUtils.isNotBlank(recvTime)&&(!recvTime.equals("null"))){
			hql+=" and a.recvTime >= :begin and a.recvTime <= :end";
		}
		Query queryObject = getSession().createQuery(hql);
		if(state.equals("已收费")){
			queryObject.setParameter("state","1");
		}
		if(state.equals("未收费")){
			queryObject.setParameter("state","0");
		}
		queryObject.setParameter("feeType",feeType);
		if(StringUtils.isNotEmpty(agencyid)){
			queryObject.setParameter("agencyid",Long.parseLong(agencyid));
		}
		if(StringUtils.isNotBlank(recvTime)&&(!recvTime.equals("null"))){
			Timestamp begin = new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(recvTime).getTime());
			Timestamp end = new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(recvTime).getTime()+86400000L);
			queryObject.setParameter("begin",begin);
			queryObject.setParameter("end",end);
		}
		List<AgencyBills> result = queryObject.list();
		return result;
	}


	public Integer findAvgFeeByAgencyIdAndState(Long agencyId) {
		Integer sumFees =Integer.parseInt(((this.getSession()//
				.createQuery("select a.shareTotalFee from  AgencyBills a where a.agency.id=:agencyId and a.state=0")//
				.setParameter("agencyId",agencyId)//
				.iterate().next().toString())));   
		return sumFees;
	}


	public List<AgencyBills> findListByAgencyId(long agencyId, String state) {
		String hql = "from AgencyBills a where a.agency.id=:agencyId ";
		if(state!=null&&state.length()>0){
			hql+="and state='"+state+"'";
		}
		List<AgencyBills> list = this.getSession()//
									.createQuery(hql)//
									.setParameter("agencyId",agencyId)//
									.list();
		return list;
	}
	
	
}
