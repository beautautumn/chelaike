package com.ct.erp.common.orm;

import java.util.Map;


public class BuildPropertyFilterParam {
    private String hql;
    private Map<String, Object> param;


    public BuildPropertyFilterParam(String hql, Map<String, Object> param) {
        this.hql = hql;
        this.param = param;
    }

    public String getHql() {
        return hql;
    }

    public void setHql(String hql) {
        this.hql = hql;
    }

    public Map<String, Object> getParam() {
        return param;
    }

    public void setParam(Map<String, Object> param) {
        this.param = param;
    }
}
