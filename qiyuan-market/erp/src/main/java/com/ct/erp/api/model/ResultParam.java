package com.ct.erp.api.model;

import java.util.ArrayList;
import java.util.List;


public class ResultParam {
	private TradeBean trade;
	private VehicleBean vehicle;
	private List<VehiclePicBean> vehiclePicList = new ArrayList<VehiclePicBean>();
	public TradeBean getTrade() {
		return trade;
	}
	public void setTrade(TradeBean trade) {
		this.trade = trade;
	}
	public VehicleBean getVehicle() {
		return vehicle;
	}
	public void setVehicle(VehicleBean vehicle) {
		this.vehicle = vehicle;
	}
	public List<VehiclePicBean> getVehiclePicList() {
		return vehiclePicList;
	}
	public void setVehiclePicList(List<VehiclePicBean> vehiclePicList) {
		this.vehiclePicList = vehiclePicList;
	}
	
}
