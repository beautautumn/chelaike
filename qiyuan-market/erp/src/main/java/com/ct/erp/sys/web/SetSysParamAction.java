package com.ct.erp.sys.web;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.Params;
import com.ct.erp.sys.model.ParamsBean;
import com.ct.erp.sys.service.SetSysParamService;
import com.ct.erp.util.UcmsWebUtils;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("sys.setSysParamAction")
public class SetSysParamAction extends SimpleActionSupport {
	
	
	@Autowired
	private SetSysParamService setSysParamService;
	
	private Long paramId;
	
	private Params params;
	
	private ParamsBean paramsBean = new ParamsBean();
	
	public String saveParams(){
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
				this.setSysParamService.saveParams(params);
				
				UcmsWebUtils.ajaxOutPut(response, "success");
			} catch (Exception e) {
				e.printStackTrace();
				UcmsWebUtils.ajaxOutPut(response, "error");
			}
			return null;
	}
	
	public String toUpdateParams(){
		
			params=this.setSysParamService.findParams(paramId);
				
			
			return "toUpdateParams";
	}
	
	public String updateParams(){
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
				this.setSysParamService.updateParams(paramsBean);
				
				UcmsWebUtils.ajaxOutPut(response, "success");
			} catch (Exception e) {
				e.printStackTrace();
				UcmsWebUtils.ajaxOutPut(response, "error");
			}
			return null;
	}
	
	public String deleteParams(){
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
				this.setSysParamService.deleteParams(paramId);
				
				UcmsWebUtils.ajaxOutPut(response, "success");
			} catch (Exception e) {
				e.printStackTrace();
				UcmsWebUtils.ajaxOutPut(response, "error");
			}
			return null;
	}

	

	public Long getParamId() {
		return paramId;
	}

	public void setParamId(Long paramId) {
		this.paramId = paramId;
	}

	public ParamsBean getParamsBean() {
		return paramsBean;
	}

	public void setParamsBean(ParamsBean paramsBean) {
		this.paramsBean = paramsBean;
	}

	public Params getParams() {
		return params;
	}

	public void setParams(Params params) {
		this.params = params;
	}
	

}
