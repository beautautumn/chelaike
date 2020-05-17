package com.ct.erp.list.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.common.model.GridPageInfo;
import com.ct.erp.common.model.GridPageInfoUtil;
import com.ct.erp.common.utils.BshUtils;
import com.ct.erp.common.web.struts2.ContextPvd;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.DynamicView;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.lib.entity.ViewParam;
import com.ct.erp.list.model.Button;
import com.ct.erp.list.model.ColFormatBean;
import com.ct.erp.list.model.ComposeQueryBean;
import com.ct.erp.list.model.ConditionBean;
import com.ct.erp.list.model.ConditionInfo;
import com.ct.erp.list.model.ConditionSql;
import com.ct.erp.list.model.ConditionValueBean;
import com.ct.erp.list.model.DialogBean;
import com.ct.erp.list.model.DynamicDataBean;
import com.ct.erp.list.model.GridTableBean;
import com.ct.erp.list.model.Input;
import com.ct.erp.list.model.MainSqlInfo;
import com.ct.erp.list.model.Option;
import com.ct.erp.list.model.PageConfigBean;
import com.ct.erp.list.model.PageTableColBean;
import com.ct.erp.list.model.PageTableColInfo;
import com.ct.erp.list.model.PageTableInfo;
import com.ct.erp.list.model.SearchInputCondtion;
import com.ct.erp.list.model.Select;
import com.ct.erp.list.model.StateQueryBtnBean;
import com.ct.erp.list.service.CalculateGridService;
import com.ct.erp.list.service.DynamicDataService;
import com.ct.erp.list.service.DynamicViewProcess;
import com.ct.erp.list.service.DynamicViewService;
import com.ct.erp.list.service.DynamicViewShow;
import com.ct.erp.list.service.DynamicViewUiProcess;
import com.ct.erp.list.service.ISqlCombin;
import com.ct.erp.list.service.ViewParamService;
import com.ct.erp.list.web.PageAction;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.util.AppRunTimeException;
import com.ct.util.lang.StrUtils;
import com.ct.util.log.LogUtil;

@Service
public class DynamicViewShowImpl implements DynamicViewShow {

	private static final Logger log = LoggerFactory.getLogger(PageAction.class);

	@Autowired
	private DynamicViewService dynamicViewService;
	@Autowired
	private DynamicViewProcess dynamicViewProcess;
	@Autowired
	private DynamicViewUiProcess dynamicViewUiProcess;
	@Autowired
	private ISqlCombin iSqlCombin;
	@Autowired
	private DynamicDataService dynamicDataService;
	@Autowired
	private ViewParamService viewParamService;


