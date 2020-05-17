package com.ct.erp.api.che300;

import java.util.List;

/**
 * Created by jf on 15/6/8.
 */
 class Che300ModelWrapper {

    private String status;
    private List<Che300Model> model_list;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Che300Model> getModel_list() {
        return model_list;
    }

    public void setModel_list(List<Che300Model> model_list) {
        this.model_list = model_list;
    }
}
