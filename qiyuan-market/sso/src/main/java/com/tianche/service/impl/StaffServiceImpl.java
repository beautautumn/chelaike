package com.tianche.service.impl;

import com.tianche.dao.StaffDao;
import com.tianche.domain.StaffModel;
import com.tianche.service.IStaffService;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


/**
 * Created by jf on 15/6/3.
 */

@Service
public class StaffServiceImpl implements IStaffService {

    @Resource
    private StaffDao staffDao;

    @Override
    public StaffModel getStaffByLoginName(String username) {
        if(StringUtils.isNotBlank(username)){
            return staffDao.findByLogin(username);
        }else{
            return null;
        }
    }

}
