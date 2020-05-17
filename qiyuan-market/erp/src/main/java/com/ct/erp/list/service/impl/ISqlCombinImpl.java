package com.ct.erp.list.service.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.common.web.struts2.ContextPvd;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.list.dao.DynamicViewDao;
import com.ct.erp.list.model.ComposeQueryBean;
import com.ct.erp.list.model.ConditionValueBean;
import com.ct.erp.list.model.Option;
import com.ct.erp.list.model.PageTableColInfo;
import com.ct.erp.list.service.ISqlCombin;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.util.AppRunTimeException;
import com.ct.util.lang.StrUtils;

@Service
public class ISqlCombinImpl implements ISqlCombin {

	@Autowired
	protected ContextPvd contextPvd;
	@Autowired
	private StaffDao staffDao;
	@Autowired
	private DynamicViewDao dynamicViewDao;

	@Autowired
	public void setDynamicViewDao(DynamicViewDao dynamicViewDao) {
		this.dynamicViewDao = dynamicViewDao;
	}

	/**
	 * 拼接需要查询的sql
	 * 
	 * @Title: combinSelectColSql
	 * @param colFields
	 * @author: jieketao Create at: 2012-2-1 上午09:36:10
	 */
	public String getSelectCol(Map<String, PageTableColInfo> colFields) {
		Iterator<Map.Entry<String, PageTableColInfo>> it = colFields.entrySet()
				.iterator();
		StringBuilder sql = new StringBuilder();
		while (it.hasNext()) {
			Map.Entry<String, PageTableColInfo> entry = it.next();
			sql.append(entry.getKey());
			sql.append(",");
		}
		if (sql.length() > 0)
			sql = sql.deleteCharAt(sql.length() - 1);
		return sql.toString();
	}

