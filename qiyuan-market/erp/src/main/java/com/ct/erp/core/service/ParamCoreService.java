package com.ct.erp.core.service;

import java.util.List;
import java.util.Map;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.core.model.ComboboxDataBean;

public interface ParamCoreService {

	public List<ComboboxDataBean> findParamCombobox(
			Map<String, Object> conditionMap, String code)
			throws ServiceException;

}
