package com.ct.erp.wx.util;

import com.alibaba.fastjson.JSON;
import com.ct.erp.constants.sysconst.Const;

 
public class WeixinUtil {
	
	/**
	 * code 获取公众号对应的微信用户openid
	 * @param code
	 * @return
	 * @throws Exception
	 */
	public static String getOpenIdByCode(String code) throws Exception {
		StringBuilder url = new StringBuilder("");
		url.append("https://api.weixin.qq.com/sns/oauth2/access_token?");
		url.append("appid=").append(Const.APPID);
		url.append("&secret=").append(Const.SECRET);
		url.append("&code=").append(code);
		url.append("&grant_type=authorization_code");
		// https
		String rsp = HttpsAccessUtil.httpsRequest(url.toString(), "GET", "");
		// 解析获得openid
		String openId = JSON.parseObject(rsp, OauthRspBean.class).getOpenid();
		return openId;
	}
	
}
