package com.ct.erp.api.che300;

/**
 * Created by jf on 15/6/8.
 */
public class Che300Model{

    private int model_id;
    private String model_name;
    private Double model_price;
    private String model_year;
    private String discharge_standard;

    public int getModel_id() {
        return model_id;
    }

    public void setModel_id(int model_id) {
        this.model_id = model_id;
    }

    public String getModel_name() {
        return model_name;
    }

    public void setModel_name(String model_name) {
        this.model_name = model_name;
    }

    public Double getModel_price() {
        return model_price;
    }

    public void setModel_price(Double model_price) {
        this.model_price = model_price;
    }

    public String getModel_year() {
        return model_year;
    }

    public void setModel_year(String model_year) {
        this.model_year = model_year;
    }

    public String getDischarge_standard() {
        return discharge_standard;
    }

    public void setDischarge_standard(String discharge_standard) {
        this.discharge_standard = discharge_standard;
    }
}
