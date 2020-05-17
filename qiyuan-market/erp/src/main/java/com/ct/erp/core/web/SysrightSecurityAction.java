package com.ct.erp.core.web;

import java.util.List;

import org.springframework.stereotype.Controller;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.web.struts2.action.CmmCoreAction;
import com.ct.erp.constants.ReturnCodeConst;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.util.log.LogUtil;

@Controller("core.sysrightSecurityAction")
public class SysrightSecurityAction extends CmmCoreAction {

	private static final long serialVersionUID = 1L;

	private String rightCode;

	public void validateRightCode() {
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			List<Sysright> sysrightList = sessionInfo.getSysrightList();
			boolean permitTag = false;
			for (Sysright sys : sysrightList) {
				if (sys.getRightCode().equals(this.rightCode)) {
					permitTag = true;
					break;
				}
			}
			if (permitTag)
				UcmsWebUtils.ajaxOutPut(super.contextPvd.getResponse(),
						ReturnCodeConst.SUCCESS);
			else
				UcmsWebUtils.ajaxOutPut(super.contextPvd.getResponse(),
						ReturnCodeConst.NO_AUTH);
		} catch (ServiceException e) {
			UcmsWebUtils.ajaxOutPut(super.contextPvd.getResponse(),
					ReturnCodeConst.SYS_ERROR);
			LogUtil.logError(SysrightSecurityAction.class,
					"Error in method validateRightCode:" + e.getMessage());
		}
	}

	public String getRightCode() {
		return this.rightCode;
	}

	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}

	
}