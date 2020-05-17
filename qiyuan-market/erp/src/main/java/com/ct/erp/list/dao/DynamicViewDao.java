package com.ct.erp.list.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.web.struts2.ContextPvd;
import com.ct.erp.lib.entity.DynamicView;
import com.ct.erp.list.model.ComposeQueryBean;
import com.ct.erp.list.service.PageResultSet;
import com.ct.util.AppRunTimeException;

@Repository
public class DynamicViewDao extends BaseDaoImpl<DynamicView> {

	@Autowired
	protected ContextPvd contextPvd;

	public DynamicView getDynamicViewByPk(Integer id)
			throws AppRunTimeException {
		try {
			return super.get(id);
		} catch (Exception e) {
			throw new AppRunTimeException("getDynamicViewByPk error:" + e);
		}
	}

	/**
	 * 根据动态sql查询列表数据
	 * 
	 * @Title: findDynamicDataList
	 * @param colFields
	 * @param sqlMap
	 * @param pageInfo
	 * @param conditionMap
	 * @throws AppRunTimeException
	 * @author: jieketao Create at: 2012-2-1 上午09:35:33
	 */
	@SuppressWarnings("deprecation")
	public List findDynamicDataList(String sql,ComposeQueryBean bean)
			throws AppRunTimeException {
		try {			
			log.debug("The combinSql is :" + sql);
			Connection con = super.getSession().connection();
			PageResultSet pageResultSet = new PageResultSet(bean.getPageInfo());
			bean.getPageInfo().setRows(pageResultSet.getData(sql, null, con,
					bean.getColPageTableColInfoMap()));
			bean.getPageInfo().setColumns(bean.getSelectCol(true));
			return bean.getPageInfo().getRows();
		} catch (Exception e) {
			throw new AppRunTimeException(e);
		}
	}
	
	public List findSelectOptionList(String sql,String optionValue,String optionName)
			throws AppRunTimeException {
		try {			
			log.debug("The select option sql is :" + sql);
			Connection con =null;	
			Statement st=null;
			ResultSet rs=null;
			List<Map<String,String>> result=null;
			try {
				con = super.getSession().connection();
				st=con.createStatement();				
				rs=st.executeQuery(sql);
				if(rs!=null){
					result=new ArrayList<Map<String,String>>();
					while(rs.next()){
						Map<String,String> optionMap=new HashMap<String,String>();
						optionMap.put(optionName, rs.getString(optionName));
						optionMap.put(optionValue, rs.getString(optionValue));
						result.add(optionMap);
					}
				}
				return result;
			} catch (Exception e) {
				throw e;
			}finally{
				if(rs!=null)rs.close();
				if(st!=null)st.close();
				if(con!=null)con.close();
			}
		} catch (Exception e) {
			throw new AppRunTimeException("Method in findSelectOptionList has erorrs:",e);
		}
	}
	
}
