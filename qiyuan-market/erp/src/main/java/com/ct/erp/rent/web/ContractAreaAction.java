package com.ct.erp.rent.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.rent.service.ContractAreaService;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.contractAreaAction")
public class ContractAreaAction extends SimpleActionSupport {
	
	private ContractArea coonstractArea;
	@Autowired
	private ContractAreaService contractAreaService;

	public ContractAreaService getContractAreaService() {
		return contractAreaService;
	}
	public void setContractAreaService(ContractAreaService contractAreaService) {
		this.contractAreaService = contractAreaService;
	}
	public ContractArea getCoonstractArea() {
		return coonstractArea;
	}
	public void setCoonstractArea(ContractArea coonstractArea) {
		this.coonstractArea = coonstractArea;
	}
	
	
}
