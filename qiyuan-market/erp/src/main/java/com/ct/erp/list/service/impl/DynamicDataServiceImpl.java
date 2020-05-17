package com.ct.erp.list.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.lib.entity.DynamicView;
import com.ct.erp.list.model.ConditionBean;
import com.ct.erp.list.model.ConditionInfo;
import com.ct.erp.list.model.DialogBean;
import com.ct.erp.list.model.DynamicDataBean;
import com.ct.erp.list.model.MainSqlInfo;
import com.ct.erp.list.model.Option;
import com.ct.erp.list.model.PageConfigBean;
import com.ct.erp.list.model.PageTableColBean;
import com.ct.erp.list.model.PageTableInfo;
import com.ct.erp.list.model.SelectBean;
import com.ct.erp.list.model.StateQueryBtnBean;
import com.ct.erp.list.service.DynamicDataService;
import com.ct.erp.list.service.DynamicViewService;
import com.ct.erp.list.service.ISqlCombin;
import com.ct.util.AppRunTimeException;
import com.ct.util.lang.StrUtils;
import com.ct.util.log.LogUtil;

@Service
public class DynamicDataServiceImpl implements DynamicDataService {

	@Autowired
	private DynamicViewService dynamicViewService;
	
	@Autowired
	private ISqlCombin iSqlCombin;


	private static Map<Integer, DynamicDataBean> dynamicDataMap = new HashMap<Integer, DynamicDataBean>();

	@Override
	public DynamicDataBean findDynamicDataBeanById(Integer viewId) {
		/**
		if (dynamicDataMap.size() == 0) {			
			List<DynamicDataBean> beanList=initDynamicDataList();
			for(DynamicDataBean bean:beanList){
				dynamicDataMap.put(bean.getViewId(), bean);
			}				
		}
		*/
		if (dynamicDataMap.containsKey(viewId)) {
			return dynamicDataMap.get(viewId);
		}else{
			DynamicDataBean bean=initDynamicDataByViewId(viewId);
			//暂时去掉缓存功能
			//dynamicDataMap.put(viewId, bean);
			return bean;
		}
	}
	
	
	public DynamicDataBean initDynamicDataByViewId(Integer viewId) {
		try {
			DynamicView view = this.dynamicViewService.findDynamicViewByPk(viewId);
			if (view != null) {
				DynamicDataBean bean = new DynamicDataBean();
				bean.setViewId(view.getDynamicViewId());
				PageTableColBean tableColbean = dynamicViewService
						.findPageTableColBean(view);
				PageConfigBean pageConfigBean = dynamicViewService
						.findPageConfigBean(view);
				DialogBean dialogBean = dynamicViewService
						.findDialogBean(view);

				ConditionBean conditionBean = dynamicViewService
						.findConditionBean(view);
				//if(conditionBean!=null)initSelectOptions(conditionBean.getConditionInfos());

				StateQueryBtnBean stateQueryBtnBean = dynamicViewService
						.findStateQueryBtnBean(view);
				
				PageTableInfo pageTableInfo = dynamicViewService
						.findPageTable(view);
				MainSqlInfo mainSqlBean=dynamicViewService.findMainSqlBean(view);

				bean.setTableColbean(tableColbean);
				bean.setConditionBean(conditionBean);
				bean.setPageConfigBean(pageConfigBean);
				bean.setTableColbean(tableColbean);
				bean.setDialogBean(dialogBean);
				bean.setStateQueryBtnBean(stateQueryBtnBean);
				bean.setPageTableInfo(pageTableInfo);
				bean.setMainQueryTable(view.getMainQueryTable());
				bean.setMainSqlBean(mainSqlBean);
				return bean;
			}else return null;
		} catch (Exception e) {
			LogUtil.logError(DynamicDataService.class, "", e);
			return null;
		}
	}
	
	public void initSelectOptions(List<ConditionInfo> conditionInfos) throws AppRunTimeException{
		for(ConditionInfo cond: conditionInfos){
			if(cond.getSecondSelect()!=null&&cond.getSecondSelect().getSelectSql()!=null
					&&StringUtils.isNotBlank(cond.getSecondSelect().getSelectSql().getOptionSql())){
				List<Option> optionList=iSqlCombin.findOptionsBySql(cond.getSecondSelect().getSelectSql().getOptionSql(),
						cond.getSecondSelect().getSelectSql().getOptionValue(),
						cond.getSecondSelect().getSelectSql().getOptionName(),
						cond.getSecondSelect().getSelectSql().getHeadName(),
						cond.getSecondSelect().getSelectSql().getHeadValue(),
						""
						);
				cond.getSecondSelect().setOptions(optionList);
			}			
			if(cond.getSelectList()!=null){
				for(SelectBean bean:cond.getSelectList()){
					List<Option> optionList=iSqlCombin.findOptionsBySql(bean.getSql(),
							bean.getOptionValue(),
							bean.getOptionName(),
							bean.getHeadName(),
							bean.getHeadValue(),
							""
					);
					bean.setOptions(optionList);					
				}
			}
		}
	}
	
