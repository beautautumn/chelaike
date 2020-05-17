package com.ct.erp.list.service;

import java.util.List;

import com.ct.erp.list.model.ConditionInfo;
import com.ct.erp.list.model.DynamicDataBean;
import com.ct.erp.list.model.PageConfigBean;

public interface DynamicDataService {

	
	public DynamicDataBean findDynamicDataBeanById(Integer viewId);
	
	public void initSelectOptions(List<ConditionInfo> conditionInfos,
                                  PageConfigBean pageConfigBean, Integer currentUser, Integer departmentId, Long marketId, Long staffId)throws Exception;
}
