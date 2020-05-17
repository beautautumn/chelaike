package com.ct.erp.sys.dao;

import java.util.List;

import org.springframework.stereotype.Repository;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Brand;

@Repository
public class BrandDao extends BaseDaoImpl<Brand> {
 
	public List<Brand> findValidList(){
	  String hql=" from Brand b where b.validTag=1 order by b.firstLetter,b.showOrder";
	  Finder finder = Finder.create(hql);
	  return this.find(finder); 
  } 
}
