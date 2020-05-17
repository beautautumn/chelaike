package com.ct.erp.sys.web;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.cloudtrend.erprocks.util.LogUtil;
import com.ct.erp.common.model.Result;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.constants.ReturnCodeConst;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("sys.sysParamAction")
public class SysParamAction extends SimpleActionSupport {

	@Autowired
	private StaffService staffService;

	private Staff staff;

	// end
	public String tab() throws Exception {
		try {
			return "param-tab";
		} catch (Exception e) {
			throw e;
		}
	}

	public String view() throws Exception {
		try {
			if (this.id != null) {
				this.staff = this.staffService.findStaffById(this.id);
			}
			return "staff-view";
		} catch (Exception e) {
			throw e;
		}
	}

	public void detail() throws Exception {
		try {

		} catch (Exception e) {
			throw e;
		}
	}

	public void save() throws Exception {
		try {
			try {
				// SessionInfo sessionInfo =
				// SecurityUtils.getCurrentSessionInfo();
				this.staffService.saveStaff(this.staff);
				Result result = new Result(Result.SUCCESS, "员工操作成功!", null);
				Struts2Utils.renderJson(result);
			} catch (Exception e) {
				throw e;
			}

		} catch (Exception e) {
			throw e;
		}
	}

	// 2014-05-20
	public String toStockWarningConf() {
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		return "toStockWarningConf";
	}

	public String doStockWarningConf() {
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		String result = "";
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
		} catch (Exception e) {
			result = ReturnCodeConst.SYS_ERROR;
			LogUtil.logError(this.getClass(),
					"error in sysParamAction.doStockWarningConf method", e);
		}
		UcmsWebUtils.ajaxOutPut(response, result);
		return "toStockWarningConf";
	}

	// end
	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}


}
