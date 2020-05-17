package com.ct.erp.rotation.dao;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Market;
import com.ct.erp.lib.entity.Rotation;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class RotationDao extends BaseDaoImpl<Rotation> {

    public int countByType(String rotationType) {
        String hql="from Rotation r where r.rotationType = :rotationType";
        Finder finder = Finder.create(hql).setParam("rotationType", rotationType);
        return this.countQueryResult(finder);
    }

    public int countByTypeAndId(String rotationType, Long id) {
        String hql="from Rotation r where r.rotationType = :rotationType and r.id != :id";
        Finder finder = Finder.create(hql).setParam("rotationType", rotationType).setParam("id", id);
        return this.countQueryResult(finder);
    }
}
