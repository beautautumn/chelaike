package com.ct.erp.api.che300;

import java.util.List;

/**
 * Created by jf on 15/6/8.
 */
class Che300BrandWrapper {

    private String status;

    private List<Che300Brand> brand_list;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Che300Brand> getBrand_list() {
        return brand_list;
    }

    public void setBrand_list(List<Che300Brand> brand_list) {
        this.brand_list = brand_list;
    }
}
