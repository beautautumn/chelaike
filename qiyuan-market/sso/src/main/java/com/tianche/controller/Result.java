package com.tianche.controller;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by jf on 15/5/13.
 */
public class Result {

    private boolean success = true;

    private Map<String, Object> data = new HashMap<String, Object>();

    public static Result create(){
        return new Result();
    }

    public Result add(String key, Object value){
        data.put(key, value);
        return this;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public Map<String, Object> getData() {
        return data;
    }

    public void setData(Map<String, Object> data) {
        this.data = data;
    }
}
