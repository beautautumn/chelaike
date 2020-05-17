package com.ct.erp.rent.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.model.Result;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.SiteShop;
import com.ct.erp.rent.dao.SiteShopDao;
import com.ct.erp.rent.service.SiteShopService;
import com.ct.erp.util.UcmsWebUtils;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.SiteShopAction")
public class SiteShopAction extends SimpleActionSupport{
	private static final Logger log = LoggerFactory.getLogger(SiteShopAction.class);
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -2637652424899218250L;

	@Autowired
	private SiteShopService siteShopService;
	@Autowired
	private SiteShopDao siteShopDao;
	
	private Long siteShopId;
	private SiteShop siteShop;
	private List<SiteShop> siteShops = new ArrayList<SiteShop>();
	private List<String> shopNos = new ArrayList<String>();
	private String currentSiteShops;
	private String shopNoAll;
	
	public String toAdd(){
		return "site_shop_add";
	}
	
	public String toUpdate(){
		this.siteShop = this.siteShopDao.get(this.siteShopId);
		return "site_shop_add";
	}
	
	
	//新增or修改区域商铺
	public String add(){
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try{
			SiteShop siteShop;
			if(this.siteShop.getId()==null){
				this.siteShop.setFreeCount(this.siteShop.getTotalCount());
				this.siteShop.setCreateTime(UcmsWebUtils.now());
				this.siteShop.setValidTag("1");
				siteShop = this.siteShop;
				siteShop.setMonthRentFee(this.siteShop.getMonthRentFee()*100);
				siteShop.setUpdateTime(UcmsWebUtils.now());
				this.siteShopService.saveSiteShop(siteShop);
			}else{
				siteShop = this.siteShopDao.get(this.siteShop.getId());
				siteShop.setAreaName(this.siteShop.getAreaName());
				siteShop.setTotalCount(this.siteShop.getTotalCount());
				siteShop.setMonthRentFee(this.siteShop.getMonthRentFee()*100);
				siteShop.setRemark(this.siteShop.getRemark());
				siteShop.setFreeCount(siteShop.getFreeCount()+this.siteShop.getTotalCount()-this.siteShop.getTotalCount());
				siteShop.setUpdateTime(UcmsWebUtils.now());
				this.siteShopService.updateSiteShop(siteShop);
			}
			UcmsWebUtils.ajaxOutPut(response, "success");
		}catch (Exception e) {
			e.printStackTrace();
			log.error("error", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
		return null;
	}
	
	public String toAddSiteShop(){
		siteShops=this.siteShopService.getSiteArea(currentSiteShops);
		shopNos=this.siteShopService.findCurrentAreas();
		String shopNosString="";
		for(String shopNo:shopNos){
			shopNosString += shopNo+",";
		}
		if(shopNoAll==null||shopNoAll.trim().length()==0){
			shopNoAll = shopNosString;
		}else{
			shopNoAll += shopNosString;
		}
		return "toAddSiteShop";
	}
	
	//删除区域商铺
	public void delete() throws Exception{
		Result result  =null;
		try {
			boolean b = siteShopService.hasContract(siteShopId);
			if (b)
			{
			   result = new Result(Result.ERROR, "该区域已有商户入驻,不能删除!", null);
			}
			else
			{
			   this.siteShopService.delete(this.siteShopId);
			   result = new Result(Result.SUCCESS, "操作成功!", null);
			}
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			log.error("SiteAreaAction.delete>>",e);
			result = new Result(Result.ERROR, "操作失败!", null);
			Struts2Utils.renderJson(result);
			
		}
	}

	public Long getSiteShopId() {
		return siteShopId;
	}

	public void setSiteShopId(Long siteShopId) {
		this.siteShopId = siteShopId;
	}

	public SiteShop getSiteShop() {
		return siteShop;
	}

	public void setSiteShop(SiteShop siteShop) {
		this.siteShop = siteShop;
	}

	public List<SiteShop> getSiteShops() {
		return siteShops;
	}

	public void setSiteShops(List<SiteShop> siteShops) {
		this.siteShops = siteShops;
	}

	public List<String> getShopNos() {
		return shopNos;
	}

	public void setShopNos(List<String> shopNos) {
		this.shopNos = shopNos;
	}

	public String getShopNoAll() {
		return shopNoAll;
	}

	public void setShopNoAll(String shopNoAll) {
		this.shopNoAll = shopNoAll;
	}

}
