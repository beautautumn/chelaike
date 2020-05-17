package com.tianche.service;

import com.tianche.domain.StaffModel;

/**
 * Created by jf on 15/6/3.
 */
public interface IStaffService {
    StaffModel getStaffByLoginName(String username);
}
