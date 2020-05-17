package com.ct.erp.rent.service;


import java.sql.Timestamp;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.ManagerFee;
import com.ct.erp.rent.dao.ManagerFeeDao;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.dao.StaffDao;

@Service
public class ManagerFeeService {
	@Autowired
	private ManagerFeeDao managerFeeDao;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private StaffDao staffDao;
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void save(ManagerFee managerFee){
			managerFee.setStaffByCreateStaff(staffDao.findById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
			managerFee.setState("0");
			managerFee.setCreateTime(new Timestamp(new Date().getTime()));
			managerFee.setUpdateTime(managerFee.getCreateTime());
			managerFee = managerFeeDao.save(managerFee);
			String operDesc = "新增物业总费，科目："+managerFee.getFeeItem().getItemName()+"，金额："+managerFee.getTotalFee();
			operHisDao.createNewOperHis(managerFee.getId(), "1",operDesc );
	}
	
	public ManagerFee findById(Long managerFeeId) {
		return managerFeeDao.findById(managerFeeId);
	} 
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void update(ManagerFee managerFee) {
		managerFee.setUpdateTime(new Timestamp(new Date().getTime()));
		String operDesc = "修改物业总费，科目："+managerFee.getFeeItem().getItemName()+"，金额："+managerFee.getTotalFee();
		operHisDao.createNewOperHis(managerFee.getId(), "1", operDesc);
		managerFeeDao.update(managerFee);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void delete(ManagerFee managerFee) {
		String operDesc = "删除物业总费，科目："+managerFee.getFeeItem().getItemName()+"，金额："+managerFee.getTotalFee();
		operHisDao.createNewOperHis(managerFee.getId(), "1", operDesc);
		managerFeeDao.delete(managerFee);
	}
	/**
	 * 李斌
	 * @param managerFeeId
	 * @param state
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void changeManagerFeeState(Long managerFeeId,String state){
		ManagerFee managerFee =  managerFeeDao.findById(managerFeeId);
		managerFee.setState(state);	
		managerFeeDao.update(managerFee);
	}
}
