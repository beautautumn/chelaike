package com.ct.erp.list.service.impl;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.ct.erp.lib.entity.DynamicView;
import com.ct.erp.list.dao.DynamicViewDao;
import com.ct.erp.list.model.ComposeQueryBean;
import com.ct.erp.list.model.ConditionBean;
import com.ct.erp.list.model.ConditionInfo;
import com.ct.erp.list.model.DialogBean;
import com.ct.erp.list.model.MainSqlInfo;
import com.ct.erp.list.model.PageConfigBean;
import com.ct.erp.list.model.PageTableColBean;
import com.ct.erp.list.model.PageTableInfo;
import com.ct.erp.list.model.StateQueryBtnBean;
import com.ct.erp.list.service.DynamicViewService;
import com.ct.util.AppRunTimeException;
import com.google.gson.Gson;

/**
 * 
 * <P>
 * 公司名称: 云潮网络
 * </P>
 * <P>
 * 项目名称： 哪有车爬虫
 * </P>
 * <P>
 * 模块名称： 报表查询
 * </P>
 * 
 * @Title: DynamicViewServiceImpl.java
 * @Description: TODO
 * @author: jieketao
 * @version: 1.0 Create at: 2012-1-18 下午04:05:18
 */
@Service("dynamicViewService")
@Transactional
public class DynamicViewServiceImpl implements DynamicViewService {

	private static final Gson gson = new Gson();

	private DynamicViewDao dynamicViewDao;

	@Autowired
	public void setDynamicViewDao(DynamicViewDao dynamicViewDao) {
		this.dynamicViewDao = dynamicViewDao;
	}

	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public DynamicView findDynamicViewByPk(Integer id)
			throws AppRunTimeException {

		return dynamicViewDao.getDynamicViewByPk(id);
	}

	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public List<DynamicView> findList() throws AppRunTimeException {

		return dynamicViewDao.findAll();
	}

	/**
	 * 通过json传获得条件对象
	 * 
	 * @Title: findConditionInfo
	 * @param view
	 * @return
	 * @throws AppRunTimeException
	 * @author: jieketao Create at: 2012-1-18 下午04:05:36
	 */
	public ConditionInfo findConditionInfo(DynamicView view)
			throws AppRunTimeException {

		try {
			Assert.notNull(view);
			if (StringUtils.isNotEmpty(view.getQueryDef())) {
				return gson.fromJson(view.getQueryDef(), ConditionInfo.class);
			}
		} catch (Exception e) {
			throw new AppRunTimeException(e);
		}

		return null;
	}

	/**
	 * 通过json传获得表对象
	 */
	public PageTableInfo findPageTable(DynamicView view)
			throws AppRunTimeException {

		try {
			Assert.notNull(view);
			if (StringUtils.isNotEmpty(view.getTablePropertyDef())) {
				return gson.fromJson(view.getTablePropertyDef(),
						PageTableInfo.class);
			}
		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException(e);
		}
		return null;
	}

	/**
	 * 通过json传获得表列对象
	 */
	public PageTableColBean findPageTableColBean(DynamicView view)
			throws AppRunTimeException {
		try {
			Assert.notNull(view);
			if (StringUtils.isNotEmpty(view.getTableColDef())) {
				return gson.fromJson(view.getTableColDef(),
						PageTableColBean.class);
			}
		} catch (Exception e) {
			throw new AppRunTimeException(e);
		}
		return null;
	}

	/**
	 * 获得分页数据对象
	 */
	public void findDynamicDataList(String sql,ComposeQueryBean bean)
			throws AppRunTimeException {

		dynamicViewDao.findDynamicDataList(sql,bean);
	}

	/**
	 * 通过json传获得报表配置对象
	 */
	public PageConfigBean findPageConfigBean(DynamicView view)
			throws AppRunTimeException {
		try {
			Assert.notNull(view);
			if (StringUtils.isNotEmpty(view.getTablePropertyDef())) {
				return gson.fromJson(view.getPageConfigDef(),
						PageConfigBean.class);
			}
		} catch (Exception e) {
			throw new AppRunTimeException(e);
		}
		return null;
	}

	/**
	 * 通过json传获得对话框对象
	 */
	public DialogBean findDialogBean(DynamicView view)
			throws AppRunTimeException {
		try {
			Assert.notNull(view);
			if (StringUtils.isNotEmpty(view.getOptBtnDef())) {
				return gson.fromJson(view.getOptBtnDef(), DialogBean.class);
			}
		} catch (Exception e) {
			throw new AppRunTimeException(e);
		}
		return null;
	}

	/**
	 * 通过json传获得条件对象
	 */
	public ConditionBean findConditionBean(DynamicView view)
			throws AppRunTimeException {

		try {
			Assert.notNull(view);
			if (StringUtils.isNotEmpty(view.getQueryDef())) {
				return gson.fromJson(view.getQueryDef(), ConditionBean.class);
			}
		} catch (Exception e) {
			throw new AppRunTimeException(e);
		}
		return null;
	}

	/**
	 * 通过json传获得状态查询对象
	 */
	public StateQueryBtnBean findStateQueryBtnBean(DynamicView view)
			throws AppRunTimeException {

		try {
			Assert.notNull(view);
			if (StringUtils.isNotEmpty(view.getStateQueryBtnDef())) {
				return gson.fromJson(view.getStateQueryBtnDef(),
						StateQueryBtnBean.class);
			}
		} catch (Exception e) {
			throw new AppRunTimeException(e);
		}
		return null;
	}

	public MainSqlInfo findMainSqlBean(DynamicView view)
			throws AppRunTimeException {

		try {
			Assert.notNull(view);
			if (StringUtils.isNotEmpty(view.getMainQueryTable())) {
				return gson.fromJson(view.getMainQueryTable(),
						MainSqlInfo.class);
			}
		} catch (Exception e) {
			throw new AppRunTimeException(e);
		}
		return null;
	}
}
