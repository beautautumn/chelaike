package com.ct.erp.sys.web;

import java.util.*;

import com.ct.erp.lib.entity.Market;
import com.ct.erp.market.service.MarketService;
import com.ct.erp.util.DataSync;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.model.Result;
import com.ct.erp.common.model.TreeNode;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.model.ComboboxDataBean;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.sys.model.StatusState;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.sys.service.base.SysrightService;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("sys.staffAction")
public class StaffAction extends SimpleActionSupport {

	private static final long serialVersionUID = 3955786343455698369L;

	@Autowired
	private StaffService staffService;

	@Autowired
	private MarketService marketService;

	@Autowired
	SysrightService sysrightService;

	@Autowired
	private DataSync dataSync;

	private Staff staff;
	private String funcTreeStr;
	private String firstLevelFun;
	private String functionid;
	private String loginName;
	private List<ComboboxDataBean> locateList;
	private String locateId;
	private List<Market> markets = new ArrayList<Market>();
	private Market market;
	private String verifyCode;
	private String phone;
	private String pwd;

	private String editType;



	public String view() throws Exception {
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			List<TreeNode> systreeNodeList = this.sysrightService
					.getSysrightTreeByUserId(sessionInfo.getStaffId());
			if (this.id != null) {
				this.staff = this.staffService.findStaffById(this.id);
				List<TreeNode> assginTreeNode = this.sysrightService
						.getSysrightTreeNodeList(this.id);
				this.funcTreeStr = this.sysrightService.getFunctionTreeStr(
						systreeNodeList, assginTreeNode);
				this.editType = "edit";
			} else {
				this.staff = new Staff();
				this.staff.setStatus("1");
				this.funcTreeStr = this.sysrightService.getFunctionTreeStr(
						systreeNodeList, null);
				this.editType = "new";
			}
			Map<String, Object> conditionMap = new HashMap<String, Object>();
			StringBuilder sb = new StringBuilder();
			List<Sysright> sysrightList = this.sysrightService
					.findSysrightListByStaffId(sessionInfo.getStaffId());
			for (Sysright node : sysrightList) {
				sb.append(node.getRightCode()).append("','");
			}
			if (sb.length() > 0) {
				sb.delete(sb.length() - 2, sb.length());
			}
			this.firstLevelFun = "'" + sb.toString();
			markets = this.marketService.findValidMarketList();
			return "staff-view";
		} catch (Exception e) {
			throw e;
		}
	}

	public String toDelete() { return "toDelete"; }

	public String account() {
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		if (sessionInfo.getMarketId() != null) {
			this.market = marketService.findMarketById(sessionInfo.getMarketId());
		}
		return "account";
	}

	public String changePhone1() { return "changePhone1"; }
	public String changePhone2() { return "changePhone2"; }
	public String changePhone3() { return "changePhone3"; }
	public void changePhone() {
		Object code = Struts2Utils.getSession().getAttribute("staff_account_verify_code");
		if (code != null && this.verifyCode != null && code.toString().equals(this.verifyCode)) {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			Staff staff = staffService.findStaffById(sessionInfo.getStaffId());
			staff.setTel(this.phone);
			staff.setLoginName(this.phone);
			staffService.saveStaff(staff);
			// 通过队列通知车来客修改
			dataSync.publishStaffToRuby(staff.getId().toString(), null);
			Result result = new Result(Result.SUCCESS, "", null);
			Struts2Utils.renderJson(result);
		} else {
			Result result = new Result(Result.ERROR, "验证码不匹配", null);
			Struts2Utils.renderJson(result);
		}
	}
	public String changePwd1() { return "changePwd1"; }
	public String changePwd2() { return "changePwd2"; }
	public String changePwd3() { return "changePwd3"; }
	public void changePassword() {
		// 通过队列修改密码
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		dataSync.publishStaffToRuby(sessionInfo.getStaffId().toString(), this.pwd);
		Result result = new Result(Result.SUCCESS, "", null);
		Struts2Utils.renderJson(result);
	}

	public void sendVerifyCode() {
		Random random = new Random();
		String code = String.valueOf(100000 + random.nextInt(899999));
		Struts2Utils.getSession().setAttribute("staff_account_verify_code", code);
		// 通过队列发送验证码短信
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		dataSync.publishSMSToRuby(sessionInfo.getPhone(), code);
		Result result = new Result(Result.SUCCESS, "验证码发送成功!", null);
		Struts2Utils.renderJson(result);
	}
	public void verifyCode() {
		Object code = Struts2Utils.getSession().getAttribute("staff_account_verify_code");
		if (code != null && this.verifyCode != null && code.toString().equals(this.verifyCode)) {
			Result result = new Result(Result.SUCCESS, "验证码匹配", null);
			Struts2Utils.renderJson(result);
		} else {
			Result result = new Result(Result.ERROR, "验证码不匹配", null);
			Struts2Utils.renderJson(result);
		}

	}

	/**
	 * 禁用
	 * 
	 * @throws Exception
	 */
	public void delete() throws Exception {
		try {
			this.staffService.changeStaffStatus(this.id, StatusState.delete
					.getValue());
			Result result = new Result(Result.SUCCESS, "禁用成功!", null);
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			Result result = new Result(Result.ERROR, "禁用失败!", null);
			Struts2Utils.renderJson(result);
			throw e;
		}
	}

	/**
	 * 启用
	 * 
	 * @throws Exception
	 */
	public void valid() throws Exception {
		try {
			this.staffService.changeStaffStatus(this.id, StatusState.normal
					.getValue());
			Result result = new Result(Result.SUCCESS, "启用成功!", null);
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			Result result = new Result(Result.ERROR, "启用失败!", null);
			Struts2Utils.renderJson(result);
			throw e;
		}
	}

	public void save() throws Exception {
		try {
			if(this.staff.getNeedSmsNotice().equals("on")) {
//				YunpianClient clnt = new YunpianClient("eb593149962876a76f84edf967406a4b").init();
//				Map<String, String> param = clnt.newParam(2);
//				param.put(YunpianClient.MOBILE, "15307316345");
//				param.put(YunpianClient.TEXT, "【云片网】您的验证码是1234");
//				com.yunpian.sdk.model.Result<SmsSingleSend> r = clnt.sms().single_send(param);
			}
			this.staffService.saveStaffRight(this.staff, this.functionid);
			Result result = new Result(Result.SUCCESS, "员工操作成功!", null);
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			Result result = new Result(Result.ERROR, "员工操作失败!", null);
			Struts2Utils.renderJson(result);
			throw e;
		}
	}

	public void checkLoginName() throws Exception {
		try {
			Staff staff = this.staffService
					.findValidStaffByLoginName(this.loginName);
			int code = -1;
			if (staff != null) {
				code = 1;
			} else {
				code = 0;
			}
			Struts2Utils.renderJson(code);
		} catch (Exception e) {
			Struts2Utils.renderJson(2);
			throw e;
		}
	}

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public List<Market> getMarkets() { return this.markets; }
	public void setMarkets(List<Market> list) { this.markets = list; }

	public String getFuncTreeStr() {
		return this.funcTreeStr;
	}

	public void setFuncTreeStr(String funcTreeStr) {
		this.funcTreeStr = funcTreeStr;
	}

	public String getFirstLevelFun() {
		return this.firstLevelFun;
	}

	public void setFirstLevelFun(String firstLevelFun) {
		this.firstLevelFun = firstLevelFun;
	}

	public String getFunctionid() {
		return this.functionid;
	}

	public void setFunctionid(String functionid) {
		this.functionid = functionid;
	}

	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}

	public String getLoginName() {
		return this.loginName;
	}

	public List<ComboboxDataBean> getLocateList() {
		return this.locateList;
	}

	public void setLocateList(List<ComboboxDataBean> locateList) {
		this.locateList = locateList;
	}

	public String getLocateId() {
		return this.locateId;
	}

	public void setLocateId(String locateId) {
		this.locateId = locateId;
	}

	public String getEditType() {
		return this.editType;
	}

	public void setEditType(String editType) {
		this.editType = editType;
	}

	public void setMarket(Market market) { this.market = market; }
	public Market getMarket() { return this.market; }

	public void setVerifyCode(String verifyCode) { this.verifyCode = verifyCode; }
	public String getVerifyCode() { return this.verifyCode; }

	public void setPwd(String pwd) { this.pwd = pwd; }
	public String getPwd() { return this.pwd; }

	public void setPhone(String phone) { this.phone = phone; }
	public String getPhone() { return this.phone; }
}