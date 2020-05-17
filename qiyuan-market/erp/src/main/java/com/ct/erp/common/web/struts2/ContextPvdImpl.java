package com.ct.erp.common.web.struts2;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

public class ContextPvdImpl implements ContextPvd {
	public String getAppRealPath(String path) {
		return ServletActionContext.getServletContext().getRealPath(path);
	}

	public String getAppRoot() {
		return getAppRealPath("/");
	}

	public String getAppCxtPath() {
		return ServletActionContext.getRequest().getContextPath();
	}

	public int getServerPort() {
		return ServletActionContext.getRequest().getServerPort();
	}

	public void logout() {
		HttpSession session = ServletActionContext.getRequest().getSession(
				false);
		if (session != null) {
			session.invalidate();
		}
	}

	public HttpServletResponse getResponse() {
		return ServletActionContext.getResponse();
	}

	public Object getRequestAttr(String key) {
		return ServletActionContext.getRequest().getAttribute(key);
	}

	public void setRequestAttr(String key, Object value) {
		ServletActionContext.getRequest().setAttribute(key, value);
	}

	public Object getSessionAttr(String key) {
		HttpSession session = ServletActionContext.getRequest().getSession(
				false);
		if (session == null) {
			return null;
		} else {
			return session.getAttribute(key);
		}
	}

	public void setSessionAttr(String key, Object value) {
		HttpSession session = ServletActionContext.getRequest().getSession();
		session.setAttribute(key, value);
	}

	public void removeAttribute(String key) {
		HttpSession session = ServletActionContext.getRequest().getSession();
		session.removeAttribute(key);
	}

	public Object getApplicationAttr(String key) {
		return ServletActionContext.getServletContext().getAttribute(key);
	}

	public void setApplicationAttr(String key, Object value) {
		ServletActionContext.getServletContext().setAttribute(key, value);
	}

	public String getSessionId(boolean isCreate) {
		HttpSession session = ServletActionContext.getRequest().getSession(
				isCreate);
		if (session == null) {
			return null;
		} else {
			return session.getId();
		}
	}

	public String getRemoteIp() {
		return ServletActionContext.getRequest().getRemoteAddr();
	}

	public int getRemotePort() {
		return ServletActionContext.getRequest().getRemotePort();
	}

	public String getRequestURL() {
		return ServletActionContext.getRequest().getRequestURL().toString();
	}

	public String getRequestBrowser() {
		String userAgent = getRequestUserAgent();
		String[] agents = userAgent.split(";");
		if (agents.length > 1) {
			return agents[1].trim();
		} else {
			return null;
		}
	}

	public String getRequestOs() {
		String userAgent = getRequestUserAgent();
		String[] agents = userAgent.split(";");
		if (agents.length > 2) {
			return agents[2].trim();
		} else {
			return null;
		}
	}

	public String getRequestUserAgent() {
		HttpServletRequest req = ServletActionContext.getRequest();
		String userAgent = req.getHeader("user-agent");
		return userAgent;
	}

	public void addCookie(Cookie cookie) {
		ServletActionContext.getResponse().addCookie(cookie);
	}

	public Cookie getCookie(String name) {
		Cookie[] cookies = ServletActionContext.getRequest().getCookies();
		if (cookies != null) {
			for (Cookie c : cookies) {
				if (c.getName().equals(name)) {
					return c;
				}
			}
		}
		return null;
	}

	public boolean isMethodPost() {
		String method = ServletActionContext.getRequest().getMethod();
		if ("post".equalsIgnoreCase(method)) {
			return true;
		} else {
			return false;
		}
	}

	public HttpServletRequest getRequest() {
		// TODO Auto-generated method stub
		return ServletActionContext.getRequest();
	}
}
