package com.ct.erp.check.service;

import com.ct.erp.check.dao.CheckTaskDao;
import com.ct.erp.lib.entity.CheckTask;
import com.ct.erp.lib.entity.Market;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.market.dao.MarketDao;
import com.ct.erp.market.service.ServiceResult;
import com.ct.erp.sys.dao.StaffDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.sql.Timestamp;
import java.util.List;

@Service
@Transactional
public class CheckTaskService {
    @Autowired
    private CheckTaskDao checkTaskDao;

    @Autowired
    private StaffDao staffDao;

    /**
     * 创建或修改检测员，用于检测员维护创景
     * 同时创建检测员的同时要创建登陆用户，用于检测员登陆查看检测任务单并回填检测报告url
     *
     * @param staff
     * @return
     */
    public ServiceResult createCheckStaff(Staff staff){

//        List<Staff> staffs = staffDao.findByLoginName(market.getMarketMobile());
//        if(staffs != null && staffs.size() > 0){
//            return new ServiceResult(false,"手机号"+market.getMarketMobile()+"已被注册,请使用其它手机号码进行注册.");
//        }
//        try {
//            marketDao.save(market);
//            Staff staff = new Staff();
//            staff.setLoginName(market.getMarketMobile());
//            staff.setName(market.getMarketName());
//            staff.setStatus("1");
//            staff.setLoginPwd(new StringBuilder(market.getMarketMobile()).reverse().toString());
//            staff.setCreateTime(new Timestamp(System.currentTimeMillis()));
//            staff.setUpdateTime(new Timestamp(System.currentTimeMillis()));
//            staff.setMarket(market);
//            staffDao.save(staff);
//            return new ServiceResult(true, "商户创建成功!");
//        } catch (Exception e) {
//            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
//            e.printStackTrace();
//        }
        staffDao.saveOrUpdate(staff);
        return new ServiceResult(false, "检测员创建失败!");
    }

    /**
     * 根据检测员属性查询检测员列表，用于检测员维护、派单场景
     * @param checkStaff
     * @return
     */
    public List<Staff> getCheckStaffList(Staff checkStaff) {
        return staffDao.findAll();
    }

    /**
     * 创建或修改检测任务单，用于任务单的创建、派单、填写检测报告URL场景
     * @param checkTask
     */
    public void createCheckTask(CheckTask checkTask) {
        checkTaskDao.saveOrUpdate(checkTask);
    }

    /**
     * 根据监测任务单查询监测任务单列表，用于创建、派单、填写检测报告URL场景
     * @param checkTask
     * @return
     */
    public List<CheckTask> getCheckTaskList(CheckTask checkTask) {
        return checkTaskDao.findAll();
    }

}
