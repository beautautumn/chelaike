package com.ct.erp.rent.dao;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.Contract;

@Repository
public class ContractDao extends BaseDaoImpl<Contract> {
	/**
	 * 根据合同信息ID查询
	 * @param id
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Contract findById(Long id){
		List<Contract> list = this.getSession()//
								.createQuery("from Contract where id=:id")//
								.setParameter("id", id)//
								.list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<Contract> findContractBeforeContinueEndDate(Timestamp continueEndDate) {
		List<Contract> list = this.getSession()//
		.createQuery("from Contract a where a.endDate<:continueEndDate")//
		.setParameter("continueEndDate", continueEndDate)//
		.list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<Contract> finByEndDate(Timestamp endDate) {
		List<Contract> list = this.getSession()//
		.createQuery("from Contract a where a.endDate =:endDate")//
		.setParameter("endDate", endDate)//
		.list();
		return list;
	}

	public List<Contract> findByAgencyId(Long agencyId,String state) {
		List<Contract> list=null;
		try{
			String hql = "from Contract where agency.id=:agencyId";
			if(state!=null&&state.length()>0){
				hql += " and state='"+state+"'";
			}
			list = this.getSession()//
			.createQuery(hql)//
			.setParameter("agencyId", agencyId)//
			.list();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public List<Contract> findByAgencyId(Long agencyId) {
		List<Contract> list=null;
		try{
			String hql = "from Contract where agency.id=:agencyId and state <> '104'";
			list = this.getSession()//
			.createQuery(hql)//
			.setParameter("agencyId", agencyId)//
			.list();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<Contract> findByAgencyname(String agencyName,String state) {
		List<Contract> list = this.getSession()
									.createQuery("from Contract where agency.agencyName=:agencyName and agency.state=:state and agency.status=1")//
									.setParameter("agencyName", agencyName)
									.setParameter("state", state)
									.list();
		if ((list != null) && (list.size() > 0)) {
			return list;
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public List<Contract> findCurrentByAgencyname(String agencyName) {
		List<Contract> list = this.getSession()
									.createQuery("from Contract where agency.agencyName=:agencyName and ( state =101 or state=102 ) ")//
									.setParameter("agencyName", agencyName)
									.list();
		if ((list != null) && (list.size() > 0)) {
			return list;
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<Contract> findByCondition(String agencyName, Long contractAreaId,
			Timestamp startBeginDate, Timestamp startEndDate, Timestamp endBeginDate,Timestamp endFinalDate) {
		String hql="from  Contract c where 1 = 1";

		if(!(agencyName==null||agencyName.trim().length()==0)){
			hql+="and c.agency.agencyName like '%"+agencyName.trim()+"%'";
		}
		if(!(contractAreaId==null)){
			hql+="and c.contractArea.contractAreaId = "+contractAreaId;
		}
		if(!(startBeginDate==null)){
			hql+="and c.startDate >= "+startBeginDate ;
		}
		if(!(startEndDate==null)){
			hql+="and c.startDate <= "+startEndDate ;
		}
		if(!(endBeginDate==null)){
			hql+="and c.endDate >= "+endBeginDate ;
		}
		if(!(endFinalDate==null)){
			hql+="and c.endDate <= "+endFinalDate ;
		}
		
		
		List<Contract> list=this.getSession().createQuery(hql).list();
		
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<Contract> findCurrentAll() {
		List<Contract> list = this.getSession().createQuery("from Contract where status = '1' and ( state = '101' or state='102' )").list();
		if ((list != null) && (list.size() > 0)) {
			return list;
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<Contract> findAvaByAgencyId(Long agencyId) {
		List<Contract> list=this.getSession()
			.createQuery("from Contract c where c.agency.id =:agencyId and c.status = '1' and  c.state='102' ")
			.setParameter("agencyId", agencyId).list();
		if ((list != null) && (list.size() > 0)) {
			return list;
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<Contract> findAvailByAgencyId(Long agencyId) {
		List<Contract> list=this.getSession()
			.createQuery("from Contract c where c.agency.id =:agencyId and c.status = '1' and ( c.state='102' or c.state='101' )")
			.setParameter("agencyId", agencyId).list();
		if ((list != null) && (list.size() > 0)) {
			return list;
		}
		return null;
	}
	

	
}
