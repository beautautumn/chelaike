package com.ct.erp.core.security;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.builder.ToStringBuilder;

import com.ct.erp.common.model.TreeNode;
import com.ct.erp.lib.entity.Sysright;

@SuppressWarnings("serial")
public class SessionInfo implements java.io.Serializable {

	private static final long serialVersionUID = 3186066260135128981L;
	/**
	 * sessionID
	 */
	private String id;
	/**
	 * 用户ID
	 */
	private Long staffId;
	/**
	 * 登录名
	 */
	private String loginName;

	private String phone;

	private String userName;

	private String mac;
	/**
	 * 用户类型
	 */
	private String userType;
	
	
	private String token;
	/**
	 * 客户端IP
	 */
	private String ip;

	private List<String> rightCodeList;

	private String corpNames;


	private List<Sysright> sysrightList;

	private List<TreeNode> systreeNodeList;

	private TreeNode firstMenuTreeNode;

	/**
	 * 登录时间
	 */
	private Date loginTime = new Date();
	private Long marketId;
	private String roleName;

	public SessionInfo() {
	}

	/**
	 * sessionID
	 */
	public String getId() {
		return this.id;
	}

	/**
	 * 设置 sessionID
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * 登录名
	 */
	public String getLoginName() {
		return this.loginName;
	}

	/**
	 * 设置 登录名
	 */
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}

	/**
	 * 用户类型
	 */
	public String getUserType() {
		return this.userType;
	}

	/**
	 * 设置 用户类型
	 */
	public void setUserType(String userType) {
		this.userType = userType;
	}

	/**
	 * 客户端IP
	 */
	public String getIp() {
		return this.ip;
	}

	/**
	 * 设置 客户端IP
	 */
	public void setIp(String ip) {
		this.ip = ip;
	}

	/**
	 * 登录时间
	 */
	public Date getLoginTime() {
		return this.loginTime;
	}

	/**
	 * 设置登录时间
	 */
	public void setLoginTime(Date loginTime) {
		this.loginTime = loginTime;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}

	public String getCorpNames() {
		return this.corpNames;
	}

	public void setCorpNames(String corpNames) {
		this.corpNames = corpNames;
	}


	public Long getStaffId() {
		return this.staffId;
	}

	public void setStaffId(Long staffId) {
		this.staffId = staffId;
	}

	public List<String> getRightCodeList() {
		return this.rightCodeList;
	}

	public void setRightCodeList(List<String> rightCodeList) {
		this.rightCodeList = rightCodeList;
	}

	public List<Sysright> getSysrightList() {
		return this.sysrightList;
	}

	public void setSysrightList(List<Sysright> sysrightList) {
		this.sysrightList = sysrightList;
	}

	public List<TreeNode> getSystreeNodeList() {
		return this.systreeNodeList;
	}

	public void setSystreeNodeList(List<TreeNode> systreeNodeList) {
		this.systreeNodeList = systreeNodeList;
	}

	public TreeNode getFirstMenuTreeNode() {
		if ((getSystreeNodeList() != null)
				&& (getSystreeNodeList().size() > 0)) {
			this.firstMenuTreeNode = getSystreeNodeList().get(0);
		}
		return this.firstMenuTreeNode;
	}

	public void setFirstMenuTreeNode(TreeNode firstMenuTreeNode) {
		this.firstMenuTreeNode = firstMenuTreeNode;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getMac() {
		return this.mac;
	}

	public void setMac(String mac) {
		this.mac = mac;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public Long getMarketId() {
		return marketId;
	}

	public void setMarketId(Long marketId) {
		this.marketId = marketId;
	}

	public String getPhone() { return phone; }
	public void setPhone(String phone) { this.phone = phone; }

	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
}
