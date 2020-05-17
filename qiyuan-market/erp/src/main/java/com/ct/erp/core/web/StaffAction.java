package com.ct.erp.core.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.model.Result;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.struts2.action.CmmCoreAction;
import com.ct.erp.core.model.ComboboxDataBean;
import com.ct.erp.core.service.StaffService;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.util.json.JsonUtils;
import com.ct.util.log.LogUtil;


@Controller("core.staffAction")
public class StaffAction extends CmmCoreAction{

	private static final long serialVersionUID = 1L;

	@Autowired
	private StaffService staffService;
	
	@Autowired
	@Qualifier("core.staffService")
	private com.ct.erp.core.service.StaffService service;
	
	private List<Staff> staffList;
	
	private Integer roleCode;
	
	private String code;
	
	private Integer departId;
	
	private Short state=0;

	public void loadCombobox() {
		try {
			Map<String, Object> conditionMap = new HashMap<String, Object>();
			if(this.departId!=null){
				conditionMap.put("depart_id", this.departId);	
			}
			if(this.state!=null){
				conditionMap.put("state", this.state);
			}			
			List<ComboboxDataBean> beanList = this.service
					.findParamCombobox(conditionMap, this.code);
			String jsonStr = JsonUtils.toJSONStr(beanList);
			UcmsWebUtils
					.ajaxOutPut(super.contextPvd.getResponse(), jsonStr);
		} catch (ServiceException e) {
			Result result = new Result(e.getCode(), e.getMessage(), e.getObj());
			Struts2Utils.renderText(result);
			LogUtil.logError(StaffAction.class,
					"Error in method insuranceLoad:" + e.getMessage());
		}
	}


	public Integer getRoleCode() {
		return this.roleCode;
	}


	public void setRoleCode(Integer roleCode) {
		this.roleCode = roleCode;
	}


	public List<Staff> getStaffList() {
		return this.staffList;
	}


	public void setStaffList(List<Staff> staffList) {
		this.staffList = staffList;
	}

	public Integer getDepartId() {
		return this.departId;
	}

	public void setDepartId(Integer departId) {
		this.departId = departId;
	}

	

	public Short getState() {
		return this.state;
	}

	public void setState(Short state) {
		this.state = state;
	}

	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
	}
	
}