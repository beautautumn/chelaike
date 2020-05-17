package com.ct.erp.common.model;

import javax.servlet.http.HttpServletRequest;

public class GridPageInfoUtil {
	
	public static GridPageInfo getGridPageInfo(HttpServletRequest request) {
		GridPageInfo gridPageInfo = new GridPageInfo();
		// 获得当前页数
		String pageIndex = request.getParameter("page");
		// 获得每页数据最大量
		String pageSize = request.getParameter("rows");
		gridPageInfo.setPage(pageIndex == null ? 1 : Integer.parseInt(pageIndex));
		gridPageInfo.setRp(pageSize == null ? 20 : Integer.parseInt(pageSize));

		return gridPageInfo;
	}

}
