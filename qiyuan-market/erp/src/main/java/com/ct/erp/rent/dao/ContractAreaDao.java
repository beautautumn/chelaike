package com.ct.erp.rent.dao;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.SiteArea;

@Repository
public class ContractAreaDao extends BaseDaoImpl<ContractArea>{
	
	@SuppressWarnings("unchecked")
	public List<String> findAreaNo() {
		List<String> list = this.getSession()
		.createQuery("select ca.areaNo from ContractArea ca ")
		.list();
		if ((list != null) && (list.size() > 0)) {
			  return list;                        
		}
		return null;
	}

	/**
	 * 根据场地编号查找
	 * @param id
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ContractArea> findContractAreaByAreaId (Long id){
		List<ContractArea> list = this.getSession()
		.createQuery("from ContractArea a where a.siteArea.id =:id")
		.setParameter("id", id).list();
		return list;
	}
	
	@SuppressWarnings("unchecked")
	public List<String> findAreaNoBeforeContinueEndDate(
			Timestamp continueEndDate) {
		List<String> list=this.getSession().createQuery("from Contract a where a.createTime <: createTime").setParameter("createTime", continueEndDate).list();
		
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<String> findCurrentAreas() {
		List<String> list=this.getSession().createQuery("select ca.areaNo from ContractArea ca where ca.contract.state = '101' or ca.contract.state = '102' ").list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<ContractArea> findContractAreasByContractId(Long id) {
		List<ContractArea> list=this.getSession().createQuery("from ContractArea ca where ca.contract.id =:id").setParameter("id", id).list();
		return list;
	}
	
	public  List<ContractArea>  findConractBysiteAreaId(Long siteAreaId){
        String hql =" from ContractArea c where c.contract.state in(101,102) and  c.siteArea.id = :siteAreaId";
        Finder finder = Finder.create(hql);
        finder.setParam("siteAreaId", siteAreaId);
        return this.find(finder);
	}

	@SuppressWarnings("unchecked")
	public List<ContractArea> findByAgencyId(Long id) {
		String hql = " from ContractArea c where c.contract.agency.id = "+id;
		Finder finder = Finder.create(hql);
		return this.find(finder);
	}	
}
