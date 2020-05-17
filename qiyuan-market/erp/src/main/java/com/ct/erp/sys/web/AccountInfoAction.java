package com.ct.erp.sys.web;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.OutputStream;
import java.util.List;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.constants.ReturnCodeConst;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;

import net.sf.json.JSONObject;

@Scope("prototype")
@Controller("sys.accountInfoAction")
public class AccountInfoAction extends SimpleActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6537033380040658601L;
	private static final Logger log = LoggerFactory.getLogger(AccountInfoAction.class);
	@Autowired
	private StaffService staffService;


	private Long regionCode;
	private String corpName;
	private String contactName;
	private String contactTel;
	private String otherDesc;
	private Staff staff;
	// 2014-04-14
	private String adminAccount;
	private String adminPwd;
	// 2014-04-18
	private String checkCode;// 页面上填写的验证码
	private String loginName;// 找回密码页面填写的账号
	private String findType;// 找回方式,0:邮箱,1:手机号
	private String email;// 邮箱
	private String tel;// 手机号

	private String oldPwd;
	private String newPwd;

	public String toRegist() {

		return "toRegist";
	}

	public String doRegist() {
		String result = "";
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			// 2014-04-14
//			this.accountService.applyRegister(this.regionCode, this.corpName,
//					this.contactName, this.contactTel, this.otherDesc,
//					this.adminAccount, this.adminPwd);
			result = ReturnCodeConst.SUCCESS;
		} catch (Exception e) {
			log.error("error in AccountInfoAction.doRegist method", e);
			result = ReturnCodeConst.SYS_ERROR;
			e.printStackTrace();
		}
		UcmsWebUtils.ajaxOutPut(response, result);
		return null;
	}

	public String toChangePwd() {
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			this.staff = this.staffService.findStaffById(sessionInfo
					.getStaffId());

		} catch (Exception e) {
			log.error("error in AccountInfoAction.toChangePwd method", e);
			e.printStackTrace();
		}
		return "toChangePwd";
	}

	/**
	 * 修改密码
	 * @return
	 */
	public String doChangePwd() {
		JSONObject obj = new JSONObject();
		HttpServletResponse response = ServletActionContext.getResponse();
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		Staff staff = this.staffService.findStaffById(sessionInfo.getStaffId());
		if (!staff.getLoginPwd().equals(this.oldPwd)) {
			obj.put("code", 0);
			obj.put("msg", "原密码输入错误");
		} else {
			try {
				this.staffService.doChangePwd(staff, this.newPwd);
				obj.put("code", 1);
				obj.put("msg", "修改密码成功");
			} catch (Exception e) {
				obj.put("code", 2);
				obj.put("msg", "操作异常,请联系管理员");
				log.error("error in AccountInfoAction.doChangePwd method", e);
				e.printStackTrace();
			}
		}
		UcmsWebUtils.ajaxOutPut(response, obj.toString());
		return null;
	}

	/**
	 * 到找回密码对话框
	 * 
	 * @return
	 */
	public String toFindPwd() {

		return "toFindPwd";
	}

	/**
	 * 生成验证码
	 * 
	 * @return
	 */
	public String checkcode() {
		try {
			HttpServletResponse response = ServletActionContext.getResponse();
			response.setContentType("image/jpeg");
			BufferedImage image = new BufferedImage(40, 20,
					BufferedImage.TYPE_INT_RGB);
			Random r = new Random();
			Graphics g = image.getGraphics();
			g.setColor(Color.pink);
			g.fillRect(0, 0, 40, 20);
			g.setColor(new Color(0, 0, 0));
			String checkcode = "";
			String[] codes = new String[] { "A", "B", "C", "D", "E", "F", "G",
					"H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S",
					"T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4",
					"5", "6", "7", "8", "9" };
			for (int i = 0; i < 4; i++) {
				int index = r.nextInt(codes.length);
				checkcode += codes[index];
			}
			HttpSession session = ServletActionContext.getRequest()
					.getSession();
			session.setAttribute("generatedCode", checkcode);
			for (int j = 0; j < 2; j++) {
				g.drawLine(r.nextInt(40), r.nextInt(20), r.nextInt(40), r
						.nextInt(20));
			}
			g.drawString(checkcode, 5, 15);
			// 2014-04-18
			OutputStream os = response.getOutputStream();
			ImageIO.write(image, "jpeg", os);

		} catch (Exception e) {
			log.error("error in accountInfoAction.checkCode method", e);
			e.printStackTrace();

		}

		return null;
	}

	// 2014-04-15
	/**
	 *根据页面输入的账号查找数据库中是否存在
	 * 
	 */
	public String checkAccount() {
		try {
			HttpServletResponse response = ServletActionContext.getResponse();
			String result = "";
			List<Staff> staffs = this.staffService
					.findByLoginName(this.adminAccount);
			if ((staffs != null) && (staffs.size() > 0)) {
				result = "1";
			} else {
				result = "0";
			}
			UcmsWebUtils.ajaxOutPut(response, result);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("error in accountInfoAction.checkAccount method", e);
		}
		return null;
	}

	// 2014-04-18
	/**
	 * 执行找回密码
	 */
	public String doFindPwd() {
		JSONObject obj = new JSONObject();
		HttpServletResponse response = ServletActionContext.getResponse();
		HttpSession session = ServletActionContext.getRequest().getSession();
		try {
			if (!(this.checkCode.equalsIgnoreCase((String) session
					.getAttribute("generatedCode")))) {
				obj.put("code", "1");
				obj.put("msg", "验证码错误,请重新输入");
			} else {
//				obj = this.accountService.doFindPwd(this.loginName,
//						this.findType, this.email, this.tel);
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("error in accountInfoAction.doFindPwd method", e);
			obj.put("code", "1");
			obj.put("msg", "操作异常,请稍后重试");
		}
		UcmsWebUtils.ajaxOutPut(response, obj.toString());
		return null;
	}

//	public StockBean getStockbeBean() {
//		return this.stockbeBean;
//	}

//	public void setStockbeBean(StockBean stockbeBean) {
//		this.stockbeBean = stockbeBean;
//	}

	public Long getRegionCode() {
		return this.regionCode;
	}

	public void setRegionCode(Long regionCode) {
		this.regionCode = regionCode;
	}

	public String getCorpName() {
		return this.corpName;
	}

	public void setCorpName(String corpName) {
		this.corpName = corpName;
	}

	public String getContactName() {
		return this.contactName;
	}

	public void setContactName(String contactName) {
		this.contactName = contactName;
	}

	public String getContactTel() {
		return this.contactTel;
	}

	public void setContactTel(String contactTel) {
		this.contactTel = contactTel;
	}

	public String getOtherDesc() {
		return this.otherDesc;
	}

	public void setOtherDesc(String otherDesc) {
		this.otherDesc = otherDesc;
	}

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public String getOldPwd() {
		return this.oldPwd;
	}

	public void setOldPwd(String oldPwd) {
		this.oldPwd = oldPwd;
	}

	public String getNewPwd() {
		return this.newPwd;
	}

	public void setNewPwd(String newPwd) {
		this.newPwd = newPwd;
	}

	// 2014-04-14
	public String getAdminAccount() {
		return this.adminAccount;
	}

	public void setAdminAccount(String adminAccount) {
		this.adminAccount = adminAccount;
	}

	public String getAdminPwd() {
		return this.adminPwd;
	}

	public void setAdminPwd(String adminPwd) {
		this.adminPwd = adminPwd;
	}

	public String getCheckCode() {
		return this.checkCode;
	}

	public void setCheckCode(String checkCode) {
		this.checkCode = checkCode;
	}

	public String getLoginName() {
		return this.loginName;
	}

	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}

	public String getFindType() {
		return this.findType;
	}

	public void setFindType(String findType) {
		this.findType = findType;
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getTel() {
		return this.tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

}
