package com.ct.erp.core.service;

import java.util.List;

import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Staff;

public interface OperHisService {

	// public List<OperHis> findHisListByObjIdAndRightCode(Integer objId,
	// Short operTag, String rightCode) throws Exception;

	public List<OperHis> findHisListByObjIdAndTag(Long objId, Short operTag)
			throws Exception;

	public OperHis createOperHis(String rightCode, String operDesc, Long objId,
			Short operTag, Staff staff) throws Exception;


}
