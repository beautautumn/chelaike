package com.ct.erp.report.dao;

import com.ct.erp.check.dao.CheckTaskDao;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.CheckTask;
import org.springframework.stereotype.Repository;

@Repository
public class ReportDao extends BaseDaoImpl<CheckTask> {
    public int countById( Long id) {
        String hql="from CheckTask r where  r.id != :id";
        Finder finder = Finder.create(hql).setParam("id", id);
        return this.countQueryResult(finder);
    }
}
