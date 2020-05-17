package com.ct.erp.list.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.model.GridPageInfo;
import com.ct.erp.common.model.GridPageInfoUtil;
import com.ct.erp.common.model.Pagination;
import com.ct.erp.common.web.struts2.action.CmmCoreAction;
import com.ct.erp.lib.entity.DynamicView;
import com.ct.erp.list.service.DynamicTableService;
import com.ct.util.json.JsonUtils;
import com.ct.util.web.ResponseUtils;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("list.dynamicTableAction")
public class DynamicTableAction extends CmmCoreAction {

	private static final Log log = LogFactory.getLog(DynamicTableAction.class);

	@Autowired
	private DynamicTableService dynamicTableService;

	private DynamicView view;

	private boolean winIsClose = false;

	public String toViewList() {
		try {

		} catch (Exception e) {
			log
					.error(
							"Error in DynamicTableAction.toViewList method!Args-->departId is :",
							e);
			return super.ERROR;
		}
		return "toViewList";
	}

	public void queryPageData() {
		try {
			GridPageInfo pageInfo = GridPageInfoUtil
					.getGridPageInfo(this.contextPvd.getRequest());
			Pagination pagenation = this.dynamicTableService.findListByPage(1,
					1000);
			// Pagination pagenation=
			// dynamicTableService.findListByPage(pageInfo.getPage(),
			// pageInfo.getRp());
			pageInfo.setRows(pagenation.getList());
			pageInfo.setPageCount(pagenation.getTotalPage());
			pageInfo.setTotal(pagenation.getTotalCount());
			String returnJson = JsonUtils.toJSONStr(pageInfo);
			ResponseUtils.renderJson(this.contextPvd.getResponse(), returnJson);
		} catch (Exception e) {
			log.error("queryPageData>>", e);
		}
	}

	public String viewEdit() {
		try {
			DynamicView entity = this.dynamicTableService.findByPk(this.view
					.getDynamicViewId());
			entity.setMainQueryTable(this.view.getMainQueryTable().replaceAll(
					"&quot;", "\""));
			entity.setOptBtnDef(this.view.getOptBtnDef().replaceAll("&quot;",
					"\""));
			entity.setPageConfigDef(this.view.getPageConfigDef().replaceAll(
					"&quot;", "\""));
			entity.setQueryDef(this.view.getQueryDef().replaceAll("&quot;",
					"\""));
			entity.setStateQueryBtnDef(this.view.getStateQueryBtnDef()
					.replaceAll("&quot;", "\""));
			entity.setTableColDef(this.view.getTableColDef().replaceAll(
					"&quot;", "\""));
			entity.setTablePropertyDef(this.view.getTablePropertyDef()
					.replaceAll("&quot;", "\""));
			this.dynamicTableService.saveOrUpdate(entity);
			this.winIsClose = true;
		} catch (Exception e) {
			log
					.error(
							"Error in DynamicTableAction.viewEdit method!Args-->id is :",
							e);
			return super.ERROR;
		}
		return this.toViewEdit();
	}

	public String toViewEdit() {
		try {
			DynamicView entity = this.dynamicTableService.findByPk(this.view
					.getDynamicViewId());
			if (entity != null) {
				this.view = entity;
			}
		} catch (Exception e) {
			log
					.error(
							"Error in  DynamicTableAction.toViewEdit method!Args-->id is :",
							e);
		}
		return "viewEdit";
	}

	public DynamicView getView() {
		return this.view;
	}

	public void setView(DynamicView view) {
		this.view = view;
	}

	public boolean isWinIsClose() {
		return this.winIsClose;
	}

	public void setWinIsClose(boolean winIsClose) {
		this.winIsClose = winIsClose;
	}

}