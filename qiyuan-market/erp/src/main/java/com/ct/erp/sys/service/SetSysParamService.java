package com.ct.erp.sys.service;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Params;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.dao.ParamsDao;
import com.ct.erp.sys.model.ParamsBean;
import com.ct.erp.sys.service.base.StaffService;

@Service
public class SetSysParamService {
	@Autowired
	private ParamsDao paramsDao;
	@Autowired
	private StaffService staffService;
	@Autowired
	private OperHisDao operHisDao;
	public void saveParams(Params params) {
		this.paramsDao.save(params);
		OperHis operHisSys=new OperHis();
		operHisSys.setOperObj(params.getId());
		operHisSys.setOperTag("101");
		operHisSys.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHisSys.setStaff(this.staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHisSys.setOperDesc("");
		this.operHisDao.save(operHisSys);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void updateParams(ParamsBean paramsBean) {
		Params params = this.paramsDao.findById(paramsBean.getId());
		params.setIntValue(Integer.valueOf(paramsBean.getIntValue()));
		this.paramsDao.update(params);
	}
	
	public void deleteParams(Long id) {
		this.paramsDao.deleteById(id);
		OperHis operHisSys=new OperHis();
		operHisSys.setOperObj(id);
		operHisSys.setOperTag("101");
		operHisSys.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHisSys.setStaff(this.staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHisSys.setOperDesc("");
		this.operHisDao.save(operHisSys);
		
	}

	public Params findParams(Long paramId) {
		return this.paramsDao.findById(paramId);
	}

	
}
