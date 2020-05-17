package com.ct.erp.sys.dao;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.FirstCheck;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.User;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class UserDao extends BaseDaoImpl<User> {

 /*   public User findCheckById(Long userId){
        String hql = "select c from User c where id=:UserId";
        Finder finder = Finder.create(hql);
        finder.setParam("taskId", userId);
        List<User> list = this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list.get(0);
        }
        return null;
    }
    public List<User> findAll(){
        String hql = "select c from User c where id=:userId";
        Finder finder = Finder.create(hql);
        finder.setParam("userId", 1);
        List<User> list= this.find(finder);
        if ((list != null) && (list.size() > 0)) {
            return list;
        }
        return null;
    }*/
}
