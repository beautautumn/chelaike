package com.ct.erp.parkingcard.dao;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.ParkingCards;
import com.ct.erp.lib.entity.Staff;
import org.springframework.stereotype.Repository;


import java.sql.Timestamp;
import java.util.List;

@Repository
public class ParkingCardsDao extends BaseDaoImpl<ParkingCards> {
    /*
    * 根据Ajax传过来的卡号去查询数据库中是否由此卡号，
    * 有则返回true
    * 无则返回false
    * */
    public Boolean checkNo(String nos){
        String hql = "from ParkingCards where no = :nos ";
        Finder finder =Finder.create(hql);
        finder.setParam("nos",nos);
        return this.find(finder).size()>0;
    }
}
