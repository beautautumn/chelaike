package com.ct.erp.wx.auth.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.MerchantAuth;

@Repository
public class MerchantAuthDao extends BaseDaoImpl<MerchantAuth>{
  
	public  MerchantAuth save(MerchantAuth entity){ 
		  return (MerchantAuth) this.update(entity) ;
	}
	
	
	/**
	 * 判断是否认证微信
	 * @param openid
	 * @return
	 */
	public List existOpenidAuth(String openid){
		    String hql=" from  MerchantAuth a where a.state= '1' and  a.openid=:openid";
		    Finder finder = Finder.create(hql);
			finder.setParam("openid", openid);
		    List<MerchantAuth> list =this.find(finder);
		    return list;
	}
	
	/**
	 * 判断是否存在录入的授权并且授权码未被占用,状态启用
	 * @param authCode
	 * @return
	 */
	public List existAuthCode(String authCode){
	    String hql=" from MerchantAuth a where  a.state= '1' and a.isused='0' and  a.authorzationCode=:authCode";
	    Finder finder = Finder.create(hql);
		finder.setParam("authCode", authCode); 
	    List<MerchantAuth> list =this.find(finder);
	    return list;
    }


	/**
	 * 根据openId查询
	 * @param openid
	 * @return
	 */
	public MerchantAuth findAuthByOpenid(String openid) {
		 String hql=" from  MerchantAuth a where a.state= '1' and  a.openid=:openid";
		    Finder finder = Finder.create(hql);
			finder.setParam("openid", openid);
		    List<MerchantAuth> list =this.find(finder);
		    if(list != null && list.size() > 0){
		    	return list.get(0);
		    }
		return null;
	}
	
	
}
