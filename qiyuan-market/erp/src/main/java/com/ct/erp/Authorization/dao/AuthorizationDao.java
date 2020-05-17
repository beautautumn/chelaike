package com.ct.erp.Authorization.dao;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Authorization;
import com.ct.erp.lib.entity.Cars;
import com.ct.erp.lib.entity.CheckTask;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class AuthorizationDao extends BaseDaoImpl<Authorization> {
    public Authorization findCheckByCarId(Long carId){
        String hql = "select c from Authorization c where car_id=:car_id order by created_at desc";
        Finder finder = Finder.create(hql);
        finder.setParam("car_id", carId);
        List<Authorization> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list.get(0);
        }
        return null;
    }
}
