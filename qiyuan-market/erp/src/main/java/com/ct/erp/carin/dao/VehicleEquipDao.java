package com.ct.erp.carin.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.VehicleEquip;

@Repository
public class VehicleEquipDao extends BaseDaoImpl<VehicleEquip> {

	/**
	 * 保存或修改 VehicleEquip
	 * @param ve
	 */
	public void saveVehicleEquip(VehicleEquip ve){
		
		this.saveOrUpdate(ve);
	}

	public VehicleEquip findByVehicleId(Long id) {
		String hql = "from VehicleEquip v where v.Vehicle.id="+id;
		Finder finder = Finder.create(hql);
	    List<VehicleEquip> list =this.find(finder);
	    if((list!=null)&&(list.size()>0))
	    {
	      return list.get(0);
	    }
	    return null;
	}
}