	public String getQuerySql(ComposeQueryBean composeQueryBean) throws AppRunTimeException {
		try {
			StringBuilder sql = new StringBuilder();
			String columns = getSelectCol(composeQueryBean.getColPageTableColInfoMap());
			sql.append("select ");
			sql.append(columns);
			sql.append("  from (");
			if (composeQueryBean.getSqlMap() != null) {
				if (StringUtils.isNotBlank(composeQueryBean.getSqlMap().get("mainSql"))) {
					sql.append(composeQueryBean.getSqlMap().get("mainSql"));
				}
				sql.append("\t");

				if (composeQueryBean.getSqlMap().get("baseWhereSql") != null
						&& StringUtils.isNotBlank(composeQueryBean.getSqlMap().get("baseWhereSql"))) {
					sql.append(composeQueryBean.getSqlMap().get("baseWhereSql"));
				}
				// 判断是否有按钮查询条件
				if (composeQueryBean.getSqlMap().get("condSql") != null
						&& StringUtils.isNotBlank(composeQueryBean.getSqlMap().get("condSql"))) {
					sql.append(composeQueryBean.getSqlMap().get("condSql"));
				}
				if (composeQueryBean.getConditionMap().size() > 0) {
					// 添加查询框条件
					if (composeQueryBean.getConditionMap().size() > 0) {
						Iterator<Map.Entry<String, ConditionValueBean>> it = composeQueryBean.getConditionMap()
								.entrySet().iterator();
						while (it.hasNext()) {
							Map.Entry<String, ConditionValueBean> entry = it.next();
							sql.append("\t");
							ConditionValueBean bean=entry.getValue();
							//如果配置了sql在哪些位置被替换，那么先替换
							if(StringUtils.isNotBlank(bean.getPositionName())){
								String temp=sql.toString().replaceAll("#"+bean.getPositionName()+"#", bean.getSql());
								sql.delete(0, sql.length());
								sql.append(temp);
							}else sql.append(entry.getValue().getSql());
						}
					}
				} else if (composeQueryBean.getSqlMap().get("defWhereSql") != null
						&& StringUtils.isNotBlank(composeQueryBean.getSqlMap().get("defWhereSql"))) {
					sql.append(composeQueryBean.getSqlMap().get("defWhereSql"));
				}

				if (composeQueryBean.getSqlMap().get("groupBySql") != null
						&& StringUtils.isNotBlank(composeQueryBean.getSqlMap().get("groupBySql"))) {
					sql.append("\t");
					sql.append(composeQueryBean.getSqlMap().get("groupBySql"));
				}
				if (composeQueryBean.getSqlMap().get("orderBySql") != null
						&& StringUtils.isNotBlank(composeQueryBean.getSqlMap().get("orderBySql"))) {
					sql.append("\t");
					sql.append(composeQueryBean.getSqlMap().get("orderBySql"));
				}
			}
//			if (StringUtils.isNotBlank(composeQueryBean.getOrder()) && StringUtils.isNotBlank(composeQueryBean.getSort())) {
//				sql.append(" order by " +  composeQueryBean.getSort()+ " " + composeQueryBean.getOrder() +" ");
//			}	
			sql.append(") t ");
			if (StringUtils.isNotBlank(composeQueryBean.getOrder()) && StringUtils.isNotBlank(composeQueryBean.getSort())) {
				sql.append("order by " +  composeQueryBean.getSort()+ " " + composeQueryBean.getOrder());
			}

			String resultSql = sql.toString();
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();   		
//			List<Sysright> sysrightList = sessionInfo.getSysrightList();
			
			String staffId = null;
			if(sessionInfo != null){
				staffId = sessionInfo.getStaffId().toString();
			}
//			String subDepart=String.valueOf(contextPvd.getSessionAttr(Const._USER_SUB_DEPARTMENT));
//			String subOrg = String.valueOf(contextPvd.getSessionAttr(Const._USER_SUB_ORGANIZATION));
			Integer parentDepartId = null;
//			if (staffId != null) {
//				Staff staff = staffDao.get(staffId);
//				if (staff.getDepartment() != null)
//					departId = staff.getDepartment().getDepartId();
//				if (departId != null)
//					parentDepartId = commonService
//							.findFirstDepartment(departId).getDepartId();
//				
//			}

			if (staffId != null
					&& StrUtils.contains(sql.toString(), "#_user_key#")) {
				resultSql = resultSql.replaceAll("#_user_key#", staffId
						.toString());
			}
//
//			if (departId != null
//					&& StrUtils.contains(sql.toString(), "#_user_department#")) {
//				resultSql = resultSql.replaceAll("#_user_department#", departId
//						.toString());
//			}
			
//			if (parentDepartId != null
//					&& StrUtils.contains(sql.toString(),
//							"#_user_parent_department#")) {
//				resultSql = resultSql.replaceAll("#_user_parent_department#",
//						parentDepartId.toString());
//			}
			
//			if (subDepart != null
//					&& StrUtils.contains(sql.toString(),
//							"#_user_sub_department#")) {
//				resultSql = resultSql.replaceAll("#_user_sub_department#",subDepart);
//			}	
//			if (subOrg != null
//					&& StrUtils.contains(sql.toString(),
//							"#_user_sub_organization#")) {
//				resultSql = resultSql.replaceAll("#_user_sub_organization#",subOrg);
//			}	
			return resultSql;
		} catch (Exception e) {
			throw new AppRunTimeException(
					"Error in ISqlCombinImpl getQuerySql :", e);
		}
	}

	@Override
	public List<Option> findOptionsBySql(String sql, String optionValue,
			String optionName,String headKey,String keyValue,String defaultValue) throws AppRunTimeException {
		List<Map<String,String>> mapList=this.dynamicViewDao.findSelectOptionList(sql,optionValue, optionName);
		List<Option> options=new ArrayList<Option>();
		if(StringUtils.isNotBlank(headKey)){
			Option option=new Option();
			option.setText(headKey);
			option.setValue(keyValue);
			options.add(option);
		}
		for(Map<String,String> map:mapList){
			Option option=new Option();
			option.setText(map.get(optionName));
			option.setValue(map.get(optionValue));
			if(map.get(optionValue).equals(defaultValue)){
				option.setDefaultSelect(true);
			}
			options.add(option);
		}
		return options;
	}
}
