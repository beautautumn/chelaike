package com.ct.erp.rent.dao;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.Agent;

@Repository
public class AgentDao extends BaseDaoImpl<Agent>{
	@SuppressWarnings("unchecked")
	public Agent findById(Long agentId) {
		List<Agent> list= this.getSession()
				.createQuery("from Agent where id=:agentId and status = 1")
				.setParameter("agentId", agentId)
				.list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public List<Agent> findByAgencyId(Long agencyId) {
		List<Agent> list= this.getSession()
				.createQuery("from Agent where agency.id=:agencyId and status = 1")
				.setParameter("agencyId", agencyId)
				.list();
		if ((list != null) && (list.size() > 0)) {
			return list;
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public List<Agent> findByAgentName(Long agencyId,String agentName) {
		String hql="from Agent where agency.id=? and name like ? and status = 1";
		Query query = this.getSession().createQuery(hql);  
		query.setLong(0,agencyId);
		query.setString(1,"%"+agentName.replace(" ", "")+"%");
		List<Agent> list=query.list();  
		if ((list != null) && (list.size() > 0)) {
			return list;
		}
		return null;
	}
}
