package com.ct.erp.check.dao;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.CheckTask;
import com.ct.erp.lib.entity.Staff;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by x on 2017/9/8.
 */
@Repository
public class CheckTaskDao extends BaseDaoImpl<CheckTask> {

    //查询当前检测单
    public CheckTask findCheckById(Long checkId){
        String hql = "select c from CheckTask c where taskId=:taskId";
        Finder finder = Finder.create(hql);
        finder.setParam("taskId", checkId);
        List<CheckTask> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list.get(0);
        }
        return null;
    }
}
