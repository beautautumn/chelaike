package com.tianche.dao;

import com.tianche.domain.StaffModel;

/**
 * Created by jf on 15/6/3.
 */
public interface StaffDao {

    public StaffModel findByLogin(String loginName);
}
