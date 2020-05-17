package com.ct.erp.carin.dao;

import java.util.List;
import org.springframework.stereotype.Repository;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.CarOperHis;

@Repository
public class CarOperHisDao extends BaseDaoImpl<CarOperHis> {
 

	public List<CarOperHis> getCarOperHisByAgencyId(Long agencyId) {
		String hql = "from CarOperHis h where h.agency.id=:agencyId   order by h.operTime desc";
		Finder finder = Finder.create(hql);
		finder.setParam("agencyId", agencyId);
		return this.find(finder);

	}

}
