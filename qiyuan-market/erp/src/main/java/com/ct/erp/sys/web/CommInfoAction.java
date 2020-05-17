package com.ct.erp.sys.web;

import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.struts2.action.CmmCoreAction;
import com.ct.erp.sys.service.CommService;
import com.ct.erp.util.UcmsWebUtils;


@Scope("prototype")
@Controller("sys.commInfoAction")
public class CommInfoAction extends CmmCoreAction {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1875381480894513560L;
    private static Logger log = Logger.getLogger("CommInfoAction");

	@Autowired
	private CommService commSerice;
	private Long seriesId;
	private Long brandId;


	public void getBrandList(){
	   HttpServletResponse response = Struts2Utils.getResponse();
       try{
         String str = commSerice.getBrandList();
         UcmsWebUtils.ajaxOutPut(response, str);
       }catch(Exception e){
    	   log.error("getBrandList",e);  
       }
	}
	
	public void getAgencyList(){
		HttpServletResponse response = Struts2Utils.getResponse();
		try{
			String str = commSerice.getAgencyList();
			UcmsWebUtils.ajaxOutPut(response, str);
		}catch ( Exception e ){
			log.error("getAgencyList",e);
		}
	}
	
	
	public void getSeriesList(){
	   HttpServletResponse response = Struts2Utils.getResponse();
       try{
         String str = commSerice.getSeriesList(brandId);
         UcmsWebUtils.ajaxOutPut(response, str);
       }catch(Exception e){
    	   log.error("getSeriesList",e);  
       }			
	}
	
	public void getKindList(){
	   HttpServletResponse response = Struts2Utils.getResponse();
       try{
         String str = commSerice.getKindList(seriesId);
         UcmsWebUtils.ajaxOutPut(response, str);
       }catch(Exception e){
    	   log.error("getKindList",e);  
       }		
	}


	
	public void setSeriesId(Long seriesId) {
		this.seriesId = seriesId;
	}


	public Long getSeriesId() {
		return seriesId;
	}

	public Long getBrandId() {
		return brandId;
	}


	public void setBrandId(Long brandId) {
		this.brandId = brandId;
	}
}
