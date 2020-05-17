package com.ct.erp.market.dao;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Market;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;

import java.util.Iterator;
import java.util.List;

@Repository
public class MarketDao extends BaseDaoImpl<Market> {

    public List<Market> findValidMarketList() {
        String hql=" from Market s where s.marketStatus = 'normal'";
        Finder finder = Finder.create(hql);
        return this.find(finder);
    }
    public int countMarketMobile(String marketMobile){
        String hql = "from Market mkt where mkt.marketMobile = :marketMobile";
        Finder finder = Finder.create(hql).setParam("marketMobile", marketMobile);
        return this.countQueryResult(finder);
    }

    public Long getCompanyId(Long marketId) {
        String sql = "select id from companies where erp_market_id = :market_id";
        List list = this.getSession().createSQLQuery(sql)
                .addScalar("id", StandardBasicTypes.LONG)
                .setLong("market_id", marketId)
                .list();
        if (list.size() == 1) { //只返回第一个查询到的结果
            return (Long) list.get(0);
        }
        return null; //否则返回 null
    }

    //根据id查询market
    public Market findById(Long marketId) {
        String hql=" from Market s where marketId = :marketId";
        Finder finder = Finder.create(hql);
        finder.setParam("marketId",marketId);
        List<Market> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list.get(0);
        }
        return null;
    }

}
