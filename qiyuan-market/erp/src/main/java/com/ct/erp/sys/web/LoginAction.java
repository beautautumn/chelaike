package com.ct.erp.sys.web;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.net.URLEncoder;


import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.ct.erp.constants.sysconst.Const;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.Validate;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.model.Result;
import com.ct.erp.common.model.TreeNode;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.lib.entity.TodoLog;
import com.ct.erp.sys.service.TodoLogService;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.sys.service.base.SysrightService;
import com.google.common.collect.Lists;
import com.tianche.domain.UserSession;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("erp.loginAction")
public class LoginAction extends SimpleActionSupport {

	private static final long serialVersionUID = -6646954355524098167L;
	private String loginName; // 登录用户名
	private String password; // 登录密码
	private String msg; // 提示信息
	private String theme; // 主题
	private String menuId;
	private String menuText = "";
	private String mac;
	private List<TodoLog> todoLogs;
	private final int pageSize = 10;
	private final int pageNo = 1;

	private String crmUrl;
	private String crmToken;

	/**
	 * 操作员管理Service
	 */
	@Autowired
	private StaffService staffService;

	@Autowired
	SysrightService sysrightService;
	
	@Autowired
	private TodoLogService todoLogService;
	
	@Autowired
	private RedisTemplate<String, UserSession> redisTemplate;

	public String list() throws Exception {
		return SUCCESS;
	}

	/**
	 * 用户登录验证
	 * 
	 * @throws Exception
	 */
	public String login() throws Exception {
		Result result = null;
		try {
			// 如果校验不通过将会抛出异常 异常会被异常拦截器ExceptionInterceptor拦截并返回客户端
			// 客户端解析返回的数据即可做相应的提示
			Validate.notBlank(this.loginName, "用户名不能为空!");
			Validate.notBlank(this.password, "密码不能为空!");

			if (StringUtils.isEmpty(this.loginName)
					|| StringUtils.isEmpty(this.password)) {
				this.msg = "用户名或密码不能为空!";
				result = new Result(Result.ERROR, this.msg, null);
				Struts2Utils.renderText(result);
				return null;
			}

			// 获取用户信息
			Staff user = this.staffService.findValidStaffByNP(this.loginName,
					this.password);

			if (user == null) {
				this.msg = "用户名或密码不正确!";
			}
			if (this.msg != null) {
				result = new Result(Result.ERROR, this.msg, null);
				Struts2Utils.renderText(result);
				return null;
			}

			List<Sysright> sysrightList = this.staffService
					.findStaffRightByStaffId(user.getId());
			List<TreeNode> systreeNodeList = this.sysrightService
					.getSysmenuTreeByUserId(user.getId());
			if ((sysrightList == null) || (systreeNodeList == null)) {
				this.msg = "该用户没有访问权限,请联系管理员!";
				result = new Result(Result.ERROR, this.msg, null);
				Struts2Utils.renderText(result);
				return null;
			}
			// 将用户信息放入session中
			/*SecurityUtils.putUserToSession(user, sysrightList,
					systreeNodeList, this.mac);*/
			// 2014-04-14
			// 将用户名密码放入cookie中
			Cookie c1 = new Cookie("loginName", this.loginName);
			Cookie c2 = new Cookie("password", this.password);
			c1.setPath("/");
			c2.setPath("/");
			c1.setMaxAge(24 * 3600 * 30);
			c2.setMaxAge(24 * 3600 * 30);
			HttpServletResponse response = Struts2Utils.getResponse();
			response.addCookie(c1);
			response.addCookie(c2);
			this.logger.info("用户{}登录系统,IP:{}.", user.getLoginName(),
					Struts2Utils.getIp());

			// 设置调整URL 如果session中包含未被授权的URL 则跳转到该页面
			String resultUrl = Struts2Utils.getRequest().getContextPath()
					+ "/login!index.action";
			result = new Result(Result.SUCCESS, "用户验证通过!", resultUrl);
			Struts2Utils.renderText(result);
		} catch (Exception e) {
			throw e;
		}
		return null;
	}


	private String macConvert(String input) {
		char c[] = input.toCharArray();
		for (int i = 0; i < c.length; i++) {
			if ((c[i] == ':') || (c[i] == '-')) {
				c[i] = '$';
			}
		}
		return new String(c);
	}

