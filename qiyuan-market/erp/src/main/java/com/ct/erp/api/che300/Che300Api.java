package com.ct.erp.api.che300;

import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.ct.erp.api.ApiCallException;
import com.ct.erp.common.utils.GlobalConfigUtil;
import com.ct.erp.util.HttpUtils;
import com.google.gson.Gson;
import com.google.gson.JsonParseException;

/**
 * Created by jf on 15/6/8.
 */
public class Che300Api {

    private static final String token = GlobalConfigUtil.get("che300.token");

    private static final String url = GlobalConfigUtil.get("che300.url");

    private static final String GET_CAR_BRAND_LIST = "getCarBrandList";
    private static final String GET_CAR_SERIES_LIST = "getCarSeriesList";
    private static final String GET_CAR_MODEL_LIST = "getCarModelList";

    private static final String GET_USED_CAR_PRICE = "getUsedCarPrice";
    
    /**
     * 车型识别
     */
    private static final String GET_IDENTIFY_MODEL = "identifyModel";

    /**
     * 获取所有车辆品牌列表
     * @return
     * @throws ApiCallException
     */
    public static List<Che300Brand> getBrand() throws ApiCallException {
        try {
            String s = HttpUtils.sendGet(url + "?oper=" + GET_CAR_BRAND_LIST + "&token=" + token);
            if (StringUtils.isNotBlank(s)) {
                Gson gson = new Gson();
                Che300BrandWrapper che300BrandWrapper = gson.fromJson(s, Che300BrandWrapper.class);
                if (che300BrandWrapper != null && che300BrandWrapper.getStatus().equals("1")) {
                    return che300BrandWrapper.getBrand_list();
                } else {
                    throw new ApiCallException("call che300 api getCarBrandList , return error");
                }
            } else {
                throw new ApiCallException("call che300 api getCarBrandList , return blank");
            }
        } catch (Exception e) {
            throw new ApiCallException("call che300 api " + GET_CAR_BRAND_LIST + " error", e);
        }
    }

    /**
     * 根据品牌编码获取车系列表
     * @param brandId
     * @return
     * @throws ApiCallException
     */
    public static List<Che300Series> getSeries(int brandId) throws ApiCallException {
        try {
            String s = HttpUtils.sendGet(url + "?oper=" + GET_CAR_SERIES_LIST + "&token=" + token + "&brandId=" + brandId);
            if (StringUtils.isNotBlank(s)) {
                Gson gson = new Gson();
                Che300SeriesWrapper che300SeriesWrapper = gson.fromJson(s, Che300SeriesWrapper.class);
                if (che300SeriesWrapper != null && che300SeriesWrapper.getStatus().equals("1")) {
                    return che300SeriesWrapper.getSeries_list();
                } else {
                    throw new ApiCallException("call che300 api " + GET_CAR_SERIES_LIST + " , return error");
                }
            } else {
                throw new ApiCallException("call che300 api " + GET_CAR_SERIES_LIST + " , return blank");
            }
        } catch (Exception e) {
            throw new ApiCallException("call che300 api " + GET_CAR_SERIES_LIST + " error", e);
        }
    }

    /**
     * 根据车系编码获取车型列表
     * @param seriesId
     * @return
     * @throws ApiCallException
     */
    public static List<Che300Model> getModel(int seriesId) throws ApiCallException {
        try {
            String s = HttpUtils.sendGet(url + "?oper=" + GET_CAR_MODEL_LIST + "&token=" + token + "&seriesId=" + seriesId);
            if (StringUtils.isNotBlank(s)) {
                Gson gson = new Gson();
                Che300ModelWrapper che300ModelWrapper = gson.fromJson(s, Che300ModelWrapper.class);
                if (che300ModelWrapper != null && che300ModelWrapper.getStatus().equals("1")) {
                    return che300ModelWrapper.getModel_list();
                } else {
                    throw new ApiCallException("call che300 api " + GET_CAR_MODEL_LIST + " , return error");
                }
            } else {
                throw new ApiCallException("call che300 api " + GET_CAR_MODEL_LIST + " , return blank");
            }
        } catch (Exception e) {
            throw new ApiCallException("call che300 api " + GET_CAR_MODEL_LIST + " error", e);
        }
    }

    /**
     * 评估
     * @param modelId 车型
     * @param regDate 待估车辆的上牌时间（格式：yyyy-MM）。
     * @param mile 待估车辆的公里数，单位万公里
     * @param zone che300的区域编码
     * @param title 待估车辆的标题信息 可选参数。
     * @param price 待估车辆在贵网站上面的卖价（不是指导价，是用户标的价格），可选参数。
     * @return
     * @throws ApiCallException
     */
    public static UsedCarPrice getUsedCarPrice(int modelId, String regDate, double mile, int zone, String title, Double price) throws ApiCallException {
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
            if (StringUtils.isNotBlank(s)) {
                Gson gson = new Gson();
                UsedCarPrice usedCarPrice = gson.fromJson(s, UsedCarPrice.class);
                if (usedCarPrice != null && usedCarPrice.getStatus().equals("1")) {
                    return usedCarPrice;
                } else {
                    ApiError apiError = gson.fromJson(s, ApiError.class);
                    throw new ApiCallException(apiError.getError_msg());
                }
            } else {
                throw new ApiCallException("call che300 api " + GET_USED_CAR_PRICE + " , return blank");
            }
        } catch (JsonParseException ex) {
            Gson gson = new Gson();
            ApiError apiError = gson.fromJson(s, ApiError.class);
            throw new ApiCallException(apiError.getError_msg());
        } catch (Exception e) {
            throw new ApiCallException("call che300 api " + GET_USED_CAR_PRICE + " error", e);
        }
    }

    /**
     * 车型识别
     * @param brand 品牌名称，是合作伙伴所使用的品牌名称，如：雪佛兰。
     * @param series 车系名称，是合作伙伴所使用的车系名称，如：赛欧三厢。
     * @param model 车型名称，是合作伙伴所使用的车型名称，如：1.4L MT 幸福版。
     * @param modelYear 车型年款，是指定车型的年款，如：2011。
     * @param modelPrice 新车指导价，可选参数，最好提供可以增加识别的成功几率和准确性，如：7.23。
     * @throws ApiCallException 
     */
    public static IdentifyModel identifyModel(String brand, String series, String model, String modelYear, Double modelPrice) throws ApiCallException{
    	String s = null;
        try {
            String param = "oper=" + GET_IDENTIFY_MODEL + "&token=" + token + "&brand=" + brand + "&series=" + series + "&model=" + model + "&modelYear=" + modelYear;;
            s = HttpUtils.sendPost(url, param, "UTF-8");
            if (StringUtils.isNotBlank(s)) {
                Gson gson = new Gson();
                IdentifyModel identifyModel = gson.fromJson(s, IdentifyModel.class);
                if (identifyModel != null && identifyModel.getStatus().equals("1")) {
                    return identifyModel;
                } else {
                    ApiError apiError = gson.fromJson(s, ApiError.class);
                    throw new ApiCallException(apiError.getError_msg());
                }
            } else {
                throw new ApiCallException("call che300 api " + GET_IDENTIFY_MODEL + " , return blank");
            }
        } catch (JsonParseException ex) {
            Gson gson = new Gson();
            ApiError apiError = gson.fromJson(s, ApiError.class);
            throw new ApiCallException(apiError.getError_msg());
        } catch (Exception e) {
            throw new ApiCallException("call che300 api " + GET_IDENTIFY_MODEL + " error", e);
        }
    }
    
}
