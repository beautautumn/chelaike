package com.ct.erp.list.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.model.FlexiGridPageInfo;
import com.ct.erp.common.model.Pagination;
import com.ct.erp.common.utils.FlexiGridPageInfoUtil;
import com.ct.erp.common.web.struts2.action.CmmCoreAction;
import com.ct.erp.lib.entity.Staff;

@Scope("prototype")
@Controller("list.pagerAction")
public class PagerAction extends CmmCoreAction {

	@Autowired
	@Qualifier("core.staffService")
	private com.ct.erp.core.service.StaffService service;
	
	private FlexiGridPageInfo info;
	
	private List<Staff> staffList;
	
	
	public String list(){
		info=FlexiGridPageInfoUtil.getPaginationInfo(super.contextPvd.getRequest());
		Pagination pagination=service.findByPager(info.getPage(), info.getRp());
		staffList=pagination.getList();
		info.setTotal(pagination.getTotalCount());
		return "nav";
	}

	public FlexiGridPageInfo getInfo() {
		return info;
	}

	public void setInfo(FlexiGridPageInfo info) {
		this.info = info;
	}

	public List<Staff> getStaffList() {
		return staffList;
	}

	public void setStaffList(List<Staff> staffList) {
		this.staffList = staffList;
	}

	
	
}
