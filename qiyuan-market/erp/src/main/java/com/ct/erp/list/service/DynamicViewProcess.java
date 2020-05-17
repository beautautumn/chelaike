package com.ct.erp.list.service;

import java.util.List;
import java.util.Map;

import com.ct.erp.common.model.GridPageInfo;
import com.ct.erp.list.model.ConditionBean;
import com.ct.erp.list.model.DialogBean;
import com.ct.erp.list.model.PageConfigBean;
import com.ct.erp.list.model.PageTableColBean;
import com.ct.erp.list.model.PageTableColInfo;
import com.ct.erp.list.model.PageTableInfo;
import com.ct.erp.list.model.StateQueryBtnBean;
import com.ct.util.AppRunTimeException;

public interface DynamicViewProcess {

	/**
	 * 页面表格信息
	 * @Title:	pageTableProess
	 * @param table
	 * @param colBean
	 * @param dataList
	 * @param path
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:22:38
	 */
	public String pageTableProess(PageTableInfo table,PageTableColBean colBean,List<Map<String, Object>> dataList,String path)throws AppRunTimeException;
	/**
	 * 表头信息
	 * @Title:	pageTableHeadProess
	 * @param table
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:23:02
	 */
	public String pageTableHeadProess(PageTableInfo table)throws AppRunTimeException;
	/**
	 * 表列信息
	 * @Title:	pageTableColProcess
	 * @param colBean
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:23:14
	 */
	public String pageTableColProcess(PageTableColBean colBean)throws AppRunTimeException;
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
	public String dialogBeanProcess(String path,DialogBean colBean)throws AppRunTimeException;
	/**
	 * 条件处理
	 * @Title:	conditionBeanProcess
	 * @param bean
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:23:43
	 */
	public String conditionBeanProcess(ConditionBean bean)throws AppRunTimeException;
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
	public String conditionSilbingProcess(ConditionBean bean,String optionValue,Map<String,String> formMap)throws AppRunTimeException;
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
	/**
	 * 表格列信息
	 * @Title:	findPageTableColProperty
	 * @param colbean
	 * @param type
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:24:43
	 */
	public List<String> findPageTableColProperty(PageTableColBean colbean,String type)throws AppRunTimeException;
	/**
	 * 查询列信息map
	 * @Title:	findColFieldMap
	 * @param colbean
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:25:00
	 */
	public Map<String,PageTableColInfo> findColFieldMap(PageTableColBean colbean)throws AppRunTimeException;
	/**
	 * 表格数据信息
	 * @Title:	pageTableDataProcess
	 * @param colbean
	 * @param dataList
	 * @param path
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午02:25:24
	 */
	public String pageTableDataProcess(PageTableColBean colbean,List<Map<String,Object>> dataList,String path)throws AppRunTimeException; 
	
	/**
	 * easyUi表头视图
	 * @Title:	pageTableDataEasyUiProcess
	 * @param colbean
	 * @param path
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-2-7 上午11:35:07
	 */
	public String pageTableDataEasyUiProcess(PageTableColBean colbean,String path) throws AppRunTimeException;
	
	
	
	public String getFormatterUrl(PageTableColInfo info,String key)throws AppRunTimeException;
	
	public String getFormatterParamUrl(PageTableColInfo info,String key)throws AppRunTimeException;
	
	public String replaceUrlConfig(String url,String parmas)throws AppRunTimeException;
	
	public String createOperateLinklJs(PageTableColBean colbean,String path) throws AppRunTimeException;
}
