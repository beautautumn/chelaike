package com.ct.erp.list.service;

import java.util.List;
import java.util.Map;

import com.ct.erp.common.model.GridPageInfo;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.list.model.ConditionBean;
import com.ct.erp.list.model.DialogBean;
import com.ct.erp.list.model.PageConfigBean;
import com.ct.erp.list.model.StateQueryBtnBean;
import com.ct.util.AppRunTimeException;

public interface DynamicViewUiProcess {
	/**
	 * 动态对话框处理
	 * @Title:	dialogBeanProcess
	 * @param path
	 * @param colBean
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:23:27
	 */
	public String dialogBeanProcess(String path,DialogBean colBean,List<Sysright> sysrightList)throws AppRunTimeException;
	/**
	 * 条件处理
	 * @Title:	conditionBeanProcess
	 * @param bean
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:23:43
	 */
	public String conditionBeanProcess(ConditionBean bean,Map<String, String> formMap)throws AppRunTimeException;
	
	public String conditionInputBeanProcess(ConditionBean bean,Map<String, String> formMap,List<Sysright> sysrightList)throws AppRunTimeException;
	/**
	 * 状态按钮查询
	 * @Title:	stateQueryBtnBeanProcess
	 * @param bean
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:23:53
	 */
	public String stateQueryBtnBeanProcess(StateQueryBtnBean bean)throws AppRunTimeException;
	/**
	 * 兄弟条件查询
	 * @Title:	conditionSilbingProcess
	 * @param bean
	 * @param optionValue
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:24:08
	 */
	public String conditionSilbingProcess(ConditionBean bean,String optionValue)throws AppRunTimeException;
	/**
	 * 页面配置信息
	 * @Title:	pageConfigProcess
	 * @param pageConfigBean
	 * @param pageInfo
	 * @param value
	 * @param path
	 * @param condStr
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:24:28
	 */
	public Map<String,String> pageConfigProcess(PageConfigBean pageConfigBean,GridPageInfo pageInfo,String value,String path,String condStr)throws AppRunTimeException;
	
	
	public String combinSelectHiddenValue(ConditionBean bean)throws AppRunTimeException ;
	
}
