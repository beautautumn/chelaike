package com.ct.erp.rent.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.ContractShop;

@Repository
public class ContractShopDao extends BaseDaoImpl<ContractShop>{

	@SuppressWarnings("unchecked")
	public List<String> findCurrentAreas() {
		List<String> list=this.getSession().createQuery("select ca.areaNo from ContractShop ca where ca.shopContract.state = '101' or ca.shopContract.state = '102' ").list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<ContractShop> findContractShopsByContractId(Long id) {
		List<ContractShop> list=this.getSession().createQuery("from ContractShop ca where ca.shopContract.id =:id").setParameter("id", id).list();
		return list;
	}

	public  List<ContractShop>  findConractBysiteShopId(Long siteShopId){
        String hql =" from ContractShop c where c.shopContract.state in(101,102) and  c.siteShop.id = :siteShopId";
        Finder finder = Finder.create(hql);
        finder.setParam("siteShopId", siteShopId);
        return this.find(finder);
	}

}
