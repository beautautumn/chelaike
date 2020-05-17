package com.ct.erp.rent.web;

import java.io.PrintWriter;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Market;
import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.model.Result;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.loan.web.LoanEvalAction;
import com.ct.erp.rent.model.SiteAreaBean;
import com.ct.erp.rent.service.SiteAreaService;
import com.ct.erp.util.UcmsWebUtils;

@Scope("prototype")
@Controller("rent.SiteAreaAction")
public class SiteAreaAction extends SimpleActionSupport {
	private static final Logger log = LoggerFactory.getLogger(LoanEvalAction.class);
	private static final long serialVersionUID = 3636934746937027213L;
	
	private SiteArea siteArea;
	private Integer unitTotalCount;
	private Integer unitMonthRentFee;
	private Long siteAreaId;
	private SiteAreaBean siteAreaBean;
	private Long marketId;

	@Autowired
	private SiteAreaService siteAreaService;
	public String view(){
		return null;
	}

	public String toAdd(){
		return "site_area_add";
	}
	
	public String toUpdate(){
		if(this.siteAreaId==null){
			return null;
		}else{
			this.siteArea = this.siteAreaService.findById(this.siteAreaId);
			return "site_area_update";
		}
	}
	
	public String update(){
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		if(siteArea==null){
			return null;
		}else{
			try{
				out = response.getWriter();
				this.siteAreaService.update(this.siteArea,this.siteAreaBean,this.siteAreaId);
				out.print("success");
				out.close();
			}catch (ServiceException e) {
		        UcmsWebUtils.ajaxOutPut(response, e.getMessage());
			}catch (Exception e) {
				e.printStackTrace();
				out.print("error");
			}finally{
				if(out != null){
					out.close();
				}
			}
		}
		return null;
	}

	public String add(){
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try{
			out = response.getWriter();
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			Long marketId = sessionInfo.getMarketId();
//			Market market = new Market();
//			market.setMarketId(marketId);
//			this.siteArea.setMarket(market);
			this.siteArea.setMarketId(marketId);
			this.siteAreaService.save(this.siteArea,this.siteAreaBean);
			out.print("success");
			out.close();
		}catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		return null;
	}
	
	public void delete() throws Exception{
		Result result  =null;
		try {
			boolean b = siteAreaService.hasContract(siteAreaId);
			if (b)
			{
			   result = new Result(Result.ERROR, "该区域已有商户入驻,不能删除!", null);
			}
			else
			{
			   this.siteAreaService.delete(this.siteAreaId);
			   result = new Result(Result.SUCCESS, "操作成功!", null);
			}
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			log.error("SiteAreaAction.delete>>",e);
			result = new Result(Result.ERROR, "操作失败!", null);
			Struts2Utils.renderJson(result);
			
		}
	}
	
	public SiteArea getSiteArea() {
		return siteArea;
	}

	public void setSiteArea(SiteArea siteArea) {
		this.siteArea = siteArea;
	}
	
	public Integer getUnitTotalCount() {
		return unitTotalCount;
	}

	public void setUnitTotalCount(Integer unitTotalCount) {
		this.unitTotalCount = unitTotalCount;
	}

	public Integer getUnitMonthRentFee() {
		return unitMonthRentFee;
	}

	public void setUnitMonthRentFee(Integer unitMonthRentFee) {
		this.unitMonthRentFee = unitMonthRentFee;
	}

	public SiteAreaService getSiteAreaService() {
		return siteAreaService;
	}

	public void setSiteAreaService(SiteAreaService siteAreaService) {
		this.siteAreaService = siteAreaService;
	}

	public Long getSiteAreaId() {
		return siteAreaId;
	}

	public void setSiteAreaId(Long siteAreaId) {
		this.siteAreaId = siteAreaId;
	}

	public SiteAreaBean getSiteAreaBean() {
		return siteAreaBean;
	}

	public void setSiteAreaBean(SiteAreaBean siteAreaBean) {
		this.siteAreaBean = siteAreaBean;
	}

	public Long getMarketId() {
		return marketId;
	}

	public void setMarketId(Long marketId) {
		this.marketId = marketId;
	}

	public void listAreaByMarket(){
        List<SiteArea> result = this.siteAreaService.listByMarketId(this.marketId);
        List<Map<String,String>> jsonResult = new ArrayList<Map<String, String>>();
        if(result != null){
            for(SiteArea area :result){
                Map<String, String> res = new HashMap<String, String>();
                res.put("id", area.getId().toString());
                res.put("name", area.getAreaName());
                jsonResult.add(res);
            }
        }
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(jsonResult));
    }
}