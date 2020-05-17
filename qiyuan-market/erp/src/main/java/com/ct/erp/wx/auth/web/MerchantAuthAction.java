package com.ct.erp.wx.auth.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.struts2.action.CmmCoreAction;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.MerchantAuth;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.erp.wx.auth.service.MerchantAuthService;
import com.ct.erp.wx.util.WeixinUtil;
import com.ct.util.log.LogUtil;

import net.sf.json.JSONObject;

@Scope("prototype")
@Controller("list.merchantAuthAction")
public class MerchantAuthAction extends CmmCoreAction{
  
	private static final long serialVersionUID = 1L;

	@Autowired
    private MerchantAuthService merchantAuthService ;
	@Autowired
	private AgencyService agencyService;
	
	private Agency agency;
	
    
	 /**
	  *  判断是否微信openid授权
	  */
    public String existAuthByOpenid( ){
		HttpServletRequest request = super.contextPvd.getRequest();

    	String code = request.getParameter("code");
		// code不为空 证明此链接是从oauth跳转而来的
		if (StringUtils.isNotBlank(code)) {
			// 解析获得openid
			try {
				String openId = WeixinUtil.getOpenIdByCode(code);
				request.getSession().setAttribute("wxOpenid", openId); 
				//是否绑定授权
  			    boolean flag = merchantAuthService.existAuthByOpenid(openId);
//				MerchantAuth merchantAuth =	merchantAuthService.findAuthByOpenid(openId); 
				//已授权
				if(flag){ 
 					MerchantAuth merchantAuth =	merchantAuthService.findAuthByOpenid(openId);
					//商户信息存放session
					request.getSession().setAttribute(Const.WX_SESSION_AGENCY_USERINFO, merchantAuth);
					this.agency = this.agencyService.findById(merchantAuth.getAgencyId());
			      return "existAuthByOpenid";
			    }else{ 
			    	return "agencyAuth";
			    } 
			} catch (Exception e) { 
		    	LogUtil.logDebug(this.getClass(),e.toString()); 
			}  
		} 
		return null;
    }
    /**
     * 保存授权码
     * @return
     */
    public String saveAgencyAuth(){
    	JSONObject obj = new JSONObject();
		HttpServletResponse response = ServletActionContext.getResponse();
		HttpServletRequest request = super.contextPvd.getRequest();
    	String openid = (String)request.getSession().getAttribute("wxOpenid"); 
        String tel = request.getParameter("tel");	
        String authCode = request.getParameter("authCode");
        MerchantAuth entity= merchantAuthService.existAuthCode(authCode);  
        
		if(null != entity){ 
	    	entity.setOpenid(openid);
	    	entity.setState("1"); 
	    	entity.setTel(tel); 
	    	entity.setIsused("1");
	    	entity.setUpdateTime(UcmsWebUtils.now());
	    	MerchantAuth merchantAuth = merchantAuthService.save(entity); 
	    	if(null!=merchantAuth){  
	    		//商户信息存放session
	    		request.getSession().setAttribute(Const.WX_SESSION_AGENCY_USERINFO, merchantAuth); 
	    		obj.put("success", true);
	    		obj.put("msg", "授权成功"); 
	    	}else{ 
	    		obj.put("success", false);
				obj.put("msg", "授权失败,请联系系统管理员");
	    	}  
 		}else{ //授权码不存在或被占用或状态禁用
 			obj.put("success", false);
			obj.put("msg", "授权失败,请联系系统管理员");
		} 
		UcmsWebUtils.ajaxOutPut(response, obj.toString());
     	 
    	 return null ;
     }
	public Agency getAgency() {
		return agency;
	}
	public void setAgency(Agency agency) {
		this.agency = agency;
	}
 
    
}
