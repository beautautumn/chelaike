package com.ct.erp.firstcheck.dao;

import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.CheckTask;
import com.ct.erp.lib.entity.FirstCheck;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.Staff;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class FirstCheckDao extends BaseDaoImpl<FirstCheck> {
    public FirstCheck findCheckById(Long firstCheckId){
        String hql = "select c from FirstCheck c where id=:taskId";
        Finder finder = Finder.create(hql);
        finder.setParam("taskId", firstCheckId);
        List<FirstCheck> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list.get(0);
        }
        return null;
    }
    public List<FirstCheck> findAll(){
        String hql = "select s from Staff s where status=:status";
        Finder finder = Finder.create(hql);
        finder.setParam("status","1");

        List<FirstCheck> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list;
        }
        return null;
    }


}
