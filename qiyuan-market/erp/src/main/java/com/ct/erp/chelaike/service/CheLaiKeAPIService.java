package com.ct.erp.chelaike.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.BooleanUtils;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.stereotype.Service;

import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.util.HttpUtils;

import net.sf.json.JSONObject;

@Service
public class CheLaiKeAPIService {
	
	/**
	 * 注册商户
	 * @param agency
	 */
	public void registUser(Agency agency){
		JSONObject json = JSONObject.fromObject(agency);
		String param = json.toString();
		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair("info", param));
		String res = HttpUtils.sendHttpPost(Const.CHELAIKE_REGISTUSER, params, "UTF-8");
		JSONObject obj = JSONObject.fromObject(res);
		Boolean success = false;
		if(obj.containsKey("success")){
			success = obj.getBoolean("success");
		}
		if(!BooleanUtils.isTrue(success)){
			String message = ""; 
			if(obj.containsKey("message")){
				message = obj.getString("message");
			}
			throw new RuntimeException(message);
		}
	}
}
