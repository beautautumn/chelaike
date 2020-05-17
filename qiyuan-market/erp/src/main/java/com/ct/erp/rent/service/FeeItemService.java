package com.ct.erp.rent.service;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.FeeItem;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.rent.dao.FeeItemDao;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.service.base.StaffService;

@Service
public class FeeItemService {
	@Autowired
	private FeeItemDao feeItemDao;
	
	@Autowired
	private StaffService staffService;
	
	@Autowired
	private OperHisDao operHisDao;
	
	public List<FeeItem> findAll(){
		return feeItemDao.findAll();
	}
	
	
	public FeeItem findById(Long id){
		return feeItemDao.findById(id);
	}
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void save(FeeItem feeItem){
		OperHis operHis=new OperHis();
		feeItem.setStatus("1");
		this.feeItemDao.save(feeItem);
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("1");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"添加了物业费:"+feeItem.getItemName());
		operHis.setOperObj(feeItem.getId());
		this.operHisDao.save(operHis);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void update(FeeItem feeItem ,Long feeItemId){
		OperHis operHis=new OperHis();
		FeeItem updateItem = this.findById(feeItemId);
		updateItem.setItemName(feeItem.getItemName());
		updateItem.setItemDesc(feeItem.getItemDesc());
		updateItem.setItemGroup(feeItem.getItemGroup());
		this.feeItemDao.update(updateItem);
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("1");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"修改了物业费:"+feeItem.getItemName());
		operHis.setOperObj(feeItemId);
		this.operHisDao.save(operHis);
	}
	public List<FeeItem> findByStatus(String status){
		return feeItemDao.findByStatus(status);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void delete(Long feeItemId){
		OperHis operHis=new OperHis();
		FeeItem itemDel = this.findById(feeItemId);
		itemDel.setStatus("0");
		this.feeItemDao.update(itemDel);
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("1");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"删除了物业费:"+itemDel.getItemName());
		operHis.setOperObj(feeItemId);
		this.operHisDao.save(operHis);
	}
}
