package com.ct.erp.common.exception;

/**
 * 基本异常, 继承自RuntimeException.
 */
@SuppressWarnings("serial")
public class BaseException extends RuntimeException {

	public BaseException() {
		super();
	}

	public BaseException(String message) {
		super(message);
	}

	public BaseException(Throwable cause) {
		super(cause);
	}

	public BaseException(String message, Throwable cause) {
		super(message, cause);
	}

}
