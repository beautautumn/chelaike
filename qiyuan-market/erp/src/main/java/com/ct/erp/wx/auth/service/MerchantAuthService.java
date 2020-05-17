package com.ct.erp.wx.auth.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.lib.entity.MerchantAuth;
import com.ct.erp.wx.auth.dao.MerchantAuthDao;

@Service
public class MerchantAuthService {
	   @Autowired
	   private MerchantAuthDao merchantAuthDao;
		
	   @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
      public  MerchantAuth save(MerchantAuth entity){ 
		   return merchantAuthDao.save(entity);
	   }
	  /**
	   * 判断是否授权
	   * @param openid
	   * @return
	   */ 
	   public boolean existAuthByOpenid(String openid)
	   {
		   List  list=  merchantAuthDao.existOpenidAuth(openid);
		   if(list.size()>0){
			   return true;
		   }else{
			   return false;			   
		   }
	   }
	   
	   /**
	    * 根据openId查询
	    * @param openid
	    * @return
	    */ 
	   public MerchantAuth findAuthByOpenid(String openid)
	   {
		   return merchantAuthDao.findAuthByOpenid(openid);
	   }
	 
	   /**
	    * 授权码是否存在
	    * @param code
	    * @return
	    */
	   public MerchantAuth existAuthCode(String code)
	   {
		   List<MerchantAuth>  list=  merchantAuthDao.existAuthCode(code);
		   if(list.size()>0)
			   return list.get(0) ;
		   return null ;
	   }
}
