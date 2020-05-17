package com.ct.erp.sys.dao;

import java.util.List;

import org.springframework.stereotype.Repository;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Kind;

@Repository
public class KindDao extends BaseDaoImpl<Kind> {
   public List<Kind> findListBySeriesId(Long seriesId)throws Exception{
	   String hql=" from Kind k where validTag=1 and k.series.id=:seriesId order by name";
	   Finder finder = Finder.create(hql);
	   finder.setParam("seriesId", seriesId);
	   return this.find(finder);
   } 
}
