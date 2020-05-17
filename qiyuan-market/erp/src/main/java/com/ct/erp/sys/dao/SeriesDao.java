package com.ct.erp.sys.dao;

import java.util.List;

import org.springframework.stereotype.Repository;


import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Series;

@Repository
public class SeriesDao extends BaseDaoImpl<Series>  {
	
   public List<Series> findListByBrandId(Long brandId)throws Exception{
	   String hql=" from Series  where brand.id=:brandId";
	   Finder finder = Finder.create(hql);
	   finder.setParam("brandId", brandId);
	   List<Series> list= this.find(finder);
	   return list;
   }
   public List<Series> getListByBrandId(Long brandId){
	   String hql=" from Series s where validTag=1 and s.brand.id=:brandId order by showOrder";
	   Finder finder = Finder.create(hql);
	   finder.setParam("brandId", brandId);
	   return this.find(finder);
   }   
}
