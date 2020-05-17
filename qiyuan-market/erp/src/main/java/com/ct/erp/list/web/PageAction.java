package com.ct.erp.list.web;

import java.io.File;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.Map.Entry;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.web.struts2.ContextPvd;
import com.ct.erp.common.web.struts2.action.CmmCoreAction;
import com.ct.erp.lib.entity.Sysmenu;
import com.ct.erp.list.model.ColFormatBean;
import com.ct.erp.list.model.ComposeQueryBean;
import com.ct.erp.list.model.GridTableBean;
import com.ct.erp.list.service.BusDataExportExcel;
import com.ct.erp.list.service.DynamicViewShow;
import com.ct.erp.list.service.ISqlCombin;
import com.ct.util.AppRunTimeException;
import com.ct.util.json.JsonUtils;
import com.ct.util.lang.StrUtils;
import com.ct.util.web.ResponseUtils;

/**
 * 报表配置处理方法
 * 
 * @author jieketao
 * 
 */
@Scope("prototype")
@Controller("list.pageAction")
public class PageAction extends CmmCoreAction {

	private static final Logger log = LoggerFactory.getLogger(PageAction.class);

	private static final long serialVersionUID = 1L;

	// 实体信息类注入
	@Autowired
	private DynamicViewShow dynamicViewShow;
//	@Autowired
//	private CommonService commonService;;
	@Autowired
	private ISqlCombin iSqlCombin;
	@Autowired
	private BusDataExportExcel busDataExportExcel;


	// 容器方法注入
	@Autowired
	protected ContextPvd contextPvd;
	@Resource(name="redisTemplate")
	private RedisTemplate redisTemplate;
	private String sort; // 根据这个字段排序
	private String order; // asc或 desc
	private String title;// 页面标题

	private String param = "";// 传递过来的参数

