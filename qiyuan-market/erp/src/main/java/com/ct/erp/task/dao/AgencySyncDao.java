package com.ct.erp.task.dao;

import java.util.List;

import org.springframework.stereotype.Repository;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.AgencySync;
import com.ct.erp.lib.entity.Trade;

@Repository
public class AgencySyncDao extends BaseDaoImpl<AgencySync> {

  public List<AgencySync> getUnSyncAgency() throws Exception{
    String hql=" from AgencySync a where a.state in(0,9)";
    Finder finder = Finder.create(hql);
    List<AgencySync> list =this.find(finder);
    return list;
   }

public List<AgencySync> getSyncedAgency() {
	String hql=" from AgencySync a where a.state in(1)";
    Finder finder = Finder.create(hql);
    List<AgencySync> list =this.find(finder);
    return list;
}   
}
