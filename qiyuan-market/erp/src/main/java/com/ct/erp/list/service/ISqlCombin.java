package com.ct.erp.list.service;

import java.util.List;

import com.ct.erp.list.model.ComposeQueryBean;
import com.ct.erp.list.model.Option;
import com.ct.util.AppRunTimeException;

public interface ISqlCombin {

	public String getQuerySql(ComposeQueryBean composeQueryBean) throws AppRunTimeException;
	
	public List<Option> findOptionsBySql(String sql,String optionValue,String optionName,String headKey,String keyValue,String defaultValue)throws AppRunTimeException;
}
