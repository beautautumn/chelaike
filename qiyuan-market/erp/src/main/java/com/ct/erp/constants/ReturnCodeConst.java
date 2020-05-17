package com.ct.erp.constants;

/**
 * 系统返回码常量定义
 * 
 * @author xueyufish
 * 
 */
public interface ReturnCodeConst {

	// ///////////////////////////////////////////////////////////
	// 成功返回码

	/**
	 * 无错误
	 */
	public static final String SUCCESS = "0000";

	/**
	 * 无错误
	 */
	public static final String SAVE_SUCCESS = "0001";

	/**
	 * 信息修改成功
	 */
	public static final String UPDATE_SUCCESS = "0002";

	/**
	 * 信息删除成功
	 */
	public static final String DELETE_SUCCESS = "0003";

	// ///////////////////////////////////////////////////////////
	// /系统错误返回码

	/**
	 * 系统错误
	 */
	public static final String SYS_ERROR = "1000";

	/**
	 * 必填参数为空
	 */
	public static final String EMPTY_PARAM_ERROR = "1001";

	/**
	 * 请求参数无效
	 */
	public static final String INVALID_PARAM_ERROR = "1002";

	/**
	 * 网络错误
	 */
	public static final String NETWORK_ERROR = "1003";

	/**
	 * 信息保存错误
	 */
	public static final String INFO_SAVE_ERROR = "1004";

	/**
	 * 信息修改错误
	 */
	public static final String INFO_UPDATE_ERROR = "1005";

	/**
	 * 信息删除错误
	 */
	public static final String INFO_DELETE_ERROR = "1006";

	// ///////////////////////////////////////////////////////////
	// 业务错误返回码

	/**
	 * 用户未登录
	 */
	public static final String NO_LOGIN = "2001";

	/**
	 * 未授权访问
	 */
	public static final String NO_AUTH = "2002";

	/**
	 * IP受限
	 */
	public static final String IP_LIMIT = "2003";

	/**
	 * 访问频率受限
	 */
	public static final String FREQ_LIMIT = "2004";

}
