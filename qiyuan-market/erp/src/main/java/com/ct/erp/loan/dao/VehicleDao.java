package com.ct.erp.loan.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;
@Repository
public class VehicleDao extends BaseDaoImpl<Vehicle> {
	
	public Vehicle findVehicleByTradeId(Long tradeId) throws Exception{
		String hql ="select * from trade t where t.id= :tradeId";
		Finder finder =  Finder.create(hql);
		finder.setParam("tradeId", tradeId);
		List<Trade> list =this.find(finder);
		if (list !=null && list.size()>0)
		{
			return list.get(0).getVehicle();
		}
		return null;
	}
	
	public Vehicle findVehicleId(Long id) throws Exception{
		String hql ="from Vehicle t where t.id= :id";
		Finder finder =  Finder.create(hql);
		finder.setParam("id", id);
		List<Vehicle> list =this.find(finder);
		if (list !=null && list.size()>0)
		{
			return list.get(0);
		}
		return null;
	}

}
