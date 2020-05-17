package com.ct.erp.che3bao.dao;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;
import com.ct.erp.lib.entity.VehiclePic;

@Repository
public class VehiclePicDao extends BaseDaoImpl<VehiclePic> {
	
	@SuppressWarnings("unchecked")
	public List<VehiclePic> getListByTradeId(Long tradeId){
		String hql =" from VehiclePic p where p.status='1' and p.trade.id=:tradeId";
		Finder finder=Finder.create(hql);
		finder.setParam("tradeId", tradeId);
		return this.find(finder);
  	}
	
  	public void deleteByVId(Long id) {
		String hql=" delete VehiclePic v where v.vehicle.id=:id ";
		Query query = this.getSession().createQuery(hql)
                .setParameter("id", id);
		query.executeUpdate();
	}

	public VehiclePic findFront() {
		String hql = "from VehiclePic p where p.status='1' and p.isFront='1'";
		Finder finder =  Finder.create(hql);
		List<VehiclePic> list =this.find(finder);
		if (list !=null && list.size()>0)
		{
			return list.get(0);
		}
		return null;
	}

}
