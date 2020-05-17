package com.ct.erp.common.model;

public class InterfaceRes {

	/**
	 * 成功： 0 0000 没有错误 所有接口 无 进行相应的业务处理
	 * 系统或网络错误： 1 0001 请求方鉴权错误 所有接口
	 * 0002 请求参数错误 所有接口 描述具体的错误参数情况 进行界面报错或记录错误日志。
	 * 0003 请求参数超过长度 所有接口 列出具体超过长度的参数 进行界面报错或记录错误日志。
	 * 9999 其它位置错误 所有接口 给出系统错误信息。 进行界面报错或记录错误日志。
	 * 业务错误： 2 0001 业务不允许 所有接口 当任何业务逻辑不允许时，采用该通用错误编码。 进行界面报错或记录错误日志。
	 */
	private String code;
	/**
	 * 成功： 0
	 * 系统或网络错误： 1
	 * 业务错误： 2
	 */
	private String type;
	private String desc;
	private String procsTime;

	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getDesc() {
		return this.desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getProcsTime() {
		return this.procsTime;
	}

	public void setProcsTime(String procsTime) {
		this.procsTime = procsTime;
	}

}
