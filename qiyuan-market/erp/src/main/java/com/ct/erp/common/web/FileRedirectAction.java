package com.ct.erp.common.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ct.erp.common.utils.Struts2Utils;

public class FileRedirectAction extends SimpleActionSupport {
	private static final long serialVersionUID = 7036941468397752690L;
	/**
	 * jsp文件夹
	 */
	private String prefix = "/WEB-INF/jsp/";
	/**
	 * 跳转页面
	 */
	private String toPage = "";

	public void redirect() throws Exception {
		HttpServletResponse response = Struts2Utils.getResponse();
		HttpServletRequest request = Struts2Utils.getRequest();
		String page = Struts2Utils.getParameter("toPage");
		if ((page == null) || ("".equals(page))) {
			logger.warn("重定向页面为空!");
			response.sendError(404);
		} else {
			if (this.logger.isDebugEnabled()) {
				this.logger.debug("重定向到页面:" + this.prefix + page);
			}
			request.getRequestDispatcher(this.prefix + page).forward(request,
					response);
		}
	}

	public String getPrefix() {
		return this.prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

	public void setToPage(String toPage) {
		this.toPage = toPage;
	}

}