package com.ct.erp.mtype.web;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.ct.erp.common.utils.GlobalConfigUtil;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.mtype.entity.Brand;
import com.ct.erp.mtype.entity.Model;
import com.ct.erp.mtype.entity.Series;
import com.ct.erp.util.HttpUtils;
import com.ct.erp.util.UcmsWebUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("erp.mtypeAction")
public class MtypeAction extends SimpleActionSupport{
    private String brandName;
    private String seriesName;

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getSeriesName() {
        return seriesName;
    }

    public void setSeriesName(String seriesName) {
        this.seriesName = seriesName;
    }

    public void brandlist(){
        /*String brandJsonString = HttpUtils.sendGet(GlobalConfigUtil.get("mtype.remotehostport")+"/ewalker-web/controller/getBrandList");
        JSONArray brandJSONArray = JSON.parseArray(brandJsonString);
        Iterator<Object> iterator = brandJSONArray.iterator();
        List<Brand> brandList = new ArrayList<Brand>();
        while(iterator.hasNext()){
            JSONObject obj = (JSONObject)iterator.next();
            Brand brand = new Brand();
            brand.setId(obj.getString("brandName"));
            brand.setName(obj.getString("brandName"));
            brandList.add(brand);
        }
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(brandList));*/

        String brandJsonString = HttpUtils.sendGet(GlobalConfigUtil.get("mtype.remotehostport")+"/api/v1/brands");
        JSONObject object=JSON.parseObject(brandJsonString);
        JSONArray brandJSONArray = JSON.parseArray(object.getString("data"));
        Iterator<Object> iterator = brandJSONArray.iterator();
        List<Brand> brandList = new ArrayList<Brand>();
        while(iterator.hasNext()){
            JSONObject obj = (JSONObject)iterator.next();
            Brand brand = new Brand();
            brand.setId(obj.getString("name"));
            brand.setName(obj.getString("name"));
            brandList.add(brand);
        }
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(brandList));
    }

    public void serieslist(){
       /* String brandJsonString = HttpUtils.sendGet(GlobalConfigUtil.get("mtype.remotehostport")+"/ewalker-web/controller/getSeriesList?brandName="+brandName);
        JSONArray brandJSONArray = JSON.parseArray(brandJsonString);
        Iterator<Object> iterator = brandJSONArray.iterator();
        List<Series> seriesList = new ArrayList<Series>();
        while(iterator.hasNext()){
            JSONObject obj = (JSONObject)iterator.next();
            Series series = new Series();
            series.setId(obj.getString("seriesName"));
            series.setName(obj.getString("seriesName"));

            seriesList.add(series);
        }
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(seriesList));*/

        String brandJsonString = HttpUtils.sendGet(GlobalConfigUtil.get("mtype.remotehostport")+"/api/v1/series?brand[name]="+brandName);
        JSONObject object=JSON.parseObject(brandJsonString);
        JSONArray brandJSONArray = JSON.parseArray(object.getString("data"));
        Iterator<Object> iterator = brandJSONArray.iterator();
        List<Series> seriesList = new ArrayList<Series>();

        while(iterator.hasNext()){
            JSONObject obj = (JSONObject)iterator.next();
            JSONArray newArray = JSON.parseArray(obj.getString("series"));
            System.out.println(newArray);
            Iterator<Object> newIterator=newArray.iterator();
            while(newIterator.hasNext()) {
                JSONObject newObj = (JSONObject) newIterator.next();
                Series series = new Series();
                series.setId(newObj.getString("name"));
                series.setName(newObj.getString("name"));

                seriesList.add(series);
            }
        }
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(seriesList));
    }
    public void modellist(){
       /* String brandJsonString = HttpUtils.sendGet(GlobalConfigUtil.get("mtype.remotehostport")+"/ewalker-web/controller/getModelList?seriesName="+seriesName+"&brandName="+brandName);
        JSONArray brandJSONArray = JSON.parseArray(brandJsonString);
        Iterator<Object> iterator = brandJSONArray.iterator();
        List<Model> modelList = new ArrayList<Model>();
        while(iterator.hasNext()){
            JSONObject obj = (JSONObject)iterator.next();
            Model model = new Model();
            model.setId(obj.getString("modelName"));
            model.setName(obj.getString("modelName"));
            modelList.add(model);
        }
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(modelList));*/


        String brandJsonString = HttpUtils.sendGet(GlobalConfigUtil.get("mtype.remotehostport")+"/api/v1/styles?series[name]="+seriesName+"&brand[name]="+brandName);
        JSONObject jsonObject=JSON.parseObject(brandJsonString);
        JSONArray brandJSONArray = JSON.parseArray(jsonObject.getString("data"));
        Iterator<Object> iterator = brandJSONArray.iterator();
        List<Model> modelList = new ArrayList<Model>();
        while(iterator.hasNext()){
            JSONObject newObj = (JSONObject)iterator.next();
            JSONArray modelArr=JSON.parseArray(newObj.getString("models"));
            Iterator<Object> newIterator = modelArr.iterator();
            while(newIterator.hasNext()) {
                JSONObject obj = (JSONObject) newIterator.next();
                Model model = new Model();
                model.setId(obj.getString("name"));
                model.setName(obj.getString("name"));
                modelList.add(model);
            }
        }
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(modelList));
    }


}