	/**
	 * 导航菜单.
	 */
	public void navTree() throws Exception {
		List<TreeNode> treeNodes = Lists.newArrayList();
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			if (sessionInfo != null) {
				treeNodes.add(sessionInfo.getFirstMenuTreeNode());
			}
			Struts2Utils.renderJson(treeNodes);
		} catch (Exception e) {
			throw e;
		}
	}

	public void navTreeListByMenu() throws Exception {
		List<TreeNode> treeNodes = Lists.newArrayList();
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			if (sessionInfo != null) {
				for (TreeNode node : sessionInfo.getSystreeNodeList()) {
					if (node.getId().equals(this.menuId)) {
						treeNodes.add(node);
						break;
					}
				}
			}
			Struts2Utils.renderJson(treeNodes);
		} catch (Exception e) {
			throw e;
		}
	}

	public void navTreeByMenu() throws Exception {
		TreeNode result = null;
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			if (sessionInfo != null) {
				for (TreeNode node : sessionInfo.getSystreeNodeList()) {
					if (node.getId().equals(this.menuId)) {
						result = node;
						break;
					}
				}
			}
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			throw e;
		}
	}

	/**
	 * 根据URL地址获取请求地址前面部分信息
	 * 
	 * @param url
	 * @return
	 */
	private String getHeadFromUrl(String url) {
		int firSplit = url.indexOf("//");
		String proto = url.substring(0, firSplit + 2);
		int webSplit = url.indexOf("/", firSplit + 2);
		int portIndex = url.indexOf(":", firSplit);
		String webUrl = url.substring(firSplit + 2, webSplit);
		String port = "";
		if (portIndex >= 0) {
			webUrl = webUrl.substring(0, webUrl.indexOf(":"));
			port = url.substring(portIndex + 1, webSplit);
		} else {
			port = "80";
		}
		return proto + webUrl + ":" + port;
	}

	/**
	 * 注销登录
	 */
	public String logout() {
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			this.mac = sessionInfo.getMac();
			// 退出时清空session中的内容
			String sessionId = Struts2Utils.getSession().getId();
			// 由监听器更新在线用户列表
			SecurityUtils.removeUserFromSession(sessionId);
            Struts2Utils.getSession().invalidate();
			redisTemplate.delete("token:"+sessionInfo.getToken());
            HttpServletResponse response = ServletActionContext.getResponse();
            HttpServletRequest request = Struts2Utils.getRequest();
            Cookie[] cookies = request.getCookies();
            String token = null;
            String u = null;
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    Cookie c = new Cookie(cookie.getName(), "");
                    c.setMaxAge(0);
                    c.setPath("/");
                    response.addCookie(c);
                }
            }
			this.logger.info("用户{}退出系统.", sessionInfo.getLoginName());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
	/**
	 * 注销登录启辕
	 */
	public String logout7y() {
		String suffix = "7y";
		logoutAct("sso/"+suffix);
		return "success"+suffix;
	}
	/**
	 * 注销登录
	 */
	public String logoutMarket() {
		String suffix = "Market";
		logoutAct("sso/market");
		return "success"+suffix;
	}

	private void logoutAct(String suffix) {
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			this.mac = sessionInfo.getMac();
			// 退出时清空session中的内容
			String sessionId = Struts2Utils.getSession().getId();
			// 由监听器更新在线用户列表
			SecurityUtils.removeUserFromSession(sessionId);
			Struts2Utils.getSession().invalidate();
			redisTemplate.delete("token:"+sessionInfo.getToken());
			HttpServletResponse response = ServletActionContext.getResponse();
			HttpServletRequest request = Struts2Utils.getRequest();
			Cookie[] cookies = request.getCookies();
			String token = null;
			String u = null;
			if (cookies != null) {
				for (Cookie cookie : cookies) {
					Cookie c = new Cookie(cookie.getName(), "");
					c.setMaxAge(0);
					c.setPath("/"+suffix);
					response.addCookie(c);
				}
			}
			this.logger.info("用户{}退出系统.", sessionInfo.getLoginName());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 后台管理主界面
	 * 
	 * @return
	 * @throws Exception
	 */
	public String index() throws Exception {
		// 根据客户端指定的参数跳转至 不同的主题 如果未指定 默认:index
		if (StringUtils.isNotBlank(this.theme)
				&& (this.theme.equals("app") || this.theme.equals("index"))) {
			return this.theme;
		}
		return "index";
	}

	public String main() throws Exception {
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		Long staffId = sessionInfo.getStaffId();
		ApplicationContext context = new ClassPathXmlApplicationContext(new String[] { "spring-redis.xml" });
		RedisTemplate redis = (RedisTemplate) context.getBean("datesyncRedisTemplate");

		for(int i=0; i < 3; i++) {
			Object token = redis.opsForValue().get("staff_" + staffId);
			if (token == null || token.toString().equals("")) {
				Thread.sleep(100);
			} else {
				crmToken = URLEncoder.encode(token.toString(), java.nio.charset.StandardCharsets.UTF_8.toString());
				break;
			}
		}
		return "main";
	}
	public String mainMarket() throws Exception {
		return "mainMarket";
	}

	public String north() throws Exception {
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		if (sessionInfo != null) {
			for (TreeNode node : sessionInfo.getSystreeNodeList()) {
				if (node.getId().equals(this.menuId)) {
					this.menuText = node.getText();
					break;
				}
			}
		}
		todoLogs = todoLogService.findBystaffIdAndState(sessionInfo.getStaffId(), this.pageNo-1, this.pageSize-1);
		return "north";
	}
	public String northMarket() throws Exception{
		north();
		return "northMarket";
	}

	public List<TodoLog> getTodoLogs() {
		return todoLogs;
	}

	public void setTodoLogs(List<TodoLog> todoLogs) {
		this.todoLogs = todoLogs;
	}

	/**
	 * 防止重复提示错误信息
	 */
	public void prepare() {
		clearErrorsAndMessages();
	}

	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getMsg() {
		return this.msg;
	}

	public String getTheme() {
		return this.theme;
	}

	public void setTheme(String theme) {
		this.theme = theme;
	}

	public String getMenuId() {
		return this.menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public String getMenuText() {
		return this.menuText;
	}

	public void setMenuText(String menuText) {
		this.menuText = menuText;
	}

	public String getMac() {
		return this.mac;
	}

	public void setMac(String mac) {
		this.mac = mac;
	}

	public String getCrmUrl() {
		return crmUrl;
	}

	public void setCrmUrl(String crmUrl) {
		this.crmUrl = crmUrl;
	}

	public String getCrmToken() {
		return crmToken;
	}

	public void setCrmToken(String crmToken) {
		this.crmToken = crmToken;
	}
}
