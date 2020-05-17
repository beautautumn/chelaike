package com.ct.erp.task.dao;

import java.util.List;

import org.springframework.stereotype.Repository;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.VehicleSync;

@Repository
public class VehicleSyncDao extends BaseDaoImpl<VehicleSync> {

  public List<VehicleSync> getUnSyncVehicle() throws Exception{
    String hql=" from VehicleSync a where a.state in(0,9)";
    Finder finder = Finder.create(hql);
    List<VehicleSync> list =this.find(finder);
    return list;
   }   
  
  @SuppressWarnings("unchecked")
	public VehicleSync findByTradeId(Long id) {
		String hql=" from VehicleSync a where a.trade.id="+id;
	    Finder finder = Finder.create(hql);
	    List<VehicleSync> list =this.find(finder);
	    if(list.size()>0){
	    	return list.get(0);
	    }
	    return null;
	}
}
