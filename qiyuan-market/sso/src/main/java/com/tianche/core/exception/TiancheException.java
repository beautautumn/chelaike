package com.tianche.core.exception;

public class TiancheException extends RuntimeException {

	private String localMessage;
	private ErrorStatus errorStatus;

	public TiancheException() {
		super();
	}

	public TiancheException(String message) {
		this(message, null);
	}

	public TiancheException(ErrorStatus errorStatus, String message) {
		this(errorStatus, message, null);
	}

	public TiancheException(String message, Throwable cause) {
		this(ErrorStatus.UNKOWN, message, cause);
	}

	public TiancheException(ErrorStatus errorStatus, String message,
			Throwable cause) {
		super(message, cause);
		this.errorStatus = errorStatus;
		this.localMessage = message;
	}

	public String getLocalMessage() {
		return localMessage;
	}

	public void setLocalMessage(String localMessage) {
		this.localMessage = localMessage;
	}

	public ErrorStatus getErrorStatus() {
		return errorStatus;
	}

	public void setErrorStatus(ErrorStatus errorStatus) {
		this.errorStatus = errorStatus;
	}

}
