package com.ct.erp.access.web;

import net.sf.json.JSONObject;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;

@Scope("prototype")
@Controller("carin.AccessControl")
public class AccessControl extends SimpleActionSupport{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3671172518272833544L;
	
	private String info;
	
	public void accessInfo(){
		JSONObject obj = JSONObject.fromObject(info);
		int operType = obj.getInt("operType");
		String barCode = obj.getString("barCode");
		Long vehicleId;
		String operTime;
		String operDeviceId;
		switch (operType) {
		case 1:
			
			break;
		case 2:
			break;
		case 3:
			vehicleId = obj.getLong("vehicleId");
			operTime = obj.getString("operTime");
			operDeviceId = obj.getString("operDeviceId");
			break;
		case 4:
			vehicleId = obj.getLong("vehicleId");
			operTime = obj.getString("operTime");
			operDeviceId = obj.getString("operDeviceId");
			break;
		}
	}

	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}
	

}
