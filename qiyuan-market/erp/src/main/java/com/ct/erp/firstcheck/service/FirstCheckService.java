package com.ct.erp.firstcheck.service;

import com.ct.erp.firstcheck.dao.FirstCheckDao;
import com.ct.erp.lib.entity.FirstCheck;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class FirstCheckService {
    @Autowired
    FirstCheckDao firstCheckDao;

    public FirstCheck findFirstCheckById(Long firstCheckId){
        return firstCheckDao.findCheckById(firstCheckId);
    }
    public List<FirstCheck> findAll(){
        return firstCheckDao.findAll();
    }
    public Object update(FirstCheck firstCheck){
        return firstCheckDao.update(firstCheck);
    }
}
