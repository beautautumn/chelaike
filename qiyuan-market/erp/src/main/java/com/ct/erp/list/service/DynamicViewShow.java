package com.ct.erp.list.service;

import java.util.Map;

import com.ct.erp.common.web.struts2.ContextPvd;
import com.ct.erp.list.model.ColFormatBean;
import com.ct.erp.list.model.ComposeQueryBean;
import com.ct.erp.list.model.GridTableBean;
import com.ct.util.AppRunTimeException;

/**
 * 
 * <P>公司名称: 云潮网络</P>
 * <P>项目名称： 哪有车爬虫</P>
 * <P>模块名称： 主视图展现</P>
 * @Title:	DynamicViewShow.java
 * @Description: TODO
 * @author:    jieketao
 * @version:   1.0
 * Create at:  2012-1-18 下午02:26:08
 */
public interface DynamicViewShow {

	/**
	 * 业务处理
	 * @Title:	businessProcess
	 * @param pageId
	 * @param contextPvd
	 * @param pageSize
	 * @param pageIndex
	 * @param mainSelect
	 * @param condtionStr
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午03:56:50
	 */
	public boolean businessProcess(String pageId,ContextPvd contextPvd,String pageSize,String pageIndex,String mainSelect,String condtionStr,String sort,String order)throws AppRunTimeException;
	
	/**
	 * 动态查询兄弟html
	 * @Title:	findSiblingHtml
	 * @param pageId
	 * @param optionValue
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午03:57:55
	 */
	public String findSiblingHtml(String pageId,String optionValue)throws AppRunTimeException;
	
	public String findLinkUrl(String pageId,String key,String type)throws AppRunTimeException;
	
	public String findParamLinkUrl(String pageId,String key,String type)throws AppRunTimeException;
	
	
	
	public GridTableBean businessDataProcess(String pageId,ContextPvd contextPvd,String pageSize,String pageIndex,String mainSelect,String condtionStr,String sort,String order)throws AppRunTimeException;
	
	
	public GridTableBean businessHeadProcess(String viewId, ContextPvd contextPvd,String pageSize,String pageIndex,String mainSelect,String condtionStr,String sort,String order,Map<String,String> formMap) throws AppRunTimeException;
	
	
	public String findOperateLinkUrl(String rightCode)throws AppRunTimeException;
	
	
	public ColFormatBean findColFormatBeanByViewId(Integer viewId);
	
	public ComposeQueryBean getComposeQueryConBean(String viewId,
			ContextPvd contextPvd, String pageSize, String pageIndex,
			String mainSelect, String condtionStr, String sort, String order)throws AppRunTimeException;

}
