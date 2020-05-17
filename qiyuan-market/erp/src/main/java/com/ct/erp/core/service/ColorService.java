package com.ct.erp.core.service;

import java.util.List;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.core.model.ComboboxDataBean;

public interface ColorService {

	public List<ComboboxDataBean> findColorByKind(String kind)throws ServiceException;
	
}
