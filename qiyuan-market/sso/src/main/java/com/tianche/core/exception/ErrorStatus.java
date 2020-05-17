package com.tianche.core.exception;

public enum ErrorStatus {

	BAD_PARAM (1001 , "不合法的参数"),
	TIME_ERROR (1002 , "超出时间范围"),
	UNKOWN (1000, "未知错误");
	
	private final int code;
	private final String message;
	private ErrorStatus(int code, String message) {
		this.code = code;
		this.message = message;
	}
	public int getCode() {
		return code;
	}
	public String getMessage() {
		return message;
	}
	
}
