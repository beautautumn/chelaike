package com.ct.erp.rent.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import com.ct.erp.core.security.SecurityUtils;
import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.rent.model.ContractBean;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.rent.service.ContractAreaService;
import com.ct.erp.rent.service.ContractSignService;
import com.ct.erp.rent.service.SiteAreaService;
import com.ct.erp.util.UcmsWebUtils;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.contractSignAction")
public class ContractSignAction extends SimpleActionSupport {
	private static final Logger log = LoggerFactory.getLogger(ContractSignAction.class);
	
	private Long agencyId;
	private String currentSiteAreas;
	private ContractBean contractBean=new ContractBean();
	private List<ContractArea> contractAreas =new ArrayList<ContractArea>();
	private List<Agency> agencys=new ArrayList<Agency>();
	private List<SiteArea> siteAreas =new ArrayList<SiteArea>();
	private List<String> areaNos;
	private String areaNoAll;
	private Long picId;
 
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private SiteAreaService siteAreaService;
	@Autowired
	private ContractAreaService contractAreaService;
	@Autowired
	private ContractSignService contractSignService;
	
	public String toContractSignReg(){
		Long marketId = SecurityUtils.getCurrentSessionInfo().getMarketId();
		agencys=this.agencyService.findValidAgencyList(marketId);
		return "toContractSignReg";
	}
	
	public String contractSignReg() {
		HttpServletResponse response = ServletActionContext.getResponse();
		try
		{
			contractSignService.contractSignReg(contractBean,contractAreas,picId);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) 
		{
			log.error(e.getMessage());
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
		return null;
	}
		
		
	
	public String toSelectSiteArea(){
        Long marketId = SecurityUtils.getCurrentSessionInfo().getMarketId();
        siteAreas=this.contractSignService.getSiteAreaByMarket(marketId);
		areaNos=this.contractAreaService.findCurrentAreas();
		String areaNosString="";
		for(String areaNo:areaNos){
			areaNosString += areaNo+",";
		}
		if(areaNoAll==null||areaNoAll.trim().length()==0){
			areaNoAll = areaNosString;
		}else{
			areaNoAll += areaNosString;
		}
		return "toSelectSiteArea";
	}

	


	public Long getAgencyId() {
		return agencyId;
	}

	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}

	public ContractBean getContractBean() {
		return contractBean;
	}
	public void setContractBean(ContractBean contractBean) {
		this.contractBean = contractBean;
	}
	public List<SiteArea> getSiteAreas() {
		return siteAreas;
	}
	public void setSiteAreas(List<SiteArea> siteAreas) {
		this.siteAreas = siteAreas;
	}
	public String getAreaNoAll() {
		return areaNoAll;
	}
	public void setAreaNoAll(String areaNoAll) {
		this.areaNoAll = areaNoAll;
	}
	public SiteAreaService getSiteAreaService() {
		return siteAreaService;
	}
	public void setSiteAreaService(SiteAreaService siteAreaService) {
		this.siteAreaService = siteAreaService;
	}
	public ContractSignService getContractSignService() {
		return contractSignService;
	}
	public void setContractSignService(ContractSignService contractSignService) {
		this.contractSignService = contractSignService;
	}

	public List<ContractArea> getContractAreas() {
		return contractAreas;
	}

	public void setContractAreas(List<ContractArea> contractAreas) {
		this.contractAreas = contractAreas;
	}

	public List<String> getAreaNos() {
		return areaNos;
	}

	public void setAreaNos(List<String> areaNos) {
		this.areaNos = areaNos;
	}

	public List<Agency> getAgencys() {
		return agencys;
	}

	public void setAgencys(List<Agency> agencys) {
		this.agencys = agencys;
	}


	public String getCurrentSiteAreas() {
		return currentSiteAreas;
	}

	public void setCurrentSiteAreas(String currentSiteAreas) {
		this.currentSiteAreas = currentSiteAreas;
	}

	public Long getPicId() {
		return picId;
	}

	public void setPicId(Long picId) {
		this.picId = picId;
	}

	

	
	
	
	
	

	
	
	
}