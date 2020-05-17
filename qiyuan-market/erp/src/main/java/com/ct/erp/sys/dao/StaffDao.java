package com.ct.erp.sys.dao;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.ct.erp.lib.entity.Market;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.ct.erp.common.exception.DaoException;
import com.ct.erp.common.model.Pagination;
import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.FeeItem;
import com.ct.erp.lib.entity.Staff;

@Repository
public class StaffDao extends BaseDaoImpl<Staff> {

    //查询所有的有用的检测员
    public List<Staff> findUseStaff(){
        String hql = "select s from Staff s where status=:status";
        Finder finder = Finder.create(hql);
        finder.setParam("status","1");
        List<Staff> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list;
        }
        return null;
    }

    public List<Staff> findUseStaffByMarket(Market market){
        String hql = "select s from Staff s where status=:status and market=:market";
        Finder finder = Finder.create(hql);
        finder.setParam("status","1");
        finder.setParam("market",market);
        List<Staff> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list;
        }
        return null;
    }


    //查询指定id的市场所有可用的检测员
   /* public List<Staff> findUseStaffById(Long marketId){
        String hql = "select s from Staff s where status=:status and marketId=:marketId";
        Finder finder = Finder.create(hql);
        finder.setParam("status","1");
        finder.setParam("marketId",marketId);
        List<Staff> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list;
        }
        return null;
    }
*/


    public Staff findById(Long id) {
        String hql = "select s from Staff s where id=:id  ";
        Finder finder = Finder.create(hql);
        finder.setParam("id", id);
        List<Staff> list = this.find(finder);

        if ((list != null) && (list.size() > 0)) {
            return list.get(0);
        }
        return null;
    }

    public List<Staff> findAllValid() {
        String hql = "select s from Staff s where s.status=1 order by name ";
        Finder finder = Finder.create(hql);
        return this.find(finder);
    }

    public List<Staff> findTryStaffs() throws Exception {
        String hql = "select s from Staff s where s.tryAccountTag=1";
        return getSession().createQuery(hql).list();
    }

    public List<Staff> findStaffByNPS(String name, String password,
                                      String status) throws Exception {
        String hql = "select s from Staff s where s.loginName =:loginName and s.loginPwd=:loginPwd and status=:status";
        return getSession().createQuery(hql).setParameter("loginName",
                name).setParameter("loginPwd", password).setParameter("status",
                status).list();
    }

    public Staff findStaffByWxid(String wxid) {
        String hql = "select s from Staff s where s.wxOpenid =:wxid status=1";
        Finder finder = Finder.create(hql);
        finder.setParam("wxid", wxid);
        List<Staff> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list.get(0);
        }
        return null;
    }

    public List<Staff> findListByCondition(Map<String, Object> conditonMap)
            throws DaoException {
        List<Staff> result = null;
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select {t.*} from  tf_m_staff t where 1=1  ");
            combinConditionSql(conditonMap, sql);
            sql.append(" order by  name");
            Query query = super.getSession().createSQLQuery(sql.toString())
                    .addEntity("t", Staff.class);
            combinConditionParams(conditonMap, query);
            result = query.list();
        } catch (Exception e) {
            throw new DaoException("", e);
        }
        return result;
    }

    public void combinConditionSql(Map<String, Object> conditionMap,
                                   StringBuilder sql) {
        if (conditionMap == null) {
            return;
        }
        Iterator<Map.Entry<String, Object>> it = conditionMap.entrySet()
                .iterator();
        while (it.hasNext()) {
            Map.Entry<String, Object> entity = it.next();
            if (entity.getKey().equals("corp_id")) {
                sql.append(" and  t.corp_id =:corp_id");
            }
            if (entity.getKey().equals("status")) {
                sql.append(" and  t.status =:status");
            }
        }
    }

    public void combinConditionParams(Map<String, Object> conditionMap,
                                      Query query) {
        if (conditionMap == null) {
            return;
        }
        Iterator<Map.Entry<String, Object>> it = conditionMap.entrySet()
                .iterator();
        while (it.hasNext()) {
            Map.Entry<String, Object> entity = it.next();

            if (entity.getKey().equals("corp_id")) {
                query.setLong("corp_id", (Long) entity.getValue());
            }
            if (entity.getKey().equals("status")) {
                query.setString("status", (String) entity.getValue());
            }
        }
    }

    public List<Staff> findStaffsByCorpId(Long id, String status) {
        String hql = "select s from Staff s where s.corp.id=:corpId and s.status=:status";
        return getSession().createQuery(hql).setParameter("corpId", id)
                .setParameter("status", status).list();
    }

    public Staff findStaffByLoginName(String name, String status)
            throws Exception {
        String hql = "select s from Staff s where s.loginName =:loginName and status=:status";
        Finder finder = Finder.create(hql);
        finder.setParam("loginName", name);
        finder.setParam("status", status);
        List<Staff> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list.get(0);
        }
        return null;
    }

    public int findMaxCountByCorp(Long corpId, String status) throws Exception {
        String hql = "select count(s) from Staff s where s.corp.id =:id and status=:status";
        Query query = getSession().createQuery(hql);
        query.setParameter("id", corpId);
        query.setParameter("status", status);
        Long count = (Long) query.uniqueResult();
        return count.intValue();
    }

    // 2014-04-15
    public List<Staff> findByLoginName(String loginName) {
        String hql = "select s from Staff s where s.loginName=:loginName";
        Finder finder = Finder.create(hql);
        finder.setParam("loginName", loginName);
        return this.find(finder);
    }

    // 2014-04-18
    public Staff findByHql(String hql) {
        Finder finder = Finder.create(hql);
        List<Staff> result = this.find(finder);
        if ((result != null) && (result.size() > 0)) {
            return result.get(0);
        }

        return null;
    }

    public Pagination findByPager(int pageNo, int pageSize) {
        Finder finder = Finder.create("select s from Staff s  ");
        return super.find(finder, pageNo, pageSize);
    }

    public List<Staff> findByStatus(String status) {
        return this.getSession()//
                .createQuery("select s from Staff s where status=:status")//
                .setParameter("status", status)//
                .list();
    }


    public void updateByMarketId(Long marketId, String status) {
        this.getSession().createQuery("update Staff set status=:status where market.marketId=:marketId ").setParameter("status", status).setParameter("marketId", marketId).executeUpdate();
    }
}