	public void initSelectOptions(List<ConditionInfo> conditionInfos,
								  PageConfigBean pageConfigBean, Integer currentUser, Integer departmentId, Long marketId, Long staffId)throws Exception{
		for(ConditionInfo cond: conditionInfos){
			 List<SelectBean> selectList=cond.getSelectList();
			if(selectList!=null){
				for(SelectBean bean:selectList){
					if(StringUtils.isNotBlank(bean.getSql())){
						String selectSql=replaceConfigParams(bean.getSql(), pageConfigBean, currentUser, departmentId, marketId, staffId);
						List<Option> optionList=iSqlCombin.findOptionsBySql(selectSql,
								bean.getOptionValue(),
								bean.getOptionName(),
								bean.getHeadName(),
								bean.getHeadValue(),
								bean.getDefaultValue()
						);
						bean.setOptions(optionList);
					}					
				}
			}
		}

	}

	
	
	public String replaceConfigParams(String sql,
									  PageConfigBean pageConfigBean,
									  Integer currentUser, Integer departmentId, Long marketId, Long staffId) {
		if (pageConfigBean.getSession() != null) {
			if (StrUtils.contains(sql, "#".concat(
					pageConfigBean.getSession().getCurrentUser()).concat("#"))) {
				if (currentUser != null) {
					sql = sql.replaceAll("#".concat(
							pageConfigBean.getSession().getCurrentUser())
							.concat("#"), currentUser.toString());
				} else {
					LogUtil.logError(this.getClass(),"DynamicViewShowImpl.businessDataProcess currentUser is null replace #_user_key# fail!");
				}

			}
			if (StrUtils.contains(sql, "#".concat(
					pageConfigBean.getSession().getCurrentDepartment()).concat("#"))) {
				if (departmentId != null) {
					sql = sql.replaceAll("#".concat(
							pageConfigBean.getSession().getCurrentDepartment())
							.concat("#"), departmentId.toString());
				} else {
					LogUtil.logError(this.getClass(),"DynamicViewShowImpl.businessDataProcess currentUser is null replace #_user_key# fail!");
				}
			}
			if(StrUtils.contains(sql, "#marketId#")){
				if(marketId != null){
                    sql = sql.replaceAll("#marketId#", marketId.toString());
                }
			}
			if(StrUtils.contains(sql, "#currentLoginUserId#")){
				if(marketId != null){
					sql = sql.replaceAll("#currentLoginUserId#", staffId.toString());
				}
			}
		}
		return sql;
	}
	
	
	public List<DynamicDataBean> initDynamicDataList() {
		try {
			List<DynamicDataBean> dynamicDataList = new ArrayList<DynamicDataBean>();
			List<DynamicView> viewList = this.dynamicViewService.findList();
			if (viewList != null) {
				for (DynamicView view : viewList) {
					DynamicDataBean bean = new DynamicDataBean();
					bean.setViewId(view.getDynamicViewId());
					PageTableColBean tableColbean = dynamicViewService
							.findPageTableColBean(view);
					PageConfigBean pageConfigBean = dynamicViewService
							.findPageConfigBean(view);
					DialogBean dialogBean = dynamicViewService
							.findDialogBean(view);

					ConditionBean conditionBean = dynamicViewService
							.findConditionBean(view);

					StateQueryBtnBean stateQueryBtnBean = dynamicViewService
							.findStateQueryBtnBean(view);

					bean.setTableColbean(tableColbean);
					bean.setConditionBean(conditionBean);
					bean.setPageConfigBean(pageConfigBean);
					bean.setTableColbean(tableColbean);
					bean.setDialogBean(dialogBean);
					bean.setStateQueryBtnBean(stateQueryBtnBean);
					dynamicDataList.add(bean);
					
					
				}
			}
			return dynamicDataList;
		} catch (Exception e) {
			LogUtil.logError(DynamicDataService.class, "", e);
			return null;
		}
	}
}
