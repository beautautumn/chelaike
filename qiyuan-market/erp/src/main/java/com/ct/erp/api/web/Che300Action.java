package com.ct.erp.api.web;

import com.ct.erp.api.ApiCallException;
import com.ct.erp.api.che300.*;
import com.ct.erp.common.utils.GlobalConfigUtil;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.util.HttpUtils;
import com.ct.erp.util.UcmsWebUtils;
import com.google.gson.Gson;
import com.google.gson.JsonParseException;

import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletResponse;

import java.util.List;

/**
 * Created by jf on 15/6/8.
 */

@Scope("prototype")
@Controller("api.Che300Action")
public class Che300Action extends SimpleActionSupport {

    private static final String token = GlobalConfigUtil.get("che300.token");

    private static final String url = GlobalConfigUtil.get("che300.url");

    private static final String GET_CAR_BRAND_LIST = "getCarBrandList";
    private static final String GET_CAR_SERIES_LIST = "getCarSeriesList";
    private static final String GET_CAR_MODEL_LIST = "getCarModelList";

    private static final String GET_USED_CAR_PRICE = "getUsedCarPrice";

    private int brandId;
    private int seriesId;
    private int modelId;
    private String regDate;
    private double mile;
    private int zone;
    private String title;
    private  Double price;

    public void getBrand() {
        HttpServletResponse response = ServletActionContext.getResponse();
        try {
            String s = HttpUtils.sendGet(url + "?oper=" + GET_CAR_BRAND_LIST + "&token=" + token);

            response.getWriter().append(s);
            UcmsWebUtils.jsonOutPut(response);
        }catch(Exception e){
            UcmsWebUtils.jsonOutPut(response);
        }
    }

    public void getSeries() {
        HttpServletResponse response = ServletActionContext.getResponse();
        try {
            String s = HttpUtils.sendGet(url + "?oper=" + GET_CAR_SERIES_LIST + "&token=" + token + "&brandId=" + brandId);
            response.getWriter().append(s);
            UcmsWebUtils.jsonOutPut(response);
        }catch(Exception e){
        	 UcmsWebUtils.jsonOutPut(response);
        }
    }

    public void getModel() throws ApiCallException {
        HttpServletResponse response = ServletActionContext.getResponse();
        try {
            String s = HttpUtils.sendGet(url + "?oper=" + GET_CAR_MODEL_LIST + "&token=" + token + "&seriesId=" + seriesId);
            response.getWriter().append(s);
            UcmsWebUtils.jsonOutPut(response);
        }catch(Exception e){
        	 UcmsWebUtils.jsonOutPut(response);
        }
    }

    public void getUsedCarPrice() throws ApiCallException {
        HttpServletResponse response = ServletActionContext.getResponse();
        String s = null;
        try {
            String getUrl = url + "?oper=" + GET_USED_CAR_PRICE + "&token=" + token + "&modelId=" + modelId + "&regDate=" + regDate + "&mile=" + mile + "&zone=" + zone;
            if (StringUtils.isNotBlank(title)) {
                getUrl += "&title=" + title;
            }
            if (price != null) {
                getUrl += "&price=" + price;
            }
            s = HttpUtils.sendGet(getUrl);
            response.getWriter().append(s);
            UcmsWebUtils.jsonOutPut(response);
        }catch(Exception e){
        	 UcmsWebUtils.jsonOutPut(response);
        }
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public int getSeriesId() {
        return seriesId;
    }

    public void setSeriesId(int seriesId) {
        this.seriesId = seriesId;
    }

    public int getModelId() {
        return modelId;
    }

    public void setModelId(int modelId) {
        this.modelId = modelId;
    }

    public String getRegDate() {
        return regDate;
    }

    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }

    public double getMile() {
        return mile;
    }

    public void setMile(double mile) {
        this.mile = mile;
    }

    public int getZone() {
        return zone;
    }

    public void setZone(int zone) {
        this.zone = zone;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }
}
