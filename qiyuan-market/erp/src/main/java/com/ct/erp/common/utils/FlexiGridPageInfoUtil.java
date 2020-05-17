package com.ct.erp.common.utils;

import javax.servlet.http.HttpServletRequest;

import com.ct.erp.common.model.FlexiGridPageInfo;

public class FlexiGridPageInfoUtil {
	
	private static String pageSize="20";

	/**
	 * 默认页面展现pagesize大小
	 * @Title:	getFlexGridPageInfo
	 * @Description: 获取分页信息
	 * @param pageVar 当前页数变量名
	 * @param maxRowsVar 每页数据最大量变量名
	 * @param request 当前请求
	 * @return
	 * @throws:   
	 * @author: jieketao
	 */
	public static FlexiGridPageInfo getFlexiGridPageInfo(HttpServletRequest request){
		FlexiGridPageInfo flexiGridPageInfo = new FlexiGridPageInfo();
		// 获得当前页数
		String pageOffset = request.getParameter("pager.offset")==null?"0":request.getParameter("pager.offset");
		flexiGridPageInfo.setRp(Integer.parseInt(pageSize));
		flexiGridPageInfo.setPage(pageOffset == null ? 0 : (Integer.parseInt(pageOffset)+Integer.parseInt(pageSize))/Integer.parseInt(pageSize));
		
				
		return flexiGridPageInfo;
	}
	
	/**
	 * 自定义pageSize大小
	 * @Title:	getFlexiGridPageInfo
	 * @Description: TODO
	 * @param request
	 * @param pageSize
	 * @return
	 * @throws:   
	 * @author:   jieketao
	 * Create at: 2011-7-27 下午06:53:14
	 */
	public static FlexiGridPageInfo getFlexiGridPageInfo(HttpServletRequest request,String pageSize){
		FlexiGridPageInfo flexiGridPageInfo = new FlexiGridPageInfo();
		// 获得当前页数
		String pageOffset = request.getParameter("pager.offset")==null?"0":request.getParameter("pager.offset");
		flexiGridPageInfo.setPage(pageOffset == null ? 0 : (Integer.parseInt(pageOffset)+Integer.parseInt(pageSize))/Integer.parseInt(pageSize));
		flexiGridPageInfo.setRp(Integer.parseInt(pageSize));
				
		return flexiGridPageInfo;
	}
	
	public static FlexiGridPageInfo getPaginationInfo(HttpServletRequest request){
		FlexiGridPageInfo flexiGridPageInfo = new FlexiGridPageInfo();
		// 获得当前页数
		String pageNo = request.getParameter("pageNo")==null?"0":request.getParameter("pageNo");
		String pageSize = request.getParameter("pageSize")==null?String.valueOf(flexiGridPageInfo.getRp()):request.getParameter("pageSize");
		flexiGridPageInfo.setPage(Integer.valueOf(pageNo)+1);
		flexiGridPageInfo.setRp(Integer.parseInt(pageSize));
				
		return flexiGridPageInfo;
	}	
}
