package com.ct.erp.api.che300;

import java.util.List;

/**
 * Created by jf on 15/6/8.
 */
class Che300SeriesWrapper {

    private String status;

    private List<Che300Series> series_list;


    public String getStatus() {

        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Che300Series> getSeries_list() {
        return series_list;
    }

    public void setSeries_list(List<Che300Series> series_list) {
        this.series_list = series_list;
    }
}
