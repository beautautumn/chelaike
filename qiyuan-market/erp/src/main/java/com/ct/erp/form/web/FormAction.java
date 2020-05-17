package com.ct.erp.form.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.carin.web.VehicleAction;
import com.ct.erp.common.web.SimpleActionSupport;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("form.formAction")
public class FormAction extends SimpleActionSupport{
	private static final Logger log = LoggerFactory
			.getLogger(VehicleAction.class);
	private String res;
	
	public String returnForm(){
		if(this.res.equals("0")){
			return "salesVolume";
		}
		if(this.res.equals("1")){
			return "auctionVehicle";
		}
		if(this.res.equals("2")){
			return "corpVehiclePer";
		}
		if(this.res.equals("3")){
			return "corpParkPer";
		}
		if(this.res.equals("4")){
			return "auctionSale";
		}
		return null;
	}


	public String getRes() {
		return res;
	}

	public void setRes(String res) {
		this.res = res;
	}

}
