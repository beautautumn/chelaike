package com.ct.erp.sys.service;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import net.sf.json.JSONObject;

import com.ct.erp.sys.model.MapLocateBean;
import com.ct.erp.util.HttpUtils;

@Service
public class MapService {

	public static final String BAIDU_MAP_URL="http://api.map.baidu.com/geocoder?output=json&key=KEY&city=CITY&address=ADDRESS";
	
	public static final String KEY="dtKHw89n9CAbG8EorQAIMHPx";
		
	/**
	 * 百度地图根据城市、地址、街道查询位置
	 * @param city
	 * @param address
	 * @param street
	 * @return
	 */
	public MapLocateBean findLocation(String city,String address,String street){
		String url=BAIDU_MAP_URL;
	    url=url.replaceFirst("KEY", KEY);
		if(StringUtils.isNotBlank(city)){
			url=url.replaceFirst("CITY", city);
		}
		if(StringUtils.isNotBlank(address)){
			url=url.replaceFirst("ADDRESS", address);
		}else if(StringUtils.isNotBlank(street)){
			url=url.replaceFirst("ADDRESS", street);
		}
		try {
			return doHandleLocation(url,street);	
		} catch (Exception e) {
			url=BAIDU_MAP_URL;
			url=url.replaceFirst("KEY", KEY);
			if(StringUtils.isNotBlank(city)){
				url=url.replaceFirst("CITY", city);
			}
			if(StringUtils.isNotBlank(street)){
				url=url.replaceFirst("ADDRESS", street);
			}else{
				url=url.replaceFirst("ADDRESS", city);
			}
			try {
				return doHandleLocation(url,street);	
			} catch (Exception e2) {
				//忽视异常
				return null;
			}
			
		}	
	}
	
	private MapLocateBean doHandleLocation(String url,String street)throws Exception{
		MapLocateBean locate=new MapLocateBean();
		String result=HttpUtils.sendGet(url);
		JSONObject j=JSONObject.fromObject(result);
		String res=j.get("status").toString();
		if("OK".equals(res)){
			try {
				JSONObject zb=j.getJSONObject("result");
				JSONObject local=zb.getJSONObject("location");
				locate.setLng(local.getString("lng"));
				locate.setLat(local.getString("lat"));
			} catch (Exception ee) {
				throw ee;
			}
		}	
		return locate;
	}
}
