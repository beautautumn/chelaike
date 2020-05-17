package com.ct.erp.common.exception;

/**
 * Action层异常, 继承自BaseException.
 */
@SuppressWarnings("serial")
public class ActionException extends BaseException {

	public ActionException() {
		super();
	}

	public ActionException(String message) {
		super(message);
	}

	public ActionException(Throwable cause) {
		super(cause);
	}

	public ActionException(String message, Throwable cause) {
		super(message, cause);
	}
}
