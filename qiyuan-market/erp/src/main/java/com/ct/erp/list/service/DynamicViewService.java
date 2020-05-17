package com.ct.erp.list.service;

import java.util.List;

import com.ct.erp.lib.entity.DynamicView;
import com.ct.erp.list.model.ComposeQueryBean;
import com.ct.erp.list.model.ConditionBean;
import com.ct.erp.list.model.DialogBean;
import com.ct.erp.list.model.MainSqlInfo;
import com.ct.erp.list.model.PageConfigBean;
import com.ct.erp.list.model.PageTableColBean;
import com.ct.erp.list.model.PageTableInfo;
import com.ct.erp.list.model.StateQueryBtnBean;
import com.ct.util.AppRunTimeException;
/**
 * 
 * <P>公司名称: 云潮网络</P>
 * <P>项目名称： 哪有车爬虫</P>
 * <P>模块名称： 查询页面实体信息类</P>
 * @Title:	DynamicViewService.java
 * @Description: TODO
 * @author:    jieketao
 * @version:   1.0
 * Create at:  2012-1-18 下午02:25:47
 */
public interface DynamicViewService {
	
	public void findDynamicDataList(String sql,ComposeQueryBean bean)throws AppRunTimeException;

	/**
	 * 动态查找报表
	 * @Title:	findDynamicViewByPk
	 * @param id
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午03:58:54
	 */
	public DynamicView findDynamicViewByPk(Integer id)throws AppRunTimeException;
	/**
	 * 查找所有报表
	 * @Title:	findList
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午03:59:43
	 */
	public List<DynamicView> findList()throws AppRunTimeException;
	/**
	 * 查找表信息
	 * @Title:	findPageTable
	 * @param view
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:00:08
	 */
	public PageTableInfo findPageTable(DynamicView view)throws AppRunTimeException;
	/**
	 * 查找报表列信息
	 * @Title:	findPageTableColBean
	 * @param view
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:00:25
	 */
	public PageTableColBean findPageTableColBean(DynamicView view)throws AppRunTimeException;
	/**
	 * 查找对话框信息
	 * @Title:	findDialogBean
	 * @param view
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:00:36
	 */
	public DialogBean findDialogBean(DynamicView view)throws AppRunTimeException;
	/**
	 * 查找条件实体bean
	 * @Title:	findConditionBean
	 * @param view
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:00:45
	 */
	public ConditionBean findConditionBean(DynamicView view)throws AppRunTimeException;
	/**
	 * 查找状态查询按钮bean
	 * @Title:	findStateQueryBtnBean
	 * @param view
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:00:59
	 */
	public StateQueryBtnBean findStateQueryBtnBean(DynamicView view)throws AppRunTimeException; 
	/**
	 * 查找报表配置bean
	 * @Title:	findPageConfigBean
	 * @param view
	 * @return
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:01:11
	 */
	public PageConfigBean findPageConfigBean(DynamicView view)throws AppRunTimeException;
	
		
	/**
	 * 查找主sql信息
	 * @param view
	 * @return
	 * @throws AppRunTimeException
	 */
	public MainSqlInfo findMainSqlBean(DynamicView view)throws AppRunTimeException;
	
}
