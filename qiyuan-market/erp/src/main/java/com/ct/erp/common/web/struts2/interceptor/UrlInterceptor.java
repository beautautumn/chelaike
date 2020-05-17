package com.ct.erp.common.web.struts2.interceptor;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.StrutsStatics;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.MethodFilterInterceptor;
/**
 * URL地址拦截器
 * 
 * 针对页面伪静态地址，需要传入多个参数
 * 
 * 
 */
public class UrlInterceptor extends MethodFilterInterceptor {
	private static final long serialVersionUID = 1L;

	@Override
	protected String doIntercept(ActionInvocation invocation) throws Exception {
		Object action = invocation.getAction();
		ActionContext ctx = invocation.getInvocationContext();
		HttpServletRequest req = (HttpServletRequest) ctx
				.get(StrutsStatics.HTTP_REQUEST);
		if (action instanceof UrlAware) {
			UrlAware aware = (UrlAware) action;
			String url = req.getRequestURL().toString();
			int pointIndex = url.indexOf('.', url.lastIndexOf('/'));
			if (pointIndex == -1) {
				url += "index.do";
				pointIndex = url.indexOf('.', url.lastIndexOf('/'));
			}
			String paramStr = req.getQueryString();
			if (paramStr != null && !paramStr.trim().equals("")) {
				url += "?" + paramStr;
			}
			aware.setWholeUrl(url);
			int lineIndex = url.indexOf('_', url.lastIndexOf('/'));
			int mlineIndex = url.indexOf('-', url.lastIndexOf('/'));
			// 前路径结束点
			int preIndex = 0;
			if (lineIndex != -1) {
				// 有下划线（有分页）
				preIndex = lineIndex;
			} else if (mlineIndex != -1) {
				// 有中划线（有定制参数）
				preIndex = mlineIndex;
			} else {
				// 什么都没有
				preIndex = pointIndex;
			}
			aware.setPageLink(url.substring(0, preIndex));
			// 后路径开始点
			int suffixIndex = 0;
			if (mlineIndex != -1) {
				// 有中划线
				suffixIndex = mlineIndex;
			} else {
				suffixIndex = pointIndex;
			}
			aware.setPageSuffix(url.substring(suffixIndex));
			// 取页数和附加参数
			if (preIndex == suffixIndex) {
				// 没有分页，为第一页。
				aware.setPageNo(1);
			} else {
				// 去掉下划线"_"。
				String page = url.substring(preIndex + 1, suffixIndex);
				aware.setPageNo(NumberUtils.toInt(page, 1));
			}
			// 路径参数
			String pathParm = ctx.getName();
			lineIndex = pathParm.indexOf("_");
			mlineIndex = pathParm.indexOf("-");
			if (lineIndex != -1) {
				pathParm = pathParm.substring(0, lineIndex);
			} else if (mlineIndex != -1) {
				pathParm = pathParm.substring(0, mlineIndex);
			}
			aware.setPathParams(pathParm.split("/"));
			// 附加参数
			if (mlineIndex != -1) {
				String otherParam = ctx.getName().substring(mlineIndex + 1);
				aware.setOtherParams(otherParam.split("-"));
			}
		}
		return invocation.invoke();
	}
}
