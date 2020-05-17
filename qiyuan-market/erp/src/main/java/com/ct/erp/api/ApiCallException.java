package com.ct.erp.api;

/**
 * Created by jf on 15/6/8.
 */
public class ApiCallException extends Exception{

    public ApiCallException(String message) {
        super(message);
    }

    public ApiCallException(String message, Throwable cause) {
        super(message, cause);
    }

}
