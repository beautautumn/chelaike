package com.ct.erp.core.web;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.model.InterfaceRes;
import com.ct.erp.common.web.struts2.action.CmmCoreAction;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.core.service.OperHisService;
import com.ct.erp.core.service.StaffService;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Sysright;

@Controller("core.operHisAction")
public class OperHisAction extends CmmCoreAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Autowired
	@Qualifier("core.operHisService")
	private OperHisService operHisService;

	@Autowired
	@Qualifier("core.staffService")
	private StaffService staffService;

	public String toOperHisList() {
		try {

			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();

			List<Sysright> sysrightList = sessionInfo.getSysrightList();

			List<OperHis> deleteHisList = new ArrayList<OperHis>();
			this.operHisList = this.operHisService.findHisListByObjIdAndTag(
					this.objectId, this.tag);
			for (OperHis his : this.operHisList) {
				// 需要权限显示验证
				// if(his.getSysright().getShowAuth()!=null
				// &&his.getSysright().getShowAuth()==1){
				// boolean delTag=true;
				// for(Sysright sysright:sysrightList){
				// if(his.getSysright().getRightCode().equals(sysright.getRightCode())){
				// delTag=false;
				// break;
				// }
				// }
				// if(delTag){
				// deleteHisList.add(his);
				// }
				// }
			}
			if (deleteHisList.size() > 0) {
				this.operHisList.removeAll(deleteHisList);
			}
		} catch (Exception e) {
			com.ct.util.log.LogUtil.logError(this.getClass(),
					"Error in method toOperHis", e);
		}
		return "oper_his_list";
	}


	private InterfaceRes getInterfaceRes(String code, String desc, String type) {
		InterfaceRes res = new InterfaceRes();
		res.setCode(code);
		res.setDesc(desc);
		res.setProcsTime(String.valueOf(System.currentTimeMillis() / 1000));
		res.setType(type);
		return res;
	}

	private String operDesc;

	private String rightCode;

	private Long staffId;

	private Short tag;

	private Long objectId;

	private List<OperHis> operHisList;

	public Short getTag() {
		return this.tag;
	}

	public void setTag(Short tag) {
		this.tag = tag;
	}

	public String getOperDesc() {
		return this.operDesc;
	}

	public void setOperDesc(String operDesc) {
		this.operDesc = operDesc;
	}

	public String getRightCode() {
		return this.rightCode;
	}

	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}

	public Long getStaffId() {
		return this.staffId;
	}

	public void setStaffId(Long staffId) {
		this.staffId = staffId;
	}

	public Long getObjectId() {
		return this.objectId;
	}

	public void setObjectId(Long objectId) {
		this.objectId = objectId;
	}

	public List<OperHis> getOperHisList() {
		return this.operHisList;
	}

	public void setOperHisList(List<OperHis> operHisList) {
		this.operHisList = operHisList;
	}

}
