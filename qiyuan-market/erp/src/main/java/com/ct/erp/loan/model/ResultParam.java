package com.ct.erp.loan.model;

import java.util.ArrayList;
import java.util.List;

import com.ct.erp.api.che300.Che300Brand;
import com.ct.erp.api.che300.Che300Model;
import com.ct.erp.api.che300.Che300Series;
import com.ct.erp.api.che300.UsedCarPrice;

public class ResultParam {
	List<Che300Brand> brandList = new ArrayList<Che300Brand>();
	List<Che300Series> seriesList = new ArrayList<Che300Series>();
	List<Che300Model> modelList = new ArrayList<Che300Model>();
	UsedCarPrice usedCarPrice = new UsedCarPrice();
	String resultCode; //0000成功    0001失败
	public List<Che300Brand> getBrandList() {
		return brandList;
	}
	public void setBrandList(List<Che300Brand> brandList) {
		this.brandList = brandList;
	}
	public List<Che300Series> getSeriesList() {
		return seriesList;
	}
	public void setSeriesList(List<Che300Series> seriesList) {
		this.seriesList = seriesList;
	}
	public List<Che300Model> getModelList() {
		return modelList;
	}
	public void setModelList(List<Che300Model> modelList) {
		this.modelList = modelList;
	}
	public String getResultCode() {
		return resultCode;
	}
	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}
	public UsedCarPrice getUsedCarPrice() {
		return usedCarPrice;
	}
	public void setUsedCarPrice(UsedCarPrice usedCarPrice) {
		this.usedCarPrice = usedCarPrice;
	}
	

}