	public String getSort() {
		return this.sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	public String getOrder() {
		return this.order;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	/**
	 * 首页链接地址
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String toRptIndex() {
		try {
			HttpServletRequest request = super.contextPvd.getRequest();
			Enumeration pNames = request.getParameterNames();
			Map<String, String> formMap = new HashMap<String, String>();
			while (pNames.hasMoreElements()) {
				String name = (String) pNames.nextElement();
				String value = request.getParameter(name);
				log.debug("toIndex the name is :" + name + " the value is :"
						+ value);
				formMap.put(name, value);
			}
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			if(sessionInfo != null) {
				Long marketId = sessionInfo.getMarketId();
				if (marketId != null) {
					formMap.put("marketId", marketId.toString());
				}
				Long staffId = sessionInfo.getStaffId();
				if(staffId != null){
					formMap.put("currentLoginUserId", staffId.toString());
				}
			}
			if (StringUtils.isNotEmpty(this.viewId)) {
				initParam(formMap);
				// 业务处理开始
				this.dynamicViewShow.businessHeadProcess(this.viewId,
						this.contextPvd, this.rows, this.page, this.mainSelect,
						this.condStr, this.sort, this.order, formMap);
				//ViewParam params=this.viewParamService.getViewParamByCode(1);
				//super.contextPvd.setRequestAttr("js", params.getParamValue());
			
			}
		} catch (Exception e) {
			// TODO: handle exception
			log.error("toRptIndex>>", e);
			e.printStackTrace();
		}
		return "index";
	}

	public void initParam(Map<String, String> formMap) {
		if (formMap != null) {
			StringBuilder paramSb = new StringBuilder();
			Iterator<Entry<String, String>> it = formMap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry<String, String> entry = it.next();
				if (!entry.getKey().equals("viewId")) {
					paramSb.append("&").append(entry.getKey()).append("=")
							.append(entry.getValue());
				}
			}
			this.param = paramSb.toString();
		}
	}

	@SuppressWarnings("unchecked")
	public String toIndex() {
		try {
			HttpServletRequest request = super.contextPvd.getRequest();
			Enumeration pNames = request.getParameterNames();
			Map<String, String> formMap = new HashMap<String, String>();
			while (pNames.hasMoreElements()) {
				String name = (String) pNames.nextElement();
				String value = request.getParameter(name);
				log.debug("toIndex the name is :" + name + " the value is :"
						+ value);
				formMap.put(name, value);
			}
			if (StringUtils.isNotEmpty(this.viewId)) {
				initParam(formMap);
				// 业务处理开始
				this.mainSelect = filterMainSelect(this.mainSelect);
				this.dynamicViewShow.businessHeadProcess(this.viewId,
						this.contextPvd, this.rows, this.page, this.mainSelect,
						this.condStr, this.sort, this.order, formMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("toIndex>>", e);
		}

		return "index";
	}

	/**
	 * 导出报表
	 * 
	 * @return
	 */
	public void doHandleDataExport() {
		try {
			HttpServletResponse response = this.contextPvd.getResponse();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = null;
			try {
				out = response.getWriter();
				this.mainSelect = filterMainSelect(this.mainSelect);
				ComposeQueryBean composeQueryBean = this.dynamicViewShow
						.getComposeQueryConBean(this.viewId, this.contextPvd,
								this.rows, this.page, this.mainSelect,
								this.condStr, this.sort, this.order);
				String sql = this.iSqlCombin.getQuerySql(composeQueryBean);
				String colName="";
				String colWidth="";
				String colField="";
				String colMeta="";
				log.debug("the colName is :"+composeQueryBean.getColumnName(false)+" colWidth is :"+composeQueryBean.getColumnWidth(false)+
						" colField is :"+composeQueryBean.getColumnField(false)+" metaType is :"+composeQueryBean.getColumnMetaType(false));
				/*if(StrUtils.contains(composeQueryBean.getColumnName(false),"操作")){*/
				if(composeQueryBean.getColumnName(false).equals("操作")){
					int index=composeQueryBean.getColumnName(false).lastIndexOf(",");
					if(index!=-1)colName=composeQueryBean.getColumnName(false).substring(0,index);
					index=composeQueryBean.getColumnWidth(false).lastIndexOf(",");
					if(index!=-1)colWidth=composeQueryBean.getColumnWidth(false).substring(0,index);
					index=composeQueryBean.getColumnField(false).lastIndexOf(",");
					if(index!=-1)colField=composeQueryBean.getColumnField(false).substring(0,index);
					index=composeQueryBean.getColumnMetaType(false).lastIndexOf(",");
					if(index!=-1)colMeta=composeQueryBean.getColumnMetaType(false).substring(0,index);					
				}else{
					colName=composeQueryBean.getColumnName(false);
					colWidth=composeQueryBean.getColumnWidth(false);
					colField=composeQueryBean.getColumnField(false);
					colMeta=composeQueryBean.getColumnMetaType(false);
				}
				log.debug("after the colName is :"+colName+" colWidth is :"+colWidth+
						" colField is :"+colField+" metaType is :"+colMeta);				
				String titleText = colName.concat(";")
						.concat(colWidth).concat(";")
						.concat(colField).concat(";")
						.concat(colMeta);

				String fileName=String.valueOf(Math.abs(UUID.randomUUID()
						.getLeastSignificantBits()));
				String uuidFile = "";
				String dir = this.contextPvd.getAppRealPath("/export"
						+ File.separator + fileName);
				File file = new File(dir);
				if (!file.exists()) {
					file.mkdirs();
				}
				uuidFile = dir + File.separator + fileName + ".xls";
				file = new File(uuidFile);
				if (!file.exists()) {
					file.createNewFile();
				}
				String pageTitle = "清单表";
				this.busDataExportExcel.exportFile(uuidFile, pageTitle,
						titleText, sql, null, composeQueryBean, null);
				pageTitle = URLEncoder.encode(pageTitle, "UTF-8");
				String returnJson = "filePath=".concat(uuidFile).concat(
						"&fileName=").concat(fileName);
				out.print(returnJson);
			} catch (Exception e) {
				throw e;
			} finally {
				out.flush();
				out.close();
			}
		} catch (Exception e) {
			log.error("Error in doHandleDataExport", e);
		}
	}

	public void findRequestParamByViewId() {
		try {
			HttpServletResponse response = this.contextPvd.getResponse();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = null;
			try {
				ColFormatBean colFormatBean = this.dynamicViewShow
						.findColFormatBeanByViewId(Integer.valueOf(this.viewId));
				out = response.getWriter();
				String returnJson = JsonUtils.toJSONStr(colFormatBean);
				out.print(returnJson);
			} catch (Exception e) {
				throw new AppRunTimeException(e);
			} finally {
				out.flush();
				out.close();
			}

		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}

	public void queryPageData() {
		try {
			HttpServletRequest request = super.contextPvd.getRequest();
			Enumeration pNames = request.getParameterNames();
			Map<String, String> formMap = new HashMap<String, String>();
			while (pNames.hasMoreElements()) {
				String name = (String) pNames.nextElement();
				String value = request.getParameter(name);
				formMap.put(name, value);
			}
			try {
				if (StringUtils.isNotEmpty(this.viewId)) {
					// 业务处理开始
					this.mainSelect = filterMainSelect(this.mainSelect);
					/*getRowsTry();
					getPageTry();
					getSortTry();
					getOrderTry();*/
					GridTableBean bean = this.dynamicViewShow.businessDataProcess(
							formMap.get("viewId"), this.contextPvd, this.rows,
							this.page, this.mainSelect, this.condStr, this.sort,
							this.order);
					bean.getPageInfo().setQuerySql("");
					bean.getPageInfo().setColumns("");
					String returnJson = JsonUtils.toJSONStr(bean.getPageInfo());
					ResponseUtils.renderJson(this.contextPvd.getResponse(),
							returnJson);
				}
			} catch (Exception e) {
				e.printStackTrace();
//				throw e;
			}
		} catch (ServiceException e) {
			log.error("报表Id[" + this.viewId + "]查询数据出错了！", e);
			e.printStackTrace();
			throw e;
		}
	}

	private void getOrderTry() {
		String token = SecurityUtils.getCurrentSessionInfo().getToken();
		String key = token + ".pageInfo."+this.viewId;
		if(StringUtils.isBlank(this.order)){
			Object order = redisTemplate.opsForHash().get(key, "order");
			if(order != null){
				this.order = order.toString();
			}
		}else{
			redisTemplate.opsForHash().put(key, "order", order);
			redisTemplate.expire(key, 30, TimeUnit.MINUTES);
		}
	}

	private void getPageTry() {
		String token = SecurityUtils.getCurrentSessionInfo().getToken();
		String key = token + ".pageInfo."+this.viewId;
		if(StringUtils.isBlank(this.page)){
			Object page = redisTemplate.opsForHash().get(key, "page");
			if(page != null){
				this.page = page.toString();
            }else {
                this.page = "1";
            }
        }else{
			redisTemplate.opsForHash().put(key, "page", page);
			redisTemplate.expire(key, 30, TimeUnit.MINUTES);
		}
	}

	public String filterMainSelect(String select) {
		if (StringUtils.isNotBlank(select)) {
			if (select.split(",").length == 2) {
				select = select.split(",")[1];
			}
			select = select.replaceAll("undefined", "");
			select = select.replaceAll(",", "");
			select = select.replaceAll(" ", "");
		}
		return select;

	}

	/**
	 * ajax查找兄弟节点html
	 * 
	 * @Title: querySiblingHtml
	 * @author: jieketao Create at: 2012-1-18 下午04:15:12
	 */
	public void querySiblingHtml() {
		try {
			HttpServletResponse response = this.contextPvd.getResponse();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = null;
			String html = "";
			try {
				String optionValue = this.contextPvd.getRequest().getParameter(
						"optionValue");
				out = response.getWriter();
				if (StringUtils.isNotEmpty(this.viewId)) {
					html = this.dynamicViewShow.findSiblingHtml(this.viewId,
							optionValue);

				}
				out.print(html);
			} catch (Exception e) {
				// TODO: handle exception
				throw new AppRunTimeException(e);
			} finally {
				out.flush();
				out.close();
			}

		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}

	/**
	 * 动态查询链接地址
	 * 
	 * @Title: queryLinkUrl
	 * @author: jieketao Create at: 2012-2-8 下午02:15:06
	 */
	public void queryLinkUrl() {
		try {
			HttpServletResponse response = this.contextPvd.getResponse();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = null;
			String html = "";
			try {
				String key = this.contextPvd.getRequest().getParameter("key");
				String type = this.contextPvd.getRequest().getParameter("type");
				out = response.getWriter();
				if (StringUtils.isNotEmpty(this.viewId)) {
					html = this.dynamicViewShow.findLinkUrl(this.viewId, key,
							type);

				}
				out.print(html);
			} catch (Exception e) {
				// TODO: handle exception
				throw new AppRunTimeException(e);
			} finally {
				out.flush();
				out.close();
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}
	
	public void queryParamLinkUrl() {
		try {
			HttpServletResponse response = this.contextPvd.getResponse();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = null;
			String html = "";
			try {
				String key = this.contextPvd.getRequest().getParameter("key");
				String type = this.contextPvd.getRequest().getParameter("type");
				out = response.getWriter();
				if (StringUtils.isNotEmpty(this.viewId)) {
					html = this.dynamicViewShow.findParamLinkUrl(this.viewId, key,
							type);

				}
				out.print(html);
			} catch (Exception e) {
				// TODO: handle exception
				throw new AppRunTimeException(e);
			} finally {
				out.flush();
				out.close();
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}

	public void queryOperateLinkUrlFromTodo() {
		try {
			HttpServletResponse response = this.contextPvd.getResponse();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = null;
			String html = "";
			try {
				out = response.getWriter();
				String rightCode = this.contextPvd.getRequest().getParameter(
						"rightCode");
				// String id = contextPvd.getRequest().getParameter("id");
				//AvalOperation avalOperation = this.commonService.findTodoAvalOperByRightCode(rightCode);
				//Set menuSet = avalOperation.getSysrightByRightCode().getSysmenus();
				Set menuSet=null;
				Map<String,Object> result=new HashMap<String,Object>();
				//result.put("url", avalOperation.getTodoUrl() );
				
				String menuUrl = "";
				if ((menuSet != null) && (menuSet.size() > 0)) {
					Iterator<Sysmenu> it = menuSet.iterator();
//					if (it.hasNext()) {
//						Sysmenu sysmenu = it.next();
//						result.put("current_id",sysmenu.getId() );
//						result.put("parent_id",sysmenu.getParentId() );
//						result.put("menu_text", sysmenu.getMenuText());
//						menuUrl = "&current_id=" + sysmenu.getId()
//								+ "&parent_id="
//								+ sysmenu.getParentId();
//					}
				}
//				if (StringUtils.isNotBlank(menuUrl)) {
//					html = avalOperation.getTodoUrl() + menuUrl;
//				} else {
//					html = avalOperation.getTodoUrl();
//				}
				out.print(JsonUtils.toJSONStr(result));
			} catch (Exception e) {
				// TODO: handle exception
				throw new AppRunTimeException(e);
			} finally {
				out.flush();
				out.close();
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}

	public String viewId;

	public String page;
	public String rows;

	public String mainSelect = "";

	public String condStr;
	public Integer currentId;

	public Integer getCurrentId() {
		return this.currentId;
	}

	public void setCurrentId(Integer currentId) {
		this.currentId = currentId;
	}

	public String getCondStr() {
		return this.condStr;
	}

	public void setCondStr(String condStr) {
		this.condStr = condStr;
	}

	public String getMainSelect() {
		return this.mainSelect;
	}

	public void setMainSelect(String mainSelect) {
		this.mainSelect = mainSelect;
	}

	public String getPage() {
		return this.page;
	}

	public void setPage(String page) {
		this.page = page;
	}

	public String getRows() {
		return this.rows;
	}

	public void setRows(String rows) {
		this.rows = rows;
	}

	public String getViewId() {
		return this.viewId;
	}

	public void setViewId(String viewId) {
		this.viewId = viewId;
	}

	public String getParam() {
		return this.param;
	}

	public void setParam(String param) {
		this.param = param;
	}

	public String getTitle() {
		return this.title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void getRowsTry() {
		String token = SecurityUtils.getCurrentSessionInfo().getToken();
		String key = token + ".pageInfo."+this.viewId;
		if(StringUtils.isBlank(this.rows)){
			Object rows = redisTemplate.opsForHash().get(key, "rows");
			if(rows != null){
				this.rows = rows.toString();
			}else{
                this.rows = "20";
            }
        }else{
			redisTemplate.opsForHash().put(key, "rows", rows);
			redisTemplate.expire(key, 30, TimeUnit.MINUTES);
		}
	}

	public void getSortTry() {
		String token = SecurityUtils.getCurrentSessionInfo().getToken();
		String key = token + ".pageInfo."+this.viewId;
		if(StringUtils.isBlank(this.sort)){
			Object sort = redisTemplate.opsForHash().get(key, "sort");
			if(sort != null){
				this.sort = sort.toString();
			}
		}else{
			redisTemplate.opsForHash().put(key, "sort", sort);
			redisTemplate.expire(key, 30, TimeUnit.MINUTES);
		}
	}
}