	public boolean businessProcess(String viewId, ContextPvd contextPvd,
			String pageSize, String pageIndex, String mainSelect,
			String condtionStr, String sort, String order)
			throws AppRunTimeException {
		// TODO Auto-generated method stub
		String path = contextPvd.getAppCxtPath();
		if (StringUtils.isNotEmpty(viewId)) {

			Map<String, ConditionValueBean> conditionMap = new HashMap<String, ConditionValueBean>();

			DynamicDataBean bean=this.dynamicDataService.findDynamicDataBeanById(Integer.valueOf(viewId));
			if (bean != null) {
				PageTableColBean tableColbean = bean.getTableColbean();
				PageTableInfo tableInfo =bean.getPageTableInfo();

				PageConfigBean pageConfigBean = bean.getPageConfigBean();
				GridPageInfo pageInfo = new GridPageInfo();
				if (StringUtils.isNotEmpty(pageSize)) {
					pageConfigBean.getPage().getSelect().setDefPageSize(
							pageSize);
					pageInfo.setRp(Integer.valueOf(pageSize));
				}
				if (StringUtils.isNotEmpty(pageIndex)) {
					pageInfo.setPage(Integer.valueOf(pageIndex));
				}

				DialogBean dialogBean = bean.getDialogBean();

				ConditionBean conditionBean = bean.getConditionBean();

				StateQueryBtnBean stateQueryBtnBean = bean.getStateQueryBtnBean();

				//Map<String, PageTableColInfo> colFieldMap = bean.getColFieldMap();
				/**
				 * 动态条件查询
				 */
				if (StringUtils.isNotEmpty(mainSelect)) {
					if (StringUtils.isNotEmpty(mainSelect)) {
						List<ConditionInfo> conditionList = conditionBean
								.getConditionInfos();
						for (ConditionInfo info : conditionList) {
							Option option = info.getOption();
							info.setDefaultFlag("false");
							if (option.getValue().equals(mainSelect)) {
								info.setDefaultFlag("true");
								combinConditionMap(contextPvd, info,
										conditionMap, option);
							}
						}
					}
				}

				/**
				 * 核心sql配置
				 */
				Map<String, String> sqlMap = new HashMap<String, String>();
				if (StringUtils.isNotEmpty(bean.getMainQueryTable())) {
					sqlMap.put("mainSql", bean.getMainQueryTable());
				}
				/**
				 * 条件sql配置
				 */
				if (StringUtils.isNotEmpty(condtionStr)
						&& !condtionStr.equals("")
						&& !condtionStr.equals("null")) {
					List<Button> queryBtnList = stateQueryBtnBean
							.getQueryBtnList();
					if (null != queryBtnList) {
						for (Button btn : queryBtnList) {
							if (btn.getBtnNo().equals(condtionStr)) {
								sqlMap.put("condSql", btn.getCondStr());
							}
						}
					}

				}

				String tableHtml = this.dynamicViewProcess.pageTableProess(
						tableInfo, tableColbean, pageInfo.getRows(), path);


				String dialogHtml = this.dynamicViewProcess.dialogBeanProcess(path,
						dialogBean);

				String conditionHtml = this.dynamicViewProcess
						.conditionBeanProcess(conditionBean);

				String stateQueryBtnHtml = this.dynamicViewProcess
						.stateQueryBtnBeanProcess(stateQueryBtnBean);

				Map<String, String> configMap = this.dynamicViewProcess
						.pageConfigProcess(pageConfigBean, pageInfo, viewId,
								path, condtionStr);
				
				if(StringUtils.isNotBlank(pageConfigBean.getParams())){
					List<ViewParam> list=this.viewParamService.getViewParamByCode(pageConfigBean.getParams());
					StringBuilder params=new StringBuilder();
					if(list!=null){
						for(ViewParam p:list){
							params.append(p.getParamValue());
							params.append("\n");
						}
						contextPvd.setRequestAttr("js", params.toString());
					}
				}else{
					contextPvd.setRequestAttr("js", "");
				}

				contextPvd.setRequestAttr("dialogHtml", dialogHtml);
				contextPvd.setRequestAttr("tableHtml", tableHtml);
				contextPvd.setRequestAttr("stateQueryBtnHtml",
						stateQueryBtnHtml);

				contextPvd.setRequestAttr("conditionHtml", conditionHtml);
				contextPvd
						.setRequestAttr("pageHtml", configMap.get("pageHtml"));
				contextPvd
						.setRequestAttr("formHtml", configMap.get("formHtml"));

			}
		}
		return false;
	}

	/**
	 * 拼where条件
	 * 
	 * @param contextPvd
	 * @param info
	 * @param conditionMap
	 * @param option
	 */
	public void combinConditionMap(ContextPvd contextPvd, ConditionInfo info,
			Map<String, ConditionValueBean> conditionMap, Option option) {
		combinInputConditionMap(contextPvd, info.getInputList(), conditionMap,
				option, info.getCondSql());
		combinSelectConditionMap(contextPvd, info.getSecondSelect(),
				conditionMap, option, info.getCondSql());
		combinDynamicInputConditionMap(contextPvd, info.getInputList(), conditionMap, option, info.getSearchInputCondtionList());
		
	}

	/**
	 * 生成下拉框条件map
	 * 
	 * @Title: combinConditionMap
	 * @param contextPvd
	 * @param conditionMap
	 * @param option
	 * @author: jieketao Create at: 2012-1-18 下午04:03:13
	 */
	public void combinSelectConditionMap(ContextPvd contextPvd, Select select,
			Map<String, ConditionValueBean> conditionMap, Option option, String condSql) {
		if (select != null) {
			String value = contextPvd.getRequest().getParameter(
					select.getName());
			if (select.getOptions() != null && select.getOptions().size() > 0) {
				value = UcmsWebUtils.replaceBlank(value);
				if (StringUtils.isNotEmpty(condSql)
						&& StringUtils.isNotEmpty(value)) {
					condSql = condSql.replaceAll("#" + select.getName() + "#",
							value);
					//conditionMap.put(option.getColumnField(), condSql);
					putConditonMap(conditionMap, option.getColumnField(), condSql, select.getPositionName());
				}
			}
		}
	}

