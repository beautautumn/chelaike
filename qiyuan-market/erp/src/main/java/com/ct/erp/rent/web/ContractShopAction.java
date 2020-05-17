package com.ct.erp.rent.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.ContractShop;
import com.ct.erp.rent.model.ContractBean;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.rent.service.ContractShopService;
import com.ct.erp.util.UcmsWebUtils;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.contractShopAction")
public class ContractShopAction extends SimpleActionSupport{
	
	

}
