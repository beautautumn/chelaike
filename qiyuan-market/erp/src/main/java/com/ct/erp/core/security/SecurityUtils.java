package com.ct.erp.core.security;

import java.util.Date;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ct.erp.common.model.TreeNode;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Sysright;

/**
 * 系统使用的特殊工具类 简化代码编写.
 */
public class SecurityUtils {
	private static final Logger logger = LoggerFactory
			.getLogger(SecurityUtils.class);

	/**
	 * User转SessionInfo.
	 * 
	 * @param user
	 * @return
	 */
	public static SessionInfo userToSessionInfo(Staff user,
			 List<Sysright> sysrightList,
			List<TreeNode> systreeNodeList, String macAddress,String token) {
		SessionInfo sessionInfo = new SessionInfo();
		sessionInfo.setStaffId(user.getId());
		if(user.getMarket()!= null && user.getMarket().getMarketId()!=null) {
            sessionInfo.setMarketId(user.getMarket().getMarketId());
        }
		sessionInfo.setLoginName(user.getLoginName());
		sessionInfo.setPhone(user.getTel());
		sessionInfo.setIp(Struts2Utils.getIp());
		sessionInfo.setUserName(user.getName());
		sessionInfo.setLoginTime(new Date());
		if (StringUtils.isNotEmpty(macAddress)) {
			sessionInfo.setMac(macAddress);
		}
		sessionInfo.setSystreeNodeList(systreeNodeList);
		sessionInfo.setSysrightList(sysrightList);
		sessionInfo.setToken(token);
		sessionInfo.setUserType(user.getUserType());
		return sessionInfo;
	}

	/**
	 * 将用户放入session中.
	 * 
	 * @param user
	 */
	public static void putUserToSession(Staff user, 
			List<Sysright> sysrightList, List<TreeNode> systreeNodeList,
			String macAddress,String token) {
		String sessionId = Struts2Utils.getSession().getId();
		logger.debug("putUserToSession:{}", sessionId);
		SessionInfo sessionInfo = userToSessionInfo(user,
				sysrightList, systreeNodeList, macAddress,token);
		sessionInfo.setId(sessionId);
		Struts2Utils.getSession().setAttribute(
				SecurityConstants.SESSION_SESSIONINFO, sessionInfo);
		SecurityConstants.sessionInfoMap.put(sessionId, sessionInfo);
	}

	/**
	 * 获取当前用户session信息.
	 */
	public static SessionInfo getCurrentSessionInfo() {
		return (SessionInfo) Struts2Utils
				.getSessionAttribute(SecurityConstants.SESSION_SESSIONINFO);
	}

	public static void removeUserFromSession(String sessionId) {
		if (StringUtils.isNotBlank(sessionId)) {
			Set<String> keySet = SecurityConstants.sessionInfoMap.keySet();
			for (String key : keySet) {
				if (key.equals(sessionId)) {
					logger.debug("removeUserFromSession:{}", sessionId);
					SecurityConstants.sessionInfoMap.remove(key);
				}
			}
		}
	}

	// public static Datagrid<SessionInfo> getSessionUser(){
	// List<SessionInfo> list = Lists.newArrayList();
	// Set<String> keySet = SecurityConstants.sessionInfoMap.keySet();
	// for(String key:keySet){
	// SessionInfo sessionInfo = SecurityConstants.sessionInfoMap.get(key);
	// list.add(sessionInfo);
	// }
	// //排序
	// Collections.sort(list, new Comparator<SessionInfo>() {
	// @Override
	// public int compare(SessionInfo o1, SessionInfo o2) {
	// return o2.getLoginTime().compareTo(o1.getLoginTime());
	// }
	// });
	//			 
	// Datagrid<SessionInfo> dg = new
	// Datagrid<SessionInfo>(SecurityConstants.sessionInfoMap.size(), list);
	// return dg;
	// }
}
