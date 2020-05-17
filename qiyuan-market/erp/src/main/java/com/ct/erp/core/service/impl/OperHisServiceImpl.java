package com.ct.erp.core.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.core.service.OperHisService;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.util.UcmsWebUtils;

@Service("core.operHisService")
public class OperHisServiceImpl implements OperHisService {

	@Autowired
	private OperHisDao operHisDao;

	@Override
	public List<OperHis> findHisListByObjIdAndTag(Long objId, Short operTag)
			throws Exception {
		return this.operHisDao.findHisListByObjIdAndTag(objId, operTag);
	}

	@Override
	public OperHis createOperHis(String rightCode, String operDesc, Long objId,
			Short operTag, Staff staff) throws Exception {
		OperHis oper = new OperHis();
		Sysright sy = new Sysright();
		sy.setRightCode(rightCode);
		oper.setOperDesc(operDesc);
		oper.setOperObj(Long.parseLong(objId.toString()));
		oper.setOperTag(operTag.toString());
		oper.setOperTime(UcmsWebUtils.now());
		oper.setStaff(staff);
		OperHis newHis = this.operHisDao.save(oper);
		return newHis;
	}

}
