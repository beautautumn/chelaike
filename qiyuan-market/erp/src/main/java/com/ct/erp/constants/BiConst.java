package com.ct.erp.constants;

/**
 * 业务常量定义
 * 
 * @author xueyufish
 * 
 */
public interface BiConst {

	// /////////////////////////////////////////////////////
	// == 信息来源相关
	public final Short ACQU_INFO_SOURCE = 0; // 收购信息来源
	public final Short SALE_INFO_SOURCE = 1;// 销售信息来源

	// /////////////////////////////////////////////////////
	// == 员工相关
	public final String VALID_STAFF_TAG = "1"; // 有效员工标记
	public final String TRY_STAFF_TAG = "1";// 试用标记
	public final String NO_TRY_STAFF_TAG = "0";// 非试用标记

	// //////////////////////////////////////////////////////
	// == 库存相关
	public static final String STOCK_MAINTAINING = "0"; // 整备状态，整备中
	public static final String STOCK_SALING = "1"; // 整备状态，在售
	public static final String STOCK_SALED = "2"; // 整备状态，已售
	public static final String STOCK_BACKED = "3"; // 整备状态，已退车

	public static final Short STOCK_IN = 1; // 库存状态：在库

	public static final String STOCK_QUERY_WITH_STATE = "sqs"; // 根据库存状态查询车辆列表
	public static final String STOCK_QUERY_WITH_COLLECT = "sqc"; // 根据收藏状态查询车辆列表
	public static final String STOCK_QUERY_WITH_SHARE = "sqshare"; // 查询分享车辆列表

	public static final Short STOCK_COLLECTED = 1; // 库存车辆收藏标记：已收藏
	public static final Short STOCK_NO_COLLECTED = 0; // 库存车辆收藏标记：未收藏

	// //////////////////////////////////////////////////////
	// == 公司相关
	public static final String CORP_WAIT_AUDIT = "3"; // 公司状态，待审核

	// //////////////////////////////////////////////////////
	// == 销售相关
	public static final String SALE_NO_MORTAGE = "0"; // 非按揭购车
	public static final String SALE_MORTAGE = "1"; // 按揭购车

	// //////////////////////////////////////////////////////
	// == 付款相关
	public static final String BUY_NO_PAY = "0"; // 未付款
	public static final String BUY_PAYING = "1"; // 付款中
	public static final String BUY_PAYED = "2"; // 付款完成

	// //////////////////////////////////////////////////////
	// == 收款相关
	public static final String SALE_NO_RECV = "0"; // 未收款
	public static final String SALE_RECVING = "1"; // 收款中
	public static final String SALE_RECVED = "2"; // 收款完成

	// //////////////////////////////////////////////////////
	// == 字典相关
	public static final String CAR_COLOR_CODE = "car_color"; // 车身颜色
	public static final String UPHOLSTERY_COLOR_CODE = "upholstery_color"; // 内饰颜色

}