	public void combinInputConditionMap(ContextPvd contextPvd,
			List<Input> inputsList, Map<String, ConditionValueBean> conditionMap,
			Option option, String condSql) {
		if (inputsList != null) {
			for (Input input : inputsList) {
				String value = contextPvd.getRequest().getParameter(
						input.getName());
				if (StringUtils.isNotEmpty(value)) {
					value = UcmsWebUtils.replaceBlank(value);
					if (StringUtils.isNotEmpty(condSql)) {
						condSql = condSql.replaceAll("#" + input.getName()
								+ "#", value);
						putConditonMap(conditionMap, option.getColumnField(), condSql, input.getPositionName());
					}
				} else {
					if (StringUtils.isNotEmpty(condSql)) {
						condSql = condSql.replaceAll("#" + input.getName()
								+ "#", "");
						putConditonMap(conditionMap, option.getColumnField(), condSql, input.getPositionName());
					}
				}
			}
		}
	}
	
	private void putConditonMap(Map<String, ConditionValueBean> conditionMap,String field,String sql,String positionName){
		ConditionValueBean bean=new ConditionValueBean();
		bean.setSql(sql);
		bean.setPositionName(positionName);
		conditionMap.put(field, bean);
	}
	
	public void combinDynamicInputConditionMap(ContextPvd contextPvd,
			List<Input> inputsList, Map<String, ConditionValueBean> conditionMap,
			Option option, List<SearchInputCondtion> searchInputCondtionList){
		
		try {
			if(searchInputCondtionList!=null){
				BshUtils bsh = new BshUtils();
				for(SearchInputCondtion searchCond:searchInputCondtionList){
					if(searchCond==null) continue;
					String searchInput=searchCond.getSearchInputName();
					if(StringUtils.isNotBlank(searchInput)){
						String searchInputs[]=searchInput.split(",");
						Map<String, Object> map = new HashMap<String, Object>();
						for(String input:searchInputs){
							String value = contextPvd.getRequest().getParameter(input);
							if(StringUtils.isNotBlank(value)){
								value=value.replaceAll("null", "");
								map.put(input, value);
							}else{
								map.put(input, "");
							}
						}
						
						List<ConditionSql> conditionSqlList=searchCond.getConditonSqlList();					
						if(conditionSqlList!=null){
							for(ConditionSql cs:conditionSqlList){
								if(StringUtils.isNotBlank(cs.getExpression())){
									String experssion=cs.getExpression().replaceAll("&amp;", "&");
									Object evalResult=bsh.eval(experssion, map);
									if(evalResult!=null&&String.valueOf(evalResult).equals("true")){
										String sql=cs.getSql();
										Iterator<Map.Entry<String, Object>> it = map.entrySet().iterator();
										//替换form表单中的值
										while (it.hasNext()) {
											Map.Entry<String, Object> entry = it.next();
											sql=sql.replaceAll("#"+entry.getKey()+"#", String.valueOf(entry.getValue()));
										}
										//conditionMap.put(searchInput, sql);
										putConditonMap(conditionMap, searchInput, sql, searchCond.getPositionName());
										break;
									}
								}

							}
						}
					}

				}
			}
		} catch (Exception e) {
			LogUtil.logError(this.getClass(), "Error in method combinDynamicInputConditionMap",e);
		}
	
	}

