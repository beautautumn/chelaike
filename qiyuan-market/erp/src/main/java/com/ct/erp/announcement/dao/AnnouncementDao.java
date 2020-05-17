package com.ct.erp.announcement.dao;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.common.orm.hibernate3.Updater;
import com.ct.erp.lib.entity.Announcement;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class AnnouncementDao extends BaseDaoImpl<Announcement> {
    public List<Announcement> getLatestAnnouncements(Long marketId) {
        String sql = "select * from announcements " +
                "where state = true " +
                "and company_id =(select id from companies where erp_market_id = :marketId) " +
                "ORDER BY top desc NULLS LAST, created_at desc limit 6";

        Query query = this.getSession().createSQLQuery(sql).addEntity("t", Announcement.class);
        query.setLong("marketId", marketId);
        return query.list();
    }
}
