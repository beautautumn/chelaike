package com.ct.erp.rent.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Agency;

@Repository
public class AgencyDao extends BaseDaoImpl<Agency>{

	@SuppressWarnings("unchecked")
	public Agency findById(Long agencyId) {
		List<Agency> list= this.getSession()//
							.createQuery("from Agency where id=:agencyId and status = '1'")//
							.setParameter("agencyId", agencyId)//
							.list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}

	public Agency findByIdWithStatus(Long agencyId) {
		List<Agency> list= this.getSession()//
				.createQuery("from Agency where id=:agencyId")//
				.setParameter("agencyId", agencyId)//
				.list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public List<Agency> findByState(String state) {
		return this.getSession()//
				.createQuery("select s from Agency s where s.state=:state"+" and s.status = '1'")//
				.setParameter("state", state)//
				.list();
	}

	@SuppressWarnings("unchecked")
	public List<Agency> findByConditionTwoState(String state1, String state2) {
		return this.getSession()//
		.createQuery("select s from Agency s where (s.state=:state1 or s.state=:state2) and s.status = '1'")//
		.setParameter("state1", state1).setParameter("state2", state2)//
		.list();
	}
	
	@SuppressWarnings("unchecked")
	public List<Agency> findByConditionState(String state1, String state2,
			String state3) {
		return this.getSession()//
		.createQuery("select s from Agency s where (s.state=:state1 or s.state=:state2 or s.state=:state3) and s.status = '1'")//
		.setParameter("state1", state1).setParameter("state2", state2).setParameter("state3", state3)//
		.list();
	}

	
	
	@SuppressWarnings("unchecked")
	public Agency findByName(String agencyName) {
		List<Agency> list= this.getSession()//
							.createQuery("from Agency where agencyName=:agencyName and status = '1'")//
							.setParameter("agencyName", agencyName)//
							.list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}
	@SuppressWarnings("unchecked")
	public List<Agency> findExistAgency(){
		return  this.getSession()//
								.createQuery("from Agency where state ='103' or state='104'")//
								.list();
	}
	public List<Agency> findValidAgencyList() {
		//String hql=" from Agency s where s.state in('101','102','103','106') and status = '1'";
		String hql=" from Agency s where status = '1'";
		Finder finder = Finder.create(hql);
        return this.find(finder);
	}
	
	public List<Agency> findValidAgenciesWithOutOne(Long agencyId) {
		String hql=" from Agency s where s.state in('101','103','106') and s.id<>:agencyId";
		Finder finder = Finder.create(hql);
		finder.setParam("agencyId", agencyId);
        return this.find(finder);
	}

	@SuppressWarnings("unchecked")
	public Agency getByOutId(long outId) {
		List<Agency> list= this.getSession()//
				.createQuery("from Agency where outerId=:outId and status = '1'")//
				.setParameter("outId", outId)//
				.list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}

    public List<Agency> findValidAgencyList(Long marketId) {
        String hql=" from Agency s where s.status = '1' and s.market.marketId = :marketId";
        Finder finder = Finder.create(hql).setParam("marketId", marketId);
        return this.find(finder);
    }
}