	/**
	 * input框是否有变化
	 * 
	 * @Title: getDifInput
	 * @param contextPvd
	 * @param inputsList
	 * @return
	 * @author: jieketao Create at: 2012-1-18 下午04:03:46
	 */
	public boolean getDifInput(ContextPvd contextPvd, List<Input> inputsList) {
		for (Input input : inputsList) {
			String value = contextPvd.getRequest()
					.getParameter(input.getName());
			if (!input.getDefultValue().equals(value)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 两个对话框值是否都改变
	 * 
	 * @Title: getAllDifInput
	 * @param contextPvd
	 * @param inputsList
	 * @return
	 * @author: jieketao Create at: 2012-1-18 下午04:04:03
	 */
	public boolean getAllDifInput(ContextPvd contextPvd, List<Input> inputsList) {
		for (Input input : inputsList) {
			String value = contextPvd.getRequest()
					.getParameter(input.getName());
			if (input.getDefultValue().equals(value) || value.equals("")) {
				return false;
			}
		}
		return true;
	}

	public String findSiblingHtml(String viewId, String optionValue)
			throws AppRunTimeException {
		// TODO Auto-generated method stub
		try {
			if (StringUtils.isNotEmpty(viewId)) {
				//DynamicView view = dynamicViewService.findDynamicViewByPk(Integer.valueOf(viewId));
				DynamicDataBean bean=this.dynamicDataService.findDynamicDataBeanById(Integer.valueOf(viewId));
				if (bean != null) {
					ConditionBean conditionBean =bean.getConditionBean();
					return this.dynamicViewProcess.conditionSilbingProcess(
							conditionBean, optionValue, null);
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException(e);
		}
		return null;
	}

	public GridTableBean businessDataProcess(String viewId,
			ContextPvd contextPvd, String pageSize, String pageIndex,
			String mainSelect, String condtionStr, String sort, String order)
			throws AppRunTimeException {
		GridTableBean bean = new GridTableBean();
		if (StringUtils.isNotEmpty(viewId)) {

			ComposeQueryBean composeQueryBean = getComposeQueryConBean(viewId,
					contextPvd, pageSize, pageIndex, mainSelect, condtionStr,
					sort, order);
			String sql=this.iSqlCombin.getQuerySql(composeQueryBean);
			this.dynamicViewService.findDynamicDataList(sql,composeQueryBean);
			bean.setPageInfo(composeQueryBean.getPageInfo());			
			bean.setColumnMap(composeQueryBean.getColFieldMap());
			CalculateGridService.calculateXsum(composeQueryBean.getPageInfo().getRows(), composeQueryBean.getColPageTableColInfoMap());
			contextPvd.setRequestAttr("gridTableBean", bean);
		}
		return bean;
	}
	

	
	public ComposeQueryBean getComposeQueryConBean(String viewId,
			ContextPvd contextPvd, String pageSize, String pageIndex,
			String mainSelect, String condtionStr, String sort, String order)
			throws AppRunTimeException {
		ComposeQueryBean result=new ComposeQueryBean();
		if (StringUtils.isNotEmpty(viewId)) {
			Map<String, ConditionValueBean> conditionMap = new HashMap<String, ConditionValueBean>();
			DynamicDataBean bean=this.dynamicDataService.findDynamicDataBeanById(Integer.valueOf(viewId));
			if (bean != null) {
				PageTableColBean tableColbean = bean.getTableColbean();
				//PageTableInfo tableInfo =bean.getPageTableInfo();

				PageConfigBean pageConfigBean = bean.getPageConfigBean();
				//DialogBean dialogBean = bean.getDialogBean();

				ConditionBean conditionBean = bean.getConditionBean();

				StateQueryBtnBean stateQueryBtnBean = bean.getStateQueryBtnBean();
				
				GridPageInfo pageInfo = GridPageInfoUtil
						.getGridPageInfo(contextPvd.getRequest());
				Integer currentUser = null;
				Integer departmentId = null;
				String orgId = null;

				if (pageConfigBean.getSession() != null
						&& pageConfigBean.getSession().getCurrentUser() != null
						&& contextPvd.getRequest().getSession() != null
						&& contextPvd.getSessionAttr(pageConfigBean
								.getSession().getCurrentUser()) != null)
					currentUser = (Integer) contextPvd
							.getSessionAttr(pageConfigBean.getSession()
									.getCurrentUser());

				if (pageConfigBean.getSession() != null
						&& pageConfigBean.getSession().getCurrentDepartment() != null
						&& contextPvd.getRequest().getSession() != null
						&& contextPvd.getSessionAttr(pageConfigBean
								.getSession().getCurrentDepartment()) != null) {
					departmentId = (Integer) contextPvd
							.getSessionAttr(pageConfigBean.getSession()
									.getCurrentDepartment());
				}
				if (pageConfigBean.getSession() != null
						&& pageConfigBean.getSession().getCurrentOrganization() != null
						&& contextPvd.getRequest().getSession() != null
						&& contextPvd.getSessionAttr(pageConfigBean
								.getSession().getCurrentOrganization()) != null) {
					orgId = (String) contextPvd
							.getSessionAttr(pageConfigBean.getSession()
									.getCurrentOrganization());
				}
				if (StringUtils.isNotEmpty(pageSize)) {
					pageConfigBean.getPage().getSelect().setDefPageSize(
							pageSize);
					pageInfo.setRp(Integer.valueOf(pageSize));
				}
				if (StringUtils.isNotEmpty(pageIndex)) {
					pageInfo.setPage(Integer.valueOf(pageIndex));
				}

				Map<String, PageTableColInfo> colFieldMap =bean.getColFieldMap();
				MainSqlInfo mainSqlBean = bean.getMainSqlBean();
		
				/**
				 * 动态条件查询
				 */
				if(conditionBean!=null&&conditionBean.getConditionInfos()!=null){
					List<ConditionInfo> conditionList = conditionBean.getConditionInfos();
					if (StringUtils.isNotEmpty(mainSelect)) {				
						for (ConditionInfo info : conditionList) {
							if (info.getSecondSelect().getSelectSql() != null) {
								String optionSql = replaceConfigParams(info
										.getSecondSelect().getSelectSql()
										.getOptionSql(), pageConfigBean, info
										.getSecondSelect().getSelectSql()
										.getOptionSql(), currentUser, departmentId,orgId);
								info.getSecondSelect().getSelectSql().setOptionSql(
										optionSql);
							}
							Option option = info.getOption();
							info.setDefaultFlag("false");
							if (option.getValue().equals(mainSelect)) {
								info.setDefaultFlag("true");
								combinConditionMap(contextPvd, info, conditionMap,
										option);
							}
						}
					}else{
						ConditionInfo info=conditionList.get(0);
						Option option = info.getOption();
						info.setDefaultFlag("true");
						combinConditionMap(contextPvd, info, conditionMap,
								option);
					}	
				}
				/**
				 * 核心sql配置
				 */
				Map<String, String> sqlMap = new HashMap<String, String>();
				if (StringUtils.isNotEmpty(mainSqlBean.getMainSql())) {
					sqlMap.put("mainSql", mainSqlBean.getMainSql());
				}
				String temp = mainSqlBean.getBaseWhereSql();
				if (StringUtils.isNotEmpty(temp)) {
					replaceConfigParams(temp, pageConfigBean, mainSqlBean.getBaseWhereSql(), currentUser, departmentId,orgId);
					sqlMap.put("baseWhereSql", temp);
				} else {
					sqlMap.put("baseWhereSql", "");
				}

				String temp1 = mainSqlBean.getDefWhereSql();
				if (StringUtils.isNotEmpty(temp1)) {
					replaceConfigParams(temp, pageConfigBean, mainSqlBean.getDefWhereSql(), currentUser, departmentId,orgId);
					sqlMap.put("defWhereSql", temp1);
				} else {
					sqlMap.put("defWhereSql", "");
				}
				if (StringUtils.isNotEmpty(mainSqlBean.getGroupBySql())) {
					sqlMap.put("groupBySql", mainSqlBean.getGroupBySql());
				} else {
					sqlMap.put("groupBySql", "");
				}
				if (StringUtils.isNotEmpty(mainSqlBean.getOrderBySql())) {
					sqlMap.put("orderBySql", mainSqlBean.getOrderBySql());
				} else {
					sqlMap.put("orderBySql", "");
				}
				/**
				 * 条件sql配置
				 */
				if (StringUtils.isNotEmpty(condtionStr)
						&& !condtionStr.equals("")
						&& !condtionStr.equals("null")) {
					List<Button> queryBtnList = stateQueryBtnBean
							.getQueryBtnList();
					if (null != queryBtnList) {
						for (Button btn : queryBtnList) {
							if (btn.getBtnNo().equals(condtionStr)) {
								sqlMap.put("condSql", btn.getCondStr());
							}
						}
					}
				}
				result.setColPageTableColInfoMap(colFieldMap);
				result.setSort(sort);
				result.setConditionMap(conditionMap);
				result.setOrder(order);
				result.setSqlMap(sqlMap);
				result.setPageInfo(pageInfo);
				result.setColFieldMap(getColumnMap(tableColbean));
			}
		}
		return result;
	}
	
	public String replaceConfigParams(String temp,
			PageConfigBean pageConfigBean,String whereSql,
			Integer currentUser, Integer departmentId,String orgId) {
		if (pageConfigBean.getSession() != null) {
			if (StrUtils.contains(whereSql, "#".concat(
					pageConfigBean.getSession().getCurrentUser()).concat("#"))) {
				if (currentUser != null) {
					temp = temp.replaceAll("#".concat(
							pageConfigBean.getSession().getCurrentUser())
							.concat("#"), currentUser.toString());
				} else {
					log.error("DynamicViewShowImpl.businessDataProcess currentUser is null replace #_user_key# fail!");
				}

			}
			if (StrUtils.contains(whereSql, "#".concat(
					pageConfigBean.getSession().getCurrentDepartment()).concat("#"))) {
				if (departmentId != null) {
					temp = temp.replaceAll("#".concat(
							pageConfigBean.getSession().getCurrentDepartment())
							.concat("#"), departmentId.toString());
				} else {
					log.error("DynamicViewShowImpl.businessDataProcess departmentId is null replace #"
									+ pageConfigBean.getSession()
											.getCurrentDepartment() + "# fail!");
				}
			}
			if (pageConfigBean.getSession().getCurrentOrganization()!=null&&StrUtils.contains(whereSql, "#".concat(
					pageConfigBean.getSession().getCurrentOrganization()).concat("#"))) {
				if (orgId != null) {
					temp = temp.replaceAll("#".concat(
							pageConfigBean.getSession().getCurrentOrganization())
							.concat("#"), orgId);
				} else {
					log.error("DynamicViewShowImpl.businessDataProcess departmentId is null replace #"
									+ pageConfigBean.getSession()
											.getCurrentDepartment() + "# fail!");
				}
			}
			
		}
		return temp;
	}

	/**
	 * 动态报表业务处理，首先从查询已经配置数据 然后通过gson将json转化为java对象 然后通过操作java对象的方式动态拼html以及sql
	 */
	public GridTableBean businessHeadProcess(String viewId,
			ContextPvd contextPvd, String pageSize, String pageIndex,
			String mainSelect, String condtionStr, String sort, String order,Map<String,String> formMap)
			throws AppRunTimeException {
		String path = contextPvd.getAppCxtPath();
		GridTableBean bean = new GridTableBean();
		if (StringUtils.isNotEmpty(viewId)) {
			// 配置实体信息
			//DynamicView view = dynamicViewService.findDynamicViewByPk(Integer.valueOf(viewId));
			DynamicDataBean dataBean=this.dynamicDataService.findDynamicDataBeanById(Integer.valueOf(viewId));

			// 将json串转换为页面表格java对象
			PageTableColBean tableColbean = dataBean.getTableColbean();
			// 将json串转换为页面配置java对象
			PageConfigBean pageConfigBean = dataBean.getPageConfigBean();
			
			GridPageInfo pageInfo = new GridPageInfo();
			Integer currentUser = null;
			Integer departmentId = null;
			/**
			 * 通过配置的参数抽取sessionid，如果在已经配置的sql中有当前用户那么需要替换
			 */
			if(SecurityUtils.getCurrentSessionInfo()!=null){
				currentUser = SecurityUtils.getCurrentSessionInfo().getStaffId().intValue();	
			}
//			if (pageConfigBean.getSession() != null
//					&& pageConfigBean.getSession().getCurrentUser() != null
//					&& contextPvd.getRequest().getSession() != null
//					&& contextPvd.getSessionAttr(pageConfigBean.getSession()
//							.getCurrentUser()) != null) {
//				currentUser = SecurityUtils.getCurrentSessionInfo().getStaffId().intValue();				
//				
//			}
//
//			if (pageConfigBean.getSession() != null
//					&& pageConfigBean.getSession().getCurrentDepartment() != null
//					&& contextPvd.getRequest().getSession() != null
//					&& contextPvd.getSessionAttr(pageConfigBean.getSession()
//							.getCurrentDepartment()) != null) {
//				departmentId = SecurityUtils.getCurrentSessionInfo().getCorpId().intValue();
//			}
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			Long marketId = null;
			Long staffId = null;
			if(sessionInfo != null){
				marketId = SecurityUtils.getCurrentSessionInfo().getMarketId();
				staffId = SecurityUtils.getCurrentSessionInfo().getStaffId();
			}

			try {
				if(dataBean!=null&&dataBean.getConditionBean()!=null)
					this.dynamicDataService.initSelectOptions(dataBean.getConditionBean().getConditionInfos(), pageConfigBean, currentUser, departmentId, marketId, staffId);
			} catch (Exception e) {
				LogUtil.logError(this.getClass(), "Error in method initSelectOptions");
			}

			if (StringUtils.isNotEmpty(pageSize)) {
				pageConfigBean.getPage().getSelect().setDefPageSize(pageSize);
				pageInfo.setRp(Integer.valueOf(pageSize));
			}
			if (StringUtils.isNotEmpty(pageIndex)) {
				pageInfo.setPage(Integer.valueOf(pageIndex));
			}
			PageTableInfo pageTableInfo=dataBean.getPageTableInfo();
			//历史数据没有那么默认列自适应
			if(StringUtils.isEmpty(pageTableInfo.getFit())){
				pageTableInfo.setFit("true");
			}
			if(StringUtils.isEmpty(pageTableInfo.getFitColumns())){
				pageTableInfo.setFitColumns("true");
			}
			if(StringUtils.isEmpty(pageTableInfo.getSingleSelect())){
				pageTableInfo.setSingleSelect("true");
			}
			if(StringUtils.isEmpty(pageTableInfo.getCheckOnSelect())){
				pageTableInfo.setCheckOnSelect("false");
			}
			// 对话框实体
			DialogBean dialogBean = dataBean.getDialogBean();
			// 条件实体
			ConditionBean conditionBean = dataBean.getConditionBean();
			// 查询按钮实体
			StateQueryBtnBean stateQueryBtnBean = dataBean.getStateQueryBtnBean();

			if(sessionInfo != null){
                List<Sysright> sysrightList = sessionInfo.getSysrightList();
                // 对话框html信息
                String dialogHtml = this.dynamicViewUiProcess.dialogBeanProcess(path,
                        dialogBean,sysrightList);
                // 条件下拉框html信息
                String conditionSelectHtml = this.dynamicViewUiProcess
                        .conditionBeanProcess(conditionBean,formMap);
                // 条件文本输入框
                String conditionInputHtml = this.dynamicViewUiProcess
                        .conditionInputBeanProcess(conditionBean,formMap,sysrightList);
                // 条件下拉框隐藏域html
                //String conditionSelectHiddenHtml = dynamicViewUiProcess.combinSelectHiddenValue(conditionBean);
                // 按钮html信息
                String stateQueryBtnHtml = this.dynamicViewUiProcess
                        .stateQueryBtnBeanProcess(stateQueryBtnBean);

                Map<String, String> configMap = this.dynamicViewUiProcess
                        .pageConfigProcess(pageConfigBean, pageInfo, viewId, path,
                                condtionStr);

                if(StringUtils.isNotBlank(pageConfigBean.getParams())){
                    List<ViewParam> list=this.viewParamService.getViewParamByCode(pageConfigBean.getParams());
                    StringBuilder params=new StringBuilder();
                    if(list!=null){
                        for(ViewParam p:list){
                            params.append(p.getParamValue());
                            params.append("\n");
                        }
                        contextPvd.setRequestAttr("js", params.toString());
                    }
                }else{
                    contextPvd.setRequestAttr("js", "");
                }

                log.debug("****************dialogHtml begin**************");
                log.debug(dialogHtml);

                log.debug("****************stateQueryBtnHtml**************");
                log.debug(stateQueryBtnHtml);

                log.debug("****************conditionSelectHtml**************");
                log.debug(conditionSelectHtml);
                log.debug("****************conditionInputHtml**************");
                log.debug(conditionInputHtml);

                log.debug("****************formHtml**************");
                log.debug(configMap.get("formHtml"));

                contextPvd.setRequestAttr("dialogHtml", dialogHtml);
                contextPvd.setRequestAttr("stateQueryBtnHtml", stateQueryBtnHtml);

                contextPvd.setRequestAttr("conditionSelectHtml",
                        conditionSelectHtml);
                contextPvd.setRequestAttr("conditionInputHtml", conditionInputHtml);
                contextPvd.setRequestAttr("formHtml", configMap.get("formHtml"));
                //contextPvd.setRequestAttr("conditionSelectHiddenHtml",conditionSelectHiddenHtml);
                if(pageConfigBean!=null&&StringUtils.isNotEmpty(pageConfigBean.getTitle())){
                    contextPvd.setRequestAttr("title", pageConfigBean.getTitle());
                }
                if (dataBean != null) {
                    contextPvd.setRequestAttr("headHtml", this.dynamicViewProcess
                            .pageTableDataEasyUiProcess(tableColbean, path));
                    contextPvd.setRequestAttr("operateLinkJs", this.dynamicViewProcess
                            .createOperateLinklJs(tableColbean, path));

                }
                contextPvd.setRequestAttr("pageTableInfo", pageTableInfo);
            }

		}
		return bean;
	}

	/**
	 * 获得列信息
	 * 
	 * @param colbean
	 * @return
	 */
	public Map<String, String> getColumnMap(PageTableColBean colbean) {
		if (colbean != null) {
			Map<String, String> result = new HashMap<String, String>();
			for (PageTableColInfo col : colbean.getColInfos()) {
				result.put(col.getColField(), col.getColName());
			}
			return result;
		}
		return null;
	}

	/**
	 * 拼接动态链接
	 */
	public String findLinkUrl(String viewId, String key, String colField)
			throws AppRunTimeException {
		String url = "";
		if (StringUtils.isNotEmpty(viewId)) {
			DynamicView view = this.dynamicViewService.findDynamicViewByPk(Integer
					.valueOf(viewId));
			PageTableColBean tableColbean = this.dynamicViewService
					.findPageTableColBean(view);
			for (PageTableColInfo info : tableColbean.getColInfos()) {
				if (info.getDialogInfo() != null) {
					if ((colField != null)
							&& (info.getColField().equals(colField))) {
						url = this.dynamicViewProcess.getFormatterUrl(info, key);
					} else if (colField == null) {
						url = info.getDialogInfo().getDialogUrl();
						url = url.replaceAll("#", key);
						break;
					}
				}
			}
		}
		return url;
	}
	
	
	
	public String findOperateLinkUrl(String rightCode)
			throws AppRunTimeException {
		String url = "";
		if (StringUtils.isNotEmpty(rightCode)) {
			
		}
		return url;
	}

	@Override
	public ColFormatBean findColFormatBeanByViewId(Integer viewId) {
		DynamicDataBean bean=this.dynamicDataService.findDynamicDataBeanById(Integer.valueOf(viewId));
		String colField=bean.getTableColbean().getColInfos().get(0).getColField();
		String formatter=bean.getTableColbean().getColInfos().get(0).getFormatter();
		ColFormatBean colFormatBean=new ColFormatBean();
		colFormatBean.setColField(colField);
		colFormatBean.setFormatter(formatter);
		return colFormatBean;
	}

	@Override
	public String findParamLinkUrl(String viewId, String key, String colField)
			throws AppRunTimeException {
		String url = "";
		if (StringUtils.isNotEmpty(viewId)) {
			DynamicView view = this.dynamicViewService.findDynamicViewByPk(Integer
					.valueOf(viewId));
			PageTableColBean tableColbean = this.dynamicViewService
					.findPageTableColBean(view);
			for (PageTableColInfo info : tableColbean.getColInfos()) {
				if (info.getDialogInfo() != null) {
					if ((colField != null)
							&& (info.getColField().equals(colField))) {
						url = this.dynamicViewProcess.getFormatterParamUrl(info, key);
					} else if (colField == null) {
						url = info.getDialogInfo().getDialogUrl();
						url=this.dynamicViewProcess.replaceUrlConfig(url, key);
						break;
					}
				}
			}
		}
		return url;
	}
	
	private List<String> getParamsInUrl(String url){
		List<String> result=new ArrayList<String>();
		String urlParts[]=url.split("\\#");
		for(int i=0;i<urlParts.length;i++){
			if(StrUtils.contains(urlParts[i],"\\?")||StrUtils.contains(urlParts[i],"\\&")){
				continue;
			}
			result.add(urlParts[i]);
		}
		return result;
	}
}
