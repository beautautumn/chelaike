package com.ct.erp.list.service;

import com.ct.erp.list.model.ComposeQueryBean;
import com.ct.util.AppRunTimeException;

public interface BusDataExportExcel {

	public String exportFile(String fileInfo, String pageTitle,
			String titleText, String sql, String urlLink,
			ComposeQueryBean composeQueryBean,String maxExportIndex)throws AppRunTimeException;
}
